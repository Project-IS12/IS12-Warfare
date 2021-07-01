#define SLASH 1
#define STAB 2
#define BASH 3


/obj/item/material/sword
	name = "claymore"
	desc = "You use the sharp part on your foes. And the flat part on your lesser foes."
	icon_state = "claymore"
	item_state = "claymore"
	slot_flags = SLOT_BELT
	w_class = ITEM_SIZE_HUGE
	force_divisor = 0.2 // 30 when wielded with hardness 60 (steel)
	thrown_force_divisor = 0.2 // 10 when thrown with weight 20 (steel)
	sharp = 1
	edge = 1
	attack_verb = list("slashed", "sliced")
	hitsound = "slash_sound"
	var/atk_mode = SLASH
	block_chance = 25
	applies_material_colour = FALSE
	grab_sound_is_loud = TRUE
	grab_sound = 'sound/items/unholster_sword02.ogg'
	equipsound = 'sound/items/holster_sword1.ogg'
	sharpness = 25
	weapon_speed_delay = 20
	parry_sounds = list('sound/weapons/bladeparry1.ogg', 'sound/weapons/bladeparry2.ogg', 'sound/weapons/bladeparry3.ogg', 'sound/weapons/bladeparry4.ogg')
	drop_sound = 'sound/items/drop_sword.ogg'
	unbreakable = TRUE


/obj/item/material/sword/handle_shield(mob/living/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(default_sword_parry(user, damage, damage_source, attacker, def_zone, attack_text))
		return 1

	return 0

/obj/item/proc/default_sword_parry(mob/living/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	//Ok this if looks like a bit of a mess, and it is. Basically you need to have the sword in your active hand, and pass the default parry check
	//and also pass the prob which is your melee skill divided by two + the swords block chance. Complicated, I know, but hopefully it'll balance out.

	var/actual_block_chance = prob(block_chance + ((user.SKILL_LEVEL(melee) * 10) / 2))//Skills aren't base 100 anymore they're based 10 so I'm multiplying 100

	if(user.atk_intent == I_DEFENSE)
		actual_block_chance += 50

	if(default_parry_check(user, attacker, damage_source) && actual_block_chance && (user.get_active_hand() == src))//You gotta be holding onto that sheesh bro.
		user.visible_message("<span class='combat_success'>\The [user] parries [attack_text] with \the [src]!</span>")
		if(parry_sounds.len)
			playsound(user.loc, pick(parry_sounds), 50, 1)
		user.adjustStaminaLoss(10)
		health -= 0.5
		if(!prob((user.SKILL_LEVEL(melee) * 10) + 15) || user.staminaloss >= user.staminaexhaust)//If you're out of stamina you will immediately be disarmed.
			disarm(user)//Moved the disarm affect to it's own proc in case we want to call it elsewhere.
		else if(user.atk_intent == I_GUARD)//If they're on gaurd intent then attack back immediately.
			if(istype(src, /obj/item/gun))//If they're using a gun I don't want them shooting like it's fucking gun kaka.
				if(user.a_intent != I_HURT)
					visible_message("<span class='combat_success'>[user] ripostes!</span>")
					src.attack(attacker, user, def_zone)
					user.adjustStaminaLoss(5)
			else
				visible_message("<span class='combat_success'>[user] ripostes!</span>")
				src.attack(attacker, user, def_zone)
				user.adjustStaminaLoss(5)
		return 1

/obj/item/proc/disarm(mob/living/user)
	user.visible_message("<span class='danger'>\The [src] flies out of \the [user]'s hand!</span>")
	user.drop_from_inventory(src)
	throw_at(get_edge_target_turf(src, pick(GLOB.alldirs)), rand(1,3), throw_speed)//Throw that sheesh away

/mob/proc/item_disarm()
	var/obj/item/I = get_active_hand()
	if(I)
		I.disarm(src)


/obj/item/material/sword/attack_self(mob/user)
	..()
	if(atk_mode == SLASH)
		switch_intent(user,STAB)
	else if(atk_mode == STAB)
		switch_intent(user,BASH)
	else if(atk_mode == BASH)
		switch_intent(user,SLASH)



/obj/item/material/sword/proc/switch_intent(mob/user,var/intent)
	switch(intent)
		if(STAB)
			atk_mode = STAB
			to_chat(user, "You will now stab.")
			edge = 0
			sharp = 1
			attack_verb = list("stabbed")
			hitsound = "stab_sound"
			return
		if(BASH)
			atk_mode = BASH
			to_chat(user, "You will now bash with the hilt.")
			edge = 0
			sharp = 0
			attack_verb = list("bashed", "smacked")
			hitsound = "swing_hit"
			return

		if(SLASH)
			atk_mode = SLASH
			to_chat(user, "You will now slash.")
			edge = TRUE
			sharp = TRUE
			attack_verb = list("slashed", "diced")
			hitsound = "slash_sound"
			return




/obj/item/material/sword/replica
	edge = 0
	sharp = 0
	force_divisor = 0.2
	thrown_force_divisor = 0.2

/obj/item/material/sword/katana
	name = "katana"
	desc = "Woefully underpowered in D20. This one looks pretty sharp."
	icon_state = "katana"
	item_state = "katana"
	slot_flags = SLOT_BELT | SLOT_BACK

/obj/item/material/sword/katana/replica
	edge = 0
	sharp = 0
	force_divisor = 0.2
	thrown_force_divisor = 0.2

/obj/item/material/sword/sabre
	name = "sabre"
	desc = "Like a claymore but for an officer."
	icon_state = "sabre"
	item_state = "sabre"
	force_divisor = 0.4
	thrown_force_divisor = 0.4
	block_chance = 50


/obj/item/material/sword/machete
	name = "machete"
	desc = "Both a vine removal tool, and a limb removal tool. Use it on vines, and also people who annoy you."
	icon_state = "machete"
	item_state = "machete"
	w_class = ITEM_SIZE_NORMAL
	slot_flags = SLOT_BELT


/obj/item/material/sword/combat_knife
	name = "combat knife"
	desc = "For self defense, and self offense."
	icon_state = "combatknife"
	item_state = "EB-knife"//"knife"
	attack_verb = list("slashed")
	force_divisor = 0.3
	block_chance = 15
	w_class = ITEM_SIZE_SMALL
	grab_sound_is_loud = TRUE
	grab_sound = 'sound/items/unholster_knife.ogg'
	equipsound = 'sound/items/holster_knife.ogg'
	sharpness = FALSE//No cutting peoples heads off with a knife please.
	weapon_speed_delay = 10
	drop_sound = 'sound/items/knife_drop.ogg'
	swing_sound = "blunt_swing"


/obj/item/material/sword/combat_knife/attack(mob/living/carbon/C as mob, mob/living/user as mob)
	if(user.a_intent == I_HELP && (C.handcuffed) && (istype(C.handcuffed, /obj/item/handcuffs/cable)))
		usr.visible_message("\The [usr] cuts \the [C]'s restraints with \the [src]!",\
		"You cut \the [C]'s restraints with \the [src]!",\
		"You hear cable being cut.")
		C.handcuffed = null
		if(C.buckled && C.buckled.buckle_require_restraints)
			C.buckled.unbuckle_mob()
		C.update_inv_handcuffed()
		return

	if(user.a_intent == I_HELP)
		remove_shrapnel(C, user)
	else
		..()


