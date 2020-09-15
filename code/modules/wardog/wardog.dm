/*

This file is built for communication with a discord bot.

*/

proc/send_to_bot(list/params, useapikey = 1)
	if(useapikey)
		params["key"] = config.bot_api_key

	world.Export("[config.bot_url]/api?[list2params(params)]")
	to_world_log("[config.bot_url]/api?[list2params(params)]")


/datum/controller/gameticker/declare_completion()
	. = ..()
	var/players = 0
	for(var/client/C in GLOB.clients)
		players++

	var/condition = SSwarfare.complete
	var/victor = findtext(condition, "red") ? "red" : (findtext(condition, "blue") ? "blue" : "draw")

	send_to_bot(list(
	"call" = "roundend",
	"winning_team" = victor,
	"condition" = condition ? condition : "draw",
	"players" = players,
	"minestripped" = GLOB.mines_tripped,
	"teethlost" = GLOB.teeth_lost,
	"bloodshed" = GLOB.total_deaths,
	"time" = roundduration2text()
	))

/*
/hook/startup/proc/roundstartping()
	send_to_bot(list(
		"call" = "roundstart"
	))
*/