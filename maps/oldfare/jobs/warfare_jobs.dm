/datum/job/assistant
	total_positions = 0

/datum/map/warfare
	allowed_jobs = list(
	/datum/job/assistant,
    /datum/job/soldier/red_soldier/captain,
    /datum/job/soldier/red_soldier/sgt,
    /datum/job/soldier/red_soldier/medic,
	/datum/job/soldier/red_soldier/engineer,
	/datum/job/soldier/red_soldier/sentry,
	/datum/job/soldier/red_soldier/sniper,
	/datum/job/soldier/red_soldier/flame_trooper,
    /datum/job/soldier/red_soldier,
	/datum/job/soldier/red_soldier/scout,
	/datum/job/fortress/red/practitioner,

    /datum/job/soldier/blue_soldier/captain,
    /datum/job/soldier/blue_soldier/sgt,
    /datum/job/soldier/blue_soldier/medic,
	/datum/job/soldier/blue_soldier/engineer,
	/datum/job/soldier/blue_soldier/sniper,
	/datum/job/soldier/blue_soldier/sentry,
	/datum/job/soldier/blue_soldier/flame_trooper,
    /datum/job/soldier/blue_soldier,
	/datum/job/soldier/blue_soldier/scout,
	/datum/job/fortress/blue/practitioner
	)

/mob/living/carbon/human/proc/warfare_language_shit(var/language_name)
	if(aspect_chosen(/datum/aspect/one_word))
		return
	if(aspect_chosen(/datum/aspect/trenchmas)) //It's trenchmas, no need to have language barriers.
		return
	remove_language(LANGUAGE_GALCOM)
	var/datum/language/L = null
	add_language(language_name)
	L = all_languages[language_name]

	if(L)
		default_language = L

/datum/job/assistant
	title = "REDACTED"
	total_positions = 0
	spawn_positions = 0