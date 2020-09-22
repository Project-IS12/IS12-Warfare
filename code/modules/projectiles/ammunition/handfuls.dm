//Handfuls
/obj/item/ammo_magazine/handful
	name = "handful"
	desc = "If you see this Matt fucked something up."
	mag_type = SINGLE_LOAD
	max_ammo = 5
	multiple_sprites = 1
	drop_sound = 'sound/items/handle/casing_drop.ogg'

/obj/item/ammo_magazine/handful/New()
	..()
	update_icon()

/obj/item/ammo_magazine/handful/update_icon()
	if(!stored_ammo.len)//There's no more ammo here, so delete the handful.
		qdel(src)
		return
	icon_state = "[initial(icon_state)][stored_ammo.len]"//If there is ammo then we take our initial icon_state and add the ammount of ammo in the stack to it.

/obj/item/ammo_magazine/handful/attack_self(mob/user)//We want to override the normal attack self with makes us "empty" our "clip".
	return

//Rifle
/obj/item/ammo_magazine/handful/brifle_handful
	name = "\improper handful of bullets"
	desc = "A handful of rifle bullets for your rifle."
	icon_state = "brifle"
	caliber = "763"
	ammo_type = /obj/item/ammo_casing/brifle
	grab_sound = 'sound/items/handle/bullet_pickup.ogg'

/obj/item/ammo_magazine/handful/brifle_handful/two
	initial_ammo = 2


//Shotgun
/obj/item/ammo_magazine/handful/shotgun
	drop_sound = 'sound/weapons/guns/misc/shotgun_fall.ogg'

/obj/item/ammo_magazine/handful/shotgun/shotgun_handful
	name = "\improper handful of shells"
	desc = "A handful of shotgun shells for your shotgun."
	icon_state = "gshell"
	item_state = "shotgun_handful"
	caliber = "shotgun"
	ammo_type = /obj/item/ammo_casing/shotgun/pellet
	drop_sound = 'sound/weapons/guns/misc/shotgun_fall.ogg'

/obj/item/ammo_magazine/handful/shotgun/shotgun_handful/two
	initial_ammo = 2

/obj/item/ammo_magazine/handful/shotgun/slug_handful
	name = "\improper handful of slug shells"
	desc = "A handful of slugs, like buckshot without the spread."
	icon_state = "slshell"
	caliber = "shotgun"
	ammo_type = /obj/item/ammo_casing/shotgun

/obj/item/ammo_magazine/handful/shotgun/beanbag_handful
	name = "\improper handful of shells"
	desc = "A handful of shotgun shells for your shotgun."
	icon_state = "bshell"
	caliber = "shotgun"
	ammo_type = /obj/item/ammo_casing/shotgun/beanbag


//Revolver
/obj/item/ammo_magazine/handful/revolver
	name = "\improper handful of revolver ammo"
	desc = "Why use a quickloader, when you can be a quicker loader?"
	icon_state = "revolver-handful"
	ammo_type = /obj/item/ammo_casing/a357
	max_ammo = 6

/obj/item/ammo_magazine/handful/revolver/two
	initial_ammo = 2

/obj/item/ammo_magazine/handful/ptsd
	name = "PTSD round"
	desc = "Massive bullet, used to shoot tanks, and also people."
	icon_state = "lcasing"
	ammo_type = /obj/item/ammo_casing/a145
	max_ammo = 1
	caliber = "14.5mm"


/*
 * AMMO BOXES
 */


/obj/item/ammo_box
	name = "\improper box of ammo"
	desc = "You get bullets out of this."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "rbox"
	w_class = ITEM_SIZE_SMALL //So you can put it in your pocket.
	var/handful_type = null
	var/list/stored_handfuls = list()
	var/max_stacks = 4
	var/handful_verb = "handful"

/obj/item/ammo_box/Initialize()
	. = ..()
	for(var/i in 1 to max_stacks)
		stored_handfuls += new handful_type(src)
	update_icon()

/obj/item/ammo_box/examine(mob/user)
	. = ..()
	if(stored_handfuls.len)
		to_chat(user, "It has [stored_handfuls.len] [handful_verb]s left.")
	else
		to_chat(user, "It is empty.")


/obj/item/ammo_box/attack_hand(var/mob/living/carbon/human/user)
	if(!istype(user))
		..()
		return
	if((src != user.r_store) && (src != user.l_store) && (src != user.belt) && (src != user.get_inactive_hand()))
		..()//If it's not in any of these slots then just return normally.
		return
	if(!stored_handfuls.len)//If there's no more handfuls then don't divide by 0 please.
		return
	var/obj/item/ammo_magazine/handful/A = src.stored_handfuls[1]//If it is in one of these slots though put it in our hand.
	if(A)
		stored_handfuls.Cut(1, 2)
		user.put_in_hands(A)
		user.visible_message("[user] takes [A] out.")
	update_icon()

/obj/item/ammo_box/attackby(obj/item/C, mob/user)
	if(!istype(C, handful_type))
		to_chat(user, "\The [src] does not accept this [handful_verb].")
		return
	if(stored_handfuls.len == max_stacks)
		to_chat(user, "There's too many [handful_verb]s in there already.")
		return
	user.remove_from_mob(C)
	C.forceMove(src)
	stored_handfuls.Add(C)
	user.visible_message("[user] adds [C] to the box.")
	update_icon()


/obj/item/ammo_box/MouseDrop(var/obj/over_object)
	if (!over_object || !(ishuman(usr) || issmall(usr)))
		return

	if (!(src.loc == usr))
		return

	if (usr.incapacitated(INCAPACITATION_STUNNED|INCAPACITATION_RESTRAINED|INCAPACITATION_KNOCKOUT))
		return

	if (!usr.unEquip(src))
		return

	switch(over_object.name)
		if("r_hand")
			usr.put_in_r_hand(src)
		if("l_hand")
			usr.put_in_l_hand(src)

	src.add_fingerprint(usr)

//Rifle box.
/obj/item/ammo_box/rifle
	name = "\improper rifle bullets box"
	desc = "You get rifle bullets out of this one."
	handful_type = /obj/item/ammo_magazine/handful/brifle_handful


//Box of handfuls of shotgun ammo.
/obj/item/ammo_box/shotgun
	name = "\improper shells box"
	icon_state = "shotgunammo"
	desc = "You get shells out of this."
	handful_type = /obj/item/ammo_magazine/handful/shotgun/shotgun_handful


/obj/item/ammo_box/ptsd
	name = "\improper shells box"
	icon_state = "ptsdbox"
	desc = "You get shells out of this."
	handful_type = /obj/item/ammo_magazine/handful/ptsd
	max_stacks = 10 //Holds 10, one round handfuls.
	handful_verb = "round"


//Dumb shotgun stuff from another time.
/obj/item/ammo_magazine/box/shotgun
	name = "shells box"
	icon_state = "gbox"
	caliber = "shotgun"
	ammo_type = /obj/item/ammo_casing/shotgun/pellet
	max_ammo = 8
	multiple_sprites = 1
	var/open = FALSE

/obj/item/ammo_magazine/box/shotgun/update_icon()
	if(!open)
		overlays.Cut()
		icon_state = "[initial(icon_state)]"
		return
	icon_state = "[initial(icon_state)]-0"
	overlays.Cut()
	var/i = 0
	for(var/obj/item/ammo_casing/shotgun/AC in stored_ammo)
		i++
		overlays += icon('icons/obj/ammo.dmi', "[AC.icon_state]-[i]")

/obj/item/ammo_magazine/box/shotgun/attack_self(mob/user)
	open =! open
	update_icon()

/obj/item/ammo_magazine/box/shotgun/attackby(obj/item/W as obj, mob/user as mob)
	if(!open)
		return
	..()

/obj/item/ammo_magazine/box/shotgun/slug
	name = "slug box"
	icon_state = "blbox"
	ammo_type = /obj/item/ammo_casing/shotgun

/obj/item/ammo_magazine/box/shotgun/stun
	name = "stunshells box"
	icon_state = "stunbox"
	ammo_type = /obj/item/ammo_casing/shotgun/stunshell

/obj/item/ammo_magazine/box/shotgun/bean
	name = "beanbag box"
	icon_state = "bbox"
	ammo_type = /obj/item/ammo_casing/shotgun/beanbag