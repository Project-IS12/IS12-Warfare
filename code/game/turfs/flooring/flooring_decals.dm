// These are objects that destroy themselves and add themselves to the
// decal list of the floor under them. Use them rather than distinct icon_states
// when mapping in interesting floor designs.
var/list/floor_decals = list()

/obj/effect/floor_decal
	name = "floor decal"
	icon = 'icons/turf/flooring/decals.dmi'
	layer = DECAL_LAYER
	plane = ABOVE_TURF_PLANE
	var/supplied_dir

/obj/effect/floor_decal/New(var/newloc, var/newdir, var/newcolour)
	supplied_dir = newdir
	if(newcolour) color = newcolour
	layer = BASE_TURF_LAYER + 0.01
	plane = null
	..(newloc)

/obj/effect/floor_decal/Initialize()
	if(supplied_dir) set_dir(supplied_dir)
	var/turf/T = get_turf(src)
	if(istype(T, /turf/simulated/floor) || istype(T, /turf/unsimulated/floor))
		var/cache_key = "[alpha]-[color]-[dir]-[icon_state]-[layer]"
		if(!floor_decals[cache_key])
			var/image/I = image(icon = src.icon, icon_state = src.icon_state, dir = src.dir)
			I.color = src.color
			I.alpha = src.alpha
			floor_decals[cache_key] = I
		if(!T.decals) T.decals = list()
		T.decals |= floor_decals[cache_key]
		T.overlays |= floor_decals[cache_key]
	initialized = TRUE
	return INITIALIZE_HINT_QDEL

/obj/effect/floor_decal/reset
	name = "reset marker"

/obj/effect/floor_decal/reset/Initialize()
	var/turf/T = get_turf(src)
	T.remove_decals()
	T.update_icon()
	initialized = TRUE
	return INITIALIZE_HINT_QDEL

/obj/effect/floor_decal/carpet
	name = "brown carpet"
	icon = 'icons/turf/flooring/carpet.dmi'
	icon_state = "brown_edges"

/obj/effect/floor_decal/carpet/blue
	name = "blue carpet"
	icon_state = "blue1_edges"

/obj/effect/floor_decal/carpet/blue2
	name = "pale blue carpet"
	icon_state = "blue2_edges"

/obj/effect/floor_decal/carpet/purple
	name = "orange carpet"
	icon_state = "purple_edges"

/obj/effect/floor_decal/carpet/orange
	name = "orange carpet"
	icon_state = "orange_edges"

/obj/effect/floor_decal/carpet/green
	name = "green carpet"
	icon_state = "green_edges"

/obj/effect/floor_decal/carpet/red
	name = "red carpet"
	icon_state = "red_edges"

/obj/effect/floor_decal/carpet/corners
	name = "brown carpet"
	icon_state = "brown_corners"

/obj/effect/floor_decal/carpet/blue/corners
	name = "blue carpet"
	icon_state = "blue1_corners"

/obj/effect/floor_decal/carpet/blue2/corners
	name = "pale blue carpet"
	icon_state = "blue2_corners"

/obj/effect/floor_decal/carpet/purple/corners
	name = "purple carpet"
	icon_state = "purple_corners"

/obj/effect/floor_decal/carpet/orange/corners
	name = "orange carpet"
	icon_state = "orange_corners"

/obj/effect/floor_decal/carpet/green/corners
	name = "green carpet"
	icon_state = "green_corners"

/obj/effect/floor_decal/carpet/red/corners
	name = "red carpet"
	icon_state = "red_corners"

/obj/effect/floor_decal/corner
	icon_state = "corner_white"
	alpha = 229

/obj/effect/floor_decal/corner/black
	name = "black corner"
	color = "#333333"

/obj/effect/floor_decal/corner/black/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/black/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/floor_decal/corner/blue
	name = "blue corner"
	color = COLOR_BLUE_GRAY

/obj/effect/floor_decal/corner/blue/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/blue/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/floor_decal/corner/paleblue
	name = "pale blue corner"
	color = COLOR_PALE_BLUE_GRAY

/obj/effect/floor_decal/corner/paleblue/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/paleblue/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/floor_decal/corner/cyan
	name = "cyan corner"
	color = "#469085"

/obj/effect/floor_decal/corner/cyan/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/cyan/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/floor_decal/corner/green
	name = "green corner"
	color = COLOR_GREEN_GRAY

/obj/effect/floor_decal/corner/green/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/green/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/floor_decal/corner/dgreen
	name = "dgreen corner"
	color = "#6e8766"

/obj/effect/floor_decal/corner/dgreen/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/dgreen/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/floor_decal/corner/lime
	name = "lime corner"
	color = COLOR_PALE_GREEN_GRAY

/obj/effect/floor_decal/corner/lime/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/lime/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/floor_decal/corner/yellow
	name = "yellow corner"
	color = COLOR_BROWN

/obj/effect/floor_decal/corner/yellow/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/yellow/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/floor_decal/corner/yellow/full
	icon_state = "corner_white_full"

/obj/effect/floor_decal/corner/beige
	name = "beige corner"
	color = COLOR_BEIGE

/obj/effect/floor_decal/corner/beige/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/beige/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/floor_decal/corner/bar
	name = "bar corner"
	color = "#7c443f"

/obj/effect/floor_decal/corner/bar/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/bar/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/floor_decal/corner/red
	name = "red corner"
	color = COLOR_RED_GRAY

/obj/effect/floor_decal/corner/red/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/red/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/floor_decal/corner/red/full
	icon_state = "corner_white_full"

/obj/effect/floor_decal/corner/pink
	name = "pink corner"
	color = COLOR_PALE_RED_GRAY

/obj/effect/floor_decal/corner/pink/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/pink/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/floor_decal/corner/purple
	name = "purple corner"
	color = "#7C507f"

/obj/effect/floor_decal/corner/purple/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/purple/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/floor_decal/corner/mauve
	name = "mauve corner"
	color = COLOR_PALE_PURPLE_GRAY

/obj/effect/floor_decal/corner/mauve/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/mauve/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/floor_decal/corner/orange
	name = "orange corner"
	color = "#d27428"

/obj/effect/floor_decal/corner/orange/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/orange/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/floor_decal/corner/neutral
	name = "neutral corner"
	color = "#b2b0b0"

/obj/effect/floor_decal/corner/neutral/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/neutral/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/floor_decal/corner/brown
	name = "brown corner"
	color = COLOR_DARK_BROWN

/obj/effect/floor_decal/corner/brown/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/brown/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/floor_decal/corner/white
	name = "white corner"
	icon_state = "corner_white"

/obj/effect/floor_decal/corner/white/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/white/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/floor_decal/corner/grey
	name = "grey corner"
	color = "#8d8c8c"

/obj/effect/floor_decal/corner/grey/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/grey/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/floor_decal/spline/plain
	name = "spline - plain"
	icon_state = "spline_plain"
	alpha = 229

/obj/effect/floor_decal/spline/plain/diagonal
	icon_state = "spline_plain_diagonal"

/obj/effect/floor_decal/spline/fancy
	name = "spline - fancy"
	icon_state = "spline_fancy"

/obj/effect/floor_decal/spline/fancy/wood
	name = "spline - wood"
	color = "#cb9e04"

/obj/effect/floor_decal/spline/fancy/wood/corner
	icon_state = "spline_fancy_corner"

/obj/effect/floor_decal/spline/fancy/wood/cee
	icon_state = "spline_fancy_cee"

/obj/effect/floor_decal/spline/fancy/wood/three_quarters
	icon_state = "spline_fancy_full"

/obj/effect/floor_decal/industrial/warning
	name = "hazard stripes"
	icon_state = "warning"

/obj/effect/floor_decal/industrial/warning/corner
	icon_state = "warningcorner"

/obj/effect/floor_decal/industrial/warning/full
	icon_state = "warningfull"

/obj/effect/floor_decal/industrial/warning/cee
	icon_state = "warningcee"

/obj/effect/floor_decal/industrial/warning/dust
	name = "hazard stripes"
	icon_state = "warning_dust"

/obj/effect/floor_decal/industrial/warning/dust/corner
	name = "hazard stripes"
	icon_state = "warningcorner_dust"

/obj/effect/floor_decal/industrial/warning_white
	name = "hazard stripes"
	icon_state = "warning_white"

/obj/effect/floor_decal/industrial/warning_white/corner
	icon_state = "warningcorner_white"

/obj/effect/floor_decal/industrial/warning_white/full
	icon_state = "warningfull_white"

/obj/effect/floor_decal/industrial/warning_white/cee
	icon_state = "warningcee_white"

/obj/effect/floor_decal/industrial/warning_red
	name = "hazard stripes"
	icon_state = "warning_red"

/obj/effect/floor_decal/industrial/warning_red/corner
	icon_state = "warningcorner_red"

/obj/effect/floor_decal/industrial/warning_red/full
	icon_state = "warningfull_red"

/obj/effect/floor_decal/industrial/warning_red/cee
	icon_state = "warningcee_red"

/obj/effect/floor_decal/industrial/hatch
	name = "hatched marking"
	icon_state = "delivery"
	alpha = 229

/obj/effect/floor_decal/industrial/hatch/yellow
	color = "#cfcf55"

/obj/effect/floor_decal/industrial/hatch/red
	color = COLOR_RED_GRAY

/obj/effect/floor_decal/industrial/hatch/orange
	color = COLOR_DARK_ORANGE

/obj/effect/floor_decal/industrial/hatch/blue
	color = COLOR_BLUE_GRAY

/obj/effect/floor_decal/industrial/shutoff
	name = "shutoff valve marker"
	icon_state = "shutoff"

/obj/effect/floor_decal/industrial/outline
	name = "white outline"
	icon_state = "outline"
	alpha = 229

/obj/effect/floor_decal/industrial/outline/blue
	name = "blue outline"
	color = "#00b8b2"

/obj/effect/floor_decal/industrial/outline/yellow
	name = "yellow outline"
	color = "#cfcf55"

/obj/effect/floor_decal/industrial/outline/grey
	name = "grey outline"
	color = "#808080"

/obj/effect/floor_decal/industrial/outline/red
	name = "red outline"
	color = COLOR_RED_GRAY

/obj/effect/floor_decal/industrial/outline/orange
	name = "orange outline"
	color = COLOR_DARK_ORANGE

/obj/effect/floor_decal/industrial/loading
	name = "loading area"
	icon_state = "loadingarea"
	alpha = 229

/obj/effect/floor_decal/plaque
	name = "plaque"
	icon_state = "plaque"

/obj/effect/floor_decal/asteroid
	name = "random asteroid rubble"
	icon_state = "asteroid0"

/obj/effect/floor_decal/asteroid/New()
	icon_state = "asteroid[rand(0,9)]"
	..()

/obj/effect/floor_decal/chapel
	name = "chapel"
	icon_state = "chapel"

/obj/effect/floor_decal/ss13/l1
	name = "L1"
	icon_state = "L1"

/obj/effect/floor_decal/ss13/l2
	name = "L2"
	icon_state = "L2"

/obj/effect/floor_decal/ss13/l3
	name = "L3"
	icon_state = "L3"

/obj/effect/floor_decal/ss13/l4
	name = "L4"
	icon_state = "L4"

/obj/effect/floor_decal/ss13/l5
	name = "L5"
	icon_state = "L5"

/obj/effect/floor_decal/ss13/l6
	name = "L6"
	icon_state = "L6"

/obj/effect/floor_decal/ss13/l7
	name = "L7"
	icon_state = "L7"

/obj/effect/floor_decal/ss13/l8
	name = "L8"
	icon_state = "L8"

/obj/effect/floor_decal/ss13/l9
	name = "L9"
	icon_state = "L9"

/obj/effect/floor_decal/ss13/l10
	name = "L10"
	icon_state = "L10"

/obj/effect/floor_decal/ss13/l11
	name = "L11"
	icon_state = "L11"

/obj/effect/floor_decal/ss13/l12
	name = "L12"
	icon_state = "L12"

/obj/effect/floor_decal/ss13/l13
	name = "L13"
	icon_state = "L13"

/obj/effect/floor_decal/ss13/l14
	name = "L14"
	icon_state = "L14"

/obj/effect/floor_decal/ss13/l15
	name = "L15"
	icon_state = "L15"

/obj/effect/floor_decal/ss13/l16
	name = "L16"
	icon_state = "L16"

/obj/effect/floor_decal/sign
	name = "floor sign"
	icon_state = "white_1"

/obj/effect/floor_decal/sign/two
	icon_state = "white_2"

/obj/effect/floor_decal/sign/a
	icon_state = "white_a"

/obj/effect/floor_decal/sign/b
	icon_state = "white_b"

/obj/effect/floor_decal/sign/c
	icon_state = "white_c"

/obj/effect/floor_decal/sign/d
	icon_state = "white_d"

/obj/effect/floor_decal/sign/ex
	icon_state = "white_ex"

/obj/effect/floor_decal/sign/m
	icon_state = "white_m"

/obj/effect/floor_decal/sign/cmo
	icon_state = "white_cmo"

/obj/effect/floor_decal/sign/v
	icon_state = "white_v"

/obj/effect/floor_decal/sign/p
	icon_state = "white_p"

/obj/effect/floor_decal/solarpanel
	icon_state = "solarpanel"

/obj/effect/floor_decal/snow
	icon = 'icons/turf/overlays.dmi'
	icon_state = "snowfloor"

/obj/effect/floor_decal/floordetail
	plane = TURF_PLANE
	layer = TURF_DETAIL_LAYER
	color = COLOR_GUNMETAL
	icon_state = "manydot"
	appearance_flags = 0

/obj/effect/floor_decal/floordetail/New(var/newloc, var/newdir, var/newcolour)
	color = null //color is here just for map preview, if left it applies both our and tile colors.
	..()

/obj/effect/floor_decal/floordetail/tiled
	icon_state = "manydot_tiled"

/obj/effect/floor_decal/floordetail/pryhole
	icon_state = "pryhole"

/obj/effect/floor_decal/floordetail/edgedrain
	icon_state = "edge"

/obj/effect/floor_decal/floordetail/traction
	icon_state = "traction"

/obj/effect/floor_decal/ntlogo
	icon_state = "ntlogo"

/obj/effect/floor_decal/newcorner
	icon = 'icons/turf/flooring/misc2.dmi'

/obj/effect/floor_decal/newcorner/red
	icon_state = "red"
/obj/effect/floor_decal/newcorner/red/quarter
	icon_state = "red-quarter"
/obj/effect/floor_decal/newcorner/red/corner
	icon_state = "red-corner"
/obj/effect/floor_decal/newcorner/red/diagonal
	icon_state = "red-diagonal"
/obj/effect/floor_decal/newcorner/red/solid
	icon_state = "redsolid"

/obj/effect/floor_decal/newcorner/blue
	icon_state = "blue"
/obj/effect/floor_decal/newcorner/blue/quarter
	icon_state = "blue-quarter"
/obj/effect/floor_decal/newcorner/blue/corner
	icon_state = "blue-corner"
/obj/effect/floor_decal/newcorner/blue/diagonal
	icon_state = "blue-diagonal"
/obj/effect/floor_decal/newcorner/blue/solid
	icon_state = "bluesolid"

/obj/effect/floor_decal/newcorner/green
	icon_state = "green"
/obj/effect/floor_decal/newcorner/green/quarter
	icon_state = "green-quarter"
/obj/effect/floor_decal/newcorner/green/corner
	icon_state = "green-corner"
/obj/effect/floor_decal/newcorner/green/diagonal
	icon_state = "green-diagonal"
/obj/effect/floor_decal/newcorner/green/solid
	icon_state = "greensolid"

/obj/effect/floor_decal/newcorner/grey
	icon_state = "grey"
/obj/effect/floor_decal/newcorner/grey/quarter
	icon_state = "grey-quarter"
/obj/effect/floor_decal/newcorner/grey/corner
	icon_state = "grey-corner"
/obj/effect/floor_decal/newcorner/grey/diagonal
	icon_state = "grey-diagonal"
/obj/effect/floor_decal/newcorner/grey/solid
	icon_state = "greysolid"

/obj/effect/floor_decal/newcorner/yellow
	icon_state = "yellow"
/obj/effect/floor_decal/newcorner/yellow/quarter
	icon_state = "yellow-quarter"
/obj/effect/floor_decal/newcorner/yellow/corner
	icon_state = "yellow-corner"
/obj/effect/floor_decal/newcorner/yellow/diagonal
	icon_state = "yellow-diagonal"
/obj/effect/floor_decal/newcorner/yellow/solid
	icon_state = "yellowsolid"

/obj/effect/floor_decal/newcorner/purple
	icon_state = "purple"
/obj/effect/floor_decal/newcorner/purple/quarter
	icon_state = "purple-quarter"
/obj/effect/floor_decal/newcorner/purple/corner
	icon_state = "purple-corner"
/obj/effect/floor_decal/newcorner/purple/diagonal
	icon_state = "purple-diagonal"
/obj/effect/floor_decal/newcorner/purple/solid
	icon_state = "purplesolid"

/obj/effect/floor_decal/newcorner/teal
	icon_state = "teal"
/obj/effect/floor_decal/newcorner/teal/quarter
	icon_state = "teal-quarter"
/obj/effect/floor_decal/newcorner/teal/corner
	icon_state = "teal-corner"
/obj/effect/floor_decal/newcorner/teal/diagonal
	icon_state = "teal-diagonal"
/obj/effect/floor_decal/newcorner/teal/solid
	icon_state = "tealsolid"

/obj/effect/floor_decal/newcorner/white
	icon_state = "white"
/obj/effect/floor_decal/newcorner/white/quarter
	icon_state = "white-quarter"
/obj/effect/floor_decal/newcorner/white/corner
	icon_state = "white-corner"
/obj/effect/floor_decal/newcorner/white/diagonal
	icon_state = "white-diagonal"
/obj/effect/floor_decal/newcorner/white/solid
	icon_state = "whitesolid"

/obj/effect/floor_decal/newcorner/whitegreen
	icon_state = "wgreen"
/obj/effect/floor_decal/newcorner/whitegreen/quarter
	icon_state = "wgreen-quarter"
/obj/effect/floor_decal/newcorner/whitegreen/corner
	icon_state = "wgreen-corner"
/obj/effect/floor_decal/newcorner/whitegreen/diagonal
	icon_state = "wgreen-diagonal"
/obj/effect/floor_decal/newcorner/whitegreen/solid
	icon_state = "wgreensolid"

/obj/effect/floor_decal/newcorner/black
	icon_state = "black"
/obj/effect/floor_decal/newcorner/black/quarter
	icon_state = "black-quarter"
/obj/effect/floor_decal/newcorner/black/corner
	icon_state = "black-corner"
/obj/effect/floor_decal/newcorner/black/diagonal
	icon_state = "black-diagonal"
/obj/effect/floor_decal/newcorner/black/solid
	icon_state = "blacksolid"

/obj/effect/floor_decal/newcorner/kafel/white
	icon_state = "whitekafel"
/obj/effect/floor_decal/newcorner/kafel/white/quarter
	icon_state = "whitekafel-quarter"
/obj/effect/floor_decal/newcorner/kafel/white/diagonal
	icon_state = "whitekafel-diagonal"
/obj/effect/floor_decal/newcorner/kafel/white/corner
	icon_state = "whitekafel-corner"

/obj/effect/floor_decal/newcorner/kafel/blue
	icon_state = "bluekafel"
/obj/effect/floor_decal/newcorner/kafel/blue/quarter
	icon_state = "bluekafel-quarter"
/obj/effect/floor_decal/newcorner/kafel/blue/diagonal
	icon_state = "bluekafel-diagonal"
/obj/effect/floor_decal/newcorner/kafel/blue/corner
	icon_state = "bluekafel-corner"

/obj/effect/floor_decal/newcorner/plazaf
	icon_state = "plazaf"
/obj/effect/floor_decal/newcorner/plazaf/quarter
	icon_state = "plazaf-quarter"
/obj/effect/floor_decal/newcorner/plazaf/diagonal
	icon_state = "plazaf-diagonal"
/obj/effect/floor_decal/newcorner/plazaf/corner
	icon_state = "plazaf-corner"

/obj/effect/floor_decal/newcorner/plazafalt
	icon_state = "plazaf2"
/obj/effect/floor_decal/newcorner/plazafalt/quarter
	icon_state = "plazaf2-quarter"
/obj/effect/floor_decal/newcorner/plazafalt/diagonal
	icon_state = "plazaf2-quarter"
/obj/effect/floor_decal/newcorner/plazafalt/corner
	icon_state = "plazaf2-corner"

/obj/effect/floor_decal/newcorner/bar
	icon_state = "bar"
/obj/effect/floor_decal/newcorner/bar/quarter
	icon_state = "bar-quarter"
/obj/effect/floor_decal/newcorner/bar/corner
	icon_state = "bar-corner"
/obj/effect/floor_decal/newcorner/bar/diagonal
	icon_state = "bar-diagonal"

/obj/effect/floor_decal/newcorner/cafe
	icon_state = "cafe"
/obj/effect/floor_decal/newcorner/cafe/quarter
	icon_state = "cafe-quarter"
/obj/effect/floor_decal/newcorner/cafe/corner
	icon_state = "cafe-corner"
/obj/effect/floor_decal/newcorner/cafe/diagonal
	icon_state = "cafe-diagonal"

/obj/effect/floor_decal/newcorner/plating
	icon_state = "plating"
/obj/effect/floor_decal/newcorner/plating/quarter
	icon_state = "plating-quarter"
/obj/effect/floor_decal/newcorner/plating/corner
	icon_state = "plating-corner"
/obj/effect/floor_decal/newcorner/plating/diagonal
	icon_state = "plating-diagonal"

/obj/effect/floor_decal/newcorner/polar
	icon_state = "polar"
/obj/effect/floor_decal/newcorner/polar/quarter
	icon_state = "polar-quarter"
/obj/effect/floor_decal/newcorner/polar/corner
	icon_state = "polar-corner"

/obj/effect/floor_decal/newcorner/reinforced
	icon_state = "reinforced"
/obj/effect/floor_decal/newcorner/reinforced/corner
	icon_state = "rcorner"

/obj/effect/floor_decal/newcorner/train
	icon_state = "train"
/obj/effect/floor_decal/newcorner/train/corner
	icon_state = "train_c"

/obj/effect/floor_decal/newcorner/train2
	icon_state = "train2"
/obj/effect/floor_decal/newcorner/train2/corner
	icon_state = "train2_c"

/obj/effect/floor_decal/newcorner/shaft
	icon_state = "shaftplating"
/obj/effect/floor_decal/newcorner/shaft/quarter
	icon_state = "shaftplating-quarter"
/obj/effect/floor_decal/newcorner/shaft/corner
	icon_state = "shaftplating-corner"
/obj/effect/floor_decal/newcorner/shaft/diagonal
	icon_state = "shaftplating-diagonal"

/obj/effect/floor_decal/newcorner/step
	icon_state = "step"
/obj/effect/floor_decal/newcorner/step_i
	icon_state = "step_i"

/obj/effect/floor_decal/newcorner/nbar
	icon_state = "nbar"
/obj/effect/floor_decal/newcorner/nbar/corner
	icon_state = "nbar_corner"

/obj/effect/floor_decal/newcorner/dwood
	icon_state = "dwood"

/obj/effect/floor_decal/industrial/direction
	icon_state = "dir_white"
/obj/effect/floor_decal/industrial/direction/black
	icon_state = "dir_black"

/obj/effect/floor_decal/industrial/mark
	icon_state = "mark_white"
/obj/effect/floor_decal/industrial/mark/black
	icon_state = "mark_black"

/obj/effect/floor_decal/industrial/punctuation
	icon_state = "punctuation_white"
/obj/effect/floor_decal/industrial/punctuation/black
	icon_state = "punctuation_black"

/obj/effect/floor_decal/industrial/plaza
	icon_state = "plaza"
/obj/effect/floor_decal/industrial/plaza/box
	icon_state = "plazabox"

/obj/effect/floor_decal/turf/bloodbar
	icon_state = "bloodbar"
/obj/effect/floor_decal/turf/bloodbar/off
	icon_state = "bloodbar2"
/obj/effect/floor_decal/turf/bar
	icon_state = "barfull"
/obj/effect/floor_decal/turf/bar2
	icon_state = "bar2"
/obj/effect/floor_decal/turf/bar3
	icon_state = "bar3"

/obj/effect/floor_decal/turf/cafe
	icon_state = "cafefull"
/obj/effect/floor_decal/turf/cafe2
	icon_state = "cafe2"

/obj/effect/floor_decal/turf/shaft
	icon_state = "shaft"
/obj/effect/floor_decal/turf/coldroom
	icon_state = "coldroom"
/obj/effect/floor_decal/turf/steel
	icon_state = "steel"

/obj/effect/floor_decal/turf/aesculapius
	icon_state = "aesculapius"
/obj/effect/floor_decal/turf/aesculapius/mem
	icon_state = "mem"
/obj/effect/floor_decal/turf/aesculapius/mento
	icon_state = "mento"
/obj/effect/floor_decal/turf/aesculapius/mori
	icon_state = "mori"

/obj/effect/floor_decal/turf/plating
	icon_state = "platingfull"

/obj/effect/floor_decal/turf/plate
	icon_state = "plate"

/obj/effect/floor_decal/turf/barnew
	icon_state = "barnew"

/obj/effect/floor_decal/turf/splate
	icon_state = "shaftplating"
