/mob/living/simple_animal/hostile/mining_borg
	name = "rogue mining drone"
	desc = "Leftover from hundreds of years ago. Quite dangerous."
	icon_state = "droid"
	icon_living = "droid"
	icon_dead = "droid_dead"
	speak = list("DESTROY!","THREAT DETECTED!","BZZZZT!","EXTERMINATE!")
	speak_emote = list("beeps", "buzzes")
	emote_hear = list("beeps","grumbles","buzzes")
	emote_see = list("stares aggresively")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	response_help  = "touches"
	response_disarm = "shoves aside"
	response_harm   = "smacks"
	stop_automated_movement_when_pulled = FALSE
	maxHealth = 200
	health = 200
	melee_damage_lower = 10
	melee_damage_upper = 25
	attack_sound = 'sound/weapons/circsawhit.ogg'
	attacked_sound = "sparks"
	speed = 1
	dodge_chance = 0 //They're big and bulky, they cannot dodge.
	bloody = FALSE //No bleeding robots please.
	delete_after_harvest = FALSE //Also don't delete them after you harvest them.
	meat_type = /obj/item/circuitboard

	var/alert_icon = null
	var/list/alert_callout = list()


	//mining borgs aren't affected by atmos.
	min_gas = null
	max_gas = null
	minbodytemp = 0
	var/stance_step = 0

	faction = "mining"



/mob/living/simple_animal/hostile/mining_borg/sleekminer
	icon_state = "sleekminer"
	icon_living = "sleekminer"
	icon_dead = "sleekminer_dead"

/mob/living/simple_animal/hostile/mining_borg/sleekengineer
	icon_state = "sleekengineer"
	icon_living = "sleekengineer"
	icon_dead = "sleekengineer_dead"

/mob/living/simple_animal/hostile/mining_borg/sleek
	icon_state = "sleek"
	icon_living = "sleek"
	icon_dead = "sleek_dead"

/mob/living/simple_animal/hostile/mining_borg/thothbot
	icon_state = "thothbot"
	icon_living = "thothbot"
	icon_dead = "thothbot_dead"


/mob/living/simple_animal/hostile/mining_borg/buff
	icon_state = "buff_scan"
	icon_living = "buff_scan"
	icon_dead = "buff_DEAD"
	icon_gib = "buff_GIB"
	alert_icon = "buff_alert"

/mob/living/simple_animal/hostile/mining_borg/thin
	icon_state = "thin_droid"
	icon_living = "thin_droid"
	icon_dead = "thin_DEAD"
	icon_gib = "thin_GIB"
	alert_icon = "thin_droidA"
	projectiletype = /obj/item/projectile/energy/laser
	projectilesound = 'sound/weapons/Laser.ogg'
	ranged = TRUE
	rapid = TRUE

/mob/living/simple_animal/hostile/mining_borg/behemoth
	name = "Rogue Securitron"
	desc = "Once employed by... some sort of corporation, these securitrons have been left to rot here for "
	icon_state = "behemoth"
	icon_living = "behemoth"
	icon_dead = "behemoth_DEAD"
	maxHealth = 300
	health = 300
	projectiletype = /obj/item/projectile/energy/laser/powerful //He shoots a big fuck you laser.
	projectilesound = 'sound/weapons/Laser.ogg'
	ranged = TRUE
	alert_callout = list('sound/voice/critters/borg_spot1.ogg', 'sound/voice/critters/borg_spot2.ogg')
	pain_sound = list('sound/voice/critters/borg_pain1.ogg', 'sound/voice/critters/borg_pain2.ogg', 'sound/voice/critters/borg_pain3.ogg')


/mob/living/simple_animal/hostile/mining_borg/Life()
	. =..()
	if(!.)
		return

	switch(stance)
		if(HOSTILE_STANCE_TIRED)
			icon_living = initial(icon_living)
			stop_automated_movement = 1
			stance_step++
			if(stance_step >= 10) //rests for 10 ticks
				if(target_mob && target_mob in ListTargets(10))
					stance = HOSTILE_STANCE_ATTACK //If the mob he was chasing is still nearby, resume the attack, otherwise go idle.
				else
					stance = HOSTILE_STANCE_IDLE
					icon_living = initial(icon_living)//Reset alert phase.

		if(HOSTILE_STANCE_ALERT)
			stop_automated_movement = 1
			var/found_mob = 0
			if(target_mob && target_mob in ListTargets(10))
				if(!(SA_attackable(target_mob)))
					stance_step = max(0, stance_step) //If we have not seen a mob in a while, the stance_step will be negative, we need to reset it to 0 as soon as we see a mob again.
					stance_step++
					found_mob = 1
					src.set_dir(get_dir(src,target_mob))	//Keep staring at the mob
					if(alert_icon)
						icon_state = alert_icon
						icon_living = alert_icon

					if(stance_step in list(1,4,7)) //every 3 ticks
						var/action = pick( list( "beeps aggressively at [target_mob]", "stares angrily at [target_mob]"))
						var/alert_sound = "sound/voice/bot_life[rand(1,3)].ogg"
						if(alert_callout.len)
							alert_sound = pick(alert_callout)
						else
							custom_emote(1,action)
						playsound(src, alert_sound, 100, FALSE)
			if(!found_mob)
				stance_step--

			if(stance_step <= -20) //If we have not found a mob for 20-ish ticks, revert to idle mode
				stance = HOSTILE_STANCE_IDLE
				icon_living = initial(icon_living)//Reset alert phase.
			if(stance_step >= 4)   //If we have been staring at a mob for 4 ticks,
				stance = HOSTILE_STANCE_ATTACK

		if(HOSTILE_STANCE_ATTACKING)
			icon_living = initial(icon_living)
			if(stance_step >= 20)	//attacks for 20 ticks, then it gets tired and needs to rest
				custom_emote(1, "needs to recoup." )
				stance = HOSTILE_STANCE_TIRED
				stance_step = 0
				walk(src, 0)
				return



/mob/living/simple_animal/hostile/mining_borg/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(stance != HOSTILE_STANCE_ATTACK && stance != HOSTILE_STANCE_ATTACKING)
		stance = HOSTILE_STANCE_ALERT
		stance_step = 6
		target_mob = user
	..()

/mob/living/simple_animal/hostile/mining_borg/attack_hand(mob/living/carbon/human/M as mob)
	if(stance != HOSTILE_STANCE_ATTACK && stance != HOSTILE_STANCE_ATTACKING)
		stance = HOSTILE_STANCE_ALERT
		stance_step = 6
		target_mob = M
	..()

/mob/living/simple_animal/hostile/mining_borg/Move()
	. = ..()
	if(.)
		if(!stat)
			playsound(src,"sound/machines/borg_move[pick(1,2)].ogg",40,1)

/mob/living/simple_animal/hostile/mining_borg/FindTarget()
	. = ..()
	if(.)
		custom_emote(1,"beeps alertly [.]")
		say("ENGAGING HOSTILE!")
		playsound(src, "sound/voice/bot_life[rand(1,3)].ogg")
		stance = HOSTILE_STANCE_ALERT

/mob/living/simple_animal/hostile/mining_borg/LoseTarget()
	..(5)


/mob/living/simple_animal/hostile/mining_borg/death()
	..(null,"breaks down and stops moving.", "You have been destroyed.")
	//some random debris left behind
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(3, 1, src)
	s.start()
	var/obj/O

	//shards
	O = new /obj/item/material/shard(src.loc)
	step_to(O, get_turf(pick(view(7, src))))
	if(prob(75))
		O = new /obj/item/material/shard(src.loc)
		step_to(O, get_turf(pick(view(7, src))))
	if(prob(50))
		O = new /obj/item/material/shard(src.loc)
		step_to(O, get_turf(pick(view(7, src))))
	if(prob(25))
		O = new /obj/item/material/shard(src.loc)
		step_to(O, get_turf(pick(view(7, src))))

	//rods
	O = new /obj/item/stack/rods(loc)
	step_to(O, get_turf(pick(view(7, src))))
	if(prob(75))
		O = new /obj/item/stack/rods(loc)
		step_to(O, get_turf(pick(view(7, src))))
	if(prob(50))
		O = new /obj/item/stack/rods(loc)
		step_to(O, get_turf(pick(view(7, src))))
	if(prob(25))
		O = new /obj/item/stack/rods(loc)
		step_to(O, get_turf(pick(view(7, src))))

	//plasteel
	O = new /obj/item/stack/material/plasteel(src.loc)
	step_to(O, get_turf(pick(view(7, src))))
	if(prob(75))
		O = new /obj/item/stack/material/plasteel(src.loc)
		step_to(O, get_turf(pick(view(7, src))))
	if(prob(50))
		O = new /obj/item/stack/material/plasteel(src.loc)
		step_to(O, get_turf(pick(view(7, src))))
	if(prob(25))
		O = new /obj/item/stack/material/plasteel(src.loc)
		step_to(O, get_turf(pick(view(7, src))))



/mob/living/simple_animal/hostile/mining_borg/harvest(var/mob/user)
	if(butchered)
		return

	//also drop dummy circuit boards deconstructable for research (loot)
	var/obj/item/circuitboard/C

	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(3, 1, src)
	s.start()
	playsound(src, "sparks", 100)

	//spawn 1-4 boards of a random type
	var/spawnees = 0
	var/num_boards = rand(1,4)
	var/list/options = list(1,2,4,8,16,32,64,128,256,512)
	for(var/i=0, i<num_boards, i++)
		var/chosen = pick(options)
		options.Remove(options.Find(chosen))
		spawnees |= chosen

	if(spawnees & 1)
		C = new(src.loc)
		C.SetName("Drone CPU motherboard")
		C.origin_tech = list(TECH_DATA = rand(3, 6))

	if(spawnees & 2)
		C = new(src.loc)
		C.SetName("Drone neural interface")
		C.origin_tech = list(TECH_BIO = rand(3,6))

	if(spawnees & 4)
		C = new(src.loc)
		C.SetName("Drone suspension processor")
		C.origin_tech = list(TECH_MAGNET = rand(3,6))

	if(spawnees & 8)
		C = new(src.loc)
		C.SetName("Drone shielding controller")
		C.origin_tech = list(TECH_BLUESPACE = rand(3,6))

	if(spawnees & 16)
		C = new(src.loc)
		C.SetName("Drone power capacitor")
		C.origin_tech = list(TECH_POWER = rand(3,6))

	if(spawnees & 32)
		C = new(src.loc)
		C.SetName("Drone hull reinforcer")
		C.origin_tech = list(TECH_MATERIAL = rand(3,6))

	if(spawnees & 64)
		C = new(src.loc)
		C.SetName("Drone auto-repair system")
		C.origin_tech = list(TECH_ENGINEERING = rand(3,6))

	if(spawnees & 128)
		C = new(src.loc)
		C.SetName("Drone phoron overcharge counter")
		C.origin_tech = list(TECH_PHORON = rand(3,6))

	if(spawnees & 256)
		C = new(src.loc)
		C.SetName("Drone targetting circuitboard")
		C.origin_tech = list(TECH_COMBAT = rand(3,6))

	if(spawnees & 512)
		C = new(src.loc)
		C.SetName("Corrupted drone morality core")
		C.origin_tech = list(TECH_ILLEGAL = rand(3,6))

	visible_message("[user] cuts out some scrap from \the [src]. That might be worth something.")
	butchered = TRUE

//Mining drones.
/mob/living/simple_animal/hostile/mining_borg/minesect
	name = "minesct"
	desc = "Some sort of cursed attempt at further weaponizing mines. These terrifying creatures have a very high chance of exploding when near."
	icon_state = "minesect"
	icon_living = "minesect"
	icon_dead = "minesect_dead"
	speak_emote = list("beeps", "buzzes", "hisses")
	health = 100
	maxHealth = 100

/mob/living/simple_animal/hostile/mining_borg/minesect/proc/explode()
	visible_message("\the [src] looks like it's about to explode!")
	spawn(20)
		fragmentate(get_turf(src), 20, 2, list(/obj/item/projectile/bullet/pellet/fragment/landmine))
		explosion(loc, 1, 1, 1, 1)
		qdel(src)

/mob/living/simple_animal/hostile/mining_borg/minesect/AttackingTarget()
	..()
	if(prob(50))
		explode()

/mob/living/simple_animal/hostile/mining_borg/minesect/death(gibbed, deathmessage = "dies!", show_dead_message)
	icon_state = icon_dead
	density = 0
	health = min(0,health)
	walk_to(src,0)
	if(prob(1))
		explode()
	return ..(gibbed,deathmessage,show_dead_message)















