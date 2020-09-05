//Going here till I find a better place for it.
/mob/living/carbon/human/proc/handle_combat_mode()//Makes it so that you can't regain stamina in combat mode.
	if(combat_mode)
		if(staminaloss < (staminaexhaust/2))
			adjustStaminaLoss(2)

/mob/living/carbon/human/proc/attempt_dodge()//Handle parry is an object proc and it's, its own thing.
	var/dodge_modifier = 0
	if(combat_mode && (defense_intent == I_DODGE) && !lying)//Todo, make use of the check_shield_arc proc to make sure you can't dodge from behind.
		if(atk_intent == I_DEFENSE)//Better chance to dodge
			dodge_modifier += 30
		if(statscheck(STAT_LEVEL(dex) / 2 + 3) >= SUCCESS)
			do_dodge()
			return	1
		else if(prob(((SKILL_LEVEL(melee) * 10) / 2) + dodge_modifier))
			do_dodge()
			return	1

		//else if(CRIT_FAILURE)
		//	visible_message("<b><big>[src.name] fails to dodge and falls on the floor!</big></b>")
		//	Weaken(3)


/mob/living/proc/do_dodge()
	var/lol = pick(GLOB.cardinal)//get a direction.
	adjustStaminaLoss(15)//add some stamina loss
	playsound(loc, 'sound/weapons/punchmiss.ogg', 80, 1)//play a sound
	step(src,lol)//move them
	visible_message("<b><big>[src.name] dodges out of the way!!</big></b>")//send a message
	//be on our way


/mob/proc/surrender()//Surrending. I need to put this in a different file.
	if(!incapacitated(INCAPACITATION_STUNNED|INCAPACITATION_KNOCKOUT))
		Stun(5)
		Weaken(5)
		visible_message("<b>[src] surrenders!</b>")
		playsound(src, 'sound/effects/surrender.ogg', 50, 1)
		var/atom/movable/overlay/animation = new /atom/movable/overlay( loc )
		animation.icon_state = "blank"
		animation.icon = 'icons/mob/screen1.dmi'
		animation.master = src
		flick("attention", animation)
		qdel(animation)

/mob/verb/mob_rest()
	set hidden = 1
	set name = "mob rest"
	if(resting && !stunned && !weakened)
		var/turf/T = get_turf(src)
		if(istype(T, /turf/simulated/floor/plating/n2floor))
			to_chat(src, "<b>The ceiling is too low here to stand.</b>")
			return

		//The incapacitated proc includes resting for whatever fucking stupid reason I hate SS13 code so fucking much.
		visible_message("<span class='notice'>[src] is trying to get up.</span>")
		if(do_after(src, 20, incapacitation_flags = INCAPACITATION_STUNNED|INCAPACITATION_KNOCKOUT))//So that we can get up when we're handcuffed.
			resting = 0
			rest?.icon_state = "rest0"
			update_canmove()
		return

	else
		resting = TRUE
		update_canmove()
		//For stopping runtimes with NPCs
		rest?.icon_state = "rest1"
		fixeye?.icon_state = "fixeye"
		walk_to(src,0)


/client/verb/CombatModeToggle()
	set hidden = 1

	if(!ishuman(usr))	return
	var/mob/living/carbon/human/C = usr
	if(C.combat_mode)
		usr << 'sound/effects/ui_toggleoff.ogg'
		C.combat_mode = FALSE
		C.combat_icon.icon_state = "combat0"
	else
		usr << 'sound/effects/ui_toggle.ogg'
		C.combat_mode = TRUE
		C.combat_icon.icon_state = "combat1"