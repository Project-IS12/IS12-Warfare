SUBSYSTEM_DEF(supply)
	name = "Supply"
	wait = 30 SECONDS
	flags = SS_NO_TICK_CHECK | SS_BACKGROUND

/datum/controller/subsystem/supply/fire()
	supply_controller.process()
