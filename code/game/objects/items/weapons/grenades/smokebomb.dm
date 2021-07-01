/obj/item/grenade/smokebomb
	desc = "Use this to stop both you, and the enemy from seeing anything."
	name = "smoke bomb"
	icon = 'icons/obj/grenade.dmi'
	icon_state = "csmoke"
	arm_sound = 'sound/weapons/grenade_arm.ogg'
	det_time = 30
	item_state = "flashbang"
	slot_flags = SLOT_BELT
	var/datum/effect/effect/system/smoke_spread/smoke

/obj/item/grenade/smokebomb/New()
	..()
	src.smoke = new /datum/effect/effect/system/smoke_spread()
	src.smoke.attach(src)

/obj/item/grenade/smokebomb/Destroy()
	qdel(smoke)
	smoke = null
	return ..()

/obj/item/grenade/smokebomb/detonate()
	playsound(src.loc, 'sound/effects/smoke.ogg', 50)
	src.smoke.set_up(10, 0, usr.loc)
	spawn(0)
		src.smoke.start()
		sleep(10)
		src.smoke.start()
		sleep(10)
		src.smoke.start()
		sleep(10)
		src.smoke.start()
	sleep(80)
	qdel(src)


//These are debug items and are not used in game.
/obj/item/grenade/smokebomb/mortar
	name = "mortar marker"
	desc = "Throw it at the spot you want mortar fire at. MAKE SURE YOU'RE NOT THERE!"
	det_time = 50
	var/mortar_type = "shrapnel"

/obj/item/grenade/smokebomb/mortar/detonate()
	drop_mortar(get_turf(src), mortar_type)
	qdel(src)


/obj/item/grenade/smokebomb/mortar/gas
	mortar_type = "gas"