/decl/hierarchy/outfit/job/security
	hierarchy_type = /decl/hierarchy/outfit/job/security
	glasses = /obj/item/clothing/glasses/sunglasses
	l_ear = /obj/item/device/radio/headset/headset_sec
	gloves = /obj/item/clothing/gloves/thick
	shoes = /obj/item/clothing/shoes/jackboots
	backpack_contents = list(/obj/item/handcuffs = 1)

/decl/hierarchy/outfit/job/security/New()
	..()
	BACKPACK_OVERRIDE_SECURITY

/decl/hierarchy/outfit/job/security/hos
	name = OUTFIT_JOB_NAME("Head of security")
	l_ear = /obj/item/device/radio/headset/heads/hos
	uniform = /obj/item/clothing/under/rank/head_of_security/jensen
	suit = /obj/item/clothing/suit/armor/hos/jensen
	head = /obj/item/clothing/head/beret/sec/corporate/hos
	id_type = /obj/item/card/id/security/head
	pda_type = /obj/item/device/pda/heads/hos
	backpack_contents = list(/obj/item/handcuffs = 1)

/decl/hierarchy/outfit/job/security/warden
	name = OUTFIT_JOB_NAME("Warden")
	uniform = /obj/item/clothing/under/rank/warden/corp
	l_pocket = /obj/item/device/flash
	id_type = /obj/item/card/id/security/warden
	pda_type = /obj/item/device/pda/warden

/decl/hierarchy/outfit/job/security/detective
	name = OUTFIT_JOB_NAME("Detective")
	head = /obj/item/clothing/head/det/grey
	uniform = /obj/item/clothing/under/det/black
	suit = /obj/item/clothing/suit/storage/det_trench/grey
	l_pocket = /obj/item/flame/lighter/zippo
	shoes = /obj/item/clothing/shoes/laceup
	r_hand = /obj/item/storage/briefcase/crimekit
	id_type = /obj/item/card/id/security/detective
	pda_type = /obj/item/device/pda/detective
	backpack_contents = list(/obj/item/storage/box/evidence = 1)

/decl/hierarchy/outfit/job/security/detective/New()
	..()
	backpack_overrides.Cut()

/decl/hierarchy/outfit/job/security/detective/forensic
	name = OUTFIT_JOB_NAME("Forensic technician")
	head = null
	suit = /obj/item/clothing/suit/storage/forensics/blue

/decl/hierarchy/outfit/job/security/officer
	name = OUTFIT_JOB_NAME("Security Officer")
	uniform = /obj/item/clothing/under/rank/security/corp
	l_pocket = /obj/item/device/flash
	r_pocket = /obj/item/handcuffs
	id_type = /obj/item/card/id/security
	pda_type = /obj/item/device/pda/security
