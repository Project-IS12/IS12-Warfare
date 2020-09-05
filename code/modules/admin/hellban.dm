#define HELLBANSFILE "config/hellbans.txt"

/hook/startup/proc/loadhellbans()
	load_hellbans()
	return 1

/proc/load_hellbans()
	log_and_message_admins("Loading hellbans")
	hellbans = list()
	var/list/Lines = file2list(HELLBANSFILE)
	for(var/line in Lines)
		if(!length(line))
			continue

		var/ascii = text2ascii(line,1)

		if(copytext(line,1,2) == "#" || ascii == 9 || ascii == 32)//# space or tab
			continue

		hellbans.Add(ckey(line))

	if(!hellbans.len)
		log_and_message_admins("hellbans: empty or missing.")
		hellbans = null
	else
		log_and_message_admins("hellbans: [hellbans.len] entrie(s).")

//Checking and adding.
/mob/proc/is_hellbanned()
	return client && client.hellbanned

/client/proc/is_hellbanned()
	return hellbanned

/client/proc/check_hellbanned()
	if(hellbans && ckey in hellbans)
		hellbanned = 1

/datum/admin/proc/add_hellban()
	set category = "Admin"
	set name = "Hellban Add"
	set desc = "Adds a ckey to hellban list."
	if (!usr.client.holder)
		return
	var/client/C = input(src, "Select a victim", "Hellban") as null|anything in GLOB.clients
	if(C)
		message_admins("[C] has been hellbanned for this round.")
		C.hellbanned = TRUE

/datum/admin/proc/remove_hellban()
	set category = "Admin"
	set name = "Hellban Remove"
	set desc = "Remove a ckey from hellban list."
	if (!usr.client.holder)
		return
	var/client/C = input(src, "Select a redeemed", "Hellban") as null|anything in GLOB.clients
	if(C)
		message_admins("[C] has been unhellbanned for this round.")
		C.hellbanned = FALSE