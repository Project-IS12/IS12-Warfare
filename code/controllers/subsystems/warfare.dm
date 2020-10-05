#define KOTH_VICTORY_POINTS 500

/datum/team
	var/list/team = list()  // members of the team
	var/list/team_clients = list()
	var/list/cooldown = list()  // captain verbs that are being cooled down and cant be used
	var/points = 0 //KOTH stuff, trench capping game mode doesn't use this.
	var/nuked = FALSE //When set to true this side instantly loses. PONR uses it.
	var/left = 60 //Number of reinforcements both sides have.
	var/datum/squad/squadA
	var/datum/squad/squadB
	var/datum/squad/squadC
	var/datum/squad/squadD

/datum/team/New()
	..()
	squadA = new /datum/squad/alpha
	squadB = new /datum/squad/bravo
	squadC = new /datum/squad/charlie
	squadD = new /datum/squad/delta


/datum/squad
	var/name = "Default Squad"
	var/mob/squad_leader
	var/list/members = list()

/datum/squad/alpha
	name = "Alpha"

/datum/squad/bravo
	name = "Bravo"

/datum/squad/charlie
	name = "Charlie"

/datum/squad/delta
	name = "Delta"

/datum/team/proc/startCooldown(var/thingToCoolDown, var/time = 1 MINUTE)
	cooldown |= thingToCoolDown
	spawn(time)
		cooldown -= thingToCoolDown

/datum/team/proc/checkCooldown(var/thingToCheck)
	return thingToCheck in cooldown

SUBSYSTEM_DEF(warfare)
	name = "Warfare"
	flags = SS_NO_FIRE
	wait = 1
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY
	var/datum/team/blue
	var/datum/team/red
	var/battle_wait = 2 MINUTES
	var/battle_time = 0
	var/complete = ""

/datum/controller/subsystem/warfare/Initialize()
	blue = new /datum/team
	red = new /datum/team
	SSwarfare = src
	..()

/datum/controller/subsystem/warfare/proc/end_warfare(var/loser)
	if(loser == RED_TEAM)
		red.nuked = TRUE
	if(loser == BLUE_TEAM)
		blue.nuked = TRUE

/datum/controller/subsystem/warfare/proc/begin_countDown()
	spawn(config.warfare_start_time MINUTES)	// :disgust:
		start_battle()

/datum/controller/subsystem/warfare/proc/start_battle()
	if(battle_time)  // so if it starts early, it doesnt @everyone again
		return
	battle_time = TRUE
	to_world("<big>I AM READY TO DIE NOW!</big>")
	sound_to(world, 'sound/effects/ready_to_die.ogg')//Sound notifying them.
	for(var/turf/simulated/floor/dirty/fake/F in world)//Make all the fake dirt into real dirt.
		F.ChangeTurf(/turf/simulated/floor/dirty)
	for(var/turf/simulated/floor/trench/fake/T in world)//Make all the fake trenches into real ones.
		T.ChangeTurf(/turf/simulated/floor/trench)

/datum/controller/subsystem/warfare/proc/check_completion()
	if(red.left <= 0)
		return TRUE
	else if(blue.left <= 0)
		return TRUE
	else if(red.points >= KOTH_VICTORY_POINTS)
		return TRUE
	else if(blue.points >= KOTH_VICTORY_POINTS)
		return TRUE
	else if(red.nuked)
		return TRUE
	else if(blue.nuked)
		return TRUE

/datum/controller/subsystem/warfare/proc/declare_completion()

	if(red.left <= 0)
		feedback_set_details("round_end_result","win-blue team no reinforcements")
		complete = "win-blue team no reinforcements"
		to_world("<FONT size = 3><B>[BLUE_TEAM] Minor Victory!</B></FONT>")
		to_world("<B>\The [BLUE_TEAM] managed to deplete all of \the [RED_TEAM]'s reinforcements! They retreat in shame!</B>")
		assign_victory(TRUE)

	else if(blue.left <= 0)
		feedback_set_details("round_end_result","win-red team no reinforcements")
		complete = "win-red team no reinforcements"
		to_world("<FONT size = 3><B>[RED_TEAM] Minor Victory!</B></FONT>")
		to_world("<B>\The [RED_TEAM] managed to deplete all of \the [BLUE_TEAM]'s reinforcements! They retreat in shame!</B>")
		assign_victory(FALSE, TRUE)

	//Point of no return
	else if(red.nuked)
		feedback_set_details("round_end_result","win-blue team point of no return")
		complete = "win-blue team point of no return"
		to_world("<FONT size = 3><B>[BLUE_TEAM] Major Victory!</B></FONT>")
		to_world("<B>\The [BLUE_TEAM] managed to successfully activate \the [RED_TEAM]'s Point Of No Return! Their trenches are overrun! They retreat in shame!</B>")
		assign_victory(TRUE)

	else if(blue.nuked)
		feedback_set_details("round_end_result","win-red team point of no return")
		complete = "win-red team point of no return"
		to_world("<FONT size = 3><B>[RED_TEAM] Major Victory!</B></FONT>")
		to_world("<B>\The [RED_TEAM] managed to successfully activate \the [BLUE_TEAM]'s Point Of No Return! Their trenches are overrun! They retreat in shame!</B>")
		assign_victory(FALSE, TRUE)

	//KOTH shit
	else if(red.points >= KOTH_VICTORY_POINTS)
		feedback_set_details("round_end_result","win-red team koth")
		complete = "win-red team koth"
		to_world("<FONT size = 3><B>[RED_TEAM] Major Victory!</B></FONT>")
		to_world("<B>\The [RED_TEAM] managed to capture the command point!</B>")
		assign_victory(FALSE, TRUE)

	else if(blue.points >= KOTH_VICTORY_POINTS)
		feedback_set_details("round_end_result","win-blue team koth")
		complete = "win-blue team koth"
		to_world("<FONT size = 3><B>[BLUE_TEAM] Major Victory!</B></FONT>")
		to_world("<B>\The [BLUE_TEAM] managed to capture the command point!</B>")
		assign_victory(TRUE)

	sound_to(world,'sound/ambience/round_over.ogg')

	for(var/mob/M in GLOB.player_list)
		if(!M.client)
			return
		if(M.client.warfare_deaths <= 0)
			M.unlock_achievement(new/datum/achievement/warfare_survivor())

/datum/controller/subsystem/warfare/proc/assign_victory(var/blue = FALSE, var/red = FALSE) //This literally exists to give an achivement. Go fuck yourself.
	for(var/client/C in GLOB.clients)
		if(blue && C.warfare_faction == BLUE_TEAM)
			C.unlock_achievement(new/datum/achievement/warfare_victory())

		else if(red && C.warfare_faction == RED_TEAM)
			C.unlock_achievement(new/datum/achievement/warfare_victory())
