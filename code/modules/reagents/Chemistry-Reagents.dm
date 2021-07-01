/datum/reagent
	var/name = "Reagent"
	var/description = "A non-descript chemical."
	var/taste_description = "old rotten bandaids"
	var/taste_mult = 1 //how this taste compares to others. Higher values means it is more noticable
	var/datum/reagents/holder = null
	var/reagent_state = REAGENT_SOLID
	var/list/data = null
	var/volume = 0
	var/metabolism = REM // This would be 0.2 normally
	var/ingest_met = 0
	var/touch_met = 0
	var/overdose = 0
	var/scannable = 0 // Shows up on health analyzers.
	var/color = "#000000"
	var/color_weight = 1
	var/flags = 0

	var/glass_icon = DRINK_ICON_DEFAULT
	var/glass_name = "something"
	var/glass_desc = "It's a glass of... what, exactly?"
	var/list/glass_special = null // null equivalent to list()

	var/quench_amount = 5 //For thirst.

	// New addiction code...
	var/addiction_stage = 1
	var/reagent_addiction_strength = 0 // Prob of 0% to 100% of geting addicted.
	var/last_addiction_dose = null
	var/time_addiction_update = 1000 // (1 minute)Time it takes to make a tick of addiction, a lower number means you will need more of the chemical faster.

/datum/reagent/New(var/datum/reagents/holder)
	if(!istype(holder))
		CRASH("Invalid reagents holder: [log_info_line(holder)]")
	src.holder = holder
	..()

/datum/reagent/proc/remove_self(var/amount) // Shortcut
	holder.remove_reagent(type, amount)

// This doesn't apply to skin contact - this is for, e.g. extinguishers and sprays. The difference is that reagent is not directly on the mob's skin - it might just be on their clothing.
/datum/reagent/proc/touch_mob(var/mob/M, var/amount)
	return

/datum/reagent/proc/touch_obj(var/obj/O, var/amount) // Acid melting, cleaner cleaning, etc
	return

/datum/reagent/proc/touch_turf(var/turf/T, var/amount) // Cleaner cleaning, lube lubbing, etc, all go here
	return

/datum/reagent/proc/on_mob_life(var/mob/living/carbon/M, var/alien, var/location) // Currently, on_mob_life is called on carbons. Any interaction with non-carbon mobs (lube) will need to be done in touch_mob.
	if(!istype(M))
		return
	if(!(flags & AFFECTS_DEAD) && M.stat == DEAD && (world.time - M.timeofdeath > 150))
		return
	if(overdose && (location != CHEM_TOUCH))
		var/overdose_threshold = overdose * (flags & IGNORE_MOB_SIZE? 1 : MOB_MEDIUM/M.mob_size)
		if(volume > overdose_threshold)
			overdose(M, alien)
	if(prob(reagent_addiction_strength) && !is_type_in_list(src, M.reagents.addiction_list))
		to_chat(M, "<span class='danger'>You like that feeling. You may want more of that later...</span>")
		var/datum/reagent/new_reagent = new type()
		new_reagent.last_addiction_dose = world.timeofday
		M.reagents.addiction_list.Add(new_reagent)
	else if(is_type_in_list(src, M.reagents.addiction_list))
		var/message = pick("You feel better, but for how long?", "Ah.....")
		if(prob(1))
			to_chat(M, "<span class='notice'>[message]</span>")
		for(var/A in M.reagents.addiction_list)
			var/datum/reagent/AD = A
			if(AD && istype(AD, src))
				AD.last_addiction_dose = world.timeofday
				AD.addiction_stage = 1
				M.clear_event("addiction")

	//determine the metabolism rate
	var/removed = metabolism
	if(ingest_met && (location == CHEM_INGEST))
		removed = ingest_met
	if(touch_met && (location == CHEM_TOUCH))
		removed = touch_met
	removed = M.get_adjusted_metabolism(removed)


	//adjust effective amounts - removed, dose, and max_dose - for mob size
	var/effective = removed
	if(!(flags & IGNORE_MOB_SIZE) && location != CHEM_TOUCH)
		effective *= (MOB_MEDIUM/M.mob_size)

	M.chem_doses[type] = M.chem_doses[type] + effective
	if(effective >= (metabolism * 0.1) || effective >= 0.1) // If there's too little chemical, don't affect the mob, just remove it
		switch(location)
			if(CHEM_BLOOD)
				affect_blood(M, alien, effective)
			if(CHEM_INGEST)
				affect_ingest(M, alien, effective)
			if(CHEM_TOUCH)
				affect_touch(M, alien, effective)

	if(volume)
		remove_self(removed)
	return

/datum/reagent/proc/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	return

/datum/reagent/proc/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	affect_blood(M, alien, removed * 0.5)
	return

/datum/reagent/proc/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	return

/datum/reagent/proc/overdose(var/mob/living/carbon/M, var/alien) // Overdose effect. Doesn't happen instantly.
	M.add_chemical_effect(CE_TOXIN, 1)
	M.adjustToxLoss(REM)
	return

/datum/reagent/proc/initialize_data(var/newdata) // Called when the reagent is created.
	if(!isnull(newdata))
		data = newdata
	return

/datum/reagent/proc/mix_data(var/newdata, var/newamount) // You have a reagent with data, and new reagent with its own data get added, how do you deal with that?
	return

/datum/reagent/proc/get_data() // Just in case you have a reagent that handles data differently.
	if(data && istype(data, /list))
		return data.Copy()
	else if(data)
		return data
	return null

/datum/reagent/Destroy() // This should only be called by the holder, so it's already handled clearing its references
	holder = null
	. = ..()

/* DEPRECATED - TODO: REMOVE EVERYWHERE */

/datum/reagent/proc/reaction_turf(var/turf/target)
	touch_turf(target)

/datum/reagent/proc/reaction_obj(var/obj/target)
	touch_obj(target)

/datum/reagent/proc/reaction_mob(var/mob/target)
	touch_mob(target)
// Addiction code.... For events

/datum/reagent/proc/addiction_act_stage1(var/mob/living/carbon/M, var/datum/reagent/R)
	if(prob(5))
		switch(R.name)
			if("Nicotine")
				var/message = pick("My mouth is a bit dry...", "A cigarette sure would go down well right now")
				to_chat(M, "<span class='notice'>[message]</span>")
	return

/datum/reagent/proc/addiction_act_stage2(var/mob/living/carbon/M, var/datum/reagent/R)
	var/name = check_name(R.name)
	clear_events(R.name, M)
	if(prob(10))
		var/message = pick("I could use some [name] right now!","I am feeling a bit stressed, sure could use some [name]!","I could use some [name] right now!")
		to_chat(M, "<span class='notice'>[message]</span>")
	M.add_event("addiction", /datum/happiness_event/addiction/withdrawal_small)
	return
/datum/reagent/proc/addiction_act_stage3(var/mob/living/carbon/M, var/datum/reagent/R)
	var/name = check_name(R.name)
	clear_events(R.name, M)
	if(prob(10))
		var/message = pick("I really could use some [name] right now!","I am feeling a bit stressed, sure could use some [name]!","I should use some [name]")
		to_chat(M, "<span class='notice'>[message]</span>")
	M.add_event("addiction", /datum/happiness_event/addiction/withdrawal_medium)
	return

/datum/reagent/proc/addiction_act_stage4(var/mob/living/carbon/M, var/datum/reagent/R)
	var/name = check_name(R.name)
	clear_events(R.name, M)
	if(prob(10))
		var/message = pick("I really should use some [name] right now!","I am stressed, I need to use some [name]!","I should use some [name]")
		to_chat(M, "<span class='notice'>[message]</span>")
	M.add_event("addiction", /datum/happiness_event/addiction/withdrawal_large)
	return
/datum/reagent/proc/addiction_act_stage5(var/mob/living/carbon/M, var/datum/reagent/R)
	var/name = check_name(R.name)
	clear_events(R.name, M)
	if(prob(10))
		var/message = pick("I need to use some [name] right now!","I am stressed, I need to use some [name] RIGHT NOW!","I REALLY NEED SOME [name]")
		to_chat(M, "<span class='notice'>[message]</span>")
	M.add_event("addiction", /datum/happiness_event/addiction/withdrawal_extreme)
	return

/datum/reagent/proc/check_name(var/name)
	switch(name)
		if("Ethanol")
			name = "Alcohol"
	return name

/datum/reagent/proc/clear_events(var/name, var/mob/living/carbon/M)
	switch(name)
		if("Nicotine")
			M.clear_event("relaxed")
		if("Trench drugs")
			M.clear_event("high")
		if("Impedrezene")
			M.clear_event("high")
		if("Psilocybin")
			M.clear_event("high")
		if("Ethanol")
			M.clear_event("booze")
