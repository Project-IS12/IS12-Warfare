SUBSYSTEM_DEF(tgui)
	name = "tgui"
	wait = 2 SECONDS

	var/list/tg_open_uis = list() // A list of open UIs, grouped by src_object and ui_key.
	var/list/processing_uis = list() // A list of processing UIs, ungrouped.
	var/list/current_run = list()
	var/basehtml // The HTML base used for all UIs.

/datum/controller/subsystem/tgui/stat_entry()
	..("P: [processing_uis.len]")

/datum/controller/subsystem/tgui/Initialize(start_timeofday)
	basehtml = file2text('tgui/tgui.html')	// Read the HTML from disk.

/datum/controller/subsystem/tgui/fire(resumed = FALSE)
	if (!resumed)
		current_run = processing_uis.Copy()

	while (current_run.len)
		var/datum/tgui/ui = current_run[current_run.len]
		current_run.len -= 1

		if (!QDELETED(ui) && ui.user && ui.src_object)
			ui.process()
		else
			processing_uis -= ui

		if (MC_TICK_CHECK)
			return
