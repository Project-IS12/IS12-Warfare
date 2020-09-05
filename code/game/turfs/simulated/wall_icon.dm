/atom/proc/relativewall_neighbours()
	for(var/turf/simulated/W in range(src,1))
		if(W.can_smooth)
			W.relativewall()
	return

/atom/proc/relativewall()
	var/junction = 0
	if(!istype(src,/turf/simulated/shuttle/wall))
		for(var/turf/simulated/W in orange(src,1))
			if(!W.can_smooth)
				continue
			if(abs(src.x-W.x)-abs(src.y-W.y))
				junction |= get_dir(src,W)


//We use this so we can smooth floor
/turf/simulated
	var/can_smooth = FALSE

/turf/simulated/wall/Del()

	var/temploc = src.loc

	spawn(10)
		for(var/turf/simulated/wall/W in range(temploc,1))
			W.relativewall()

		//for(var/obj/structure/falsewall/W in range(temploc,1)) will do it later
		//	W.relativewall()
	..()

/turf/simulated/wall/relativewall()
	var/junction = 0

	for(var/turf/simulated/wall/W in orange(src,1))
		if(abs(src.x-W.x)-abs(src.y-W.y))
			if(src.mineral == W.mineral)
				junction |= get_dir(src,W)
	//var/turf/simulated/wall/wall = src
	icon_state = "[walltype][junction]"
	return
