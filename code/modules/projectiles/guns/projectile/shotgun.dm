/obj/item/gun/projectile/shotgun
	bulletinsert_sound 	= "shotgun_insert"// sound/weapons/guns/interact/shellinsert1.ogg and 2
	fire_sound = 'sound/weapons/guns/fire/shotgun.ogg'
	parry_sounds = list('sound/weapons/blunt_parry1.ogg', 'sound/weapons/blunt_parry2.ogg', 'sound/weapons/blunt_parry3.ogg')
	load_method = SINGLE_CASING|SINGLE_LOAD
	slot_flags = SLOT_BACK|SLOT_S_STORE
	var/empty_icon = null

/obj/item/gun/projectile/shotgun/update_icon()
	. = ..()
	if(empty_icon)
		if(!chambered && !loaded.len)//If there's an empty icon then use it.
			icon_state = empty_icon
		else if(!chambered && loaded.len)
			icon_state = empty_icon
		else
			icon_state = initial(icon_state)


/obj/item/gun/projectile/shotgun/pump
	name = "shotgun"
	desc = "The mass-produced W-T Remmington 29x shotgun is a favourite of police and security forces on many worlds. Useful for sweeping alleys."
	icon_state = "shotgun"
	item_state = "shotgun"
	max_shells = 5
	w_class = ITEM_SIZE_HUGE
	force = 10
	obj_flags =  OBJ_FLAG_CONDUCTIBLE
	caliber = "shotgun"
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2)
	ammo_type = /obj/item/ammo_casing/shotgun/beanbag
	handle_casings = HOLD_CASINGS
	one_hand_penalty = 25
	var/recentpump = 0 // to prevent spammage
	var/pumpsound = 'sound/weapons/guns/interact/newpump.ogg' //Support for other kinds of pump weapons.
	var/backsound = 'sound/weapons/guns/interact/shotgun_back.ogg'
	var/forwardsound = 'sound/weapons/guns/interact/shotgun_forward.ogg'
	casingsound = 'sound/weapons/guns/misc/shotgun_fall.ogg' //Same here.
	wielded_item_state = "wshotgun"
	gun_type = GUN_SHOTGUN

/obj/item/gun/projectile/shotgun/pump/New()
	..()
	pump(null, TRUE)//Chamber it when it's created.


/obj/item/gun/projectile/shotgun/pump/consume_next_projectile()
	if(check_for_jam())
		return 0
	if(is_jammed)
		return null
	if(chambered)
		return chambered.BB
	return null


/obj/item/gun/projectile/shotgun/pump/examine(mob/user, distance)
	. = ..()
	if(chambered)
		if(chambered.BB)
			to_chat(user, "There is a <span class='bnotice'>LIVE</span> one in the chamber.")
		else
			to_chat(user, "There is a <span class='danger'><b>SPENT</b></span> one in the chamber.")
	else
		to_chat(user, "<span class='danger'>The chamber is <b>EMPTY</b>.")

/obj/item/gun/projectile/shotgun/pump/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/ammo_magazine/box/shotgun))
		var/obj/item/ammo_magazine/box/shotgun/S = W
		if(!S.open)
			return
	..()


/obj/item/gun/projectile/shotgun/pump/attack_self(mob/living/user as mob)
	if(world.time >= recentpump + 10)
		pump(user)
		recentpump = world.time

/obj/item/gun/projectile/shotgun/pump/proc/pump(mob/M as mob, silent = FALSE)
	if(is_jammed)
		if(M)
			M.visible_message("\The [M] begins to unjam [src].", "You begin to clear the jam of [src]")
		if(!do_after(M, 40, src))
			return
		is_jammed = 0
		playsound(src.loc, 'sound/effects/unjam.ogg', 50, 1)
		if(M)
			M.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		return

	if(!chambered && !loaded.len)//If there's an empty icon then use it.
		pumpsound = null
		if(M)
			to_chat(M, "<span class='warning'>It's empty.</span>")
		return

	if(chambered && loaded.len)
		pumpsound = initial(pumpsound)

	else if(!chambered && loaded.len)
		pumpsound = forwardsound

	if(chambered)//We have a shell in the chamber
		chambered.loc = get_turf(src)//Eject casing
		playsound(src, casingsound, 100, 1)
		chambered = null

	if(loaded.len)
		var/obj/item/ammo_casing/AC = loaded[1] //load next casing.
		loaded -= AC //Remove casing from loaded list.
		chambered = AC

	if(!chambered && !loaded.len)
		pumpsound = backsound

	update_icon()

	if(!silent)
		playsound(src, pumpsound, 45, 1)

	if(M)
		M.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

/obj/item/gun/projectile/shotgun/pump/combat
	name = "combat shotgun"
	desc = "Built for close quarters combat, the Hephaestus Industries KS-40 is widely regarded as a weapon of choice for repelling boarders."
	icon_state = "cshotgun"
	item_state = "cshotgun"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2)
	max_shells = 7 //match the ammo box capacity, also it can hold a round in the chamber anyways, for a total of 8.
	ammo_type = /obj/item/ammo_casing/shotgun
	one_hand_penalty = 50 //a little heavier than the regular shotgun
	wielded_item_state = "shotgun-wielded"

/obj/item/gun/projectile/shotgun/pump/border
	name = "border shotgun"
	icon_state = "border"
	item_state = "cshotgun"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2)
	max_shells = 7
	ammo_type = /obj/item/ammo_casing/shotgun
	wielded_item_state = "cshotgun2"

/obj/item/gun/projectile/shotgun/doublebarrel
	name = "\improper MS Doom"
	desc = "Two shots. That's all you'll ever need."
	icon_state = "dshotgun"
	item_state = "dshotgun"
	load_method = SINGLE_CASING|SINGLE_LOAD
	handle_casings = CYCLE_CASINGS
	max_shells = 2
	w_class = ITEM_SIZE_HUGE
	force = 10
	obj_flags =  OBJ_FLAG_CONDUCTIBLE
	caliber = "shotgun"
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 1)
	ammo_type = /obj/item/ammo_casing/shotgun/pellet
	casingsound = 'sound/weapons/guns/misc/shotgun_fall.ogg'
	wielded_item_state = "dshotgun1"
	gun_type = GUN_PISTOL //Now anyone can use it.
	one_hand_penalty = 25
	burst_delay = 0
	var/broke_open = FALSE

/obj/item/gun/projectile/shotgun/doublebarrel/update_icon()
	..()
	if(broke_open)
		icon_state = "dshotgun-e"
	else
		icon_state = "dshotgun"

/obj/item/gun/projectile/shotgun/doublebarrel/attack_self(mob/user)
	. = ..()
	broke_open = !broke_open
	playsound(src, 'sound/weapons/guns/interact/shotgun_break.ogg', 50)
	if(broke_open)
		if(loaded.len)
			unload_ammo(user)
	update_icon()

/obj/item/gun/projectile/shotgun/doublebarrel/special_check(mob/user)
	if(broke_open)
		to_chat(user, "Close the shotgun first.")
		return FALSE
	return ..()



/obj/item/gun/projectile/shotgun/doublebarrel/pellet
	ammo_type = /obj/item/ammo_casing/shotgun/pellet

/obj/item/gun/projectile/shotgun/doublebarrel/flare
	name = "signal shotgun"
	desc = "A double-barreled shotgun meant to fire signal flash shells."
	ammo_type = /obj/item/ammo_casing/shotgun/flash

/obj/item/gun/projectile/shotgun/doublebarrel/unload_ammo(user, allow_dump)
	..(user, allow_dump=1)

//this is largely hacky and bad :(	-Pete
/obj/item/gun/projectile/shotgun/doublebarrel/attackby(var/obj/item/A as obj, mob/user as mob)
	if(w_class > 3 && (istype(A, /obj/item/circular_saw) || istype(A, /obj/item/melee/energy) || istype(A, /obj/item/gun/energy/plasmacutter)))
		to_chat(user, "<span class='notice'>You begin to shorten the barrel of \the [src].</span>")
		if(loaded.len)
			for(var/i in 1 to max_shells)
				Fire(user, user)	//will this work? //it will. we call it twice, for twice the FUN
			user.visible_message("<span class='danger'>The shotgun goes off!</span>", "<span class='danger'>The shotgun goes off in your face!</span>")
			return
		if(do_after(user, 30, src))	//SHIT IS STEALTHY EYYYYY
			icon_state = "sawnshotgun"
			item_state = "sawnshotgun"
			w_class = ITEM_SIZE_NORMAL
			force = 5
			one_hand_penalty = 0
			slot_flags &= ~SLOT_BACK	//you can't sling it on your back
			slot_flags &= ~SLOT_S_STORE	//you can't sling it on your back
			slot_flags |= (SLOT_BELT|SLOT_HOLSTER) //but you can wear it on your belt (poorly concealed under a trenchcoat, ideally) - or in a holster, why not.
			SetName("sawn-off shotgun")
			desc = "Omar's coming!"
			to_chat(user, "<span class='warning'>You shorten the barrel of \the [src]!</span>")
	else
		if(!broke_open)
			return
		..()
		update_icon()

/obj/item/gun/projectile/shotgun/doublebarrel/sawn
	name = "sawn-off shotgun"
	desc = "Omar's coming!"
	icon_state = "sawnshotgun"
	item_state = "sawnshotgun"
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	ammo_type = /obj/item/ammo_casing/shotgun/pellet
	w_class = ITEM_SIZE_NORMAL
	force = 5
	one_hand_penalty = 0


/obj/item/gun/projectile/shotgun/pump/boltaction
	name = "\improper Mark II Stormrider" //I used a random rifle generator to come up with that.
	desc = "This piece of junk looks like something that could have been used 700 years ago"
	icon_state = "mosin"
	item_state = "mosin"
	caliber = "a762"
	bulletinsert_sound 	= 'sound/weapons/guns/interact/rifle_load.ogg'
	casingsound = 'sound/weapons/guns/misc/casingfall1.ogg'
	pumpsound = 'sound/weapons/boltpump.ogg'
	backsound = 'sound/weapons/guns/interact/rifle_boltback.ogg'
	forwardsound = 'sound/weapons/guns/interact/rifle_boltforward.ogg'
	ammo_type = /obj/item/ammo_casing/a762
	wielded_item_state = "rifle-wielded"
	block_chance = 45
	gun_type = GUN_PISTOL