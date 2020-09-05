// Hey! Listen! Update \config\exoplanet_ruin_blacklist.txt with your new ruins!

/datum/map_template/ruin/exoplanet
	prefix = "maps/random_ruins/exoplanet_ruins/"

/datum/map_template/ruin/exoplanet/little_house
	name = "Little House"
	id = "exoplanet_little_house"
	description = "oh wow look it's a cute little house"
	suffixes = list("little_house.dmm")
	cost = 1

/area/map_template/little_house
	name = "\improper Little House"




/datum/map_template/ruin/exoplanet/smugglers_den
	name = "Smugglers' Base"
	id = "awaysite_smugglers_two"
	description = "Yarr."
	suffixes = list("smugglers_two.dmm")
	cost = 1
	allow_duplicates = FALSE


/datum/map_template/ruin/exoplanet/crashed_ship
	name = "Crashed Ship"
	id = "crashed_ship"
	description = "How unfortunate."
	suffixes = list("crashed_ship.dmm")
	cost = 1
	allow_duplicates = FALSE


/datum/map_template/ruin/exoplanet/mine_trap
	name = "Mine Trap"
	id = "mine_trap"
	description = "How unfortunate."
	suffixes = list("mine_trap.dmm")
	cost = 0.5

/datum/map_template/ruin/exoplanet/water
	name = "Water"
	id = "water"
	description = "splish splash."
	suffixes = list("water.dmm")
	cost = 0.5

/datum/map_template/ruin/exoplanet/river
	name = "River"
	id = "river"
	description = "splish splash."
	suffixes = list("river.dmm")
	cost = 0.5

/datum/map_template/ruin/exoplanet/bunker
	name = "Red Bunker"
	id = "river"
	description = "red team."
	suffixes = list("bunker.dmm")
	cost = 1