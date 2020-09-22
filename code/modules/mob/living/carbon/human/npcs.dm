#define cycle_pause 15 //min 1
#define viewrange 9 //min 2

//HOSTILE NPC DEFINES CREDIT TO GUAP FOR THE FIRST ZOMBIE AI WRITEUP, AND TO GOON WHERE I'M SURE IT CAME FROM.
/mob/living/carbon/human
	var/list/path = new/list()
	var/frustration = 0
	var/atom/object_target
	var/reach_unable
	var/is_npc = 0
	var/mob/living/carbon/human/target
	var/list/path_target = new/list()
	var/list/path_idle = new/list()
	var/list/objects
	var/list/npc_attack_emote = list("yells!", "makes a scary noise!")
	var/list/npc_attack_sound = list()
	var/aggroed = TRUE


	proc/aggro_npc()
		if(!is_npc)
			return
		aggroed = TRUE


	// this is called when the target is within one tile
	// of distance from the hostile npc
	proc/attack_target()
		var/obj/item/I = get_active_hand()
		var/obj/item/II = get_inactive_hand()

		if(target.stat != CONSCIOUS && prob(70) || target.is_npc)
			target = null
			return

		var/direct = get_dir(src, target)
		if ( (direct - 1) & direct)
			var/turf/Step_1
			var/turf/Step_2
			switch(direct)
				if(EAST|NORTH)
					Step_1 = get_step(src, NORTH)
					Step_2 = get_step(src, EAST)

				if(EAST|SOUTH)
					Step_1 = get_step(src, SOUTH)
					Step_2 = get_step(src, EAST)

				if(NORTH|WEST)
					Step_1 = get_step(src, NORTH)
					Step_2 = get_step(src, WEST)

				if(SOUTH|WEST)
					Step_1 = get_step(src, SOUTH)
					Step_2 = get_step(src, WEST)

			if(Step_1 && Step_2)
				var/check_1 = 1
				var/check_2 = 1

				check_1 = Adjacent(get_turf(src), Step_1, target) && Adjacent(Step_1, get_turf(target), target)

				check_2 = Adjacent(get_turf(src), Step_2, target) && Adjacent(Step_2, get_turf(target), target)

				if(check_1 || check_2)
					get_attack_type(I, II, target)
					if(prob(30))
						custom_emote(2, pick(npc_attack_emote))
						if(npc_attack_sound.len)
							playsound(src, pick(npc_attack_sound), 50, 0)
						return
					return
				else
					var/obj/structure/window/W = locate() in target.loc
					var/obj/structure/window/WW = locate() in src.loc
					if(W)
						W.attack_hand(src)
						if(prob(30))
							custom_emote(2, pick(npc_attack_emote))
							if(npc_attack_sound.len)
								playsound(src, pick(npc_attack_sound), 50, 0)
							return
						return 1
					else if(WW)
						WW.attack_hand(src)
						if(prob(30))
							custom_emote(2, pick(npc_attack_emote))
							if(npc_attack_sound.len)
								playsound(src, pick(npc_attack_sound), 50, 0)
							return
						return 1
		else if(Adjacent(src.loc , target.loc,target))
			get_attack_type(I, II, target)//target.attack_hand(src)
			if(prob(30))
				custom_emote(2, pick(npc_attack_emote))
				if(npc_attack_sound.len)
					playsound(src, pick(npc_attack_sound), 50, 0)
				return
			// sometimes push the enemy
			//if(prob(30))
			//	step(src,direct)
			return 1
		else
			var/obj/structure/window/W = locate() in target.loc
			var/obj/structure/window/WW = locate() in src.loc
			if(W)
				W.attack_hand(src)
				if(prob(30))
					custom_emote(2, pick(npc_attack_emote))
					if(npc_attack_sound.len)
						playsound(src, pick(npc_attack_sound), 50, 0)
					return
				return 1
			else if(WW)
				WW.attack_hand(src)
				if(prob(30))
					custom_emote(2, pick(npc_attack_emote))
					if(npc_attack_sound.len)
						playsound(src, pick(npc_attack_sound), 50, 0)
					return
				return 1

	// main loop
	proc/process()
		set background = 1

		if (stat)
			walk_to(src, 0)
			return 0


		if(weakened || paralysis || handcuffed)
			walk_to(src, 0)
			return 1

		if(resting)
			mob_rest()
			return 1

		if(!canmove)
			return 1

		setStaminaLoss(0)//So they don't wear themselves out.
		if(!aggroed)//If they ain't angry then we don't want them searching for targets.
			step(src, pick(GLOB.cardinal))
			return 1

		if(destroy_on_path())
			return 1

		if(!target)
			// no target, and we're angery, look for a new one

			// look for a target, taking into consideration their health
			// and distance from the npc
			var/last_health = INFINITY
			var/last_dist = INFINITY

			for (var/mob/living/carbon/human/C in orange(viewrange-2,src.loc))
				var/dist = get_dist(src, C)

				// if the npc can't directly see the human, they're
				// probably blocked off by a wall, so act as if the
				// human is further away
				if(!(C in view(src, viewrange)))
					dist += 3

				if (C.stat == 2 || !can_see(src,C,viewrange))
					continue
				if(C.stunned || C.paralysis || C.weakened)
					target = C
					break
				if(C.health < last_health && dist <= last_dist) if(!prob(30))
					last_health = C.health
					last_dist = dist
					target = C

		// if we have found a target
		if(target)
			if(target.is_npc)// If the target is an NPC then search again.
				target = null
				return

			// change the target if there is another human that is closer
			for (var/mob/living/carbon/human/C in orange(2,src.loc))
				if (C.stat == 2 || !can_see(src,C,viewrange))
					continue
				if(get_dist(src, target) >= get_dist(src, C) && prob(30))
					target = C
					break

			if(target.stat == 2)
				target = null


			var/distance = get_dist(src, target)

			if(target in orange(viewrange,src))
				if(distance <= 1)
					if(attack_target())
						return 1
				else
					walk_to(src, target, 1, 5)
					return 1
			else
				target = null
				return 1

		// if there is no target in range, roam randomly
		else
			frustration--
			frustration = max(frustration, 0)

			if(stat == 2) return 0

			var/prev_loc = loc
			// make sure they don't walk into space
			if(!(locate(/turf/space) in get_step(src,dir)))
				step(src,dir)
			// if we couldn't move, pick a different direction
			// also change the direction at random sometimes
			if(loc == prev_loc || prob(20))
				sleep(5)
				dir = pick(NORTH,SOUTH,EAST,WEST)

			return 1

		// if we couldn't do anything, take a random step
		step_rand(src)
		dir = get_dir(src,target) // still face to the target
		frustration++

		return 1

	// destroy items on the path
	proc/destroy_on_path()
		// if we already have a target, use that
		if(object_target)
			if(!object_target.density)
				object_target = null
				frustration = 0
			else
				// we know the target has attack_hand
				// since we only use such objects as the target
				object_target:attack_hand(src)
				if(prob(30))
					custom_emote(2, pick(npc_attack_emote))
					if(npc_attack_sound.len)
						playsound(src, pick(npc_attack_sound), 50, 0)			//But he will say one of the prepared words, or do an emote from say.dm
					return
				return 1

		// first, try to destroy airlocks and walls that are in the way
		if(locate(/obj/machinery/door/airlock) in get_step(src,src.dir))
			var/obj/machinery/door/airlock/D = locate() in get_step(src,src.dir)
			if(D)
				if(D.density && !(locate(/turf/space) in range(1,D)) )
					D.attack_hand(src)
					object_target = D
					if(prob(30))
						custom_emote(2, pick(npc_attack_emote))
						if(npc_attack_sound.len)
							playsound(src, pick(npc_attack_sound), 50, 0)			//But he will say one of the prepared words, or do an emote from say.dm
						return
					return 1
		// before clawing through walls, try to find a direct path first
		if(frustration > 8 )
			if(istype(get_step(src,src.dir),/turf/simulated/wall))
				var/turf/simulated/wall/W = get_step(src,src.dir)
				if(W)
					if(W.density && !(locate(/turf/space) in range(1,W)))
						W.attack_hand(src)
						object_target = W
						if(prob(30))
							custom_emote(2, pick(npc_attack_emote))
							if(npc_attack_sound.len)
								playsound(src, pick(npc_attack_sound), 50, 0)			//But he will say one of the prepared words, or do an emote from say.dm
							return
						return 1
		return 0

	death()
		..()
		target = null

	//This is the ugliest thing I have ever seen.
	proc/get_attack_type(var/obj/item/I, var/obj/item/II, mob/living/carbon/human/target)
		I = get_active_hand()
		II = get_inactive_hand()
		if(I)
			target.attackby(I, src)
		else if(II)
			target.attackby(II, src)
		else
			target.attack_hand(src)


/mob/living/carbon/human/monkey/punpun/New()
	..()
	name = "Pun Pun"
	real_name = name
	var/obj/item/clothing/C
	if(prob(50))
		C = new /obj/item/clothing/under/punpun(src)
		equip_to_appropriate_slot(C)
	else
		C = new /obj/item/clothing/under/punpants(src)
		C.attach_accessory(null, new/obj/item/clothing/accessory/toggleable/hawaii/random(src))
		equip_to_appropriate_slot(C)
		if(prob(10))
			C = new/obj/item/clothing/head/collectable/petehat(src)
			equip_to_appropriate_slot(C)

/decl/hierarchy/outfit/blank_subject
	name = "Test Subject"
	uniform = /obj/item/clothing/under/color/white
	shoes = /obj/item/clothing/shoes/white
	head = /obj/item/clothing/head/helmet/facecover
	mask = /obj/item/clothing/mask/muzzle
	suit = /obj/item/clothing/suit/straight_jacket

/decl/hierarchy/outfit/blank_subject/post_equip(mob/living/carbon/human/H)
	..()
	var/obj/item/clothing/under/color/white/C = locate() in H
	if(C)
		C.has_sensor  = SUIT_LOCKED_SENSORS
		C.sensor_mode = SUIT_SENSOR_OFF

/mob/living/carbon/human/blank/New(var/new_loc)
	..(new_loc, "Vat-Grown Human")

/mob/living/carbon/human/blank/Initialize()
	. = ..()
	var/number = "[pick(possible_changeling_IDs)]-[rand(1,30)]"
	fully_replace_character_name("Subject [number]")
	var/decl/hierarchy/outfit/outfit = outfit_by_type(/decl/hierarchy/outfit/blank_subject)
	outfit.equip(src)
	var/obj/item/clothing/head/helmet/facecover/F = locate() in src
	if(F)
		F.SetName("[F.name] ([number])")

/mob/living/carbon/human/blank/ssd_check()
	return FALSE

//Hostile NPCs.

//SKINLESS
/datum/species/human/skinless/handle_npc(var/mob/living/carbon/human/H)//DON'T SPAWN TOO MANY OF THESE PLEASE!
	H.process()

/mob/living/carbon/human/skinless/ssd_check()
	return FALSE

/mob/living/carbon/human/skinless/Initialize()
	. = ..()
	fully_replace_character_name(random_skinless_name(src.gender))
	zone_sel = new /obj/screen/zone_sel( null )
	zone_sel.selecting = pick("chest", "head")
	warfare_faction = RED_TEAM
	var/decl/hierarchy/outfit/outfit = outfit_by_type(/decl/hierarchy/outfit/job/redsoldier)
	outfit.equip(src)
	a_intent = I_HURT
	npc_attack_sound = list('sound/voice/emotes/skinless1.ogg','sound/voice/emotes/skinless2.ogg','sound/voice/emotes/skinless3.ogg','sound/voice/emotes/skinless4.ogg','sound/voice/emotes/skinless5.ogg',)

	is_npc = 1//Make sure their an NPC so they don't attack each other.
	hand = 0//Make sure one of their hands is active.
	var/weapon = pick(/obj/item/crowbar, /obj/item/melee/classic_baton/trench_club, /obj/item/melee/classic_baton)
	put_in_hands(new weapon)//Give them a weapon.
	combat_mode = 1//Put them in combat mode.
	STAT_LEVEL(dex) = 1

/datum/species/human/lackey/handle_npc(var/mob/living/carbon/human/H)
	H.process()

/mob/living/carbon/human/lackey/ssd_check()
	return FALSE

/mob/living/carbon/human/lackey/Initialize()
	. = ..()
	fully_replace_character_name(random_lackey_name())
	var/decl/hierarchy/outfit/outfit = outfit_by_type(/decl/hierarchy/outfit/lackey)
	outfit.equip(src)
	a_intent = I_HURT
	aggroed = FALSE

	is_npc = 1//Make sure their an NPC so they don't attack each other.
	hand = 0//Make sure one of their hands is active.
	var/weapon = pick(/obj/item/crowbar, /obj/item/melee/classic_baton)
	put_in_hands(new weapon)//Give them a weapon.
	combat_mode = 1//Put them in combat mode.
	STAT_LEVEL(dex) = 1

/decl/hierarchy/outfit/lackey
	name = "Lackey"
	uniform = /obj/item/clothing/under/color/grey
	shoes = /obj/item/clothing/shoes/black