/turf/simulated/floor/trenches
	name = "trench"
	icon = 'icons/turf/trenches_turfs.dmi'
	icon_state = "wood0"
	can_smooth = TRUE
	movement_delay = 0.5

/obj/structure/trench_wall
	name = "trench wall"
	icon = 'icons/turf/trenches_turfs.dmi'
	icon_state = "trench"
	density = FALSE



/turf/simulated/floor/trenches/relativewall()
	var/junction = 0
	for(var/turf/simulated/floor/trenches/W in orange(src,1))
		if(abs(src.x-W.x)-abs(src.y-W.y))
			junction |= get_dir(src,W)
	icon_state = "wood[junction]"

/turf/simulated/floor/trenches/ex_act()//No blowing this up.
	return


/turf/simulated/floor/trenches/underground
	is_underground = TRUE


/turf/simulated/floor/trenches/Initialize()
	. = ..()
	relativewall_neighbours()



/turf/simulated/floor/trench
	icon = 'icons/obj/warfare.dmi'
	icon_state = "trench"
	name = "trench"
	movement_delay = 0.5
	has_coldbreath = TRUE
	var/can_be_dug = TRUE

/turf/simulated/floor/trench/fake
	atom_flags = null
	can_be_dug = FALSE

/turf/simulated/floor/trench/tough
	can_be_dug = FALSE

/turf/simulated/floor/trench/ex_act(severity)
	return

/turf/simulated/floor/trench/update_dirt()
	return	// Dirt doesn't doesn't become dirty

/turf/simulated/floor/trench/New()
	..()
	if(!locate(/obj/effect/lighting_dummy/daylight) in src)
		new /obj/effect/lighting_dummy/daylight(src)
	dir = pick(GLOB.alldirs)
	update_icon()


/turf/simulated/floor/trench/RightClick(mob/living/user)
	if(!CanPhysicallyInteract(user))
		return
	var/obj/item/shovel/S = user.get_active_hand()
	if(!istype(S))
		return
	if(!can_be_dug)//No escaping to mid early.
		return
	if(!user.doing_something)
		user.doing_something = TRUE
		if(src.density)
			user.doing_something = FALSE
			return
		for(var/obj/structure/object in contents)
			if(object)
				to_chat(user, "There are things in the way.")
				user.doing_something = FALSE
				return
		playsound(src, 'sound/effects/dig_shovel.ogg', 50, 0)
		visible_message("[user] begins fill in the trench!")
		if(do_after(user, backwards_skill_scale(user.SKILL_LEVEL(engineering)) * 5))
			for(var/mob/M in src)
				if(ishuman(M))
					M.pixel_y = 0
			ChangeTurf(/turf/simulated/floor/dirty)
			update_trench_shit()
			visible_message("[user] finishes filling in trench.")
			playsound(src, 'sound/effects/empty_shovel.ogg', 50, 0)
			user.doing_something = FALSE

		user.doing_something = FALSE

	else
		to_chat(user, "You're already digging.")


/turf/simulated/floor/proc/update_trench_layers()
	vis_contents.Cut()
	for(var/direction in GLOB.cardinal)
		var/turf/turf_to_check = get_step(src,direction)
		if(istype(turf_to_check, /turf/simulated/floor/trench))
			continue
		if(istype(turf_to_check, /turf/space) || istype(turf_to_check, /turf/simulated/floor) || istype(turf_to_check, /turf/simulated/floor/exoplanet/water/shallow) || istype(turf_to_check, /turf/simulated/wall))
			var/atom/movable/trench_side = new()
			trench_side.icon = 'icons/obj/warfare.dmi'
			trench_side.icon_state = "trench_side"
			trench_side.dir = turn(direction, 180)
			trench_side.mouse_opacity = 0
			switch(direction)
				if(NORTH)
					trench_side.pixel_y += ((world.icon_size) - 22)
					trench_side.layer = BELOW_OBJ_LAYER
				if(SOUTH)
					trench_side.pixel_y -= ((world.icon_size) - 16)
					trench_side.plane = ABOVE_OBJ_PLANE
				if(EAST)
					trench_side.pixel_x += (world.icon_size)
					trench_side.plane = ABOVE_OBJ_PLANE
					trench_side.layer = BASE_MOB_LAYER
				if(WEST)
					trench_side.pixel_x -= (world.icon_size)
					trench_side.plane = ABOVE_OBJ_PLANE
					trench_side.layer = BASE_MOB_LAYER
			vis_contents += trench_side

/turf/simulated/floor/trench/update_icon()
	update_trench_shit()

/turf/simulated/floor/proc/update_trench_shit()
	for(var/direction in GLOB.cardinal)
		var/turf/turf_to_check = get_step(src,direction)
		if(istype(turf_to_check, /turf/simulated/floor/trench))//Rebuild our neighbors.
			var/turf/simulated/floor/trench/T = turf_to_check
			T.update_trench_layers()
			continue

	update_trench_layers()

/turf/simulated/floor/trench/Crossed(var/mob/living/carbon/human/M)
	if(istype(M))
		if(!M.throwing)
			if(M.client)
				M.fov_mask.screen_loc = "1,0.8"
				M.fov.screen_loc = "1,0.8"
			if(M.crouching)
				M.pixel_y = -12
			else
				M.pixel_y = -8

			M.plane = LYING_HUMAN_PLANE

			var/trench_check = 0 //If we're not up against a trench wall, we don't want to stay zoomed in.
			for(var/direction in GLOB.cardinal)
				var/turf/turf_to_check = get_step(M.loc,direction)//So get all of the turfs around us.
				if(istype(turf_to_check, /turf/simulated/floor/trench))//And if they're a trench, count it.
					trench_check++
			if(trench_check >= 4)//We're surrounded on all sides by trench. We unzoom.
				if(M.zoomed)//If we're zoomed that is.
					M.do_zoom()

/turf/simulated/floor/trench/Uncrossed(var/mob/living/carbon/human/M)
	if(istype(M))
		if(M.client)
			M.fov_mask.screen_loc = "1,1"
			M.fov.screen_loc = "1,1"
		M.pixel_y = 0
		M.plane = HUMAN_PLANE
