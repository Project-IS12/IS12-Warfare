//DATUM BASED SKILL SYSTEM
//HIJACKS ORANGE'S SKILL AND STAT SYSTEM
//Doesn't change the math at all just makes stats and skills a datum for easier use.
//To add a new stat or skill just define one and set it's variabls, it will be automatically added to the mob.

//to check stat level use mymob.STAT_LEVEL(example_stat)
//for skills it's mymob.SKILL_LEVEL(example_skill)

//For getting stats there is also mymob.GET_STAT(example_stat)
//and mymob.GET_SKILL(example_skill)
//But you probably won't use those.

//Holders
/mob
	var/list/my_skills = list()
	var/list/my_stats = list()

//Skill defines
/datum/skill
	var/name = "My Skill"
	var/level = 0//What the value is, used in skill checks
	var/xp = 0//What the level is, used for leveling up the skill to the next rank.
	var/level_up_req = 100
	var/category = "General Skills"

//Stat defines
/datum/stat
	var/name = "My Stat"
	var/level = 10//Its level, used in stat calculations.
	var/shorthand = "sh"//Shorthand

//Stats
/datum/stat/str
	name = "Strength"
	shorthand = "ST"

/datum/stat/dex
	name = "Dexterity"
	shorthand = "DX"

/datum/stat/end
	name = "Endurance"
	shorthand = "ED"

/datum/stat/int
	name = "Intelligence"
	shorthand = "IT"


//Skills these can probably go in their own file
/datum/skill/melee
	name = "melee"

/datum/skill/ranged
	 name = "ranged"

/datum/skill/medical
	name = "medicine"

/datum/skill/engineering
	name = "engineering"

/datum/skill/surgery
	name = "surgery"

//Gun skills.
/datum/skill/auto_rifle
	category = "Gun Skills"
	name = "automatic rifles"

/datum/skill/semi_rifle
	category = "Gun Skills"
	name = "semi auto rifles"

/datum/skill/sniper
	category = "Gun Skills"
	name = "sniper rifles"

/datum/skill/shotgun
	category = "Gun Skills"
	name = "shotguns"

/datum/skill/lmg
	category = "Gun Skills"
	name = "machine guns"

/datum/skill/smg
	category = "Gun Skills"
	name = "SMGs"


//Initalization
/mob/living/carbon/human/proc/init_skills()
	for(var/thing in init_subtypes(/datum/skill))//subtypes init magic I don't know ask Kyrah about it
		var/datum/skill/S = thing
		my_skills[S.type] = S

/mob/living/carbon/human/proc/init_stats()
	for(var/thing in init_subtypes(/datum/stat))
		var/datum/stat/S = thing
		my_stats[S.type] = S


//boosters and setters, not really used at the moment.
/datum/stat/proc/boost_stat(var/num, var/time)
	level += num
	if(time)
		spawn(time)
			level -= num

/datum/stat/proc/reduce_stat(var/num, var/time)
	level -= num
	if(time)
		spawn(time)
			level += num

/datum/stat/proc/set_stat(var/num)
	level = num

//Now for skills
/datum/skill/proc/boost_skill(var/num, var/time)
	level += num
	if(time)
		spawn(time)
			level -= num

/datum/skill/proc/reduce_skill(var/num, var/time)
	level -= num
	if(time)
		spawn(time)
			level += num

/datum/skill/proc/set_skill(var/num)
	level = num

//Leveling up a skill
/datum/skill/proc/give_xp(var/amount, var/mob/user)
	xp += amount
	to_chat(user, "<span class='notice'>I have learned more about [src.name]!</span>")
	attempt_level_up(user)


/datum/skill/proc/attempt_level_up(var/mob/user)
	if(xp == level_up_req)
		level++
		to_chat(user,"<span class='notice'>My level of knowledge about [src.name] has increased!</span>")


/proc/cmp_skill_level(datum/skill/A, datum/skill/B)
    return cmp_numeric_asc(B.level, A.level)

//Checking skills
/mob/living/carbon/human/proc/check_skills()
	set name = "Check Skills"
	set category = "IC"
	var/message = "<div class='examinebox'><big><b>General Skills:</b></big>\n"
	var/list/skill_copy = my_skills.Copy()
	sortTim(skill_copy, /proc/cmp_skill_level, associative = TRUE)
	for(var/type in skill_copy)
		var/datum/skill/S = skill_copy[type]
		if(S.category == "General Skills")
			if(S.level)
				message += "I am <b>[skillnumtodesc(S.level)]</b> at [S.name].\n"
			else
				message += "<small>I have no knowledge of [S.name].</small>\n"
	message += "<big><b>Gun Skills:</b></big>\n"
	for(var/type in skill_copy)
		var/datum/skill/S = skill_copy[type]
		if(S.category == "Gun Skills")
			if(S.level)
				message += "I am <b>[skillnumtodesc(S.level)]</b> at [S.name].\n"
			else
				message += "<small>I have no knowledge of [S.name].</small>\n"
	to_chat(src, "[message]</div>")

//Use this proc to add stats to the jobs, it will add up on default values, keep that in mind
/mob/living/carbon/human/proc/add_stats(var/strength, var/dexterity, var/endurance, var/intelligence)//TODO: Make this more atomic.
	if(strength)
		STAT_LEVEL(str) = strength
		if(has_quirk(/datum/quirk/weak))
			STAT_LEVEL(str) -= 2
		if(has_quirk(/datum/quirk/strong))
			STAT_LEVEL(str) += 2
	if(dexterity)
		STAT_LEVEL(dex) = dexterity
	if(endurance)
		STAT_LEVEL(end) = endurance
	if(intelligence)
		STAT_LEVEL(int) = intelligence
	updateweight()

//same thing but for skills
/mob/living/carbon/human/proc/add_skills(var/melee, var/ranged, var/medical, var/engineering, var/surgery)
	if(melee)
		SKILL_LEVEL(melee) = melee
	if(ranged)
		SKILL_LEVEL(ranged) = ranged
	if(medical)
		SKILL_LEVEL(medical) = medical
	if(engineering)
		SKILL_LEVEL(engineering) = engineering
	if(surgery)
		SKILL_LEVEL(surgery) = surgery


///Modifiers///
//Converts mood level into number for the modifier
/mob/living/carbon/human/proc/mood()
	switch(happiness)
		if(-5000000 to MOOD_LEVEL_SAD4)
			return -4
		if(MOOD_LEVEL_SAD4 to MOOD_LEVEL_SAD3)
			return -3
		if(MOOD_LEVEL_SAD3 to MOOD_LEVEL_SAD2)
			return -2
		if(MOOD_LEVEL_SAD2 to MOOD_LEVEL_SAD1)
			return -1
		if(MOOD_LEVEL_SAD1 to MOOD_LEVEL_HAPPY1)
			return 1
		if(MOOD_LEVEL_HAPPY1 to MOOD_LEVEL_HAPPY2)
			return 2
		if(MOOD_LEVEL_HAPPY2 to MOOD_LEVEL_HAPPY3)
			return 3
		else
			return 4

//Converts stamina level into number for the modifier
/mob/living/carbon/human/proc/fatigue()
	switch(staminaloss)
		if(0)
			return 2
		if(1 to 20)
			return 0
		if(21 to 40)
			return -1
		if(41 to 60)
			return -2
		if(61 to 80)
			return -3
		if(81 to 100)
			return -4
		else
			return -5

//Add this to the action and specify what will happen in each outcome.//
//Important! you should not use more than one stat in proc but if you really want to, you should multiply amount of dices and crit according to how much of them you added to the formula//
//For example: two stats will need 6d6 dicetype and also 20 crit instead of 10//
//REMEMBER THIS: when adding proc to action you BOUND to specify SUCCESS and CRIT_FAILURE in it! FAILURE may do nothing and CRIT_SUCCESS may be same as SUCCESS though//
/mob/living/carbon/human/proc/statscheck(var/stats = 0, var/skills = 0, var/dicetype = "3d6", var/crit = 10, var/mod = 0)
	var/dice = roll(dicetype)
	var/modifier = mood() + fatigue() + mod
	var/sum = stats + skills * 2 + modifier

	if(chem_effects[CE_PAINKILLER] > 100)//Being high on pain pills will fuck up your rolls.
		sum -= 5

	if(is_hellbanned())//Being hellbanned fucks with you.
		sum -= 5

	if(dice <= sum)
		if(dice <= sum - crit || dice <= 4)
			return CRIT_SUCCESS
		else
			return SUCCESS
	else
		if(dice >= sum + crit || dice >= 17)
			return CRIT_FAILURE
		else
			return FAILURE

//helpers
proc/skillnumtodesc(var/skill)
	switch(skill)
		if(1)
			return "<small>completely worthless</small>"
		if(2)
			return "<small>incompetent</small>"
		if(3)
			return "<small>a novice</small>"
		if(4)
			return "<small>unskilled</small>"
		if(5)
			return "good enough"
		if(6)
			return "adept"
		if(7)
			return "versed"
		if(8)
			return FONT_LARGE("an expert")
		if(9)
			return FONT_LARGE("a master")
		if(10)
			return FONT_LARGE("legendary")
	if(skill > 10)
		return "inhuman"

proc/backwards_skill_scale(var/skill)
	if(0)
		return 10
	if(1)
		return 9
	if(2)
		return 8
	if(3)
		return 7
	if(4)
		return 6
	if(5)
		return 5
	if(6)
		return 4
	if(7)
		return 3
	if(8)
		return 2
	else
		return 1

proc/dexToAccuracyModifier(var/dexterity)
	return dexterity - 10

proc/strToDamageModifier(var/strength)
	return strength * 0.1

proc/endToStaminaModifier(var/endurance)
	return (endurance - 10) * 15

proc/strToSpeedModifier(var/strength, var/w_class)//
	switch(strength)
		if(1 to 5)
			if(w_class > ITEM_SIZE_NORMAL)
				return 20

		if(6 to 11)
			if(w_class > ITEM_SIZE_NORMAL)
				return 15

		if(12 to 15)
			if(w_class > ITEM_SIZE_NORMAL)
				return 10

		if(16 to INFINITY)
			if(w_class > ITEM_SIZE_NORMAL)
				return 5

//Unimplemented, unused.
/*
/mob/living/carbon/human/proc/set_stats(var/list/args)
	var/i
	for(i=1,i<=args.len,i++)
		var/type = args[i]
		var/value = args[type]
		my_stats[type].level = value
	updateweight()

set_stats(list(STAT(str) = rand(6,9), STAT(dex) = rand(8,12),STAT(dex) = rand(5,8), rand(8,12)))
*/



