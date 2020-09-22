// Dumbass's code. For first time.

/obj/machinery/sunreactor
	name = "Atomic Reactor"
	desc = "Part of a 'Sun Reactor'."
	icon = 'icons/obj/machines/particle_accelerator.dmi'
	icon_state = "none"
	anchored = 1
	density = 1
	var/desc_holder = null

/obj/machinery/sunreactor/emitter/
	name = "Emitter"
	desc_holder = "Wireless beam generator, might not want to stand near this end."
	icon = 'icons/obj/machines/sunreactor.dmi'
	icon_state = "emitter_offline"
	var/fire_delay = 50
	var/last_shot = 0
	var/safety = 1

/obj/machinery/sunreactor/emitter/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/wrench))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
		if(safety == 1)
			safety = 0
			user.visible_message("[user.name] secures [src.name].", \
				"You turn the [src.name] powerswitch to 'ON', now it'll produse a beams.", \
				"You hear a ratchet")
		else
			safety = 1
			user.visible_message("[user.name] unsecures [src.name] from the floor.", \
				"You turn the [src.name] powerswitch to 'OFF'.", \
				"You hear a ratchet")
		return


/obj/machinery/sunreactor/emitter/proc/emit_particle(var/strength = 0)
	if((src.last_shot + src.fire_delay) <= world.time)
		src.last_shot = world.time
		var/obj/effect/accelerated_particle/A = null
		var/turf/T = get_step(src,dir)
		switch(strength)
			if(0)
				if(src.safety == 0)
					A = new/obj/effect/accelerated_particle/weak(T, dir)
					playsound(src.loc, 'sound/weapons/emitter2.ogg', 25, 1)
				else
					A = new/obj/effect/sparks(src.loc)
			if(1)
				if(src.safety == 0)
					A = new/obj/effect/accelerated_particle(T, dir)
					playsound(src.loc, 'sound/weapons/emitter2.ogg', 25, 1)
				else
					A = new/obj/effect/sparks(src.loc)
			if(2)
				if(src.safety == 0)
					A = new/obj/effect/accelerated_particle/strong(T, dir)
					playsound(src.loc, 'sound/weapons/emitter2.ogg', 25, 1)
				else
					A = new/obj/effect/sparks(src.loc)
		if(A)
			A.dir = src.dir
			return 1
	return 0

/obj/machinery/sunreactor/emitter/proc/set_delay(var/delay)
	if(delay && delay >= 0)
		src.fire_delay = delay
		return 1
	return 0


/obj/machinery/sunreactor/emitter/update_icon()
	..()
	return

/obj/machinery/sunreactor/rleft
	name = "Core stabilizer"
	desc_holder = "It's perfect."
	icon = 'icons/obj/machines/sunreactor.dmi'
	icon_state = "rear_e_1"
	use_power = 0
	var/energy = 0

/obj/machinery/sunreactor/rleft/Process()
//	get_turf(src)
	if((src.energy >= 20)&(src.energy <100))
		icon_state = "rear_e_2"
		playsound(src.loc, 'sound/effects/reactor.ogg', 75, 1)
		src.energy += 100
		sleep(30)
		icon_state = "rear_e_3"

/obj/machinery/sunreactor/rright
	name = "Core stabilizer"
	desc_holder = "It's perfect."
	icon = 'icons/obj/machines/sunreactor.dmi'
	icon_state = "rear_w_1"
	use_power = 0
	var/energy = 0

/obj/machinery/sunreactor/rright/Process()
//	get_turf(src)
	if((src.energy >= 45)&(src.energy < 100))
		icon_state = "rear_w_2"
		playsound(src.loc, 'sound/effects/reactor.ogg', 75, 1)
		src.energy += 100
		sleep(30)
		icon_state = "rear_w_3"

/obj/machinery/sunreactor/rdown
	name = "Core stabilizer"
	desc_holder = "It's perfect."
	icon = 'icons/obj/machines/sunreactor.dmi'
	icon_state = "rear_n_1"
	use_power = 0
	var/energy = 0

/obj/machinery/sunreactor/rdown/Process()
//	get_turf(src)
	if((src.energy >= 60)&(src.energy < 100))
		icon_state = "rear_n_2"
		playsound(src.loc, 'sound/effects/reactor.ogg', 75, 1)
		src.energy += 100
		sleep(30)
		icon_state = "rear_n_3"

/obj/machinery/sunreactor/rup
	name = "Core stabilizer"
	desc_holder = "It's perfect."
	icon = 'icons/obj/machines/sunreactor.dmi'
	icon_state = "rear_s_1"
	use_power = 0
	var/energy = 0

/obj/machinery/sunreactor/rup/Process()
//	get_turf(src)
	if((src.energy >= 75)&(src.energy < 100))
		icon_state = "rear_s_2"
		playsound(src.loc, 'sound/effects/reactor.ogg', 75, 1)
		src.energy += 100
		sleep(30)
		icon_state = "rear_s_3"

/obj/machinery/sunreactor/tube_h
	name = "Tube"
	desc_holder = "It's tube."
	icon = 'icons/obj/machines/sunreactor.dmi'
	icon_state = "t_h"
	use_power = 0

/obj/machinery/sunreactor/tube_v
	name = "Tube"
	desc_holder = "It's tube."
	icon = 'icons/obj/machines/sunreactor.dmi'
	icon_state = "t_v"
	use_power = 0

/obj/machinery/sunreactor/tube_g_h_l
	name = "Tube"
	desc_holder = "It's tube."
	icon = 'icons/obj/machines/sunreactor.dmi'
	icon_state = "t_glass_h_1"
	use_power = 0

/obj/machinery/sunreactor/tube_g_h_r
	name = "Tube"
	desc_holder = "It's tube."
	icon = 'icons/obj/machines/sunreactor.dmi'
	icon_state = "t_glass_h_1"
	use_power = 0

/obj/machinery/sunreactor/tube_g_v_u
	name = "Tube"
	desc_holder = "It's tube."
	icon = 'icons/obj/machines/sunreactor.dmi'
	icon_state = "t_glass_v_1"
	use_power = 0

/obj/machinery/sunreactor/tube_g_v_d
	name = "Tube"
	desc_holder = "It's tube."
	icon = 'icons/obj/machines/sunreactor.dmi'
	icon_state = "t_glass_v_1"
	use_power = 0

/obj/machinery/particle_accelerator/examine()
	src.desc = src.desc_holder
	..()
	return

/obj/machinery/sunreactor/core
	name = "Core"
	desc_holder = "It's reactor Core."
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "bluespace"
	layer = 6
	density = 0
	use_power = 0

/obj/machinery/sunreactor/beam
	name = "Light beam"
	desc_holder = "Just a light."
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "reactorbeam"
	use_power = 0
	density = 0
	invisibility = 100
	luminosity = 0

/obj/machinery/sunreactor/beam/New()
	set_light(2, 1.5, "#00f9ff")


/obj/machinery/sunreactor/core/New()
	var/list/L = list(  )
	var/list/turfs = list(	)
	for(var/turf/T in orange(10))
		if(T.x>world.maxx-8 || T.x<8)	continue	//putting them at the edge is dumb
		if(T.y>world.maxy-8 || T.y<8)	continue
		turfs += T
	if(turfs.len)
		L["None (Dangerous)"] = pick(turfs)
	//var/t1 = input(src, "Please select a teleporter to lock in on.", "Hand Teleporter") in L
	var/T = L["None (Dangerous)"]
	var/obj/effect/portal/P = new /obj/effect/portal( get_turf(src) )
	P.target = T
	P.creator = src
	P.name = "Core"
	P.icon = 'icons/obj/projectiles.dmi'
	P.icon_state = "bluespace"
	set_light(2, 5, "#00f9ff")
	return
	for(var/atom/A in src.loc)
		if(!istype(A, /obj/machinery/sunreactor/center))
			sleep (rand(50,100))
			explosion(src.loc,-1,-1,2)
			qdel(src)
			set_light(0)

/obj/machinery/sunreactor/center
	name = "Plasma generator"
	desc_holder = "It generates plasma. Stay out."
	icon = 'icons/obj/machines/sunreactor.dmi'
	icon_state = "r_c_1"
	anchored = 1
	density = 1
	luminosity = 6
	unacidable = 1 //Don't comment this out.
	use_power = 0
	var/current_size = 1
	var/allowed_size = 1
	var/contained = 1 //Are we going to move around?
	var/energy = 0 //How strong are we?
	var/dissipate = 1 //Do we lose energy over time?
	var/dissipate_delay = 10
	var/dissipate_track = 0
	var/dissipate_strength = 1 //How much energy do we lose?
	var/move_self = 0 //Do we move on our own?
	var/grav_pull = 4 //How many tiles out do we pull?
	var/consume_range = 0 //How many tiles out do we eat
	var/event_chance = 15 //Prob for event each tick
	var/target = null //its target. moves towards the target if it has one
	var/last_failed_movement = 0//Will not move in the same dir if it couldnt before, will help with the getting stuck on fields thing
	var/teleport_del = 0
	var/last_warning

/obj/machinery/sunreactor/center/attack_hand(mob/user as mob)
	consume(user)
	return 1

/obj/machinery/sunreactor/center/ex_act(severity)
	switch(severity)
		if(1.0)
			if(prob(25))
				qdel(src)
				return
				set_light(0)
			else
				energy += 50
		if(2.0 to 3.0)
			energy += round((rand(20,60)/2),1)
			return
	return


/obj/machinery/sunreactor/center/Bump(atom/A)
	consume(A)
	return


/obj/machinery/sunreactor/center/Bumped(atom/A)
	consume(A)
	return


/obj/machinery/sunreactor/center/Process()
//	eat()
	dissipate()
	check_energy()
	if(current_size >= 3)
		//move()
		pulse()
		if(prob(event_chance))//Chance for it to run a special event TODO:Come up with one or two more that fit
			event()
	return


/obj/machinery/sunreactor/center/attack_ai() //to prevent ais from gibbing themselves when they click on one.
	return

/obj/machinery/sunreactor/center/proc/dissipate()
	if(!dissipate)
		return
	if(dissipate_track >= dissipate_delay)
		var/turf/Under
		Under = get_turf(src)
		src.energy -= dissipate_strength*(290/Under.temperature)
		dissipate_track = 0
	else
		dissipate_track++

/obj/machinery/sunreactor/center/proc/reactor_explosion()
	explosion(src.loc,5,9,12)
	del(src)


/obj/machinery/sunreactor/center/proc/reactor_rad()

	for(var/mob/living/carbon/human/H in GLOB.living_mob_list_)
		var/turf/T = get_turf(H)
		if(!T)
			continue
		if(T.z != 1)
			continue
		if(istype(H,/mob/living/carbon/human))
			H.apply_effect((rand(15,75)),IRRADIATE,0)
			if (prob(5))
				H.apply_effect((rand(90,150)),IRRADIATE,0)
			if (prob(25))
				if (prob(75))
					randmutb(H)
					domutcheck(H,null,1)
				else
					randmutg(H)
					domutcheck(H,null,1)
	for(var/mob/living/carbon/human/monkey/M in GLOB.living_mob_list_)
		var/turf/T = get_turf(M)
		if(!T)
			continue
		if(T.z != 1)
			continue
		M.apply_effect((rand(15,75)),IRRADIATE,0)
	sleep(100)
	for(var/mob/M in GLOB.player_list)
		M << sound('sound/AI/radiation.ogg')

/obj/machinery/sunreactor/center/proc/expand(var/force_size = 0)
	var/temp_allowed_size = src.allowed_size
	if(force_size)
		temp_allowed_size = force_size
	switch(temp_allowed_size)
		if(1)
			current_size = 1
			icon = 'icons/obj/machines/sunreactor.dmi'
			icon_state = "r_c_2"
			pixel_x = 0
			pixel_y = 0
			grav_pull = 4
			consume_range = 0
			dissipate_delay = 10
			dissipate_track = 0
			dissipate_strength = 1
			set_light(0)
		if(3)
			current_size = 3
			icon = 'icons/obj/machines/sunreactor.dmi'
			icon_state = "r_c_3"
			pixel_x = 0
			pixel_y = 0
			grav_pull = 6
			consume_range = 1
			dissipate_delay = 5
			dissipate_track = 0
			dissipate_strength = 5
			set_light(0)
			set_light(2, 1.5, "#00f9ff")
		if(5)
			current_size = 5
			icon = 'icons/obj/machines/sunreactor.dmi'
			icon_state = "r_c_3"
			pixel_x = 0
			pixel_y = 0
			grav_pull = 8
			consume_range = 2
			dissipate_delay = 4
			dissipate_track = 0
			dissipate_strength = 20
			set_light(0)
			set_light(2, 1.5, "#00f9ff")
			new/obj/machinery/sunreactor/core(src.loc)

		if(7)
			current_size = 7
			icon = 'icons/obj/machines/sunreactor.dmi'
			icon_state = "r_c_3"
			pixel_x = 0
			pixel_y = 0
			grav_pull = 10
			consume_range = 3
			dissipate_delay = 10
			dissipate_track = 0
			dissipate_strength = 10
			set_light(0)
			set_light(2, 1.5, "#00f9ff")
			for(var/mob/M in GLOB.player_list)
				M << sound('sound/effects/siren.ogg')
			sleep(20)
			new/obj/effect/effect/smoke(src.loc)
			sleep(20)
			new/obj/effect/effect/smoke(src.loc)

		if(9)
			current_size = 9
			icon = 'icons/obj/machines/sunreactor.dmi'
			icon_state = "r_c_3"
			pixel_x = 0
			pixel_y = 0
			grav_pull = 10
			consume_range = 4
			dissipate = 0 //It cant go smaller due to e loss
			reactor_rad()
		//	sleep(200)
			reactor_explosion()
			set_light(0)
			set_light(2, 1.5, "#00f9ff")
			qdel(src)
	if(current_size == allowed_size)
		investigate_log("<font color='red'>grew to size [current_size]</font>","singulo")
		return 1
	else if(current_size < (--temp_allowed_size))
		expand(temp_allowed_size)
	else
		return 0


/obj/machinery/sunreactor/center/proc/check_energy()

	switch(energy)//Some of these numbers might need to be changed up later -Mport
		if(1 to 149)
			allowed_size = 1
		if(150 to 299)
			allowed_size = 3
		if(300 to 499)
			allowed_size = 5
		if(500 to 569)
			allowed_size = 7
		if(570 to INFINITY)
			allowed_size = 9
	if(current_size != allowed_size)
		expand()
	return 1

/obj/machinery/sunreactor/center/proc/consume(var/atom/A)
	var/gain = 0
	if (istype(A,/mob/living))//Mobs get gibbed
		gain = 20
		if(istype(A,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = A
			if(H.mind)

				if((H.mind.assigned_role == "Station Engineer") || (H.mind.assigned_role == "Chief Engineer") )
					gain = 100

				if(H.mind.assigned_role == "Clown")
					gain = rand(-300, 300) // HONK

		spawn()
			A:gib()
		sleep(1)
	else if(istype(A,/obj/))

		if (istype(A,/obj/item/storage/backpack/holding))
			var/dist = max((current_size - 2),1)
			explosion(src.loc,(dist),(dist*2),(dist*4))
			return

		if((teleport_del) && (!istype(A, /obj/machinery)))//Going to see if it does not lag less to tele items over to Z 2
			var/obj/O = A
			O.x = 2
			O.y = 2
			O.z = 2
		else
			A.ex_act(1.0)
			if(A) del(A)
		gain = 2
	else if(isturf(A))
		var/turf/T = A
		for(var/obj/O in T.contents)
			if(O.level != 1)
				continue
			if(O.invisibility == 101)
				src.consume(O)
		T.ChangeTurf(/turf/simulated/floor/plating/)
		gain = 2
	src.energy += gain
	return


/obj/machinery/sunreactor/center/proc/move(var/force_move = 0)
	if(!move_self)
		return 0

	var/movement_dir = pick(GLOB.alldirs - last_failed_movement)

	if(force_move)
		movement_dir = force_move

	if(target && prob(60))
		movement_dir = get_dir(src,target) //moves to a singulo beacon, if there is one

	if(current_size >= 9)//The superlarge one does not care about things in its way
		spawn(0)
			step(src, movement_dir)
		spawn(1)
			step(src, movement_dir)
		return 1
	else if(check_turfs_in(movement_dir))
		last_failed_movement = 0//Reset this because we moved
		spawn(0)
			step(src, movement_dir)
		return 1
	else
		last_failed_movement = movement_dir
	return 0


/obj/machinery/sunreactor/center/proc/check_turfs_in(var/direction = 0, var/step = 0)
	if(!direction)
		return 0
	var/steps = 0
	if(!step)
		switch(current_size)
			if(1)
				steps = 1
			if(3)
				steps = 3//Yes this is right
			if(5)
				steps = 3
			if(7)
				steps = 4
			if(9)
				steps = 5
	else
		steps = step
	var/list/turfs = list()
	var/turf/T = src.loc
	for(var/i = 1 to steps)
		T = get_step(T,direction)
	if(!isturf(T))
		return 0
	turfs.Add(T)
	var/dir2 = 0
	var/dir3 = 0
	switch(direction)
		if(NORTH||SOUTH)
			dir2 = 4
			dir3 = 8
		if(EAST||WEST)
			dir2 = 1
			dir3 = 2
	var/turf/T2 = T
	for(var/j = 1 to steps)
		T2 = get_step(T2,dir2)
		if(!isturf(T2))
			return 0
		turfs.Add(T2)
	for(var/k = 1 to steps)
		T = get_step(T,dir3)
		if(!isturf(T))
			return 0
		turfs.Add(T)
	for(var/turf/T3 in turfs)
		if(isnull(T3))
			continue
		if(!can_move(T3))
			return 0
	return 1


/obj/machinery/sunreactor/center/proc/can_move(var/turf/T)
	if(!T)
		return 0
	if((locate(/obj/machinery/containment_field) in T)||(locate(/obj/machinery/shieldwall) in T))
		return 0
	else if(locate(/obj/machinery/field_generator) in T)
		var/obj/machinery/field_generator/G = locate(/obj/machinery/field_generator) in T
		if(G && G.active)
			return 0
	else if(locate(/obj/machinery/shieldwallgen) in T)
		var/obj/machinery/shieldwallgen/S = locate(/obj/machinery/shieldwallgen) in T
		if(S && S.active)
			return 0
	return 1


/obj/machinery/sunreactor/center/proc/event()
	var/numb = pick(1,2,3,4,5,6)
	switch(numb)
		if(1)//EMP
			emp_area()
		if(2,3)//tox damage all carbon mobs in area
			toxmob()
		if(4)//Stun mobs who lack optic scanners
			mezzer()
		else
			return 0
	return 1


/obj/machinery/sunreactor/center/proc/toxmob()
	var/toxrange = 10
	var/toxdamage = 4
	var/radiation = 15
	var/radiationmin = 3
	if (src.energy>200)
		toxdamage = round(((src.energy-150)/50)*4,1)
		radiation = round(((src.energy-150)/50)*5,1)
		radiationmin = round((radiation/5),1)//
	for(var/mob/living/M in view(toxrange, src.loc))
		M.apply_effect(rand(radiationmin,radiation), IRRADIATE)
		toxdamage = (toxdamage - (toxdamage*M.getarmor(null, "rad")))
		M.apply_effect(toxdamage, TOX)
	return


/obj/machinery/sunreactor/center/proc/mezzer()
	for(var/mob/living/carbon/M in oviewers(8, src))
		if(istype(M, /mob/living/carbon/brain)) //Ignore brains
			continue

		if(M.stat == CONSCIOUS)
			if (istype(M,/mob/living/carbon/human))
				var/mob/living/carbon/human/H = M
				if(istype(H.glasses,/obj/item/clothing/glasses/meson))
					H << "\blue You look directly into The [src.name], good thing you had your protective eyewear on!"
					return
		M << "\red You look directly into The [src.name] and feel weak."
		M.apply_effect(3, STUN)
		for(var/mob/O in viewers(M, null))
			O.show_message(text("\red <B>[] stares blankly at The []!</B>", M, src), 1)
	return


/obj/machinery/sunreactor/center/proc/emp_area()
	empulse(src, 4, 8)
	return


/obj/machinery/sunreactor/center/proc/pulse()

	for(var/obj/machinery/power/rad_collector/R in rad_collectors)
		if(get_dist(R, src) <= 15) // Better than using orange() every process
			R.receive_pulse(energy)
	return