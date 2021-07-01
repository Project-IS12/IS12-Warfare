SUBSYSTEM_DEF(evac)
	name = "Evacuation"
	wait = 2 SECONDS
	flags = SS_NO_TICK_CHECK

/datum/controller/subsystem/evac/Initialize(start_timeofday)
	if(!evacuation_controller)
		evacuation_controller = new GLOB.using_map.evac_controller_type
		evacuation_controller.set_up()

/datum/controller/subsystem/evac/fire()
	evacuation_controller.process()
