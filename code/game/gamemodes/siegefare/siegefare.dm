var/siegewall = FALSE

/datum/game_mode/siegefare
	name = "Siegefare"
	round_description = "The red horde has arrived."
	extended_round_description = "Anime is cool"
	config_tag = "siegefare"
	required_players = 0
	auto_recall_shuttle = TRUE //If the shuttle is even somehow called.

/datum/game_mode/siegefare/declare_completion()
	SSwarfare.declare_completion()

/datum/game_mode/siegefare/post_setup()
	..()
	start_siege_countdown()

/datum/game_mode/siegefare/check_finished()
	if(SSwarfare.check_completion())
		return TRUE
	..()

/datum/game_mode/siegefare/declare_completion()

/proc/issiegefare()
    return (istype(ticker.mode, /datum/game_mode/siegefare) || master_mode=="siegefare")

/datum/game_mode/siegefare/proc/start_siege_countdown()
	spawn(8 MINUTES)
		open_siegewall()		
		spawn(32 MINUTES)
			SSwarfare.end_warfare(RED_TEAM)

/datum/game_mode/siegefare/proc/open_siegewall()
	siegewall = TRUE
	to_world("<big>FIGHT OR DIE!</big>")
	sound_to(world, 'sound/effects/redcharge.ogg')
	spawn(3 MINUTES)
		close_siegewall()

/datum/game_mode/siegefare/proc/close_siegewall()
	siegewall = FALSE
	to_world("<big>The fighting starts to die down!</big>")
	spawn(5 MINUTES)
		open_siegewall()
