SUBSYSTEM_DEF(inactivity)
	name = "Inactivity"
	wait = 1 MINUTE
	flags = SS_NO_TICK_CHECK

/datum/controller/subsystem/inactivity/Initialize(start_timeofday)
	if (!config.kick_inactive)
		flags |= SS_NO_FIRE

/datum/controller/subsystem/inactivity/fire()
	if(config.kick_inactive)
		for(var/client/C in GLOB.clients)	// I doubt there'll ever be enough clients for this to cause lag.
			if(!C.holder && C.is_afk(config.kick_inactive MINUTES))
				if(!isobserver(C.mob))
					log_access("AFK: [key_name(C)]")
					to_chat(C, "<SPAN CLASS='warning'>You have been inactive for more than [config.kick_inactive] minute\s and have been disconnected.</SPAN>")
					del C	// no point qdeling a client
