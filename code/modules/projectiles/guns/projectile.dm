#define HOLD_CASINGS	0 //do not do anything after firing. Manual action, like pump shotguns, or guns that want to define custom behaviour
#define CLEAR_CASINGS	1 //clear chambered so that the next round will be automatically loaded and fired, but don't drop anything on the floor
#define EJECT_CASINGS	2 //drop spent casings on the ground after firing
#define CYCLE_CASINGS	3 //cycle casings, like a revolver. Also works for multibarrelled guns

/obj/item/gun/projectile
	name = "gun"
	desc = "A gun that fires bullets."
	icon_state = "revolver"
	item_state = "handgun"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	w_class = ITEM_SIZE_NORMAL
	matter = list(DEFAULT_WALL_MATERIAL = 1000)
	screen_shake = 0
	combustion = 1
	gun_type = GUN_PISTOL
	var/image/rust_overlay = null //for condition shit
	var/caliber = "357"		//determines which casings will fit
	var/handle_casings = EJECT_CASINGS	//determines how spent casings should be handled
	var/load_method = SINGLE_CASING|SPEEDLOADER //1 = Single shells, 2 = box or quick loader, 3 = magazine
	var/obj/item/ammo_casing/chambered = null

	//For SINGLE_CASING or SPEEDLOADER guns
	var/max_shells = 0			//the number of casings that will fit inside
	var/ammo_type = null		//the type of ammo that the gun comes preloaded with
	var/list/loaded = list()	//stored ammo
	var/starts_loaded = 1		//whether the gun starts loaded or not, can be overridden for guns crafted in-game

	//For MAGAZINE guns
	var/magazine_type = null	//the type of magazine that the gun comes preloaded with
	var/obj/item/ammo_magazine/ammo_magazine = null //stored magazine
	var/allowed_magazines		//magazine types that may be loaded. Can be a list or single path
	var/auto_eject = 0			//if the magazine should automatically eject itself when empty.
	var/auto_eject_sound = null

	var/unload_sound 	= 'sound/weapons/guns/interact/pistol_magout.ogg'
	var/reload_sound 	= 'sound/weapons/guns/interact/pistol_magin.ogg'
	var/cock_sound		= 'sound/weapons/guns/interact/pistol_cock.ogg'
	var/bulletinsert_sound 	= 'sound/weapons/guns/interact/bullet_insert.ogg'
	var/loaded_icon
	var/unwielded_loaded_icon
	var/wielded_loaded_icon
	var/unloaded_icon
	var/unwielded_unloaded_icon
	var/wielded_unloaded_icon
	var/casingsound = 'sound/weapons/guns/misc/casingfall1.ogg'
	var/load_delay = 5
	fire_sound = 'sound/weapons/guns/fire/pistol_fire.ogg'
	far_fire_sound = "far_fire"

/obj/item/gun/projectile/New()
	..()

	if (starts_loaded)
		if(ispath(ammo_type) && (load_method & (SINGLE_CASING|SPEEDLOADER)))
			for(var/i in 1 to max_shells)
				loaded += new ammo_type(src)
		if(ispath(magazine_type) && (load_method & MAGAZINE))
			ammo_magazine = new magazine_type(src)
	update_icon()

/obj/item/gun/projectile/consume_next_projectile()
	if(check_for_jam())
		return null
	if(is_jammed)
		return null
	//get the next casing
	if(loaded.len)
		chambered = loaded[1] //load next casing.
		if(handle_casings != HOLD_CASINGS)
			loaded -= chambered
	else if(ammo_magazine && ammo_magazine.stored_ammo.len)
		chambered = ammo_magazine.stored_ammo[ammo_magazine.stored_ammo.len]
		if(handle_casings != HOLD_CASINGS)
			ammo_magazine.stored_ammo -= chambered


	if (chambered)
		return chambered.BB
	return null

/obj/item/gun/projectile/proc/check_for_jam()
	if(!can_jam)//If the gun can't jam then always return true.
		return FALSE
	if(aspect_chosen(/datum/aspect/clean_guns))
		return FALSE
	if((!is_jammed && prob(GetConditionProb())) || aspect_chosen(/datum/aspect/no_guns) || aspect_chosen(/datum/aspect/trenchmas))
		playsound(src.loc, 'sound/effects/jam.ogg', 50, 1)
		src.visible_message("<span class='danger'>\The [src] jams!</span>")
		is_jammed = 1
		update_icon()
		return TRUE


/obj/item/gun/projectile/handle_post_fire()
	..()
	if(chambered)
		chambered.expend()
		process_chambered()

/obj/item/gun/projectile/update_icon()
	. = ..()
	overlays.Remove(rust_overlay)
	var/icon/I = new/icon(icon, icon_state)
	I.Blend(new /icon('icons/obj/gun.dmi',rgb(255,255,255)), ICON_MULTIPLY)
	I.Blend(new /icon('icons/obj/gun.dmi', icon_state = "[get_condition_icon()]"), ICON_ADD)
	rust_overlay = image(I)
	rust_overlay.color = "#773d28"
	overlays += rust_overlay

	if(ammo_magazine)
		set_loaded_icons()
	else
		set_unloaded_icons()


/obj/item/gun/projectile/proc/set_loaded_icons()
	if(loaded_icon)
		icon_state = loaded_icon
		if(!ammo_magazine.stored_ammo.len)
			icon_state = "[loaded_icon]-0"//Mag is loaded, but out of ammo.
		var/mob/living/M = loc
		if(istype(M))
			if(wielded)
				item_state_slots[slot_l_hand_str] = wielded_loaded_icon
				item_state_slots[slot_r_hand_str] = wielded_loaded_icon
			else
				item_state_slots[slot_l_hand_str] = unwielded_loaded_icon
				item_state_slots[slot_r_hand_str] = unwielded_loaded_icon

			item_state_slots[slot_back_str] = loaded_icon
			item_state_slots[slot_s_store_str] = loaded_icon

			M.update_inv_back()
			M.update_inv_l_hand()
			M.update_inv_r_hand()
			M.update_inv_s_store()
	else
		set_generic_icons()


/obj/item/gun/projectile/proc/set_unloaded_icons()
	if(unloaded_icon)
		icon_state = unloaded_icon
		var/mob/living/M = loc
		if(istype(M))
			if(wielded)
				item_state_slots[slot_l_hand_str] = wielded_unloaded_icon
				item_state_slots[slot_r_hand_str] = wielded_unloaded_icon
			else
				item_state_slots[slot_l_hand_str] = unwielded_unloaded_icon
				item_state_slots[slot_r_hand_str] = unwielded_unloaded_icon

			item_state_slots[slot_back_str] = unloaded_icon
			item_state_slots[slot_s_store_str] = unloaded_icon
			M.update_inv_back()
			M.update_inv_l_hand()
			M.update_inv_r_hand()
			M.update_inv_s_store()
	else
		set_generic_icons()


/obj/item/gun/projectile/proc/set_generic_icons()
	icon_state = initial(icon_state)//Default to the defaults
	var/mob/living/M = loc
	if(istype(M))
		if(wielded)
			item_state_slots[slot_l_hand_str] = wielded_item_state
			item_state_slots[slot_r_hand_str] = wielded_item_state
		else
			item_state_slots[slot_l_hand_str] = initial(item_state)
			item_state_slots[slot_r_hand_str] = initial(item_state)

		item_state_slots[slot_back_str] = initial(item_state)

		M.update_inv_back()
		M.update_inv_l_hand()
		M.update_inv_r_hand()
		M.update_inv_s_store()


/obj/item/gun/projectile/proc/get_condition_icon()
	switch(condition)
		if(1 to 30)
			return "condition_8"
		if(31 to 40)
			return "condition_7"
		if(41 to 50)
			return "condition_6"
		if(51 to 60)
			return "condition_5"
		if(61 to 70)
			return "condition_4"
		if(71 to 80)
			return "condition_3"
		if(81 to 90)
			return "condition_2"
		if(91 to INFINITY)
			return "condition_1"

/obj/item/gun/projectile/handle_click_empty()
	..()
	process_chambered()

/obj/item/gun/projectile/proc/CheckCondition()
	switch(condition)
		if(0)
			return "Broken"
		if(1 to 10)
			return "Terrible"
		if(11 to 20)
			return "Poor"
		if(21 to 30)
			return "Shoddy"
		if(31 to 40)
			return "Fair"
		if(41 to 50)
			return "Average"
		if(51 to 60)
			return "Good"
		if(61 to 70)
			return "Great"
		if(71 to 80)
			return "Excellent"
		if(81 to 90)
			return "Superb"
		if(91 to INFINITY)
			return "Perfect"

/obj/item/gun/projectile/proc/GetConditionProb()
	var/mob/M = get_mob_by_key(src.fingerprintslast)
	if(M.is_hellbanned())
		return rand(25,40)
	switch(condition)
		if(0)
			return 100
		if(1 to 10)
			return rand(20,40)
		if(11 to 20)
			return rand(8,30)
		if(21 to 30)
			return rand(4,25)
		if(31 to 40)
			return rand(2,20)
		if(41 to 50)
			return rand(1,15)
		if(51 to 60)
			return rand(0,10)
		if(61 to 70)
			return rand(0,7)
		if(71 to 80)
			return rand(0,5)
		if(81 to 90)
			return rand(0,3)
		if(91 to 100)
			return rand(0,2)
		if(100 to INFINITY)
			return 0


/obj/item/gun/projectile/can_shoot()
	if(is_jammed) //If it's jammed always melee attack.
		return FALSE

	if(magazine_type && ammo_magazine.stored_ammo.len) //If uses a magazine then check for that instead.
		return TRUE

	if(chambered && chambered.BB) //If we have something in the chamber and we're not jammed then shoot it isntead of doing a melee attack.
		return TRUE

	if(!magazine_type && handle_casings == CYCLE_CASINGS) //Edge case for revolvers. Fuck revolvers.
		return TRUE

	return FALSE

/obj/item/gun/projectile/proc/process_chambered()
	if (!chambered) return

	switch(handle_casings)
		if(EJECT_CASINGS) //eject casing onto ground.
			chambered.loc = get_turf(src)
			if(casingsound)
				playsound(get_turf(src), casingsound, 100, 1)
		if(CYCLE_CASINGS) //cycle the casing back to the end.
			if(ammo_magazine)
				ammo_magazine.stored_ammo += chambered
			else
				loaded += chambered

	if(handle_casings != HOLD_CASINGS)
		chambered = null


//Attempts to load A into src, depending on the type of thing being loaded and the load_method
//Maybe this should be broken up into separate procs for each load method?
/obj/item/gun/projectile/load_ammo(var/obj/item/A, mob/user)
	if(istype(A, /obj/item/ammo_magazine))
		var/obj/item/ammo_magazine/AM = A
		if(!(load_method & AM.mag_type) || caliber != AM.caliber)
			return //incompatible

		switch(AM.mag_type)
			if(MAGAZINE)
				if((ispath(allowed_magazines) && !istype(A, allowed_magazines)) || (islist(allowed_magazines) && !is_type_in_list(A, allowed_magazines)))
					to_chat(user, "<span class='warning'>\The [A] won't fit into [src].</span>")
					return
				if(ammo_magazine)
					to_chat(user, "<span class='warning'>[src] already has a magazine loaded.</span>")//already a magazine here
					return
				if(load_delay)
					if(!do_after(user, load_delay, src))
						return
				user.remove_from_mob(AM)
				AM.loc = src
				ammo_magazine = AM
				user.visible_message("[user] inserts [AM] into [src].", "<span class='notice'>You insert [AM] into [src].</span>")
				if(reload_sound)
					playsound(src.loc, reload_sound, 75, 1)
				if(cock_sound && AM.stored_ammo.len)
					spawn(4)
						playsound(src, cock_sound, 100, 1)
			if(SPEEDLOADER)
				if(loaded.len >= max_shells)
					to_chat(user, "<span class='warning'>[src] is full!</span>")
					return
				var/count = 0
				for(var/obj/item/ammo_casing/C in AM.stored_ammo)
					if(loaded.len >= max_shells)
						break
					if(C.caliber == caliber)
						C.loc = src
						loaded += C
						AM.stored_ammo -= C //should probably go inside an ammo_magazine proc, but I guess less proc calls this way...
						count++
				if(count)
					user.visible_message("[user] reloads [src].", "<span class='notice'>You load [count] round\s into [src].</span>")
					if(reload_sound)
						playsound(src.loc, reload_sound, 75, 1)

			if(SINGLE_LOAD)
				if(loaded.len >= max_shells)
					to_chat(user, "<span class='warning'>[src] is full!</span>")
					return
				var/obj/item/ammo_casing/C = AM.stored_ammo[1]
				if(C)
					C.loc = src
					loaded.Insert(1, C) //add to the head of the list
					AM.stored_ammo.Cut(1, 2)
					if(bulletinsert_sound)
						playsound(src.loc, bulletinsert_sound, 75, 1)
					user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)//So we can't speed click these.


		AM.update_icon()
	else if(istype(A, /obj/item/ammo_casing))
		var/obj/item/ammo_casing/C = A
		if(!(load_method & SINGLE_CASING) || caliber != C.caliber)
			return //incompatible
		if(loaded.len >= max_shells)
			to_chat(user, "<span class='warning'>[src] is full.</span>")
			return

		user.remove_from_mob(C)
		C.loc = src
		loaded.Insert(1, C) //add to the head of the list
		user.visible_message("[user] inserts \a [C] into [src].", "<span class='notice'>You insert \a [C] into [src].</span>")
		if(bulletinsert_sound)
			playsound(src.loc, bulletinsert_sound, 75, 1)

	update_icon()

//attempts to unload src. If allow_dump is set to 0, the speedloader unloading method will be disabled
/obj/item/gun/projectile/unload_ammo(mob/user, allow_dump = TRUE, quickunload = FALSE)
	if(ammo_magazine)
		user.put_in_hands(ammo_magazine)
		if(quickunload)//If we're quick unloading it, immediately drop the ammo.
			user.drop_from_inventory(ammo_magazine)
		user.visible_message("[user] removes [ammo_magazine] from [src].", "<span class='notice'>You remove [ammo_magazine] from [src].</span>")
		if(unload_sound)
			playsound(src.loc, unload_sound, 75, 1)
		ammo_magazine.update_icon()
		ammo_magazine = null
	else if(loaded.len)
	//presumably, if it can be speed-loaded, it can be speed-unloaded.
		if(allow_dump && (load_method & SPEEDLOADER))
			var/count = 0
			var/turf/T = get_turf(user)
			if(T)
				for(var/obj/item/ammo_casing/C in loaded)
					C.loc = T
					count++
				loaded.Cut()
			if(count)
				if(unload_sound)
					playsound(src.loc, unload_sound, 75, 1)
				user.visible_message("[user] unloads [src].", "<span class='notice'>You unload [count] round\s from [src].</span>")
				if(casingsound)
					playsound(src.loc, casingsound, 75, 1)
		else if(load_method & SINGLE_CASING)
			var/obj/item/ammo_casing/C = loaded[loaded.len]
			loaded.len--
			user.put_in_hands(C)
			user.visible_message("[user] removes \a [C] from [src].", "<span class='notice'>You remove \a [C] from [src].</span>")
			if(bulletinsert_sound)
				playsound(src.loc, bulletinsert_sound, 75, 1)
	else
		to_chat(user, "<span class='warning'>[src] is empty.</span>")
	update_icon()

/obj/item/gun/projectile/attackby(var/obj/item/A as obj, mob/user as mob)
	load_ammo(A, user)

/obj/item/gun/projectile/attack_self(mob/user as mob)
	if(firemodes.len > 1)
		..()

/obj/item/gun/projectile/MouseDrop(var/obj/over_object)
	if (!over_object || !(ishuman(usr) || issmall(usr)))
		return

	if (!(src.loc == usr))
		return
	var/mob/living/carbon/human/H = usr
	if(H.incapacitated(INCAPACITATION_STUNNED|INCAPACITATION_KNOCKOUT))
		return

	if(over_object.name == "r_hand" || over_object.name == "l_hand")
		unload_ammo(usr, allow_dump = FALSE)

	else
		unload_ammo(usr, allow_dump = FALSE, quickunload = TRUE)


/obj/item/gun/projectile/afterattack(atom/A, mob/living/user)
	..()
	if(auto_eject && ammo_magazine && ammo_magazine.stored_ammo && !ammo_magazine.stored_ammo.len)
		ammo_magazine.loc = get_turf(src.loc)
		user.visible_message(
			"[ammo_magazine] falls out and clatters on the floor!",
			"<span class='notice'>[ammo_magazine] falls out and clatters on the floor!</span>"
			)
		if(auto_eject_sound)
			playsound(user, auto_eject_sound, 40, 1)
		ammo_magazine.update_icon()
		ammo_magazine = null
		update_icon() //make sure to do this after unsetting ammo_magazine

/obj/item/gun/projectile/examine(mob/user)
	. = ..(user)
	if(is_jammed)
		to_chat(user, "<span class='warning'>It looks jammed.</span>")
	if(ammo_magazine)
		to_chat(user, "It has \a [ammo_magazine] loaded.")
	to_chat(user, "<b>CONDITION: [CheckCondition()]</b>")
	to_chat(user, "[inexactAmmo()]")


	return

/obj/item/gun/projectile/proc/getAmmo()
	var/bullets = 0
	if(loaded)
		bullets += loaded.len
	if(ammo_magazine && ammo_magazine.stored_ammo)
		bullets += ammo_magazine.stored_ammo.len
	if(chambered)
		bullets += 1
	return bullets

/obj/item/gun/projectile/proc/inexactAmmo()
	var/ammo = getAmmo()
	var/message

	var/mob/living/M = loc
	if(istype(M))
		if(M.l_hand == src || M.r_hand == src)//Gotta be holding it or this won't work.
			if(ammo_magazine && ammo_magazine.stored_ammo)
				if(ammo == ammo_magazine.max_ammo)
					message = "It feels full."
				else if(ammo > round(ammo_magazine.max_ammo/2) && ammo < ammo_magazine.max_ammo)
					message = "Feels like over half left."
				else if(ammo == round(ammo_magazine.max_ammo/2))
					message = "Only half left."
				else if(ammo < round(ammo_magazine.max_ammo/2) && ammo > 0)
					message = "Feel like less than half left."
				else if(ammo == 0)
					message = "It feels empty."
			else
				if(ammo == max_shells)
					message = "It feels full."
				else if(ammo >= 6)
					message = "It feels very heavy."
				else if(ammo > 3 && ammo < 6)
					message = "It feels heavy."
				else if(ammo <= 3 && ammo != 0)
					message = "It feels light."
				else if(ammo == 0)
					message = "It feels empty."
	return message

/* Unneeded -- so far.
//in case the weapon has firemodes and can't unload using attack_hand()
/obj/item/gun/projectile/verb/unload_gun()
	set name = "Unload Ammo"
	set category = "Object"
	set src in usr

	if(usr.stat || usr.restrained()) return

	unload_ammo(usr)
*/
