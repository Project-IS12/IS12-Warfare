/datum/admin_secret_item/fun_secret/waddle
	name = "Enable Waddling"

/datum/admin_secret_item/fun_secret/waddle/execute(var/mob/user)
	. = ..()
	if(.)
		GLOB.waddling = !GLOB.waddling
		to_world("<span class='notice'>Waddling has been [GLOB.waddling ? "enabled" : "disabled"].</span>")

