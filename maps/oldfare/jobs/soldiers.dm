/datum/job/soldier
	title = "Soldier"
	department = "Security"
	department_flag = SEC
	total_positions = -1
	create_record = FALSE
	account_allowed = FALSE
	social_class = SOCIAL_CLASS_MIN
	has_email = FALSE
	latejoin_at_spawnpoints = TRUE
	can_be_in_squad = TRUE
	announced = TRUE

	//Baseline skill defines
	medical_skill = 6
	surgery_skill = 4
	ranged_skill = 10
	engineering_skill = 5
	melee_skill = 10
	//Gun skills
	auto_rifle_skill = 10
	semi_rifle_skill = 8
	sniper_skill = 4
	shotgun_skill = 4
	lmg_skill = 4
	smg_skill = 4


/mob/living/carbon/human/proc/assign_random_squad(var/team, var/rank)
	switch(team)
		if(RED_TEAM)//You're now put in whatever squad has the least amount of living people in it.
			var/alpha_members = SSwarfare.red.squadA.members.len
			var/bravo_members = SSwarfare.red.squadB.members.len
			var/charlie_members = SSwarfare.red.squadC.members.len
			var/minimum = min(alpha_members, bravo_members, charlie_members)
			if(minimum == alpha_members)
				SSwarfare.red.squadA.members += src
				src.squad = SSwarfare.red.squadA
				//equip_to_slot_or_del(new /obj/item/device/radio/headset/red_team/alpha(src),slot_l_ear) //Saving the original here in case I want to return to it.
				equip_to_slot_or_del(new /obj/item/device/radio/headset/red_team/sl_alpha(src),slot_l_ear)
				var/obj/item/clothing/suit/armor/redcoat/RC = get_equipped_item(slot_wear_suit)
				var/obj/item/clothing/accessory/armband/alpha/A = new(src)
				RC.attach_accessory(src,A)
				if(rank == "medic")
					var/obj/item/clothing/accessory/medal/medical/M = new(src)
					RC.attach_accessory(src,M)
					//var/obj/item/clothing/suit/armor/redcoat/medic/MC = get_equipped_item(slot_wear_suit)
					//MC.icon_state = "redcoat_medic_alpha"
					//MC.item_state = "redcoat_medic_alpha"

			else if(minimum == bravo_members)
				SSwarfare.red.squadB.members += src
				src.squad = SSwarfare.red.squadB
				equip_to_slot_or_del(new /obj/item/device/radio/headset/red_team/sl_bravo(src),slot_l_ear)//equip_to_slot_or_del(new /obj/item/device/radio/headset/red_team/bravo(src),slot_l_ear)
				var/obj/item/clothing/suit/armor/redcoat/RC = get_equipped_item(slot_wear_suit)
				var/obj/item/clothing/accessory/armband/bravo/B = new(src)
				RC.attach_accessory(src,B)
				if(rank == "medic")
					var/obj/item/clothing/accessory/medal/medical/M = new(src)
					RC.attach_accessory(src,M)

			else if(minimum == charlie_members)
				SSwarfare.red.squadC.members += src
				src.squad = SSwarfare.red.squadC
				equip_to_slot_or_del(new /obj/item/device/radio/headset/red_team/sl_charlie(src),slot_l_ear)
				var/obj/item/clothing/suit/armor/redcoat/RC = get_equipped_item(slot_wear_suit)
				var/obj/item/clothing/accessory/armband/charlie/C = new(src.loc)
				RC.attach_accessory(src,C)
				if(rank == "medic")
					var/obj/item/clothing/accessory/medal/medical/M = new(src)
					RC.attach_accessory(src,M)
			else
				SSwarfare.red.squadB.members += src
				src.squad = SSwarfare.red.squadB
				equip_to_slot_or_del(new /obj/item/device/radio/headset/red_team/sl_bravo(src),slot_l_ear)//equip_to_slot_or_del(new /obj/item/device/radio/headset/red_team/bravo(src),slot_l_ear)
				var/obj/item/clothing/suit/armor/redcoat/RC = get_equipped_item(slot_wear_suit)
				var/obj/item/clothing/accessory/armband/bravo/B = new(src.loc)
				RC.attach_accessory(src,B)
				if(rank == "medic")
					var/obj/item/clothing/accessory/medal/medical/M = new(src)
					RC.attach_accessory(src,M)
			/*if(4)
				SSwarfare.red.squadD.members += src
				src.squad = SSwarfare.red.squadD
				equip_to_slot_or_del(new /obj/item/device/radio/headset/red_team/delta(src),slot_l_ear)
			*/
		if(BLUE_TEAM)
			var/alpha_members = SSwarfare.blue.squadA.members.len
			var/bravo_members = SSwarfare.blue.squadB.members.len
			var/charlie_members = SSwarfare.blue.squadC.members.len
			var/minimum = min(alpha_members, bravo_members, charlie_members)
			if(minimum == alpha_members)
				SSwarfare.blue.squadA.members += src
				src.squad = SSwarfare.blue.squadA
				equip_to_slot_or_del(new /obj/item/device/radio/headset/blue_team/sl_alpha(src),slot_l_ear)//equip_to_slot_or_del(new /obj/item/device/radio/headset/blue_team/alpha(src),slot_l_ear)
				var/obj/item/clothing/suit/armor/bluecoat/BC = get_equipped_item(slot_wear_suit)
				var/obj/item/clothing/accessory/armband/alpha/A = new(src)
				BC.attach_accessory(src,A)
				if(rank == "medic")
					var/obj/item/clothing/accessory/medal/medical/M = new(src)
					BC.attach_accessory(src,M)

			else if(minimum == bravo_members)
				SSwarfare.blue.squadB.members += src
				src.squad = SSwarfare.blue.squadB
				equip_to_slot_or_del(new /obj/item/device/radio/headset/blue_team/sl_bravo(src),slot_l_ear)//equip_to_slot_or_del(new /obj/item/device/radio/headset/blue_team/bravo(src),slot_l_ear)
				var/obj/item/clothing/suit/armor/bluecoat/BC = get_equipped_item(slot_wear_suit)
				var/obj/item/clothing/accessory/armband/bravo/B = new(src.loc)
				BC.attach_accessory(src,B)
				if(rank == "medic")
					var/obj/item/clothing/accessory/medal/medical/M = new(src)
					BC.attach_accessory(src,M)

			//else if(charlie_members < alpha_members && charlie_members < bravo_members)
			else if(minimum == charlie_members)
				SSwarfare.blue.squadC.members += src
				src.squad = SSwarfare.blue.squadC
				equip_to_slot_or_del(new /obj/item/device/radio/headset/blue_team/sl_charlie(src),slot_l_ear)//equip_to_slot_or_del(new /obj/item/device/radio/headset/blue_team/charlie(src),slot_l_ear)
				var/obj/item/clothing/suit/armor/bluecoat/BC = get_equipped_item(slot_wear_suit)
				var/obj/item/clothing/accessory/armband/charlie/C = new(src.loc)
				BC.attach_accessory(src,C)
				if(rank == "medic")
					var/obj/item/clothing/accessory/medal/medical/M = new(src)
					BC.attach_accessory(src,M)


			else
				SSwarfare.blue.squadB.members += src
				src.squad = SSwarfare.blue.squadB
				equip_to_slot_or_del(new /obj/item/device/radio/headset/blue_team/sl_bravo(src),slot_l_ear)//equip_to_slot_or_del(new /obj/item/device/radio/headset/blue_team/bravo(src),slot_l_ear)
				var/obj/item/clothing/suit/armor/bluecoat/BC = get_equipped_item(slot_wear_suit)
				var/obj/item/clothing/accessory/armband/bravo/B = new(src.loc)
				BC.attach_accessory(src,B)
				if(rank == "medic")
					var/obj/item/clothing/accessory/medal/medical/M = new(src)
					BC.attach_accessory(src,M)

			/*if(4)
				SSwarfare.blue.squadD.members += src
				src.squad = SSwarfare.blue.squadD
				equip_to_slot_or_del(new /obj/item/device/radio/headset/blue_team/delta(src),slot_l_ear)
			*/

	var/obj/item/card/id/I = GetIdCard()
	var/actual_job = "Soldier"
	switch(rank)
		if("medic")
			actual_job = "Medic"
		if("engineer")
			actual_job = "Engineer"
	I.assignment = "[src.squad.name] Squad [actual_job]"

	to_chat(src, "<b>I am apart of [src.squad.name] Squad</b>")


/mob/living/carbon/human/proc/assign_squad_leader(var/team)
	switch(team)
		if(RED_TEAM)//Start from A, go to D
			if(!SSwarfare.red.squadA.squad_leader)
				SSwarfare.red.squadA.members += src
				SSwarfare.red.squadA.squad_leader = src
				src.squad = SSwarfare.red.squadA
				equip_to_slot_or_del(new /obj/item/device/radio/headset/red_team/sl_alpha(src),slot_l_ear)
				var/obj/item/clothing/suit/armor/redcoat/RC = get_equipped_item(slot_wear_suit)
				var/obj/item/clothing/accessory/armband/alpha/A = new(src)
				RC.attach_accessory(src,A)

			else if(!SSwarfare.red.squadB.squad_leader)
				SSwarfare.red.squadB.members += src
				SSwarfare.red.squadB.squad_leader = src
				src.squad = SSwarfare.red.squadB
				equip_to_slot_or_del(new /obj/item/device/radio/headset/red_team/sl_bravo(src),slot_l_ear)
				var/obj/item/clothing/suit/armor/redcoat/RC = get_equipped_item(slot_wear_suit)
				var/obj/item/clothing/accessory/armband/bravo/B = new(src)
				RC.attach_accessory(src,B)

			else if(!SSwarfare.red.squadC.squad_leader)
				SSwarfare.red.squadC.members += src
				SSwarfare.red.squadC.squad_leader = src
				src.squad = SSwarfare.red.squadC
				equip_to_slot_or_del(new /obj/item/device/radio/headset/red_team/sl_charlie(src),slot_l_ear)
				var/obj/item/clothing/suit/armor/redcoat/RC = get_equipped_item(slot_wear_suit)
				var/obj/item/clothing/accessory/armband/charlie/C = new(src)
				RC.attach_accessory(src,C)

			/*
			else if(!SSwarfare.red.squadD.squad_leader)
				SSwarfare.red.squadD.members += src
				SSwarfare.red.squadD.squad_leader = src
				src.squad = SSwarfare.red.squadD
				equip_to_slot_or_del(new /obj/item/device/radio/headset/red_team/sl_delta(src),slot_l_ear)
			*/
			else//Somehow we have more than 3 SLs, no idea how but let's just exit now.
				return

		if(BLUE_TEAM)
			if(!SSwarfare.blue.squadA.squad_leader)
				SSwarfare.blue.squadA.members += src
				SSwarfare.blue.squadA.squad_leader = src
				src.squad = SSwarfare.blue.squadA
				equip_to_slot_or_del(new /obj/item/device/radio/headset/blue_team/sl_alpha(src),slot_l_ear)
				var/obj/item/clothing/suit/armor/bluecoat/BC = get_equipped_item(slot_wear_suit)
				var/obj/item/clothing/accessory/armband/alpha/A = new(src)
				BC.attach_accessory(src,A)

			else if(!SSwarfare.blue.squadB.squad_leader)
				SSwarfare.blue.squadB.members += src
				SSwarfare.blue.squadB.squad_leader = src
				src.squad = SSwarfare.blue.squadB
				equip_to_slot_or_del(new /obj/item/device/radio/headset/blue_team/sl_bravo(src),slot_l_ear)
				var/obj/item/clothing/suit/armor/bluecoat/BC = get_equipped_item(slot_wear_suit)
				var/obj/item/clothing/accessory/armband/bravo/B = new(src)
				BC.attach_accessory(src,B)

			else if(!SSwarfare.blue.squadC.squad_leader)
				SSwarfare.blue.squadC.members += src
				SSwarfare.blue.squadC.squad_leader = src
				src.squad = SSwarfare.blue.squadC
				equip_to_slot_or_del(new /obj/item/device/radio/headset/blue_team/sl_charlie(src),slot_l_ear)
				var/obj/item/clothing/suit/armor/bluecoat/BC = get_equipped_item(slot_wear_suit)
				var/obj/item/clothing/accessory/armband/charlie/C = new(src)
				BC.attach_accessory(src,C)
			/*
			else if(!SSwarfare.blue.squadD.squad_leader)
				SSwarfare.blue.squadD.members += src
				SSwarfare.blue.squadD.squad_leader = src
				src.squad = SSwarfare.blue.squadD
				equip_to_slot_or_del(new /obj/item/device/radio/headset/blue_team/sl_delta(src),slot_l_ear)
			*/
			else
				return

	var/obj/item/card/id/I = GetIdCard()
	I.assignment = "[src.squad.name] Squad"

	to_chat(src, "<b>I am the Squad Leader of [src.squad.name] Squad</b>")


/mob/proc/voice_in_head(message)
	to_chat(src, "<i>...[message]</i>")

GLOBAL_LIST_INIT(lone_thoughts, list(
		"Why are we still here, just to suffer?",
		"We fight to win, and that's all that matters.",
		"Why we don't get any more reinforcements?",
		"We have not gotten any orders from central command in months...",
		"Did something happened while we were fighting in trenches?",
		"Is there any reason to keep fighting?",
		"Did anyone notice when ash started to fall?",
		"It's middle of summer. Why it's so cold?",
		"Greg died last night.",
		"I do not want to die.",
		"I miss my loved ones.",
		"There is no hope... anymore...",
		"Is there actually a central command?",
		"Is any of this real?",
		"My teeth hurt.",
		"I am not ready to die.",
		"Who keeps dropping the artillery?",
		"I don't remember joining the military..."))

/mob/living/proc/assign_random_quirk()
	if(prob(75))//75% of not choosing a quirk at all.
		return
	if(is_hellbanned())//Hellbanned people will never get quirks.
		return
	var/list/random_quirks = list()
	for(var/thing in subtypesof(/datum/quirk))//Populate possible quirks list.
		var/datum/quirk/Q = thing
		random_quirks += Q
	if(!random_quirks.len)//If there's somewhow nothing there afterwards return.
		return
	var/datum/quirk/chosen_quirk = pick(random_quirks)
	src.quirk = new chosen_quirk
	to_chat(src, "<span class='bnotice'>I was formed a bit different. I am [quirk.name]. [quirk.description]</span>")
	switch(chosen_quirk)
		if(/datum/quirk/cig_addict)
			var/datum/reagent/new_reagent = new /datum/reagent/nicotine
			src.reagents.addiction_list.Add(new_reagent)
		if(/datum/quirk/alcoholic)
			var/datum/reagent/new_reagent = new /datum/reagent/ethanol
			src.reagents.addiction_list.Add(new_reagent)
