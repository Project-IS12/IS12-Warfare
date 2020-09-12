mob/proc/flash_weakest_pain()
	flick("weakest_pain",pain)

mob/proc/flash_weak_pain()
	flick("weak_pain",pain)

mob/proc/flash_pain()
	flick("pain",pain)

mob/var/last_pain_message
mob/var/next_pain_time = 0

// message is the custom message to be displayed
// power decides how much painkillers will stop the message
// force means it ignores anti-spam timer
/mob/living/carbon/proc/custom_pain(var/message, var/power, var/force, var/obj/item/organ/external/affecting, var/nohalloss, var/flash_pain)
	if(stat || !can_feel_pain() || chem_effects[CE_PAINKILLER] > power)//!message
		return 0

	// Excessive halloss is horrible, just give them enough to make it visible.
	if(!nohalloss && (power || flash_pain))//Flash pain is so that handle_pain actually makes use of this proc to flash pain.
		var/actual_flash
		if(affecting)
			affecting.add_pain(ceil(power/2))
			if(power > flash_pain)
				actual_flash = power
			else
				actual_flash = flash_pain

			switch(actual_flash)
				if(1 to 50)
					if(has_quirk(/datum/quirk/tough))
						return 0
					flash_weakest_pain()
				if(50 to 90)
					if(has_quirk(/datum/quirk/tough))
						if(prob(75))
							return 0
					flash_weak_pain()
					if(stuttering < 10)
						stuttering += 5
				if(90 to INFINITY)
					if(has_quirk(/datum/quirk/tough))
						if(prob(50))
							return 0
					flash_pain()
					if(stuttering < 10)
						stuttering += 10
					if(prob(5))
						Stun(5)//makes you drop what you're holding.
						Weaken(1)//knocks you over
						agony_scream()
					add_event("pain", /datum/happiness_event/pain)
		else
			adjustHalLoss(ceil(power/2))

	// Anti message spam checks
	// This actually isn't used because I got rid of pain message shit but I don't feel like removing this and breaking everything. - Matt
	if((force || (message != last_pain_message) || (world.time >= next_pain_time)) && message)
		last_pain_message = message
		if(power >= 50)
			to_chat(src, "<b><font size=3>[message]</font></b>")
		else
			to_chat(src, "<b>[message]</b>")
	next_pain_time = world.time + (100-power)

/mob/living/carbon/human/proc/handle_pain()
	if(stat)
		return
	if(!can_feel_pain())
		return
	if(world.time < next_pain_time)
		return
	var/maxdam = 0
	var/obj/item/organ/external/damaged_organ = null
	for(var/obj/item/organ/external/E in organs)
		if(!E.can_feel_pain()) continue
		var/dam = E.get_pain() + E.get_damage()
		// make the choice of the organ depend on damage,
		// but also sometimes use one of the less damaged ones
		if(dam > maxdam && (maxdam == 0 || prob(70)) )
			damaged_organ = E
			maxdam = dam
	if(damaged_organ && chem_effects[CE_PAINKILLER] < maxdam)
		if(maxdam > 10 && paralysis)
			paralysis = max(0, paralysis - round(maxdam/10))
		var/msg
		custom_pain(msg, 0, prob(10), affecting = damaged_organ, flash_pain = maxdam)

	// Damage to internal organs hurts a lot.
	for(var/obj/item/organ/I in internal_organs)
		if((I.status & ORGAN_DEAD) || I.robotic >= ORGAN_ROBOT) continue
		if(I.damage > 2) if(prob(2))
			var/obj/item/organ/external/parent = get_organ(I.parent_organ)
			src.custom_pain("You feel a sharp pain in your [parent.name]", 50, affecting = parent)

	if(prob(2))
		switch(getToxLoss())
			if(10 to 25)
				custom_pain("Your body stings slightly.", getToxLoss())
			if(25 to 45)
				custom_pain("Your whole body hurts badly.", getToxLoss())
			if(61 to INFINITY)
				custom_pain("Your body aches all over, it's driving you mad.", getToxLoss())