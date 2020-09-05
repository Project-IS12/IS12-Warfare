/datum/event/invasion
	endWhen = 300
	var/drones

	var/list/spawned_skinless = list()

/datum/event/invasion/New()
	..()
	if(prob(50))
		drones = TRUE

/datum/event/invasion/announce()
	if(drones)
		threat_announcement.Announce("Hostile mining drones detected ascending from the surface! Please watch out for any portals on [station_name()]!", "[station_name()] Sensor Array")
	else
		threat_announcement.Announce("Hostile invaders detected ascending from the surface! Please watch out for any portals on [station_name()]!", "[station_name()] Sensor Array")

/datum/event/invasion/start()
	if(severity == EVENT_LEVEL_MAJOR)
		spawn_skinless(landmarks_list.len)
	else if(severity == EVENT_LEVEL_MODERATE)
		spawn_skinless(rand(4, 6)) 			//12 to 30 carp, in small groups
	else
		spawn_skinless(rand(1, 3), 1, 2)	//1 to 6 carp, alone or in pairs

/datum/event/invasion/proc/spawn_skinless(var/num_groups, var/group_size_min=3, var/group_size_max=5)
	var/list/spawn_locations = list()

	for(var/obj/effect/landmark/C in landmarks_list)
		if(C.name == "skinless")
			spawn_locations.Add(C.loc)
			new /obj/effect/fake_portal(C.loc)
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
					spawned_skinless.Add(new /mob/living/carbon/human/skinless(spawn_locations[i]))
			i++
		else
			group_size = max(1,round(group_size/6))
			group_size = min(spawn_locations.len-i+1,group_size)
			for(var/j = 1, j <= group_size, j++)
				if(drones)
					spawned_skinless.Add(new /obj/random/mining_hostile(spawn_locations[i+j]))
				else
					spawned_skinless.Add(new /mob/living/carbon/human/skinless(spawn_locations[i+j]))
			i += group_size

/datum/event/invasion/invasion/end()
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