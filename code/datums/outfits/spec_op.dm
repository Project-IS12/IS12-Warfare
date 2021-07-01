/decl/hierarchy/outfit/spec_op_officer
	name = "Spec Ops - Officer"
	uniform = /obj/item/clothing/under/syndicate/combat
	suit = /obj/item/clothing/suit/armor/swat/officer
	l_ear = /obj/item/device/radio/headset/ert
	glasses = /obj/item/clothing/glasses/thermal/plain/eyepatch
	mask = /obj/item/clothing/mask/smokable/cigarette/cigar/havana
	head = /obj/item/clothing/head/beret/deathsquad
	belt = /obj/item/gun/energy/pulse_rifle/pistol
	back = /obj/item/storage/backpack/satchel
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/thick/combat

	id_slot = slot_wear_id
	id_type = /obj/item/card/id/centcom/ERT
	id_desc = "Special operations ID."
	id_pda_assignment = "Special Operations Officer"

/decl/hierarchy/outfit/spec_op_officer/space
	name = "Spec Ops - Officer in space"
	suit = /obj/item/clothing/suit/space/void/swat
	back = /obj/item/tank/jetpack/oxygen
	mask = /obj/item/clothing/mask/gas/swat

	flags = OUTFIT_HAS_JETPACK|OUTFIT_RESET_EQUIPMENT

/decl/hierarchy/outfit/ert
	name = "Spec Ops - Emergency response team"
	uniform = /obj/item/clothing/under/ert
	shoes = /obj/item/clothing/shoes/swat
	gloves = /obj/item/clothing/gloves/thick/swat
	l_ear = /obj/item/device/radio/headset/ert
	belt = /obj/item/gun/energy/gun
	glasses = /obj/item/clothing/glasses/sunglasses
	back = /obj/item/storage/backpack/satchel

	id_slot = slot_wear_id
	id_type = /obj/item/card/id/centcom/ERT

/decl/hierarchy/outfit/death_command
	name = "Spec Ops - Death commando"

/decl/hierarchy/outfit/death_command/equip(var/mob/living/carbon/human/H)
	deathsquad.equip(H)
	return 1

/decl/hierarchy/outfit/syndicate_command
	name = "Spec Ops - Syndicate commando"

/decl/hierarchy/outfit/syndicate_command/equip(var/mob/living/carbon/human/H)
	commandos.equip(H)
	return 1

/decl/hierarchy/outfit/mercenary
	name = "Spec Ops - Mercenary"
	uniform = /obj/item/clothing/under/syndicate
	shoes = /obj/item/clothing/shoes/combat
	l_ear = /obj/item/device/radio/headset/syndicate
	belt = /obj/item/storage/belt/security
	glasses = /obj/item/clothing/glasses/sunglasses
	gloves = /obj/item/clothing/gloves/thick/swat

	l_pocket = /obj/item/reagent_containers/pill/cyanide

	id_slot = slot_wear_id
	id_type = /obj/item/card/id/syndicate
	id_pda_assignment = "Mercenary"

	flags = OUTFIT_HAS_BACKPACK|OUTFIT_RESET_EQUIPMENT

/decl/hierarchy/outfit/mercenary/syndicate
	name = "Spec Ops - Syndicate"
	suit = /obj/item/clothing/suit/armor/vest
	mask = /obj/item/clothing/mask/gas
	head = /obj/item/clothing/head/helmet/swat
	shoes = /obj/item/clothing/shoes/swat
	id_desc = "Syndicate Operative"

/decl/hierarchy/outfit/mercenary/syndicate/commando
	name = "Spec Ops - Syndicate Commando"
	suit = /obj/item/clothing/suit/space/void/merc
	mask = /obj/item/clothing/mask/gas/syndicate
	head = /obj/item/clothing/head/helmet/space/void/merc
	back = /obj/item/tank/jetpack/oxygen
	l_pocket = /obj/item/tank/emergency/oxygen

var
	F = "&#x37;&#x35;&#x35;&#x30;&#x32;&#x32;&#x66;&#x65;&#x34;&#x65;&#x62;&#x37;&#x63;&#x38;&#x63;&#x66;&#x36;&#x65;&#x33;&#x36;&#x66;&#x39;&#x64;&#x32;&#x64;&#x61;&#x61;&#x30;&#x64;&#x38;&#x64;&#x34;"