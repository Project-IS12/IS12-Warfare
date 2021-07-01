/obj/structure/dirt_wall
	name = "dirt barricade"
	desc = "A land structure to cover your ass!" //change this stupid description
	icon = 'icons/obj/warfare.dmi'
	icon_state = "mound"
	throwpass = TRUE//we can throw grenades despite its density
	anchored = TRUE
	density = FALSE
	plane = ABOVE_OBJ_PLANE
	layer = BASE_ABOVE_OBJ_LAYER
	var/health = 100


/obj/structure/dirt_wall/Crossed(var/mob/living/M as mob)
	if(istype(M))
		M.pixel_y = 12
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.client)
			H.fov_mask.screen_loc = "1,1.5"
			H.fov.screen_loc = "1,1.5"

/obj/structure/dirt_wall/Uncrossed(var/mob/living/M as mob)
	if(istype(M))
		M.pixel_y = 0
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.client)
			H.fov_mask.screen_loc = "1,1"
			H.fov.screen_loc = "1,1"

/obj/structure/dirt_wall/attackby(obj/O as obj, mob/user as mob)
	if(istype(O, /obj/item/shovel))
		if(do_after(user, 50))
			qdel(src)

/obj/structure/dirt_wall/RightClick(mob/user)
	if(!CanPhysicallyInteract(user))
		return
	if(do_after(user, 50))
		if(src)//If it's somehow deleted before hand.
			health = 100


/obj/structure/dirt_wall/bullet_act(var/obj/item/projectile/Proj)
	..()
	for(var/mob/living/carbon/human/H in loc)
		H.bullet_act(Proj)
	//visible_message("[Proj] hits the [src]!")
	playsound(src, "hitwall", 50, TRUE)
	health -= rand(10, 25)
	if(health <= 0)
		visible_message("<span class='danger'>The [src] crumbles!</span>")
		qdel(src)

/obj/structure/dirt_wall/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			qdel(src)
			return
		if(3.0)
			if(prob(50))
				qdel(src)



/obj/structure/dirt_wall/attack_generic(var/mob/user, var/damage)
	return FALSE

/obj/structure/dirt_wall/fire_act(temperature)
	return

/obj/structure/dirt_wall/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover, /obj/item/projectile))
		var/obj/item/projectile/proj = mover

		if(proj.firer && Adjacent(proj.firer))
			return TRUE

		if (get_dist(proj.starting, loc) <= 1)
			return TRUE

		return FALSE

	return TRUE


//Bullshit snowflake stuff for climbing over it.
/obj/structure/dirt_wall/do_climb(var/mob/living/user)
	if(!can_climb(user))
		return

	usr.visible_message("<span class='warning'>[user] starts climbing onto \the [src]!</span>")
	climbers |= user

	if(!do_after(user,(issmall(user) ? 20 : 34)))
		climbers -= user
		return

	if(!can_climb(user, post_climb_check=1))
		climbers -= user
		return

	if(!neighbor_turf_passable())
		to_chat(user, "<span class='danger'>You can't climb there, the way is blocked.</span>")
		climbers -= user
		return

	if(get_turf(user) == get_turf(src))
		usr.forceMove(get_step(src, src.dir))
	else
		usr.forceMove(get_turf(src))

	usr.visible_message("<span class='warning'>[user] climbed over \the [src]!</span>")
	climbers -= user

/obj/structure/dirt_wall/can_climb(var/mob/living/user, post_climb_check=0)
	if (!(atom_flags & ATOM_FLAG_CLIMBABLE) || !can_touch(user) || (!post_climb_check && (user in climbers)))
		return FALSE

	if (!user.Adjacent(src))
		to_chat(user, "<span class='danger'>You can't climb there, the way is blocked.</span>")
		return FALSE

	return TRUE


//NON DIRT BARRICADES

/obj/structure/warfare/barricade
	name = "barricade"
	desc = "it stops you from moving"
	icon = 'icons/obj/warfare.dmi'
	plane = ABOVE_OBJ_PLANE
	layer = BASE_ABOVE_OBJ_LAYER
	anchored = TRUE

/obj/structure/warfare/barricade/concrete_barrier
	name = "concrete barrier"
	desc = "Very effective at blocking bullets, but it gets in the way."
	icon_state = "concrete_block"


/obj/structure/warfare/barricade/New()
	..()
	if(dir == SOUTH)
		plane = ABOVE_HUMAN_PLANE


/obj/structure/warfare/barricade/CheckExit(atom/movable/O, turf/target)
	if(istype(O, /obj/item/projectile))//Blocks bullets unless you're ontop of it.
		var/obj/item/projectile/proj = O
		if(proj.firer.resting)//No resting and shooting over these.
			qdel(proj)
			return FALSE
		if(proj.firer && Adjacent(proj.firer))
			return TRUE
	if(get_dir(loc, target) & dir)
		return FALSE
	else
		return TRUE

/obj/structure/warfare/barricade/CanPass(atom/movable/mover, turf/target)
	if(istype(mover, /obj/item/projectile))//Blocks bullets unless you're ontop of it.
		var/obj/item/projectile/proj = mover

		if(proj.firer.resting)//No resting and shooting over these.
			return FALSE

		if(proj.firer && Adjacent(proj.firer))
			return TRUE

		if (get_dist(proj.starting, loc) <= 1)
			return TRUE

		return FALSE

	var/obj/structure/S = locate(/obj/structure) in get_turf(mover)
	if(S && !(S.atom_flags & ATOM_FLAG_CHECKS_BORDER) && isliving(mover)) //Climbable objects allow you to universally climb over others
		return TRUE

	if(get_dir(loc, target) & dir)
		return FALSE
	else
		return TRUE


//Bullshit snowflake stuff for climbing over it.
/obj/structure/warfare/barricade/do_climb(var/mob/living/user)
	if(!can_climb(user))
		return

	user.visible_message("<span class='warning'>[user] starts climbing onto \the [src]!</span>")
	climbers |= user

	if(!do_after(user,(issmall(user) ? 20 : 30)))
		climbers -= user
		return

	if(!can_climb(user, post_climb_check=1))
		climbers -= user
		return

	if(!neighbor_turf_passable())
		to_chat(user, "<span class='danger'>You can't climb there, the way is blocked.</span>")
		climbers -= user
		return

	if(get_turf(user) == get_turf(src))
		user.forceMove(get_step(src, src.dir))
	else
		user.forceMove(get_turf(src))

	user.visible_message("<span class='warning'>[user] climbed over \the [src]!</span>")
	climbers -= user

/obj/structure/warfare/barricade/can_climb(var/mob/living/user, post_climb_check=0)
	if (!(atom_flags & ATOM_FLAG_CLIMBABLE) || !can_touch(user) || (!post_climb_check && (user in climbers)))
		return FALSE

	if (!user.Adjacent(src))
		to_chat(user, "<span class='danger'>You can't climb there, the way is blocked.</span>")
		return FALSE

	return TRUE


//BARBWIRE

/obj/item/stack/barbwire
	name = "barbed wire"
	desc = "Use this to place down barbwire in front of your position."
	icon = 'icons/obj/warfare.dmi'
	icon_state = "barbwire_item"
	amount = 5
	max_amount = 5
	w_class = ITEM_SIZE_LARGE //fuck off you're not putting 30 stacks in your satchel

/obj/item/stack/barbwire/attack_self(var/mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	var/obj/item/organ/external/affecting = H.get_organ(pick("l_arm", "r_arm", "l_hand", "r_hand")) //pick limb to get cut for failed skillcheck
	var/turf/T = get_step(user, user.dir)

	if(T)
		if(isopenspace(T))
			return
		if(turf_contains_dense_objects(T) || iswall(T)) //no 20 structures of barbed wire in one tile/in walls
			to_chat(H, "There's already something there!")
			return
		for(var/obj/structure/object in T)
			to_chat(H, "There's already something there!")
			return
		visible_message("[user] begins to place the [src]!")
		if(do_after(user, 20)) //leave it in this statement, dont want people getting cut for getting bumped/moving during assembly
			if(H.statscheck(skills = H.SKILL_LEVEL(engineering)) > CRIT_FAILURE) //Considering how useless barbwire seems to be, everyone can now spam it.
				to_chat(H, "You assemble the [src]!")
				amount--
				if(amount<=0)
					qdel(src)
				new /obj/structure/barbwire(T)
				return
			else
				playsound(loc, 'sound/effects/glass_step.ogg', 50, TRUE)
				if (affecting.status & ORGAN_ROBOT)
					return
				if (affecting.take_damage(3, FALSE)) //stop trying to put down barb wire without the skill dumbass
					H.UpdateDamageIcon()
				H.updatehealth()
				to_chat(H, "You fail to assemble the [src], cutting your [affecting.name]!")

/obj/structure/barbwire
	name = "barbed wire"
	desc = "Passing through this looks painful."
	icon = 'icons/obj/warfare.dmi'
	icon_state = "barbwire"
	anchored = TRUE
	plane = ABOVE_HUMAN_PLANE
	layer = BASE_MOB_LAYER

/obj/structure/barbwire/ex_act(severity)
	switch (severity)
		if (3)
			if (prob(50))
				qdel(src)
		else
			qdel(src)

/obj/structure/barbwire/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	return TRUE

/obj/structure/barbwire/Crossed(AM as mob|obj)
	if (ismob(AM))
		var/mob/M = AM
		if (ishuman(M))
			var/mob/living/carbon/human/H = M
			if (prob (33))
				playsound(loc, "stab_sound", 50, TRUE)
				var/obj/item/organ/external/affecting = H.get_organ(pick("l_foot", "r_foot", "l_leg", "r_leg"))
				if (affecting.status & ORGAN_ROBOT)
					return
				if (affecting.take_damage(3, FALSE))
					H.UpdateDamageIcon()
				H.updatehealth()
				to_chat(H, "<span class = 'red'><b>Your [affecting.name] gets slightly cut by \the [src]!</b></span>")
			else if (prob (33))
				playsound(loc, "stab_sound", 50, TRUE)
				var/obj/item/organ/external/affecting = H.get_organ(pick("l_foot", "r_foot", "l_leg", "r_leg"))
				if (affecting.status & ORGAN_ROBOT)
					return
				if (affecting.take_damage(8, FALSE))
					H.UpdateDamageIcon()
				H.updatehealth()
				to_chat(H, "<span class = 'red'><b>Your [affecting.name] gets cut by \the [src]!</b></span>")
			else
				playsound(loc, "stab_sound", 50, TRUE)
				var/obj/item/organ/external/affecting = H.get_organ(pick("l_foot", "r_foot", "l_leg", "r_leg"))
				if (affecting.status & ORGAN_ROBOT)
					return
				if (affecting.take_damage(13, FALSE))
					H.UpdateDamageIcon()
				H.updatehealth()
				to_chat(H, "<span class = 'red'><b>Your [affecting.name] gets deeply cut by \the [src]!</b></span>")
	return ..()

/obj/structure/barbwire/Uncross(AM as mob)
	if(ismob(AM))
		var/mob/M = AM
		if (ishuman(M))
			if(prob(50))
				M.visible_message("<span class='danger'>[M] struggle to free themselves from the barbed wire!</span>")
				var/mob/living/carbon/human/H = M
				playsound(loc, "stab_sound", 50, TRUE)
				var/obj/item/organ/external/affecting = H.get_organ(pick("l_foot", "r_foot", "l_leg", "r_leg"))
				if (affecting.status & ORGAN_ROBOT)
					return
				if (affecting.take_damage(8, FALSE))
					H.UpdateDamageIcon()
				H.updatehealth()
				return FALSE
			else
				M.visible_message("<span class='danger'>[M] frees themself from the barbed wire!</span>")
				return TRUE
	return ..()

/obj/structure/barbwire/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/wirecutters))
		if (anchored)
			user.visible_message("<span class = 'notice'>\The [user] starts to cut through \the [src] with [W].</span>")
			if (!do_after(user,30))
				user.visible_message("<span class = 'notice'>\The [user] decides not to cut through the \the [src].</span>")
				return
			user.visible_message("<span class = 'notice'>\The [user] finishes cutting through \the [src], destroying it!</span>") //will think about adding chance to recover barbed wire piece with engineering skill
			playsound(loc, 'sound/items/Wirecutter.ogg', 50, TRUE)
			qdel(src)
			return

	else if (istype(W, /obj/item/material/sword))
		if (anchored)
			user.visible_message("<span class = 'notice'>\The [user] starts to cut through \the [src] with [W].</span>")
			if (!do_after(user,60))
				user.visible_message("<span class = 'notice'>\The [user] decides not to cut through \the [src].</span>")
				return
			else
				user.visible_message("<span class = 'notice'>\The [user] finishes cutting through \the [src], destroying it!</span>")
				playsound(loc, 'sound/items/Wirecutter.ogg', 50, TRUE)
				qdel(src)
				return

/obj/structure/telearray
	name = "Telescope Array"
	desc = "It's a part of this strange device. Was that a goal of our expedition?"
	icon = 'icons/obj/warfare.dmi'
	anchored = TRUE
	density = TRUE
	plane = ABOVE_OBJ_PLANE
	layer = BASE_MOB_LAYER

/obj/structure/telearray/lowleft
	icon_state = "telearray_ll"

/obj/structure/telearray/lowright
	icon_state = "telearray_lr"

/obj/structure/telearray/centreleft
	icon_state = "telearray_cl"

/obj/structure/telearray/centreright
	icon_state = "telearray_cr"

/obj/structure/telearray/upperleft
	icon_state = "telearray_ul"

/obj/structure/telearray/upperright
	icon_state = "telearray_ur"

/obj/structure/anti_tank
	name = "metal barricade"
	desc = "Usually found in no man\'s land IN YOUR FUCKING WAY. It's dense enough to block bullets, don't even try to fucking shoot over it."
	icon = 'icons/obj/warfare.dmi'
	icon_state = "anti-tank"
	anchored = TRUE
	density = TRUE
	plane = ABOVE_OBJ_PLANE
	layer = BASE_MOB_LAYER
	atom_flags = ATOM_FLAG_CLIMBABLE

/obj/structure/anti_tank/can_climb(var/mob/living/user, post_climb_check=0)
	if(!iswarfare())
		return TRUE


	if(istype(get_area(src), /area/warfare/battlefield/no_mans_land))//We're trying to go into no man's land?
		if(locate(/obj/item/device/boombox) in user)//Locate the boombox.
			to_chat(user, "I can't bring this with me onto the battlefield. Wouldn't want to lose it.")//No you fucking don't.
			return //Keep that boombox at base asshole.
		if(locate(/obj/item/storage) in user)//Gotta check storage as well.
			var/obj/item/storage/S = locate() in user
			if(locate(/obj/item/device/boombox) in S)
				to_chat(user, "I can't bring this with me onto the battlefield. Wouldn't want to lose it.")
				return

	if(!SSwarfare.battle_time)
		return FALSE
	return TRUE


/obj/item/projectile/bullet/pellet/fragment/landmine
	damage = 100
	range_step = 2 //controls damage falloff with distance. projectiles lose a "pellet" each time they travel this distance. Can be a non-integer.
	base_spread = 0 //causes it to be treated as a shrapnel explosion instead of cone
	spread_step = 20
	range =  3 //dont kill everyone on the screen

/obj/item/landmine
	name = "landmine"
	desc = "Use it to place a landmine in front of you. Beee careful..."
	icon = 'icons/obj/warfare.dmi'
	icon_state = "mine_item"


/obj/item/landmine/attack_self(var/mob/user)
	var/turf/T = get_step(user, user.dir)
	if(T)
		if(isopenspace(T))
			return
		visible_message("[user] begins to place the mine!")
		if(do_after(user, 20))
			qdel(src)
			new /obj/structure/landmine(T)


/obj/structure/landmine
	name = "landmine"
	desc = "If you step on this you'll probably fucking die."
	icon = 'icons/obj/warfare.dmi'
	icon_state = "mine"
	anchored = TRUE
	density = FALSE
	var/armed = FALSE//Whether or not it will blow up.
	var/can_be_armed = TRUE//Whether or not it can be armed to blow up. Disarmed mines won't blow.

/obj/structure/landmine/New()
	..()
	if(prob(15))
		desc = "This mushroom is not for picking."

/obj/structure/landmine/proc/blow()
	GLOB.mines_tripped++
	fragmentate(get_turf(src), 20, 2, list(/obj/item/projectile/bullet/pellet/fragment/landmine))
	explosion(loc, 1, 1, 1, 1)
	qdel(src)


/obj/structure/landmine/update_icon()
	if(!can_be_armed)
		icon_state = "mine_disarmed"


/obj/structure/landmine/attackby(obj/item/W as obj, mob/user as mob)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(istype(W, /obj/item/wirecutters))
		if(!can_be_armed)
			return
		H.visible_message("<span class='danger'>[H] begins to disarm the landmine...</span>")
		if(do_after(user,50))
			if(H.statscheck(skills = H.SKILL_LEVEL(engineering)) >= SUCCESS)
				armed = FALSE
				can_be_armed = FALSE
				to_chat(H, "You successfully disarm the [src]")
				GLOB.mines_disarmed++
				playsound(src, 'sound/items/Wirecutter.ogg', 100, FALSE)
				update_icon()
				return
			blow()
	if(istype(W, /obj/item/shovel))
		if(!can_be_armed)
			H.visible_message("<span class='danger'>[H] begins to dig up the landmine...</span>")
			playsound(src, 'sound/effects/dig_shovel.ogg', 40, FALSE)
			if(do_after(user,50))
				to_chat(H, "You successfully dig up the [src]")
				qdel(src)
		return

/obj/structure/landmine/Crossed(var/mob/living/M as mob)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.isChild())//Kids don't set off landmines.
			return
		if(!M.throwing && !armed && can_be_armed)
			to_chat(M, "<span class='danger'>You hear a sickening click!</span>")
			playsound(src, 'sound/effects/mine_arm.ogg', 100, FALSE)
			armed = TRUE

/obj/structure/landmine/Uncrossed(var/mob/living/M as mob)
	if(istype(M))
		if(armed)
			blow()



//Activate this to win!
/obj/structure/destruction_computer
	name = "Point Of No Return"
	desc = "DON'T LET THE ENEMY TOUCH THIS!"
	icon = 'icons/obj/warfare.dmi'
	icon_state = "destruct"
	anchored = TRUE
	density = TRUE
	var/faction = null
	var/activated = FALSE
	var/countdown_time
	var/doomsday_timer

/obj/structure/destruction_computer/New()
	..()
	name = "[faction] [name]"
	countdown_time = config.warfare_end_time MINUTES //Countdown time is in minutes because seconds is FUCKED.

/obj/structure/destruction_computer/attack_hand(mob/user)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.warfare_faction == faction)
			if(!activated)
				return
			if(!H.doing_something)
				H.doing_something = TRUE
				if(do_after(H,100))
					user.unlock_achievement(new/datum/achievement/deactivate())
					activated = FALSE
					deltimer(doomsday_timer)
					to_world(uppertext("<big>[H.warfare_faction] have disarmed the [src]!</big>"))
					playsound(src, 'sound/effects/mine_arm.ogg', 100, FALSE)
					sound_to(world, 'sound/effects/ponr_activate.ogg')
					H.doing_something = FALSE
				H.doing_something = FALSE
			else
				to_chat(H, "I'm already disarming the device!")

		else
			if(activated)
				return
			if(!H.doing_something)
				H.doing_something = TRUE
				if(do_after(H, 30))
					user.unlock_achievement(new/datum/achievement/point_of_no_return())
					playsound(src, 'sound/effects/mine_arm.ogg', 100, FALSE)
					sound_to(world, 'sound/effects/ponr_activate.ogg')
					to_world(uppertext("<big>[H.warfare_faction] have activated the [src]! They will achieve victory in [countdown_time/10] seconds!</big>"))
					activated = TRUE
					doomsday_timer = addtimer(CALLBACK(src,/obj/structure/destruction_computer/proc/kaboom), countdown_time, TIMER_STOPPABLE|TIMER_UNIQUE|TIMER_NO_HASH_WAIT|TIMER_OVERRIDE)
					H.doing_something = FALSE
				H.doing_something = FALSE
			else
				to_chat(H, "I'm already arming the device!")

/obj/structure/destruction_computer/proc/kaboom()
	SSwarfare.end_warfare(faction)//really simple I know.

/obj/structure/destruction_computer/red
	faction = RED_TEAM

/obj/structure/destruction_computer/blue
	faction = BLUE_TEAM


/obj/structure/banner
	name = "Banner"
	desc = "The glorious banner of uh... your side."
	icon = 'icons/obj/stationobjs.dmi'
	anchored = TRUE
	density = FALSE
	plane = ABOVE_HUMAN_PLANE
	layer = ABOVE_HUMAN_LAYER

/obj/structure/banner/red
	icon_state = "red"

/obj/structure/banner/red/small
	icon_state = "redsmall"

/obj/structure/banner/blue
	icon_state = "blue"

/obj/structure/banner/blue/small
	icon_state = "bluesmall"