//Defines for echo list index positions.
//ECHO_DIRECT and ECHO_ROOM are the only two that actually appear to do anything, and represent the dry and wet channels of the environment effects, respectively.
//The rest of the defines are there primarily for the sake of completeness. It might be worth testing on EAX-enabled hardware, and on future BYOND versions (I've tested with 511, 512, and 513)
#define ECHO_DIRECT 1
#define ECHO_DIRECTHF 2
#define ECHO_ROOM 3
#define ECHO_ROOMHF 4
#define ECHO_OBSTRUCTION 5
#define ECHO_OBSTRUCTIONLFRATIO 6
#define ECHO_OCCLUSION 7
#define ECHO_OCCLUSIONLFRATIO 8
#define ECHO_OCCLUSIONROOMRATIO 9
#define ECHO_OCCLUSIONDIRECTRATIO 10
#define ECHO_EXCLUSION 11
#define ECHO_EXCLUSIONLFRATIO 12
#define ECHO_OUTSIDEVOLUMEHF 13
#define ECHO_DOPPLERFACTOR 14
#define ECHO_ROLLOFFFACTOR 15
#define ECHO_ROOMROLLOFFFACTOR 16
#define ECHO_AIRABSORPTIONFACTOR 17
#define ECHO_FLAGS 18

//Defines for controlling how zsound sounds.
#define ZSOUND_DRYLOSS_PER_Z -2000 //Affects what happens to the dry channel as the sound travels through z-levels
#define ZSOUND_DISTANCE_PER_Z 2 //Affects the distance added to the sound per z-level travelled

//Sound environment defines. Reverb preset for sounds played in an area, see sound datum reference for more.
#define GENERIC 0
#define PADDED_CELL 1
#define ROOM 2
#define BATHROOM 3
#define LIVINGROOM 4
#define STONEROOM 5
#define AUDITORIUM 6
#define CONCERT_HALL 7
#define CAVE 8
#define ARENA 9
#define HANGAR 10
#define CARPETED_HALLWAY 11
#define HALLWAY 12
#define STONE_CORRIDOR 13
#define ALLEY 14
#define FOREST 15
#define CITY 16
#define MOUNTAINS 17
#define QUARRY 18
#define PLAIN 19
#define PARKING_LOT 20
#define SEWER_PIPE 21
#define UNDERWATER 22
#define DRUGGED 23
#define DIZZY 24
#define PSYCHOTIC 25

#define STANDARD_STATION STONEROOM
#define LARGE_ENCLOSED HANGAR
#define SMALL_ENCLOSED BATHROOM
#define TUNNEL_ENCLOSED CAVE
#define LARGE_SOFTFLOOR CARPETED_HALLWAY
#define MEDIUM_SOFTFLOOR LIVINGROOM
#define SMALL_SOFTFLOOR ROOM
#define ASTEROID CAVE
#define SPACE UNDERWATER

GLOBAL_LIST_INIT(shatter_sound,list('sound/effects/Glassbr1.ogg','sound/effects/Glassbr2.ogg','sound/effects/Glassbr3.ogg'))
GLOBAL_LIST_INIT(explosion_sound,list('sound/effects/explosion1.ogg','sound/effects/explosion2.ogg'))
GLOBAL_LIST_INIT(spark_sound,list('sound/effects/sparks1.ogg','sound/effects/sparks2.ogg','sound/effects/sparks3.ogg','sound/effects/sparks4.ogg'))
GLOBAL_LIST_INIT(rustle_sound,list('sound/effects/rustle1.ogg','sound/effects/rustle2.ogg','sound/effects/rustle3.ogg','sound/effects/rustle4.ogg','sound/effects/rustle5.ogg'))
GLOBAL_LIST_INIT(punch_sound,list('sound/weapons/punch_01.ogg','sound/weapons/punch_02.ogg','sound/weapons/punch_03.ogg','sound/weapons/punch_04.ogg','sound/weapons/punch_05.ogg','sound/weapons/punch_06.ogg','sound/weapons/punch_07.ogg','sound/weapons/punch_08.ogg','sound/weapons/punch_09.ogg','sound/weapons/punch_10.ogg'))
GLOBAL_LIST_INIT(clown_sound,list('sound/effects/clownstep1.ogg','sound/effects/clownstep2.ogg'))
GLOBAL_LIST_INIT(swing_hit_sound,list('sound/weapons/genhit1.ogg', 'sound/weapons/genhit2.ogg', 'sound/weapons/genhit3.ogg'))
GLOBAL_LIST_INIT(hiss_sound,list('sound/voice/hiss1.ogg','sound/voice/hiss2.ogg','sound/voice/hiss3.ogg','sound/voice/hiss4.ogg'))
GLOBAL_LIST_INIT(page_sound,list('sound/effects/pageturn1.ogg', 'sound/effects/pageturn2.ogg','sound/effects/pageturn3.ogg'))
GLOBAL_LIST_INIT(fracture_sound,list('sound/effects/bonebreak1.ogg','sound/effects/bonebreak2.ogg','sound/effects/bonebreak3.ogg','sound/effects/bonebreak4.ogg'))
GLOBAL_LIST_INIT(lighter_sound,list('sound/items/lighter1.ogg','sound/items/lighter2.ogg'))
GLOBAL_LIST_INIT(keypress_sound,list('sound/machines/keyboard/keypress1.ogg','sound/machines/keyboard/keypress2.ogg','sound/machines/keyboard/keypress3.ogg','sound/machines/keyboard/keypress4.ogg'))
GLOBAL_LIST_INIT(keystroke_sound,list('sound/machines/keyboard/keystroke1.ogg','sound/machines/keyboard/keystroke2.ogg','sound/machines/keyboard/keystroke3.ogg','sound/machines/keyboard/keystroke4.ogg'))
GLOBAL_LIST_INIT(switch_sound,list('sound/machines/switch1.ogg','sound/machines/switch2.ogg','sound/machines/switch3.ogg','sound/machines/switch4.ogg'))
GLOBAL_LIST_INIT(button_sound,list('sound/machines/button1.ogg','sound/machines/button2.ogg','sound/machines/button3.ogg','sound/machines/button4.ogg'))
GLOBAL_LIST_INIT(flop_sound, list('sound/effects/bodyfall1.ogg','sound/effects/bodyfall2.ogg','sound/effects/bodyfall3.ogg','sound/effects/bodyfall4.ogg'))
GLOBAL_LIST_INIT(trauma_sound, list('sound/effects/gore/trauma1.ogg', 'sound/effects/gore/trauma2.ogg', 'sound/effects/gore/trauma3.ogg'))
GLOBAL_LIST_INIT(casing_sound, list('sound/weapons/guns/misc/casingfall1.ogg','sound/weapons/guns/misc/casingfall2.ogg','sound/weapons/guns/misc/casingfall3.ogg'))
GLOBAL_LIST_INIT(terminal_type, list('sound/machines/keypress1.ogg', 'sound/machines/keypress2.ogg', 'sound/machines/keypress3.ogg', 'sound/machines/keypress4.ogg'))
GLOBAL_LIST_INIT(keyboard_sound, list('sound/machines/terminal_button01.ogg', 'sound/machines/terminal_button02.ogg', 'sound/machines/terminal_button03.ogg',
							  'sound/machines/terminal_button04.ogg', 'sound/machines/terminal_button05.ogg', 'sound/machines/terminal_button06.ogg',
							  'sound/machines/terminal_button07.ogg', 'sound/machines/terminal_button08.ogg'))
GLOBAL_LIST_INIT(keyboard_sound_long, list('sound/effects/keyboard/keyboard1.ogg', 'sound/effects/keyboard/keyboard2.ogg', 'sound/effects/keyboard/keyboard3.ogg', 'sound/effects/keyboard/keyboard4.ogg'))
GLOBAL_LIST_INIT(gun_sound, list('sound/weapons/guns/fire/pistol1.ogg', 'sound/weapons/guns/fire/pistol2.ogg', 'sound/weapons/guns/fire/pistol3.ogg', 'sound/weapons/guns/fire/pistol4.ogg', 'sound/weapons/guns/fire/pistol5.ogg'))
GLOBAL_LIST_INIT(brifle, list('sound/weapons/newrifle.ogg', 'sound/weapons/newrifle2.ogg', 'sound/weapons/newrifle3.ogg'))
GLOBAL_LIST_INIT(bullet_hit_wall, list('sound/weapons/guns/misc/ric1.ogg', 'sound/weapons/guns/misc/ric2.ogg', 'sound/weapons/guns/misc/ric3.ogg', 'sound/weapons/guns/misc/ric4.ogg', 'sound/weapons/guns/misc/ric5.ogg'))
GLOBAL_LIST_INIT(shotgun_insert, list('sound/weapons/guns/interact/shell_insert1.ogg','sound/weapons/guns/interact/shell_insert2.ogg'))
GLOBAL_LIST_INIT(stab_sound, list('sound/weapons/stab1.ogg', 'sound/weapons/stab2.ogg', 'sound/weapons/stab3.ogg'))
GLOBAL_LIST_INIT(slash_sound, list('sound/weapons/slash1.ogg','sound/weapons/slash2.ogg','sound/weapons/slash3.ogg'))
GLOBAL_LIST_INIT(blunt_swing, list('sound/weapons/blunt_swing1.ogg','sound/weapons/blunt_swing2.ogg','sound/weapons/blunt_swing3.ogg'))
GLOBAL_LIST_INIT(swing_sound, list('sound/weapons/swing_01.ogg', 'sound/weapons/swing_02.ogg', 'sound/weapons/swing_03.ogg'))
GLOBAL_LIST_INIT(shovel_swing, list('sound/weapons/shovel_swing1.ogg', 'sound/weapons/shovel_swing2.ogg'))
GLOBAL_LIST_INIT(shovel_hit, list('sound/weapons/shovel_hit1.ogg', 'sound/weapons/shovel_hit2.ogg', 'sound/weapons/shovel_hit3.ogg'))
GLOBAL_LIST_INIT(chop_sound, list('sound/weapons/chop1.ogg','sound/weapons/chop2.ogg','sound/weapons/chop3.ogg'))
GLOBAL_LIST_INIT(armor_walk_sound, list('sound/effects/footsteps/armor/gear1.ogg','sound/effects/footsteps/armor/gear2.ogg','sound/effects/footsteps/armor/gear3.ogg','sound/effects/footsteps/armor/gear4.ogg'))
GLOBAL_LIST_INIT(blood_drip, list('sound/effects/gore/blood1.ogg', 'sound/effects/gore/blood2.ogg', 'sound/effects/gore/blood3.ogg', 'sound/effects/gore/blood3.ogg', 'sound/effects/gore/blood4.ogg', 'sound/effects/gore/blood5.ogg', 'sound/effects/gore/blood6.ogg'))
GLOBAL_LIST_INIT(head_break_sound, list('sound/effects/gore/blast1.ogg', 'sound/effects/gore/blast3.ogg', 'sound/effects/gore/blast4.ogg'))
GLOBAL_LIST_INIT(foliage, list('sound/effects/foliage_01.ogg','sound/effects/foliage_02.ogg', 'sound/effects/foliage_03.ogg', 'sound/effects/foliage_04.ogg', 'sound/effects/foliage_05.ogg'))
GLOBAL_LIST_INIT(foliagedry, list('sound/effects/foliage_forest_01.ogg','sound/effects/foliage_forest_02.ogg', 'sound/effects/foliage_forest_03.ogg', 'sound/effects/foliage_forest_04.ogg', 'sound/effects/foliage_forest_05.ogg'))
GLOBAL_LIST_INIT(gun_pickup, list('sound/items/handle/gunpickup1.ogg', 'sound/items/handle/gunpickup2.ogg', 'sound/items/handle/gunpickup3.ogg'))
GLOBAL_LIST_INIT(far_fire_sound,list('sound/effects/weapons/gun/far_fire1.ogg','sound/effects/weapons/gun/far_fire2.ogg','sound/effects/weapons/gun/far_fire3.ogg'))
GLOBAL_LIST_INIT(far_sniper,list('sound/effects/weapons/gun/rifle_farfire1.ogg','sound/effects/weapons/gun/rifle_farfire2.ogg','sound/effects/weapons/gun/rifle_farfire3.ogg', 'sound/effects/weapons/gun/rifle_farfire4.ogg'))
GLOBAL_LIST_INIT(far_rifle,list('sound/effects/weapons/gun/semi_farfire1.ogg','sound/effects/weapons/gun/semi_farfire2.ogg','sound/effects/weapons/gun/semi_farfire3.ogg', 'sound/effects/weapons/gun/semi_farfire4.ogg'))
GLOBAL_LIST_INIT(eat_food, list('sound/effects/eating/eat1.ogg', 'sound/effects/eating/eat2.ogg', 'sound/effects/eating/eat3.ogg', 'sound/effects/eating/eat4.ogg', 'sound/effects/eating/eat5.ogg'))
GLOBAL_LIST_INIT(drink_sound, list('sound/effects/eating/drink1.ogg','sound/effects/eating/drink2.ogg','sound/effects/eating/drink3.ogg','sound/effects/eating/drink4.ogg','sound/effects/eating/drink5.ogg'))



/proc/playsound(atom/source, soundin, vol as num, vary, extrarange as num, falloff, is_global, frequency, is_ambiance = 0,  ignore_walls = TRUE, zrange = 2, override_env, envdry, envwet)
	if(isarea(source))
		error("[source] is an area and is trying to make the sound: [soundin]")
		return

	soundin = get_sfx(soundin) // same sound for everyone
	frequency = vary && isnull(frequency) ? get_rand_frequency() : frequency // Same frequency for everybody

	var/turf/turf_source = get_turf(source)
	var/maxdistance = (world.view + extrarange) * 2

 	// Looping through the player list has the added bonus of working for mobs inside containers
	var/list/listeners = GLOB.player_list
	if(!ignore_walls) //these sounds don't carry through walls
		listeners = listeners & hearers(maxdistance, turf_source)

	for(var/P in listeners)
		var/mob/M = P
		if(!M || !M.client)
			continue

		if(get_dist(M, turf_source) <= maxdistance)
			var/turf/T = get_turf(M)

			if(T && (T.z == turf_source.z || (zrange && AreConnectedZLevels(T.z, turf_source.z) && abs(T.z - turf_source.z) <= zrange)) && (!is_ambiance || M.get_preference_value(/datum/client_preference/play_ambiance) == GLOB.PREF_YES))
				M.playsound_local(turf_source, soundin, vol, vary, frequency, falloff, is_global, extrarange, override_env, envdry, envwet)

var/const/FALLOFF_SOUNDS = 0.5

/mob/proc/playsound_local(var/turf/turf_source, soundin, vol as num, vary, frequency, falloff, is_global, extrarange, override_env, envdry, envwet)
	if(!src.client || ear_deaf > 0)
		return

	var/sound/S = soundin
	if(!istype(S))
		soundin = get_sfx(soundin)
		S = sound(soundin)
		S.wait = 0 //No queue
		S.channel = 0 //Any channel
		S.volume = vol
		S.environment = -1
		if(frequency)
			S.frequency = frequency
		else if (vary)
			S.frequency = get_rand_frequency()

	//sound volume falloff with pressure
	var/pressure_factor = 1.0

	var/turf/T = get_turf(src)
	// 3D sounds, the technology is here!
	if(isturf(turf_source))
		//sound volume falloff with distance
		var/distance = get_dist(T, turf_source)

		S.volume -= max(distance - (world.view + extrarange), 0) * 2 //multiplicative falloff to add on top of natural audio falloff.

		var/datum/gas_mixture/hearer_env = T.return_air()
		var/datum/gas_mixture/source_env = turf_source.return_air()

		if (hearer_env && source_env)
			var/pressure = min(hearer_env.return_pressure(), source_env.return_pressure())

			if (pressure < ONE_ATMOSPHERE)
				pressure_factor = max((pressure - SOUND_MINIMUM_PRESSURE)/(ONE_ATMOSPHERE - SOUND_MINIMUM_PRESSURE), 0)
		else //in space
			pressure_factor = 0

		if (distance <= 1)
			pressure_factor = max(pressure_factor, 0.15)	//hearing through contact

		S.volume *= pressure_factor

		if (S.volume <= 0)
			return //no volume means no sound

		var/dx = turf_source.x - T.x // Hearing from the right/left
		S.x = dx
		var/dz = turf_source.y - T.y // Hearing from infront/behind
		S.z = dz
		var/dy = (turf_source.z - T.z) * ZSOUND_DISTANCE_PER_Z // Hearing from above/below. There is ceiling in 2d spessmans.
		S.y = (dy < 0) ? dy - 1 : dy + 1 //We want to make sure there's *always* at least one extra unit of distance. This helps normalize sound that's emitting from the turf you're on.
		S.falloff = (falloff ? falloff : FALLOFF_SOUNDS)

		if(!override_env)
			envdry = abs(turf_source.z - T.z) * ZSOUND_DRYLOSS_PER_Z

	if(!is_global)

		if(istype(src,/mob/living/))
			var/mob/living/carbon/M = src
			if (istype(M) && M.hallucination_power > 50 && M.chem_effects[CE_MIND] < 1)
				S.environment = PSYCHOTIC
			else if (M.druggy)
				S.environment = DRUGGED
			else if (M.drowsyness)
				S.environment = DIZZY
			else if (M.confused)
				S.environment = DIZZY
			else if (M.stat == UNCONSCIOUS)
				S.environment = UNDERWATER
			else if (pressure_factor < 0.5)
				S.environment = SPACE
			else
				var/area/A = get_area(src)
				S.environment = A.sound_env

		else if (pressure_factor < 0.5)
			S.environment = SPACE
		else
			var/area/A = get_area(src)
			S.environment = A.sound_env

	var/list/echo_list = new(18)
	echo_list[ECHO_DIRECT] = envdry
	echo_list[ECHO_ROOM] = envwet
	S.echo = echo_list

	sound_to(src, S)

/client/proc/playtitlemusic()
	if(get_preference_value(/datum/client_preference/play_lobby_music) == GLOB.PREF_YES)
		GLOB.using_map.lobby_music.play_to(src)

/proc/get_rand_frequency()
	return rand(32000, 55000) //Frequency stuff only works with 45kbps oggs.

/proc/get_sfx(soundin)
	if(istext(soundin))
		switch(soundin)
			if ("shatter") soundin = pick(GLOB.shatter_sound)
			if ("explosion") soundin = pick(GLOB.explosion_sound)
			if ("sparks") soundin = pick(GLOB.spark_sound)
			if ("rustle") soundin = pick(GLOB.rustle_sound)
			if ("punch") soundin = pick(GLOB.punch_sound)
			if ("clownstep") soundin = pick(GLOB.clown_sound)
			if ("swing_hit") soundin = pick(GLOB.swing_hit_sound)
			if ("hiss") soundin = pick(GLOB.hiss_sound)
			if ("pageturn") soundin = pick(GLOB.page_sound)
			if ("fracture") soundin = pick(GLOB.fracture_sound)
			if ("light_bic") soundin = pick(GLOB.lighter_sound)
			if ("keyboard") soundin = pick(GLOB.keyboard_sound)
			if ("keystroke") soundin = pick(GLOB.keystroke_sound)
			if ("switch") soundin = pick(GLOB.switch_sound)
			if ("button") soundin = pick(GLOB.button_sound)
			if ("trauma") soundin = pick(GLOB.trauma_sound)
			if ("headsmash") soundin = pick(GLOB.head_break_sound)
			if ("stab_sound") soundin = pick(GLOB.stab_sound)
			if ("casing_sound") soundin = pick(GLOB.casing_sound)
			if ("keypress") soundin = pick(GLOB.keypress_sound)
			if ("gunshot") soundin = pick(GLOB.gun_sound)
			if ("brifle") soundin = pick(GLOB.brifle)
			if ("hitwall") soundin = pick(GLOB.bullet_hit_wall)
			if ("slash_sound") soundin = pick(GLOB.slash_sound)
			if ("swing_sound") soundin = pick(GLOB.swing_sound)
			if ("blunt_swing") soundin = pick(GLOB.blunt_swing)
			if ("shovel_swing") soundin = pick(GLOB.shovel_swing)
			if ("shovel_hit") soundin = pick(GLOB.shovel_hit)
			if ("chop") soundin = pick(GLOB.chop_sound)
			if ("pratfall") soundin = pick(GLOB.flop_sound)
			if ("armorwalk") soundin = pick(GLOB.armor_walk_sound)
			if ("blood_drip") soundin = pick(GLOB.blood_drip)
			if ("shotgun_insert") soundin = pick(GLOB.shotgun_insert)
			if ("foliage") soundin = pick(GLOB.foliage)
			if ("foliagedry") soundin = pick(GLOB.foliagedry)
			if ("gun_pickup") soundin = pick(GLOB.gun_pickup)
			if ("far_fire") soundin = pick(GLOB.far_fire_sound)
			if ("sniper_fire") soundin = pick(GLOB.far_sniper)
			if ("rifle_fire") soundin = pick(GLOB.far_rifle)
			if ("eat") soundin = pick(GLOB.eat_food)
			if ("drink") soundin = pick(GLOB.drink_sound)
	return soundin
