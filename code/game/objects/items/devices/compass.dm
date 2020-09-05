/obj/item/device/compass

	name = "Compass"
	desc = "A small metallic device with a swivel on top of its face. You could find your location with this."
	icon_state = "compass"

	obj_flags = OBJ_FLAG_CONDUCTIBLE
	force = 5.0
	w_class = ITEM_SIZE_SMALL
	throwforce = 5.0
	throw_range = 15
	throw_speed = 3

	//matter = list("metal" = 50,"glass" = 50)


/obj/item/device/compass/attack_self(mob/user)
	var/turf/T = get_turf(src)
	to_chat(user, "You start finding your location...")
	if(do_after(user, 10))
		to_chat(user, "It looks like I'm at [T.x] [T.y]")
	else
		to_chat(user, "You lower the compass and stop.")

