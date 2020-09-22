/obj/item/gun/energy/taser
	name = "Mk30 NL"
	desc = "Low capacity gun used for non-lethal takedowns. Never has ammo when you need it the most."
	icon_state = "taser"
	fire_sound = 'sound/weapons/guns/fire/pain_fire.ogg'
	item_state = null	//so the human update icon uses the icon_state instead.
	max_shots = 2
	projectile_type = /obj/item/projectile/energy/electrode
	combustion = 0

	/*
	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun),
		list(mode_name="shock", projectile_type=/obj/item/projectile/beam/stun/shock),
		)
	*/
/obj/item/gun/energy/taser/carbine
	name = "taser carbine"
	desc = "The NT Mk44 NL is a high capacity gun used for non-lethal takedowns. It can switch between high and low intensity stun shots."
	icon_state = "tasercarbine"
	w_class = ITEM_SIZE_LARGE
	slot_flags = SLOT_BELT|SLOT_BACK
	one_hand_penalty = 3
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3, TECH_POWER = 3)
	force = 8
	max_shots = 12
	accuracy = 1
	projectile_type = /obj/item/projectile/energy/electrode ///obj/item/projectile/beam/stun/heavy
	wielded_item_state = "tasercarbine-wielded"
/*
	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun/heavy),
		list(mode_name="shock", projectile_type=/obj/item/projectile/beam/stun/shock/heavy),
		)
*/
/obj/item/gun/energy/taser/mounted
	name = "mounted taser gun"
	self_recharge = 1
	use_external_power = 1

/obj/item/gun/energy/taser/mounted/cyborg
	name = "taser gun"
	max_shots = 6
	recharge_time = 10 //Time it takes for shots to recharge (in ticks)


/obj/item/gun/energy/stunrevolver
	name = "stun revolver"
	desc = "A LAEP20 Zeus. Designed by Lawson Arms and produced under the wing of the FTU, several TSCs have been trying to get a hold of the blueprints for half a decade."
	icon_state = "stunrevolver"
	item_state = "stunrevolver"
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_POWER = 2)
	projectile_type = /obj/item/projectile/energy/electrode
	max_shots = 6
	combustion = 0

/obj/item/gun/energy/stunrevolver/rifle
	name = "stun rifle"
	desc = "A LAEP38 Thor, a vastly oversized variant of the LAEP20 Zeus. Fires overcharged electrodes to take down hostile armored targets without harming them too much."
	icon_state = "stunrifle"
	item_state = "stunrifle"
	w_class = ITEM_SIZE_HUGE
	slot_flags = SLOT_BACK
	one_hand_penalty = 6
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3, TECH_POWER = 3)
	force = 10
	max_shots = 10
	accuracy = 1
	projectile_type = /obj/item/projectile/energy/electrode/stunshot
	wielded_item_state = "stunrifle-wielded"

/obj/item/gun/energy/crossbow
	name = "mini energy-crossbow"
	desc = "A weapon favored by many mercenary stealth specialists."
	icon_state = "crossbow"
	w_class = ITEM_SIZE_NORMAL
	item_state = "crossbow"
	origin_tech = list(TECH_COMBAT = 2, TECH_MAGNET = 2, TECH_ILLEGAL = 5)
	matter = list(DEFAULT_WALL_MATERIAL = 2000)
	slot_flags = SLOT_BELT
	silenced = 1
	fire_sound = 'sound/weapons/Genhit.ogg'
	projectile_type = /obj/item/projectile/energy/bolt
	max_shots = 8
	self_recharge = 1
	charge_meter = 0
	combustion = 0

/obj/item/gun/energy/crossbow/largecrossbow
	name = "energy crossbow"
	desc = "A weapon favored by mercenary infiltration teams."
	w_class = ITEM_SIZE_LARGE
	force = 10
	one_hand_penalty = 1
	matter = list(DEFAULT_WALL_MATERIAL = 200000)
	projectile_type = /obj/item/projectile/energy/bolt/large
