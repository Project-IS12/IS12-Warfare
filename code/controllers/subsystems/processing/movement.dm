SUBSYSTEM_DEF(movement)
	name = "Movement"
	wait = 1 //SS_TICKER means this runs every tick
	flags = SS_TICKER | SS_NO_INIT | SS_KEEP_TIMING
	priority = 151
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY

/datum/controller/subsystem/movement/fire()
	var/list/clients = GLOB.clients // Let's sing the list cache song
	for(var/i in 1 to clients.len)
		var/client/C = clients[i]
		C.handle_move()

/client/proc/handle_move()
	set waitfor = FALSE
	if (mob && moving_in_dir)
		if((moving_in_dir & NORTH) && (moving_in_dir & SOUTH))
			moving_in_dir &= ~(NORTH|SOUTH)
		if((moving_in_dir & EAST) && (moving_in_dir & WEST))
			moving_in_dir &= ~(EAST|WEST)
		var/turf/target = get_step(mob,moving_in_dir)
		Move(target, moving_in_dir)