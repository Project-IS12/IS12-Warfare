var/list/starting_cryopods = list()

/obj/machinery/startcryo
	name = "CryoPod"
	icon = 'icons/obj/cryostart.dmi'
	icon_state = "cryo_loaded"
	var/mob/living/carbon/human/occupant
	anchored = 1
	density = 1
	var/is_used = 0
	plane = ABOVE_OBJ_PLANE
	interact_offline = 1
	layer = 0

/obj/machinery/startcryo/New()
	starting_cryopods.Add(src)
	..()

/obj/machinery/startcryo/Destroy()
	starting_cryopods.Remove(src)
	..()

/obj/machinery/startcryo/proc/move_occupant_in(var/mob/living/carbon/C)
	occupant = C
	C.forceMove(src)
	update_icon()
	starting_cryopods.Remove(src)

/obj/machinery/startcryo/relaymove(mob/user)
	eject_occupant()

/obj/machinery/startcryo/proc/eject_occupant()
	spawn(20)
		is_used = 1
		occupant.forceMove(src.loc)
		occupant.reset_view(0)
		occupant.visible_message("[occupant] gets out from [src]!")
		playsound(occupant.loc, 'sound/machines/cryoexit.ogg')
		occupant = null
		update_icon()
		return

/obj/machinery/startcryo/update_icon()
	underlays.Cut()
	icon_state = "cryo_[is_used ? "used" : "loaded"]"
	if(occupant)
		var/image/pickle = image(occupant.icon, occupant.icon_state)
		pickle.overlays = occupant.overlays
		underlays += pickle