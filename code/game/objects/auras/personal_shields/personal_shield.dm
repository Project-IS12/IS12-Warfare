/obj/aura/personal_shield
	name = "personal shield"

/obj/aura/personal_shield/New(var/mob/living/user)
	..()
	playsound(user,'sound/weapons/flash.ogg',35,1)
	to_chat(user,SPAN_NOTICE("You feel your body prickle as \the [src] comes online."))

/obj/aura/personal_shield/bullet_act(var/obj/item/projectile/P, var/def_zone)
	user.visible_message(SPAN_WARNING("\The [user]'s [src.name] flashes before \the [P] can hit them!"))
	new /obj/effect/shield_impact(user.loc)
	playsound(user,'sound/effects/basscannon.ogg',35,1)
	return AURA_FALSE|AURA_CANCEL

/obj/aura/personal_shield/Destroy()
	to_chat(user,SPAN_WARNING("\The [src] goes offline!"))
	playsound(user,'sound/mecha/internaldmgalarm.ogg',25,1)
	return ..()

/obj/aura/personal_shield/device
	var/obj/item/device/personal_shield/shield

/obj/aura/personal_shield/device/bullet_act()
	. = ..()
	if(shield)
		shield.take_charge()

/obj/aura/personal_shield/device/New(var/mob/living/user, var/user_shield)
	..()
	shield = user_shield

/obj/aura/personal_shield/device/Destroy()
	shield = null
	return ..()