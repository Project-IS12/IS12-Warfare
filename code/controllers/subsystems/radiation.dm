SUBSYSTEM_DEF(radiation)
	name = "Radiation"
	wait = 2 SECONDS

	var/repository/radiation/linked = null
	var/list/current_sources
	var/list/current_resistances
	var/list/current_listeners

/datum/controller/subsystem/radiation/stat_entry()
	..("S: [linked.sources.len], CT: [linked.resistance_cache.len]")

/datum/controller/subsystem/radiation/Initialize(start_timeofday)
	linked = radiation_repository

/datum/controller/subsystem/radiation/fire(resumed = FALSE)
	if (!resumed)
		current_sources = linked.sources.Copy()
		current_resistances = linked.resistance_cache.Copy()
		if (linked.sources.len)
			current_listeners = GLOB.living_mob_list_.Copy()
		else
			current_listeners = list()

	while (current_sources.len)
		var/datum/radiation_source/S = current_sources[current_sources.len]
		current_sources.len -= 1

		if (!QDELETED(S))
			if (S.decay)
				S.update_rad_power(S.rad_power - config.radiation_decay_rate)
			if (S.rad_power <= config.radiation_lower_limit)
				linked.sources -= S
		else
			linked.sources -= S

		if (MC_TICK_CHECK)
			return

	while (current_resistances.len)
		var/turf/T = current_resistances[current_resistances.len]
		current_resistances.len -= 1

		if (T.contents.len + 1 != linked.resistance_cache[T])
			linked.resistance_cache -= T

		if (MC_TICK_CHECK)
			return

	while (current_listeners.len)
		var/atom/A = current_listeners[current_listeners.len]
		current_listeners.len -= 1

		if (!QDELETED(A))
			var/turf/T = get_turf(A)
			var/rads = linked.get_rads_at_turf(T)
			if (rads)
				A.rad_act(rads)

		if (MC_TICK_CHECK)
			return
