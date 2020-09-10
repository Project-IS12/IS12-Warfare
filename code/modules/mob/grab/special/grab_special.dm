/datum/grab/special
	icon = 'icons/mob/screen1.dmi'
	stop_move = 1
	can_absorb = 1
	shield_assailant = 0
	point_blank_mult = 1
	force_danger = 1

/obj/item/grab/special/init()
	..()

	if(affecting.w_uniform)
		affecting.w_uniform.add_fingerprint(assailant)

	assailant.put_in_active_hand(src)
	//assailant.do_attack_animation(affecting)
	playsound(affecting.loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
	var/obj/O = get_targeted_organ()
	var/grab_string = O.name
	if(assailant.zone_sel.selecting == BP_THROAT)
		grab_string = "throat"
	visible_message("<span class='warning'>[assailant] grabs [affecting]'s [grab_string]!</span>")
	affecting.grabbed_by += src

/obj/item/grab/special/strangle
	type_name = GRAB_STRANGLE
	start_grab_name = GRAB_STRANGLE

/datum/grab/special/strangle
	type_name = GRAB_STRANGLE
	icon_state = "strangle"
	activate_effect = FALSE
	state_name = GRAB_STRANGLE

/datum/grab/special/strangle/attack_self_act(var/obj/item/grab/G)
	do_strangle(G)

/datum/grab/special/strangle/process_effect(var/obj/item/grab/G)
	var/mob/living/carbon/human/affecting = G.affecting

	affecting.drop_l_hand()
	affecting.drop_r_hand()

	if(affecting.lying)
		affecting.Weaken(4)

	affecting.adjustOxyLoss(1)

	affecting.apply_effect(STUTTER, 5) //It will hamper your voice, being choked and all.
	affecting.Weaken(5)	//Should keep you down unless you get help.
	affecting.losebreath = max(affecting.losebreath + 2, 3)

/datum/grab/special/strangle/proc/do_strangle(var/obj/item/grab/G)
	activate_effect = !activate_effect
	G.assailant.visible_message("<span class='warning'>[G.assailant] [activate_effect ? "starts" : "stops"] strangling [G.affecting]</span>")


/obj/item/grab/special/wrench
	type_name = GRAB_WRENCH
	start_grab_name = GRAB_WRENCH


/datum/grab/special/wrench
	type_name = GRAB_WRENCH
	icon_state = "wrench"
	state_name = GRAB_WRENCH

/datum/grab/special/wrench/attack_self_act(var/obj/item/grab/G)
	do_wrench(G)
	G.assailant.setClickCooldown(DEFAULT_SLOW_COOLDOWN)

/datum/grab/special/wrench/proc/do_wrench(var/obj/item/grab/G)
	var/obj/item/organ/external/O = G.get_targeted_organ()
	var/mob/living/carbon/human/assailant = G.assailant
	var/mob/living/carbon/human/affecting = G.affecting

	if(assailant.doing_something)
		return

	if(!O)
		to_chat(assailant, "<span class='warning'>[affecting] is missing that body part!</span>")
		return
	if(!G.wielded)
		to_chat(assailant, "<span class='warning'>We must wield them in both hands to break their limb.</span>")
		return

	assailant.doing_something = TRUE

	if(!do_after(assailant, 30, affecting))
		assailant.doing_something = FALSE
		return


	if(!O.is_broken()) // The limb is broken and we're grabbing it in both hands.
		assailant.visible_message("<span class='danger'>[assailant] tries to break [affecting]'s [O.name]!</span>")
		var/break_chance = (assailant.STAT_LEVEL(str)*10) - 105 // We have to have a strength over 12 to really have a chance of breaking a limb.
		if(break_chance <= 0)
			break_chance = 10
		if(prob(break_chance))
			O.fracture()

	assailant.doing_something = FALSE


/obj/item/grab/special/takedown
	type_name = GRAB_TAKEDOWN
	start_grab_name = GRAB_TAKEDOWN

/datum/grab/special/takedown
	type_name = GRAB_TAKEDOWN
	state_name = GRAB_TAKEDOWN
	icon_state = "takedown"

/datum/grab/special/takedown/attack_self_act(var/obj/item/grab/G)
	do_takedown(G)
	G.assailant.setClickCooldown(DEFAULT_SLOW_COOLDOWN)

/datum/grab/special/takedown/process_effect(var/obj/item/grab/G)
	// Keeps those who are on the ground down
	if(G.affecting.lying)
		G.affecting.Weaken(4)


/datum/grab/special/takedown/proc/do_takedown(var/obj/item/grab/G)
	var/mob/living/carbon/human/affecting = G.affecting
	var/mob/living/carbon/human/assailant = G.assailant

	if(assailant.doing_something)
		return

	assailant.doing_something = TRUE

	if(!do_after(assailant, 30, affecting))
		assailant.doing_something = FALSE
		return

	if(!G.attacking && !affecting.lying)

		affecting.visible_message("<span class='notice'>[assailant] is trying to pin [affecting] to the ground!</span>")
		G.attacking = 1

		if(!assailant.statscheck(assailant.STAT_LEVEL(str) / 2 + 3) >= SUCCESS && do_mob(assailant, affecting, 30))

			G.attacking = 0
			G.action_used()
			affecting.Weaken(2)
			affecting.visible_message("<span class='notice'>[assailant] pins [affecting] to the ground!</span>")
			assailant.doing_something = FALSE
			return 1
		else
			affecting.visible_message("<span class='notice'>[assailant] fails to pin [affecting] to the ground.</span>")
			G.attacking = 0
			assailant.doing_something = FALSE
			return 0
	else
		assailant.doing_something = FALSE
		return 0

/datum/grab/special/self
	icon_state = "self"