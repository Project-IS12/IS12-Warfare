/obj/structure/defensive_barrier
	name = "defensive barrier"
	desc = "A portable defensive barrier. It stops bullets from hitting you... most of the time. CTRL click it to pack it up."
	icon = 'icons/obj/structures/barrier.dmi'
	icon_state = "barrier_rised"
	density =    FALSE
	throwpass =  TRUE
	anchored =   TRUE
	atom_flags = ATOM_FLAG_CLIMBABLE | ATOM_FLAG_CHECKS_BORDER
	var/health = 300
	var/maxhealth = 300
	var/secured

/obj/structure/defensive_barrier/Initialize()
	. = ..()
	update_icon()
	GLOB.dir_set_event.register(src, src, .proc/update_layers)

/obj/structure/defensive_barrier/examine(mob/user)
	. = ..()
	if(maxhealth == -1)
		return
	else if(health >= 150)
		to_chat(user, SPAN_NOTICE("It is undamaged."))
	else if(health < 150 && health > 100)
		to_chat(user, SPAN_WARNING("It has a few small dents."))
	else if(health < 100 && health > 50)
		to_chat(user, SPAN_WARNING("It has several large dents."))
	else
		to_chat(user, SPAN_DANGER("It is on the verge of breaking apart!"))

/obj/structure/defensive_barrier/proc/get_destroyed()
	visible_message(SPAN_DANGER("\The [src] was destroyed!"))
	playsound(src, 'sound/effects/clang.ogg', 100, 1)
	qdel(src)

/obj/structure/defensive_barrier/Destroy()
	GLOB.dir_set_event.unregister(src, src, .proc/update_layers)
	. = ..()

/obj/structure/defensive_barrier/proc/update_layers()
	if(dir != SOUTH)
		layer = initial(layer) + 0.01
		plane = initial(plane)
	else if(dir == SOUTH && density)
		layer = ABOVE_HUMAN_LAYER
		plane = ABOVE_HUMAN_PLANE
	else
		layer = initial(layer) + 0.01
		plane = initial(plane)

/obj/structure/defensive_barrier/update_icon()
	..()
	if(!secured)
		if(density)
			icon_state = "barrier_rised"
		else
			icon_state = "barrier_downed"
	else
		icon_state = "barrier_deployed"
	update_layers()

/obj/structure/defensive_barrier/CanPass(atom/movable/mover, turf/target, height = 0, air_group = 0)
	if(!density || air_group || (height == 0))
		return TRUE

	if(istype(mover, /obj/item/projectile))
		var/obj/item/projectile/proj = mover
		if(Adjacent(proj?.firer))
			return TRUE
		//if(mover.dir != reverse_direction(dir))
		//	return TRUE
		if(get_dist(proj.starting, loc) <= 1)//allows to fire from 1 tile away of barrier
			return TRUE
		return check_cover(mover, target)

	if(get_dir(get_turf(src), target) == dir && density)//turned in front of barrier
		return FALSE

	return TRUE

/obj/structure/defensive_barrier/CheckExit(atom/movable/O, target)
	if(O?.checkpass(PASS_FLAG_TABLE))
		return TRUE
	if(get_dir(loc, target) == dir)
		return !density
	return TRUE

/obj/structure/defensive_barrier/proc/try_pack_up(var/mob/user)

	if(secured)
		to_chat(user, SPAN_WARNING("\The [src] is secured in place and cannot be packed up. You will need to unsecure it with a screwdriver."))
		return FALSE

	if(density)
		to_chat(user, SPAN_WARNING("\The [src] is raised and must be lowered before you can pack it up."))
		return FALSE

	visible_message(SPAN_NOTICE("\The [user] starts packing up \the [src]."))

	if(!do_after(user, 10, src) || secured || density)
		return FALSE

	visible_message(SPAN_NOTICE("\The [user] packs up \the [src]."))
	var/obj/item/defensive_barrier/B = new(get_turf(user))
	playsound(src, 'sound/items/Deconstruct.ogg', 100, 1)
	B.stored_health = health
	B.stored_max_health = maxhealth
	B.add_fingerprint(user)
	qdel(src)
	return TRUE

/obj/structure/defensive_barrier/CtrlClick(mob/living/user)
	try_pack_up(user)

/obj/structure/defensive_barrier/attack_hand(mob/living/carbon/human/user)

	if(ishuman(user) && user.species.can_shred(user) && user.a_intent == I_HURT)
		take_damage(20)
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		return TRUE

	if(user.a_intent == I_GRAB)
		try_pack_up(user)
		return TRUE

	if(secured)
		to_chat(user, SPAN_WARNING("\The [src] is secured in place and cannot be put up or down. You will need to unsecure it with a screwdriver."))
		return TRUE

	if(!do_after(user, 5, src))
		return TRUE

	playsound(src, 'sound/effects/extout.ogg', 100, 1)
	density = !density
	to_chat(user, SPAN_NOTICE("You [density ? "raise" : "lower"] \the [src]."))
	update_icon()
	return TRUE

/obj/structure/defensive_barrier/attackby(obj/item/W, mob/user)

	if(isScrewdriver(W) && density)
		user.visible_message(SPAN_NOTICE("\The [user] begins to [secured ? "unsecure" : "secure"] \the [src]..."))
		playsound(src, 'sound/items/Screwdriver.ogg', 100, 1)
		if(!do_after(user, 30, src))
			return TRUE
		secured = !secured
		user.visible_message(SPAN_NOTICE("\The [user] has [secured ? "secured" : "unsecured"] \the [src]."))
		update_icon()
		return TRUE

	. = ..()

/obj/structure/defensive_barrier/proc/take_damage(damage)
	if(damage)
		playsound(src.loc, 'sound/effects/bang.ogg', 75, 1)
		damage = round(damage * 0.5)
		if(damage)
			..()

/obj/structure/defensive_barrier/proc/check_cover(obj/item/projectile/P, turf/from)
	var/turf/cover = get_turf(src)
	if(!cover)
		return TRUE

	visible_message(SPAN_WARNING("\The [P] hits \the [src]!"))
	bullet_act(P)
	return FALSE


/obj/structure/defensive_barrier/bullet_act(obj/item/projectile/P)
	..()
	health -= rand(20,40)
	if(health <= 0)
		health = 0
		get_destroyed()


/obj/item/defensive_barrier
	name = "deployable barrier"
	desc = "A portable barrier in flatpack form. Deploy it to stop bullets from killing you."
	icon = 'icons/obj/structures/barrier.dmi'
	icon_state = "barrier_hand"
	w_class = ITEM_SIZE_NORMAL
	var/stored_health = 300
	var/stored_max_health = 300

/obj/item/defensive_barrier/proc/turf_check(mob/user, var/turf/to_check)
	var/turf/T = get_turf(to_check)
	if(!istype(T))
		return FALSE
	if(istype(T, /turf/simulated/floor/trench))
		to_chat(user, "I cannot place this in a trench.")
		return FALSE
	if(T.density)
		to_chat(user, "I cannot place cover here.")
		return FALSE
	for(var/obj/structure/defensive_barrier/D in T)
		if((D.dir == user.dir))
			to_chat(user, SPAN_WARNING("There is already a barrier set up facing that direction."))
			return FALSE
	return TRUE

/obj/item/defensive_barrier/attack_self(mob/user)
	var/turf/T = get_step(user, user.dir)
	if(!turf_check(user, T))//Checking if we can put this here.
		return TRUE
	if(!do_after(user, 30, src))
		return TRUE
	playsound(src, 'sound/effects/extout.ogg', 100, 1)
	var/obj/structure/defensive_barrier/B = new(T)
	B.set_dir(user.dir)
	B.health = stored_health
	if(loc == user)
		user.drop_from_inventory(src)
	qdel(src)

/obj/item/defensive_barrier/attackby(obj/item/W, mob/user)

	if(stored_health < stored_max_health && isWelder(W))
		var/obj/item/weldingtool/WT = W
		if(!WT.isOn())
			to_chat(user, SPAN_WARNING("Turn \the [W] on first."))
			return TRUE

		if(!WT.remove_fuel(0,user))
			to_chat(user, SPAN_WARNING("You need more welding fuel to complete this task."))
			return TRUE

		to_chat(user, SPAN_WARNING("You start repairing the damage to \the [src]."))
		playsound(src, 'sound/items/Welder.ogg', 100, 1)

		if(!do_after(user, max(5, round((stored_max_health-stored_health) / 5)), src) || !WT?.isOn() || QDELETED(src))
			return TRUE

		to_chat(user, SPAN_NOTICE("You finish repairing the damage to \the [src]."))
		playsound(src, 'sound/items/Welder2.ogg', 100, 1)
		stored_health = stored_max_health
		return TRUE

	. = ..()