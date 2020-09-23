/datum/job/fortress/red
	title = "Red Fortress Inhabitant"
	is_red_team = TRUE
	selection_color = "#b27676"

	equip(var/mob/living/carbon/human/H)
		H.warfare_faction = RED_TEAM
		..()
		SSwarfare.red.team += H
		H.add_stats(rand(6,10), rand(6,10), rand(6,10))
		H.warfare_language_shit(LANGUAGE_RED)
		H.assign_random_quirk()

/datum/job/fortress/red/chef
	title = "Red Chef"
	outfit_type = /decl/hierarchy/outfit/job/service/chef/red
	access = list(access_hydroponics, access_bar, access_kitchen)
	total_positions = 2
	social_class = SOCIAL_CLASS_MED

	equip(var/mob/living/carbon/human/H)
		..()
		H.add_stats(rand(7,11), rand(7,12), rand(7,11), rand(10,15))
		H.add_skills(rand(4,6), rand(0,2), 0, rand(0,3))

/decl/hierarchy/outfit/job/service/chef/red
	back = /obj/item/storage/backpack/satchel
	l_ear = /obj/item/device/radio/headset/syndicate
	neck = /obj/item/reagent_containers/food/drinks/canteen


/datum/job/fortress/red/practitioner
	title = "Red Practitioner"
	outfit_type = /decl/hierarchy/outfit/job/medical/doctor/red
	access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_chemistry, access_virology, access_genetics)
	total_positions = -1
	social_class = SOCIAL_CLASS_MED
	medical_skill = 10
	surgery_skill = 10
	ranged_skill = 0
	engineering_skill = 0
	melee_skill = 0
	auto_rifle_skill = 0
	semi_rifle_skill = 0
	sniper_skill = 0
	shotgun_skill = 0
	lmg_skill = 0
	smg_skill = 0

	equip(var/mob/living/carbon/human/H)
		..()
		H.set_trait(new/datum/trait/death_tolerant())
		H.add_stats(rand(8,11), rand(5,8), rand(5,7), rand(10,14))
		H.fully_replace_character_name("Prac. [H.real_name]")
		H.say(";Practitioner reporting for duty!")

/decl/hierarchy/outfit/job/medical/doctor/red
	uniform = /obj/item/clothing/under/red_uniform
	back = /obj/item/storage/backpack/satchel/warfare
	gloves = /obj/item/clothing/gloves/prac_gloves
	suit = /obj/item/clothing/suit/prac_arpon
	mask = /obj/item/clothing/mask/gas/prac_mask
	shoes = /obj/item/clothing/shoes/prac_boots
	l_ear = /obj/item/device/radio/headset/syndicate
	neck = /obj/item/reagent_containers/food/drinks/canteen
	belt = /obj/item/storage/belt/medical/full
	pda_type = null
	id_type = /obj/item/card/id/dog_tag/red
	backpack_contents = list(/obj/item/ammo_magazine/handful/revolver = 1, /obj/item/gun/projectile/revolver = 1)
