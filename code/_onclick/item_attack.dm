/*
=== Item Click Call Sequences ===
These are the default click code call sequences used when clicking on stuff with an item.

Atoms:

mob/ClickOn() calls the item's resolve_attackby() proc.
item/resolve_attackby() calls the target atom's attackby() proc.

Mobs:

mob/living/attackby() after checking for surgery, calls the item's attack() proc.
item/attack() generates attack logs, sets click cooldown and calls the mob's attacked_with_item() proc. If you override this, consider whether you need to set a click cooldown, play attack animations, and generate logs yourself.
mob/attacked_with_item() should then do mob-type specific stuff (like determining hit/miss, handling shields, etc) and then possibly call the item's apply_hit_effect() proc to actually apply the effects of being hit.

Item Hit Effects:

item/apply_hit_effect() can be overriden to do whatever you want. However "standard" physical damage based weapons should make use of the target mob's hit_with_weapon() proc to
avoid code duplication. This includes items that may sometimes act as a standard weapon in addition to having other effects (e.g. stunbatons on harm intent).
*/

// Called when the item is in the active hand, and clicked; alternately, there is an 'activate held object' verb or you can hit pagedown.
/obj/item/proc/attack_self(mob/user)
	return

//I would prefer to rename this to attack(), but that would involve touching hundreds of files.
/obj/item/proc/resolve_attackby(atom/A, mob/user, var/click_params)
	if(item_flags & ITEM_FLAG_ABSTRACT)//Abstract items cannot be interacted with. They're not real.
		return
	if(!(item_flags & ITEM_FLAG_NO_PRINT))
		add_fingerprint(user)
	return A.attackby(src, user, click_params)

// No comment
/atom/proc/attackby(obj/item/W, mob/user, var/click_params)
	return

/atom/movable/attackby(obj/item/W, mob/user)
	if(!(W.item_flags & ITEM_FLAG_NO_BLUDGEON))
		visible_message("<span class='danger'>[src] has been hit by [user] with [W].</span>")

/mob/living/attackby(obj/item/I, mob/user)
	if(!ismob(user))
		return 0
	if(can_operate(src,user) && I.do_surgery(src,user)) //Surgery
		return 1
	return I.attack(src, user, user.zone_sel.selecting, FALSE)

/mob/living/carbon/human/attackby(obj/item/I, mob/user)
	if(user == src && src.a_intent == I_DISARM && src.zone_sel.selecting == "mouth")
		var/obj/item/blocked = src.check_mouth_coverage()
		if(blocked)
			to_chat(user, "<span class='warning'>\The [blocked] is in the way!</span>")
			return 1
		else if(devour(I))
			return 1
	return ..()

// Proximity_flag is 1 if this afterattack was called on something adjacent, in your square, or on your person.
// Click parameters is the params string from byond Click() code, see that documentation.
/obj/item/proc/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	return

//I would prefer to rename this attack_as_weapon(), but that would involve touching hundreds of files.
//The "special" arg is there for special attacks, it's present the entire way down the chain so if you ever want to put a sepcial attack
//anywhere in the code, then check for special and then write you special affects.
/obj/item/proc/attack(mob/living/M, mob/living/user, var/target_zone, var/special = FALSE)
	var/offhand_attack = FALSE
	if(!force || (item_flags & ITEM_FLAG_NO_BLUDGEON))
		return 0
	if(ticker.current_state == GAME_STATE_FINISHED)
		to_chat(user, "<span class='warning'>The battle is over! There is no need to fight!</span>")
		return 0

	if(aspect_chosen(/datum/aspect/trenchmas))
		to_chat(user, "<span class='warning'>It's trenchmas! There is no reason to fight!</span>")
		return 0

	if(M == user && user.a_intent != I_HURT)
		return 0

	if(user.staminaloss >= user.staminaexhaust)//Can't attack people if you're out of stamina.
		return 0

	if(world.time <= next_attack_time)
		if(world.time % 3) //to prevent spam
			to_chat(user, "<span class='warning'>The [src] is not ready to attack again!</span>")
		return 0

	if(!user.combat_mode)
		special = FALSE

	if(M == user)//Hitting yourself.
		user.unlock_achievement(new/datum/achievement/miss())

	if(special)//We did a special attack, let's apply it's special properties.
		if(user.atk_intent == I_QUICK)//Faster attack but takes much more stamina.
			user.visible_message("<span class='combat_success'>[user] performs a quick attack!</span>")
			user.adjustStaminaLoss(w_class + 6)
			user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
			apply_speed_delay(-5)

		else if(user.atk_intent == I_AIMED)//More accurate attack
			user.visible_message("<span class='combat_success'>[user] performs an aimed attack!</span>")
			user.adjustStaminaLoss(w_class + 5)
			user.setClickCooldown(DEFAULT_SLOW_COOLDOWN)
			apply_speed_delay(5)

		else if(user.atk_intent == I_FEINT)//Feint attack that leaves them unable to attack for a few seconds
			if(!prob(user.SKILL_LEVEL(melee) * 10))//Add skill check here.
				user.visible_message("<span class='combat_success'>[user] botches a feint attack!</span>")
				return 0
			user.adjustStaminaLoss(w_class + 5)
			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
			M.setClickCooldown(DEFAULT_SLOW_COOLDOWN)
			apply_speed_delay(0)
			user.visible_message("<span class='combat_success'>[user] performs a successful feint attack!</span>")
			if(M.atk_intent == I_DEFENSE)
				if(M.combat_mode)
					M.item_disarm()
			return 0 //We fiented them don't actaully hit them now, we can follow up with another attack.

		else if(user.atk_intent == I_STRONG)//Attack with stronger damage at the cost slightly longer cooldown
			user.visible_message("<span class='combat_success'>[user] performs a heavy attack!</span>")
			user.adjustStaminaLoss(w_class + 5)
			user.setClickCooldown(DEFAULT_SLOW_COOLDOWN)
			apply_speed_delay(6)

		else if(user.atk_intent == I_WEAK)
			user.visible_message("<span class='combat_success'>[user] performs a weak attack.</span>")
			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
			apply_speed_delay(0)

		else if(user.atk_intent == I_DUAL)
			user.visible_message("<span class='combat_success'>[user] attacks with their offhand!</span>")
			offhand_attack = TRUE
			apply_speed_delay(3)
		else
			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
			apply_speed_delay(0)



	/////////////////////////

	if(!no_attack_log)
		admin_attack_log(user, M, "Attacked using \a [src] (DAMTYE: [uppertext(damtype)])", "Was attacked with \a [src] (DAMTYE: [uppertext(damtype)])", "used \a [src] (DAMTYE: [uppertext(damtype)]) to attack")

		if(ishuman(user) && ishuman(M))
			var/mob/living/carbon/human/attacker = user
			var/mob/living/carbon/human/victim = M
			if(attacker != victim)
				if(attacker.warfare_faction)
					if(attacker.warfare_faction == victim.warfare_faction && victim.stat != DEAD)
						to_chat(attacker, "<big>[victim] is on my side!</big>")
						log_and_message_admins("[attacker] has hit his teammate [victim] with \a [src]!")
						GLOB.ff_incidents++
	/////////////////////////

	if(!special)
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

	//user.do_attack_animation(M)
	if(!user.aura_check(AURA_TYPE_WEAPON, src, user))
		return 0

	if(force && !special)
		user.adjustStaminaLoss(w_class + 3)
	if(swing_sound)
		playsound(user, swing_sound, 50, 1, -1)

	if(offhand_attack)
		var/obj/item/I = user.get_inactive_hand()
		if(I)
			var/offhand_hit_zone = M.resolve_item_attack(I, user, target_zone, special)
			if(offhand_hit_zone)
				I.apply_hit_effect(M, user, offhand_hit_zone, special)
		else
			visible_message("<span class='warning'>[user] has nothing in their offhand to attack with!</span>")

	else
		var/hit_zone = M.resolve_item_attack(src, user, target_zone, special)
		if(hit_zone)
			apply_hit_effect(M, user, hit_zone, special)

	if(!special)
		apply_speed_delay(0)
	return 1


//by default, that's 25 - 10. Which is 15. Which should be what the average attack is. People who are weaker will swing heavy objects slower.
//The "delay" arg is for adding a greater or lesser delay from special attacks.
/obj/item/proc/apply_speed_delay(delay)
	next_attack_time = world.time + (weapon_speed_delay + delay)


//Called when a weapon is used to make a successful melee attack on a mob. Returns the blocked result
/obj/item/proc/apply_hit_effect(mob/living/target, mob/living/user, var/hit_zone, var/special = FALSE)
	if(hitsound)
		playsound(loc, hitsound, 50, 1, -1)

	var/power = force
	if(HULK in user.mutations)
		power *= 2
	return target.hit_with_weapon(src, user, power, hit_zone, special)

