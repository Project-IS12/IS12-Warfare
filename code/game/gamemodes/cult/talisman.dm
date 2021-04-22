/obj/item/paper/talisman
	icon_state = "paper_talisman"
	var/imbue = null
	info = "<center><img src='talisman.png'></center><br/><br/>"

/obj/item/paper/talisman/attack_self(var/mob/living/user)
	if(iscultist(user))
		to_chat(user, "Attack your target to use this talisman.")
	else
		to_chat(user, "You see strange symbols on the paper. Are they supposed to mean something?")

/obj/item/paper/talisman/attack(var/mob/living/M, var/mob/living/user)
	return

/obj/item/paper/talisman/emp/attack_self(var/mob/living/user)
	if(iscultist(user))
		to_chat(user, "This is an emp talisman.")
	..()

/obj/item/paper/talisman/emp/afterattack(var/atom/target, var/mob/user, var/proximity)
	if(!iscultist(user))
		return
	if(!proximity)
		return
	user.say("Ta'gh fara[pick("'","`")]qha fel d'amar det!")
	user.visible_message(SPAN_DANGER("\The [user] invokes \the [src] at [target]."), SPAN_DANGER("You invoke \the [src] at [target]."))
	target.emp_act(1)
	qdel(src)
