/datum/event/zombies
	endWhen = 300
	var/drones

	var/list/spawned_skinless = list()

/datum/event/zombies/New()
	..()
	if(prob(50))
		drones = TRUE

/datum/event/zombies/start()
	//GLOB.zombie_round++
	to_world("<font size=5><b><span class='danger'>FETCH ME THEIR SOULS!!</span></b></font>")
	//to_world('sound/ambience/survival_begin.ogg')
	//to_world("Wave: [GLOB.zombie_round]")
	if(severity == EVENT_LEVEL_MAJOR)
		spawn_skinless(landmarks_list.len)
	spawn_skinless(rand(4, 6))

/datum/event/zombies/proc/spawn_skinless(var/num_groups, var/group_size_min=3, var/group_size_max=5)
	var/list/spawn_locations = list()

	for(var/obj/effect/landmark/C in landmarks_list)
		if(C.name == "skinless")
			spawn_locations.Add(C.loc)
			//new /obj/effect/fake_portal(C.loc)
	spawn_locations = shuffle(spawn_locations)
	num_groups = min(num_groups, spawn_locations.len)

	var/i = 1
	while (i <= num_groups)
		var/group_size = rand(group_size_min, group_size_max)
		if(prob(96))
			for (var/j = 1, j <= group_size, j++)
				if(drones)
					spawned_skinless.Add(new /obj/random/mining_hostile(spawn_locations[i]))
				else
					spawned_skinless.Add(new /mob/living/simple_animal/hostile/mining_borg/minesect(spawn_locations[i]))
			i++
		else
			group_size = max(1,round(group_size/6))
			group_size = min(spawn_locations.len-i+1,group_size)
			for(var/j = 1, j <= group_size, j++)
				if(drones)
					spawned_skinless.Add(new /obj/random/mining_hostile(spawn_locations[i+j]))
				else
					spawned_skinless.Add(new /mob/living/simple_animal/hostile/mining_borg/minesect(spawn_locations[i+j]))
			i += group_size

/*
/datum/event/zombies/end()
	for(var/obj/effect/fake_portal/F in world)
		qdel(F)


/obj/effect/fake_portal
	name = "portal"
	desc = "Seems to be one way."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "portal"
	density = TRUE
	unacidable = TRUE//Can't destroy energy portals.
	anchored = TRUE
*/