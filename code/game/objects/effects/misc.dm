//The effect when you wrap a dead body in gift wrap
/obj/effect/spresent
	name = "strange present"
	desc = "It's a ... present?"
	icon = 'icons/obj/items.dmi'
	icon_state = "strangepresent"
	density = 1
	anchored = 0

/obj/effect/stop
	var/victim = null
	icon_state = "empty"
	name = "Geas"
	desc = "You can't resist."


/obj/effect/effect/cig_smoke
	name = "smoke"
	icon_state = "smallsmoke"
	icon = 'icons/effects/effects.dmi'
	opacity = FALSE
	anchored = TRUE
	mouse_opacity = FALSE
	plane = HUMAN_PLANE
	layer = ABOVE_HUMAN_LAYER

	var/time_to_live = 3 SECONDS

/obj/effect/effect/cig_smoke/Initialize()
	. = ..()
	set_dir(pick(GLOB.cardinal))
	pixel_x = rand(0, 13)
	pixel_y = rand(0, 13)
	animate(src, alpha = 0, time_to_live, easing = EASE_IN)
	QDEL_IN(src, time_to_live)