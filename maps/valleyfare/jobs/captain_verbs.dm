/mob/living/carbon/human/proc/help_me()
	set name = "Help me!"
	set category = "Captain"

	if(stat)
		return

	var/is_blue = SSjobs.GetJobByTitle(job).is_blue_team
	var/class = "red_team"
	var/datum/team/T = SSwarfare.red
	if(is_blue)
		class = "blue_team"
		T = SSwarfare.blue

	if(T.checkCooldown("Help me!"))
		to_chat(src, "<span class='notice'>I can't overuse this!</span>")
		return

	for(var/mob/living/carbon/human/H in T.team)
		if(H == src)
			continue
		H.tracking.track(src)

	to_chat(T.team, "<h1><span class='[class]'>Your Captain requires help!</span></h1>")

	T.startCooldown("Help me!")
	sound_to(T.team, 'sound/effects/klaxon_alarm.ogg')

/mob/living/carbon/human/proc/retreat()
	set name = "Retreat!"
	set category = "Captain"
	if(stat)
		return

	var/is_blue = SSjobs.GetJobByTitle(job).is_blue_team
	var/class = "red_team"
	var/datum/team/T =  SSwarfare.red
	if(is_blue)
		class = "blue_team"
		T = SSwarfare.blue

	if(T.checkCooldown("Retreat!"))
		to_chat(src, "<span class='notice'>I can't overuse this!</span>")
		return

	to_chat(T.team, "<h1><span class='[class]'>Your Captain has ordered a retreat!</span></h1>")

	T.startCooldown("Retreat!")
	sound_to(T.team, 'sound/effects/klaxon_alarm.ogg')

/mob/living/carbon/human/proc/announce()
	set name = "Make Announcement!"
	set category = "Captain"
	if(stat)
		return

	var/is_blue = SSjobs.GetJobByTitle(job).is_blue_team
	var/class = "red_team"
	var/datum/team/T =  SSwarfare.red
	if(is_blue)
		class = "blue_team"
		T = SSwarfare.blue

	if(T.checkCooldown("Make Announcement!"))
		to_chat(src, "<span class='notice'>I can't overuse this!</span>")
		return

	var/announcement = sanitize(input(src, "What would you like to announce?", "Announcement"))
	if(!announcement)
		return

	if(findtext(announcement, config.ic_filter_regex))
		var/warning_message = "<span class='warning'>Bro you just tried to announce cringe! You're going to loose subscribers! Check the server rules!</br>The bolded terms are disallowed: &quot;"
		var/list/words = splittext(announcement, " ")
		var/cringe = ""
		for (var/word in words)
			if (findtext(word, config.ic_filter_regex))
				warning_message = "[warning_message]<b>[word]</b> "
				cringe += "/<b>[word]</b>"
			else
				warning_message = "[warning_message][word] "


		warning_message = trim(warning_message)
		to_chat(src, "[warning_message]&quot;</span>")
		log_and_message_admins("[src] just tried to ANNOUNCE cringe: [cringe]", src)
		return

	to_chat(T.team, "<h1><span class='[class]'>Announcement from Captain: <br> [announcement]</span></h1>")

	T.startCooldown("Make Announcement!")
	sound_to(T.team, 'sound/effects/klaxon_alarm.ogg')

/mob/living/carbon/human/proc/give_order()
	set name = "Give Order!"
	set category = "Captain"
	if(stat)
		return

	var/is_blue = SSjobs.GetJobByTitle(job).is_blue_team
	var/class = "red_team"
	var/datum/team/T =  SSwarfare.red
	if(is_blue)
		class = "blue_team"
		T = SSwarfare.blue

	if(T.checkCooldown("Give Order!"))
		to_chat(src, "<span class='notice'>I can't overuse this!</span>")
		return

	var/announcement = input(src, "What would you like to command?", "Give Order")
	if(!announcement)
		return
	if(findtext(announcement, config.ic_filter_regex))
		var/warning_message = "<span class='warning'>Bro you just tried to announce cringe! You're going to loose subscribers! Check the server rules!</br>The bolded terms are disallowed: &quot;"
		var/list/words = splittext(announcement, " ")
		var/cringe = ""
		for (var/word in words)
			if (findtext(word, config.ic_filter_regex))
				warning_message = "[warning_message]<b>[word]</b> "
				cringe += "/<b>[word]</b>"
			else
				warning_message = "[warning_message][word] "


		warning_message = trim(warning_message)
		to_chat(src, "[warning_message]&quot;</span>")
		log_and_message_admins("[src] just tried to ANNOUNCE cringe: [cringe]", src)
		return
	to_chat(T.team, "<h1><span class='[class]'>Order from Captain: <br> [announcement]</span></h1>")
	log_and_message_admins("[src] gave the order: <b>[announcement]</b>.", src)

	T.startCooldown("Give Order!")
	sound_to(T.team, 'sound/effects/klaxon_alarm.ogg')


/mob/living/carbon/human/proc/check_reinforcements()
	set name = "Check Reinforcements"
	set category = "Captain"

	var/is_blue = SSjobs.GetJobByTitle(job).is_blue_team
	var/datum/team/T =  SSwarfare.red
	if(is_blue)
		T = SSwarfare.blue
	if(T.checkCooldown("Check Reinforcements"))
		to_chat(src, "<span class='notice'>I can't overuse this!</span>")
		return
	if(is_blue)
		to_chat(src, "<span class='bnotice'><font size=4>Reinforcements Left: [SSwarfare.blue.left]</font></span>")
	else
		to_chat(src, "<span class='bnotice'><font size=4>Reinforcements Left: [SSwarfare.red.left]</font></span>")
	T.startCooldown("Check Reinforcements")



/mob/living/carbon/human/proc/morale_boost()
	set name = "Morale Boost"
	set category = "Squad Leader"
	if(stat)
		return

	var/is_blue = SSjobs.GetJobByTitle(job).is_blue_team
	var/class = "red_team"
	var/datum/team/T =  SSwarfare.red
	if(is_blue)
		class = "blue_team"
		T = SSwarfare.blue

	switch(alert(src,"This has a long cool down are you sure you wish to use this?", "Cooldown", "Yes", "No"))
		if("No")
			to_chat(src, "You decide not to use this power right now.")
			return

	if(T.checkCooldown("Morale Boost"))
		to_chat(src, "<span class='notice'>I can't overuse this!</span>")
		return

	for(var/mob/living/carbon/human/H in T.team)
		H.add_event("morale boost", /datum/happiness_event/morale_boost)

	T.startCooldown("Morale Boost", 10 MINUTES)
	sound_to(T.team, 'sound/effects/klaxon_alarm.ogg')
	to_chat(T.team, "<h1><span class='[class]'>OOORAH!</span></h1>")