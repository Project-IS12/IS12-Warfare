/obj/item/gun/energy
	name = "energy gun"
	desc = "A basic energy-based gun."
	icon_state = "energy"
	fire_sound = 'sound/weapons/Taser.ogg'
	fire_sound_text = "laser blast"

	var/obj/item/cell/power_supply //What type of power cell this uses
	var/charge_cost = 20 //How much energy is needed to fire.
	var/max_shots = 10 //Determines the capacity of the weapon's power cell. Specifying a cell_type overrides this value.
	var/cell_type = null
	var/projectile_type = /obj/item/projectile/energy/laser // /obj/item/projectile/beam/practice
	var/modifystate
	var/charge_meter = 1	//if set, the icon state will be chosen based on the current charge

	//self-recharging
	var/self_recharge = 0	//if set, the weapon will recharge itself
	var/use_external_power = 0 //if set, the weapon will look for an external power source to draw from, otherwise it recharges magically
	var/recharge_time = 4
	var/charge_tick = 0
	var/icon_rounder = 25
	combustion = 1

/obj/item/gun/energy/switch_firemodes()
	. = ..()
	if(.)
		update_icon()

/obj/item/gun/energy/emp_act(severity)
	..()
	update_icon()

/obj/item/gun/energy/New()
	..()
	if(cell_type)
		power_supply = new cell_type(src)
	else
		power_supply = new /obj/item/cell/device/variable(src, max_shots*charge_cost)
	if(self_recharge)
		START_PROCESSING(SSobj, src)
	update_icon()

/obj/item/gun/energy/Destroy()
	if(self_recharge)
		STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/gun/energy/Process()
	if(self_recharge) //Every [recharge_time] ticks, recharge a shot for the cyborg
		charge_tick++
		if(charge_tick < recharge_time) return 0
		charge_tick = 0

		if(!power_supply || power_supply.charge >= power_supply.maxcharge)
			return 0 // check if we actually need to recharge

		if(use_external_power)
			var/obj/item/cell/external = get_external_power_supply()
			if(!external || !external.use(charge_cost)) //Take power from the borg...
				return 0

		power_supply.give(charge_cost) //... to recharge the shot
		update_icon()
	return 1

/obj/item/gun/energy/consume_next_projectile()
	if(!power_supply) return null
	if(!ispath(projectile_type)) return null
	if(!power_supply.checked_use(charge_cost)) return null
	return new projectile_type(src)

/obj/item/gun/energy/proc/get_external_power_supply()
	if(isrobot(src.loc))
		var/mob/living/silicon/robot/R = src.loc
		return R.cell
	return null

/obj/item/gun/energy/examine(mob/user)
	. = ..(user)
	var/shots_remaining = 0
	if(power_supply)
		shots_remaining = round(power_supply.charge / charge_cost)
	to_chat(user, "Has [shots_remaining] shot\s remaining.")
	return

/obj/item/gun/energy/update_icon()
	..()
	if(charge_meter)
		var/ratio = 0
		if(power_supply)
			ratio = power_supply.percent()

			//make sure that rounding down will not give us the empty state even if we have charge for a shot left.
			if(power_supply.charge < charge_cost)
				ratio = 0
			else
				ratio = max(round(ratio, icon_rounder), icon_rounder)

		if(modifystate)
			icon_state = "[modifystate][ratio]"
		else
			icon_state = "[initial(icon_state)][ratio]"




/obj/item/gun/energy/attackby(var/obj/item/A as obj, mob/user as mob)
	load_ammo(A, user)

/obj/item/gun/energy/load_ammo(var/obj/item/A, mob/user)
	if(!istype(A, /obj/item/cell))
		return

	if(power_supply)
		to_chat(user, "<span class='warning'>[src] already has a power cell loaded.</span>")//already a power cell here
		return

	user.remove_from_mob(A)
	A.loc = src
	power_supply = A
	user.visible_message("[user] inserts [A] into [src].", "<span class='notice'>You insert [A] into [src].</span>")
	playsound(src, 'sound/weapons/guns/interact/mag_load.ogg', 100)
	update_icon()


/obj/item/gun/energy/unload_ammo(mob/user, var/allow_dump=1)
	if(power_supply)
		playsound(src, 'sound/weapons/guns/interact/mag_unload.ogg', 100)
		user.visible_message("[user] removes the power cell from [src].", "<span class='notice'>You remove the power cell from [src].</span>")
		user.put_in_hands(power_supply)
		power_supply.update_icon()
		power_supply = null
		update_icon()

/obj/item/gun/energy/MouseDrop(var/obj/over_object)
	if (!over_object || !(ishuman(usr) || issmall(usr)))
		return

	if (!(src.loc == usr))
		return
	var/mob/living/carbon/human/H = usr
	if(H.incapacitated(INCAPACITATION_STUNNED|INCAPACITATION_KNOCKOUT))
		return

	switch(over_object.name)
		if("r_hand")
			unload_ammo(usr, allow_dump=0)
		if("l_hand")
			unload_ammo(usr, allow_dump=0)