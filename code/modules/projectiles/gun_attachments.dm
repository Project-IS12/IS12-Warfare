//Gun attachable related flags.
//flags_attach_features
#define ATTACH_REMOVABLE	(1<<0)
#define ATTACH_ACTIVATION	(1<<1)
#define ATTACH_PROJECTILE	(1<<2) //for attachments that fire bullets
#define ATTACH_RELOADABLE	(1<<3)
#define ATTACH_WEAPON		(1<<4) //is a weapon that fires stuff
#define ATTACH_UTILITY		(1<<5) //for attachments with utility that trigger by 'shooting'


/obj/item/attachable
	name = "attachable item"
	desc = "It's an attachment. You should never see this."
	icon = 'icons/obj/items/attachments.dmi'
	icon_state = null
	item_state = null
	var/attach_icon //the sprite to show when the attachment is attached when we want it different from the icon_state.
	var/pixel_shift_x = 16 //Determines the amount of pixels to move the icon state for the overlay.
	var/pixel_shift_y = 16 //Uses the bottom left corner of the item.

	w_class = WEIGHT_CLASS_SMALL
	force = 0 //Don't try killing people with attachments please.
	var/slot = null //"muzzle", "rail", "under", "stock"

	/*
	Anything that isn't used as the gun fires should be a flat number, never a percentange. It screws with the calculations,
	and can mean that the order you attach something/detach something will matter in the final number. It's also completely
	inaccurate. Don't worry if force is ever negative, it won't runtime.
	*/
	//These bonuses are applied only as the gun fires a projectile.

	//These are flat bonuses applied and are passive, though they may be applied at different points.
	var/accuracy_mod 	= 0 //Modifier to firing accuracy, works off a multiplier.
	var/accuracy_unwielded_mod = 0 //same as above but for onehanded.
	var/damage_mod 		= 0 //Modifer to the damage mult, works off a multiplier.
	var/melee_mod 		= 0 //Changing to a flat number so this actually doesn't screw up the calculations.
	var/recoil_mod 		= 0 //If positive, adds recoil, if negative, lowers it. Recoil can't go below 0.
	var/recoil_unwielded_mod = 0 //same as above but for onehanded firing.
	var/delay_mod 		= 0 //Changes firing delay. Cannot go below 0.
	var/burst_delay_mod = 0 //Changes burst firing delay. Cannot go below 0.
	var/burst_mod 		= 0 //Changes burst rate. 1 == 0.
	var/size_mod 		= 0 //Increases the weight class.
	var/attach_delay = 30 //How long in deciseconds it takes to attach a weapon with level 1 firearms training. Default is 30 seconds.
	var/detach_delay = 30 //How long in deciseconds it takes to detach a weapon with level 1 firearms training. Default is 30 seconds.
	var/fire_delay_mod = 0 //how long in deciseconds this adds to your base fire delay.

	var/attachment_firing_delay = 0 //the delay between shots, for attachments that fires stuff

	var/activation_sound = 'sound/machines/click.ogg'

	var/flags_attach_features = ATTACH_REMOVABLE

	var/attachment_action_type
	var/scope_zoom_mod = FALSE //codex

	var/ammo_mod = null			//what ammo the gun could also fire, different lasers usually.
	var/charge_mod = 0		//how much charge difference it now costs to shoot. negative means more shots per mag.
	var/gun_firemode_list_mod = null //what firemodes this attachment allows/adds.

	var/obj/item/gun/master_gun




/obj/item/attachable/proc/Attach(obj/item/gun/gun_to_attach, mob/user)
	if(!istype(gun_to_attach))
		return //Guns only
	master_gun = gun_to_attach
	/*
	This does not check if the attachment can be removed.
	Instead of checking individual attachments, I simply removed
	the specific guns for the specific attachments so you can't
	attempt the process in the first place if a slot can't be
	removed on a gun. can_be_removed is instead used when they
	try to strip the gun.
	*/
	switch(slot)
		if("rail")
			master_gun.rail?.Detach(user)
			master_gun.rail = src
		if("muzzle")
			master_gun.muzzle?.Detach(user)
			master_gun.muzzle = src
		if("under")
			master_gun.under?.Detach(user)
			master_gun.under = src
		if("stock")
			master_gun.stock?.Detach(user)
			master_gun.stock = src

	if(ishuman(user))
		var/mob/living/carbon/human/wielder = user
		wielder.drop_item(src)

	forceMove(master_gun)

	master_gun.damage_modifier				+= damage_mod

	master_gun.force 						+= melee_mod

	master_gun.update_attachable(slot)



/obj/item/attachable/proc/Detach(mob/user)

	switch(slot)
		if("rail")
			master_gun.rail = null
		if("muzzle")
			master_gun.muzzle = null
		if("under")
			master_gun.under = null
		if("stock")
			master_gun.stock = null

	master_gun.damage_modifier				-= damage_mod

	master_gun.force 						-= melee_mod

	master_gun.update_force_list()

	forceMove(get_turf(master_gun))

	master_gun = null

	master_gun.update_attachables()



/obj/item/gun/proc/update_attachables() //Updates everything. You generally don't need to use this.
	//overlays.Cut()
	if(attachable_offset) //Even if the attachment doesn't exist, we're going to try and remove it.
		update_overlays(muzzle, "muzzle")
		update_overlays(stock, "stock")
		update_overlays(under, "under")
		update_overlays(rail, "rail")


/obj/item/gun/proc/update_attachable(attachable) //Updates individually.
	if(attachable_offset)
		switch(attachable)
			if("muzzle") update_overlays(muzzle, attachable)
			if("stock") update_overlays(stock, attachable)
			if("under") update_overlays(under, attachable)
			if("rail") update_overlays(rail, attachable)


/obj/item/gun/update_overlays(obj/item/attachable/A, slot)
	. = ..()
	var/image/I = attachable_overlays[slot]
	overlays -= I
	qdel(I)
	if(A) //Only updates if the attachment exists for that slot.
		var/item_icon = A.icon_state
		if(A.attach_icon)
			item_icon = A.attach_icon
		I = image(A.icon,src, item_icon)
		I.pixel_x = attachable_offset["[slot]_x"] - A.pixel_shift_x
		I.pixel_y = attachable_offset["[slot]_y"] - A.pixel_shift_y
		attachable_overlays[slot] = I
		overlays += I
	else
		attachable_overlays[slot] = null



/obj/item/attachable/bayonet
	name = "bayonet"
	desc = "A sharp blade for mounting on a weapon. It can be used to stab manually on anything but harm intent."
	icon_state = "bayonet"
	attach_icon = "bayonet_a"
	force = 20
	throwforce = 10
	attach_delay = 10 //Bayonets attach/detach quickly.
	detach_delay = 10
	attack_verb = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	melee_mod = 15
	slot = "muzzle"
	pixel_shift_x = 14 //Below the muzzle.
	pixel_shift_y = 18
	accuracy_mod = -0.05
	accuracy_unwielded_mod = -0.1
	size_mod = 1


/obj/item/attachable/verticalgrip
	name = "vertical grip"
	desc = "A custom-built improved foregrip for better accuracy, less recoil, and less scatter when wielded especially during burst fire. \nHowever, it also increases weapon size, slightly increases wield delay and makes unwielded fire more cumbersome."
	icon_state = "verticalgrip"
	attach_icon = "verticalgrip_a"
	wield_delay_mod = 0.2 SECONDS
	size_mod = 1
	slot = "under"
	pixel_shift_x = 20
	accuracy_mod = 0.1
	recoil_mod = -2
	scatter_mod = -10
	burst_scatter_mod = -1
	accuracy_unwielded_mod = -0.05
	scatter_unwielded_mod = 5


/obj/item/attachable/angledgrip
	name = "angled grip"
	desc = "A custom-built improved foregrip for less recoil, and faster wielding time. \nHowever, it also increases weapon size, and slightly hinders unwielded firing."
	icon_state = "angledgrip"
	attach_icon = "angledgrip_a"
	wield_delay_mod = -0.3 SECONDS
	size_mod = 1
	slot = "under"
	pixel_shift_x = 20
	recoil_mod = -1
	accuracy_unwielded_mod = -0.1
	scatter_unwielded_mod = 5