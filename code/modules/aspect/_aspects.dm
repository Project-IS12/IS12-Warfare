/*
##################ASPECTS!############
##Aspects are one time events that only fire at the very beginning of the round.
##The idea behind them is that they change something about the game world, an aspect if you will,
##to keep rounds from being samey. They can either affect a certain job, the crew on whole, or the map.
##Obviously some are going to be more balanced than others. Aspects should change something about the
##game world to make it more interesting, not annoying. Remember that when adding a new one.
##
##In order to add your own just define a new aspect datum and add it to the "possible_aspects" list.
##I'm sure there's a better way to do this, and I'll change this comment block when I find one. - Matt
######################################

IT'S IMPORTANT TO REMEMBER THAT YES, ASPECTS HAVE THE HUGE POTENTIAL TO RUIN GAME BALANCE!
								USE THIS POWER WITH CAUTION!
*/

//Global "chosen aspect" mainly used to affect stuff post game launch
//The global list of aspects that can be chosen. Used in gameticker.dm
var/list/possible_aspects = list()

//Checks to see if the aspect chosen matches the argument. Useful for affecting stuff post round start.
proc/aspect_chosen(var/datum/aspect/aspect)
	if(!config.use_aspect_system)
		return FALSE
	if(!SSaspects.chosen_aspect)
		return FALSE
	if(istype(SSaspects.chosen_aspect, aspect))
		return TRUE


//Prints out the aspect. Used at the end of the round in gameticker.dm
proc/print_aspect()
	if(SSaspects.chosen_aspect)
		to_world("<b><FONT size=3 color='red'>The random game modifier was \"[SSaspects.chosen_aspect.name]\": [SSaspects.chosen_aspect.desc]</FONT></b>")


//Aspect defines
/datum/aspect
	var/name = "Default Aspect"
	var/desc = "Default description."

//The thing that does the thing roundstart.
/datum/aspect/proc/activate()
	return

/datum/aspect/proc/deactivate()
	display_deactivation_text()

/datum/aspect/proc/display_activation_text()
	to_world("<span class='binfo'><FONT size=3>Praise the atomic bomb! [desc]</FONT></span>")

/datum/aspect/proc/display_deactivation_text()
	to_world("<span class='binfo'><FONT size=3>Praise the atomic bomb! We will not battle under the curse of [name]</FONT></span>")


//Test aspect
/*
/datum/aspect/lightsout
    name = "Dark Days Ahead"
    desc = "All lights are broken today!"


//Breaks all the lights. How nice.
/datum/aspect/lightsout/activate()
	..()
	lightsout(0,0)
*/

/datum/aspect/trenchmas
	name = "Trenchmas"
	desc = "It's Trenchmas! We Will Not Battle This Day!"

/datum/aspect/clean_guns
	name = "Well Oiled Machine"
	desc = "Due to proper gun maintenance, guns will not jam this battle!"

/datum/aspect/lone_rider
	name = "Battlefield 1842"
	desc = "All bolt action rifles have been replaced by their lever action variants this battle!"

/datum/aspect/one_word
	name = "Civil War"
	desc = "Nothing seperates one side from the other. We all speak the same language this battle!"

/datum/aspect/no_guns
	name = "Slappers only!"
	desc = "Due to poor gun maintenance, guns just don't work this battle."

/datum/aspect/nightfare
	name = "Nightfare"
	desc = "Our worst fears have come true! The sun has gone out! There is no natural light on the battlefield!"

datum/aspect/nightfare/activate()
	//Change lobby to a moon or something. Adjust lobby music?
	..()
	for(var/obj/effect/lighting_dummy/daylight/A in GLOB.lighting_dummies)
		A.set_light(0, 0, 0)

datum/aspect/nightfare/deactivate()
	//Change lobby to a moon or something. Adjust lobby music?
	..()
	for(var/obj/effect/lighting_dummy/daylight/A in GLOB.lighting_dummies)
		A.set_light(3, 3, "#28284f")

