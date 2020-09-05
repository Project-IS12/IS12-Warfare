//Achievements system by Matt.
//This system allows you there to be achievements in the game, that are not tied to a database or to the byond medals system
//User mob.unlock_achievement(new/datum/achievement/achievement()) or client.unlock_achievement(new/datum/achievement/achievement())
//Check achievements.dm for the list of achievements.

//Defines for client.
/client
	var/datum/achievements/achievement_holder = null

//The achievement holder datum
/datum/achievements
	var/list/achievements = list()

/client/New()
	achievement_holder = new
	..()

//The actual achievements
/datum/achievement
	var/name = "Default Achievement"
	var/description = "Default Description"
	var/difficulty = DIFF_EASY
	var/announced = FALSE

/client/proc/unlock_achievement(var/datum/achievement/A)
	if(IsGuestKey(src.key))
		return
	for(var/X in achievement_holder.achievements)
		var/datum/achievement/AA = X
		if(A.name == AA.name) //I don't think a name check is very safe here, we should type check instead.
			return
	achievement_holder.achievements |= A
	var/savefile/F = new /savefile("data/player_saves/[copytext(ckey, 1, 2)]/[ckey]/achievements.sav")//Store the achievemnt in the file.
	achievement_holder.Write(F)
	var/H
	switch(A.difficulty)
		if (DIFF_MEDIUM)
			H = "#EE9A4D"
		if (DIFF_EASY)
			H = "green"
		if (DIFF_HARD)
			H = "red"
	if (A.announced)
		to_world("<b>Achievement Unlocked! [src.key] unlocked the '<font color = [H]>[A.name]</font color>' achievement.</b></font>")
	else
		to_chat(src, "<b>Achievement Unlocked! You unlocked the '<font color = [H]>[A.name]</font color>' achievement.</b></font>")
	if(A.description)
		to_chat(src, "<i>[A.description]</i>")

/mob/proc/unlock_achievement(var/datum/achievement/A)// use is 	mob.unlock_achievement(new/datum/achievement/achievement())
	if(client)
		client.unlock_achievement(A)


/mob/verb/show_achievements()
	set name = "Show Achievements"
	set category = "OOC"

	if(!client)//How they check achievements without client? No idea. But I'm staying sane.
		return

	if(IsGuestKey(src.key)) //How did they even connect without being logged in? No idea. But better safe than sorry.
		to_chat(src, "<b>Guests don't get achievements.</b>")
		return

	var/count = 0
	to_chat(src, "<b>Achievements:</b>\n")

	for(var/X in client.achievement_holder.achievements)
		var/datum/achievement/A = X //Typeless loops are faster than typed ones. Or os TG told me anyway. *shrug*
		var/H
		count++
		switch(A.difficulty)
			if (DIFF_MEDIUM)
				H = "#EE9A4D"
			if (DIFF_EASY)
				H = "green"
			if (DIFF_HARD)
				H = "red"
		to_chat(src, "<b>[count]:<font color = [H]> [A.name]</font color></b></font>")
		if(A.description)
			to_chat(src, "<i>[A.description]</i>\n")
		else
			to_chat(src, "\n")
	if(count)
		to_chat(src, "---\n<b>TOTAL ACHIEVEMENTS: [count]</b>")