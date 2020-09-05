/mob/proc/agony_scream(var/fire = FALSE)
	if(stat)
		return
	if(emote_cd == 1)		// Check if we need to suppress the emote attempt.
		return
	var/screamsound = null
	var/muzzled = istype(wear_mask, /obj/item/clothing/mask/muzzle)
	var/message = null

	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		if(!muzzled)
			if(H.isMonkey())
				screamsound = "sound/voice/monkey_pain[rand(1,3)].ogg"

			else if(H.isChild())
				screamsound = "sound/voice/child_pain[rand(1,2)].ogg"

			else if(src.gender == MALE)
				if(fire)
					screamsound = "sound/voice/agony_male[rand(1, 10)].ogg"
				else
					screamsound = "sound/voice/man_pain[rand(1,3)].ogg"

			else
				screamsound = "sound/voice/woman_agony[rand(1,3)].ogg"
			message = "screams in agony!"

		else
			message = "makes a loud noise!"
			screamsound = "sound/voice/gagscream[rand(1,3)].wav"

	if(screamsound)
		playsound(src, screamsound, 50, 0, 1)

	if(message)
		custom_emote(2,message)
	shake_camera(src, 20, 3)//suffer well pupper
	handle_emote_CD()

/mob/proc/gasp_sound(var/collapsed_lung = FALSE, var/drowning = FALSE)
	var/gaspsound = null
	var/muzzled = istype(wear_mask, /obj/item/clothing/mask/muzzle)
	if(stat)
		return
	if(emote_cd == 1)		// Check if we need to suppress the emote attempt.
		return

	if(muzzled)
		custom_emote(2,"[src.name] makes a muffled gasping noise.")
		return

	if(gender == MALE)
		if(drowning)
			gaspsound =	"sound/voice/emotes/gurp_male[rand(1,2)].ogg"
		else
			gaspsound = "sound/voice/gasp_male[rand(1,7)].ogg"

	if(gender == FEMALE)
		if(drowning)
			gaspsound = "sound/voice/emotes/gurp_female[rand(1,2)].ogg"
		else
			gaspsound = "sound/voice/gasp_female[rand(1,7)].ogg"

	if(collapsed_lung)
		gaspsound = "sound/voice/gasp[rand(1,3)].ogg"

	if(gaspsound)
		playsound(src, gaspsound, 25, 0, 1)
	handle_emote_CD()


/mob/proc/agony_moan()
	if(stat)
		return
	if(emote_cd == 1)		// Check if we need to suppress the emote attempt.
		return
	var/moansound = null
	var/message = null

	var/muzzled = istype(src.wear_mask, /obj/item/clothing/mask/muzzle)
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		if(!muzzled)
			if(H.isMonkey())
				return

			if(H.isChild())
				moansound = 'sound/voice/child_moan1.ogg'

			else if(src.gender == MALE)
				moansound = "sound/voice/male_moan[rand(1,3)].ogg"

			else
				moansound = "sound/voice/female_moan[rand(1,3)].ogg"

			message = "moans."
		else
			message = "makes a loud noise!"
			moansound = "sound/voice/gagscream[rand(1,3)].wav"

	if(moansound)
		playsound(src, moansound, 50, 0, 1)

	if(message)
		custom_emote(2,message)
	handle_emote_CD()


/mob/proc/freakout_emote()
	if(stat)
		return
	if(emote_cd == 1)		// Check if we need to suppress the emote attempt.
		return
	var/screamsound = null
	var/message = null

	var/muzzled = istype(src.wear_mask, /obj/item/clothing/mask/muzzle)
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		if(!muzzled)
			if(H.isMonkey())
				return

			message = "loses their fucking mind!"
		else
			message = "makes a loud noise!"

		screamsound = "sound/voice/gagscream[rand(1,3)].wav"


	if(screamsound)
		playsound(src, screamsound, 50, 0, 1)

	if(message)
		custom_emote(2,message)
	handle_emote_CD()