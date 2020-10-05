// simulated/floor is currently plating by default, but there really should be an explicit plating type.
/turf/simulated/floor/plating
	name = "plating"
	icon = 'icons/turf/flooring/plating.dmi'
	icon_state = "plating"
	plane = PLATING_PLANE
	layer = PLATING_LAYER

/turf/simulated/floor/plating/AltClick(var/mob/user)
	if(CanPhysicallyInteract(user))
		if(istype(user.get_active_hand(), /obj/item/stack/rods))
			var/obj/item/stack/rods/R = user.get_active_hand()
			visible_message("<span class='notice'>[user] has started place reinforced plating!</span>")
			if(R.get_amount() > 10)
				if(do_after(user, 10 SECONDS))
					R.use(10)
					ChangeTurf(/turf/simulated/floor/plating/reinforced)


/turf/simulated/floor/plating/reinforced
	name = "reinforced plating"
	icon = 'icons/turf/flooring/decals.dmi'
	icon_state = "shaft-ready"
	var/image/lattice_overlay
	var/reinforced_stage = 1

/turf/simulated/floor/plating/reinforced/New()
	..()
	icon_state = "shaft"
	lattice_overlay = image(icon ='icons/obj/structures.dmi',icon_state ="latticefull")
	lattice_overlay.layer = CATWALK_LAYER
	//lattice_overlay.plane = ABOVE_TURF_PLANE
	overlays += lattice_overlay

/turf/simulated/floor/plating/reinforced/attackby(obj/item/C as obj, mob/user as mob)
	if(isWelder(C) && reinforced_stage == 1)
		var/obj/item/weldingtool/welder = C
		if(welder.isOn())
			visible_message("<span class='notice'>[user] start to unweld lattice from [src]!</span>")
			if(do_after(user, 15 SECONDS) && welder.isOn())
				to_chat(user, "<span class='notice'>You unweld lattice from plating.</span>")
				playsound(src, 'sound/items/Welder.ogg', 80, 1)
				overlays.Cut()
				reinforced_stage++
	if(isCrowbar(C) && reinforced_stage == 2)
		visible_message("<span class='notice'>[user] start to pry off [src.name] from floor!</span>")
		playsound(src, 'sound/items/Crowbar.ogg', 80, 1)
		if(do_after(user, 10 SECONDS))
			playsound(src, 'sound/items/Crowbar.ogg', 80, 1)
			new /obj/item/stack/rods(src.loc)
			ChangeTurf(/turf/simulated/floor/plating)


/turf/simulated/floor/bluegrid
	name = "mainframe floor"
	icon = 'icons/turf/flooring/circuit.dmi'
	icon_state = "bcircuit"
	initial_flooring = /decl/flooring/reinforced/circuit
	light_range = 2
	light_power = 3
	light_color = COLOR_BLUE

/turf/simulated/floor/bluegrid/airless
	initial_gas = null

/turf/simulated/floor/greengrid
	name = "mainframe floor"
	icon = 'icons/turf/flooring/circuit.dmi'
	icon_state = "gcircuit"
	initial_flooring = /decl/flooring/reinforced/circuit/green
	light_range = 2
	light_power = 3
	light_color = COLOR_GREEN

/turf/simulated/floor/blackgrid
	name = "mainframe floor"
	icon = 'icons/turf/flooring/circuit.dmi'
	icon_state = "rcircuit"
	initial_flooring = /decl/flooring/reinforced/circuit/red
	light_range = 2
	light_power = 2
	light_color = COLOR_RED

/turf/simulated/floor/greengrid/airless
	initial_gas = null

/turf/simulated/floor/wood
	name = "wooden floor"
	icon = 'icons/turf/flooring/wood.dmi'
	icon_state = "wood"
	initial_flooring = /decl/flooring/wood

/turf/simulated/floor/grass
	name = "grass patch"
	icon = 'icons/turf/flooring/grass.dmi'
	icon_state = "grass0"
	initial_flooring = /decl/flooring/grass

/turf/simulated/floor/diona
	name = "biomass"
	icon = 'icons/turf/floors.dmi'
	initial_flooring = /decl/flooring/diona

/turf/simulated/floor/tiled
	name = "steel floor"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "steel"
	initial_flooring = /decl/flooring/tiling

/turf/simulated/floor/carpet
	name = "brown carpet"
	icon = 'icons/turf/flooring/carpet.dmi'
	icon_state = "brown"
	initial_flooring = /decl/flooring/carpet

/turf/simulated/floor/carpet/blue
	name = "blue carpet"
	icon_state = "blue1"
	initial_flooring = /decl/flooring/carpet/blue

/turf/simulated/floor/carpet/blue2
	name = "pale blue carpet"
	icon_state = "blue2"
	initial_flooring = /decl/flooring/carpet/blue2

/turf/simulated/floor/carpet/purple
	name = "purple carpet"
	icon_state = "purple"
	initial_flooring = /decl/flooring/carpet/purple

/turf/simulated/floor/carpet/orange
	name = "orange carpet"
	icon_state = "orange"
	initial_flooring = /decl/flooring/carpet/orange

/turf/simulated/floor/carpet/green
	name = "green carpet"
	icon_state = "green"
	initial_flooring = /decl/flooring/carpet/green

/turf/simulated/floor/carpet/red
	name = "red carpet"
	icon_state = "red"
	initial_flooring = /decl/flooring/carpet/red

/turf/simulated/floor/reinforced
	name = "reinforced floor"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "reinforced"
	initial_flooring = /decl/flooring/reinforced

/turf/simulated/floor/reinforced/airless
	initial_gas = null

/turf/simulated/floor/reinforced/airmix
	initial_gas = list("oxygen" = MOLES_O2ATMOS, "nitrogen" = MOLES_N2ATMOS)

/turf/simulated/floor/reinforced/nitrogen
	initial_gas = list("nitrogen" = ATMOSTANK_NITROGEN)

/turf/simulated/floor/reinforced/hydrogen
	initial_gas = list("hydrogen" = ATMOSTANK_HYDROGEN)

/turf/simulated/floor/reinforced/oxygen
	initial_gas = list("oxygen" = ATMOSTANK_OXYGEN)

/turf/simulated/floor/reinforced/phoron
	initial_gas = list("phoron" = ATMOSTANK_PHORON)

/turf/simulated/floor/reinforced/nitrogen/engine
	name = "engine floor"
	initial_gas = list("nitrogen" = MOLES_N2STANDARD)

/turf/simulated/floor/reinforced/phoron/fuel
	initial_gas = list("phoron" = ATMOSTANK_PHORON_FUEL)

/turf/simulated/floor/reinforced/hydrogen
	initial_gas = list("hydrogen" = ATMOSTANK_HYDROGEN)

/turf/simulated/floor/reinforced/hydrogen/fuel
	initial_gas = list("hydrogen" = ATMOSTANK_HYDROGEN_FUEL)

/turf/simulated/floor/reinforced/carbon_dioxide
	initial_gas = list("carbon_dioxide" = ATMOSTANK_CO2)

/turf/simulated/floor/reinforced/n20
	initial_gas = list("sleeping_agent" = ATMOSTANK_NITROUSOXIDE)


/turf/simulated/floor/cult
	name = "engraved floor"
	icon = 'icons/turf/flooring/cult.dmi'
	icon_state = "cult"
	initial_flooring = /decl/flooring/reinforced/cult

/turf/simulated/floor/cult/cultify()
	return

/turf/simulated/floor/tiled/dark
	name = "dark floor"
	icon_state = "dark"
	initial_flooring = /decl/flooring/tiling/dark

/turf/simulated/floor/tiled/dark/airless
	initial_gas = null

/turf/simulated/floor/tiled/white
	name = "white floor"
	icon_state = "white"
	initial_flooring = /decl/flooring/tiling/white

/turf/simulated/floor/tiled/freezer
	name = "tiles"
	icon_state = "freezer"
	initial_flooring = /decl/flooring/tiling/freezer

/turf/simulated/floor/lino
	name = "lino"
	icon = 'icons/turf/flooring/linoleum.dmi'
	icon_state = "lino"
	initial_flooring = /decl/flooring/linoleum

/turf/simulated/floor/tiled/ramp
	name = "foot ramp"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "ramptop"
	initial_flooring = /decl/flooring/reinforced/ramp

/turf/simulated/floor/tiled/ramp/bottom
	name = "foot ramp"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "rampbot"
	initial_flooring = /decl/flooring/reinforced/ramp/bottom

/turf/simulated/floor/plating/n2floor
	name = "floor with low ceiling"
	icon_state = "n2floor"
	desc = "There is low ceiling here!"

/turf/simulated/floor/plating/n2floor/Enter(var/atom/movable/A)
	..()
	if(ishuman(A))
		var/mob/living/carbon/human/L = A
		var/turf/Above = GetAbove(src)
		if(L.isChild())
			return 1
		if(!L.resting && !istype(Above, /turf/simulated/open))
			to_chat(L, "This passage is too low. I need to lie down.")
			return 0
		return 1

//ATMOS PREMADES
/turf/simulated/floor/reinforced/airless
	name = "vacuum floor"
	initial_gas = null
	temperature = TCMB

/turf/simulated/floor/airless
	name = "airless plating"
	initial_gas = null
	temperature = TCMB

/turf/simulated/floor/tiled/airless
	name = "airless floor"
	initial_gas = null
	temperature = TCMB

/turf/simulated/floor/bluegrid/airless
	name = "airless floor"
	initial_gas = null
	temperature = TCMB

/turf/simulated/floor/greengrid/airless
	name = "airless floor"
	initial_gas = null
	temperature = TCMB

/turf/simulated/floor/greengrid/nitrogen
	initial_gas = list("nitrogen" = MOLES_N2STANDARD)

/turf/simulated/floor/tiled/white/airless
	name = "airless floor"
	initial_gas = null
	temperature = TCMB

// Placeholders
/turf/simulated/floor/airless/lava
	name = "lava"
	icon = 'icons/turf/flooring/lava.dmi'
	icon_state = "lava"

/turf/simulated/floor/ice
	name = "ice"
	icon = 'icons/turf/snow.dmi'
	icon_state = "ice"

/turf/simulated/floor/snow
	name = "snow"
	icon = 'icons/turf/snow.dmi'
	icon_state = "snow"

/turf/simulated/floor/snow/New()
	icon_state = pick("snow[rand(1,12)]","snow0")
	..()


/turf/simulated/floor/light
/turf/simulated/floor/airless/ceiling

/turf/simulated/floor/beach
	name = "beach"
	icon = 'icons/misc/beach.dmi'

/turf/simulated/floor/beach/sand
	name = "sand"
	icon_state = "sand"

/turf/simulated/floor/beach/sand/desert
	icon_state = "desert"
	has_resources = 1

/turf/simulated/floor/beach/sand/desert/New()
	icon_state = "desert[rand(0,5)]"
	..()

/turf/simulated/floor/beach/coastline
	name = "coastline"
	icon = 'icons/misc/beach2.dmi'
	icon_state = "sandwater"

/turf/simulated/floor/beach/water
	name = "water"
	icon_state = "water"

/turf/simulated/floor/beach/water/update_dirt()
	return	// Water doesn't become dirty

/turf/simulated/floor/beach/water/ocean
	icon_state = "seadeep"

/turf/simulated/floor/beach/water/New()
	..()
	overlays += image("icon"='icons/misc/beach.dmi',"icon_state"="water5","layer"=BASE_MOB_LAYER+0.1)
