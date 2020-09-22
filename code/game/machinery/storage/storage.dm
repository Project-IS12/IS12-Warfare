/* Copyright (C) The interbay dev team - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 *
 * Proprietary and confidential
 * Do not modify or remove this header.
 *
 * Written by Kyrah Abattoir <git@kyrahabattoir.com>, August 2018
 */

//This is a special baseclass to equip machineries and other static objects with
//a standard backpack style storage, it does so by overriding the adjacency check
//allowing to manipulate the container's inventory despite not being on a player
//or a turf.

/obj/item/storage/special
	name = "/obj/item/storage/special"
	desc = "base storage for storage machines"
	w_class = ITEM_SIZE_NO_CONTAINER
	max_w_class = ITEM_SIZE_GARGANTUAN //you prolly want to change this on subclasses.
	storage_slots = 1
	use_sound = null

//overrides item:Adjacent() so we can drop down one level
/obj/item/storage/special/Adjacent(var/atom/neighbor)
	return loc.Adjacent(neighbor)

/obj/item/storage/special/attack_hand(mob/user as mob)
	open(user)

//Use this machine as a base class it's pretty simple
/obj/machinery/storage/
	name = "/obj/machinery/storage/"
	desc = "baseclass for storage enabled machines"
	var/obj/item/storage/special/inventory

/obj/machinery/storage/New()
	inventory = new /obj/item/storage/special()
	inventory.loc = src   //VERY IMPORTANT
	inventory.name = name //Not strictly needed but this affects the text description when players insert items inside the storage.

/obj/machinery/storage/Destroy()
	qdel(inventory)
	..()

//fowards attack_hand
/obj/machinery/storage/attack_hand(mob/user as mob)
	inventory.attack_hand(user)

//fowards attackby
/obj/machinery/storage/attackby(obj/item/W as obj, mob/user as mob)
	inventory.attackby(W, user)
