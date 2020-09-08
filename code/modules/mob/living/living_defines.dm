/mob/living
	see_in_dark = 2
	see_invisible = SEE_INVISIBLE_LIVING

	//Health and life related vars
	var/maxHealth = 100 //Maximum health that should be possible.
	var/health = 100 	//A mob's health

	var/hud_updateflag = 0

	//Damage related vars, NOTE: THESE SHOULD ONLY BE MODIFIED BY PROCS // what a joke
	//var/bruteloss = 0 //Brutal damage caused by brute force (punching, being clubbed by a toolbox ect... this also accounts for pressure damage)
	//var/oxyloss = 0   //Oxygen depravation damage (no air in lungs)
	//var/toxloss = 0   //Toxic damage caused by being poisoned or radiated
	//var/fireloss = 0  //Burn damage caused by being way too hot, too cold or burnt.
	//var/halloss = 0   //Hallucination damage. 'Fake' damage obtained through hallucinating or the holodeck. Sleeping should cause it to wear off.

	var/lisp = 0
	var/staminaloss = 0
	var/staminaexhaust = 250
	var/tongueless = 0

	var/last_special = 0 //Used by the resist verb, likely used to prevent players from bypassing next_move by logging in/out.

	var/t_phoron = null
	var/t_oxygen = null
	var/t_sl_gas = null
	var/t_n2 = null

	var/now_pushing = null
	var/mob_bump_flag = 0
	var/mob_swap_flags = 0
	var/mob_push_flags = 0
	var/mob_always_swap = 0

	var/mob/living/cameraFollow = null
	var/list/datum/action/actions = list()

	var/update_slimes = 1
	var/on_fire = 0 //The "Are we on fire?" var
	var/fire_stacks

	var/failed_last_breath = 0 //This is used to determine if the mob failed a breath. If they did fail a brath, they will attempt to breathe each tick, otherwise just once per 4 ticks.
	var/possession_candidate // Can be possessed by ghosts if unplayed.

	var/eye_blind = null	//Carbon
	var/eye_blurry = null	//Carbon
	var/ear_damage = null	//Carbon
	var/stuttering = null	//Carbon
	var/slurring = null		//Carbon
	var/slur_loop = FALSE
	var/deaf_loop = FALSE
	var/horror_loop = FALSE

	var/job = null//Living
	var/list/obj/aura/auras = null //Basically a catch-all aura/force-field thing.

	var/obj/screen/cells = null
	var/list/in_vision_cones = list()
	var/doing_something = FALSE

	var/religion = "Nothing" //Leftover from anther time.
	var/datum/trait/trait = null
	var/fast_stripper = FALSE //whether or not you can turbostrip

	//This is for the screen. Yes I hate this. Yes I know it needs a refactor. No I don't care at the moment.
	var/obj/screen/plane_master/blur/human_blur/HB = new
	var/obj/screen/plane_master/blur/turf_blur/TB = new
	var/obj/screen/plane_master/blur/wall_blur/WB = new
	var/obj/screen/plane_master/blur/obj_blur/OB = new
	var/obj/screen/plane_master/blur/above_turf_blur/AT = new
	var/obj/screen/plane_master/blur/lhuman_blur/LB = new
	var/obj/screen/plane_master/blur/mob_blur/MB = new
	var/obj/screen/plane_master/blur/above_human_blur/AB = new
	var/obj/screen/plane_master/blur/effects_blur/EB = new
	var/obj/screen/plane_master/blur/plating_blur/plating_blur = new
	var/obj/screen/plane_master/blur/above_obj_blur/AOB = new
