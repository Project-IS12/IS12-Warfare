// This is a holder for LEGACY init behaviors - please don't add new things to this, instead create a subsystem for it.

SUBSYSTEM_DEF(legacy_init)
	name = "Legacy Initialization"
	flags = SS_NO_FIRE
	init_order = INIT_BAY_LEGACY

/datum/controller/subsystem/legacy_init/Initialize(start_timeofday)
	if (GLOB.using_map.use_overmap)
		overmap_event_handler.create_events(GLOB.using_map.overmap_z, GLOB.using_map.overmap_size, GLOB.using_map.overmap_event_areas)

	populate_lathe_recipes()
	setupgenetics()

	if(!syndicate_code_phrase)
		syndicate_code_phrase = generate_code_phrase()
	if(!syndicate_code_response)
		syndicate_code_response = generate_code_phrase()
	if(!GLOB.cargo_password)
		GLOB.cargo_password = GenerateKey()

	createRandomZlevel()	// probably slow, but I believe unused
