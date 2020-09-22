/obj/item/reciever
	name = "Reciever"
	icon = 'icons/obj/crafting.dmi'
	w_class = ITEM_SIZE_NORMAL
	desc = "This is a reciever."
	icon_state = "reciever"
	matter = list(DEFAULT_WALL_MATERIAL = 500)

/obj/item/action
	name = "Action"
	icon = 'icons/obj/crafting.dmi'
	w_class = ITEM_SIZE_NORMAL
	desc = "This is a action."
	icon_state = "action"
	matter = list(DEFAULT_WALL_MATERIAL = 400)

/obj/item/metal_bar
	name = "Metal Bar"
	icon = 'icons/obj/crafting.dmi'
	w_class = ITEM_SIZE_NORMAL
	desc = "This is a metal bar.  Can be made into lots of stuff"
	icon_state = "metal_bar"
	matter = list(DEFAULT_WALL_MATERIAL = 300)

	mill()
		return /obj/item/pipe
	press()
		return /obj/item/crowbar


/obj/item/glass_bar
	name = "Glass Bar"
	icon = 'icons/obj/crafting.dmi'
	w_class = ITEM_SIZE_NORMAL
	desc = "This is a glass bar.  Can be made into lots of stuff"
	icon_state = "glass_bar"
	matter = list("glass" = 300)

	mill()
		return /obj/item/glass_tube

/obj/item/glass_tube
	name = "Glass Tube"
	icon = 'icons/obj/crafting.dmi'
	w_class = ITEM_SIZE_NORMAL
	desc = "A hollow glass bar.  Looks like it would fit perfectly as a tube light."
	icon_state = "glass_tube"
	matter = list("glass" = 200)


/obj/item/metal_shiv
	name = "Metal shiv"
	icon = 'icons/obj/crafting.dmi'
	w_class = ITEM_SIZE_NORMAL
	desc = "This is a metal shiv. It can be made into many things."
	icon_state = "metal_shiv"
	matter = list(DEFAULT_WALL_MATERIAL = 300)

	press()
		return /obj/item/screwdriver_head

/obj/item/screwdriver_head
	name = "Screwdriver head"
	icon = 'icons/obj/crafting.dmi'
	w_class = ITEM_SIZE_NORMAL
	desc = "This is the top of a screwdriver"
	icon_state = "screwdriver_head"

/obj/item/wrench_head
	name = "Top of a wrench"
	icon = 'icons/obj/crafting.dmi'
	w_class = ITEM_SIZE_NORMAL
	desc = "This is a top of a wrench."
	icon_state = "wrench_head"
	matter = list(DEFAULT_WALL_MATERIAL = 800)

/obj/item/glass_handle
	name = "Glass handle"
	icon = 'icons/obj/crafting.dmi'
	w_class = ITEM_SIZE_NORMAL
	desc = "This is a piece of glass.  It could be used as a handle"
	icon_state = "glass_handle"
	matter = list("glass" = 400)

/obj/item/cylinder
	var/chambers = 0
	name = "cylinder"
	icon = 'icons/obj/crafting.dmi'
	w_class = ITEM_SIZE_NORMAL
	desc = "This is a makeshift cylinder.  It has zero holes drilled into it"
	icon_state = "cylinder_0"
	matter = list(DEFAULT_WALL_MATERIAL = 500)

	mill(var/mob/living/carbon/human/user)
		switch(chambers)
			if(0)
				if (user.statscheck(skills = user.SKILL_LEVEL(engineering)) >= SUCCESS)
					return /obj/item/cylinder/one_slot
			if(1)
				if (user.statscheck(skills = user.SKILL_LEVEL(engineering), mod = -2) >= SUCCESS)
					return /obj/item/cylinder/two_slot
			if(2)
				if (user.statscheck(skills = user.SKILL_LEVEL(engineering), mod = -4) >= SUCCESS)
					return /obj/item/cylinder/three_slot
			if(3)
				if (user.statscheck(skills = user.SKILL_LEVEL(engineering), mod = -6) >= SUCCESS)
					return /obj/item/cylinder/four_slot
			if(4)
				to_chat(usr, "<span class='notice'>You nick another hole, and the cylinder falls apart.</span>")
				return /obj/item/ore/slag
		return /obj/item/ore/slag

	press()
		return /obj/item/wrench_head

/obj/item/cylinder/one_slot
	chambers = 1
	icon_state = "cylinder_1"
	desc = "This is a makeshift cylinder.  It has one hole drilled into it"

/obj/item/cylinder/two_slot
	chambers = 2
	icon_state = "cylinder_2"
	desc = "This is a makeshift cylinder.  It has two holes drilled into it"

/obj/item/cylinder/three_slot
	chambers = 3
	icon_state = "cylinder_3"
	desc = "This is a makeshift cylinder.  It has three holes drilled into it"

/obj/item/cylinder/four_slot
	chambers = 4
	desc = "This is a makeshift cylinder.  It has four holes drilled into it"
	icon_state = "cylinder_4"

/obj/item/stock
	icon = 'icons/obj/crafting.dmi'
	w_class = ITEM_SIZE_NORMAL
	desc = "This is reciever."
	icon_state = "stock"

/obj/item/gun/projectile/revolver/crafted
	max_shells = 0
	starts_loaded = 0
	icon_state = "crafted_revolver"
	desc = "An ugly revolver made right here on the station.  Looks like it will take .38 ammo"
	condition = 75
	caliber = "38"
	ammo_type = /obj/item/ammo_casing/c38

/obj/item/gun/projectile/revolver/crafted/one_chamber
	max_shells = 1

/obj/item/gun/projectile/revolver/crafted/two_chamber
	max_shells = 2

/obj/item/gun/projectile/revolver/crafted/three_chamber
	max_shells = 3

/obj/item/gun/projectile/revolver/crafted/four_chamber
	max_shells = 4