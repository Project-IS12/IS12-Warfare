/datum/event/mortar
	announceWhen = 0
	var/area/area_hit

/datum/event/gravity/mortar
	endWhen = 50

/datum/event/mortar/start()

	area_hit = pick(GLOB.mortar_areas)

	var/mortar_type = pick("gas", "shrapnel") // , "fire") //Fire lags the entire game, have to remove it for now.
	to_chat(world, uppertext("<font size=5><b>INCOMING!! [area_hit.name]!!</b></font>"))
	for(var/i = 1, i<4, i++)
		sound_to(world, 'sound/effects/arty_distant.ogg')
		sleep(30)

	if(aspect_chosen(/datum/aspect/somme)) // needs less gas because fuck me it lags the game on somme mode
		if(prob(5))
			mortar_type = "gas"
		else
			mortar_type = "shrapnel"

	switch(mortar_type)
		if("shrapnel")
			if(aspect_chosen(/datum/aspect/somme))
				for(var/i = 1, i<24, i++)//three guns shoot three extra rounds each
					var/turf/T = pick(get_area_turfs(area_hit))

					drop_mortar(T, mortar_type)
					sleep(10)
			else for(var/i = 1, i<15, i++)//No man's land is a big area so drop a lot of shells.
				var/turf/T = pick(get_area_turfs(area_hit))

				drop_mortar(T, mortar_type)
				sleep(10)

		if("gas")
			for(var/i = 1, i<5, i++)//Only do this five times to reduce lag.
				var/turf/T = pick(get_area_turfs(area_hit))

				drop_mortar(T, mortar_type)
				sleep(10)

		if("fire")
			for(var/i = 1, i<15, i++)//15 fire shells, going hot!
				var/turf/T = pick(get_area_turfs(area_hit))

				drop_mortar(T, mortar_type)
				sleep(10)
