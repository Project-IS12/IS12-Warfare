/obj/machinery/kaos/cargo_machine
	name = "Supply Computer"
	desc = "You use this to buy shit."
	icon = 'icons/obj/old_computers.dmi'
	icon_state = "cargo_machine"
	anchored = TRUE
	density = TRUE


/obj/machinery/kaos/cargo_machine/red

/obj/machinery/kaos/cargo_machine/blue

/obj/effect/landmark/red_cargo

/obj/effect/landmark/blue_cargo


//Just for looks, it shows off nicely where the cargo will be dropped off.
/obj/structure/cargo_pad
	name = "Cargo Pad"
	desc = "Stuff ordered from the cargo computer will appear on these pads."
	icon = 'icons/obj/old_computers.dmi'
	icon_state = "cargo_pad"
	density = FALSE
	unacidable = TRUE
	anchored = TRUE
	plane = WALL_PLANE

/obj/structure/cargo_pad/ex_act()
	return

/obj/structure/cargo_pad/bottom_left
	icon_state = "bottom_left"

/obj/structure/cargo_pad/bottom_middle
	icon_state = "bottom_middle"

/obj/structure/cargo_pad/bottom_right
	icon_state = "bottom_right"