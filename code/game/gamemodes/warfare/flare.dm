// FLARES

/obj/item/warflare
	name = "warflare"
	desc = "A standard-issue warflare. There are instructions on the side reading 'pull cord, make light'."
	w_class = ITEM_SIZE_TINY
	var/brightness_on = 8 // Pretty bright.
	light_power = 3
	light_color = COLOR_RED_LIGHT
	icon = 'icons/obj/lighting.dmi'
	icon_state = "rflare"
	item_state = "flare"
	var/on = FALSE
	var/activation_sound = 'sound/effects/flare.ogg'
	var/used = FALSE

/obj/item/warflare/blue
	icon_state = "bflare"
	item_state = "blueflare"
	light_color = COLOR_BLUE_LIGHT

/obj/item/warflare/Initialize()
	. = ..()
	update_icon()
	
/obj/item/warflare/update_icon() //Copied and pasted, kinda gross, but I don't really care to make all lighting objects overlay based. Maybe some other time. ~Chaoko
	overlays = overlays.Cut()
	if(on)
		set_light(brightness_on, light_power, light_color)
		overlays += overlay_image(icon, "[icon_state]-fire")
	else
		if(used)
			overlays += overlay_image(icon, "burnt")
		else
			overlays += overlay_image(icon, "[icon_state]-ring")
		set_light(0)

/obj/item/warflare/proc/turn_off()
	on = 0
	update_icon()

/obj/item/warflare/attack_self(mob/user)
	if(turn_on(user))
		user.visible_message("<span class='notice'>\The [user] activates \the [src].</span>", "<span class='notice'>FFFFFFSHHSHSHSHSHSHHH</span>")
		playsound(src.loc, activation_sound, 75, 1)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.throw_mode_on()


/obj/item/warflare/proc/turn_on(var/mob/user)
	if(on)
		return FALSE
	if(used)
		if(user)
			to_chat(user, "<span class='notice'>It's out of fuel.</span>")
		return FALSE
	on = TRUE
	update_icon()
	
	addtimer(CALLBACK(src, .turn_off), rand(6 MINUTE, 10 MINUTES) )
	used = 1
	return 1

/obj/item/ammo_box/flares
	name = "warflare pouch"
	desc = "Filled with warflares. They light the night, and the fires. Holds three. Only accepts your side's flares."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "flarepack"
	handful_type = /obj/item/warflare
	max_stacks = 4
	handful_verb = "warflare"
	slot_flags = SLOT_BELT
	var/flaretype = "r"

/obj/item/ammo_box/flares/blue
	flaretype = "b"
	handful_type = /obj/item/warflare/blue

//Build flare icon on new. Updates every time it's opened anyway.
/obj/item/ammo_box/flares/update_icon()
	overlays = overlays.Cut()
	overlays += overlay_image(icon, "[flaretype]flare-[stored_handfuls.len]")
