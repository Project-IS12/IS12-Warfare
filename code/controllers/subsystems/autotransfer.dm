SUBSYSTEM_DEF(autotransfer)
	name = "Auto-Transfer"
	wait = 2 SECONDS
	flags = SS_KEEP_TIMING | SS_NO_TICK_CHECK

	var/timerbuffer	// fuck if I know why this is named this

/datum/controller/subsystem/autotransfer/Initialize()
	timerbuffer = config.vote_autotransfer_initial

/datum/controller/subsystem/autotransfer/fire()
	if (time_till_transfer_vote() <= 0)
		SSvote.autotransfer()
		timerbuffer += config.vote_autotransfer_interval

/datum/controller/subsystem/autotransfer/proc/time_till_transfer_vote()
	return timerbuffer - round_duration_in_ticks - 1 MINUTE
