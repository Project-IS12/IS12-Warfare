/obj/machinery/button/remote
	name = "remote object control"
	desc = "It controls objects, remotely."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "doorctrl"
	power_channel = ENVIRON
	var/desiredstate = 0
	var/exposedwires = 0
	var/wires = 3
	/*
	Bitflag,	1=checkID
				2=Network Access
	*/

	anchored = 1.0
	use_power = 1
	idle_power_usage = 2
	active_power_usage = 4

/obj/machinery/button/remote/attack_ai(mob/user as mob)
	if(wires & 2)
		return src.attack_hand(user)
	else
		to_chat(user, "Error, no route to host.")

/obj/machinery/button/remote/attackby(obj/item/W, mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/button/remote/emag_act(var/remaining_charges, var/mob/user)
	if(req_access.len || req_one_access.len)
		req_access = list()
		req_one_access = list()
		playsound(src.loc, "sparks", 100, 1)
		return 1

/obj/machinery/button/remote/attack_hand(mob/user as mob)
	if(..())
		return

	if(stat & (NOPOWER|BROKEN))
		return

	if(!allowed(user) && (wires & 1))
		to_chat(user, "<span class='warning'>Access Denied</span>")
		flick("[initial(icon_state)]-denied",src)
		return

	use_power(5)
	icon_state = "[initial(icon_state)]1"
	desiredstate = !desiredstate
	trigger(user)
	spawn(15)
		update_icon()

/obj/machinery/button/remote/proc/trigger()
	return

/obj/machinery/button/remote/update_icon()
	if(stat & NOPOWER & !istype(src,/obj/machinery/button/remote/blast_door/lever))
		icon_state = "[initial(icon_state)]-p"
	else
		icon_state = "[initial(icon_state)]"

/*
	Airlock remote control
*/

// Bitmasks for door switches.
#define OPEN   0x1
#define IDSCAN 0x2
#define BOLTS  0x4
#define SHOCK  0x8
#define SAFE   0x10

/obj/machinery/button/remote/airlock
	name = "remote door-control"
	desc = "It controls doors, remotely."

	var/specialfunctions = 1
	/*
	Bitflag, 	1= open
				2= idscan,
				4= bolts
				8= shock
				16= door safties
	*/

/obj/machinery/button/remote/airlock/trigger()
	for(var/obj/machinery/door/airlock/D in world)
		if(D.id_tag == src.id)
			if(specialfunctions & OPEN)
				if (D.density)
					spawn(0)
						D.open()
						return
				else
					spawn(0)
						D.close()
						return
			if(desiredstate == 1)
				if(specialfunctions & IDSCAN)
					D.set_idscan(0)
				if(specialfunctions & BOLTS)
					D.lock()
				if(specialfunctions & SHOCK)
					D.electrify(-1)
				if(specialfunctions & SAFE)
					D.set_safeties(0)
			else
				if(specialfunctions & IDSCAN)
					D.set_idscan(1)
				if(specialfunctions & BOLTS)
					D.unlock()
				if(specialfunctions & SHOCK)
					D.electrify(0)
				if(specialfunctions & SAFE)
					D.set_safeties(1)

#undef OPEN
#undef IDSCAN
#undef BOLTS
#undef SHOCK
#undef SAFE

/*
	Blast door remote control
*/
/obj/machinery/button/remote/blast_door
	name = "remote blast door-control"
	desc = "It controls blast doors, remotely."
	icon_state = "blastctrl"

/obj/machinery/button/remote/blast_door/trigger()
	for(var/obj/machinery/door/blast/M in world)
		if(M.id == src.id)
			if(M.density)
				spawn(0)
					M.open()
					return
			else
				spawn(0)
					M.close()
					return

/obj/machinery/button/remote/blast_door/lever
	name = "Lever"
	desc = "It controls something."
	icon_state = "lever"
	plane = ABOVE_HUMAN_PLANE
	layer = ABOVE_HUMAN_LAYER
	var/on = 0

/obj/machinery/button/remote/blast_door/lever/update_icon()
	if(on)
		icon_state = "lever1"
	else
		icon_state = "lever"

/obj/machinery/button/remote/blast_door/lever/trigger()
	for(var/obj/machinery/door/blast/M in world)
		if(M.id == src.id)
			if(M.density)
				spawn(0)
					M.open()
					on = 1
					update_icon()
					return
			else
				spawn(0)
					M.close()
					on = 0
					update_icon()
					return

/obj/machinery/button/remote/blast_door/lever/attack_hand(mob/user)
	if(..())
		return
	if(stat & (NOPOWER|BROKEN))
		to_chat(user, "<span class='warning'>[src] is not moving</span>")
		return
	trigger(user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)


/obj/machinery/button/remote/blast_door/id_scan
	name = "ID lock"
	desc = null
	icon_state = "id_swap"

/obj/machinery/button/remote/blast_door/id_scan/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/card/id))
		if(allowed(usr))
			if(stat & (NOPOWER|BROKEN))
				return
			to_chat(user, "<span class='notice'>You used your id in [src]</span>")
			playsound(src.loc, 'sound/effects/card_swipe.ogg', 70, 1)
			trigger(user)
			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		else
			to_chat(user, "<span class='warning'>[src] flashes with red color!</span>")
			playsound(src.loc, 'sound/effects/card_swipe.ogg', 70, 1)
			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

/obj/machinery/button/remote/blast_door/id_scan/attack_hand(mob/user)
	return

/obj/machinery/button/remote/blast_door/id_scan/update_icon()
	return

/obj/machinery/button/remote/blast_door/id_scan/trigger(mob/user)
	for(var/obj/machinery/door/blast/id_door/M in world)
		if(M.id == src.id)
			if(M.density)
				spawn(0)
					M.open()
					return
			else
				spawn(0)
					M.close()
					return



/*
	Emitter remote control
*/
/obj/machinery/button/remote/emitter
	name = "remote emitter control"
	desc = "It controls emitters, remotely."

/obj/machinery/button/remote/emitter/trigger(mob/user as mob)
	for(var/obj/machinery/power/emitter/E in world)
		if(E.id == src.id)
			spawn(0)
				E.activate(user)
				return

/*
	Mass driver remote control
*/
/obj/machinery/button/remote/driver
	name = "mass driver button"
	desc = "A remote control switch for a mass driver."
	icon = 'icons/obj/objects.dmi'
	icon_state = "launcherbtt"

/obj/machinery/button/remote/driver/trigger(mob/user as mob)
	set waitfor = 0
	active = 1
	update_icon()

	for(var/obj/machinery/door/blast/M in SSmachines.machinery)
		if (M.id == src.id)
			spawn( 0 )
				M.open()
				return

	sleep(20)

	for(var/obj/machinery/mass_driver/M in SSmachines.machinery)
		if(M.id == src.id)
			M.drive()

	sleep(50)

	for(var/obj/machinery/door/blast/M in SSmachines.machinery)
		if (M.id == src.id)
			spawn(0)
				M.close()
				return

	icon_state = "launcherbtt"
	update_icon()

	return

/obj/machinery/button/remote/driver/update_icon()
	if(!active || (stat & NOPOWER))
		icon_state = "launcherbtt"
	else
		icon_state = "launcheract"
