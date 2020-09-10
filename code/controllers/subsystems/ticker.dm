SUBSYSTEM_DEF(ticker)
	name = "Ticker"
	wait = 2 SECONDS
	init_order = INIT_ORDER_TICKER

	flags = SS_NO_TICK_CHECK | SS_KEEP_TIMING

/datum/controller/subsystem/ticker/Initialize(start_timeofday)
	if (!ticker)
		ticker = new

	spawn
		ticker.pregame()

/datum/controller/subsystem/ticker/fire()
	ticker.process()

/world/proc/has_round_started()
	return (ticker && ticker.current_state >= GAME_STATE_PLAYING)
