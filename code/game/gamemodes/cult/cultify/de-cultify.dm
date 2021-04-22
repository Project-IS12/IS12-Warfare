/turf/unsimulated/wall/cult/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/nullrod))
		user.visible_message(SPAN_NOTICE("\The [user] touches \the [src] with \the [I], and it shifts."), SPAN_NOTICE("You touch \the [src] with \the [I], and it shifts."))
		ChangeTurf(/turf/unsimulated/wall)
		return
	..()