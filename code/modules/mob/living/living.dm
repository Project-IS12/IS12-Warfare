/mob/living
	var/current_ambience = null
	var/ambience_is_playing = 0
	var/ambience_override = 0

/mob/living/New()
	..()
	if(stat == DEAD)
		add_to_dead_mob_list()
	else
		add_to_living_mob_list()

//mob verbs are faster than object verbs. See mob/verb/examine.
/mob/living/proc/pulled(atom/movable/AM as mob|obj in oview(1))
	set name = "Pull"
	set category = "Object"

	if(AM.Adjacent(src))
		src.start_pulling(AM)

	return

//mob verbs are faster than object verbs. See above.
/mob/living/pointed(atom/A as mob|obj|turf in view())
	if(src.stat || src.restrained()) //!src.canmove
		return 0
	if(src.status_flags & FAKEDEATH)
		return 0
	if(!..())
		return 0

	if(!isturf(A))
		var/point_color = "#F00"
		if(ishuman(A))
			var/mob/living/carbon/human/H = A
			if(H.warfare_faction == RED_TEAM)
				point_color = "#b27676"
			else
				point_color = "#76abb2"
		var/pointglow = filter(type = "drop_shadow", x = 0, y = -1, offset = 2, size = 1, color = point_color)
		remove_filter(A, pointglow)
		LAZYADD(A.filters, pointglow)
		addtimer(CALLBACK(src, .proc/remove_filter, A, pointglow), 20)

	usr.visible_message("<b>[src]</b> points to [A]")
	return 1

/mob/proc/remove_filter(var/atom/A, var/filter_to_remove)
	LAZYREMOVE(A.filters, filter_to_remove)

/*one proc, four uses
swapping: if it's 1, the mobs are trying to switch, if 0, non-passive is pushing passive
default behaviour is:
 - non-passive mob passes the passive version
 - passive mob checks to see if its mob_bump_flag is in the non-passive's mob_bump_flags
 - if si, the proc returns
*/
/mob/living/proc/can_move_mob(var/mob/living/swapped, swapping = 0, passive = 0)
	if(!swapped)
		return 1
	if(!passive)
		return swapped.can_move_mob(src, swapping, 1)
	else
		var/context_flags = 0
		if(swapping)
			context_flags = swapped.mob_swap_flags
		else
			context_flags = swapped.mob_push_flags
		if(!mob_bump_flag) //nothing defined, go wild
			return 1
		if(mob_bump_flag & context_flags)
			return 1
		else
			return ((a_intent == I_HELP && swapped.a_intent == I_HELP) && swapped.can_move_mob(src, swapping, 1))

/mob/living/canface()
	if(stat)
		return 0
	return ..()

/mob/living/Bump(atom/movable/AM, yes)
	spawn(0)
		if ((!( yes ) || now_pushing) || !loc)
			return
		now_pushing = 1
		if (istype(AM, /mob/living))
			var/mob/living/tmob = AM

			for(var/mob/living/M in range(tmob, 1))
				if(tmob.pinned.len ||  ((M.pulling == tmob && ( tmob.restrained() && !( M.restrained() ) && M.stat == 0)) || locate(/obj/item/grab, tmob.grabbed_by.len)) )
					if ( !(world.time % 5) )
						to_chat(src, "<span class='warning'>[tmob] is restrained, you cannot push past</span>")
					now_pushing = 0
					return
				if( tmob.pulling == M && ( M.restrained() && !( tmob.restrained() ) && tmob.stat == 0) )
					if ( !(world.time % 5) )
						to_chat(src, "<span class='warning'>[tmob] is restraining [M], you cannot push past</span>")
					now_pushing = 0
					return

			//Leaping mobs just land on the tile, no pushing, no anything.
			if(status_flags & LEAPING)
				loc = tmob.loc
				status_flags &= ~LEAPING
				now_pushing = 0
				return

			if(can_swap_with(tmob)) // mutual brohugs all around!
				var/turf/oldloc = loc
				forceMove(tmob.loc)
				tmob.forceMove(oldloc)
				now_pushing = 0
				for(var/mob/living/carbon/slime/slime in view(1,tmob))
					if(slime.Victim == tmob)
						slime.UpdateFeed()
				return

			if(!can_move_mob(tmob, 0, 0))
				now_pushing = 0
				return
			if(src.restrained())
				now_pushing = 0
				return
			if(tmob.a_intent != I_HELP)
				if(ishuman(tmob) && ishuman(src))
					var/mob/living/carbon/human/pusher = src
					var/mob/living/carbon/human/pushee = tmob
					if((pusher.STAT_LEVEL(str) < pushee.STAT_LEVEL(str)) && prob(95))
						src.visible_message("<span class='danger'>[pusher] fails to push past [pushee].</span>")
						now_pushing = 0
						return
					//if(prob(40) && !(FAT in src.mutations))
					//	to_chat(src, "<span class='danger'>You fail to push [tmob]'s fat ass out of the way.</span>")
					//	now_pushing = 0
					//	return
				if(tmob.r_hand && istype(tmob.r_hand, /obj/item/shield/riot))
					if(prob(99))
						now_pushing = 0
						return
				if(tmob.l_hand && istype(tmob.l_hand, /obj/item/shield/riot))
					if(prob(99))
						now_pushing = 0
						return
			if(!(tmob.status_flags & CANPUSH))
				now_pushing = 0
				return
			tmob.LAssailant = src
		if(isobj(AM) && !AM.anchored)
			var/obj/I = AM
			if(!can_pull_size || can_pull_size < I.w_class)
				to_chat(src, "<span class='warning'>It won't budge!</span>")
				now_pushing = 0
				return

		now_pushing = 0
		spawn(0)
			..()
			var/saved_dir = AM.dir
			if (!istype(AM, /atom/movable) || AM.anchored)
				if(confused && prob(50) && m_intent=="run")
					Weaken(2)
					playsound(loc, "punch", 40, 1, -1)
					visible_message("<span class='warning'>[src] [pick("ran", "slammed")] into \the [AM]!</span>")
					src.apply_damage(5, BRUTE)
				return
			if (!now_pushing)
				now_pushing = 1

				var/t = get_dir(src, AM)
				if (istype(AM, /obj/structure/window))
					for(var/obj/structure/window/win in get_step(AM,t))
						now_pushing = 0
						return
				step(AM, t)
				if (istype(AM, /mob/living))
					var/mob/living/tmob = AM
					if(istype(tmob.buckled, /obj/structure/bed))
						if(!tmob.buckled.anchored)
							step(tmob.buckled, t)
				if(ishuman(AM) && AM:grabbed_by)
					for(var/obj/item/grab/G in AM:grabbed_by)
						step(G:assailant, get_dir(G:assailant, AM))
						G.adjust_position()
				if(saved_dir)
					AM.set_dir(saved_dir)
				now_pushing = 0
			return
	return

/proc/swap_density_check(var/mob/swapper, var/mob/swapee)
	var/turf/T = get_turf(swapper)
	if(T.density)
		return 1
	for(var/atom/movable/A in T)
		if(A == swapper)
			continue
		if(!A.CanPass(swapee, T, 1))
			return 1

/mob/living/proc/can_swap_with(var/mob/living/tmob)
	if(tmob.buckled || buckled)
		return 0
	//BubbleWrap: people in handcuffs are always switched around as if they were on 'help' intent to prevent a person being pulled from being seperated from their puller
	if(!(tmob.mob_always_swap || (tmob.a_intent == I_HELP || tmob.restrained()) && (a_intent == I_HELP || src.restrained())))
		return 0
	if(!tmob.canmove || !canmove)
		return 0

	if(swap_density_check(src, tmob))
		return 0

	if(swap_density_check(tmob, src))
		return 0

	return can_move_mob(tmob, 1, 0)

/mob/living/verb/succumb()
	set name = "Succumb"
	set category = "IC"
	if(stat == DEAD)
		return
	if ((src.health < src.maxHealth/2) || is_asystole()) // Health below half of maxhealth, or asystole.
		src.adjustBrainLoss(src.health + src.maxHealth * 2) // Deal 2x health in BrainLoss damage, as before but variable.
		updatehealth()
		to_chat(src, "<span class='notice'>You have given up life and succumbed to death.</span>")
	else
		to_chat(src, "<span class='notice'>You are too alive to die.</span>")


/mob/living/proc/updatehealth()
	if(status_flags & GODMODE)
		health = 100
		set_stat(CONSCIOUS)
	else
		health = maxHealth - getOxyLoss() - getToxLoss() - getFireLoss() - getBruteLoss() - getCloneLoss() - getHalLoss()


//This proc is used for mobs which are affected by pressure to calculate the amount of pressure that actually
//affects them once clothing is factored in. ~Errorage
/mob/living/proc/calculate_affecting_pressure(var/pressure)
	return


//sort of a legacy burn method for /electrocute, /shock, and the e_chair
/mob/living/proc/burn_skin(burn_amount)
	take_overall_damage(0, burn_amount)

/mob/living/proc/adjustBodyTemp(actual, desired, incrementboost)
	var/temperature = actual
	var/difference = abs(actual-desired)	//get difference
	var/increments = difference/10 //find how many increments apart they are
	var/change = increments*incrementboost	// Get the amount to change by (x per increment)

	// Too cold
	if(actual < desired)
		temperature += change
		if(actual > desired)
			temperature = desired
	// Too hot
	if(actual > desired)
		temperature -= change
		if(actual < desired)
			temperature = desired
//	if(istype(src, /mob/living/carbon/human))
//		log_debug("[src] ~ [src.bodytemperature] ~ [temperature]")

	return temperature


// ++++ROCKDTBEN++++ MOB PROCS -- Ask me before touching.
// Stop! ... Hammertime! ~Carn
// I touched them without asking... I'm soooo edgy ~Erro (added nodamage checks)

/mob/living/proc/getBruteLoss()
	return maxHealth - health

/mob/living/proc/adjustBruteLoss(var/amount)
	if(status_flags & GODMODE)	return 0	//godmode
	health = max(health-amount, 0)

/mob/living/proc/getOxyLoss()
	return 0

/mob/living/proc/adjustOxyLoss(var/amount)
	return

/mob/living/proc/setOxyLoss(var/amount)
	return

/mob/living/proc/getToxLoss()
	return 0

/mob/living/proc/adjustToxLoss(var/amount)
	adjustBruteLoss(amount * 0.5)

/mob/living/proc/setToxLoss(var/amount)
	adjustBruteLoss((amount * 0.5)-getBruteLoss())

/mob/living/proc/getFireLoss()
	return

/mob/living/proc/adjustFireLoss(var/amount)
	adjustBruteLoss(amount * 0.5)

/mob/living/proc/setFireLoss(var/amount)
	adjustBruteLoss((amount * 0.5)-getBruteLoss())

/mob/living/proc/getHalLoss()
	return 0

/mob/living/proc/adjustHalLoss(var/amount)
	adjustBruteLoss(amount * 0.5)

/mob/living/proc/setHalLoss(var/amount)
	adjustBruteLoss((amount * 0.5)-getBruteLoss())

/mob/living/proc/getStaminaLoss()//Stamina shit.
	return staminaloss

/mob/living/proc/adjustStaminaLoss(var/amount)
	if(status_flags & GODMODE)	return 0
	staminaloss = min(max(staminaloss + amount, 0),(maxHealth*2))

/mob/living/proc/setStaminaLoss(var/amount)
	if(status_flags & GODMODE)	return 0
	staminaloss = amount

/mob/living/proc/getBrainLoss()
	return 0

/mob/living/proc/adjustBrainLoss(var/amount)
	return

/mob/living/proc/setBrainLoss(var/amount)
	return

/mob/living/proc/getCloneLoss()
	return 0

/mob/living/proc/setCloneLoss(var/amount)
	return

/mob/living/proc/adjustCloneLoss(var/amount)
	return

/mob/living/proc/getMaxHealth()
	return maxHealth

/mob/living/proc/setMaxHealth(var/newMaxHealth)
	maxHealth = newMaxHealth

// ++++ROCKDTBEN++++ MOB PROCS //END

/mob/proc/get_contents()
	return

//Recursive function to find everything a mob is holding.
/mob/living/get_contents(var/obj/item/storage/Storage = null)
	var/list/L = list()

	if(Storage) //If it called itself
		L += Storage.return_inv()

		//Leave this commented out, it will cause storage items to exponentially add duplicate to the list
		//for(var/obj/item/storage/S in Storage.return_inv()) //Check for storage items
		//	L += get_contents(S)

		for(var/obj/item/gift/G in Storage.return_inv()) //Check for gift-wrapped items
			L += G.gift
			if(istype(G.gift, /obj/item/storage))
				L += get_contents(G.gift)

		for(var/obj/item/smallDelivery/D in Storage.return_inv()) //Check for package wrapped items
			L += D.wrapped
			if(istype(D.wrapped, /obj/item/storage)) //this should never happen
				L += get_contents(D.wrapped)
		return L

	else

		L += src.contents
		for(var/obj/item/storage/S in src.contents)	//Check for storage items
			L += get_contents(S)

		for(var/obj/item/gift/G in src.contents) //Check for gift-wrapped items
			L += G.gift
			if(istype(G.gift, /obj/item/storage))
				L += get_contents(G.gift)

		for(var/obj/item/smallDelivery/D in src.contents) //Check for package wrapped items
			L += D.wrapped
			if(istype(D.wrapped, /obj/item/storage)) //this should never happen
				L += get_contents(D.wrapped)
		return L

/mob/living/proc/check_contents_for(A)
	var/list/L = src.get_contents()

	for(var/obj/B in L)
		if(B.type == A)
			return 1
	return 0

/mob/living/proc/can_inject(var/mob/user, var/target_zone)
	return 1

/mob/living/proc/get_organ_target()
	var/mob/shooter = src
	var/t = shooter:zone_sel.selecting
	if ((t in list( BP_EYES, BP_MOUTH )))
		t = BP_HEAD
	var/obj/item/organ/external/def_zone = ran_zone(t)
	return def_zone


// heal ONE external organ, organ gets randomly selected from damaged ones.
/mob/living/proc/heal_organ_damage(var/brute, var/burn)
	adjustBruteLoss(-brute)
	adjustFireLoss(-burn)
	src.updatehealth()

// damage ONE external organ, organ gets randomly selected from damaged ones.
/mob/living/proc/take_organ_damage(var/brute, var/burn, var/emp=0)
	if(status_flags & GODMODE)	return 0	//godmode
	adjustBruteLoss(brute)
	adjustFireLoss(burn)
	src.updatehealth()

// heal MANY external organs, in random order
/mob/living/proc/heal_overall_damage(var/brute, var/burn)
	adjustBruteLoss(-brute)
	adjustFireLoss(-burn)
	src.updatehealth()

// damage MANY external organs, in random order
/mob/living/proc/take_overall_damage(var/brute, var/burn, var/used_weapon = null)
	if(status_flags & GODMODE)	return 0	//godmode
	adjustBruteLoss(brute)
	adjustFireLoss(burn)
	src.updatehealth()

/mob/living/proc/restore_all_organs()
	return

/mob/living/proc/revive()
	rejuvenate()
	if(buckled)
		buckled.unbuckle_mob()
	if(iscarbon(src))
		var/mob/living/carbon/C = src

		if (C.handcuffed && !initial(C.handcuffed))
			C.drop_from_inventory(C.handcuffed)
		C.handcuffed = initial(C.handcuffed)
	BITSET(hud_updateflag, HEALTH_HUD)
	BITSET(hud_updateflag, STATUS_HUD)
	BITSET(hud_updateflag, LIFE_HUD)
	ExtinguishMob()
	fire_stacks = 0

/mob/living/proc/rejuvenate()
	if(reagents)
		reagents.clear_reagents()

	// shut down various types of badness
	setToxLoss(0)
	setOxyLoss(0)
	setCloneLoss(0)
	setBrainLoss(0)
	SetParalysis(0)
	SetStunned(0)
	SetWeakened(0)
	setStaminaLoss(0)

	// shut down ongoing problems
	radiation = 0
	bodytemperature = T20C
	sdisabilities = 0
	disabilities = 0

	// fix blindness and deafness
	blinded = 0
	eye_blind = 0
	eye_blurry = 0
	ear_deaf = 0
	ear_damage = 0
	heal_overall_damage(getBruteLoss(), getFireLoss())

	// fix all of our organs
	restore_all_organs()

	// remove the character from the list of the dead
	if(stat == DEAD)
		switch_from_dead_to_living_mob_list()
		timeofdeath = 0

	// restore us to conciousness
	set_stat(CONSCIOUS)

	// make the icons look correct
	regenerate_icons()

	BITSET(hud_updateflag, HEALTH_HUD)
	BITSET(hud_updateflag, STATUS_HUD)
	BITSET(hud_updateflag, LIFE_HUD)

	failed_last_breath = 0 //So mobs that died of oxyloss don't revive and have perpetual out of breath.
	reload_fullscreen()
	return

/mob/living/proc/UpdateDamageIcon()
	return


/mob/living/proc/Examine_OOC()
	set name = "Examine Meta-Info (OOC)"
	set category = "OOC"
	set src in view()

	if(config.allow_Metadata)
		if(client)
			to_chat(usr, "[src]'s Metainfo:<br>[client.prefs.metadata]")
		else
			to_chat(usr, "[src] does not have any stored infomation!")
	else
		to_chat(usr, "OOC Metadata is not supported by this server!")

	return

/mob/living/Move(a, b, flag)
	if (buckled)
		return

	if (restrained())
		stop_pulling()


	var/t7 = 1
	if (restrained())
		for(var/mob/living/M in range(src, 1))
			if ((M.pulling == src && M.stat == 0 && !( M.restrained() )))
				t7 = null
	if ((t7 && (pulling && ((get_dist(src, pulling) <= 1 || pulling.loc == loc) && (client && client.moving)))))
		var/turf/T = loc
		. = ..()

		if (pulling && pulling.loc)
			if(!( isturf(pulling.loc) ))
				stop_pulling()
				return

		/////
		if(pulling && pulling.anchored)
			stop_pulling()
			return

		if (!restrained())
			var/diag = get_dir(src, pulling)
			if ((diag - 1) & diag)
			else
				diag = null
			if ((get_dist(src, pulling) > 1 || diag))
				if (isliving(pulling))
					var/mob/living/M = pulling
					var/ok = 1
					if (locate(/obj/item/grab, M.grabbed_by))
						if (prob(75))
							var/obj/item/grab/G = pick(M.grabbed_by)
							if (istype(G, /obj/item/grab))
								for(var/mob/O in viewers(M, null))
									O.show_message(text("<span class='warning'>[] has been pulled from []'s grip by []</span>", G.affecting, G.assailant, src), 1)
								//G = null
								qdel(G)
						else
							ok = 0
						if (locate(/obj/item/grab, M.grabbed_by.len))
							ok = 0
					if (ok)
						var/atom/movable/t = M.pulling
						M.stop_pulling()


						if(!istype(M.loc, /turf/space))
							var/area/A = get_area(M)
							if(A.has_gravity)
								//Ok I rewrote all the gay blood shit up on the floor. - Matt
								if (M.lying && (prob(M.getBruteLoss() / 2)))
									var/blood_exists = 0
									var/trail_type = M.getTrail()
									for(var/obj/effect/decal/cleanable/trail_holder/C in M.loc) //checks for blood splatter already on the floor
										blood_exists = 1
									if(ishuman(M))//Ok so they're a human, so they have blood and shit.
										var/mob/living/carbon/human/H = M
										var/blood_volume = round(H.vessel.get_reagent_amount(/datum/reagent/blood))//Getting their blood.

										if(blood_volume > 50)//Do they have blood?
											H.vessel.remove_reagent(/datum/reagent/blood, 1)//If so take some away.

											if (istype(M.loc, /turf/simulated) && trail_type != null)//Ok we've taken the blood away then we can leave a trail.
												var/newdir = get_dir(T, M.loc)//All this trail shit.
												if(newdir != M.dir)
													newdir = newdir | M.dir
													if(newdir == 3) //N + S
														newdir = NORTH
													else if(newdir == 12) //E + W
														newdir = EAST
												if((newdir in list(1, 2, 4, 8)) && (prob(50)))
													newdir = turn(get_dir(T, M.loc), 180)
												if(!blood_exists)
													new /obj/effect/decal/cleanable/trail_holder(M.loc)
												for(var/obj/effect/decal/cleanable/trail_holder/X in M.loc)
													if((!(newdir in X.existing_dirs) || trail_type == "trails_1" || trail_type == "trails_2") && X.existing_dirs.len <= 16) //maximum amount of overlays is 16 (all light & heavy directions filled)
														X.existing_dirs += newdir
														X.overlays.Add(image('icons/effects/blood.dmi',trail_type,dir = newdir))

								/*
								//pull damage with injured people
									if(prob(25))
										M.adjustBruteLoss(1)
										visible_message("<span class='danger'>\The [M]'s [M.isSynthetic() ? "state worsens": "wounds open more"] from being dragged!</span>")
								if(M.pull_damage())
									if(prob(25))
										M.adjustBruteLoss(2)
										visible_message("<span class='danger'>\The [M]'s [M.isSynthetic() ? "state" : "wounds"] worsen terribly from being dragged!</span>")
										var/turf/location = M.loc
										if (istype(location, /turf/simulated))
											location.add_blood(M)
											if(ishuman(M))
												var/mob/living/carbon/human/H = M
												var/blood_volume = round(H.vessel.get_reagent_amount(/datum/reagent/blood))
												if(blood_volume > 0)
													H.vessel.remove_reagent(/datum/reagent/blood, 1)

								*/

						step(pulling, get_dir(pulling.loc, T))
						if(t)
							M.start_pulling(t)
				else
					if (pulling)
						if (istype(pulling, /obj/structure/window))
							var/obj/structure/window/W = pulling
							if(W.is_full_window())
								for(var/obj/structure/window/win in get_step(pulling,get_dir(pulling.loc, T)))
									stop_pulling()
					if (pulling)
						step(pulling, get_dir(pulling.loc, T))
	else
		stop_pulling()
		. = ..()

	if (s_active && !( s_active in contents ) && get_turf(s_active) != get_turf(src))	//check !( s_active in contents ) first so we hopefully don't have to call get_turf() so much.
		s_active.close(src)

	if(update_slimes)
		for(var/mob/living/carbon/slime/M in view(1,src))
			M.UpdateFeed()

	for(var/mob/M in oview(src))
		M.update_vision_cone()

	update_vision_cone()


/mob/living/proc/CheckStamina()
	if(staminaloss <= 0)
		setStaminaLoss(0)

	if(staminaloss && !combat_mode)//If we're not doing anything, we're not in combat mode, and we've lost stamina we can wait to gain it back.
		var/speed = 0
		if(is_hellbanned())//SLower recovery if you're hellbanned.
			speed = 4
		if(lying)
			speed += -10
		else
			speed += -5

		adjustStaminaLoss(speed)

	if(staminaloss >= staminaexhaust && !stat)//Oh shit we've lost too much stamina and now we're tired!
		Exhaust()
		return

/mob/living/proc/Exhaust()//Called when you run out of stamina.
	Weaken(5)


/mob/living/verb/resist()
	set name = "Resist"
	set category = "IC"

	if(!incapacitated(INCAPACITATION_KNOCKOUT) && canClick())
		setClickCooldown(20)
		resist_grab()
		if(!weakened)
			process_resist()

/mob/living/proc/process_resist()
	//Getting out of someone's inventory.
	if(istype(src.loc, /obj/item/holder))
		escape_inventory(src.loc)
		return

	//unbuckling yourself
	if(buckled)
		spawn() escape_buckle()
		return TRUE

	//Breaking out of a locker?
	if( src.loc && (istype(src.loc, /obj/structure/closet)) )
		var/obj/structure/closet/C = loc
		spawn() C.mob_breakout(src)
		return TRUE

/mob/living/proc/escape_inventory(obj/item/holder/H)
	if(H != src.loc) return

	var/mob/M = H.loc //Get our mob holder (if any).

	if(istype(M))
		M.drop_from_inventory(H)
		to_chat(M, "<span class='warning'>\The [H] wriggles out of your grip!</span>")
		to_chat(src, "<span class='warning'>You wriggle out of \the [M]'s grip!</span>")

		// Update whether or not this mob needs to pass emotes to contents.
		for(var/atom/A in M.contents)
			if(istype(A,/mob/living/simple_animal/borer) || istype(A,/obj/item/holder))
				return
		M.status_flags &= ~PASSEMOTES
	else if(istype(H.loc,/obj/item/clothing/accessory/holster))
		var/obj/item/clothing/accessory/holster/holster = H.loc
		if(holster.holstered == H)
			holster.clear_holster()
		to_chat(src, "<span class='warning'>You extricate yourself from \the [holster].</span>")
		H.forceMove(get_turf(H))
	else if(istype(H.loc,/obj))
		if(istype(H.loc, /obj/machinery/cooker))
			var/obj/machinery/cooker/C = H.loc
			C.cooking_obj = null
			C.check_cooking_obj()
		to_chat(src, "<span class='warning'>You struggle free of \the [H.loc].</span>")
		H.forceMove(get_turf(H))

	if(loc != H)
		qdel(H)

/mob/living/proc/escape_buckle()
	if(buckled)
		if(buckled.can_buckle)
			buckled.user_unbuckle_mob(src)
		else
			to_chat(usr, "<span class='warning'>You can't seem to escape from \the [buckled]!</span>")
			return

/mob/living/proc/resist_grab()
	var/resisting = 0
	for(var/obj/item/grab/G in grabbed_by)
		resisting++
		G.handle_resist()
	if(resisting)
		visible_message("<span class='danger'>[src] resists!</span>")

/mob/living/verb/lay_down()
	set name = "Rest"
	set category = "IC"

	resting = !resting
	to_chat(src, "<span class='notice'>You are now [resting ? "resting" : "getting up"]</span>")

//called when the mob receives a bright flash
/mob/living/flash_eyes(intensity = FLASH_PROTECTION_MODERATE, override_blindness_check = FALSE, affect_silicon = FALSE, visual = FALSE, type = /obj/screen/fullscreen/flash)
	if(override_blindness_check || !(disabilities & BLIND))
		overlay_fullscreen("flash", type)
		spawn(25)
			if(src)
				clear_fullscreen("flash", 25)
		return 1

/mob/living/proc/cannot_use_vents()
	if(mob_size > MOB_SMALL)
		return "You can't fit into that vent."
	return null

/mob/living/proc/has_brain()
	return 1

/mob/living/proc/has_eyes()
	return 1

/mob/living/proc/slip(var/slipped_on,stun_duration=8)
	return 0

/mob/living/carbon/drop_from_inventory(var/obj/item/W, var/atom/Target = null)
	if(W in internal_organs)
		return
	. = ..()

//damage/heal the mob ears and adjust the deaf amount
/mob/living/adjustEarDamage(var/damage, var/deaf)
	ear_damage = max(0, ear_damage + damage)
	ear_deaf = max(0, ear_deaf + deaf)

//pass a negative argument to skip one of the variable
/mob/living/setEarDamage(var/damage = null, var/deaf = null)
	if(!isnull(damage))
		ear_damage = damage
	if(!isnull(deaf))
		ear_deaf = deaf

/mob/proc/can_be_possessed_by(var/mob/observer/ghost/possessor)
	return istype(possessor) && possessor.client

/mob/living/can_be_possessed_by(var/mob/observer/ghost/possessor)
	if(!..())
		return 0
	if(!possession_candidate)
		to_chat(possessor, "<span class='warning'>That animal cannot be possessed.</span>")
		return 0
	if(jobban_isbanned(possessor, "Animal"))
		to_chat(possessor, "<span class='warning'>You are banned from animal roles.</span>")
		return 0
	if(!possessor.MayRespawn(1,ANIMAL_SPAWN_DELAY))
		return 0
	return 1

/mob/living/proc/do_possession(var/mob/observer/ghost/possessor)

	if(!(istype(possessor) && possessor.ckey))
		return 0

	if(src.ckey || src.client)
		to_chat(possessor, "<span class='warning'>\The [src] already has a player.</span>")
		return 0

	message_admins("<span class='adminnotice'>[key_name_admin(possessor)] has taken control of \the [src].</span>")
	log_admin("[key_name(possessor)] took control of \the [src].")
	src.ckey = possessor.ckey
	qdel(possessor)

	if(round_is_spooky(6)) // Six or more active cultists.
		to_chat(src, "<span class='notice'>You reach out with tendrils of ectoplasm and invade the mind of \the [src]...</span>")
		to_chat(src, "<b>You have assumed direct control of \the [src].</b>")
		to_chat(src, "<span class='notice'>Due to the spookiness of the round, you have taken control of the poor animal as an invading, possessing spirit - roleplay accordingly.</span>")
		src.universal_speak = 1
		src.universal_understand = 1
		//src.cultify() // Maybe another time.
		return

	to_chat(src, "<b>You are now \the [src]!</b>")
	to_chat(src, "<span class='notice'>Remember to stay in character for a mob of this type!</span>")
	return 1

/mob/living/reset_layer()
	if(hiding)
		plane = HIDING_MOB_PLANE
		layer = HIDING_MOB_LAYER
	else
		..()
/mob/living/set_dir()
	..()
	update_vision_cone()

/atom/movable/proc/receive_damage(atom/A)
	var/pixel_x_diff = rand(-2,2)
	var/pixel_y_diff = rand(-2,2)
	animate(src, pixel_x = pixel_x + pixel_x_diff, pixel_y = pixel_y + pixel_y_diff, time = 2)
	animate(pixel_x = initial(pixel_x), pixel_y = initial(pixel_y), time = 2)

/mob/living/update_icons()
	if(auras)
		overlays |= auras

/mob/living/receive_damage(atom/A)
	..()

/mob/living/proc/add_aura(var/obj/aura/aura)
	LAZYDISTINCTADD(auras,aura)
	update_icons()
	return 1

/mob/living/proc/getTrail() //silicon and simple_animals don't get blood trails
    return null

/mob/living/proc/remove_aura(var/obj/aura/aura)
	LAZYREMOVE(auras,aura)
	update_icons()
	return 1

/mob/living/Destroy()
	if(auras)
		for(var/a in auras)
			remove_aura(a)
	return ..()

//Does a special attack if combat mode is on, and they have an item.
/mob/living/RightClick(var/mob/living/user)
	if(user.Adjacent(src))
		var/obj/item/I = user.get_active_hand()
		if(!I)
			return
		if(!user.combat_mode)
			return
		I.attack(src, user, user.zone_sel.selecting, TRUE)

	/*
	else
		//Aiming a gun at someone.
		var/obj/item/gun/G = user.get_active_hand()
		if(G)
			if(ismob(src) && user.aiming)
				if(src == user.aiming.aiming_at)//If we're already aiming at them, then stop aiming.
					user.aiming.cancel_aiming()
				else
					user.aiming.aim_at(src, G)//Else aim at them with the gun.
	*/


/mob/living/proc/handle_lisp()
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		var/obj/item/organ/external/head/O = locate(/obj/item/organ/external/head) in H.organs
		if(O)
			if(!O.teeth_list.len || O.get_teeth() <= 0)
				lisp = 100 //No teeth = full lisp power
			else
				lisp = (1 - (O.get_teeth()/O.max_teeth)) * 100 //Less teeth = more lisp
		else
			lisp = 0 //No head = no lisp.
	return lisp

/mob/living/proc/melee_accuracy_mods()
	. = 0
	if(eye_blind)
		. += 75
	if(eye_blurry)
		. += 15
	if(confused)
		. += 30

/mob/living/proc/toggle_crouch()
	if(lying)//No crouching while you're lying down please.
		return
	crouching = !crouching
	if(crouching)
		to_chat(src, "<span class='binfo'>You crouch low.")
		if(istype(loc, /turf/simulated/floor/trench))
			pixel_y = -12
		if(zoomed)//Can't zoom in if you're crouching behind cover.
			do_zoom()

	else
		to_chat(src, "<span class='binfo'>You stand up.")
		if(istype(loc, /turf/simulated/floor/trench))
			pixel_y = -8

/mob/living/verb/toggle_crouching()
	set name = ".toggle_crouching"
	set hidden = TRUE
	toggle_crouch()