/obj/item/clothing/head/helmet/hard_had
	name = "Mining Helmet"
	desc = "Protects you head from rocks and other hazards."
	icon_state = "hardhat"


/obj/item/clothing/head/helmet/sentryhelm
	name = "Sentry Helmet"
	desc = "Used for taking blows to the noggin without getting hurt."
	armor = list(melee = 75, bullet = 75, laser = 55, energy = 40, bomb = 50, bio = 10, rad = 0)//proteck ya neck
	str_requirement = 18


/obj/item/clothing/suit/armor/sentry
	name = "Sentry Armor"
	desc = "Protects you very well from getting smacked, and decently well from getting shot."
	armor = list(melee = 75, bullet = 75, laser = 55, energy = 40, bomb = 50, bio = 10, rad = 0)//Beefy boys.
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	cold_protection = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	str_requirement = 18


/obj/item/clothing/suit/child_coat
	name = "scav coat"
	desc = "Fitted just for scavs."
	icon_state = "child_redcoat"
	can_be_worn_by_child = TRUE
	child_exclusive = TRUE


/obj/item/clothing/suit/child_coat/red
	icon_state = "child_redcoat"
	warfare_team = RED_TEAM

/obj/item/clothing/suit/child_coat/blue
	icon_state = "child_bluecoat"
	warfare_team = BLUE_TEAM


/obj/item/clothing/suit/fire/red
	name = "Redcoats Firesuit"
	icon_state = "redfiresuit"
	warfare_team = RED_TEAM
	cold_protection = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	str_requirement = 18
	flags_inv = null //HIDEJUMPSUIT|HIDETAIL

/obj/item/clothing/suit/fire/blue
	name = "Bluecoats Firesuit"
	icon_state = "bluefiresuit"
	warfare_team = BLUE_TEAM
	cold_protection = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	str_requirement = 18
	flags_inv = null //HIDEJUMPSUIT|HIDETAIL


/obj/item/clothing/head/helmet/redhelmet/fire
	str_requirement = 18
	icon_state = "redfirehelmet"

/obj/item/clothing/head/helmet/bluehelmet/fire
	str_requirement = 18
	icon_state = "bluefirehelmet"


/obj/item/clothing/under/child_jumpsuit/warfare
	name = "scavengers's clothing"
	desc = "A proper uniform worn by child scavengers."
	icon_state = "urchin"
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS//So they don't freeze to death with their clothes on.
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE

/obj/item/clothing/under/child_jumpsuit/warfare/red
	warfare_team = RED_TEAM
	icon_state = "red_child_uniform"

/obj/item/clothing/under/child_jumpsuit/warfare/blue
	warfare_team = BLUE_TEAM
	icon_state = "blue_child_uniform"

//Red shit
/obj/item/clothing/suit/armor/redcoat
	name = "Red Team's jacket"
	desc = "The proud jacket of the Red Baron!"
	icon_state = "redcoat"
	warfare_team = RED_TEAM
	allowed = list(/obj/item/ammo_magazine,/obj/item/ammo_casing)
	starting_accessories = list(/obj/item/clothing/accessory/red_outline)
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE

/obj/item/clothing/suit/armor/redcoat/New()
	..()
	name = "The [RED_TEAM]'s jacket"
	desc = "The proud jacket of the [RED_TEAM]."

/obj/item/clothing/suit/armor/sentry/red
	name = "Red Sentry Armor"
	icon_state = "redsentryarmor"
	warfare_team = RED_TEAM

/obj/item/clothing/head/helmet/sentryhelm/red
	name = "Red Sentry Helmet"
	icon_state = "redsentryhelmet"
	item_state = "redsentryhelmet"
	warfare_team = RED_TEAM

/obj/item/clothing/under/red_uniform
	name = "Red's uniform"
	desc = "It's not the best. But it's not the worst."
	icon_state = "reduni"
	worn_state = "reduni"
	item_state = "reduni"
	warfare_team = RED_TEAM


/obj/item/clothing/suit/armor/redcoat/leader
	icon_state = "redcoat_leader"

/obj/item/clothing/suit/armor/redcoat/medic
	icon_state = "redcoat_medic"
	item_state = "redcoat_medic"

/obj/item/clothing/suit/armor/redcoat/sniper
	icon_state = "redcoat_sniper"
	item_state = "redcoat_sniper"

/obj/item/clothing/head/warfare_officer/redofficer
	name = "Red Officer\'s Cap"
	desc = "Fit for an officer of just your ranking. And nothing more."
	icon_state = "redoffcap"
	item_state = "redoffcap"
	warfare_team = RED_TEAM
	cold_protection = HEAD
	min_cold_protection_temperature = HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	body_parts_covered = HEAD

/obj/item/clothing/head/redcoat/redgarrisoncap
	name = "Red Garrison Cap"
	icon_state = "redgarrisoncap"
	item_state = "redgarrisoncap"
	warfare_team = RED_TEAM

/obj/item/clothing/head/redcoat/redsargecap
	name = "Red Garrison Cap"
	icon_state = "redsargecap"
	item_state = "redsargecap"
	warfare_team = RED_TEAM

/obj/item/clothing/head/redcoat/redmedicalcap
	name = "Red Garrison Cap"
	icon_state = "redmedicalcap"
	item_state = "redmedicalcap"
	warfare_team = RED_TEAM

/obj/item/clothing/head/redcoat/rednursehat
	name = "Red Nurse Hat"
	icon_state = "rednursehat"
	item_state = "rednursehat"
	warfare_team = RED_TEAM

/obj/item/clothing/head/helmet/redhelmet
	name = "Red's Helmet"
	desc = "Sometimes protects your head from bullets and blows."
	icon_state = "redhelmet"
	warfare_team = RED_TEAM

/obj/item/clothing/head/helmet/redhelmet/medic
	icon_state = "redhelmet_medic"

/obj/item/clothing/head/helmet/redhelmet/leader
	icon_state = "redhelmet_leader"

/obj/item/clothing/head/helmet/redhelmet/sniper
	icon_state = "redsniperhelmet"
	item_state = "redsniperhelmet"


//Nam shit
/obj/item/clothing/suit/armor/redcoat/nam
	icon_state = "redsuit"

/obj/item/clothing/suit/armor/redcoat/leader/nam
	icon_state = "redsuit_leader"

/obj/item/clothing/suit/armor/redcoat/medic/nam
	icon_state = "redsuit_medic"

/obj/item/clothing/head/helmet/redhelmet/nam
	desc = "Sometimes protects your head from bullets and blows."
	icon_state = "redhelmnam"

/obj/item/clothing/head/helmet/redhelmet/leader/nam
	icon_state = "redhelmnam_leader"

/obj/item/clothing/head/helmet/redhelmet/medic/nam
	icon_state = "redhelmnam_medic"

/obj/item/clothing/mask/gas/nam
	icon_state = "redmask"
	item_state = "redmask"


/obj/item/clothing/gloves/thick/swat/combat/nam
	icon_state = "namgloves"
	item_state = "namgloves"

/obj/item/clothing/gloves/thick/swat/combat/warfare
	icon_state = "warfare_gloves"
	item_state = "warfare_gloves"


//Blue shit
/obj/item/clothing/suit/armor/bluecoat
	name = "Blue Team's jacket"
	desc = "The proud jacket of the Bluecoats!"
	icon_state = "bluecoat"
	warfare_team = BLUE_TEAM
	allowed = list(/obj/item/ammo_magazine,/obj/item/ammo_casing)
	starting_accessories = list(/obj/item/clothing/accessory/blue_outline)
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE

/obj/item/clothing/suit/armor/bluecoat/New()
	..()
	name = "The [BLUE_TEAM]'s jacket"
	desc = "The proud jacket of the [BLUE_TEAM]."

/obj/item/clothing/suit/armor/sentry/blue
	warfare_team = BLUE_TEAM
	name = "Blue Sentry Armor"
	icon_state = "bluesentryarmor"

/obj/item/clothing/head/helmet/sentryhelm/blue
	warfare_team = BLUE_TEAM
	name = "Blue Sentry Helmet"
	icon_state = "bluesentryhelmet"
	item_state = "bluesentryhelmet"

/obj/item/clothing/suit/armor/bluecoat/leader
	icon_state = "bluecoat_leader"

/obj/item/clothing/suit/armor/bluecoat/medic
	icon_state = "bluecoat_medic"
	item_state = "bluecoat_medic"

/obj/item/clothing/suit/armor/bluecoat/sniper
	icon_state = "bluecoat_sniper"
	item_state = "bluecoat_sniper"

//Uniform.
/obj/item/clothing/under/blue_uniform
	name = "Blue's uniform"
	desc = "It's not the best, but it's not the worst."
	icon_state = "blueuni"
	worn_state = "blueuni"
	item_state = "blueuni"

//Hats
/obj/item/clothing/head/warfare_officer/blueofficer
	name = "Blue Officer\'s Cap"
	desc = "Fit for an officer of just your ranking. And nothing more."
	icon_state = "blueoffcap"
	item_state = "blueoffcap"
	warfare_team = BLUE_TEAM
	cold_protection = HEAD
	min_cold_protection_temperature = HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	body_parts_covered = HEAD

/obj/item/clothing/head/bluecoat/bluegarrisoncap
	name = "Blue Garrison Cap"
	icon_state = "bluegarrisoncap"
	item_state = "bluegarrisoncap"
	warfare_team = BLUE_TEAM

/obj/item/clothing/head/bluecoat/bluesargecap
	name = "Blue Garrison Cap"
	icon_state = "bluesargecap"
	item_state = "bluesargecap"
	warfare_team = BLUE_TEAM

/obj/item/clothing/head/bluecoat/bluemedicalcap
	name = "Blue Garrison Cap"
	icon_state = "bluemedicalcap"
	item_state = "bluemedicalcap"
	warfare_team = BLUE_TEAM

/obj/item/clothing/head/bluecoat/bluenursehat
	name = "Blue Nurse Hat"
	icon_state = "bluenursehat"
	item_state = "bluenursehat"
	warfare_team = BLUE_TEAM

//Helmets
/obj/item/clothing/head/helmet/bluehelmet
	name = "Blue's Helmet"
	desc = "Sometimes protects your head from bullets and blows."
	icon_state = "bluehelmet"
	warfare_team = BLUE_TEAM

/obj/item/clothing/head/helmet/bluehelmet/medic
	icon_state = "bluehelmet_medic"

/obj/item/clothing/head/helmet/bluehelmet/leader
	icon_state = "bluehelmet_leader"

/obj/item/clothing/head/helmet/bluehelmet/sniper
	icon_state = "bluesniperhelmet"
	item_state = "bluesniperhelmet"

/obj/item/card/id/dog_tag
	var/warfare_faction = null
	icon_state = "dogtag"
	desc = "A metal dog tag. Functions like an ID."

/obj/item/card/id/dog_tag/red
	warfare_faction = RED_TEAM
	icon_state = "tagred"

/obj/item/card/id/dog_tag/blue
	warfare_faction = BLUE_TEAM
	icon_state = "tagblue"

/obj/item/card/id/dog_tag/update_name()
	var/final_name = "[registered_name]'s Dog Tag"
	if(military_rank && military_rank.name_short)
		final_name = military_rank.name_short + " " + final_name
	if(assignment)
		final_name = final_name + " ([assignment])"
	SetName(final_name)


/obj/item/device/radio/headset/red_team
	name = "Red Headset"
	origin_tech = list(TECH_ILLEGAL = 3)
	syndie = 1
	ks1type = /obj/item/device/encryptionkey/red

/obj/item/device/radio/headset/red_team/Initialize()
	. = ..()
	set_frequency(RED_FREQ)

/obj/item/device/radio/headset/red_team/sl_alpha
	ks1type = /obj/item/device/encryptionkey/redsl_alpha

/obj/item/device/radio/headset/red_team/sl_bravo
	ks1type = /obj/item/device/encryptionkey/redsl_bravo

/obj/item/device/radio/headset/red_team/sl_charlie
	ks1type = /obj/item/device/encryptionkey/redsl_charlie

/obj/item/device/radio/headset/red_team/sl_delta
	ks1type = /obj/item/device/encryptionkey/redsl_delta

/obj/item/device/radio/headset/red_team/all
	ks1type = /obj/item/device/encryptionkey/red_all

/obj/item/device/radio/headset/red_team/alpha
	ks1type = /obj/item/device/encryptionkey/red_alpha

	Initialize()
		. = ..()
		set_frequency(RED_ALPHA)

/obj/item/device/radio/headset/red_team/bravo
	ks1type = /obj/item/device/encryptionkey/red_bravo

	Initialize()
		. = ..()
		set_frequency(RED_BRAVO)

/obj/item/device/radio/headset/red_team/charlie
	ks1type = /obj/item/device/encryptionkey/red_charlie

	Initialize()
		. = ..()
		set_frequency(RED_CHARLIE)

/obj/item/device/radio/headset/red_team/delta
	ks1type = /obj/item/device/encryptionkey/red_delta

	Initialize()
		. = ..()
		set_frequency(RED_DELTA)




/obj/item/device/radio/headset/blue_team
	name = "Blue Headset"
	origin_tech = list(TECH_ILLEGAL = 2)
	syndie = 1
	ks1type = /obj/item/device/encryptionkey/blue

/obj/item/device/radio/headset/blue_team/Initialize()
	. = ..()
	set_frequency(BLUE_FREQ)


/obj/item/device/radio/headset/blue_team/sl_alpha
	ks1type = /obj/item/device/encryptionkey/bluesl_alpha

/obj/item/device/radio/headset/blue_team/sl_bravo
	ks1type = /obj/item/device/encryptionkey/bluesl_bravo

/obj/item/device/radio/headset/blue_team/sl_charlie
	ks1type = /obj/item/device/encryptionkey/bluesl_charlie

/obj/item/device/radio/headset/blue_team/sl_delta
	ks1type = /obj/item/device/encryptionkey/bluesl_delta

/obj/item/device/radio/headset/blue_team/all
	ks1type = /obj/item/device/encryptionkey/blue_all

/obj/item/device/radio/headset/blue_team/alpha
	ks1type = /obj/item/device/encryptionkey/blue_alpha

	Initialize()
		. = ..()
		set_frequency(BLUE_ALPHA)

/obj/item/device/radio/headset/blue_team/bravo
	ks1type = /obj/item/device/encryptionkey/blue_bravo

	Initialize()
		. = ..()
		set_frequency(BLUE_BRAVO)

/obj/item/device/radio/headset/blue_team/charlie
	ks1type = /obj/item/device/encryptionkey/blue_charlie

	Initialize()
		. = ..()
		set_frequency(BLUE_CHARLIE)

/obj/item/device/radio/headset/blue_team/delta
	ks1type = /obj/item/device/encryptionkey/blue_delta

	Initialize()
		. = ..()
		set_frequency(BLUE_DELTA)


/obj/item/melee/trench_axe
	name = "trench axe"
	desc = "Used mainly for murdering those on the enemy side."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "trenchaxe"
	item_state = "trenchaxe"
	wielded_icon = "trenchaxe-w"
	slot_flags = SLOT_BELT|SLOT_BACK|SLOT_S_STORE
	force = 20
	block_chance = 20
	sharp = TRUE
	edge = TRUE
	hitsound = "slash_sound"
	drop_sound = 'sound/items/handle/axe_drop.ogg'
	equipsound = 'sound/items/equip/axe_equip.ogg'
	grab_sound = 'sound/items/handle/axe_grab.ogg'
	grab_sound_is_loud = TRUE




/obj/item/clothing/suit/prac_arpon
	name = "practioner robes"
	desc = "Worn by practioners and other surgoens."
	icon_state = "prac_robes"
	item_state = "prac_robes"
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE

/obj/item/clothing/mask/gas/prac_mask
	name = "practioner mask"
	desc = "Keeps all that blood off your face."
	icon_state = "prac_mask"
	item_state = "prac_mask"
	flags_inv = HIDEEARS|HIDEEYES|HIDEFACE|BLOCKHAIR
	body_parts_covered = FACE|EYES|HEAD

/obj/item/clothing/shoes/prac_boots
	name = "practioner boots"
	desc = "Squish."
	icon_state = "prac_boots"
	item_state = "prac_boots"

/obj/item/clothing/gloves/prac_gloves
	name = "practioner gloves"
	desc = "Now you can grope the dead without worrying about what you're contracting."
	icon_state = "prac_gloves"
	item_state = "prac_gloves"

/obj/item/clothing/head/prac_cap
	name = "practioner cap"
	desc = "Wouldn't want your hair to get messy now would we."
	icon_state = "prac_cap"
	item_state = "prac_cap"
	flags_inv = BLOCKHEADHAIR


/obj/item/clothing/accessory/red_outline
	icon_state = "red_outline"
	high_visibility = FALSE

/obj/item/clothing/accessory/blue_outline
	icon_state = "blue_outline"
	high_visibility = FALSE

/obj/item/clothing/accessory/armband/alpha
	icon_state = "alpha_patch"
	high_visibility = FALSE

/obj/item/clothing/accessory/armband/bravo
	icon_state = "bravo_patch"
	high_visibility = FALSE

/obj/item/clothing/accessory/armband/charlie
	icon_state = "charlie_patch"
	high_visibility = FALSE

/obj/item/clothing/accessory/medal/medical
	name = "medical patch"
	icon_state = "medic_patch"
	overlay_state = "medic_patch"
	high_visibility = FALSE

/obj/item/clothing/accessory/helm_patch
	slot = ACCESSORY_SLOT_HELM_C

/obj/item/clothing/accessory/helm_patch/medic
	icon_state = "medical_helmet_patch"
	overlay_state = "medical_helmet_patch"

/obj/item/clothing/accessory/helm_patch/leader
	icon_state = "leader_patch_helm"
	overlay_state = "leader_patch_helm"


/obj/item/storage/belt/warfare
	name = "ammo belt"
	desc = "Great for holding ammo! This one starts with smg ammo."
	icon_state = "warfare_belt"
	item_state = "warfare_belt"
	can_hold = list(
		/obj/item/ammo_magazine,
		)

	New()
		..()
		new /obj/item/ammo_magazine/mc9mmt/machinepistol(src)
		new /obj/item/ammo_magazine/mc9mmt/machinepistol(src)
		new /obj/item/ammo_magazine/mc9mmt/machinepistol(src)
		new /obj/item/ammo_magazine/mc9mmt/machinepistol(src)

/obj/item/storage/belt/armageddon
	name = "ammo belt"
	desc = "Great for holding ammo! This one starts with Armageddon ammo."
	icon_state = "warfare_belt"
	item_state = "warfare_belt"
	can_hold = list(
		/obj/item/ammo_magazine,
		)

	New()
		..()
		new /obj/item/ammo_magazine/a762/rsc(src)
		new /obj/item/ammo_magazine/a762/rsc(src)
		new /obj/item/ammo_magazine/a762/rsc(src)
		new /obj/item/ammo_magazine/a762/rsc(src)

/obj/item/storage/belt/warfare/chestrig
	name = "Chestrig"
	desc = "Holds ammo. But not much else."
	icon_state = "chestrig"

/obj/item/storage/belt/autoshotty
	name = "ammo belt"
	desc = "Great for holding ammo! This one starts with Warcrime ammo."
	icon_state = "warfare_belt"
	item_state = "warfare_belt"
	can_hold = list(
		/obj/item/ammo_magazine,
		)
	New()
		..()
		new /obj/item/ammo_magazine/autoshotty(src)
		new /obj/item/ammo_magazine/autoshotty(src)
		new /obj/item/ammo_magazine/autoshotty(src)
		new /obj/item/ammo_magazine/autoshotty(src)
		new /obj/item/ammo_magazine/autoshotty(src)


/obj/item/storage/belt/autoshotty/chestrig
	name = "Chestrig"
	desc = "Holds ammo. But not much else. This one starts with Warcrime ammo."
	icon_state = "chestrig"

/obj/item/storage/box/ifak
	name = "IFAK"
	desc = "An Individual First Aid Kit, used to keep you alive until a medic can patch you up proper."
	icon_state = "ifak"
	startswith = list(/obj/item/bandage_pack, /obj/item/tourniquet, /obj/item/reagent_containers/hypospray/autoinjector/morphine)
	w_class = ITEM_SIZE_SMALL
	max_storage_space = 6

/obj/item/storage/box/ifak/attack_hand(var/mob/living/carbon/human/user)
	if(!istype(user))
		..()
		return
	if((src != user.r_store) && (src != user.l_store) && (src != user.belt) && (src != user.get_inactive_hand()))
		..()//If it's not in any of these slots then just return normally.
		return
	open(user)//If it's in your pocket then open it.


/obj/item/bandage_pack
	name = "Bandage Pack"
	desc = "Holds a bandage. One time use. You can't put the bandage back don't try."
	icon = 'icons/obj/storage.dmi'
	icon_state = "bandage_pack1"
	w_class = ITEM_SIZE_SMALL
	var/used = FALSE

/obj/item/bandage_pack/attack_self(mob/user)
	. = ..()
	if(used)
		to_chat(user, "<span class='warning'>This one is used up already.</span>")
		return

	var/obj/item/stack/medical/bruise_pack/BP = new(get_turf(src))
	playsound(src, 'sound/effects/rip_pack.ogg', 100)
	user.put_in_inactive_hand(BP)
	used = TRUE
	icon_state = "bandage_pack0"//Yes this could go in update icon, but this is the only time this icon is ever going to change.


/obj/item/tourniquet
	name = "Tourniquet"
	desc = "Use this to stop arteries from bleeding. One time use only."
	icon = 'icons/obj/items.dmi'//TODO: MOVE THIS INTO ANOTHER DMI!
	icon_state = "tourniquet"
	w_class = ITEM_SIZE_SMALL

/obj/item/tourniquet/attack(mob/living/carbon/human/H as mob, mob/living/userr, var/target_zone)//All of this is snowflake and copied and pasted from sutures.
	//Checks if they're human, have a limb, and have the skill to fix it.
	if(!ishuman(H))
		return ..()
	if(!ishuman(userr))
		return ..()

	var/mob/living/carbon/human/user = userr
	var/obj/item/organ/external/affected = H.get_organ(target_zone)

	if(!affected)
		return ..()


	if(!(affected.status & ORGAN_ARTERY_CUT))//There is nothing to fix don't fix anything.
		return

	//Ok all the checks are over let's do the quick fix.
	if(!user.doing_something)
		user.doing_something = TRUE
		if(affected.status & ORGAN_ARTERY_CUT)//Fix arteries.
			user.visible_message("<span class='notice'>[user] to apply the tourniquet to their [affected.name].")
			if(do_mob(user, H, (backwards_skill_scale(user.SKILL_LEVEL(medical)) * 5)))
				user.visible_message("<span class='notice'>[user] has patched the [affected.artery_name] in [H]'s [affected.name] with \the [src.name].</span>", \
				"<span class='notice'>You have patched the [affected.artery_name] in [H]'s [affected.name] with \the [src.name].</span>")
				affected.status &= ~ORGAN_ARTERY_CUT
				playsound(src, 'sound/items/tourniquet.ogg', 70, FALSE)
				qdel(src)
			else
				user.doing_something = FALSE

		affected.update_damages()
		user.doing_something = FALSE
	else
		to_chat(user, "You're already trying to suture them.")


/obj/item/grenade_dud
	name = "Dud"
	desc = "This grenade doesn't look like it'll function properly. Might make a decent club?"
	icon = 'icons/obj/grenade.dmi'
	icon_state = "stick0"
	force = 10
