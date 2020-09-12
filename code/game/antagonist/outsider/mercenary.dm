var/datum/antagonist/mercenary/mercs

/datum/antagonist/mercenary
	id = MODE_MERCENARY
	role_text = "Mercenary"
	antag_indicator = "hudsyndicate"
	role_text_plural = "Mercenaries"
	landmark_id = "Syndicate-Spawn"
	leader_welcome_text = "You are the leader of the mercenary strikeforce; hail to the chief. Use :t to speak to your underlings."
	welcome_text = "To speak on the strike team's private channel use :t."
	flags = ANTAG_VOTABLE | ANTAG_OVERRIDE_JOB | ANTAG_CLEAR_EQUIPMENT | ANTAG_CHOOSE_NAME | ANTAG_HAS_NUKE | ANTAG_SET_APPEARANCE | ANTAG_HAS_LEADER
	antaghud_indicator = "hudoperative"
	spawn_announcement_title = "Vital Priority Announcement At All Communications Consoles!"
	spawn_announcement_sound = 'sound/AI/november/threat.ogg'
	gag_announcement = FALSE //Loud and clear, we want these guys to be KNOWN


	hard_cap = 4
	hard_cap_round = 8
	initial_spawn_req = 4
	initial_spawn_target = 5
	min_player_age = 14

	faction = "mercenary"

/datum/antagonist/mercenary/New()
	..()
	mercs = src

/datum/antagonist/mercenary/create_global_objectives()
	if(!..())
		return 0
	global_objectives = list()
	global_objectives |= new /datum/objective/nuclear
	return 1

/datum/antagonist/mercenary/equip(var/mob/living/carbon/human/player)
	if(!..())
		return 0

	var/decl/hierarchy/outfit/mercenary = outfit_by_type(/decl/hierarchy/outfit/mercenary)
	mercenary.equip(player)

	player.add_stats(rand(14,18), rand(10,16), rand(12,18), rand(8,12))
	player.add_skills(rand(5, 9), rand(4,7), rand(2,5), rand(1,5), rand(1,5))

	//var/obj/item/device/radio/uplink/U = new(get_turf(player), player.mind, DEFAULT_TELECRYSTAL_AMOUNT)
	//player.put_in_hands(U)

	return 1
/datum/antagonist/mercenary/create_antagonist(var/datum/mind/target, var/move, var/gag_announcement = TRUE, var/preserve_appearance)
	..()
/*
/datum/antagonist/mercenary/check_victory()
	var/survivor
	for(var/datum/mind/player in current_antagonists)
		if(!player.current || player.current.stat)
			continue
		survivor = 1
		break
	if(!survivor)
		feedback_set_details("round_end_result","loss - mercenaries are dead")
		to_world("<span class='danger'><font size = 3>The [(current_antagonists.len>1)?"[role_text_plural] have":"[role_text] has"] been killed! The Magistrate's station is safe again!</font></span>")
*/

/datum/antagonist/mercenary/announce_antagonist_spawn()
	..()
	var/welcome_text = "<center><b><font size = 3> Declaration of War!</center></b></font><br>"
	welcome_text += "Dear Commandant of this stronghold. This is a formal declaration of war from Sir Magistrate [pick(GLOB.first_names_male)] [pick(GLOB.last_names)]. We are sending our team of mercenaries to:"
	for(var/datum/objective/objective in global_objectives)
		welcome_text += "<B>[objective.explanation_text]<B><br>"

	post_comm_message("Declaration of War!!", welcome_text)
	//command_announcement.Announce(welcome_text, "Declaration of War!", new_sound = 'sound/AI/november/threat.ogg', msg_sanitized = 1);





