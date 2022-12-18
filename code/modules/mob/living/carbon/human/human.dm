/mob/living/carbon/human
	name = "unknown"
	real_name = "unknown"
	voice_name = "unknown"
	icon = 'icons/mob/human.dmi'
	icon_state = "body_m_s"

	var/list/hud_list[10]
	var/embedded_flag	  //To check if we've need to roll for damage on movement while an item is imbedded in us.

/mob/living/carbon/human/New(var/new_loc, var/new_species = null)

	if(!dna)
		dna = new /datum/dna(null)
		// Species name is handled by set_species()

	if(!species)
		if(new_species)
			set_species(new_species,1)
		else
			set_species()

	if(species)
		real_name = species.get_random_name(gender)
		SetName(real_name)
		if(mind)
			mind.name = real_name

	hud_list[HEALTH_HUD]      = new /image/hud_overlay('icons/mob/hud_med.dmi', src, "100")
	hud_list[STATUS_HUD]      = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudhealthy")
	hud_list[LIFE_HUD]	      = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudhealthy")
	hud_list[ID_HUD]          = new /image/hud_overlay(GLOB.using_map.id_hud_icons, src, "hudunknown")
	hud_list[WANTED_HUD]      = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudblank")
	hud_list[IMPLOYAL_HUD]    = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudblank")
	hud_list[IMPCHEM_HUD]     = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudblank")
	hud_list[IMPTRACK_HUD]    = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudblank")
	hud_list[SPECIALROLE_HUD] = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudblank")
	hud_list[STATUS_HUD_OOC]  = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudhealthy")

	GLOB.human_mob_list |= src
	..()

	init_skills()
	init_stats()
	add_teeth()
	bladder = rand(0,100)
	bowels = rand(0, 100)
	overlay_fullscreen("fademob", /obj/screen/fullscreen/fadeoutok)

	if(dna)
		dna.ready_dna(src)
		dna.real_name = real_name
		dna.s_base = s_base
		sync_organ_dna()
	make_blood()
	spawn(10)
		var/turf/T = get_turf(src)
		var/obj/structure/bed/padded/B = locate() in T
		if(B)
			B.buckle_mob(src)

/mob/living/carbon/human/Destroy()
	GLOB.human_mob_list -= src
	worn_underwear = null
	for(var/organ in organs)
		qdel(organ)
	return ..()

/mob/living/carbon/human/Stat()
	. = ..()
	if(statpanel("Status"))
		if(iswarfare())
			//stat("[BLUE_TEAM] reinforcements:", SSwarfare.blue.left)
			//stat("[BLUE_TEAM] capture points:", SSwarfare.blue.points)
			//stat("[RED_TEAM] reinforcements:", SSwarfare.red.left)
			//stat("[RED_TEAM] capture points:", SSwarfare.red.points)


			if(warfare_faction == RED_TEAM)
				for(var/area/A in GLOB.red_captured_zones)
					stat("Captured Trench:", A)
			if(warfare_faction == BLUE_TEAM)
				for(var/area/A in GLOB.blue_captured_zones)
					stat("Captured Trench:", A)

		if(crouching)
			stat("Stance:", "Crouching")
		else if(lying)
			stat("Stance:", "Lying Down")
		else
			stat("Stance:", "Standing")

		stat("[my_stats[STAT(str)].shorthand]:", "[STAT_LEVEL(str)]")//Stats!
		stat("[my_stats[STAT(dex)].shorthand]:", "[STAT_LEVEL(dex)]")
		stat("[my_stats[STAT(end)].shorthand]:", "[STAT_LEVEL(end)]")
		stat("[my_stats[STAT(int)].shorthand]:", "[STAT_LEVEL(int)]")

		//if(evacuation_controller)
		//	var/eta_status = evacuation_controller.get_status_panel_eta()
		//	if(eta_status)
		//		stat(null, eta_status)

		if (istype(internal))
			if (!internal.air_contents)
				qdel(internal)
			else
				stat("Internal Atmosphere Info", internal.name)
				stat("Tank Pressure", internal.air_contents.return_pressure())
				stat("Distribution Pressure", internal.distribute_pressure)


		var/obj/item/organ/internal/cell/potato = internal_organs_by_name[BP_CELL]
		if(potato && potato.cell)
			stat("Battery charge:", "[potato.get_charge()]/[potato.cell.maxcharge]")

		if(mind)
			if(mind.changeling)
				stat("Chemical Storage", mind.changeling.chem_charges)
				stat("Genetic Damage Time", mind.changeling.geneticdamage)

/mob/living/carbon/human/ex_act(severity)
	if(!blinded)
		flash_eyes()

	var/b_loss = null
	var/f_loss = null
	switch (severity)
		if (1.0)
			b_loss = 400
			f_loss = 100
			if (!prob(getarmor(null, "bomb")))
				gib()
				return
			else
				var/atom/target = get_edge_target_turf(src, get_dir(src, get_step_away(src, src)))
				throw_at(target, 200, 4)

		if (2.0)
			b_loss = 60
			f_loss = 60

			if (!istype(l_ear, /obj/item/clothing/ears/earmuffs) && !istype(r_ear, /obj/item/clothing/ears/earmuffs))
				ear_damage += 30
				ear_deaf += 120
			if (prob(70))
				Paralyse(10)

		if(3.0)
			b_loss = 30
			if (!istype(l_ear, /obj/item/clothing/ears/earmuffs) && !istype(r_ear, /obj/item/clothing/ears/earmuffs))
				ear_damage += 15
				ear_deaf += 60
			if (prob(50))
				Paralyse(10)

	// factor in armour
	var/protection = blocked_mult(getarmor(null, "bomb"))
	b_loss *= protection
	f_loss *= protection

	// focus most of the blast on one organ
	var/obj/item/organ/external/take_blast = pick(organs)
	take_blast.take_damage(b_loss * 0.7, f_loss * 0.7, used_weapon = "Explosive blast")

	// distribute the remaining 30% on all limbs equally (including the one already dealt damage)
	b_loss *= 0.3
	f_loss *= 0.3

	var/weapon_message = "Explosive Blast"
	for(var/obj/item/organ/external/temp in organs)
		var/loss_val
		if(temp.organ_tag  == BP_HEAD)
			loss_val = 0.2
		else if(temp.organ_tag == BP_CHEST)
			loss_val = 0.4
		else
			loss_val = 0.05
		temp.take_damage(b_loss * loss_val, f_loss * loss_val, used_weapon = weapon_message)

/mob/living/carbon/human/proc/implant_loyalty(mob/living/carbon/human/M, override = FALSE) // Won't override by default.
	if(!config.use_loyalty_implants && !override) return // Nuh-uh.

	var/obj/item/implant/loyalty/L = new/obj/item/implant/loyalty(M)
	L.imp_in = M
	L.implanted = 1
	var/obj/item/organ/external/affected = M.organs_by_name[BP_HEAD]
	affected.implants += L
	L.part = affected
	L.implanted(src)

/mob/living/carbon/human/proc/is_loyalty_implanted(mob/living/carbon/human/M)
	for(var/L in M.contents)
		if(istype(L, /obj/item/implant/loyalty))
			for(var/obj/item/organ/external/O in M.organs)
				if(L in O.implants)
					return 1
	return 0

/mob/living/carbon/human/restrained()
	if (handcuffed)
		return 1
	if(grab_restrained())
		return 1
	if (istype(wear_suit, /obj/item/clothing/suit/straight_jacket))
		return 1
	return 0

/mob/living/carbon/human/proc/grab_restrained()
	for (var/obj/item/grab/G in grabbed_by)
		if(G.restrains())
			return TRUE

/mob/living/carbon/human/var/co2overloadtime = null
/mob/living/carbon/human/var/temperature_resistance = T0C+75


/mob/living/carbon/human/show_inv(mob/user as mob)
	if(user.incapacitated()  || !user.Adjacent(src) || !user.IsAdvancedToolUser())
		return

	var/datum/browser/popup = new(user, "mob[name]", FALSE, 340, 540)
	user.set_machine(src)
	var/dat = "<B><HR><FONT size=3>[name]</FONT></B><BR><HR>"

	for(var/entry in species.hud.gear)
		var/list/slot_ref = species.hud.gear[entry]
		if((slot_ref["slot"] in list(slot_l_store, slot_r_store)))
			continue
		var/obj/item/thing_in_slot = get_equipped_item(slot_ref["slot"])
		dat += "<BR><B>[slot_ref["name"]]:</b> <a href='?src=\ref[src];item=[slot_ref["slot"]]'>[istype(thing_in_slot) ? thing_in_slot : "nothing"]</a>"
		if(istype(thing_in_slot, /obj/item/clothing))
			var/obj/item/clothing/C = thing_in_slot
			if(C.accessories.len)
				dat += "<BR><A href='?src=\ref[src];item=tie;holder=\ref[C]'>Remove accessory</A>"
	dat += "<BR><HR>"

	if(species.hud.has_hands)
		dat += "<BR><b>Left hand:</b> <A href='?src=\ref[src];item=[slot_l_hand]'>[istype(l_hand) ? l_hand : "nothing"]</A>"
		dat += "<BR><b>Right hand:</b> <A href='?src=\ref[src];item=[slot_r_hand]'>[istype(r_hand) ? r_hand : "nothing"]</A>"

	// Do they get an option to set internals?
	if(istype(wear_mask, /obj/item/clothing/mask) || istype(head, /obj/item/clothing/head/helmet/space))
		if(istype(back, /obj/item/tank) || istype(belt, /obj/item/tank) || istype(s_store, /obj/item/tank))
			dat += "<BR><A href='?src=\ref[src];item=internals'>Toggle internals.</A>"

	var/obj/item/clothing/under/suit = w_uniform
	// Other incidentals.
	if(istype(suit))
		dat += "<BR><b>Pockets:</b> <A href='?src=\ref[src];item=pockets'>Empty or Place Item</A>"
		if(suit.has_sensor == 1)
			dat += "<BR><A href='?src=\ref[src];item=sensors'>Set sensors</A>"
	if(handcuffed)
		dat += "<BR><A href='?src=\ref[src];item=[slot_handcuffed]'>Handcuffed</A>"

	for(var/entry in worn_underwear)
		var/obj/item/underwear/UW = entry
		dat += "<BR><a href='?src=\ref[src];item=\ref[UW]'>Remove \the [UW]</a>"

	dat += "<BR><A href='?src=\ref[src];item=splints'>Remove splints</A>"
	dat += "<BR><A href='?src=\ref[src];refresh=1'>Refresh</A>"
	dat += "<BR><A href='?src=\ref[user];mach_close=mob[name]'>Close</A>"


	popup.set_content(jointext(dat, null))
	popup.open()
	//user << browse(dat, text("window=mob[name];size=340x540"))
	onclose(user, "mob[name]")
	return

// called when something steps onto a human
// this handles mulebots and vehicles
/mob/living/carbon/human/Crossed(var/atom/movable/AM)
	if(istype(AM, /mob/living/bot/mulebot))
		var/mob/living/bot/mulebot/MB = AM
		MB.runOver(src)

	if(istype(AM, /obj/vehicle))
		var/obj/vehicle/V = AM
		V.RunOver(src)

// Get rank from ID, ID inside PDA, PDA, ID in wallet, etc.
/mob/living/carbon/human/proc/get_authentification_rank(var/if_no_id = "No id", var/if_no_job = "No job")
	var/obj/item/device/pda/pda = wear_id
	if (istype(pda))
		if (pda.id)
			return pda.id.rank
		else
			return pda.ownrank
	else
		var/obj/item/card/id/id = get_idcard()
		if(id)
			return id.rank ? id.rank : if_no_job
		else
			return if_no_id

//gets assignment from ID or ID inside PDA or PDA itself
//Useful when player do something with computers
/mob/living/carbon/human/proc/get_assignment(var/if_no_id = "No id", var/if_no_job = "No job")
	var/obj/item/device/pda/pda = wear_id
	if (istype(pda))
		if (pda.id)
			return pda.id.assignment
		else
			return pda.ownjob
	else
		var/obj/item/card/id/id = get_idcard()
		if(id)
			return id.assignment ? id.assignment : if_no_job
		else
			return if_no_id

//gets name from ID or ID inside PDA or PDA itself
//Useful when player do something with computers
/mob/living/carbon/human/proc/get_authentification_name(var/if_no_id = "Unknown")
	var/obj/item/device/pda/pda = wear_id
	if (istype(pda))
		if (pda.id)
			return pda.id.registered_name
		else
			return pda.owner
	else
		var/obj/item/card/id/id = get_idcard()
		if(id)
			return id.registered_name
		else
			return if_no_id

//repurposed proc. Now it combines get_id_name() and get_face_name() to determine a mob's name variable. Made into a seperate proc as it'll be useful elsewhere
/mob/living/carbon/human/proc/get_visible_name()
	var/face_name = get_face_name()
	var/id_name = get_id_name("")
	if(is_anonymous)
		return "Unknown"

	else if(face_name == "Unknown" && id_name)
		var/job = get_assignment()
		if(job == "No job")//We don't want them named "No job", that looks dumb.
			job = ""
		else
			job = "[job] "
		return "[job][ageAndGender2Desc(age, gender)]"

	if(id_name && (id_name != face_name) && face_name != "Unknown")
		return "[face_name] (as [id_name])"

	else if(id_name && (id_name != face_name) && face_name == "Unknown")//Hacky af.
		return id_name

	return face_name



//Returns "Unknown" if facially disfigured and real_name if not. Useful for setting name when polyacided or when updating a human's name variable
//Also used in AI tracking people by face, so added in checks for head coverings like masks and helmets
/mob/living/carbon/human/proc/get_face_name()
	var/obj/item/organ/external/H = get_organ(BP_HEAD)
	if(!H || is_anonymous || H.disfigured || H.is_stump() || !real_name || (HUSK in mutations) || (wear_mask && (wear_mask.flags_inv&HIDEFACE)) || (head && (head.flags_inv&HIDEFACE)))	//Face is unrecognizeable, use ID if able
		return "Unknown"
	return real_name

//gets name from ID or PDA itself, ID inside PDA doesn't matter
//Useful when player is being seen by other mobs
/mob/living/carbon/human/proc/get_id_name(var/if_no_id = "Unknown")
	. = if_no_id
	if(istype(wear_id,/obj/item/device/pda))
		var/obj/item/device/pda/P = wear_id
		return P.owner
	if(wear_id)
		var/obj/item/card/id/I = wear_id.GetIdCard()
		if(I)
			return I.registered_name
	return

/mob/living/carbon/human/proc/get_job_name()
	if(wear_id)
		var/obj/item/card/id/I = wear_id.GetIdCard()
		if(I)
			return I.assignment


//gets ID card object from special clothes slot or null.
/mob/living/carbon/human/proc/get_idcard()
	if(wear_id)
		return wear_id.GetIdCard()

//Removed the horrible safety parameter. It was only being used by ninja code anyways.
//Now checks siemens_coefficient of the affected area by default
/mob/living/carbon/human/electrocute_act(var/shock_damage, var/obj/source, var/base_siemens_coeff = 1.0, var/def_zone = null)

	if(status_flags & GODMODE)	return 0	//godmode

	if(species.siemens_coefficient == -1)
		if(stored_shock_by_ref["\ref[src]"])
			stored_shock_by_ref["\ref[src]"] += shock_damage
		else
			stored_shock_by_ref["\ref[src]"] = shock_damage
		return

	if (!def_zone)
		def_zone = pick(BP_L_HAND, BP_R_HAND)

	return ..(shock_damage, source, base_siemens_coeff, def_zone)

/mob/living/carbon/human/apply_shock(var/shock_damage, var/def_zone, var/base_siemens_coeff = 1.0)
	var/obj/item/organ/external/initial_organ = get_organ(check_zone(def_zone))
	if(!initial_organ)
		initial_organ = pick(organs)

	var/obj/item/organ/external/floor_organ

	if(!lying)
		var/obj/item/organ/external/list/standing = list()
		for(var/limb_tag in list(BP_L_FOOT, BP_R_FOOT))
			var/obj/item/organ/external/E = organs_by_name[limb_tag]
			if(E && E.is_usable())
				standing[E.organ_tag] = E
		if((def_zone == BP_L_FOOT || def_zone == BP_L_LEG) && standing[BP_L_FOOT])
			floor_organ = standing[BP_L_FOOT]
		if((def_zone == BP_R_FOOT || def_zone == BP_R_LEG) && standing[BP_R_FOOT])
			floor_organ = standing[BP_R_FOOT]
		else
			floor_organ = standing[pick(standing)]

	if(!floor_organ)
		floor_organ = pick(organs)

	var/obj/item/organ/external/list/to_shock = trace_shock(initial_organ, floor_organ)

	if(to_shock && to_shock.len)
		shock_damage /= to_shock.len
		shock_damage = round(shock_damage, 0.1)
	else
		return 0

	var/total_damage = 0

	for(var/obj/item/organ/external/E in to_shock)
		total_damage += ..(shock_damage, E.organ_tag, base_siemens_coeff * get_siemens_coefficient_organ(E))
	return total_damage

/mob/living/carbon/human/proc/trace_shock(var/obj/item/organ/external/init, var/obj/item/organ/external/floor)
	var/obj/item/organ/external/list/traced_organs = list(floor)

	if(!init)
		return

	if(!floor || init == floor)
		return list(init)

	for(var/obj/item/organ/external/E in list(floor, init))
		while(E && E.parent_organ)
			E = organs_by_name[E.parent_organ]
			traced_organs += E
			if(E == init)
				return traced_organs

	return traced_organs

/mob/living/carbon/human/Topic(href, href_list)

	if (href_list["refresh"])
		if(Adjacent(src, usr))
			show_inv(usr)

	if (href_list["mach_close"])
		var/t1 = text("window=[]", href_list["mach_close"])
		unset_machine()
		src << browse(null, t1)

	if(href_list["item"])
		handle_strip(href_list["item"],usr,locate(href_list["holder"]))
		//show_inv(usr)

	if (href_list["criminal"])
		if(hasHUD(usr,"security"))

			var/modified = 0
			var/perpname = "wot"
			if(wear_id)
				var/obj/item/card/id/I = wear_id.GetIdCard()
				if(I)
					perpname = I.registered_name
				else
					perpname = name
			else
				perpname = name

			var/datum/computer_file/crew_record/R = get_crewmember_record(perpname)
			if(R)
				var/setcriminal = input(usr, "Specify a new criminal status for this person.", "Security HUD", R.get_criminalStatus()) as anything in GLOB.security_statuses
				if(hasHUD(usr, "security") && setcriminal)
					R.set_criminalStatus(setcriminal)
					modified = 1

					spawn()
						BITSET(hud_updateflag, WANTED_HUD)
						if(istype(usr,/mob/living/carbon/human))
							var/mob/living/carbon/human/U = usr
							U.handle_regular_hud_updates()
						if(istype(usr,/mob/living/silicon/robot))
							var/mob/living/silicon/robot/U = usr
							U.handle_regular_hud_updates()

			if(!modified)
				to_chat(usr, "<span class='warning'>Unable to locate a data core entry for this person.</span>")
	if (href_list["secrecord"])
		if(hasHUD(usr,"security"))
			var/perpname = "wot"
			var/read = 0

			if(wear_id)
				if(istype(wear_id,/obj/item/card/id))
					perpname = wear_id:registered_name
				else if(istype(wear_id,/obj/item/device/pda))
					var/obj/item/device/pda/tempPda = wear_id
					perpname = tempPda.owner
			else
				perpname = src.name
			var/datum/computer_file/crew_record/E = get_crewmember_record(perpname)
			if(E)
				if(hasHUD(usr,"security"))
					to_chat(usr, "<b>Name:</b> [E.get_name()]")
					to_chat(usr, "<b>Criminal Status:</b> [E.get_criminalStatus()]")
					to_chat(usr, "<b>Details:</b> [pencode2html(E.get_criminalStatus())]")
					read = 1

			if(!read)
				to_chat(usr, "<span class='warning'>Unable to locate a data core entry for this person.</span>")
	if (href_list["medical"])
		if(hasHUD(usr,"medical"))
			var/perpname = "wot"
			var/modified = 0

			if(wear_id)
				if(istype(wear_id,/obj/item/card/id))
					perpname = wear_id:registered_name
				else if(istype(wear_id,/obj/item/device/pda))
					var/obj/item/device/pda/tempPda = wear_id
					perpname = tempPda.owner
			else
				perpname = src.name

			var/datum/computer_file/crew_record/E = get_crewmember_record(perpname)
			if(E)
				var/setmedical = input(usr, "Specify a new medical status for this person.", "Medical HUD", E.get_status()) as anything in GLOB.physical_statuses
				if(hasHUD(usr,"medical") && setmedical)
					E.set_status(setmedical)
					modified = 1

					spawn()
						if(istype(usr,/mob/living/carbon/human))
							var/mob/living/carbon/human/U = usr
							U.handle_regular_hud_updates()
						if(istype(usr,/mob/living/silicon/robot))
							var/mob/living/silicon/robot/U = usr
							U.handle_regular_hud_updates()

			if(!modified)
				to_chat(usr, "<span class='warning'>Unable to locate a data core entry for this person.</span>")
	if (href_list["medrecord"])
		if(hasHUD(usr,"medical"))
			var/perpname = "wot"
			var/read = 0

			if(wear_id)
				if(istype(wear_id,/obj/item/card/id))
					perpname = wear_id:registered_name
				else if(istype(wear_id,/obj/item/device/pda))
					var/obj/item/device/pda/tempPda = wear_id
					perpname = tempPda.owner
			else
				perpname = src.name
			var/datum/computer_file/crew_record/E = get_crewmember_record(perpname)
			if(E)
				if(hasHUD(usr,"medical"))
					to_chat(usr, "<b>Name:</b> [E.get_name()]")
					to_chat(usr, "<b>Gender:</b> [E.get_sex()]")
					//to_chat(usr, "<b>Species:</b> [E.get_species()]")
					to_chat(usr, "<b>Blood Type:</b> [E.get_bloodtype()]")
					to_chat(usr, "<b>Details:</b> [pencode2html(E.get_medRecord())]")
					read = 1
			if(!read)
				to_chat(usr, "<span class='warning'>Unable to locate a data core entry for this person.</span>")

	if (href_list["lookitem"])
		var/obj/item/I = locate(href_list["lookitem"])
		if(I)
			src.examinate(I)

	if (href_list["lookmob"])
		var/mob/M = locate(href_list["lookmob"])
		if(M)
			src.examinate(M)

	if (href_list["flavor_change"])
		switch(href_list["flavor_change"])
			if("done")
				src << browse(null, "window=flavor_changes")
				return
			if("general")
				var/msg = sanitize(input(usr,"Update the general description of your character. This will be shown regardless of clothing, and may include OOC notes and preferences.","Flavor Text",html_decode(flavor_texts[href_list["flavor_change"]])) as message, extra = 0)
				flavor_texts[href_list["flavor_change"]] = sanitize(msg, extra = 0)
				return
			else
				var/msg = sanitize(input(usr,"Update the flavor text for your [href_list["flavor_change"]].","Flavor Text",html_decode(flavor_texts[href_list["flavor_change"]])) as message, extra = 0)
				flavor_texts[href_list["flavor_change"]] = sanitize(msg, extra = 0)
			//	set_flavor()
				return
	//Crafting
	if (href_list["craft"])
		var/turf/T = get_step(src, dir)
		if(!T.Adjacent(src))
			return 0
		var/rname = href_list["craft"]
		var/datum/crafting_recipe/R = crafting_recipes[rname]
		R.make(src, T)

	..()
	return

///eyecheck()
///Returns a number between -1 to 2
/mob/living/carbon/human/eyecheck()
	var/total_protection = flash_protection
	if(internal_organs_by_name[BP_EYES]) // Eyes are fucked, not a 'weak point'.
		var/obj/item/organ/internal/eyes/I = internal_organs_by_name[BP_EYES]
		if(!I.is_usable())
			return FLASH_PROTECTION_MAJOR
		else
			total_protection = I.get_total_protection(flash_protection)
	else // They can't be flashed if they don't have eyes.
		return FLASH_PROTECTION_MAJOR
	return total_protection

/mob/living/carbon/human/flash_eyes(var/intensity = FLASH_PROTECTION_MODERATE, override_blindness_check = FALSE, affect_silicon = FALSE, visual = FALSE, type = /obj/screen/fullscreen/flash)
	if(internal_organs_by_name[BP_EYES]) // Eyes are fucked, not a 'weak point'.
		var/obj/item/organ/internal/eyes/I = internal_organs_by_name[BP_EYES]
		I.additional_flash_effects(intensity)
	return ..()

//Used by various things that knock people out by applying blunt trauma to the head.
//Checks that the species has a "head" (brain containing organ) and that hit_zone refers to it.
/mob/living/carbon/human/proc/headcheck(var/target_zone, var/brain_tag = BP_BRAIN)

	var/obj/item/organ/affecting = internal_organs_by_name[brain_tag]

	target_zone = check_zone(target_zone)
	if(!affecting || affecting.parent_organ != target_zone)
		return 0

	//if the parent organ is significantly larger than the brain organ, then hitting it is not guaranteed
	var/obj/item/organ/parent = get_organ(target_zone)
	if(!parent)
		return 0

	if(parent.w_class > affecting.w_class + 1)
		return prob(100 / 2**(parent.w_class - affecting.w_class - 1))

	return 1

/mob/living/carbon/human/IsAdvancedToolUser(var/silent)
	if(species.has_fine_manipulation && !nabbing)
		return 1
	if(!silent)
		to_chat(src, "<span class='warning'>You don't have the dexterity to use that!</span>")
	return 0

/mob/living/carbon/human/abiotic(var/full_body = TRUE)
	if(full_body)
		if(src.head || src.shoes || src.w_uniform || src.wear_suit || src.glasses || src.l_ear || src.r_ear || src.gloves)
			return FALSE
	return ..()

/mob/living/carbon/human/proc/check_dna()
	dna.check_integrity(src)
	return

/mob/living/carbon/human/get_species()
	if(!species)
		set_species()
	return species.name

/mob/living/carbon/human/proc/play_xylophone()
	if(!src.xylophone)
		visible_message("<span class='warning'>\The [src] begins playing \his ribcage like a xylophone. It's quite spooky.</span>","<span class='notice'>You begin to play a spooky refrain on your ribcage.</span>","<span class='warning'>You hear a spooky xylophone melody.</span>")
		var/song = pick('sound/effects/xylophone1.ogg','sound/effects/xylophone2.ogg','sound/effects/xylophone3.ogg')
		playsound(loc, song, 50, 1, -1)
		xylophone = 1
		spawn(1200)
			xylophone=0
	return

/mob/living/proc/check_has_mouth()
	// mobs do not have mouths by default
	return 0

/mob/living/carbon/human/check_has_mouth()
	// Todo, check stomach organ when implemented.
	var/obj/item/organ/external/head/H = get_organ(BP_HEAD)
	if(!H || !istype(H) || !H.can_intake_reagents)
		return 0
	return 1

/mob/living/carbon/human/proc/vomit(var/toxvomit = 0, var/timevomit = 1, var/level = 3)
	set waitfor = 0
	if(!check_has_mouth() || isSynthetic() || !timevomit || !level)
		return
	level = Clamp(level, 1, 3)
	timevomit = Clamp(timevomit, 1, 10)
	if(stat == DEAD)
		return
	if(!lastpuke)
		lastpuke = 1
		to_chat(src, "<span class='warning'>You feel nauseous...</span>")
		if(level > 1)
			sleep(150 / timevomit)	//15 seconds until second warning
			to_chat(src, "<span class='warning'>You feel like you are about to throw up!</span>")
			if(level > 2)
				sleep(100 / timevomit)	//and you have 10 more for mad dash to the bucket
				Stun(1)
				if(nutrition < 40)
					custom_emote(1,"dry heaves.")
				else
					for(var/a in stomach_contents)
						var/atom/movable/A = a
						A.forceMove(get_turf(src))
						stomach_contents.Remove(a)
						if(src.species.gluttonous & GLUT_PROJECTILE_VOMIT)
							A.throw_at(get_edge_target_turf(src,src.dir),7,7,src)

					src.visible_message("<span class='warning'>[src] throws up!</span>","<span class='warning'>You throw up!</span>")
					playsound(src, 'sound/effects/vomit.ogg', 50, 1)
					playsound(src, 'sound/effects/splat.ogg', 50, 1)
					add_event("hygiene", /datum/happiness_event/hygiene/vomitted)

					var/turf/location = loc
					if (istype(location, /turf/simulated))
						location.add_vomit_floor(src, toxvomit)
					ingested.remove_any(5)
					nutrition -= 30
		sleep(350)	//wait 35 seconds before next volley
		lastpuke = 0

/mob/living/carbon/human/proc/morph()
	set name = "Morph"
	set category = "Superpower"

	if(stat!=CONSCIOUS)
		reset_view(0)
		remoteview_target = null
		return

	if(!(mMorph in mutations))
		src.verbs -= /mob/living/carbon/human/proc/morph
		return

	var/new_facial = input("Please select facial hair color.", "Character Generation",rgb(r_facial,g_facial,b_facial)) as color
	if(new_facial)
		r_facial = hex2num(copytext(new_facial, 2, 4))
		g_facial = hex2num(copytext(new_facial, 4, 6))
		b_facial = hex2num(copytext(new_facial, 6, 8))

	var/new_hair = input("Please select hair color.", "Character Generation",rgb(r_hair,g_hair,b_hair)) as color
	if(new_facial)
		r_hair = hex2num(copytext(new_hair, 2, 4))
		g_hair = hex2num(copytext(new_hair, 4, 6))
		b_hair = hex2num(copytext(new_hair, 6, 8))

	var/new_eyes = input("Please select eye color.", "Character Generation",rgb(r_eyes,g_eyes,b_eyes)) as color
	if(new_eyes)
		r_eyes = hex2num(copytext(new_eyes, 2, 4))
		g_eyes = hex2num(copytext(new_eyes, 4, 6))
		b_eyes = hex2num(copytext(new_eyes, 6, 8))
		update_eyes()

	var/new_tone = input("Please select skin tone level: 1-220 (1=albino, 35=caucasian, 150=black, 220='very' black)", "Character Generation", "[35-s_tone]")  as text

	if (!new_tone)
		new_tone = 35
	s_tone = max(min(round(text2num(new_tone)), 220), 1)
	s_tone =  -s_tone + 35

	// hair
	var/list/all_hairs = typesof(/datum/sprite_accessory/hair) - /datum/sprite_accessory/hair
	var/list/hairs = list()

	// loop through potential hairs
	for(var/x in all_hairs)
		var/datum/sprite_accessory/hair/H = new x // create new hair datum based on type x
		hairs.Add(H.name) // add hair name to hairs
		qdel(H) // delete the hair after it's all done

	var/new_style = input("Please select hair style", "Character Generation",h_style)  as null|anything in hairs

	// if new style selected (not cancel)
	if (new_style)
		h_style = new_style

	// facial hair
	var/list/all_fhairs = typesof(/datum/sprite_accessory/facial_hair) - /datum/sprite_accessory/facial_hair
	var/list/fhairs = list()

	for(var/x in all_fhairs)
		var/datum/sprite_accessory/facial_hair/H = new x
		fhairs.Add(H.name)
		qdel(H)

	new_style = input("Please select facial style", "Character Generation",f_style)  as null|anything in fhairs

	if(new_style)
		f_style = new_style

	var/new_gender = alert(usr, "Please select gender.", "Character Generation", "Male", "Female", "Neutral")
	if (new_gender)
		if(new_gender == "Male")
			gender = MALE
		else if(new_gender == "Female")
			gender = FEMALE
		else
			gender = NEUTER
	regenerate_icons()
	check_dna()

	visible_message("<span class='notice'>\The [src] morphs and changes [get_visible_gender() == MALE ? "his" : get_visible_gender() == FEMALE ? "her" : "their"] appearance!</span>", "<span class='notice'>You change your appearance!</span>", "<span class='warning'>Oh, god!  What the hell was that?  It sounded like flesh getting squished and bone ground into a different shape!</span>")

/mob/living/carbon/human/proc/remotesay()
	set name = "Project mind"
	set category = "Superpower"

	if(stat!=CONSCIOUS)
		reset_view(0)
		remoteview_target = null
		return

	if(!(mRemotetalk in src.mutations))
		src.verbs -= /mob/living/carbon/human/proc/remotesay
		return
	var/list/creatures = list()
	for(var/mob/living/carbon/h in world)
		creatures += h
	var/mob/target = input("Who do you want to project your mind to ?") as null|anything in creatures
	if (isnull(target))
		return

	var/say = sanitize(input("What do you wish to say"))
	if(mRemotetalk in target.mutations)
		target.show_message("<span class='notice'>You hear [src.real_name]'s voice: [say]</span>")
	else
		target.show_message("<span class='notice'>You hear a voice that seems to echo around the room: [say]</span>")
	usr.show_message("<span class='notice'>You project your mind into [target.real_name]: [say]</span>")
	log_say("[key_name(usr)] sent a telepathic message to [key_name(target)]: [say]")
	for(var/mob/observer/ghost/G in world)
		G.show_message("<i>Telepathic message from <b>[src]</b> to <b>[target]</b>: [say]</i>")

/mob/living/carbon/human/proc/remoteobserve()
	set name = "Remote View"
	set category = "Superpower"

	if(stat!=CONSCIOUS)
		remoteview_target = null
		reset_view(0)
		return

	if(!(mRemote in src.mutations))
		remoteview_target = null
		reset_view(0)
		src.verbs -= /mob/living/carbon/human/proc/remoteobserve
		return

	if(client.eye != client.mob)
		remoteview_target = null
		reset_view(0)
		return

	var/list/mob/creatures = list()

	for(var/mob/living/carbon/h in world)
		var/turf/temp_turf = get_turf(h)
		if((temp_turf.z != 1 && temp_turf.z != 5) || h.stat!=CONSCIOUS) //Not on mining or the station. Or dead
			continue
		creatures += h

	var/mob/target = input ("Who do you want to project your mind to ?") as mob in creatures

	if (target)
		remoteview_target = target
		reset_view(target)
	else
		remoteview_target = null
		reset_view(0)

/atom/proc/get_visible_gender()
	return gender

/mob/living/carbon/human/get_visible_gender()
	if(wear_suit && wear_suit.flags_inv & HIDEJUMPSUIT && ((head && head.flags_inv & HIDEMASK) || wear_mask))
		return NEUTER
	return ..()

/mob/living/carbon/human/proc/increase_germ_level(n)
	if(gloves)
		gloves.germ_level += n
	else
		germ_level += n

/mob/living/carbon/human/revive()

	if(should_have_organ(BP_HEART))
		vessel.add_reagent(/datum/reagent/blood,species.blood_volume-vessel.total_volume)
		fixblood()

	species.create_organs(src) // Reset our organs/limbs.
	restore_all_organs()       // Reapply robotics/amputated status from preferences.
	add_teeth()

	if(!client || !key) //Don't boot out anyone already in the mob.
		for (var/obj/item/organ/internal/brain/H in world)
			if(H.brainmob)
				if(H.brainmob.real_name == src.real_name)
					if(H.brainmob.mind)
						H.brainmob.mind.transfer_to(src)
						qdel(H)


	for (var/ID in virus2)
		var/datum/disease2/disease/V = virus2[ID]
		V.cure(src)

	losebreath = 0

	..()
/mob/living/carbon/human/proc/add_teeth()
	var/obj/item/organ/external/head/U = locate() in organs
	if(istype(U))
		U.teeth_list.Cut() //Clear out their mouth of teeth
		var/obj/item/stack/teeth/T = new species.teeth_type(U)
		U.max_teeth = T.max_amount //Set max teeth for the head based on teeth spawntype
		T.amount = T.max_amount
		U.teeth_list += T

/mob/living/carbon/human/proc/is_lung_ruptured()
	var/obj/item/organ/internal/lungs/L = internal_organs_by_name[BP_LUNGS]
	return L && L.is_bruised()

/mob/living/carbon/human/proc/rupture_lung()
	var/obj/item/organ/internal/lungs/L = internal_organs_by_name[BP_LUNGS]
	if(L)
		L.rupture()

/mob/living/carbon/human/add_blood(mob/living/carbon/human/M as mob)
	if (!..())
		return 0
	//if this blood isn't already in the list, add it
	if(istype(M))
		if(!blood_DNA[M.dna.unique_enzymes])
			blood_DNA[M.dna.unique_enzymes] = M.dna.b_type
	hand_blood_color = blood_color
	src.update_inv_gloves()	//handles bloody hands overlays and updating
	verbs += /mob/living/carbon/human/proc/bloody_doodle
	return 1 //we applied blood to the item

/mob/living/carbon/human/clean_blood(var/clean_feet)
	.=..()
	gunshot_residue = null
	if(clean_feet && !shoes)
		feet_blood_color = null
		feet_blood_DNA = null
		update_inv_shoes(1)
		return 1

/mob/living/carbon/human/get_visible_implants(var/class = 0)

	var/list/visible_implants = list()
	for(var/obj/item/organ/external/organ in src.organs)
		for(var/obj/item/O in organ.implants)
			if(!istype(O,/obj/item/implant) && (O.w_class > class) && !istype(O,/obj/item/material/shard/shrapnel))
				visible_implants += O

	return(visible_implants)

/mob/living/carbon/human/embedded_needs_process()
	for(var/obj/item/organ/external/organ in src.organs)
		for(var/obj/item/O in organ.implants)
			if(!istype(O, /obj/item/implant)) //implant type items do not cause embedding effects, see handle_embedded_objects()
				return 1
	return 0

/mob/living/carbon/human/proc/handle_embedded_and_stomach_objects()
	for(var/obj/item/organ/external/organ in src.organs)
		if(organ.splinted)
			continue
		for(var/obj/item/O in organ.implants)
			if(!istype(O,/obj/item/implant) && O.w_class > 1 && prob(5)) //Moving with things stuck in you could be bad.
				jossle_internal_object(organ, O)
	var/obj/item/organ/external/groin = src.get_organ(BP_GROIN)
	if(groin && stomach_contents && stomach_contents.len)
		for(var/obj/item/O in stomach_contents)
			if(O.edge || O.sharp)
				if(prob(1))
					stomach_contents.Remove(O)
					if(can_feel_pain())
						to_chat(src, "<span class='danger'>You feel something rip out of your stomach!</span>")
						groin.embed(O)
				else if(prob(5))
					jossle_internal_object(groin,O)

/mob/living/carbon/human/proc/jossle_internal_object(var/obj/item/organ/organ, var/obj/item/O)
	// All kinds of embedded objects cause bleeding.
	if(!can_feel_pain())
		to_chat(src, "<span class='warning'>You feel [O] moving inside your [organ.name].</span>")
	else
		var/msg = pick( \
			"<span class='warning'>A spike of pain jolts your [organ.name] as you bump [O] inside.</span>", \
			"<span class='warning'>Your movement jostles [O] in your [organ.name] painfully.</span>", \
			"<span class='warning'>Your movement jostles [O] in your [organ.name] painfully.</span>")
		custom_pain(msg,40,affecting = organ)

	organ.take_damage(rand(1,3), 0, 0)
	if(!(organ.robotic >= ORGAN_ROBOT) && (should_have_organ(BP_HEART))) //There is no blood in protheses.
		organ.status |= ORGAN_BLEEDING
		src.adjustToxLoss(rand(1,3))

/mob/living/carbon/human/verb/check_pulse()
	set category = "Object"
	set name = "Check pulse"
	set desc = "Approximately count somebody's pulse. Requires you to stand still at least 6 seconds."
	set src in view(1)
	var/self = 0

	if(usr.stat || usr.restrained() || !isliving(usr)) return

	if(usr == src)
		self = 1
	if(!self)
		usr.visible_message("<span class='notice'>[usr] kneels down, puts \his hand on [src]'s wrist and begins counting their pulse.</span>",\
		"You begin counting [src]'s pulse")
	else
		usr.visible_message("<span class='notice'>[usr] begins counting their pulse.</span>",\
		"You begin counting your pulse.")

	if(pulse())
		to_chat(usr, "<span class='notice'>[self ? "You have a" : "[src] has a"] pulse! Counting...</span>")
	else
		to_chat(usr, "<span class='danger'>[src] has no pulse!</span>")//it is REALLY UNLIKELY that a dead person would check his own pulse
		return

	to_chat(usr, "You must[self ? "" : " both"] remain still until counting is finished.")
	if(do_mob(usr, src, 60))
		var/message = "<span class='notice'>[self ? "Your" : "[src]'s"] pulse is [src.get_pulse(GETPULSE_HAND)].</span>"
		to_chat(usr, message)
	else
		to_chat(usr, "<span class='warning'>You failed to check the pulse. Try again.</span>")

/mob/living/carbon/human/verb/lookup()
	set name = "Look Up"
	set desc = "If you want to know what's above."
	set category = "IC"

	if(!is_physically_disabled())
		var/turf/above = GetAbove(src)
		if(shadow)
			if(client.eye == shadow)
				reset_view(0)
				return
			if(istype(above, /turf/simulated/open))
				to_chat(src, "<span class='notice'>You look up.</span>")
				if(client)
					reset_view(shadow)
				return
		if(istype(above, /turf/space))
			to_chat(src, "<span class='notice'>You can see empty space - wow.</span>")
		else
			to_chat(src, "<span class='notice'>There is nothing to see up there.</span>")
	else
		to_chat(src, "<span class='notice'>You can't look up right now.</span>")
	return

/mob/living/carbon/human/proc/set_species(var/new_species, var/default_colour)
	if(!dna)
		if(!new_species)
			new_species = SPECIES_HUMAN
	else
		if(!new_species)
			new_species = dna.species
		else
			dna.species = new_species

	// No more invisible screaming wheelchairs because of set_species() typos.
	if(!all_species[new_species])
		new_species = SPECIES_HUMAN

	if(species)

		if(species.name && species.name == new_species)
			return
		if(species.language)
			remove_language(species.language)
		if(species.default_language)
			remove_language(species.default_language)
		for(var/datum/language/L in species.assisted_langs)
			remove_language(L)
		// Clear out their species abilities.
		species.remove_inherent_verbs(src)
		holder_type = null

	species = all_species[new_species]
	species.handle_pre_spawn(src)

	if(species.language)
		add_language(species.language)
		species_language = all_languages[species.language]

	for(var/L in species.additional_langs)
		add_language(L)

	if(species.default_language)
		add_language(species.default_language)

	if(species.grab_type)
		current_grab_type = all_grabobjects[species.grab_type]

	if(species.base_color && default_colour)
		//Apply colour.
		r_skin = hex2num(copytext(species.base_color,2,4))
		g_skin = hex2num(copytext(species.base_color,4,6))
		b_skin = hex2num(copytext(species.base_color,6,8))
	else
		r_skin = 0
		g_skin = 0
		b_skin = 0

	if(species.holder_type)
		holder_type = species.holder_type


	if(!(gender in species.genders))
		gender = species.genders[1]

	icon_state = lowertext(species.name)

	species.create_organs(src)
	species.handle_post_spawn(src)

	maxHealth = species.total_health

	default_pixel_x = initial(pixel_x) + species.pixel_offset_x
	default_pixel_y = initial(pixel_y) + species.pixel_offset_y
	pixel_x = default_pixel_x
	pixel_y = default_pixel_y

	spawn(0)
		regenerate_icons()
		if(vessel.total_volume < species.blood_volume)
			vessel.maximum_volume = species.blood_volume
			vessel.add_reagent(/datum/reagent/blood, species.blood_volume - vessel.total_volume)
		else if(vessel.total_volume > species.blood_volume)
			vessel.remove_reagent(/datum/reagent/blood, vessel.total_volume - species.blood_volume)
			vessel.maximum_volume = species.blood_volume
		fixblood()


	// Rebuild the HUD. If they aren't logged in then login() should reinstantiate it for them.
	if(client && client.screen)
		client.screen.len = null
		InitializeHud()

	if(config && config.use_cortical_stacks && client && client.prefs.has_cortical_stack)
		create_stack()
	full_prosthetic = null

	//recheck species-restricted clothing
	for(var/slot in slot_first to slot_last)
		var/obj/item/clothing/C = get_equipped_item(slot)
		if(istype(C) && !C.mob_can_equip(src, slot, 1))
			unEquip(C)

	add_teeth()

	return 1

/mob/living/carbon/human/proc/bloody_doodle()
	set category = "IC"
	set name = "Write in blood"
	set desc = "Use blood on your hands to write a short message on the floor or a wall, murder mystery style."

	if (src.stat)
		return

	if (usr != src)
		return 0 //something is terribly wrong

	if (!bloody_hands)
		verbs -= /mob/living/carbon/human/proc/bloody_doodle

	if (src.gloves)
		to_chat(src, "<span class='warning'>Your [src.gloves] are getting in the way.</span>")
		return

	var/turf/simulated/T = src.loc
	if (!istype(T)) //to prevent doodling out of mechs and lockers
		to_chat(src, "<span class='warning'>You cannot reach the floor.</span>")
		return

	var/direction = input(src,"Which way?","Tile selection") as anything in list("Here","North","South","East","West")
	if (direction != "Here")
		T = get_step(T,text2dir(direction))
	if (!istype(T))
		to_chat(src, "<span class='warning'>You cannot doodle there.</span>")
		return

	var/num_doodles = 0
	for (var/obj/effect/decal/cleanable/blood/writing/W in T)
		num_doodles++
	if (num_doodles > 4)
		to_chat(src, "<span class='warning'>There is no space to write on!</span>")
		return

	var/max_length = bloody_hands * 30 //tweeter style

	var/message = sanitize(input("Write a message. It cannot be longer than [max_length] characters.","Blood writing", ""))

	if (message)
		var/used_blood_amount = round(length(message) / 30, 1)
		bloody_hands = max(0, bloody_hands - used_blood_amount) //use up some blood

		if (length(message) > max_length)
			message += "-"
			to_chat(src, "<span class='warning'>You ran out of blood to write with!</span>")
		var/obj/effect/decal/cleanable/blood/writing/W = new(T)
		W.basecolor = (hand_blood_color) ? hand_blood_color : COLOR_BLOOD_HUMAN
		W.update_icon()
		W.message = message
		W.add_fingerprint(src)

#define CAN_INJECT 1
#define INJECTION_PORT 2
/mob/living/carbon/human/can_inject(var/mob/user, var/target_zone)
	var/obj/item/organ/external/affecting = get_organ(target_zone)

	if(!affecting)
		to_chat(user, "<span class='warning'>They are missing that limb.</span>")
		return 0

	if(affecting.robotic >= ORGAN_ROBOT)
		to_chat(user, "<span class='warning'>That limb is robotic.</span>")
		return 0

	. = CAN_INJECT
	for(var/obj/item/clothing/C in list(head, wear_mask, wear_suit, w_uniform, gloves, shoes))
		if(C && (C.body_parts_covered & affecting.body_part) && (C.item_flags & ITEM_FLAG_THICKMATERIAL))
			if(istype(C, /obj/item/clothing/suit/space))
				. = INJECTION_PORT //it was going to block us, but it's a space suit so it doesn't because it has some kind of port
			else
				to_chat(user, "<span class='warning'>There is no exposed flesh or thin material on [src]'s [affecting.name] to inject into.</span>")
				return 0


/mob/living/carbon/human/print_flavor_text(var/shrink = 1)
	var/list/equipment = list(src.head,src.wear_mask,src.glasses,src.w_uniform,src.wear_suit,src.gloves,src.shoes)
	var/head_exposed = 1
	var/face_exposed = 1
	var/eyes_exposed = 1
	var/torso_exposed = 1
	var/arms_exposed = 1
	var/legs_exposed = 1
	var/hands_exposed = 1
	var/feet_exposed = 1

	for(var/obj/item/clothing/C in equipment)
		if(C.body_parts_covered & HEAD)
			head_exposed = 0
		if(C.body_parts_covered & FACE)
			face_exposed = 0
		if(C.body_parts_covered & EYES)
			eyes_exposed = 0
		if(C.body_parts_covered & UPPER_TORSO)
			torso_exposed = 0
		if(C.body_parts_covered & ARMS)
			arms_exposed = 0
		if(C.body_parts_covered & HANDS)
			hands_exposed = 0
		if(C.body_parts_covered & LEGS)
			legs_exposed = 0
		if(C.body_parts_covered & FEET)
			feet_exposed = 0

	flavor_text = ""
	for (var/T in flavor_texts)
		if(flavor_texts[T] && flavor_texts[T] != "")
			if((T == "general") || (T == "head" && head_exposed) || (T == "face" && face_exposed) || (T == "eyes" && eyes_exposed) || (T == "torso" && torso_exposed) || (T == "arms" && arms_exposed) || (T == "hands" && hands_exposed) || (T == "legs" && legs_exposed) || (T == "feet" && feet_exposed))
				flavor_text += flavor_texts[T]
				flavor_text += "\n\n"
	if(!shrink)
		return flavor_text
	else
		return ..()

/mob/living/carbon/human/getDNA()
	if(species.species_flags & SPECIES_FLAG_NO_SCAN)
		return null
	if(isSynthetic())
		return
	..()

/mob/living/carbon/human/setDNA()
	if(species.species_flags & SPECIES_FLAG_NO_SCAN)
		return
	if(isSynthetic())
		return
	..()

/mob/living/carbon/human/has_brain()
	if(internal_organs_by_name[BP_BRAIN])
		var/obj/item/organ/internal/brain = internal_organs_by_name[BP_BRAIN]
		if(brain && istype(brain))
			return 1
	return 0

/mob/living/carbon/human/has_eyes()
	if(internal_organs_by_name[BP_EYES])
		var/obj/item/organ/internal/eyes = internal_organs_by_name[BP_EYES]
		if(eyes && eyes.is_usable())
			return 1
	return 0

/mob/living/carbon/human/slip(var/slipped_on, stun_duration=8)
	if((species.species_flags & SPECIES_FLAG_NO_SLIP) || (shoes && (shoes.item_flags & ITEM_FLAG_NOSLIP)))
		return 0
	return !!(..(slipped_on,stun_duration))

/mob/living/carbon/human/check_slipmove()
	if(h_style)
		var/datum/sprite_accessory/hair/S = GLOB.hair_styles_list[h_style]
		if(S && S.flags & HAIR_TRIPPABLE && prob(0.4))
			slip(S, 4)
			return TRUE
	return FALSE

/mob/living/carbon/human/proc/undislocate()
	set category = "Object"
	set name = "Undislocate Joint"
	set desc = "Pop a joint back into place. Extremely painful."
	set src in view(1)

	if(!isliving(usr) || !usr.canClick())
		return

	usr.setClickCooldown(20)

	if(usr.stat > 0)
		to_chat(usr, "You are unconcious and cannot do that!")
		return

	if(usr.restrained())
		to_chat(usr, "You are restrained and cannot do that!")
		return

	var/mob/S = src
	var/mob/U = usr
	var/self = null
	if(S == U)
		self = 1 // Removing object from yourself.

	var/list/limbs = list()
	for(var/limb in organs_by_name)
		var/obj/item/organ/external/current_limb = organs_by_name[limb]
		if(current_limb && current_limb.dislocated > 0 && !current_limb.is_parent_dislocated()) //if the parent is also dislocated you will have to relocate that first
			limbs |= current_limb
	var/obj/item/organ/external/current_limb = input(usr,"Which joint do you wish to relocate?") as null|anything in limbs

	if(!current_limb)
		return

	if(self)
		to_chat(src, "<span class='warning'>You brace yourself to relocate your [current_limb.joint]...</span>")
	else
		to_chat(U, "<span class='warning'>You begin to relocate [S]'s [current_limb.joint]...</span>")
	if(!do_after(U, 30, src))
		return
	if(!current_limb || !S || !U)
		return

	if(self)
		to_chat(src, "<span class='danger'>You pop your [current_limb.joint] back in!</span>")
	else
		to_chat(U, "<span class='danger'>You pop [S]'s [current_limb.joint] back in!</span>")
		to_chat(S, "<span class='danger'>[U] pops your [current_limb.joint] back in!</span>")
	current_limb.undislocate()

/mob/living/carbon/human/drop_from_inventory(var/obj/item/W, var/atom/Target = null)
	if(W in organs)
		return
	. = ..()

/mob/living/carbon/human/reset_view(atom/A, update_hud = 1)
	..()
	if(update_hud)
		handle_regular_hud_updates()


/mob/living/carbon/human/can_stand_overridden()
	//FIXME, this was used for rigs acting as exoskeletal support.
	//We could use it for something else maybe...
	return 0

/mob/living/carbon/human/verb/pull_punches()
	set name = "Pull Punches"
	set desc = "Try not to hurt them."
	set category = "IC"

	if(incapacitated() || species.species_flags & SPECIES_FLAG_CAN_NAB) return
	pulling_punches = !pulling_punches
	to_chat(src, "<span class='notice'>You are now [pulling_punches ? "pulling your punches" : "not pulling your punches"].</span>")
	return

//generates realistic-ish pulse output based on preset levels
/mob/living/carbon/human/proc/get_pulse(var/method)	//method 0 is for hands, 1 is for machines, more accurate
	var/obj/item/organ/internal/heart/H = internal_organs_by_name[BP_HEART]
	if(!H)
		return
	if(H.open && !method)
		return "muddled and unclear; you can't seem to find a vein"

	var/temp = 0
	switch(pulse())
		if(PULSE_NONE)
			return "0"
		if(PULSE_SLOW)
			temp = rand(40, 60)
		if(PULSE_NORM)
			temp = rand(60, 90)
		if(PULSE_FAST)
			temp = rand(90, 120)
		if(PULSE_2FAST)
			temp = rand(120, 160)
		if(PULSE_THREADY)
			return method ? ">250" : "extremely weak and fast, patient's artery feels like a thread"
	return "[method ? temp : temp + rand(-10, 10)]"
//			output for machines^	^^^^^^^output for people^^^^^^^^^

/mob/living/carbon/human/proc/pulse()
	var/obj/item/organ/internal/heart/H = internal_organs_by_name[BP_HEART]
	if(!H)
		return PULSE_NONE
	if(stat == DEAD)
		return PULSE_NONE
	else
		return H.pulse

/mob/living/carbon/human/can_devour(atom/movable/victim)
	if(!src.species.gluttonous)
		return FALSE
	var/total = 0
	for(var/a in stomach_contents + victim)
		if(ismob(a))
			var/mob/M = a
			total += M.mob_size
		else if(isobj(a))
			var/obj/item/I = a
			total += I.get_storage_cost()
	if(total > src.species.stomach_capacity)
		return FALSE

	if(iscarbon(victim) || isanimal(victim))
		var/mob/living/L = victim
		if((src.species.gluttonous & GLUT_TINY) && (L.mob_size <= MOB_TINY) && !ishuman(victim)) // Anything MOB_TINY or smaller
			return DEVOUR_SLOW
		else if((src.species.gluttonous & GLUT_SMALLER) && (src.mob_size > L.mob_size)) // Anything we're larger than
			return DEVOUR_SLOW
		else if(src.species.gluttonous & GLUT_ANYTHING) // Eat anything ever
			return DEVOUR_FAST
	else if(istype(victim, /obj/item) && !istype(victim, /obj/item/holder)) //Don't eat holders. They are special.
		var/obj/item/I = victim
		var/cost = I.get_storage_cost()
		if(cost != ITEM_SIZE_NO_CONTAINER)
			if((src.species.gluttonous & GLUT_ITEM_TINY) && cost < 4)
				return DEVOUR_SLOW
			else if((src.species.gluttonous & GLUT_ITEM_NORMAL) && cost <= 4)
				return DEVOUR_SLOW
			else if(src.species.gluttonous & GLUT_ITEM_ANYTHING)
				return DEVOUR_FAST
	return ..()

/mob/living/carbon/human/should_have_organ(var/organ_check)

	var/obj/item/organ/external/affecting
	if(organ_check in list(BP_HEART, BP_LUNGS))
		affecting = organs_by_name[BP_CHEST]
	else if(organ_check in list(BP_LIVER, BP_KIDNEYS))
		affecting = organs_by_name[BP_GROIN]

	if(affecting && (affecting.robotic >= ORGAN_ROBOT))
		return 0
	return (species && species.has_organ[organ_check])

/mob/living/carbon/human/can_feel_pain(var/obj/item/organ/check_organ)
	if(isSynthetic())
		return FALSE
	if(check_organ)
		if(!istype(check_organ))
			return FALSE
		return check_organ.can_feel_pain()
	return !(species.species_flags & SPECIES_FLAG_NO_PAIN)

/mob/living/carbon/human/get_breath_volume()
	. = ..()
	var/obj/item/organ/internal/heart/H = internal_organs_by_name[BP_HEART]
	if(H)
		. *= (H.robotic < ORGAN_ROBOT) ? pulse()/PULSE_NORM : 1.5

/mob/living/carbon/human/need_breathe()
	if(species.breathing_organ && should_have_organ(species.breathing_organ))
		return 1
	else
		return 0

/mob/living/carbon/human/get_adjusted_metabolism(metabolism)
	return ..() * (species ? species.metabolism_mod : 1)

/mob/living/carbon/human/is_invisible_to(var/mob/viewer)
	return (is_cloaked() || ..())

/mob/living/carbon/human/help_shake_act(mob/living/carbon/M)
	if(src != M)
		..()
	else
		exam_self()

		if((SKELETON in mutations) && (!w_uniform) && (!wear_suit))
			play_xylophone()

/mob/living/carbon/human/proc/exam_self()
	if(!stat)
		visible_message("<span class='info'>[src] examines [gender==MALE ? "himself" : "herself"].</span>")
	var/msg = "<div class='examinebox'><span class='notice'><b>Let's see how I am doing.</b></span>\n"

	if(!stat)
		msg += "<span class='info'>I am alive and conscious.</span>\n"
	if(stat == DEAD)
		msg += "<span class='danger'>I am dead.</span>\n"
	else if(sleeping || stat == UNCONSCIOUS)
		if(!is_asystole())
			msg += "<span class='danger'>I am unconscious, but still breathing.</span>\n"
		else
			msg += "<span class='danger'>I am dying.</span>\n"
	msg += "<span class='info'>I feel like I can carry [baseload]kg with ease</span>\n"
	if(overweight())
		msg += "<span class='danger'>[overweighttxt()]</span>\n"

	for(var/obj/item/organ/external/org in organs)
		var/list/status = list()
		var/hurts = org.get_pain()
		if(!org.can_feel_pain())
			hurts = 0
		if(!can_feel_pain())
			hurts = 0
		if((chem_effects[CE_PAINKILLER] < hurts))
			switch(hurts)
				if(1 to 49)
					status += "<span class='danger'><small>pain</small></span>"
				if(50 to 89)
					status += "<span class='danger'>PAIN</span>"
				if(90 to INFINITY)
					status += "<span class='danger'><big>PAIN</big></span>"
		if(org.robotic >= ORGAN_ROBOT)
			switch(org.damage)
				if(1 to 25)
					status += "<span class='danger'><small>slightly damaged</small></span>"
				if(26 to 49)
					status += "<span class='danger'>damaged</span>"
				if(50 to 99)
					status += "<span class='danger'>VERY DAMAGED</span>"
				if(100 to INFINITY)
					status += "<span class='danger'><big>BARELY WORKING</big></span>"



		for(var/datum/wound/wound in org.wounds)
			if(wound.embedded_objects.len)
				status += "<span class='danger'>SHRAPNEL</span>"
			if(wound.bandaged)
				status += "<span class='binfo'>BANDAGED</span>"

		if(org.is_stump())
			status += "<span class='danger'>MISSING</span>"
		if(org.status & ORGAN_MUTATED)
			status += "<span class='danger'>MISSHAPEN</span>"
		if(org.status & ORGAN_BLEEDING)
			status += "<span class='danger'>BLEEDING</span>"
		if(org.dislocated == 2)
			status += "<span class='danger'>DISLOCATED</span>"
		if(org.status & ORGAN_BROKEN)
			status += "<span class='danger'>BROKEN</span>"
		if(org.splinted)
			status += "<span class='binfo'>SPLINTED</span>"
		if(org.status & ORGAN_DEAD)
			status += "<span class='danger'>NECROTIC</span>"
		if(org.is_dislocated()) //!org.is_usable() ||
			status += "<span class='danger'>UNUSABLE</span>"
		if(status.len)
			msg += "<b>[capitalize(org.name)]:</b> [or_sign_list(status)]\n"
		else
			msg += "<b>[capitalize(org.name)]:</b> <span class='info'>OK</span>\n"

	to_chat(src, "[msg]</div>")


/mob/living/carbon/human/proc/resuscitate()
	if(!is_asystole() || !should_have_organ(BP_HEART))
		return
	var/obj/item/organ/internal/heart/heart = internal_organs_by_name[BP_HEART]
	if(istype(heart) && heart.robotic <= ORGAN_ROBOT && !(heart.status & ORGAN_DEAD))
		var/species_organ = species.breathing_organ
		var/active_breaths = 0
		if(species_organ)
			var/obj/item/organ/internal/lungs/L = internal_organs_by_name[species_organ]
			if(L)
				active_breaths = L.active_breathing
		if(!nervous_system_failure() && active_breaths)
			visible_message("\The [src] jerks and gasps for breath!")
		else
			visible_message("\The [src] twitches a bit as \his heart restarts!")
		shock_stage = min(shock_stage, 100) // 120 is the point at which the heart stops.
		if(getOxyLoss() >= 75)
			setOxyLoss(75)
		heart.pulse = PULSE_NORM
		heart.handle_pulse()
	unlock_achievement(new/datum/achievement/revived())

/mob/living/carbon/human/proc/make_adrenaline(amount)
	if(stat == CONSCIOUS)
		var/limit = max(0, reagents.get_overdose(/datum/reagent/adrenaline) - reagents.get_reagent_amount(/datum/reagent/adrenaline))
		reagents.add_reagent(/datum/reagent/adrenaline, min(amount, limit))

//Get fluffy numbers
/mob/living/carbon/human/proc/get_blood_pressure()
	if(status_flags & FAKEDEATH)
		return "[Floor(120+rand(-5,5))*0.25]/[Floor(80+rand(-5,5)*0.25)]"
	var/blood_result = get_blood_circulation()
	return "[Floor((120+rand(-5,5))*(blood_result/100))]/[Floor((80+rand(-5,5))*(blood_result/100))]"

//Point at which you dun breathe no more. Separate from asystole crit, which is heart-related.
/mob/living/carbon/human/proc/nervous_system_failure()
	return getBrainLoss() >= maxHealth * 0.75


/mob/living/carbon/proc/get_social_class()
	var/socclass = social_class
	if(!socclass)
		return
	switch(socclass)
		if(SOCIAL_CLASS_MIN)
			return "<b>filth</b>"
		if(SOCIAL_CLASS_MED)
			return "<b>a commoner</b>"
		if(SOCIAL_CLASS_HIGH)
			return "<b>a noble</b>"
		if(SOCIAL_CLASS_MAX)
			return "<b>a greater noble</b>"


/mob/living/carbon/human/proc/get_social_description(var/mob/living/carbon/human/H)
	if(!ishuman(H))
		return
	if(!social_class || !H.social_class)
		return
	if(social_class < H.social_class)
		return "They are of a <b>lesser</b> social class than me."
	else if(social_class > H.social_class)
		return "They are of a <b>higher</b> social class than me."
	else
		return "They are of the same social class as me."


//RightClick procs!
/mob/living/carbon/human/RightClick(mob/living/user)
	var/intent = user.a_intent
	if(src == user)
		return

	if(!user.Adjacent(src))
		var/obj/item/I = user.get_inactive_hand()
		if(I)
			if(user.atk_intent == I_DUAL && user.combat_mode)
				if(istype(I, /obj/item/gun))
					I.afterattack(src, user)
					return
		/*//This doesn't want to work.
		//Aiming a gun at someone.
		var/obj/item/gun/G = user.get_active_hand()
		if(G && istype(G))
			if(ismob(src) && user.aiming)
				if(src == user.aiming.aiming_at)//If we're already aiming at them, then stop aiming.
					user.aiming.cancel_aiming()
				else
					user.aiming.aim_at(src, G)//Else aim at them with the gun.
				*/

		//else//Ok we have no gun do other dumb shit instead.
		switch(intent)
			if(I_HURT)
				user.visible_message("<span class='danger'><b>[user] threatens [src] with a fist!</b></span>")
				return
			if(I_HELP)
				user.visible_message("<font color='green'><b>[user] waves friendly to [src].</b></font>")
				return

	else if(lying && intent == I_HELP)
		check_pulse()
		return

	else if(!lying && !user.combat_mode && intent == I_HELP )
		give(src)
		return

	else
		..()

/atom/RightClick(mob/living/user)
	var/obj/item/I = user.get_inactive_hand()
	if(I)
		if(user.atk_intent == I_DUAL && user.combat_mode)
			if(istype(I, /obj/item/gun))
				I.afterattack(src, user)


/mob
	var/zoomed = FALSE

/mob/proc/do_zoom()
	var/do_normal_zoom = TRUE
	if(!zoomed)
		if(lying)
			return
		var/obj/item/gun/projectile/heavysniper/S = get_active_hand()
		if(istype(S))
			do_normal_zoom = FALSE
			S.toggle_scope(src, 2)
			set_face_dir(dir)//Face what we're zoomed in on.

		if(do_normal_zoom)
			var/_x = 0
			var/_y = 0
			switch(dir)
				if (NORTH)
					_y = 7
				if (EAST)
					_x = 7
				if (SOUTH)
					_y = -7
				if (WEST)
					_x = -7
			if(ishuman(src))
				var/mob/living/carbon/human/H = src
				H.hide_cone()
			if(get_preference_value(/datum/client_preference/smooth_zoom) ==  GLOB.PREF_YES)
				animate(client, pixel_x = world.icon_size*_x, pixel_y = world.icon_size*_y, time = 2, easing = SINE_EASING)
			else
				client.pixel_x = world.icon_size*_x
				client.pixel_y = world.icon_size*_y

			set_face_dir(dir)//Face what we're zoomed in on.

		zoomed = TRUE


	else
		var/obj/item/gun/projectile/heavysniper/S = get_active_hand()
		if(istype(S))
			if(S.zoom)//Only do this if we're zoomed in please.
				do_normal_zoom = FALSE
				S.toggle_scope(src, 2)
				set_face_dir(FALSE)//Reset us back to normal.
		S = get_inactive_hand()//Then check if it's in our inactive hand instead. That way you can swap hands and still unzoom normally.
		if(istype(S))
			if(S.zoom)
				do_normal_zoom = FALSE
				S.toggle_scope(src, 2)
				set_face_dir(FALSE)//Reset us back to normal.

		if(do_normal_zoom)
			if(ishuman(src))
				var/mob/living/carbon/human/H = src
				if(get_preference_value(/datum/client_preference/smooth_zoom) ==  GLOB.PREF_YES)
					animate(client, pixel_x = 0, pixel_y = 0, time = 2, easing = SINE_EASING)
					spawn(1)
						H.show_cone()
				else
					client.pixel_x = 0
					client.pixel_y = 0
					H.show_cone()


			set_face_dir(FALSE)//Reset us back to normal.
		zoomed = FALSE

/atom/AltRightClick(var/mob/living/carbon/human/user)
	..()
	if(!istype(user))
		return
	if(user.lying)
		return
	if(user.crouching)//If you're crouching, pop up.
		user.toggle_crouch()

	if(istype(user.loc, /turf/simulated/floor/trench))//We're in a trench.
		if(user.zoomed)
			user.do_zoom()
			return
		var/trench_check = 0 //We don't wanna be zooming unless we're up against a wall.
		for(var/direction in GLOB.cardinal)
			var/turf/turf_to_check = get_step(user.loc,direction)//So get all of the turfs around us.
			if(istype(turf_to_check, /turf/simulated/floor/trench))//And if they're a trench, count it.
				trench_check++
		if(trench_check >= 4)//But, if we're surrounded on all sides by trench, we cannot zoom in.
			to_chat(user, "<span class='warning'>I'm too far away from the side to peer over.</span>")
			return //ez pz

	visible_message("<span class='notice'>[user] peers into the distance.</span>")
	user.face_atom(src)
	user.do_zoom()

/mob/living/carbon/human/melee_accuracy_mods()
	. = ..()
	for(var/obj/item/organ/external/org in organs)
		var/hurts = org.get_pain()
		if(!org.can_feel_pain())
			hurts = 0

		if(hurts > 50)
			. += 15
	if(!combat_mode)
		. += 25

/mob/living/carbon/human/proc/has_low_circulation()
	return (get_blood_circulation() <= 60)

// trench kiss
/mob/living/carbon/human/proc/tkiss_try(var/mob/living/carbon/human/H)
	var/turf/T = get_turf(H)

	// Some bullshit to make it look right
	if(tkiss_is_wrong_trench_adjacency(H) && istype(T, /turf/simulated/floor/trench))
		to_chat(H, "<span class='warning'>In the trench, we kiss sideways</span>")
		return 0
	if(tkiss_is_wrong_adjacency(H))
		to_chat(H, "<span class='warning'>Oh! Can't trench kiss people from behind! I feel silly now.</span>")
		H.add_event("tkiss_silly", /datum/happiness_event/tkiss_silly)
		return 0
	if(tkiss_is_north_adjacency(H))
		to_chat(H, "<span class='warning'>Trench kissing from the north is a bad luck. I won't do this.</span>")
		return 0

	// Alright, do it
	H.commiting_trench_kiss = 1

	// Because of the trench offsets and such, we're remembering our initial pixel offsets
	var/initial_pixel_x = H.pixel_x
	var/initial_pixel_y = H.pixel_y
	H.tkiss_lean_towards(src)

	T.visible_message("<span class='notice'>[H] leans towards [src]...</span>")

	// It's safe to do this here because conditions were checked earlier
	var/obj/item/clothing/mask/smokable/source = H.wear_mask
	var/obj/item/clothing/mask/smokable/target = src.wear_mask
	var/obj/item/clothing/mask/smokable/toLight = source.lit ? target : source

	if(do_mob(H, src, 20))
		toLight.light("<span class='notice'>[H] presses their \the [source] against \the [target] in [src]'s mouth.</span>")
		H.tkiss_handle_happiness(src, TRUE)
		src.tkiss_handle_happiness(H)
	else
		to_chat(H, "<span class='notice'>You stop leaning towards [src].</span>")

	H.commiting_trench_kiss = 0
	H.tkiss_return_to_initial_now(initial_pixel_x, initial_pixel_y)
	return 1

/mob/living/carbon/human/proc/tkiss_handle_happiness(var/mob/living/carbon/human/H, var/instigator = FALSE)
	var/turf/T = get_turf(src)
	if(istype(T,/turf/simulated/floor/trench))
		to_chat(src, "<span class='hypnophrase'>O-oh... awesome!</span>")
		src.add_event("tkiss_feeling", /datum/happiness_event/tkiss_felt_right)
	else if(instigator)
		to_chat(src, "<span class='phobia'>THAT WAS WRONG.</span>")
		src.add_event("tkiss_feeling", /datum/happiness_event/tkiss_felt_wrong)
	else
		to_chat(src, "<span class='notice'>I was trench kissed, but I felt nothing.</span>")

/mob/living/carbon/human/proc/tkiss_check_able(var/mob/living/carbon/human/H)
	var/smoke = /obj/item/clothing/mask/smokable
	var/mouth_selected = H.zone_sel.selecting == BP_MOUTH
	if(istype(H) && istype(H.wear_mask,smoke) && istype(src.wear_mask,smoke) && mouth_selected)
		var/obj/item/clothing/mask/smokable/source = H.wear_mask
		var/obj/item/clothing/mask/smokable/target = src.wear_mask
		if(source.lit && !target.lit || !source.lit && target.lit)
			return TRUE
	return FALSE

/mob/living/carbon/human/proc/tkiss_is_wrong_trench_adjacency(var/mob/living/carbon/human/H)
	return H.y == src.y + 1 || H.y == src.y - 1

/mob/living/carbon/human/proc/tkiss_is_north_adjacency(var/mob/living/carbon/human/H)
	return H.y == src.y + 1

/mob/living/carbon/human/proc/tkiss_is_wrong_adjacency(var/mob/living/carbon/human/H)
	var/fromBackSouth = H.y == src.y + 1 && src.dir == SOUTH
	var/fromBackNorth = H.y == src.y - 1 && src.dir == NORTH
	var/fromBackEast = H.x == src.x - 1 && src.dir == EAST
	var/fromBackWest = H.x == src.x + 1 && src.dir == WEST
	return fromBackSouth || fromBackNorth || fromBackEast || fromBackWest