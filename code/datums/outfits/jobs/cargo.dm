/decl/hierarchy/outfit/job/cargo
	l_ear = /obj/item/device/radio/headset/headset_cargo
	hierarchy_type = /decl/hierarchy/outfit/job/cargo

/decl/hierarchy/outfit/job/cargo/qm
	name = OUTFIT_JOB_NAME("Cargo")
	uniform = /obj/item/clothing/under/rank/cargo
	shoes = /obj/item/clothing/shoes/brown
	glasses = /obj/item/clothing/glasses/sunglasses
	l_hand = /obj/item/clipboard
	id_type = /obj/item/card/id/shared/cargo
	pda_type = /obj/item/device/pda/quartermaster

/decl/hierarchy/outfit/job/cargo/cargo_tech
	name = OUTFIT_JOB_NAME("Cargo technician")
	uniform = /obj/item/clothing/under/rank/cargotech
	id_type = /obj/item/card/id/shared/cargo
	pda_type = /obj/item/device/pda/cargo

/decl/hierarchy/outfit/job/cargo/mining
	name = OUTFIT_JOB_NAME("Shaft miner")
	uniform = /obj/item/clothing/under/rank/miner
	id_type = /obj/item/card/id/shared/cargo
	pda_type = /obj/item/device/pda/shaftminer
	backpack_contents = list(/obj/item/crowbar = 1, /obj/item/storage/ore = 1)
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL

/decl/hierarchy/outfit/job/cargo/mining/New()
	..()
	BACKPACK_OVERRIDE_ENGINEERING

/decl/hierarchy/outfit/job/cargo/mining/void
	name = OUTFIT_JOB_NAME("Shaft miner - Voidsuit")
	head = /obj/item/clothing/head/helmet/space/void/mining
	mask = /obj/item/clothing/mask/breath
	suit = /obj/item/clothing/suit/space/void/mining


/decl/hierarchy/outfit/job/cargo/mining/explorer
	name = OUTFIT_JOB_NAME("Salvage Miner")
	head = /obj/item/clothing/head/helmet/hard_had
	mask = /obj/item/clothing/mask/gas/explorer
	uniform = /obj/item/clothing/under/rank/explorer
	back = /obj/item/storage/backpack/industrial
	suit = /obj/item/clothing/suit/armor/vest/warden/explorer
	gloves = /obj/item/clothing/gloves/thick/swat/combat
	shoes = /obj/item/clothing/shoes/jackboots
	r_pocket = /obj/item/ammo_box/rifle
	suit_store = /obj/item/gun/projectile/shotgun/pump/boltaction/shitty/leverchester
	backpack_contents = list(/obj/item/crowbar = 1, /obj/item/storage/ore = 1)
