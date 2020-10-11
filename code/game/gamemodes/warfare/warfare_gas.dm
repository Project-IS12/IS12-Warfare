//That's just the way it goes on this bitch of an earth.
/datum/reagent/toxin/mustard_gas
	name = "Mustard Gas"
	description = "Doesn't go on hotdogs"
	reagent_state = REAGENT_GAS
	color = "#a2cd5a"
	strength = 30
	touch_met = 5

/datum/reagent/toxin/mustard_gas/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	if(istype(M))
		if(M.wear_mask && (M.wear_mask.item_flags & ITEM_FLAG_AIRTIGHT))
			return
		M.take_organ_damage(0, strength * 0.1)
		M.adjustToxLoss(strength)

	M.take_overall_damage(0, rand(1,15))