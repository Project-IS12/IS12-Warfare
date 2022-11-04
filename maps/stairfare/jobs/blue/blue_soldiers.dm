/datum/job/soldier/blue_soldier
	title = "Blue Soldier"
	outfit_type = /decl/hierarchy/outfit/job/bluesoldier/soldier
	is_blue_team = TRUE
	selection_color = "#76abb2"

	//auto_rifle_skill = 10 //This is leftover from coldfare, but we could go back to that one day so better not to mess with it. //Fuck you we're not going back to it.
	semi_rifle_skill = 10
	boltie_skill = 10
	sniper_skill = 3
	shotgun_skill = 5
	lmg_skill = 3
	smg_skill = 3

	equip(var/mob/living/carbon/human/H)
		H.warfare_faction = BLUE_TEAM
		..()
		H.add_stats(rand(12,17), rand(10,16), rand(8,12))
		SSwarfare.blue.team += H
		if(can_be_in_squad)
			H.assign_random_squad(BLUE_TEAM)
		H.fully_replace_character_name("Pvt. [H.real_name]")
		H.warfare_language_shit(LANGUAGE_BLUE)
		H.assign_random_quirk()
		if(announced)
			H.say(";Soldier reporting for duty!")

/datum/job/soldier/blue_soldier/sgt
	title = "Blue Squad Leader"
	total_positions = 3
	social_class = SOCIAL_CLASS_MED
	outfit_type = /decl/hierarchy/outfit/job/bluesoldier/sgt
	can_be_in_squad = FALSE //They have snowflake squad bullshit.

	auto_rifle_skill = 10
	semi_rifle_skill = 10
	shotgun_skill = 10

	announced = FALSE

	equip(var/mob/living/carbon/human/H)
		var/current_name = H.real_name
		..()
		H.verbs += /mob/living/carbon/human/proc/morale_boost
		H.assign_squad_leader(BLUE_TEAM)
		H.fully_replace_character_name("Sgt. [current_name]")
		H.say(";[title] reporting for duty!")



/datum/job/soldier/blue_soldier/medic
	title = "Blue Medic"
	outfit_type = /decl/hierarchy/outfit/job/bluesoldier/medic
	can_be_in_squad = FALSE //We assign them to a squad seperately.

	//Skill defines
	medical_skill = 10
	surgery_skill = 10
	engineering_skill = 4
	auto_rifle_skill = 3
	semi_rifle_skill = 10

	announced = FALSE

	equip(var/mob/living/carbon/human/H)
		var/current_name = H.real_name
		..()
		H.assign_random_squad(BLUE_TEAM, "medic")
		H.set_trait(new/datum/trait/death_tolerant())
		H.fully_replace_character_name("Medic [current_name]")
		H.say(";Medic reporting for duty!")


/datum/job/soldier/blue_soldier/engineer
	title = "Blue Engineer"
	outfit_type = /decl/hierarchy/outfit/job/bluesoldier/engineer
	engineering_skill = 10
	auto_rifle_skill = 5
	semi_rifle_skill = 5
	smg_skill = 3
	shotgun_skill = 10
	boltie_skill = 5

	announced = FALSE

	equip(var/mob/living/carbon/human/H)
		var/current_name = H.real_name
		..()
		H.assign_random_squad(BLUE_TEAM, "engineer")
		H.add_stats(rand(15,17), rand(10,16), rand(12,16))
		H.fully_replace_character_name("Eng. [current_name]")
		H.say(";Engineer reporting for duty!")


/datum/job/soldier/blue_soldier/sniper
	title = "Blue Sniper"
	total_positions = 2
	outfit_type = /decl/hierarchy/outfit/job/bluesoldier/sniper
	auto_rifle_skill = 3
	semi_rifle_skill = 3
	sniper_skill = 10
	shotgun_skill = 3
	lmg_skill = 3
	smg_skill = 3
	open_when_dead = FALSE
	can_be_in_squad = FALSE

	announced = FALSE

	equip(var/mob/living/carbon/human/H)
		var/current_name = H.real_name
		..()
		H.fully_replace_character_name("Sniper [current_name]")
		H.say(";Sniper reporting for duty!")

/datum/job/soldier/blue_soldier/flame_trooper
	title = "Blue Flame Trooper"
	total_positions = 0
	outfit_type = /decl/hierarchy/outfit/job/bluesoldier/flamer
	auto_rifle_skill = 8
	semi_rifle_skill = 8
	sniper_skill = 3
	shotgun_skill = 3
	boltie_skill = 3
	lmg_skill = 3
	smg_skill = 3
	can_be_in_squad = FALSE
	open_when_dead = FALSE

	announced = FALSE

	equip(var/mob/living/carbon/human/H)
		var/current_name = H.real_name
		..()
		H.fully_replace_character_name("FT. [current_name]")
		H.add_stats(18, rand(10,16), rand(15,18))
		H.say(";Flame Trooper reporting for duty!")
		H.unlock_achievement(new/datum/achievement/flamer())

/datum/job/soldier/blue_soldier/sentry
	title = "Blue Sentry"
	total_positions = 0
	outfit_type = /decl/hierarchy/outfit/job/bluesoldier/sentry
	auto_rifle_skill = 5
	semi_rifle_skill = 5
	sniper_skill = 3
	shotgun_skill = 3
	lmg_skill = 10
	smg_skill = 3
	boltie_skill = 3
	can_be_in_squad = FALSE
	open_when_dead = TRUE

	announced = FALSE

	equip(var/mob/living/carbon/human/H)
		var/current_name = H.real_name
		..()
		H.fully_replace_character_name("Sentry [current_name]")
		H.add_stats(18, rand(10,16), rand(15,18))
		H.say(";Sentry reporting for duty!")



/datum/job/soldier/blue_soldier/captain
	title = "Blue Captain"
	total_positions = 1
	req_admin_notify = TRUE
	social_class = SOCIAL_CLASS_HIGH
	outfit_type = /decl/hierarchy/outfit/job/bluesoldier/leader
	can_be_in_squad = FALSE //They're above all the squads.
	sniper_skill = 10
	open_when_dead = TRUE

	announced = FALSE

	equip(var/mob/living/carbon/human/H)
		var/current_name = H.real_name
		..()
		H.fully_replace_character_name("Cpt. [current_name]")
		H.get_idcard()?.access = get_all_accesses()
		var/obj/O = H.get_equipped_item(slot_s_store)
		if(O)
			qdel(O)
		H.verbs += list(
			/mob/living/carbon/human/proc/help_me,
			/mob/living/carbon/human/proc/retreat,
			/mob/living/carbon/human/proc/announce,
			/mob/living/carbon/human/proc/give_order,
			/mob/living/carbon/human/proc/check_reinforcements
		)
		H.voice_in_head(pick(GLOB.lone_thoughts))
		to_chat(H, "<b>Artillery Password</b>: [GLOB.cargo_password]")
		H.mind.store_memory("<b>Artillery Password</b>: [GLOB.cargo_password]")
		H.say(";[H.real_name] [pick("taking","in")] command!")

/datum/job/soldier/blue_soldier/scout
	title = "Blue Scavenger"
	total_positions = -1
	outfit_type = /decl/hierarchy/outfit/job/bluesoldier/scout
	child_role = TRUE
	can_be_in_squad = FALSE
	//Kids suck at everything.
	specific_skill = TRUE
	medical_skill = 1
	surgery_skill = 1
	ranged_skill = 1
	engineering_skill = 1
	melee_skill = 1
	auto_rifle_skill = 1
	semi_rifle_skill = 1
	sniper_skill = 1
	shotgun_skill = 1
	lmg_skill = 1
	smg_skill = 1

	announced = FALSE

	equip(mob/living/carbon/human/H)
		var/current_name = H.real_name
		..()
		H.fast_stripper = TRUE
		H.add_stats(rand(3,6), rand(12,16), rand(6,9))
		qdel(H.get_equipped_item(slot_s_store))  // they cant even handle guns
		H.fully_replace_character_name("Scav. [current_name]")
		H.set_trait(new/datum/trait/child())
		H.say(";Scav reporting for duty!")

/decl/hierarchy/outfit/job/bluesoldier
	name = OUTFIT_JOB_NAME("Blue Soldier")
	head = /obj/item/clothing/head/helmet/bluehelmet
	uniform = /obj/item/clothing/under/blue_uniform
	back = /obj/item/storage/backpack/satchel/warfare
	shoes = /obj/item/clothing/shoes/jackboots
	l_ear = null
	l_pocket = /obj/item/storage/box/ifak
	suit = /obj/item/clothing/suit/armor/bluecoat
	gloves = /obj/item/clothing/gloves/thick/swat/combat/warfare
	neck = /obj/item/reagent_containers/food/drinks/canteen
	pda_type = null
	id_type = /obj/item/card/id/dog_tag/blue
	flags = OUTFIT_NO_BACKPACK|OUTFIT_NO_SURVIVAL_GEAR


/decl/hierarchy/outfit/job/bluesoldier/soldier/equip()
	if(aspect_chosen(/datum/aspect/lone_rider))
		suit_store = /obj/item/gun/projectile/shotgun/pump/boltaction/shitty/leverchester
		r_pocket = /obj/item/ammo_box/rifle
		backpack_contents = initial(backpack_contents)
		belt = null

	else if (prob(5))
		suit_store = /obj/item/gun/projectile/automatic/m22/warmonger/m14/battlerifle/rsc
		r_pocket =  /obj/item/ammo_magazine/a762/rsc
		backpack_contents = list(/obj/item/grenade/smokebomb = 1)
		belt = /obj/item/storage/belt/armageddon

	else if(prob(25))
		suit_store = /obj/item/gun/projectile/shotgun/pump/boltaction/shitty/leverchester
		r_pocket = /obj/item/ammo_box/rifle
		backpack_contents = list(/obj/item/grenade/smokebomb = 1)
		belt = null

	else if(prob(50))
		suit_store = /obj/item/gun/projectile/shotgun/pump/boltaction/shitty/bayonet
		r_pocket = /obj/item/ammo_box/rifle
		backpack_contents = list(/obj/item/grenade/smokebomb = 1)
		belt = null

	else
		suit_store = /obj/item/gun/projectile/shotgun/pump/boltaction/shitty
		r_pocket = /obj/item/ammo_box/rifle
		backpack_contents = list(/obj/item/grenade/smokebomb = 1)
		belt = null

	if(aspect_chosen(/datum/aspect/somme))
		belt = /obj/item/shovel
	if(aspect_chosen(/datum/aspect/nightfare))
		backpack_contents += list(/obj/item/torch/self_lit = 1, /obj/item/ammo_box/flares/blue = 1)
	if(aspect_chosen(/datum/aspect/trenchmas))
		backpack_contents += list(/obj/item/gift/warfare = 1)
	..()


/decl/hierarchy/outfit/job/bluesoldier/sgt
	head = /obj/item/clothing/head/helmet/bluehelmet/leader
	suit_store = /obj/item/gun/projectile/automatic/m22/warmonger
	r_pocket = /obj/item/ammo_magazine/c45rifle/akarabiner

/decl/hierarchy/outfit/job/bluesoldier/sgt/equip()
	if(prob(25))
		suit_store = /obj/item/gun/projectile/shotgun/pump/boltaction/shitty/bayonet
		r_pocket = /obj/item/ammo_box/rifle
		backpack_contents = list(/obj/item/grenade/smokebomb = 1, /obj/item/device/binoculars = 1)
		belt = null
	else
		suit_store = /obj/item/gun/projectile/automatic/m22/warmonger/m14/battlerifle/rsc
		r_pocket =  /obj/item/ammo_magazine/a762/rsc
		backpack_contents = list(/obj/item/grenade/smokebomb = 1, /obj/item/device/binoculars = 1)
		belt = /obj/item/storage/belt/armageddon

	if(aspect_chosen(/datum/aspect/nightfare))
		backpack_contents += list(/obj/item/torch/self_lit = 1, /obj/item/ammo_box/flares/blue = 1)
	if(aspect_chosen(/datum/aspect/trenchmas))
		backpack_contents += list(/obj/item/gift/warfare = 1)
	..()

/decl/hierarchy/outfit/job/bluesoldier/engineer
	r_pocket = /obj/item/ammo_magazine/mc9mmt/machinepistol
	l_pocket = /obj/item/wirecutters
	suit_store = /obj/item/gun/projectile/automatic/machinepistol
	back = /obj/item/storage/backpack/warfare
	backpack_contents = list(/obj/item/stack/barbwire = 1, /obj/item/shovel = 1, /obj/item/defensive_barrier = 4, /obj/item/storage/box/ifak = 1)

/decl/hierarchy/outfit/job/bluesoldier/engineer/equip()
	if(prob(1))//Rare engineer spawn
		suit_store = /obj/item/gun/projectile/automatic/autoshotty
		r_pocket = /obj/item/shovel
		belt = /obj/item/storage/belt/autoshotty
		backpack_contents = list(/obj/item/stack/barbwire = 1, /obj/item/defensive_barrier = 3, /obj/item/storage/box/ifak = 1, /obj/item/grenade/smokebomb = 1)
	else //if(prob(50))
		suit_store = /obj/item/gun/projectile/shotgun/pump/shitty
		r_pocket = /obj/item/ammo_box/shotgun
		belt = /obj/item/shovel
		backpack_contents = list(/obj/item/stack/barbwire = 1, /obj/item/defensive_barrier = 3, /obj/item/storage/box/ifak = 1, /obj/item/grenade/smokebomb = 1)
	/*
	else
		suit_store = /obj/item/gun/projectile/automatic/machinepistol
		r_pocket = /obj/item/shovel
		belt = /obj/item/storage/belt/warfare
		backpack_contents = list(/obj/item/stack/barbwire = 1, /obj/item/defensive_barrier = 3, /obj/item/storage/box/ifak = 1, /obj/item/grenade/smokebomb = 1)
	*/
	if(aspect_chosen(/datum/aspect/somme))
		suit_store = /obj/item/gun/projectile/shotgun/pump/shitty
		r_pocket = /obj/item/ammo_box/shotgun
		belt = /obj/item/shovel
		backpack_contents = list(/obj/item/stack/barbwire = 1, /obj/item/defensive_barrier = 3, /obj/item/storage/box/ifak = 1, /obj/item/grenade/smokebomb = 1)
	if(aspect_chosen(/datum/aspect/nightfare))
		backpack_contents += list(/obj/item/ammo_box/flares/blue = 1, /obj/item/torch/self_lit = 1)
	if(aspect_chosen(/datum/aspect/trenchmas))
		backpack_contents += list(/obj/item/gift/warfare = 1)
	..()


/decl/hierarchy/outfit/job/bluesoldier/medic
	belt = /obj/item/storage/belt/medical/full
	r_pocket = /obj/item/ammo_magazine/c45rifle/akarabiner
	l_pocket = /obj/item/stack/medical/bruise_pack
	suit_store = /obj/item/gun/projectile/automatic/m22/warmonger
	gloves = /obj/item/clothing/gloves/latex
	head = /obj/item/clothing/head/helmet/bluehelmet/medic

/decl/hierarchy/outfit/job/bluesoldier/medic/equip()
	if(prob(50))
		suit_store = /obj/item/gun/projectile/automatic/m22/warmonger
		r_pocket = /obj/item/ammo_magazine/c45rifle/akarabiner
		backpack_contents = list(/obj/item/ammo_magazine/c45rifle/akarabiner = 3, /obj/item/grenade/smokebomb = 1)

	else
		suit_store = /obj/item/gun/projectile/shotgun/pump/boltaction/shitty/bayonet
		r_pocket = /obj/item/ammo_box/rifle
		backpack_contents = list(/obj/item/grenade/smokebomb = 1)
	if(aspect_chosen(/datum/aspect/nightfare))
		backpack_contents += list(/obj/item/ammo_box/flares/blue = 1, /obj/item/torch/self_lit = 1)
	if(aspect_chosen(/datum/aspect/trenchmas))
		backpack_contents += list(/obj/item/gift/warfare = 1)
	..()

/decl/hierarchy/outfit/job/bluesoldier/sniper
	l_ear = /obj/item/device/radio/headset/blue_team/all
	suit = /obj/item/clothing/suit/armor/bluecoat/sniper
	head = /obj/item/clothing/head/helmet/bluehelmet/sniper
	suit_store = /obj/item/gun/projectile/heavysniper
	belt = /obj/item/gun/projectile/revolver //Backup weapon.
	r_pocket = /obj/item/ammo_box/ptsd
	backpack_contents = list(/obj/item/grenade/smokebomb = 1)

/decl/hierarchy/outfit/job/bluesoldier/sniper/equip()
	if(prob(50))
		belt = /obj/item/gun/projectile/warfare
	else
		belt = /obj/item/gun/projectile/revolver
	if(aspect_chosen(/datum/aspect/nightfare))
		backpack_contents += list(/obj/item/ammo_box/flares/blue = 1, /obj/item/torch/self_lit = 1)
	if(aspect_chosen(/datum/aspect/trenchmas))
		backpack_contents += list(/obj/item/gift/warfare = 1)
	..()

/decl/hierarchy/outfit/job/bluesoldier/flamer
	l_ear = /obj/item/device/radio/headset/blue_team/all
	suit = /obj/item/clothing/suit/fire/blue
	head = /obj/item/clothing/head/helmet/bluehelmet/fire
	belt = /obj/item/gun/projectile/automatic/flamer
	suit_store = /obj/item/melee/trench_axe
	r_pocket = /obj/item/grenade/fire
	backpack_contents = list(/obj/item/ammo_magazine/flamer = 4, /obj/item/grenade/smokebomb = 1)

/decl/hierarchy/outfit/job/bluesoldier/sentry
	l_ear = /obj/item/device/radio/headset/blue_team/all
	suit = /obj/item/clothing/suit/armor/sentry/blue
	head = /obj/item/clothing/head/helmet/sentryhelm/blue
	belt = /obj/item/melee/trench_axe
	suit_store = /obj/item/gun/projectile/automatic/mg08
	backpack_contents = list(/obj/item/ammo_magazine/box/a556/mg08 = 3, /obj/item/grenade/smokebomb = 1)

/decl/hierarchy/outfit/job/bluesoldier/sentry/equip()
	if(aspect_chosen(/datum/aspect/nightfare))
		backpack_contents += list(/obj/item/torch/self_lit = 1)
		belt = /obj/item/ammo_box/flares/blue
	if(aspect_chosen(/datum/aspect/trenchmas))
		backpack_contents += list(/obj/item/gift/warfare = 1)
	..()

/decl/hierarchy/outfit/job/bluesoldier/leader
	glasses = /obj/item/clothing/glasses/sunglasses
	suit = /obj/item/clothing/suit/armor/bluecoat/leader
	head = /obj/item/clothing/head/warfare_officer/blueofficer
	l_ear = /obj/item/device/radio/headset/blue_team/all
	belt = /obj/item/gun/projectile/revolver/cpt
	r_pocket = /obj/item/device/binoculars
	backpack_contents = list(/obj/item/ammo_magazine/handful/revolver = 2, /obj/item/grenade/smokebomb = 1)

/decl/hierarchy/outfit/job/bluesoldier/leader/equip()
	if(aspect_chosen(/datum/aspect/nightfare))
		backpack_contents += list(/obj/item/ammo_box/flares/blue = 1 , /obj/item/torch/self_lit = 1)
	if(aspect_chosen(/datum/aspect/trenchmas))
		backpack_contents += list(/obj/item/gift/warfare = 1)
	..()

/decl/hierarchy/outfit/job/bluesoldier/scout
	suit = /obj/item/clothing/suit/child_coat/blue
	l_ear = /obj/item/device/radio/headset/blue_team/all
	uniform = /obj/item/clothing/under/child_jumpsuit/warfare/blue
	shoes = /obj/item/clothing/shoes/child_shoes
	gloves = null
	r_pocket = /obj/item/device/binoculars
	backpack_contents = list(/obj/item/grenade/smokebomb = 1)

/decl/hierarchy/outfit/job/bluesoldier/scout/equip()
	if(aspect_chosen(/datum/aspect/nightfare))
		backpack_contents += list(/obj/item/torch/self_lit = 1)
		belt = /obj/item/ammo_box/flares/blue
	if(aspect_chosen(/datum/aspect/trenchmas))
		backpack_contents += list(/obj/item/gift/warfare = 1)
	..()
