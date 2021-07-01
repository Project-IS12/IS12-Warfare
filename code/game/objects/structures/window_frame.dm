
#define HALF_HEALTH 80
//I'm feeling really bad of copypasting alot of existing code
/obj/structure/window_frame
	name = "window"
	density = 1
	anchored = 1
	opacity = 0
	icon = 'icons/obj/cs.dmi'
	icon_state = "window1"
	layer = SIDE_WINDOW_LAYER
	var/maximal_heat = T0C + 100
	var/damage_per_fire_tick = 2.0
	var/maxhealth = 160.0
	var/health
	var/glass = TRUE
	var/shattered = FALSE
	atmos_canpass = CANPASS_PROC

/obj/structure/window_frame/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	return !glass

/obj/structure/window_frame/examine(mob/user)
	. = ..(user)

	if(health == maxhealth)
		to_chat(user, "<span class='notice'>It looks intact.</span>")
	else
		if(health <= HALF_HEALTH)
			to_chat(user, "<span class='notice'>It has a lots of cracks.</span>")

/obj/structure/window_frame/proc/take_damage(var/damage = 0,  var/sound_effect = 1)
	if(!glass)
		return
	health = max(0, health - damage)

	if(health <= 0)
		shatter()
	else
		if(sound_effect)
			playsound(loc, 'sound/effects/Glasshit.ogg', 100, 1)
		if(health <= HALF_HEALTH)
			update_icon()
	return

/obj/structure/window_frame/proc/shatter(var/display_message = 1)
	if(!glass)
		return
	playsound(src, "shatter", 70, 1)
	if(display_message)
		visible_message("[src] shatters!")

	cast_new(/obj/item/material/shard, 1, loc)
	cast_new(/obj/item/stack/rods, 1, loc)
	glass = FALSE
	shattered = TRUE
	update_icon()
	update_nearby_tiles()
	return

/obj/structure/window_frame/bullet_act(var/obj/item/projectile/Proj)

	var/proj_damage = Proj.get_structure_damage()
	if(!proj_damage) return

	..()
	take_damage(proj_damage)
	return

/obj/structure/window_frame/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			shatter(0)
			return
		if(3.0)
			if(prob(50))
				shatter(0)
				return
			else
				take_damage(100)
				return

/obj/structure/window_frame/hitby(AM as mob|obj)
	..()
	visible_message("<span class='danger'>[src] was hit by [AM].</span>")
	var/tforce = 0
	if(ismob(AM)) // All mobs have a multiplier and a size according to mob_defines.dm
		var/mob/I = AM
		tforce = I.mob_size * 2 * I.throw_multiplier
	else if(isobj(AM))
		var/obj/item/I = AM
		tforce = I.throwforce
	take_damage(tforce)

/obj/structure/window_frame/attack_tk(mob/user as mob)
	user.visible_message("<span class='notice'>Something knocks on [src].</span>")
	playsound(loc, 'sound/effects/Glasshit.ogg', 50, 1)

/obj/structure/window_frame/attack_hand(mob/user as mob)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(!glass)
		if(shattered)
			to_chat(usr,"<span class='notice'>You clear broken glass from the frame.</span>")
			var/obj/item/material/shard/S = new
			usr.put_in_hands(S)
			shattered = 0
			update_icon()
		else
			return
	else if (usr.a_intent == I_HURT)
		if (istype(usr,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = usr
			if(H.species.can_shred(H))
				attack_generic(H,25)
				return
		playsound(src.loc, 'sound/effects/glassknock.ogg', 80, 1)
		usr.visible_message("<span class='danger'>\The [usr] bangs against \the [src]!</span>",
							"<span class='danger'>You bang against \the [src]!</span>",
							"You hear a banging sound.")
	else
		playsound(src.loc, 'sound/effects/glassknock.ogg', 80, 1)
		usr.visible_message("[usr.name] knocks on the [src.name].",
							"You knock on the [src.name].",
							"You hear a knocking sound.")
	return

/obj/structure/window_frame/attack_generic(var/mob/user, var/damage)
	if(istype(user))
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(!damage)
		return
	if(damage >= 10)
		visible_message("<span class='danger'>[user] smashes into [src]!</span>")
		take_damage(damage)
	else
		visible_message("<span class='notice'>\The [user] bonks \the [src] harmlessly.</span>")
	return 1

/obj/structure/window_frame/attackby(var/obj/item/W, var/mob/user)
	if(!istype(W))
		return
	if(istype(W, /obj/item/stack/material/glass/reinforced))
		var/obj/item/stack/material/glass/reinforced/R = W
		if(!shattered && !glass)
			if(do_after(user, 10, src, same_direction = 1))
				R.use(5)
				glass = TRUE
				health = maxhealth
				update_icon()
				update_nearby_tiles()
				return
		else
			if(shattered)
				to_chat(usr,"<span class='notice'>I need to remove shards first.</span>")
			if(glass)
				to_chat(usr,"<span class='notice'>There is glass already.</span>")
			return

	if(istype(W, /obj/item/stack/material/glass))
		to_chat(usr,"<span class='notice'>It doesn't fit the frame.</span>")

	if(W.item_flags & ITEM_FLAG_NO_BLUDGEON)
		return

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(W.damtype == BRUTE || W.damtype == BURN)
		hit(W.force)
	else
		playsound(loc, 'sound/effects/Glasshit.ogg', 75, 1)
	..()


/obj/structure/window_frame/proc/hit(var/damage, var/sound_effect = 1)
	take_damage(damage)
	return

/obj/structure/window_frame/New(Loc, start_dir=null, constructed=0)
	..()

	if (start_dir)
		set_dir(start_dir)

	health = maxhealth

/obj/structure/window_frame/Destroy()
	set_density(0)
	update_nearby_tiles()
	. = ..()

/obj/structure/window_frame/update_icon()
	if(glass)
		if(health <= HALF_HEALTH)
			icon_state = "window2"
		else
			icon_state = "window1"
	else
		if(shattered)
			icon_state = "window3"
		else
			icon_state = "window4"
	return

/obj/structure/window_frame/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > maximal_heat)
		hit(damage_per_fire_tick, 0)
	..()
