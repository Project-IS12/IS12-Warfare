/mob/living/carbon/proc/print_happiness()
	var/msg = "<span class='info'><div class='examinebox'>"
	if(real_name)
		msg += "<span class='info'>My name is <span class='danger'>[real_name]</span>.</span>\n"
	if(age)
		msg += "<span class='info'>I am <span class='danger'>[age]</span> years old.</span>\n"
	if(squad)
		msg += "<span class='info'>I'm in <span class='danger'>[squad.name]</span> squad!</span>\n"
	if(social_class)
		msg +=	"<span class='info'>I am <span class='danger'>[get_social_class()]</span>.</span>\n"
	if(trait)
		msg += 	"<span class='info'>I am <span class='danger'>[trait.name]</span>. [trait.description]</span>\n"
	if(quirk)//NOT THE SAME THING AS TRAITS
		msg += "<span class='info'>Oh lucky, I am also <span class='danger'>[quirk.name]</span>. [quirk.description]</span>\n"
	msg += "<EM>Current feelings:</EM>\n"
	for(var/i in events)
		var/datum/happiness_event/event = events[i]
		msg += event.description

	if(!events.len)
		msg += "<span class='info'>I feel indifferent.</span>\n"

	if(happiness < MOOD_LEVEL_SAD2)
		msg += "<span class='warning'>I am stressed out!</span>\n"


	msg += "</span></div>"
	to_chat(src, msg)

/mob/living/carbon/proc/update_happiness()
	var/old_happiness = happiness
	var/old_icon = null
	if(happiness_icon)
		old_icon = happiness_icon.icon_state
	happiness = 0
	for(var/i in events)
		var/modified_mood
		var/datum/happiness_event/event = events[i]
		if(has_quirk(/datum/quirk/hypersensitive))
			modified_mood = (event.happiness*2) //Double the happiness.
		else
			modified_mood = event.happiness //Otherwise leave it the same.

		happiness += modified_mood

	if(has_quirk(/datum/quirk/dead_inside))//Set this to be the same.
		happiness = MOOD_LEVEL_HAPPY1

	if(has_quirk(/datum/quirk/brave))
		happiness = MOOD_LEVEL_HAPPY1 //Still get moodies, they just don't affect you.

	switch(happiness)
		if(-5000000 to MOOD_LEVEL_SAD4)
			if(happiness_icon)
				happiness_icon.icon_state = "mood7"

		if(MOOD_LEVEL_SAD4 to MOOD_LEVEL_SAD3)
			if(happiness_icon)
				happiness_icon.icon_state = "mood6"

		if(MOOD_LEVEL_SAD3 to MOOD_LEVEL_SAD2)
			if(happiness_icon)
				happiness_icon.icon_state = "mood5"

		if(MOOD_LEVEL_SAD2 to MOOD_LEVEL_SAD1)
			if(happiness_icon)
				happiness_icon.icon_state = "mood5"

		if(MOOD_LEVEL_SAD1 to MOOD_LEVEL_HAPPY1)
			if(happiness_icon)
				happiness_icon.icon_state = "mood4"

		if(MOOD_LEVEL_HAPPY1 to MOOD_LEVEL_HAPPY2)
			if(happiness_icon)
				happiness_icon.icon_state = "mood4"

		if(MOOD_LEVEL_HAPPY2 to MOOD_LEVEL_HAPPY3)
			if(happiness_icon)
				happiness_icon.icon_state = "mood3"

		if(MOOD_LEVEL_HAPPY3 to MOOD_LEVEL_HAPPY4)
			if(happiness_icon)
				happiness_icon.icon_state = "mood2"

		if(MOOD_LEVEL_HAPPY4 to INFINITY)
			if(happiness_icon)
				happiness_icon.icon_state = "mood1"

	if(old_icon && old_icon != happiness_icon.icon_state)
		if(old_happiness > happiness)
			to_chat(src, "<span class='warning'>I have become more stressed.</span>")
		else
			to_chat(src, "<span class='info'>I have become less stressed.</span>")

/mob/proc/flash_sadness()
	if(prob(2))
		flick("sadness",pain)
		var/spoopysound = pick('sound/effects/badmood1.ogg','sound/effects/badmood2.ogg','sound/effects/badmood3.ogg','sound/effects/badmood4.ogg')
		var/actual_message = ""
		var/msg = rand(1,4)
		switch(msg)
			if(1)
				actual_message = "None of this is real."
				spoopysound = 'sound/voice/sam/none_of_this_is_real.ogg'
			if(2)
				actual_message = "You need to wake up."
				spoopysound = 'sound/voice/sam/you_need_to_wake_up.ogg'
			if(3)
				actual_message = "The blood will never wash away."
				spoopysound = 'sound/voice/sam/wash_away.ogg'
			if(4)
				actual_message = pick("This isn't actually happening.", "I don't want to die anymore.", "GOTTA GET A GRIP!")

		sound_to(src, spoopysound)
		to_chat(src, "<span class='phobia'<big>[actual_message]</big></span>")

/mob/living/carbon/proc/handle_happiness()
	if(happiness > MOOD_LEVEL_SAD4)
		if(horror_loop)
			to_chat(src, "<span class='phobia'>My nerves relax some... I can think clearly again...</span>")
			sound_to(src, sound(null, repeat = 1, wait = 0, volume = 50, channel = 6))
			horror_loop = FALSE
			clear_fullscreen("freakout", /obj/screen/fullscreen/freakout)


	switch(happiness)
		if(MOOD_LEVEL_SAD4 to MOOD_LEVEL_SAD3)
			flash_sadness()
		if(-INFINITY to MOOD_LEVEL_SAD4)
			do_stress_effects()
			flash_sadness()

/mob/living/carbon/proc/do_stress_effects()
	return

/mob/living/carbon/human/do_stress_effects()
	if(!horror_loop)
		freakout_emote()
		sound_to(src, sound('sound/effects/losing_my_mind.ogg', repeat = 1, wait = 0, volume = 25, channel = 6))
		horror_loop = TRUE
		overlay_fullscreen("freakout", /obj/screen/fullscreen/freakout)
		to_chat(src, "<span class='phobia'<big>I AM FREAKING THE FUCK OUT!</big></span>")
	stuttering = 5
	shake_camera(src, 5, 0.1)

/mob/living/carbon/proc/add_event(category, type) //Category will override any events in the same category, should be unique unless the event is based on the same thing like hunger.
	if(has_quirk(/datum/quirk/dead_inside))//They're dead inside, they feel nothing.
		return
	var/datum/happiness_event/the_event
	if(events[category])
		the_event = events[category]
		if(the_event.type != type)
			clear_event(category)
			return .()
		else
			return 0 //Don't have to update the event.
	else
		the_event = new type()

	events[category] = the_event
	update_happiness()

	if(the_event.timeout)
		spawn(the_event.timeout)
			clear_event(category)

/mob/living/carbon/proc/clear_event(category)
	var/datum/happiness_event/event = events[category]
	if(!event)
		return 0

	events -= category
	qdel(event)
	update_happiness()

/mob/living/carbon/proc/adjust_thirst(var/amount)
	var/old_thirst = thirst
	if(amount>0)
		thirst = min(thirst+amount, THIRST_LEVEL_MAX)

	else if(old_thirst)
		thirst = max(thirst+amount, 0)

/mob/living/carbon/proc/set_thirst(var/amount)
	if(amount >= 0)
		thirst = min(THIRST_LEVEL_MAX, amount)