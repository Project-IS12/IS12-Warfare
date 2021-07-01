//A temporary effect that does not DO anything except look pretty.
/obj/effect/temporary
	anchored = 1
	unacidable = 1
	mouse_opacity = 0
	density = 0
	plane = ABOVE_HUMAN_PLANE
	layer = ABOVE_HUMAN_LAYER

/obj/effect/temporary/Initialize(var/mapload, var/duration = 30, var/_icon = 'icons/effects/effects.dmi', var/_state)
	. = ..()
	icon = _icon
	icon_state = _state
	QDEL_IN(src, duration)


/obj/effect/temporary/item_pickup_ghost
	var/lifetime = 0.2 SECONDS

/obj/effect/temporary/item_pickup_ghost/Initialize(var/mapload, var/obj/item/picked_up)
	. = ..(mapload, lifetime, picked_up.icon, picked_up.icon_state)
	pixel_x = picked_up.pixel_x
	pixel_y = picked_up.pixel_y
	color = picked_up.color

/obj/effect/temporary/item_pickup_ghost/proc/animate_towards(var/atom/target)
	var/new_pixel_x = pixel_x + (target.x - src.x) * 32
	var/new_pixel_y = pixel_y + (target.y - src.y) * 32
	animate(src, pixel_x = new_pixel_x, pixel_y = new_pixel_y, transform = matrix()*0, time = lifetime)