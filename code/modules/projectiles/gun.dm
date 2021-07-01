#define GUN_AUTOMATIC "auto_rifle"
#define GUN_SEMIAUTO "semi_rifle"
#define GUN_SNIPER  "sniper"
#define GUN_SHOTGUN "shotgun"
#define GUN_LMG "lmg"
#define GUN_SMG "smg"
#define GUN_PISTOL "pistol"

/*
	Defines a firing mode for a gun.

	A firemode is created from a list of fire mode settings. Each setting modifies the value of the gun var with the same name.
	If the fire mode value for a setting is null, it will be replaced with the initial value of that gun's variable when the firemode is created.
	Obviously not compatible with variables that take a null value. If a setting is not present, then the corresponding var will not be modified.
*/
/datum/firemode
	var/name = "default"
	var/list/settings = list()

/datum/firemode/New(obj/item/gun/gun, list/properties = null)
	..()
	if(!properties) return

	for(var/propname in properties)
		var/propvalue = properties[propname]

		if(propname == "mode_name")
			name = propvalue
		else if(isnull(propvalue))
			settings[propname] = gun.vars[propname] //better than initial() as it handles list vars like burst_accuracy
		else
			settings[propname] = propvalue

/datum/firemode/proc/apply_to(obj/item/gun/gun)
	for(var/propname in settings)
		gun.vars[propname] = settings[propname]

//Parent gun type. Guns are weapons that can be aimed at mobs and act over a distance
/obj/item/gun
	name = "gun"
	desc = "Its a gun. It's pretty terrible, though."
	icon = 'icons/obj/gun.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/onmob/items/lefthand_guns.dmi',
		slot_r_hand_str = 'icons/mob/onmob/items/righthand_guns.dmi',
		)
	icon_state = "detective"
	item_state = "gun"
	obj_flags =  OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT
	matter = list(DEFAULT_WALL_MATERIAL = 2000)
	w_class = ITEM_SIZE_NORMAL
	throwforce = 5
	throw_speed = 4
	throw_range = 5
	force = 5
	origin_tech = list(TECH_COMBAT = 1)
	attack_verb = list("struck", "hit", "bashed")
	zoomdevicename = "scope"
	grab_sound_is_loud = TRUE
	grab_sound = "gun_pickup"//'sound/items/unholster.ogg'
	equipsound = 'sound/items/equip/gun_equip.ogg'
	drop_sound = 'sound/items/handle/gun_drop.ogg'

	var/burst = 1
	var/fire_delay = 6 	//delay after shooting before the gun can be used again
	var/burst_delay = 2	//delay between shots, if firing in bursts
	var/automatic = 0  //can gun use it, 0 is no, anything above 0 is the delay between clicks in ds
	var/move_delay = 1
	var/fire_sound = null//'sound/weapons/gunshot/gunshot.ogg' //No fire sound by default so we use the bullet's fire sound.
	var/fire_sound_text = "gunshot"
	var/far_fire_sound = null
	var/fire_anim = null
	var/screen_shake = 0 //shouldn't be greater than 2 unless zoomed
	var/silenced = 0
	var/accuracy = 0   //accuracy is measured in tiles. +1 accuracy means that everything is effectively one tile closer for the purpose of miss chance, -1 means the opposite. launchers are not supported, at the moment.
	var/scoped_accuracy = null
	var/list/burst_accuracy = list(0) //allows for different accuracies for each shot in a burst. Applied on top of accuracy
	var/list/dispersion = list(0)
	var/one_hand_penalty
	var/wielded_item_state
	var/combustion	//whether it creates hotspot when fired
	var/is_jammed = FALSE	//Whether this gun is jammed
	var/condition = 100
	var/safety = TRUE	//Whether or not the safety is on.
	var/broken = FALSE //weapon broken or no
	var/jammed_icon
	var/gun_type = "generic"

	var/next_fire_time = 0

	var/sel_mode = 1 //index of the currently selected mode
	var/list/firemodes = list()

	//aiming system stuff
	var/keep_aim = 1 	//1 for keep shooting until aim is lowered
						//0 for one bullet after tarrget moves and aim is lowered
	var/multi_aim = 0 //Used to determine if you can target multiple people.
	var/tmp/list/mob/living/aim_targets //List of who yer targeting.
	var/tmp/mob/living/last_moved_mob //Used to fire faster at more than one person.
	var/tmp/told_cant_shoot = 0 //So that it doesn't spam them with the fact they cannot hit them.
	var/tmp/lock_time = -100
	var/can_jam = TRUE

	//attachment shit
	var/damage_modifier = 0

	var/list/attachable_overlays	= list("muzzle", "rail", "under", "stock", "mag") //List of overlays so we can switch them in an out, instead of using Cut() on overlays.
	var/list/attachable_offset 		= null		//Is a list, see examples of from the other files. Initiated on New() because lists don't initial() properly.
	var/list/attachable_allowed		= null		//Must be the exact path to the attachment present in the list. Empty list for a default.
	var/obj/item/attachable/muzzle 	= null		//Attachable slots. Only one item per slot.
	var/obj/item/attachable/rail 	= null
	var/obj/item/attachable/under 	= null
	var/obj/item/attachable/stock 	= null


/obj/item/gun/New()
	..()
	for(var/i in 1 to firemodes.len)
		firemodes[i] = new /datum/firemode(src, firemodes[i])

	if(isnull(scoped_accuracy))
		scoped_accuracy = accuracy

/obj/item/gun/update_icon()
	if(wielded_item_state)
		var/mob/living/M = loc
		if(istype(M))
			if(wielded)
				item_state_slots[slot_l_hand_str] = wielded_item_state
				item_state_slots[slot_r_hand_str] = wielded_item_state
			else
				item_state_slots[slot_l_hand_str] = initial(item_state)
				item_state_slots[slot_r_hand_str] = initial(item_state)
	if(is_jammed)
		if(jammed_icon)
			icon_state = jammed_icon

//Checks whether a given mob can use the gun
//Any checks that shouldn't result in handle_click_empty() being called if they fail should go here.
//Otherwise, if you want handle_click_empty() to be called, check in consume_next_projectile() and return null there.
/obj/item/gun/proc/special_check(var/mob/user)

	if(!istype(user, /mob/living))
		return 0
	if(!user.IsAdvancedToolUser())
		return 0

	var/mob/living/M = user
	if(HULK in M.mutations)
		to_chat(M, "<span class='danger'>Your fingers are much too large for the trigger guard!</span>")
		return 0
	if((CLUMSY in M.mutations) && prob(40)) //Clumsy handling
		var/obj/P = consume_next_projectile()
		if(P)
			if(process_projectile(P, user, user, pick(BP_L_FOOT, BP_R_FOOT)))
				handle_post_fire(user, user)
				user.visible_message(
					"<span class='danger'>\The [user] shoots \himself in the foot with \the [src]!</span>",
					"<span class='danger'>You shoot yourself in the foot with \the [src]!</span>"
					)
				M.drop_item()
		else
			handle_click_empty(user)
		return 0
	if(safety)
		to_chat(user, "<span class='danger'>The gun's safety is on!</span>")
		handle_click_empty(user)
		return 0

	if(broken)
		to_chat(user, "<span class='danger'>The gun is broken!</span>")
		handle_click_empty(user)
		return 0

	if(is_jammed)
		handle_click_empty(user)
		return 0

	return 1

/obj/item/gun/emp_act(severity)
	for(var/obj/O in contents)
		O.emp_act(severity)

/obj/item/gun/afterattack(atom/A, mob/living/user, adjacent, params)
	if(adjacent) return //A is adjacent, is the user, or is on the user's person

	if(!user.aiming)
		user.aiming = new(user)

	if(user && user.client && user.aiming && user.aiming.active && user.aiming.aiming_at != A)
		PreFire(A,user,params) //They're using the new gun system, locate what they're aiming at.
		return
	else
		Fire(A,user,params) //Otherwise, fire normally.

/obj/item/gun/proc/can_shoot() //This is just an abstract check to stop us from attempting to shoot an empty gun instead of doing a melee attack.
	return TRUE

/obj/item/gun/attack(atom/A, mob/living/user, def_zone)
	if (A == user && user.zone_sel.selecting == BP_MOUTH && !mouthshoot)
		handle_suicide(user)
	else if(user.a_intent == I_HURT && can_shoot()) //point blank shooting
		Fire(A, user, pointblank=1)
	else
		return ..() //Pistolwhippin'

/obj/item/gun/proc/Fire(atom/target, mob/living/user, clickparams, pointblank=0, reflex=0)
	if(!user || !target) return


	if(ticker.current_state == GAME_STATE_FINISHED)
		to_chat(user, "<span class='warning'>The battle is over! There is no need to shoot!</span>")
		return

	if(aspect_chosen(/datum/aspect/trenchmas))
		return

	add_fingerprint(user)

	if(!special_check(user))
		return

	if(world.time < next_fire_time)
		if (world.time % 3) //to prevent spam
			to_chat(user, "<span class='warning'>[src] is not ready to fire again!</span>")
		return

	var/shoot_time = (burst - 1)* burst_delay
	user.setClickCooldown(shoot_time) //no clicking on things while shooting
	user.setMoveCooldown(shoot_time) //no moving while shooting either
	next_fire_time = world.time + shoot_time

	var/held_twohanded = wielded

	//actually attempt to shoot
	var/turf/targloc = get_turf(target) //cache this in case target gets deleted during shooting, e.g. if it was a securitron that got destroyed.
	for(var/i in 1 to burst)
		var/obj/projectile = consume_next_projectile(user)
		if(!projectile)
			handle_click_empty(user)
			break

		process_accuracy(projectile, user, target, i, held_twohanded)

		if(pointblank)
			process_point_blank(projectile, user, target)

		if(process_projectile(projectile, user, target, user.zone_sel.selecting, clickparams))
			handle_post_fire(user, target, pointblank, reflex)
			update_icon()

		if(istype(src, /obj/item/gun/projectile))
			var/obj/item/gun/projectile/P = src
			if(P.can_jam)
				P.condition -= 1

		if(i < burst)
			sleep(burst_delay)

		if(!(target && target.loc))
			target = targloc
			pointblank = 0

	//update timing
	if(!automatic)
		user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
		user.recoil += 0.5 //So you can click pretty quick for a bit before it starts getting innacurate.
	if(automatic)
		user.setClickCooldown(automatic)
		user.recoil += 0.01
	user.setMoveCooldown(move_delay)
	next_fire_time = world.time + fire_delay
	update_icon()

//obtains the next projectile to fire
/obj/item/gun/proc/consume_next_projectile()
	return null

//used by aiming code
/obj/item/gun/proc/can_hit(atom/target as mob, var/mob/living/user as mob)
	if(!special_check(user))
		return 2
	//just assume we can shoot through glass and stuff. No big deal, the player can just choose to not target someone
	//on the other side of a window if it makes a difference. Or if they run behind a window, too bad.
	return check_trajectory(target, user)

//called if there was no projectile to shoot
/obj/item/gun/proc/handle_click_empty(mob/user)
	if(is_jammed)
		if(user)
			user.visible_message("*jam jam*", "<span class='danger'>*jam*</span>")
		else
			src.visible_message("*jam jam*")
		playsound(src.loc, 'sound/effects/jam.ogg', 50, 1)
	else
		if(user)
			user.visible_message("*click click*", "<span class='danger'>*click*</span>")
		else
			src.visible_message("*click click*")
		playsound(src.loc, 'sound/weapons/empty.ogg', 100, 1)

//called after successfully firing
/obj/item/gun/proc/handle_post_fire(mob/user, atom/target, var/pointblank=0, var/reflex=0)
	if(fire_anim)
		flick(fire_anim, src)

	if(!silenced)
		if(reflex)
			user.visible_message(
				"<span class='reflex_shoot'><b>\The [user] fires \the [src][pointblank ? " point blank at \the [target]":""] by reflex!</b></span>",
				"<span class='reflex_shoot'>You fire \the [src] by reflex!</span>",
				"You hear a [fire_sound_text]!"
			)
		/*
		else
			user.visible_message(
				"<span class='danger'>\The [user] fires \the [src][pointblank ? " point blank at \the [target]":""]!</span>",
				"<span class='danger'>You fire \the [src]!</span>",
				"You hear a [fire_sound_text]!"
				)
		*/

	if(one_hand_penalty)
		if(!wielded && (user.my_stats[STAT(dex)].level <= 15))
			switch(one_hand_penalty)
				if(1)
					if(prob(50)) //don't need to tell them every single time
						to_chat(user, "<span class='warning'>Your aim wavers slightly.</span>")
				if(2)
					to_chat(user, "<span class='warning'>Your aim wavers as you fire \the [src] with just one hand.</span>")
				if(3)
					to_chat(user, "<span class='warning'>You have trouble keeping \the [src] on target with just one hand.</span>")
				if(4 to INFINITY)
					to_chat(user, "<span class='warning'>You struggle to keep \the [src] on target with just one hand!</span>")

	if(screen_shake)
		spawn()
			shake_camera(user, screen_shake+1, screen_shake)

	if(combustion)
		var/turf/curloc = get_turf(src)
		curloc.hotspot_expose(700, 5)

	update_icon()


/obj/item/gun/proc/process_point_blank(obj/projectile, mob/user, atom/target)
	var/obj/item/projectile/P = projectile
	if(!istype(P))
		return //default behaviour only applies to true projectiles

	//default point blank multiplier
	var/max_mult = 1.3

	//determine multiplier due to the target being grabbed
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		for(var/obj/item/grab/G in H.grabbed_by)
			if(G.point_blank_mult() > max_mult)
				max_mult = G.point_blank_mult()
	P.damage *= max_mult

/obj/item/gun/proc/process_accuracy(obj/projectile, mob/living/carbon/human/user, atom/target, var/burst, var/held_twohanded)
	var/obj/item/projectile/P = projectile
	if(!istype(P))
		return //default behaviour only applies to true projectiles

	var/acc_mod = burst_accuracy[min(burst, burst_accuracy.len)]
	var/disp_mod = dispersion[min(burst, dispersion.len)]

	if(one_hand_penalty)
		if(!held_twohanded && (user.my_stats[STAT(dex)].level < 16))
			acc_mod -= ceil(one_hand_penalty)
			disp_mod += one_hand_penalty*0.5 //dispersion per point of two-handedness

	//Accuracy modifiers
	P.accuracy = accuracy + acc_mod + dexToAccuracyModifier(user.my_stats[STAT(dex)].level)
	P.dispersion = disp_mod + (user.recoil / 2)//Recoil gets added when you shoot. The faster we shoot our semi-auto gun the less accurate it is.
	if(user.crouching || user.lying)//Blind firing out of the trench.
		if(istype(user.loc, /turf/simulated/floor/trench))
			P.dispersion += 10
			P.accuracy -= 5

	/* AIMING IS NOT A THING ANYMORE, BUT IN CASE IT COMES BACK I'M LEAVING THIS HERE
	//accuracy bonus from aiming
	if (aim_targets && (target in aim_targets))
		//If you aim at someone beforehead, it'll hit more often.
		//Kinda balanced by fact you need like 2 seconds to aim
		//As opposed to no-delay pew pew
		P.accuracy += 2
	*/

	//Dispersion stuff. I'll put it in its own proc soon enough.
	var/mod = rand(5,20)
	var/wrong_gun_class_mod = mod + (mod * 0.5)//A lot.
	switch(gun_type)
		if(GUN_AUTOMATIC)
			if(user.SKILL_LEVEL(auto_rifle) < 6) //Less than over half, make them do a statcheck.
				if(user.statscheck(skills = user.SKILL_LEVEL(auto_rifle) <= FAILURE))
					P.dispersion += wrong_gun_class_mod

		if(GUN_SEMIAUTO)
			if(user.SKILL_LEVEL(semi_rifle) < 6) //Less than over half, make them do a statcheck.
				if(user.statscheck(skills = user.SKILL_LEVEL(semi_rifle) <= FAILURE))
					P.dispersion += wrong_gun_class_mod

		if(GUN_SNIPER)
			if(user.SKILL_LEVEL(sniper) < 6) //Less than over half, make them do a statcheck.
				if(user.statscheck(skills = user.SKILL_LEVEL(sniper) <= FAILURE))
					P.dispersion += wrong_gun_class_mod

		if( GUN_SHOTGUN)
			if(user.SKILL_LEVEL(shotgun) < 6) //Less than over half, make them do a statcheck.
				if(user.statscheck(skills = user.SKILL_LEVEL(shotgun) <= FAILURE))
					P.dispersion += wrong_gun_class_mod

		if(GUN_LMG)
			if(user.SKILL_LEVEL(lmg) < 6) //Less than over half, make them do a statcheck.
				if(user.statscheck(skills = user.SKILL_LEVEL(lmg) <= FAILURE))
					P.dispersion += wrong_gun_class_mod

		if(GUN_SMG)
			if(user.SKILL_LEVEL(smg) < 6) //Less than over half, make them do a statcheck.
				if(user.statscheck(skills = user.SKILL_LEVEL(smg) <= FAILURE))
					P.dispersion += wrong_gun_class_mod

	if(user.chem_effects[CE_PAINKILLER] > 100)
		P.dispersion += 10
		P.accuracy -= 3

	if(user.horror_loop)//They're freaking the fuck out, make it hard to aim.
		P.dispersion += 5
		P.accuracy -= 3

	if(user.combat_mode)
		P.accuracy += 3

	if(!user.combat_mode)
		P.dispersion += mod

	if(user.staminaloss >= (user.staminaexhaust/2))
		P.dispersion += mod

	user.dispersion_mouse_display_number = P.dispersion
	//to_chat(world, "[P.dispersion]") //Debug.
	if(user.dispersion_mouse_display_number > 0 && user.dispersion_mouse_display_number < 2)// else
		user.client.mouse_pointer_icon = 'icons/effects/standard/standard2.dmi'//'icons/misc/aim.dmi'
	else if(user.dispersion_mouse_display_number >= 2 && user.dispersion_mouse_display_number < 4)
		user.client.mouse_pointer_icon = 'icons/effects/standard/standard3.dmi'
	else if(user.dispersion_mouse_display_number >= 4 && user.dispersion_mouse_display_number < 6)
		user.client.mouse_pointer_icon = 'icons/effects/standard/standard4.dmi'
	else if(user.dispersion_mouse_display_number >= 6 && user.dispersion_mouse_display_number < 10)
		user.client.mouse_pointer_icon = 'icons/effects/standard/standard5.dmi'
	else if(user.dispersion_mouse_display_number >= 10)
		user.client.mouse_pointer_icon = 'icons/effects/standard/standard6.dmi'
	else
		user.client.mouse_pointer_icon = 'icons/effects/standard/standard1.dmi'





//does the actual launching of the projectile
/obj/item/gun/proc/process_projectile(obj/projectile, mob/user, atom/target, target_zone, params)
	var/obj/item/projectile/P = projectile
	if(!istype(P))
		return 0 //default behaviour only applies to true projectiles

	var/launched = !P.launch_from_gun(target, target_zone, user, params, null, 0, src)

	if(launched)
		play_fire_sound(user,P)

	return launched

/obj/item/gun/proc/unjam(var/mob/M)
	if(is_jammed)
		M.visible_message("\The [M] begins to unjam [src].", "You begin to clear the jam of [src]")
		if(!do_after(M, 20, src))
			return
		is_jammed = 0
		playsound(src.loc, 'sound/weapons/unjam.ogg', 50, 1)
		update_icon()
		return


/obj/item/gun/proc/play_fire_sound(var/mob/user, var/obj/item/projectile/P)
	var/shot_sound
	if(fire_sound)//Check if the gun has a fire sound first, then if it doesn't use the bullet's fire_sound.
		shot_sound = fire_sound
	else if(P.fire_sound)
		shot_sound = P.fire_sound
	if(silenced)
		playsound(user, shot_sound, 10, 1)
	else//If the mobs are far away, then play the far away shot sound instead.
		playsound(user, shot_sound, 50, 1)
		var/list/mob/mobs = view(world.view, user)
		var/list/mob/far_mobs = (orange(world.view * 3, user) - mobs)
		for(var/mob/living/carbon/human/M in far_mobs)
			M.playsound_local(user, far_fire_sound, rand(1, 10))

//Suicide handling.
/obj/item/gun/var/mouthshoot = 0 //To stop people from suiciding twice... >.>
/obj/item/gun/proc/handle_suicide(mob/living/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/M = user

	mouthshoot = 1
	M.visible_message("<span class='danger'>[user] sticks their gun in their mouth, ready to pull the trigger...</span>")
	if(!do_after(user, 40, progress=0))
		M.visible_message("<span class='notice'>[user] decided life was worth living</span>")
		mouthshoot = 0
		return
	var/obj/item/projectile/in_chamber = consume_next_projectile()
	if (istype(in_chamber))
		user.visible_message("<span class = 'warning'>[user] pulls the trigger.</span>")
		var/shot_sound = in_chamber.fire_sound? in_chamber.fire_sound : fire_sound
		if(silenced)
			playsound(user, shot_sound, 10, 1)
		else
			playsound(user, shot_sound, 50, 1)
		if(istype(in_chamber, /obj/item/projectile/beam/lastertag))
			user.show_message("<span class = 'warning'>You feel rather silly, trying to commit suicide with a toy.</span>")
			mouthshoot = 0
			return

		in_chamber.on_hit(M)
		if (in_chamber.damage_type != PAIN)
			log_and_message_admins("[key_name(user)] commited suicide using \a [src]")
			user.unlock_achievement(new/datum/achievement/suicide())
			user.apply_damage(in_chamber.damage*2.5, in_chamber.damage_type, BP_HEAD, 0, in_chamber.damage_flags(), used_weapon = "Point blank shot in the mouth with \a [in_chamber]")
			user.death()

		else
			to_chat(user, "<span class = 'notice'>Ow...</span>")
			user.apply_effect(110,PAIN,0)
		qdel(in_chamber)
		mouthshoot = 0
		return
	else
		handle_click_empty(user)
		mouthshoot = 0
		return

/obj/item/gun/proc/toggle_scope(mob/user, var/zoom_amount=2.0)
	//looking through a scope limits your periphereal vision
	//still, increase the view size by a tiny amount so that sniping isn't too restricted to NSEW
	var/zoom_offset = round(world.view * zoom_amount)
	var/view_size = round(world.view + zoom_amount)
	var/scoped_accuracy_mod = zoom_offset

	zoom(user, zoom_offset, view_size)
	if(zoom)
		accuracy = scoped_accuracy + scoped_accuracy_mod
		if(screen_shake)
			screen_shake = round(screen_shake*zoom_amount+1) //screen shake is worse when looking through a scope

//make sure accuracy and screen_shake are reset regardless of how the item is unzoomed.
/obj/item/gun/zoom()
	..()
	if(!zoom)
		accuracy = initial(accuracy)
		screen_shake = initial(screen_shake)

/obj/item/gun/examine(mob/user)
	. = ..()
	if(firemodes.len > 1)
		var/datum/firemode/current_mode = firemodes[sel_mode]
		to_chat(user, "The fire selector is set to [current_mode.name].")
	if(safety)
		to_chat(user, "<span class='notice'>The safety is on.</span>")
	else
		to_chat(user, "<span class='notice'>The safety is off.</span>")



/obj/item/gun/proc/switch_firemodes()
	if(firemodes.len <= 1)
		return null

	sel_mode++
	if(sel_mode > firemodes.len)
		sel_mode = 1
	var/datum/firemode/new_mode = firemodes[sel_mode]
	new_mode.apply_to(src)

	return new_mode

/obj/item/gun/attack_self(mob/user)
	var/datum/firemode/new_mode = switch_firemodes(user)
	if(new_mode)
		playsound(src.loc, 'sound/weapons/guns/interact/selector.ogg', 50, 1)
		to_chat(user, "<span class='notice'>\The [src] is now set to [new_mode.name].</span>")

//Gun safety
/obj/item/gun/RightClick(mob/user)
	toggle_safety(user)

/obj/item/gun/proc/toggle_safety(mob/user)
	if(user.incapacitated(INCAPACITATION_STUNNED|INCAPACITATION_RESTRAINED|INCAPACITATION_KNOCKOUT))
		return
	if(src != user.get_active_hand())
		return

	if(is_jammed)
		unjam(user)
	else
		safety = !safety
		playsound(user, 'sound/items/safety.ogg', 50, 1)
		to_chat(user, "<span class='notice'>You toggle the safety [safety ? "on":"off"].</span>")
		if(!safety)
			user.update_aim_icon()
		else
			user.client.mouse_pointer_icon = null

/obj/item/gun/AltClick(mob/user)
	if(user.incapacitated(INCAPACITATION_STUNNED|INCAPACITATION_RESTRAINED|INCAPACITATION_KNOCKOUT))
		return
	if(src != user.get_active_hand())
		return
	if(!ishuman(user))
		return
	var/allowed_condition = 60//Non smart engeery people can only repair their weapon up to 60%
	var/repair_speed = 50
	var/mob/living/carbon/human/H = user
	if(H.SKILL_LEVEL(engineering) >= 6)//If you're a smart engineery boi u can repair da wepon all da wey
		allowed_condition = 90
		repair_speed = 20
	if(condition <= allowed_condition)
		if(!H.doing_something)//No spamming repairs
			H.visible_message("<span class='notice'>[H] starts to repair their weapon.</span>")
			H.doing_something = TRUE
			if(do_after(H, repair_speed, src))//Instead of failing if their not skilled, just make it slow.
				H.doing_something = FALSE
				condition += 10
				H.visible_message("<span class='info'>[H] successfully repairs their weapon.</span>")
				if(condition > 100)//If it's greater than 100
					condition = 100
			else
				H.visible_message("<span class='warning'>[H] fails to repair their weapon.</span>")
				H.doing_something = FALSE
			update_icon()



/obj/item/gun/proc/check_gun_safety(mob/user)//Used in inventory.dm to see whether or not you fucking shoot someone when you drop your gun on the ground.
	if(!safety && prob(10))
		user.visible_message("<span class='warning'>[src] goes off!</span>")
		var/list/targets = list(user)
		targets += trange(2, src)
		afterattack(pick(targets), user)



///////////////////////////
/////AUTOMATIC CLICKS//////
/////ONLY USED FOR GUNS////
///////////////////////////

/mob
	var/dispersion_mouse_display_number = 0
	var/recoil = 0


/client
	var/list/selected_target[2]

/client/MouseDown(object, location, control, params)
	var/delay = mob.CanMobAutoclick(object, location, params)
	if(delay)
		selected_target[1] = object
		selected_target[2] = params
		while(selected_target[1])
			usr.recoil += 1
			Click(selected_target[1], location, control, selected_target[2])
			sleep(delay)
		usr.dispersion_mouse_display_number = 0
		usr.recoil = 0

/client/MouseUp(object, location, control, params)
	selected_target[1] = null


/client/MouseDrag(src_object,atom/over_object,src_location,over_location,src_control,over_control,params)
	if(selected_target[1] && over_object.IsAutoclickable())
		selected_target[1] = over_object
		selected_target[2] = params

/mob/proc/CanMobAutoclick(object, location, params)
	return

/mob/living/carbon/CanMobAutoclick(atom/object, location, params)
	if(!object.IsAutoclickable())
		return
	var/obj/item/h = get_active_hand()
	if(h)
		. = h.CanItemAutoclick(object, location, params)

/obj/item/proc/CanItemAutoclick(object, location, params)
	return

/obj/item/gun/CanItemAutoclick(object, location, params)
	. = automatic

/atom/proc/IsAutoclickable()
	. = 1

/obj/screen/IsAutoclickable()
	. = 0

//A cool pointer for your gun.
/obj/item/gun/pickup(mob/user)
	if(user.client)
		if(!safety)
			user.client.mouse_pointer_icon = 'icons/effects/standard/standard1.dmi'
	update_icon()
	..()
/obj/item/gun/dropped(mob/user)
	..()
	if(user.client)
		user.client.mouse_pointer_icon = null
	update_icon()

/obj/item/gun/equipped(mob/user)
	..()
	if(user.client)
		user.client.mouse_pointer_icon = null
	update_icon()


/obj/item/gun/proc/add_bayonet()
	var/image/I =  image('icons/obj/gun.dmi', "bayonett")
	I.pixel_x += 5
	src.overlays += I


/obj/item/gun/proc/unload_ammo(mob/user, var/allow_dump=1)
	return

/obj/item/gun/proc/load_ammo(var/obj/item/A, mob/user)
	return