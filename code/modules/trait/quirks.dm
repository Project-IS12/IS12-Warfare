/mob/living
	var/datum/quirk/quirk = null

/datum/quirk
	var/name = "quirk name"
	var/description = "quirk description"


/datum/quirk/hypersensitive //Doubles mood values.
	name = "hypersensitive"
	description = "I'm more sensitive to good and bad moods than normal."

/datum/quirk/alcoholic //Starts out addicted to alcohol
	name = "alcoholic"
	description = "I need booze to be happy."

/datum/quirk/cig_addict //Starts out addicted to nicotine.
	name = "a smoker"
	description = "I need a smoke every now and then."

/datum/quirk/brave //Still gets moods, but is not bothered by them.
	name = "brave"
	description = "I'm not stressed by combat."

/datum/quirk/no_bathroom //You'll never have to use the restroom.
	name = "bladderless"
	description = "I don't have to use the restroom."

/datum/quirk/tough //Still feel pain, just not bothered by it as often.
	name = "tough"
	description = "I'm more pain resiliant than most."

/datum/quirk/weak //Removes two str
	name = "weak"
	description = "I'm not as strong as I should be."

/datum/quirk/strong //Adds two str
	name = "strong"
	description = "I'm stronger than should be."

/datum/quirk/dead_inside //Gets no moods. Isn't bothered by anything.
	name = "dead inside"
	description = "I feel nothing anymore."
/*
/datum/quirk/psychopath //Shooting people boosts their mood.
	name = "psychopath"
	description = "I love killing people!"
*/


/mob/living/proc/has_quirk(var/datum/quirk/this_quirk)
	return istype(quirk, this_quirk)

/mob/living/proc/set_quirk(var/datum/quirk/set_quirk)
	quirk = set_quirk

/mob/living/proc/remove_quirk()
	quirk = null