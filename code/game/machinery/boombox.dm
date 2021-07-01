/obj/item/device/boombox
	name = "Boombox"
	icon = 'icons/obj/boombox.dmi'
	icon_state = "boombox"
	desc = "A smuggled in boombox used with smuggled in cassette tapes to listen to smuggled in tunes."
	var/obj/item/device/cassette/casseta = null
	var/datum/sound_token/sound_token
	var/playing = 0
	var/sound_id
	w_class = ITEM_SIZE_NO_CONTAINER

/obj/item/device/boombox/attack_hand(mob/user as mob)
	if(istype(get_area(user), /area/warfare/battlefield/no_mans_land))//Do not take this into no man's land please.
		to_chat(user, "I can't take that with me into no man's land. Wouldn't want to lose it.")
		return
	else
		..()

/obj/item/device/boombox/New()
	..()
	sound_id = "[type]_[sequential_id(type)]"


/obj/item/device/boombox/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/device/cassette))
		if(casseta)
			to_chat(user, "<span class='warning'>There is already cassette inside.</span>")
			return
		if(!user.unEquip(I))
			return
		I.forceMove(src)
		casseta = I
		visible_message("<span class='notice'>[user] insert cassette into [src].</span>")
		playsound(get_turf(src), 'sound/machines/bominside.ogg', 50, 1)
		return
	..()


/obj/item/device/boombox/MouseDrop(var/obj/over_object)
	if (!over_object || !(ishuman(usr) || issmall(usr)))
		return

	if (!(src.loc == usr))
		return

	switch(over_object.name)
		if("r_hand")
			eject()
		if("l_hand")
			eject()




/obj/item/device/boombox/proc/eject()
	if(usr.incapacitated())
		return
	if(!casseta)
		to_chat(usr, "<span class='warning'>There is no cassette inside.</span>")
		return

	if(playing)
		StopPlaying()
	visible_message("<span class='notice'>[usr] ejects cassette from [src].</span>")
	playsound(get_turf(src), 'sound/machines/bominside.ogg', 50, 1)
	usr.put_in_hands(casseta)
	casseta = null

/obj/item/device/boombox/attack_self(mob/user)
	if(playing)
		StopPlaying()
		playsound(get_turf(src), 'sound/machines/bomclick.ogg', 50, 1)
		return
	else
		StartPlaying()
		playsound(get_turf(src), 'sound/machines/bomclick.ogg', 50, 1)


/obj/item/device/boombox/proc/StopPlaying()
	playing = 0
	QDEL_NULL(sound_token)

/obj/item/device/boombox/proc/StartPlaying()
	StopPlaying()
	if(isnull(casseta))
		return
	if(!casseta.sound_inside)
		return

	sound_token = sound_player.PlayLoopingSound(src, sound_id, casseta.sound_inside, volume = 50, range = 9, falloff = 3, prefer_mute = TRUE, ignore_vis = TRUE)
	playing = 1

/obj/item/device/cassette
	name = "cassette tape"
	desc = "A tape smuggled in from somewhere in the outside world. Contains some bumping tunes on it."
	icon = 'icons/obj/cassette.dmi'
	icon_state = "cassette_0"
	var/sound/sound_inside
	w_class = ITEM_SIZE_TINY
	var/uploader_idiot
	var/current_side = 1
	var/sound/a_side
	var/sound/b_side

/obj/item/device/cassette/New()
	icon_state = "cassette_[rand(0,12)]"

/obj/item/device/cassette/attack_self(mob/user)
	. = ..()
	if(current_side == 1)
		sound_inside = b_side
		current_side = 2
		to_chat(user, "<span class='notice'>You flip the cassette over to the b-side.")
	else
		sound_inside = a_side
		current_side = 1
		to_chat(user, "<span class='notice'>You flip the cassette over to the a-side.")

/obj/item/device/cassette/tape1/New()
	..()
	name = "\"The Outside World\'s Greatest Hits Vol.1\" magn-o-tape"
	a_side = pick('sound/music/boombox1.ogg','sound/music/boombox2.ogg')
	b_side = 'sound/music/boombox3.ogg'
	sound_inside = a_side

/obj/item/device/cassette/tape2/New()
	..()
	name = "\"The Outside World\'s Greatest Hits Vol.2\" magn-o-tape"
	a_side = pick('sound/music/boombox4.ogg', 'sound/music/boombox5.ogg')
	b_side = 'sound/music/boombox6.ogg'
	sound_inside = a_side

/obj/item/device/cassette/tape3/New()
	..()
	name = "\"The Outside World\'s Greatest Hits Vol.3\" magn-o-tape"
	a_side = pick('sound/music/boombox7.ogg', 'sound/music/boombox8.ogg')
	b_side = pick('sound/music/boombox9.ogg', 'sound/music/boombox10.ogg')
	sound_inside = a_side

/obj/item/device/cassette/tape/rare
	name = "rare trenchmas tape"
	a_side = 'sound/music/drip.ogg'
	b_side = 'sound/music/drip.ogg'