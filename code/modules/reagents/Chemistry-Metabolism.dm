/datum/reagents/metabolism
	var/metabolism_class //CHEM_TOUCH, CHEM_INGEST, or CHEM_BLOOD
	var/mob/living/carbon/parent

/datum/reagents/metabolism/New(var/max = 100, mob/living/carbon/parent_mob, var/met_class)
	..(max, parent_mob)

	metabolism_class = met_class
	if(istype(parent_mob))
		parent = parent_mob

/datum/reagents/metabolism/proc/metabolize()

	var/metabolism_type = 0 //non-human mobs
	if(ishuman(parent))
		var/mob/living/carbon/human/H = parent
		metabolism_type = H.species.reagent_tag

	for(var/datum/reagent/current in reagent_list)
		current.on_mob_life(parent, metabolism_type, metabolism_class)

	if(istype(parent, /mob/living/carbon/human))
		for(var/A in parent.reagents.addiction_list)
			var/datum/reagent/R = A
			if(parent && R)
				if(world.timeofday > (R.last_addiction_dose + R.time_addiction_update))
					if(R.addiction_stage < 100)
						R.addiction_stage++
					switch(R.addiction_stage)
						if(1 to 10)
							R.addiction_act_stage1(parent,R)
						if(11 to 30)
							R.addiction_act_stage2(parent,R)
						if(31 to 60)
							R.addiction_act_stage3(parent,R)
						if(61 to 80)
							R.addiction_act_stage4(parent,R)
						if(81 to 100)
							R.addiction_act_stage5(parent,R)
					R.last_addiction_dose = world.timeofday
	update_total()