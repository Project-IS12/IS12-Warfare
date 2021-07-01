/datum/happiness_event
	var/description
	var/happiness = 0
	var/timeout = 1 MINUTE

///For descriptions, use the span classes bold info, info, none, warning and boldwarning in order from great to horrible.

//thirst
/datum/happiness_event/thirst/filled
	description = "<span class='binfo'>I've had enough to drink for a while!</span>\n"
	happiness = 4

/datum/happiness_event/thirst/watered
	description = "<span class='info'>I have recently had something to drink.</span>\n"
	happiness = 2

/datum/happiness_event/thirst/thirsty
	description = "<span class='warning'>I'm getting a bit thirsty.</span>\n"
	happiness = -7

/datum/happiness_event/thirst/dehydrated
	description = "<span class='danger'>I need water!</span>\n"
	happiness = -14



//nutrition
/datum/happiness_event/nutrition/fat
	description = "<span class='warning'><B>I'm so fat..</B></span>\n" //muh fatshaming
	happiness = -4

/datum/happiness_event/nutrition/wellfed
	description = "<span class='binfo'>My belly feels round and full.</span>\n"
	happiness = 4

/datum/happiness_event/nutrition/fed
	description = "<span class='info'>I have recently had some food.</span>\n"
	happiness = 2

/datum/happiness_event/nutrition/hungry
	description = "<span class='warning'>I'm getting a bit hungry.</span>\n"
	happiness = -6

/datum/happiness_event/nutrition/starving
	description = "<span class='danger'>I'm starving!</span>\n"
	happiness = -12


//Hygiene
/datum/happiness_event/hygiene/clean
	description = "<span class='info'>I feel so clean!\n"
	happiness = 2

/datum/happiness_event/hygiene/smelly
	description = "<span class='warning'>I smell like shit.\n"
	happiness = -5

/datum/happiness_event/hygiene/vomitted
	description = "<span class='warning'>Ugh, I've vomitted.\n"
	happiness = -5
	timeout = 1800



//Disgust
/datum/happiness_event/disgust/gross
	description = "<span class='warning'>That was gross.</span>\n"
	happiness = -2
	timeout = 1800

/datum/happiness_event/disgust/verygross
	description = "<span class='warning'>I think I'm going to puke...</span>\n"
	happiness = -4
	timeout = 1800

/datum/happiness_event/disgust/disgusted
	description = "<span class='danger'>Oh god that's disgusting...</span>\n"
	happiness = -6
	timeout = 1800



//Generic events
/datum/happiness_event/favorite_food
	description = "<span class='info'>I really liked eating that.</span>\n"
	happiness = 3
	timeout = 2400

/datum/happiness_event/nice_shower
	description = "<span class='info'>I had a nice shower.</span>\n"
	happiness = 1
	timeout = 1800

/datum/happiness_event/handcuffed
	description = "<span class='warning'>I guess my antics finally caught up with me..</span>\n"
	happiness = -1

/datum/happiness_event/hot_food //Hot food feels good!
	description = "<span class='info'>I've eaten something warm.</span>\n"
	happiness = 3
	timeout = 1800

/datum/happiness_event/cold_drink //Cold drinks feel good!
	description = "<span class='info'>I've had something refreshing.</span>\n"
	happiness = 3
	timeout = 1800

/datum/happiness_event/angered_god
	description = "<span class='danger'>I have angered my God!</span>\n"
	happiness = -12

/datum/happiness_event/pleased_god
	description = "<span class='binfo'>I have pleased my God!</span>\n"
	happiness = 12

/datum/happiness_event/unpraised_god
	description = "<span class='danger'>I do not praise my god! And that upsets them!</span>\n"
	happiness = -10
	timeout = FALSE //Praise your god or forever be unhappy!


/datum/happiness_event/dark//For being in the dark.
	description = "<span class='danger'>The darkness makes me uneasy.</span>\n"
	happiness = -5
	timeout = FALSE//no timeouts here.


//Embarassment
/datum/happiness_event/hygiene/shit
	description = "<span class='danger'>I shit myself. How embarassing.\n"
	happiness = -10
	timeout = 1800

/datum/happiness_event/hygiene/pee
	description = "<span class='danger'>I pissed myself. How embarassing.\n"
	happiness = -5
	timeout = 1800


//For when you get branded.
/datum/happiness_event/humiliated
	description = "<span class='danger'>I've been humiliated.</span>\n"
	happiness = -10
	timeout = 1800

//And when you've seen someone branded
/datum/happiness_event/punished_heretic
	description = "<span class='binfo'>I've seen a punished heretic.</span>\n"
	happiness = 10
	timeout = 1800

/datum/happiness_event/pain
	description = "<span class='danger'>IT HURTS SO MUCH!</span>\n"
	happiness = -10
	timeout = 1800

//For when you see someone die and you're not hardcore.
/datum/happiness_event/dead
	description = "<span class='danger'>OH MY GOD THEY'RE DEAD!</span>\n"
	happiness = -10
	timeout = 5 MINUTES

//For when you see a family member die.
/datum/happiness_event/family_death
	description = "<span class='danger'>I SAW A FAMILY MEMBER DIE!</span>\n"
	happiness = -12
	timeout = 5 MINUTES

/datum/happiness_event/captain_death
	description = "<span class='danger'>My captain is dead!</span>\n"
	happiness = -12
	timeout = 2 MINUTES

/datum/happiness_event/morale_boost
	description = "<span class='binfo'>OORAH! TODAY WE FIGHT LIKE MEN!</span>\n"
	happiness = 12
	timeout = 1800

// Addiction Events

/datum/happiness_event/addiction/withdrawal_small
	description = "<span class='danger'>I don't indulge in my addiction.</span>\n"
	happiness = -3
	timeout = FALSE

/datum/happiness_event/addiction/withdrawal_medium
	description = "<span class='danger'>I don't indulge in my addiction, that makes me unhappy!</span>\n"
	happiness = -5
	timeout = FALSE

/datum/happiness_event/addiction/withdrawal_large
	description = "<span class='danger'>I don't indulge in my addiction, that makes me very unhappy!</span>\n"
	happiness = -10
	timeout = FALSE

/datum/happiness_event/addiction/withdrawal_extreme
	description = "<span class='danger'>I DON'T INDULGE IN MY ADDICTION, MY DAY IS SHIT!!</span>\n"
	happiness = -12
	timeout = FALSE

/datum/happiness_event/high
	description = "<span class='binfo'>I'm high as fuck</span>\n"
	happiness = 12

/datum/happiness_event/relaxed
	description = "<span class='binfo'>That cigarette was good.</span>\n"
	happiness = 10
	timeout = 1800

/datum/happiness_event/booze
	description = "<span class='binfo'>Alcohol makes the pain go away.</span>\n"
	happiness = 10
	timeout = 2400