/obj/item/projectile/ion
	name = "ion bolt"
	icon_state = "ion"
	fire_sound = 'sound/weapons/Laser.ogg'
	damage = 0
	damage_type = BURN
	nodamage = 1
	check_armour = "energy"
	var/heavy_effect_range = 1
	var/light_effect_range = 2

	on_impact(var/atom/A)
		empulse(A, heavy_effect_range, light_effect_range)
		return 1

/obj/item/projectile/ion/small
	name = "ion pulse"
	heavy_effect_range = 0
	light_effect_range = 1

/obj/item/projectile/bullet/gyro
	name ="explosive bolt"
	icon_state= "bolter"
	damage = 50
	check_armour = "bullet"
	sharp = 1
	edge = 1

	on_hit(var/atom/target, var/blocked = 0)
		explosion(target, -1, 0, 2)
		return 1

/obj/item/projectile/meteor
	name = "meteor"
	icon = 'icons/obj/meteor.dmi'
	icon_state = "smallf"
	damage = 0
	damage_type = BRUTE
	nodamage = 1
	check_armour = "bullet"

	Bump(atom/A as mob|obj|turf|area)
		if(A == firer)
			loc = A.loc
			return

		sleep(-1) //Might not be important enough for a sleep(-1) but the sleep/spawn itself is necessary thanks to explosions and metoerhits

		if(src)//Do not add to this if() statement, otherwise the meteor won't delete them
			if(A)

				A.ex_act(2)
				playsound(src.loc, 'sound/effects/meteorimpact.ogg', 40, 1)

				for(var/mob/M in range(10, src))
					if(!M.stat && !istype(M, /mob/living/silicon/ai))\
						shake_camera(M, 3, 1)
				qdel(src)
				return 1
		else
			return 0


/obj/item/projectile/beam/mindflayer
	name = "flayer ray"

	on_hit(var/atom/target, var/blocked = 0)
		if(ishuman(target))
			var/mob/living/carbon/human/M = target
			M.confused += rand(5,8)

/obj/item/projectile/chameleon
	name = "bullet"
	icon_state = "bullet"
	damage = 1 // stop trying to murderbone with a fake gun dumbass!!!
	embed = 0 // nope
	nodamage = 1
	damage_type = PAIN
	muzzle_type = /obj/effect/projectile/bullet/muzzle

/obj/item/projectile/fire_spray
	name = "fire"
	icon_state = "fire"
	damage = 0 //It catches stuff on fire and doesn't actually do damage.
	muzzle_type = /obj/effect/projectile/bullet/muzzle

	Bump(atom/A as mob|obj|turf|area)
		if(ishuman(A))
			var/mob/living/carbon/human/H = A
			H.adjust_fire_stacks(50)
			H.IgniteMob()

/obj/item/projectile/flamer
	name = "fire"
	icon_state = "flame"
	damage = 3
	range =  5//Very short range.
	damage_type = BURN
	mob_hit_sound = list('sound/effects/fire.ogg')
	speed = 0.8

/obj/item/projectile/flamer/on_hit(var/atom/target, var/blocked = 0)
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(!istype(H.wear_suit, /obj/item/clothing/suit/fire))
			H.adjust_fire_stacks(50)
			H.IgniteMob()
		new /obj/flamer_fire(H.loc, 12, 10, "red", 1)
		if(H.isChild())
			var/mob/living/carbon/human/F = firer
			F.unlock_achievement(new/datum/achievement/child_fire())


//Create a flame sprite object. Doesn't work like regular fire, ie. does not affect atmos or heat
/obj/flamer_fire
	name = "fire"
	desc = "Ouch!"
	anchored = 1
	mouse_opacity = 0
	icon = 'icons/effects/fire.dmi'
	icon_state = "red_2"
	layer = BELOW_OBJ_LAYER
	var/firelevel = 12 //Tracks how much "fire" there is. Basically the timer of how long the fire burns
	var/burnlevel = 10 //Tracks how HOT the fire is. This is basically the heat level of the fire and determines the temperature.
	var/flame_color = "red"

/obj/flamer_fire/New(loc, fire_lvl, burn_lvl, f_color, fire_spread_amount)
	..()
	if(istype(loc, /turf/simulated/floor/exoplanet/water/shallow))//No catching the water on fire.
		qdel(src)
	playsound(src, "sound/effects/fire.ogg", 50, FALSE)
	if (f_color)
		flame_color = f_color

	icon_state = "[flame_color]_2"
	if(fire_lvl) firelevel = fire_lvl
	if(burn_lvl) burnlevel = burn_lvl
	START_PROCESSING(SSobj,src)

	if(fire_spread_amount > 0)
		var/turf/T
		for(var/dirn in GLOB.cardinal)
			T = get_step(loc, dirn)
			if(istype(T,/turf/simulated/floor/exoplanet/water/shallow)) continue//Do not light the water on fire please.
			if(locate(/obj/flamer_fire) in T) continue //No stacking
			var/new_spread_amt = T.density ? 0 : fire_spread_amount - 1 //walls stop the spread
			if(new_spread_amt)
				for(var/obj/O in T)
					if(!O.CanPass(src, loc))
						new_spread_amt = 0
						break
			spawn(0) //delay so the newer flame don't block the spread of older flames
				new /obj/flamer_fire(T, fire_lvl, burn_lvl, f_color, new_spread_amt)


/obj/flamer_fire/Destroy()
	set_light(0)
	STOP_PROCESSING(SSobj,src)
	. = ..()


/obj/flamer_fire/Crossed(mob/living/M) //Only way to get it to reliable do it when you walk into it.
	if(istype(M))
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(istype(H.wear_suit, /obj/item/clothing/suit/fire))
				return
		M.adjust_fire_stacks(burnlevel) //Make it possible to light them on fire later.
		if (prob(firelevel + 2*M.fire_stacks)) //the more soaked in fire you are, the likelier to be ignited
			M.IgniteMob()

		M.adjustFireLoss(round(burnlevel*0.5)) //This makes fire stronk.


/obj/flamer_fire/proc/updateicon()
	if(burnlevel < 15)
		color = "#c1c1c1" //make it darker to make show its weaker.
	switch(firelevel)
		if(1 to 9)
			icon_state = "[flame_color]_1"
			set_light(2)
		if(10 to 25)
			icon_state = "[flame_color]_2"
			set_light(4)
		if(25 to INFINITY) //Change the icons and luminosity based on the fire's intensity
			icon_state = "[flame_color]_3"
			set_light(6)


/obj/flamer_fire/Process()
	var/turf/T = loc
	firelevel = max(0, firelevel)
	if(!istype(T)) //Is it a valid turf? Has to be on a floor
		qdel(src)
		return

	updateicon()

	if(!firelevel)
		qdel(src)
		return

	var/j = 0
	for(var/i in loc)
		if(++j >= 11) break
		if(isliving(i))
			var/mob/living/I = i
			if(istype(I,/mob/living/carbon/human))
				var/mob/living/carbon/human/M = I
				if(istype(M.wear_suit, /obj/item/clothing/suit/fire))
					continue
			I.adjust_fire_stacks(burnlevel) //If i stand in the fire i deserve all of this. Also Napalm stacks quickly.
			I.IgniteMob()

	//This has been made a simple loop, for the most part flamer_fire_act() just does return, but for specific items it'll cause other effects.
	firelevel -= 2 //reduce the intensity by 2 per tick
	return