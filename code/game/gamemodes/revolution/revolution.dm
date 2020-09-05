/datum/game_mode/revolution
	name = "Riot"
	config_tag = "revolution"
	round_description = "Some crewmembers are attempting to overthrow the nobles!"
	extended_round_description = "Revolutionaries - Remove the nobles from power. Convert other crewmembers to your cause using the 'Convert Bourgeoise' verb. Protect your leaders."
	required_players = 15
	required_enemies = 3
//	auto_recall_shuttle = TRUE
	end_on_antag_death = TRUE
	shuttle_delay = 2
	antag_tags = list(MODE_REVOLUTIONARY)
	require_all_templates = 1
