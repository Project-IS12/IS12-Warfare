/turf/simulated/wall
	name = "wall"
	desc = "A huge chunk of metal used to seperate rooms."
	icon = 'icons/turf/wall.dmi'
	icon_state = "metal0"
	plane = WALL_PLANE
	opacity = 1
	density = 1
	blocks_air = 1
	var/walltype = "metal"
	thermal_conductivity = WALL_HEAT_TRANSFER_COEFFICIENT
	heat_capacity = 312500 //a little over 5 cm thick , 312500 for 1 m by 2.5 m by 0.25 m plasteel wall
	can_smooth = TRUE
	var/mineral = "metal"
	var/damage = 0
	var/damage_overlay = 0
	var/global/damage_overlays[16]
	var/active
	var/can_open = 0
	var/last_state
	var/integrity = 150
	var/construction_stage
	var/hitsound = 'sound/weapons/Genhit.ogg'
	var/floor_type = /turf/simulated/floor/plating //turf it leaves after destruction


/turf/simulated/wall/New(var/newloc)
	..(newloc)
	icon_state = "blank"
	relativewall_neighbours()
	START_PROCESSING(SSslowprocess, src)
	generate_splines()

/turf/simulated/wall/Destroy()
	STOP_PROCESSING(SSslowprocess, src)
	dismantle_wall(null,null,1)
	. = ..()

// Walls always hide the stuff below them.
/turf/simulated/wall/levelupdate()
	for(var/obj/O in src)
		O.hide(1)

/turf/simulated/wall/protects_atom(var/atom/A)
	var/obj/O = A
	return (istype(O) && O.hides_under_flooring()) || ..()


/turf/simulated/wall/proc/return_material(material_type, times)
	if(!material_type||!times)
		return
	var/obj/structure/girder/newgirder = null
	switch(material_type)
		if("metal")
			newgirder = new /obj/structure/girder/reinforced(src)
			for(var/i=1,i<times,i++)
				new /obj/item/stack/material/steel(src)
		if("reinforced_m")
			newgirder = new /obj/structure/girder/reinforced(src)
			newgirder.reinforce_girder()
			new /obj/item/stack/material/plasteel(src)
			for(var/i=1,i<times,i++)
				new /obj/item/stack/material/steel(src)

	if(newgirder)
		transfer_fingerprints_to(newgirder)

/turf/simulated/wall/proc/is_reinf()
	if(walltype == "rwall")
		return 1
	return 0

/turf/simulated/wall/bullet_act(var/obj/item/projectile/Proj)
	var/p_x = Proj.p_x + pick(0,0,0,0,0,-1,1) // really ugly way of coding "sometimes offset Proj.p_x!"
	var/p_y = Proj.p_y + pick(0,0,0,0,0,-1,1)
	var/decaltype = 1 // 1 - scorch, 2 - bullet
	var/proj_damage = Proj.get_structure_damage()

	if(is_reinf())
		if(Proj.damage_type == BURN)
			proj_damage /= 10
		else if(Proj.damage_type == BRUTE)
			proj_damage /= 8

	//cap the amount of damage, so that things like emitters can't destroy walls in one hit.
	var/damage = min(proj_damage, 100)

	var/obj/effect/overlay/bmark/BM = new(src)

	BM.pixel_x = p_x
	BM.pixel_y = p_y

	//new /obj/effect/overlay/temp/bullet_impact(src)//, p_x, p_y)

	if(decaltype == 1)
		// Energy weapons are hot. they scorch!

		// offset correction
		BM.pixel_x--
		BM.pixel_y--

		new /obj/effect/overlay/temp/bullet_impact(src, BM.pixel_x, BM.pixel_y)

		if(Proj.damage >= 20 || istype(Proj, /obj/item/projectile/beam/practice))
			BM.icon_state = "dent"//"scorch"
			BM.set_dir(pick(NORTH,SOUTH,EAST,WEST)) // random scorch design
		else
			BM.icon_state = "scorch"//"light_scorch"
	else

		// Bullets are hard. They make dents!
		BM.icon_state = "dent"


	take_damage(damage)

	return

/turf/simulated/wall/hitby(AM as mob|obj, var/speed=THROWFORCE_SPEED_DIVISOR)
	..()
	if(ismob(AM))
		return

	var/tforce = AM:throwforce * (speed/THROWFORCE_SPEED_DIVISOR)
	if (tforce < 15)
		return

	take_damage(tforce)

/turf/simulated/wall/proc/clear_plants()
	for(var/obj/effect/overlay/wallrot/WR in src)
		qdel(WR)
	for(var/obj/effect/vine/plant in range(src, 1))
		if(!plant.floor) //shrooms drop to the floor
			plant.floor = 1
			plant.update_icon()
			plant.pixel_x = 0
			plant.pixel_y = 0
		plant.update_neighbors()

/turf/simulated/wall/proc/clear_bulletholes()
	for(var/obj/effect/overlay/bmark/BM in src)
		qdel(BM)

/turf/simulated/wall/ChangeTurf(var/newtype)
	clear_plants()
	clear_bulletholes()
	return ..(newtype)

//Appearance
/turf/simulated/wall/examine(mob/user)
	. = ..(user)

	if(!damage)
		to_chat(user, "<span class='notice'>It looks fully intact.</span>")
	else
		var/dam = damage/150
		if(is_reinf())
			dam = damage/400
		if(dam <= 0.3)
			to_chat(user, "<span class='warning'>It looks slightly damaged.</span>")
		else if(dam <= 0.6)
			to_chat(user, "<span class='warning'>It looks moderately damaged.</span>")
		else
			to_chat(user, "<span class='danger'>It looks heavily damaged.</span>")

	if(locate(/obj/effect/overlay/wallrot) in src)
		to_chat(user, "<span class='warning'>There is fungus growing on [src].</span>")

//Damage

/turf/simulated/wall/melt()

	if(!can_melt())
		return

	src.ChangeTurf(/turf/simulated/floor/plating)

	var/turf/simulated/floor/F = src
	if(!F)
		return
	F.burn_tile()
	F.icon_state = "wall_thermite"
	visible_message("<span class='danger'>\The [src] spontaneously combusts!.</span>") //!!OH SHIT!!
	return

/turf/simulated/wall/proc/take_damage(dam)
	if(dam)
		damage = max(0, damage + dam)
		update_damage()
	return


/turf/simulated/wall/proc/update_damage()
	var/cap = integrity
	if(is_reinf())
		cap += 130

	if(locate(/obj/effect/overlay/wallrot) in src)
		cap = cap / 10

	if(damage >= cap)
		dismantle_wall()
	else
		update_icon()

	return


/turf/simulated/wall/adjacent_fire_act(turf/simulated/floor/adj_turf, datum/gas_mixture/adj_air, adj_temp, adj_volume)
	if(adj_temp > 1200)
		take_damage(log(RAND_F(0.9, 1.1) * (adj_temp - 1200)))

	return ..()

/turf/simulated/wall/proc/dismantle_wall(var/devastated, var/explode, var/no_product)

	playsound(src, 'sound/items/Welder.ogg', 100, 1)
	return_material(mineral, rand(1,2))
	for(var/obj/O in src.contents) //Eject contents!
		if(istype(O,/obj/structure/sign/poster))
			var/obj/structure/sign/poster/P = O
			P.roll_and_drop(src)
		else
			O.forceMove(src)

	clear_plants()
	clear_bulletholes()

	ChangeTurf(floor_type)

/turf/simulated/wall/ex_act(severity)
	switch(severity)
		if(1.0)
			src.ChangeTurf(get_base_turf(src.z))
			return
		if(2.0)
			if(prob(75))
				take_damage(rand(150, 250))
			else
				dismantle_wall(1,1)
		if(3.0)
			take_damage(rand(0, 250))
		else
	return

// Wall-rot effect, a nasty fungus that destroys walls.
/turf/simulated/wall/proc/rot()
	if(locate(/obj/effect/overlay/wallrot) in src)
		return
	var/number_rots = rand(2,3)
	for(var/i=0, i<number_rots, i++)
		new/obj/effect/overlay/wallrot(src)

/turf/simulated/wall/proc/can_melt()
	if(is_reinf())
		return 0
	return 1

/turf/simulated/wall/proc/thermitemelt(mob/user as mob)
	if(!can_melt())
		return
	var/obj/effect/overlay/O = new/obj/effect/overlay( src )
	O.SetName("Thermite")
	O.desc = "Looks hot."
	O.icon = 'icons/effects/fire.dmi'
	O.icon_state = "2"
	O.anchored = 1
	O.set_density(1)
	O.plane = LIGHTING_PLANE
	O.layer = FIRE_LAYER

	src.ChangeTurf(/turf/simulated/floor/plating)

	var/turf/simulated/floor/F = src
	F.burn_tile()
	F.icon_state = "wall_thermite"
	to_chat(user, "<span class='warning'>The thermite starts melting through the wall.</span>")

	spawn(100)
		if(O)
			qdel(O)
	return

/*/turf/simulated/wall/proc/radiate()
	var/total_radiation = material.radioactivity + (reinf_material ? reinf_material.radioactivity / 2 : 0)
	if(!total_radiation)
		return

	radiation_repository.radiate(src, total_radiation)
	return total_radiation
*/
/turf/simulated/wall/proc/burn(temperature)
	new /obj/structure/girder(src)
	src.ChangeTurf(/turf/simulated/floor)
	for(var/turf/simulated/wall/W in range(3,src))
		W.burn((temperature/4))
	for(var/obj/machinery/door/airlock/phoron/D in range(3,src))
		D.ignite(temperature/4)
