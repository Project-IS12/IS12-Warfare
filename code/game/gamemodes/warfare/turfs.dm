
//Dirt!
/turf/simulated/floor/dirty
	name = "dirt" //"snowy dirt"
	//icon = 'icons/turf/snow.dmi'
	//icon_state = "snow_3"
	icon = 'icons/turf/dirt.dmi'
	icon_state = "dirt1"
	movement_delay = 1
	has_coldbreath = TRUE
	atom_flags = ATOM_FLAG_CLIMBABLE
	var/has_light = TRUE
	var/can_generate_water = TRUE
	var/can_be_dug = TRUE

/turf/simulated/floor/dirty/fake
	atom_flags = null
	can_generate_water = FALSE
	can_be_dug = FALSE

/turf/simulated/floor/dirty/tough //Can't dig this.
	name = "tough dirt"
	desc = "This dirt doesn't look diggable."
	can_be_dug = FALSE

/turf/simulated/floor/dirty/tough/lightless/
	has_light = FALSE

/turf/simulated/floor/dirty/tough/fake //Can't be click dragged on.
	atom_flags = null

/turf/simulated/floor/dirty/tough/lightless/fake
	atom_flags = null

/turf/simulated/floor/dirty/tough/ex_act(severity)//Can't be blown up.
	return

/turf/simulated/floor/dirty/CanPass(atom/movable/mover, turf/target)
	if(ishuman(mover))
		if(istype(get_turf(mover), /turf/simulated/floor/trench))
			if(!mover.pulledby)
				return FALSE

	return TRUE

/turf/simulated/floor/dirty/can_climb(var/mob/living/user, post_climb_check=0)
	if (!(atom_flags & ATOM_FLAG_CLIMBABLE) || !can_touch(user))
		return FALSE

	if (!user.Adjacent(src))
		to_chat(user, "<span class='danger'>You can't climb there, the way is blocked.</span>")
		return FALSE

	return TRUE

/turf/simulated/floor/dirty/do_climb(var/mob/living/user)
	if(!can_climb(user))
		return

	if(istype(get_area(src), /area/warfare/battlefield/no_mans_land))//We're trying to go into no man's land?
		if(locate(/obj/item/device/boombox) in user)//Locate the boombox.
			to_chat(user, "I can't bring this with me onto the battlefield. Wouldn't want to lose it.")//No you fucking don't.
			return //Keep that boombox at base asshole.
		if(locate(/obj/item/storage) in user)//Gotta check storage as well.
			var/obj/item/storage/S = locate() in user
			if(locate(/obj/item/device/boombox) in S)
				to_chat(user, "I can't bring this with me onto the battlefield. Wouldn't want to lose it.")
				return

	user.visible_message("<span class='warning'>[user] starts climbing onto \the [src]!</span>")
	climbers |= user

	if(!can_climb(user))
		climbers -= user
		return

	if(!do_after(user,15))
		climbers -= user
		return

	user.forceMove(get_turf(src))
	user.visible_message("<span class='warning'>[user] climbed onto \the [src]!</span>")
	climbers -= user

/turf/simulated/floor/dirty/MouseDrop_T(mob/target, mob/user)
	var/mob/living/H = user
	if(istype(H) && can_climb(H) && target == user)
		do_climb(target)
	else
		return ..()

/turf/simulated/floor/dirty/indestructable/snow
	name = "snow"
	icon = 'icons/turf/snow.dmi'
	icon_state = "snow"

/turf/simulated/floor/dirty/indestructable/snow/New()
	icon_state = pick("snow[rand(1,12)]","snow0")
	..()

/turf/simulated/floor/dirty/New()
	..()
	temperature = T0C - 60
	//icon_state = pick("snow[rand(1,12)]","snow0")
	dir = pick(GLOB.alldirs)
	if(!(locate(/obj/effect/lighting_dummy/daylight) in src) && has_light)
		new /obj/effect/lighting_dummy/daylight(src)
	spawn(1)
		overlays.Cut()
		vis_contents.Cut()
		update_icon()
	if(loc.type != /area/warfare/battlefield/no_mans_land) // no base puddles
		return
	if(!can_generate_water)//This type can't generate water so don't bother.
		return
	if(prob(1)) // puddle generation,  every turf has a probability to become a water tile, then it spreads itself out
		var/list/waters = list() // list of already generated water tiles
		ChangeTurf(/turf/simulated/floor/exoplanet/water/shallow)//This is actually just a mud tile, we spawn water with it to make it looks like it's water.
		waters += src
		for(var/p in list(50,25,10,3,1)) // run through probabilities, spreading water out
			for(var/turf/water in waters)
				for(var/turf/simulated/floor/possible_water in range(1, water))
					if(prob(p) && !LAZYLEN(possible_water.contents) && !istype(possible_water, /turf/simulated/floor/exoplanet/water/shallow))
						if(/obj/structure in possible_water)//If there's any objects here return.
							return
						if(istype(possible_water, /turf/simulated/floor/trench))//No trenches becoming water please.
							return
						if(istype(possible_water, /turf/simulated/floor/dirty/fake))//Do not override the fake hacky dirt turfs please.
							return
						possible_water.ChangeTurf(/turf/simulated/floor/exoplanet/water/shallow)
						waters += possible_water

/turf/simulated/floor/dirty/attackby(obj/O as obj, mob/living/user as mob)
	if(istype(O, /obj/item/shovel))
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
			visible_message("[user] begins to dig some dirt cover!")
			if(do_after(user, (backwards_skill_scale(user.SKILL_LEVEL(engineering)) * 5)))
				new /obj/structure/dirt_wall(src)
				visible_message("[user] finishes digging the dirt cover.")
				playsound(src, 'sound/effects/empty_shovel.ogg', 50, 0)

			user.doing_something = FALSE

		else
			to_chat(user, "You're already digging.")

/turf/simulated/floor/dirty/RightClick(mob/living/user)
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
		visible_message("[user] begins to dig a trench!")
		if(do_after(user, backwards_skill_scale(user.SKILL_LEVEL(engineering)) * 5))
			ChangeTurf(/turf/simulated/floor/trench)
			visible_message("[user] finishes digging the trench.")
			playsound(src, 'sound/effects/empty_shovel.ogg', 50, 0)
			user.doing_something = FALSE

		user.doing_something = FALSE

	else
		to_chat(user, "You're already digging.")

/turf/simulated/floor/dirty/update_dirt()
	return	// Dirt doesn't doesn't become dirty

/turf/simulated/floor/dirty/indestructable
	desc = "This dirt seems tougher than most other dirts."

/turf/simulated/floor/dirty/indestructable/mud
	name = "mud"
	desc = "This mud looks tougher than most other muds."
	icon_state = "mud"

/turf/simulated/floor/dirty/indestructable/mud/New()
	dir = pick(GLOB.alldirs)
	..()

/turf/simulated/floor/dirty/indestructable/ex_act(severity)//Can't be blown up.
	return

/turf/simulated/floor/dirty/indestructable/lightless
	has_light = FALSE

/turf/simulated/floor/dirty/indestructable/lightless/has_trees

/////////
//WATER//
/////////
/turf/simulated/floor/exoplanet/water/shallow
	name = "water"
	icon = 'icons/turf/dirt.dmi'//This appears under the water.
	icon_state = "mud"
	movement_delay = 3
	mudpit = 1
	has_coldbreath = TRUE
	var/has_light = TRUE
	atom_flags = ATOM_FLAG_CLIMBABLE

/turf/simulated/floor/exoplanet/water/shallow/update_dirt()
	return

/turf/simulated/floor/exoplanet/water/shallow/ex_act(severity)
	return

/turf/simulated/floor/exoplanet/water/shallow/CanPass(atom/movable/mover, turf/target)
	if(ishuman(mover))
		if(istype(get_turf(mover), /turf/simulated/floor/trench))
			if(!mover.pulledby)
				return FALSE

	return TRUE

/turf/simulated/floor/exoplanet/water/shallow/can_climb(var/mob/living/user, post_climb_check=0)
	if (!(atom_flags & ATOM_FLAG_CLIMBABLE) || !can_touch(user))
		return FALSE

	if (!user.Adjacent(src))
		to_chat(user, "<span class='danger'>You can't climb there, the way is blocked.</span>")
		return FALSE

	return TRUE

/turf/simulated/floor/exoplanet/water/shallow/do_climb(var/mob/living/user)
	if(!can_climb(user))
		return

	user.visible_message("<span class='warning'>[user] starts climbing onto \the [src]!</span>")
	climbers |= user

	if(!can_climb(user))
		climbers -= user
		return

	if(!do_after(user,15))
		climbers -= user
		return

	user.forceMove(get_turf(src))
	user.visible_message("<span class='warning'>[user] climbed onto \the [src]!</span>")
	climbers -= user

/turf/simulated/floor/exoplanet/water/shallow/MouseDrop_T(mob/target, mob/user)
	var/mob/living/H = user
	if(istype(H) && can_climb(H) && target == user)
		if(istype(get_area(src), /area/warfare/battlefield/no_mans_land))//We're trying to go into no man's land?
			if(locate(/obj/item/device/boombox) in user)//Locate the boombox.
				to_chat(user, "I can't bring this with me onto the battlefield. Wouldn't want to lose it.")//No you fucking don't.
				return //Keep that boombox at base asshole.
			if(locate(/obj/item/storage) in user)//Gotta check storage as well.
				var/obj/item/storage/S = locate() in user
				if(locate(/obj/item/device/boombox) in S)
					to_chat(user, "I can't bring this with me onto the battlefield. Wouldn't want to lose it.")
					return
		do_climb(target)
	else
		return ..()

/turf/simulated/floor/exoplanet/water/shallow/Cross(var/atom/A)//People who are on fire go out.
	if(isliving(A))
		var/mob/living/L = A
		L.ExtinguishMob()

/turf/simulated/floor/exoplanet/water/shallow/lightless
	has_light = FALSE

/turf/simulated/floor/exoplanet/water/shallow/New()
	..()
	if((!locate(/obj/effect/lighting_dummy/daylight) in src) && has_light)
		new /obj/effect/lighting_dummy/daylight(src)
	temperature = T0C - 80
	for(var/obj/effect/water/bottom/B in src)
		if(B)
			qdel(B)
	for(var/obj/effect/water/top/T in src)
		if(T)
			qdel(T)

	new /obj/effect/water/bottom(src)//Put it right on top of the water so that they look like they're the same.
	new /obj/effect/water/top(src)
	spawn(5)
		update_icon()
		for(var/turf/simulated/floor/exoplanet/water/shallow/T in range(1))
			T.update_icon()

/turf/simulated/floor/exoplanet/water/shallow/update_icon()

	overlays.Cut()
	for(var/direction in GLOB.cardinal)
		var/turf/turf_to_check = get_step(src,direction)
		if(istype(turf_to_check, /turf/simulated/floor/exoplanet/water/shallow))
			continue

		else if(istype(turf_to_check, /turf/simulated))
			var/image/water_side = image('icons/obj/warfare.dmi', "over_water1", dir = direction)//turn(direction, 180))
			water_side.plane = EFFECTS_BELOW_LIGHTING_PLANE

			overlays += water_side
		var/image/wave_overlay = image('icons/obj/warfare.dmi', "waves")
		overlays += wave_overlay

/turf/simulated/floor/exoplanet/water/shallow/Destroy()
	. = ..()
	for(var/obj/effect/water/bottom/B in src)
		qdel(B)
	for(var/obj/effect/water/top/T in src)
		qdel(T)

/turf/simulated/floor/exoplanet/water/shallow/attackby(obj/item/O, mob/user)
	if(istype(O, /obj/item/reagent_containers))
		var/obj/item/reagent_containers/RG = O
		if (istype(RG) && RG.is_open_container())
			RG.reagents.add_reagent(/datum/reagent/water, min(RG.volume - RG.reagents.total_volume, RG.amount_per_transfer_from_this))
			user.visible_message("<span class='notice'>[user] fills \the [RG] using \the [src].</span>","<span class='notice'>You fill \the [RG] using \the [src].</span>")
			return 1

	if (istype(O, /obj/item/stack/duckboard))
		var/obj/item/stack/duckboard/S = O
		if (S.get_amount() < 1)
			return
		playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
		S.use(1)
		ChangeTurf(/turf/simulated/floor/trenches)
		return

/turf/simulated/floor/exoplanet/water/shallow/ChangeTurf(turf/N, tell_universe, force_lighting_update)
	var/obj/effect/water/top/T = locate() in loc
	if(T)
		qdel(T)
	var/obj/effect/water/bottom/B = locate() in loc
	if(B)
		qdel(B)
	. = ..()
	for(var/turf/simulated/floor/exoplanet/water/shallow/S in range(1))
		S.update_icon()


/obj/effect/water/top//This one appears over objects but under mobs.
	name = "water"
	icon = 'icons/obj/warfare.dmi'
	icon_state = "trench_water_top"
	plane = ABOVE_OBJ_PLANE
	layer = ABOVE_OBJ_LAYER
	density = FALSE
	anchored = TRUE
	mouse_opacity = FALSE

/obj/effect/water/bottom//This one appears over mobs.
	name = "water"
	icon = 'icons/obj/warfare.dmi'
	icon_state = "trench_water_bottom"
	plane = ABOVE_HUMAN_PLANE
	layer = ABOVE_HUMAN_LAYER
	density = FALSE
	anchored = TRUE
	mouse_opacity = FALSE//Don't want this being clicked.

/turf/simulated/floor/exoplanet/water/update_dirt()
	return	// Water doesn't become dirty



/obj/item/stack/duckboard
	name = "duckboards"
	singular_name = "duckboard"
	w_class = 1
	force = 0
	throwforce = 0
	max_amount = 20
	gender = PLURAL
	desc = "For building over water."
	icon = 'icons/turf/trenches_turfs.dmi'
	icon_state = "wood0"