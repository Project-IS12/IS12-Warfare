/area
	var/is_mortar_area = FALSE

// check /datum/controller/subsystem/warfare for warfare vars and procs

/datum/game_mode/warfare
	name = "Warfare"
	round_description = "All out warfare on the battlefront!"
	extended_round_description = "Invade the enemies trenches and then destroy them! War is heck! Expect to die a lot!"
	config_tag = "warfare"
	required_players = 0
	auto_recall_shuttle = TRUE //If the shuttle is even somehow called.

/datum/game_mode/warfare/declare_completion()
	SSWarfare.declare_completion()

/datum/game_mode/warfare/post_setup()
	..()
	SSWarfare.begin_countDown()


/datum/game_mode/warfare/check_finished()
	if(SSWarfare.check_completion())
		return TRUE
	..()


/mob/living/carbon/human/proc/handle_warfare_death()
	if(!iswarfare())
		return
	if(is_npc)
		return
	if(src in SSWarfare.blue.team)//If in the team.
		SSWarfare.blue.left--//Take out a life.
		SSWarfare.blue.team -= src//Remove them from the team.
	if(src in SSWarfare.red.team)//Same here.
		SSWarfare.red.left--
		SSWarfare.red.team -= src

	if(client)
		client.warfare_deaths++

	// as far as i know there are no immediate jobtype vars in mind or human, so here we go
	if(job_master?.GetJobByTitle(job)?.type == /datum/job/soldier/red_soldier/captain)
		for(var/X in SSWarfare.red.team)
			var/mob/living/carbon/human/H = X
			H.add_event("captain death", /datum/happiness_event/captain_death)
	if(job_master?.GetJobByTitle(job)?.type == /datum/job/soldier/blue_soldier/captain)
		for(var/X in SSWarfare.blue.team)
			var/mob/living/carbon/human/H = X
			H.add_event("captain death", /datum/happiness_event/captain_death)
	if(job_master?.GetJobByTitle(job)?.open_when_dead)//When the person dies who has this job, free this role again.
		job_master.allow_one_more(job)

	if(!GLOB.first_death)
		GLOB.first_death = real_name
	if(!GLOB.first_death_happened)
		GLOB.first_death_happened = TRUE
	if(!GLOB.final_words)
		GLOB.final_words = last_words

/mob/living/carbon/human/proc/handle_warfare_life()
	if(!iswarfare())
		return

	if(tracking)
		tracking.update()

/proc/iswarfare()
    return (istype(ticker.mode, /datum/game_mode/warfare) || master_mode=="warfare")
