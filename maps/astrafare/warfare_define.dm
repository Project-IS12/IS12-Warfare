
/datum/map/warfare
	name = "Warfare"
	full_name = "Warfare"
	path = "warfare"
	station_name  = "Warfare"
	station_short = "Warfare"
	dock_name     = "Warfare"
	boss_name     = "Colonial Magistrate Authority"
	boss_short    = "CMA"
	company_name  = "Colonial Magistrate Space Residential Complex"
	company_short = "CMSRC"
	system_name = "hell"

	lobby_icon = 'maps/astrafare/fullscreen.dmi'
	lobby_screens = list("lobby1")

	station_levels = list(1,2)
	contact_levels = list(1)
	player_levels = list(1,2)

	allowed_spawns = list("Arrivals Shuttle")
	base_turf_by_z = list("1" = /turf/simulated/floor/dirty/tough/lightless, "2" = /turf/simulated/floor/dirty, "3" = /turf/simulated/floor/dirty)
	shuttle_docked_message = "The shuttle has docked."
	shuttle_leaving_dock = "The shuttle has departed from home dock."
	shuttle_called_message = "A scheduled transfer shuttle has been sent."
	shuttle_recall_message = "The shuttle has been recalled"
	emergency_shuttle_docked_message = "The emergency escape shuttle has docked."
	emergency_shuttle_leaving_dock = "The emergency escape shuttle has departed from %dock_name%."
	emergency_shuttle_called_message = "An emergency escape shuttle has been sent."
	emergency_shuttle_recall_message = "The emergency shuttle has been recalled"
	map_lore = "We have been marching through the mountain ravine for more than two seasons. Never ending, tight and dangerous. No one can remember what our target was anymore - something important. Something that could end the War. Yesterday we captured old complex of unknown origin. Recon returned with confirmed enemy presence. We have orders to move out at dawn."



//Overriding event containers to remove random events.
/datum/event_container/mundane
	available_events = list(
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Mortars1",/datum/event/mortar,100),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Mortars2",/datum/event/mortar,100),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Mortars3",/datum/event/mortar,100),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Mortars4",/datum/event/mortar,100)
		)

/datum/event_container/moderate
	available_events = list(
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Mortars1",/datum/event/mortar,100),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Mortars2",/datum/event/mortar,100),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Mortars3",/datum/event/mortar,100),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Mortars4",/datum/event/mortar,100)
	)

/datum/event_container/major
	available_events = list(
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Mortars1",/datum/event/mortar,100),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Mortars2",/datum/event/mortar,100),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Mortars3",/datum/event/mortar,100),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Mortars4",/datum/event/mortar,100)
	)