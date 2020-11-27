#define REQUIRED_CAPTURED_ZONES 5 //You gotta hold all four trenches and mid in order to enter the enemies zone.
#define REQUIRED_TRENCH_ZONES 3 //Hold

GLOBAL_LIST_EMPTY(blue_captured_zones) //= list()
GLOBAL_LIST_EMPTY(red_captured_zones) // = list()

GLOBAL_LIST_EMPTY(mortar_areas) // = list()


/area/constructionsite
	name = "\improper Construction Site"
	icon_state = "storage"

/area/maintenance/fsmaint2
	name = "\improper Fore Starboard Maintenance - 2"
	icon_state = "fsmaint"

/area/medical/surgery
	name = "\improper Operating Theatre"
	icon_state = "surgery"

/area/warfare
	music = 'sound/music/trench_bgm.ogg'
	dynamic_lighting = TRUE
	requires_power = FALSE

/area/warfare/battlefield
	name = "\improper Battlefield"
	var/captured = null
	turf_initializer = /decl/turf_initializer/oldfare
	var/can_pre_enter = FALSE
	//forced_ambience = list('sound/effects/siegestorm.ogg')

/area/warfare/battlefield/trench_section//So they can cross atop their trench section.
	can_pre_enter = TRUE

/area/warfare/battlefield/trench_section/underground//So it doesn't spawn random shit underground.
	//forced_ambience = list('sound/effects/siegestorm-indoor.ogg')
	turf_initializer = null


/area/warfare/battlefield/trench_section/underground/Entered(mob/living/L, area/A)
	. = ..()
	if(istype(L) && !istype(A, /area/warfare/battlefield))
		L.clear_fullscreen("fog")
		L.clear_fullscreen("ash")
		L.clear_fullscreen("fallout")
		//L.clear_fullscreen("rain")

/area/warfare/battlefield/no_mans_land
	name = "\improper No Man\'s Land"

	New()
		..()
		GLOB.mortar_areas += src

/area/warfare/battlefield/Entered(mob/living/L,  atom/A)
	. = ..()
	if(istype(L) && !istype(A, /area/warfare/battlefield))//Doesn't work but this does stop the lag.
		L.overlay_fullscreen("fog", /obj/screen/fullscreen/fog)
		L.overlay_fullscreen("fallout", /obj/screen/fullscreen/fallout)
		L.overlay_fullscreen("ash", /obj/screen/fullscreen/storm)
		//L.overlay_fullscreen("rain", /obj/screen/fullscreen/siegestorm)

/area/warfare/battlefield/capture_point
	name = "\improper Capture Point"
	icon_state = "storage"
	turf_initializer = null
	var/red_capture_points = 0
	var/blue_capture_points = 0
	var/list/blues = list()
	var/list/reds = list()

/area/warfare/battlefield/capture_point/New()
	..()
	START_PROCESSING(SSprocessing, src)

/area/warfare/battlefield/capture_point/Entered(atom/A)
	. = ..()
	if(ishuman(A))
		var/mob/living/carbon/human/H = A
		if(H.warfare_faction != captured)
			to_chat(H, "Now capturing [src]!")
		else
			to_chat(H, "Now defending [src]!")

/area/warfare/battlefield/capture_point/Process()
	for(var/mob/living/carbon/human/H in src)
		if(!istype(H))
			continue

		if(H.warfare_faction == BLUE_TEAM)
			if(H.stat == CONSCIOUS)//If they're dead or unconcious then don't add them.
				blues |= H
			else if(H.stat > 0)//If they die or pass out remove them.
				blues -= H
			else if(!H.client)//No client, then remove them.
				blues -= H

		//Same for red team.
		else if(H.warfare_faction == RED_TEAM )
			if(H.stat == CONSCIOUS)
				reds |= H
			else if(H.stat > 0)
				reds -= H
			else if(!H.client)
				reds -= H

	if(blues.len > reds.len)//More of the blue team than red team is in the area.
		if(blue_capture_points < config.trench_capture_points)
			blue_capture_points++//Increase the points until it's captured.
		if(red_capture_points > 0)
			red_capture_points--
	else if(blues.len < reds.len)//Opposite here.
		if(red_capture_points < config.trench_capture_points)
			red_capture_points++
		if(blue_capture_points > 0)
			blue_capture_points--

	if(blue_capture_points == (config.trench_capture_points/2) && (captured != BLUE_TEAM))//Announce when we're halfway done.
		to_world("<big>[uppertext("[BLUE_TEAM] are 50% done capturing the [src]")]</big>")

	if(red_capture_points == (config.trench_capture_points/2) && (captured != RED_TEAM))
		to_world("<big>[uppertext("[RED_TEAM] are 50% done capturing the [src]")]</big>")

	if(blue_capture_points >= config.trench_capture_points && (captured != BLUE_TEAM))//If we've already captured it we don't want to capture it again.
		to_world("<big>[uppertext("[BLUE_TEAM] HAVE CAPTURED THE [src]")]!</big>")
		captured = BLUE_TEAM
		GLOB.blue_captured_zones |= src//Add it to our list.
		GLOB.red_captured_zones -= src//Remove it from theirs.
		blue_capture_points = 0//Reset it back to 0.
		red_capture_points = 0//For both sides.
		sound_to(world, 'sound/effects/capture.ogg')

	else if(red_capture_points >= config.trench_capture_points && (captured != RED_TEAM))
		to_world("<big>[uppertext("[RED_TEAM] HAVE CAPTURED THE [src]")]!</big>")
		captured = RED_TEAM
		GLOB.red_captured_zones |= src
		GLOB.blue_captured_zones -= src
		blue_capture_points = 0
		red_capture_points = 0
		sound_to(world, 'sound/effects/capture.ogg')

/area/warfare/battlefield/capture_point/Exit(mob/living/L)
	. = ..()
	if(ishuman(L))
		if(L in blues)
			blues -= L
		else if(L in reds)
			reds -= L

/area/warfare/battlefield/capture_point/mid
	name = "Middle Bunker"
	icon_state = "start"

/area/warfare/battlefield/capture_point/red
	icon_state = "red"
	captured = RED_TEAM

	New()//They start out having these by default.
		..()
		GLOB.red_captured_zones |= src

/area/warfare/battlefield/capture_point/red/Enter(atom/movable/AM)
	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		if(H.warfare_faction == BLUE_TEAM && (GLOB.blue_captured_zones.len < REQUIRED_TRENCH_ZONES))
			to_chat(H, "<big>WE DO NOT CONTROL THE MIDDLE BUNKER!</big>")
			return FALSE
	return TRUE

/area/warfare/battlefield/capture_point/red/one
	name = "First South Trench"

/area/warfare/battlefield/capture_point/red/two
	name = "Second South Trench"

/area/warfare/battlefield/capture_point/blue
	icon_state = "blue"
	captured = BLUE_TEAM

	New()
		..()
		GLOB.blue_captured_zones |= src

/area/warfare/battlefield/capture_point/blue/Enter(atom/movable/AM)
	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		if(H.warfare_faction == RED_TEAM && (GLOB.red_captured_zones.len < REQUIRED_TRENCH_ZONES))
			to_chat(H, "<big>WE DO NOT CONTROL THE MIDDLE BUNKER!</big>")
			return FALSE
	return TRUE

/area/warfare/battlefield/capture_point/blue/one
	name = "First North Trench"

/area/warfare/battlefield/capture_point/blue/two
	name = "Second North Trench"

//If it's not time for war then you can't exit your starting trench.
/area/warfare/battlefield/Enter(atom/movable/mover as mob|obj, atom/forget as mob|obj|turf|area)
	if(!iswarfare())
		return TRUE
	if(ishuman(mover))
		var/mob/living/carbon/human/H = mover

		if(can_pre_enter)//You can always enter these areas.
			return TRUE

		if(locate(/obj/item/device/boombox) in H)//Locate the boombox.
			to_chat(H, "I can't bring this with me onto the battlefield. Wouldn't want to lose it.")//No you fucking don't.
			return //Keep that boombox at base asshole.

		if(locate(/obj/item/storage) in H)//Gotta check storage as well.
			var/obj/item/storage/S = locate() in H
			if(locate(/obj/item/device/boombox) in S)
				to_chat(H, "I can't bring this with me onto the battlefield. Wouldn't want to lose it.")
				return

		if(istype(SSjobs.GetJobByTitle(H.job), /datum/job/fortress) && captured != H.warfare_faction)
			to_chat(H, "<big>I need to stay home!</big>")
			return FALSE

		if(!SSwarfare.battle_time && captured != H.warfare_faction)//So people can enter their own trenches.
			to_chat(H, "<big>I am not ready to die yet!</big>")
			return FALSE

	if(istype(mover, /obj/item/device/boombox))//No boomboxes in no man's land please.
		return

	return TRUE

/area/warfare/homebase
	name = "\improper Base"
	icon_state = "start"
	requires_power = FALSE

/area/warfare/homebase/Entered(mob/living/L, area/A)
	. = ..()
	if(istype(L) && !istype(A, /area/warfare/battlefield))
		L.clear_fullscreen("fog")
		L.clear_fullscreen("ash")
		L.clear_fullscreen("fallout")
		//L.clear_fullscreen("rain")

/area/warfare/homebase/red
	name = "\improper Red Base"
	icon_state = "security"
	forced_ambience = null

/area/warfare/homebase/red/foyer
	//forced_ambience = list('sound/effects/siegestorm-indoor.ogg')

/area/warfare/homebase/red/outside
	//forced_ambience = list('sound/effects/siegestorm.ogg')

/area/warfare/homebase/red/Enter(atom/movable/AM)
	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		if(H.warfare_faction == BLUE_TEAM && (GLOB.blue_captured_zones.len < REQUIRED_CAPTURED_ZONES))//No spawn camping till you take the required zones bitch.
			to_chat(H, "<big>WE DO NOT CONTROL THE TRENCHES!</big>")
			return FALSE
	return TRUE


/area/warfare/homebase/blue
	name = "\improper Blue Base"
	icon_state = "showroom"
	forced_ambience = null

/area/warfare/homebase/blue/foyer
	//forced_ambience = list('sound/effects/siegestorm-indoor.ogg')

/area/warfare/homebase/blue/outside
	//forced_ambience = list('sound/effects/siegestorm.ogg')

/area/warfare/homebase/blue/Enter(atom/movable/AM)
	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		if(H.warfare_faction == RED_TEAM && (GLOB.red_captured_zones.len < REQUIRED_CAPTURED_ZONES))
			to_chat(H, "<big>WE DO NOT CONTROL THE TRENCHES!</big>")
			return FALSE
	return TRUE

/area/warfare/farawayhome
	name = "\improper Far Away"
	icon_state = "start"

/area/warfare/farawayhome/Enter(atom/movable/mover as mob|obj, atom/forget as mob|obj|turf|area)
	if(!iswarfare())
		return TRUE
	if(ishuman(mover))
		var/mob/living/carbon/human/H = mover
		to_chat(H, "<big>I CANNOT DISOBEY ORDERS!</big>")
	return FALSE