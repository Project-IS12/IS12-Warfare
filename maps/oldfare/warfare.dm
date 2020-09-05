#if !defined(using_map_DATUM)
	#include "warfare_areas.dm"
	#include "warfare_shuttles.dm"
	#include "warfare_unit_testing.dm"
	#include "jobs/captain_verbs.dm"
	#include "jobs/warfare_jobs.dm"
	#include "jobs/soldiers.dm"
	#include "jobs/fortress.dm"
	#include "jobs/blue/blue_fortress.dm"
	#include "jobs/blue/blue_soldiers.dm"
	#include "jobs/red/red_fortress.dm"
	#include "jobs/red/red_soldiers.dm"
	#include "warfare_items.dm"
	#include "../shared/items/clothing.dm"
	#include "../shared/items/cards_ids.dm"

	#include "warfare-1.dmm"
	#include "warfare-2.dmm"

	#include "../../code/modules/lobby_music/generic_songs.dm"

	#define using_map_DATUM /datum/map/warfare

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Example

#endif
