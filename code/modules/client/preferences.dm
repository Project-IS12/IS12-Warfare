#define SAVE_RESET -1

var/list/preferences_datums = list()

datum/preferences
	//doohickeys for savefiles
	var/path
	var/default_slot = 1				//Holder so it doesn't default to slot 1, rather the last one used
	var/savefile_version = 0

	//non-preference stuff
	var/warns = 0
	var/muted = 0
	var/last_ip
	var/last_id
	var/is_bordered = 0

	//game-preferences
	var/lastchangelog = ""				//Saved changlog filesize to detect if there was a change

	//character preferences
	var/species_preview                 //Used for the species selection window.

	//Mob preview
	var/icon/preview_icon = null
	var/client/client = null
	var/client_ckey = null

	var/savefile/loaded_preferences
	var/savefile/loaded_character
	var/datum/category_collection/player_setup_collection/player_setup
	var/datum/browser/panel

/datum/preferences/New(client/C)
	player_setup = new(src)
	gender = MALE
	real_name = random_name(gender,species)
	b_type = RANDOM_BLOOD_TYPE

	if(istype(C))
		client = C
		client_ckey = C.ckey
		if(!IsGuestKey(C.key))
			load_path(C.ckey)
			load_preferences()
			load_and_update_character()

/datum/preferences/proc/load_and_update_character(var/slot)
	load_character(slot)
	if(update_setup(loaded_preferences, loaded_character))
		save_preferences()
		save_character()

/datum/preferences/proc/ShowChoices(mob/user)
	var/dat = "<html><head><title>Interweb Explorer!</title>"
	dat += "<style type='text/css'>html {overflow: auto;};"
	dat += "body {"
	dat += "overflow:hidden;"
	dat += "font-family: Times;"
	dat += "background-repeat:repeat-x;"
	dat += "}"
	dat += "a {text-decoration:none;outline: none;border: none;margin:-1px;}"
	dat += "a:focus{outline:none;border: none;}"
	dat += "a:hover {Color:#0d0d0d;background:#505055;outline: none;border: none; text-decoration:none;}"
	dat += "a.active { text-decoration:none; Color:#533333;border: none;}"
	dat += "a.inactive:hover {Color:#0d0d0d;background:#bb0000;border: none;}"
	dat += "a.active:hover {Color:#bb0000;background:#0f0f0f;}"
	dat += "a.inactive:hover { text-decoration:none; Color:#0d0d0d; background:#bb0000;border: none;}"
	dat += "a img {     border: 0; }"
	dat += "TABLE.winto {"
	dat += "z-index:-1;"
	dat += "position: absolute;"
	dat += "top: 12;"
	dat += "left:14;"
	dat += "background-position: bottom;"
	dat += "background-repeat:repeat-x;"
	dat += "border: 4px dotted #222222;"
	dat += "border-bottom: none;"
	dat += "border-top: none;"
	dat += "}"
	dat += "TR {"
	dat += "border: 0px;"
	dat += "}"
	dat += "span.job_class {Color:#000000;}"
	dat += "</style>"
	dat += "</head>"
	dat += "<body bgcolor='#0d0d0d' text='#555555' alink='#777777' vlink='#777777' link='#777777'>"
	dat += "<p align ='right'>"
	dat += "<a onfocus ='this.blur()' href='byond://?src=\ref[src];toggletitle=1'>X</a></p>"
	if(path)
		dat += "<a onfocus ='this.blur()' href='?src=\ref[src];save=1'>Save Slot</a> -"
		dat += "<a onfocus ='this.blur()' href='?src=\ref[src];resetslot=1'>Reset Slot</a> -"
		dat += "<a onfocus ='this.blur()' href='?src=\ref[src];load=1'>Personalities in your head</a>"
	dat += "<br>"
	dat += player_setup.header()
	dat += "<br>"
	dat += player_setup.content(user)
	dat += "</html></body>"
	user <<browse(dat,"window=player_panel;size=600x600;can_close=0;can_resize=0;border=[is_bordered];titlebar=[is_bordered]")

/datum/preferences/proc/process_link(mob/user, list/href_list)

	if(!user)	return
	if(isliving(user)) return

	if(href_list["preference"] == "open_whitelist_forum")
		if(config.forumurl)
			user << link(config.forumurl)
		else
			to_chat(user, "<span class='danger'>The forum URL is not set in the server configuration.</span>")
			return
	ShowChoices(usr)
	return 1

/datum/preferences/Topic(href, list/href_list)
	if(..())
		return 1

	if(href_list["save"])
		save_preferences()
		save_character()
	else if(href_list["reload"])
		load_preferences()
		load_character()
		sanitize_preferences()
	else if(href_list["load"])
		if(!IsGuestKey(usr.key))
			open_load_dialog(usr)
			return 1
	else if(href_list["changeslot"])
		load_character(text2num(href_list["changeslot"]))
		sanitize_preferences()
		close_load_dialog(usr)
	else if(href_list["resetslot"])
		if(real_name != input("This will reset the current slot. Enter the character's full name to confirm."))
			return 0
		load_character(SAVE_RESET)
		sanitize_preferences()
	else if(href_list["toggletitle"])
		usr <<browse(null, "window=player_panel")
		is_bordered = !is_bordered
	else
		return 0

	ShowChoices(usr)
	return 1

/datum/preferences/proc/copy_to(mob/living/carbon/human/character, is_preview_copy = FALSE)
	// Sanitizing rather than saving as someone might still be editing when copy_to occurs.
	player_setup.sanitize_setup()
	character.set_species(species)
	if(be_random_name)
		real_name = random_name(gender,species)

	if(config.humans_need_surnames)
		var/firstspace = findtext(real_name, " ")
		var/name_length = length(real_name)
		if(!firstspace)	//we need a surname
			real_name += " [pick(GLOB.last_names)]"
		else if(firstspace == name_length)
			real_name += "[pick(GLOB.last_names)]"

	if(GLOB.in_character_filter.len) //If you name yourself hitler you're getting a random name.
		if(findtext(real_name, config.ic_filter_regex))
			real_name = random_name(gender,species)

	character.fully_replace_character_name(real_name)

	character.gender = gender
	character.age = age
	character.b_type = b_type

	character.r_eyes = r_eyes
	character.g_eyes = g_eyes
	character.b_eyes = b_eyes

	character.h_style = h_style
	character.r_hair = r_hair
	character.g_hair = g_hair
	character.b_hair = b_hair

	character.f_style = f_style
	character.r_facial = r_facial
	character.g_facial = g_facial
	character.b_facial = b_facial

	character.r_skin = r_skin
	character.g_skin = g_skin
	character.b_skin = b_skin

	character.s_tone = s_tone
	character.s_base = s_base

	character.h_style = h_style
	character.f_style = f_style

	// Replace any missing limbs.
	for(var/name in BP_ALL_LIMBS)
		var/obj/item/organ/external/O = character.organs_by_name[name]
		if(!O && organ_data[name] != "amputated")
			var/list/organ_data = character.species.has_limbs[name]
			if(!islist(organ_data)) continue
			var/limb_path = organ_data["path"]
			O = new limb_path(character)

	// Destroy/cyborgize organs and limbs. The order is important for preserving low-level choices for robolimb sprites being overridden.
	for(var/name in BP_BY_DEPTH)
		var/status = organ_data[name]
		var/obj/item/organ/external/O = character.organs_by_name[name]
		if(!O)
			continue
		O.status = 0
		O.robotic = 0
		O.model = null
		if(status == "amputated")
			character.organs_by_name[O.organ_tag] = null
			character.organs -= O
			if(O.children) // This might need to become recursive.
				for(var/obj/item/organ/external/child in O.children)
					character.organs_by_name[child.organ_tag] = null
					character.organs -= child
		else if(status == "cyborg")
			if(rlimb_data[name])
				O.robotize(rlimb_data[name])
			else
				O.robotize()
		else //normal organ
			O.force_icon = null
			O.SetName(initial(O.name))
			O.desc = initial(O.desc)
	//For species that don't care about your silly prefs
	character.species.handle_limbs_setup(character)
	if(!is_preview_copy)
		for(var/name in list(BP_HEART,BP_EYES,BP_BRAIN,BP_LUNGS,BP_LIVER,BP_KIDNEYS))
			var/status = organ_data[name]
			if(!status)
				continue
			var/obj/item/organ/I = character.internal_organs_by_name[name]
			if(I)
				if(status == "assisted")
					I.mechassist()
				else if(status == "mechanical")
					I.robotize()

	QDEL_NULL_LIST(character.worn_underwear)
	character.backpack_setup = new(backpack, backpack_metadata["[backpack]"])

	for(var/N in character.organs_by_name)
		var/obj/item/organ/external/O = character.organs_by_name[N]
		O.markings.Cut()

	for(var/M in body_markings)
		var/datum/sprite_accessory/marking/mark_datum = GLOB.body_marking_styles_list[M]
		var/mark_color = "[body_markings[M]]"

		for(var/BP in mark_datum.body_parts)
			var/obj/item/organ/external/O = character.organs_by_name[BP]
			if(O)
				O.markings[M] = list("color" = mark_color, "datum" = mark_datum)

	character.force_update_limbs()
	character.update_mutations(0)
	character.update_body(0)
	character.update_underwear(0)
	character.update_hair(0)
	character.update_icons()

	character.religion = religion

	character.char_branch = mil_branches.get_branch(char_branch)
	character.char_rank = mil_branches.get_rank(char_branch, char_rank)
	if(is_preview_copy)
		return

	if(!character.isSynthetic())
		character.nutrition = rand(140,360)

	return


/datum/preferences/proc/open_load_dialog(mob/user)
	var/dat  = list()
	dat += "<body>"
	dat += "<tt><center>"

	var/savefile/S = new /savefile(path)
	if(S)
		dat += "<b>Select a character slot to load</b><hr>"
		var/name
		for(var/i=1, i<= config.character_slots, i++)
			S.cd = GLOB.using_map.character_load_path(S, i)
			S["real_name"] >> name
			if(!name)	name = "Character[i]"
			if(i==default_slot)
				name = "<b>[name]</b>"
			dat += "<a href='?src=\ref[src];changeslot=[i]'>[name]</a><br>"

	dat += "<hr>"
	dat += "</center></tt>"
	panel = new(user, "Character Slots", "Character Slots", 300, 390, src)
	panel.set_content(jointext(dat,null))
	panel.open()

/datum/preferences/proc/close_load_dialog(mob/user)
	user << browse(null, "window=saves")
	panel.close()
