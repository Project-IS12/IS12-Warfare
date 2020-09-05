//Shitty hack to make aspects run before the ticker does.
SUBSYSTEM_DEF(aspects)
	name = "Aspects"
	init_order = INIT_ORDER_ASPECTS
	flags = SS_NO_FIRE
	var/datum/aspect/chosen_aspect
	var/list/possible_aspects = list()

//Picks the aspect and assigns it. Runs before atom init CONTROLLER, so you can use it to modify spawning behaviors.
/datum/controller/subsystem/aspects/Initialize(timeofday)
	..(timeofday)
	get_or_set_aspect()

/datum/controller/subsystem/aspects/proc/get_or_set_aspect(var/datum/aspect/B = null)
	if(!config.use_aspect_system)
		return
	//if(prob(75))//75% of not choosing an aspect at all. Not enough systems to keep this interesting at the moment.
	//	return

	for(var/thing in subtypesof(/datum/aspect))//Populate possible aspects list.
		var/datum/aspect/A = thing
		possible_aspects += A
	if(!possible_aspects.len)//If there's nothing there afterwards return.
		return
	var/used_aspect
	if(B != null)
		used_aspect = B
	else 
		used_aspect = pick(possible_aspects)
	if(chosen_aspect)
		chosen_aspect.deactivate()
	chosen_aspect = new  used_aspect
	chosen_aspect.activate()

/datum/controller/subsystem/aspects/Recover() //In case the aspects system mysteriously crashes (It won't.) recover. Aren't subsystems fucking stellar?
	chosen_aspect = SSaspects.chosen_aspect
	possible_aspects = SSaspects.possible_aspects



/datum/admins/proc/force_aspect()
	set category = "Admin"
	set name = "Force Aspect"
	set desc = "Force an aspect from a list of all aspects."

	if (!istype(src,/datum/admins))
		src = usr.client.holder
	if (!istype(src,/datum/admins) || !check_rights(R_ADMIN))
		to_chat(usr, "Error: you are not an admin!")
		return
	var/datum/aspect/A = input("Select Aspect.", "Force Aspect.") as anything in SSaspects.possible_aspects
	SSaspects.get_or_set_aspect(A)
	log_and_message_admins("has forced the aspect to [SSaspects.chosen_aspect.name]. Description: [SSaspects.chosen_aspect.desc]")