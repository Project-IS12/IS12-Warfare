/obj/item/bola
	name = "Bola"
	icon = 'icons/obj/crafting.dmi'
	w_class = ITEM_SIZE_NORMAL
	desc = "This is a bola.  Good for tripping people the are running away."
	icon_state = "bola"
	matter = list(DEFAULT_WALL_MATERIAL = 20)

/obj/item/bola/throw_impact(atom/hit_atom)
	..()
	var/mob/living/carbon/C = hit_atom
	C.Weaken(10)

/datum/crafting_recipe/bola
	name = "Bola"
	parts = list(/obj/item/cylinder = 3, /obj/item/stack/cable_coil = 15)
	tools = list()
	result = list(/obj/item/bola = 1)
	time = 30
	base_chance = 100

/datum/crafting_recipe/light_tube
	name = "Light tube"
	parts = list(/obj/item/glass_tube = 1, /obj/item/stack/cable_coil = 5)
	tools = list(/obj/item/weapon/screwdriver = 1)
	result = list(/obj/item/weapon/light/tube	 = 1)
	time = 30
	base_chance = 100