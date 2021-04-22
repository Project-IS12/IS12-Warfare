//Procedures in this file: Putting items in body cavity. Implant removal. Items removal.

//////////////////////////////////////////////////////////////////
//					ITEM PLACEMENT SURGERY						//
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//	 generic implant surgery step datum
//////////////////////////////////////////////////////////////////
/datum/surgery_step/cavity
	priority = 1
	shock_level = 40
	delicate = 1
/datum/surgery_step/cavity/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!hasorgans(target))
		return 0
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && affected.open() >= (affected.encased ? SURGERY_ENCASED : SURGERY_RETRACTED)

/datum/surgery_step/cavity/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/chest/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, scraping around inside [target]'s [affected.name] with \the [tool]!"), \
	SPAN_WARNING("Your hand slips, scraping around inside [target]'s [affected.name] with \the [tool]!"))
	affected.take_damage(20, 0, (DAM_SHARP|DAM_EDGE), used_weapon = tool)

//////////////////////////////////////////////////////////////////
//	 create implant space surgery step
//////////////////////////////////////////////////////////////////
/datum/surgery_step/cavity/make_space
	allowed_tools = list(
	/obj/item/surgicaldrill = 100,	\
	/obj/item/pen = 75,	\
	/obj/item/stack/rods = 50
	)

	min_duration = 60
	max_duration = 80

/datum/surgery_step/cavity/make_space/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(..())
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		return affected && !affected.cavity

/datum/surgery_step/cavity/make_space/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts making some space inside [target]'s [affected.cavity_name] cavity with \the [tool].", \
	"You start making some space inside [target]'s [affected.cavity_name] cavity with \the [tool]." )
	target.custom_pain("The pain in your chest is living hell!",1,affecting = affected)
	affected.cavity = 1
	..()

/datum/surgery_step/cavity/make_space/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/chest/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_NOTICE("[user] makes some space inside [target]'s [affected.cavity_name] cavity with \the [tool]."), \
	SPAN_NOTICE("You make some space inside [target]'s [affected.cavity_name] cavity with \the [tool].") )

//////////////////////////////////////////////////////////////////
//	 implant cavity sealing surgery step
//////////////////////////////////////////////////////////////////
/datum/surgery_step/cavity/close_space
	priority = 2
	allowed_tools = list(
	/obj/item/cautery = 100,			\
	/obj/item/clothing/mask/smokable/cigarette = 75,	\
	/obj/item/flame/lighter = 50,			\
	/obj/item/weldingtool = 25
	)

	min_duration = 60
	max_duration = 80

/datum/surgery_step/cavity/close_space/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(..())
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		return affected && affected.cavity

/datum/surgery_step/cavity/close_space/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts mending [target]'s [affected.cavity_name] cavity wall with \the [tool].", \
	"You start mending [target]'s [affected.cavity_name] cavity wall with \the [tool]." )
	target.custom_pain("The pain in your chest is living hell!",1,affecting = affected)
	affected.cavity = 0
	..()

/datum/surgery_step/cavity/close_space/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/chest/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_NOTICE("[user] mends [target]'s [affected.cavity_name] cavity walls with \the [tool]."), \
	SPAN_NOTICE("You mend [target]'s [affected.cavity_name] cavity walls with \the [tool].") )

//////////////////////////////////////////////////////////////////
//	 implanting surgery step
//////////////////////////////////////////////////////////////////
/datum/surgery_step/cavity/place_item
	priority = 0
	allowed_tools = list(/obj/item = 100)

	min_duration = 80
	max_duration = 100

/datum/surgery_step/cavity/place_item/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(..())
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		if(istype(user,/mob/living/silicon/robot))
			return FALSE
		if(affected && affected.cavity)
			var/max_volume = base_storage_capacity(affected.cavity_max_w_class)

			if(tool.w_class > affected.cavity_max_w_class)
				to_chat(user, SPAN_WARNING("\The [tool] is too big for [affected.cavity_name] cavity."))
				return FALSE

			var/total_volume = tool.get_storage_cost()
			for(var/obj/item/I in affected.implants)
				if(istype(I,/obj/item/implant))
					continue
				total_volume += I.get_storage_cost()
			if(total_volume > max_volume)
				to_chat(user, SPAN_WARNING("There isn't enough space left in [affected.cavity_name] cavity for [tool]."))
				return FALSE
			return TRUE


/datum/surgery_step/cavity/place_item/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts putting \the [tool] inside [target]'s [affected.cavity_name] cavity.", \
	"You start putting \the [tool] inside [target]'s [affected.cavity_name] cavity." )
	target.custom_pain("The pain in your chest is living hell!",1,affecting = affected)
	playsound(target.loc, 'sound/effects/squelch1.ogg', 25, 1)
	..()

/datum/surgery_step/cavity/place_item/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/chest/affected = target.get_organ(target_zone)

	user.visible_message(SPAN_NOTICE("[user] puts \the [tool] inside [target]'s [affected.cavity_name] cavity."), \
	SPAN_NOTICE("You put \the [tool] inside [target]'s [affected.cavity_name] cavity.") )
	if (tool.w_class > affected.cavity_max_w_class/2 && prob(50) && !(affected.robotic >= ORGAN_ROBOT) && affected.sever_artery())
		to_chat(user, SPAN_WARNING("You tear some blood vessels trying to fit such a big object in this cavity."))
		affected.owner.custom_pain("You feel something rip in your [affected.name]!", 1,affecting = affected)
	user.drop_item()
	affected.implants += tool
	tool.loc = affected
	affected.cavity = 0

//////////////////////////////////////////////////////////////////
//	 implant removal surgery step
//////////////////////////////////////////////////////////////////
/datum/surgery_step/cavity/implant_removal
	allowed_tools = list(
	/obj/item/hemostat = 100,	\
	/obj/item/wirecutters = 75,	\
	/obj/item/material/kitchen/utensil/fork = 20
	)

	min_duration = 80
	max_duration = 100

/datum/surgery_step/cavity/implant_removal/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(!affected)
		return FALSE
	if(affected.robotic < ORGAN_ROBOT)
		return affected.open() >= SURGERY_RETRACTED
	else
		return affected.hatch_state == HATCH_OPENED

/datum/surgery_step/cavity/implant_removal/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts poking around inside [target]'s [affected.name] with \the [tool].", \
	"You start poking around inside [target]'s [affected.name] with \the [tool]" )
	target.custom_pain("The pain in your [affected.name] is living hell!",1,affecting = affected)
	..()

/datum/surgery_step/cavity/implant_removal/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/chest/affected = target.get_organ(target_zone)
	var/exposed = 0
	if(affected.open() >= (affected.encased ? SURGERY_ENCASED : SURGERY_RETRACTED))
		exposed = 1
	if(affected.robotic >= ORGAN_ROBOT && affected.hatch_state == HATCH_OPENED)
		exposed = 1

	var/find_prob = 0
	var/list/loot = list()
	if(exposed)
		loot = affected.implants
	else
		for(var/datum/wound/wound in affected.wounds)
			loot |= wound.embedded_objects
			find_prob += 50

	if (loot.len)

		var/obj/item/obj = pick(loot)

		if(istype(obj,/obj/item/implant))
			var/obj/item/implant/imp = obj
			if (imp.islegal())
				find_prob +=60
			else
				find_prob +=40
		else
			find_prob +=50

		if (prob(find_prob))
			user.visible_message(SPAN_NOTICE("[user] takes something out of incision on [target]'s [affected.name] with \the [tool]."), \
			SPAN_NOTICE("You take [obj] out of incision on [target]'s [affected.name]s with \the [tool].") )
			affected.implants -= obj
			for(var/datum/wound/wound in affected.wounds)
				if(obj in wound.embedded_objects)
					wound.embedded_objects -= obj
					break

			BITSET(target.hud_updateflag, IMPLOYAL_HUD)

			//Handle possessive brain borers.
			if(istype(obj,/mob/living/simple_animal/borer))
				var/mob/living/simple_animal/borer/worm = obj
				if(worm.controlling)
					target.release_control()
				worm.detatch()
				worm.leave_host()
			else
				obj.dropInto(target.loc)
				obj.add_blood(target)
				obj.update_icon()
				if(istype(obj,/obj/item/implant))
					var/obj/item/implant/imp = obj
					imp.removed(target)
			playsound(target.loc, 'sound/effects/squelch1.ogg', 15, 1)
		else
			user.visible_message(SPAN_NOTICE("[user] removes \the [tool] from [target]'s [affected.name]."), \
			SPAN_NOTICE("There's something inside [target]'s [affected.name], but you just missed it this time.") )
	else
		user.visible_message(SPAN_NOTICE("[user] could not find anything inside [target]'s [affected.name], and pulls \the [tool] out."), \
		SPAN_NOTICE("You could not find anything inside [target]'s [affected.name].") )

/datum/surgery_step/cavity/implant_removal/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	..()
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	for(var/obj/item/implant/imp in affected.implants)
		var/fail_prob = 10
		fail_prob += 100 - tool_quality(tool)
		if (prob(fail_prob))
			user.visible_message(SPAN_WARNING("Something beeps inside [target]'s [affected.name]!"))
			playsound(imp.loc, 'sound/items/countdown.ogg', 75, 1, -3)
			spawn(25)
				imp.activate()

