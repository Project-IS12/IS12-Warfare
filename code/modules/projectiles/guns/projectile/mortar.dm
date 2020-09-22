
//The mortar shell item.
/obj/item/mortar_shell
	name = "HE Mortar Shell"
	icon = 'icons/obj/items/mortars.dmi'
	icon_state = "he_mortar"
	var/mortar_type = "shrapnel"

/obj/item/mortar_shell/flare
	name = "Red Illumination Mortar"
	icon_state = "r_flare"
	mortar_type = "rflare"

/obj/item/mortar_shell/flare/blue
	name = "Blue Illumination Mortar"
	icon_state = "b_flare"
	mortar_type = "bflare"

//The mortar shell launcher item. This is the one you use.
/obj/item/mortar_launcher
	name = "HE Trench Ender"
	icon = 'icons/obj/items/mortars.dmi'
	icon_state = "mortar_tube"
	item_state = "mortar_tube"
	var/loaded = FALSE
	var/loaded_with = null
	var/deployed = FALSE

/obj/item/mortar_launcher/attackby(obj/item/W, mob/user)
	. = ..()
	if(!istype(W, /obj/item/mortar_shell))
		return
	if(loaded)
		to_chat(user, "There is already a mortar loaded!")
		return
	if(!deployed)
		to_chat(user, "I have to deploy the mortar first!")
		return
	var/obj/item/mortar_shell/M = W
	loaded_with = M.mortar_type
	loaded = TRUE
	playsound(src, 'sound/weapons/mortar_load.ogg', 100, FALSE)
	user.visible_message("<span class='danger'>[user] loads the [src] with \the [W]!</span>")
	qdel(W)
	update_icon()

/obj/item/mortar_launcher/update_icon(var/mob/living/carbon/human/H)
	if(deployed)
		item_state = "blank"
	else
		item_state = "mortar_tube"

	if(istype(H))
		H.regenerate_icons()
	..()

/obj/item/mortar_launcher/afterattack(atom/A, mob/living/user)
	..()
	if(!deployed)//Can't fire.
		to_chat(user, "<span class='danger'>I can't fire it if it's not deployed.</span>")
		return
	if(!loaded)//Nothing to fire.
		to_chat(user, "<span class='danger'>It's not loaded.</span>")
		return
	if(istype(user.loc, /turf/simulated/floor/tiled))
		to_chat(user, "<span class='danger'>I can't use this indoors.</span>")
		return
	if(!user.zoomed)
		to_chat(user, "<span class='danger'>I must zoom into the distance to get a good shot in on.</span>")
		return
	var/obj/item/I = user.get_inactive_hand()
	if(I)
		to_chat(user, "<span class='danger'>I need a free hand for this.</span>")
		return
	log_and_message_admins("[user] has fired a mortar at [A]!", user)
	launch_mortar(A, user, loaded_with)
	QDEL_NULL(loaded)


/obj/item/mortar_launcher/proc/launch_mortar(atom/A, mob/living/user, var/mortar_type)
	user.visible_message("<span class='danger'>[user] fires the [src]!</span>")
	playsound(src, 'sound/weapons/mortar_fire.ogg', 100, FALSE)
	spawn(35)
		drop_mortar(get_turf(A),mortar_type)
	loaded = FALSE

/obj/item/mortar_launcher/attack_self(mob/user)
	. = ..()
	if(deployed)//If there's a mortar deployed, then pack it up again.
		pack_up_mortar(user)
	else
		deploy_mortar(user)//Otherwise, deploy that motherfucker.

/obj/item/mortar_launcher/proc/deploy_mortar(mob/user)
	for(var/obj/structure/mortar_launcher_structure/M in user.loc)//If there's already a mortar there then don't deploy it. Dunno how that's possible but stranger things have happened.
		if(M)
			to_chat(user, "There is already a mortar here.")
			return
	user.visible_message("[user] starts to deploy the [src]")
	if(!do_after(user,30))
		return
	var/obj/structure/mortar_launcher_structure/M = new(get_turf(user)) //Make a new one here.
	M.dir = user.dir
	switch(M.dir)
		if(EAST)
			user.pixel_x -= 5
		if(WEST)
			user.pixel_x += 5
		if(NORTH)
			user.pixel_y -= 5
		if(SOUTH)
			user.pixel_y += 5
			M.plane = ABOVE_HUMAN_PLANE
	deployed = TRUE
	playsound(src, 'sound/weapons/mortar_deploy.ogg', 100, FALSE)
	update_icon(user)

/obj/item/mortar_launcher/proc/pack_up_mortar(mob/user)
	user.visible_message("[user] packs up the [src]")
	for(var/obj/structure/mortar_launcher_structure/M in user.loc)
		switch(M.dir)//Set our offset back to normal.
			if(EAST)
				user.pixel_x += 5
			if(WEST)
				user.pixel_x -= 5
			if(NORTH)
				user.pixel_y += 5
			if(SOUTH)
				user.pixel_y -= 5
		qdel(M) //Delete the mortar structure.
	deployed = FALSE
	update_icon(user)

/obj/item/mortar_launcher/dropped(mob/user)
	. = ..()
	if(deployed)
		pack_up_mortar(user)

/obj/structure/mortar_launcher_structure //That thing that's created when you place down your mortar, purely for looks.
	name = "Deployed HE Trench Ender"
	icon = 'icons/obj/items/mortars.dmi'
	icon_state = "mortar_tube_structure"
	anchored = TRUE //No moving this around please.

/obj/structure/mortar_launcher_structure/CanPass(atom/movable/mover, turf/target, height, air_group)//Humans cannot pass cross this thing in any way shape or form.
	if(ishuman(mover))
		return FALSE

/obj/structure/mortar_launcher_structure/CheckExit(atom/movable/O, turf/target)//Humans can't leave this thing either.
	if(ishuman(O))
		return FALSE