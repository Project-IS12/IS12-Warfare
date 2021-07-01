/* Surgery Tools
 * Contains:
 *		Retractor
 *		Hemostat
 *		Cautery
 *		Surgical Drill
 *		Scalpel
 *		Circular Saw
 */

/*
 * Retractor
 */
/obj/item/retractor
	name = "retractor"
	desc = "Retracts stuff."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "retractor"
	matter = list(DEFAULT_WALL_MATERIAL = 10000, "glass" = 5000)
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	w_class = ITEM_SIZE_SMALL
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)

/*
 * Hemostat
 */
/obj/item/hemostat
	name = "hemostat"
	desc = "You think you have seen this before."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "hemostat"
	matter = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 2500)
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	w_class = ITEM_SIZE_SMALL
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	attack_verb = list("attacked", "pinched")

/*
 * Cautery
 */
/obj/item/cautery
	name = "cautery"
	desc = "This stops bleeding."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "cautery"
	matter = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 2500)
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	w_class = ITEM_SIZE_SMALL
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	attack_verb = list("burnt")

/obj/item/suture
	name = "suture"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "suture"
	desc = "Used to stitch up arteries and wounds."
	matter = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 2500)
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	w_class = ITEM_SIZE_SMALL
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)

/obj/item/suture/attack(mob/living/carbon/human/H as mob, mob/living/userr, var/target_zone)//All of this is snowflake because surgery is broken.
	//Checks if they're human, have a limb, and have the skill to fix it.
	if(!ishuman(H))
		return ..()
	if(!ishuman(userr))
		return ..()

	var/mob/living/carbon/human/user = userr
	var/obj/item/organ/external/affected = H.get_organ(target_zone)

	if(!affected)
		return ..()


	if(!(affected.status & ORGAN_ARTERY_CUT) && !affected.wounds.len)//There is nothing to fix don't fix anything.
		return

	//Ok all the checks are over let's do the quick fix.
	if(!user.doing_something)
		user.doing_something = TRUE
		if(affected.status & ORGAN_ARTERY_CUT)//Fix arteries first,
			user.visible_message("<span class='notice'>[user] begins to suture [H]'s arteries.")
			playsound(src, 'sound/weapons/suture.ogg', 70, FALSE)
			if(do_mob(user, H, (backwards_skill_scale(user.SKILL_LEVEL(medical)) * 5)))
				user.visible_message("<span class='notice'>[user] has patched the [affected.artery_name] in [H]'s [affected.name] with \the [src.name].</span>", \
				"<span class='notice'>You have patched the [affected.artery_name] in [H]'s [affected.name] with \the [src.name].</span>")
				affected.status &= ~ORGAN_ARTERY_CUT

		else//Then fix wounds if they do it again.
			for(var/datum/wound/W in affected.wounds)
				if(W.damage)
					user.visible_message("<span class='notice'>[user] begins to suture up [H]'s wounds.")
					playsound(src, 'sound/weapons/suture.ogg', 40, FALSE)
					H.custom_pain("The pain in your [affected.name] is unbearable!",rand(50, 65),affecting = affected)
					if(do_mob(user, H, (backwards_skill_scale(user.SKILL_LEVEL(medical)) * 5)))
						// Close it up to a point that it can be bandaged and heal naturally!
						W.heal_damage(rand(5,20)+10)
						if(W.damage >= W.autoheal_cutoff)
							user.visible_message("<span class='notice'>\The [user] partially closes a wound on [H]'s [affected.name] with \the [src.name].</span>", \
							"<span class='notice'>You partially close a wound on [H]'s [affected.name] with \the [src.name].</span>")
						else
							user.visible_message("<span class='notice'>\The [user] closes a wound on [H]'s [affected.name] with \the [src.name].</span>", \
							"<span class='notice'>You close a wound on [H]'s [affected.name] with \the [src.name].</span>")
							if(!W.damage)
								affected.wounds -= W
								qdel(W)
							else if(W.damage <= 10)
								W.clamped = 1
				else
					to_chat(user, "There are no wounds to patch up.")
				break

		affected.update_damages()
		user.doing_something = FALSE
		//else
		//	user.doing_something = FALSE
	else
		to_chat(user, "You're already trying to suture them.")



/*
 * Surgical Drill
 */
/obj/item/surgicaldrill
	name = "surgical drill"
	desc = "You can drill using this item. You dig?"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "drill"
	hitsound = 'sound/weapons/circsawhit.ogg'
	matter = list(DEFAULT_WALL_MATERIAL = 15000, "glass" = 10000)
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	force = 0
	w_class = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	attack_verb = list("drilled")

/*
 * Scalpel
 */
/obj/item/scalpel
	name = "scalpel"
	desc = "Cut, cut, and once more cut."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "scalpel"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	force = 0
	sharp = 1
	sharpness = 1
	//edge = 1 //WHY THE FUCK DOES THIS HAVE EDGE YOU'RE NOT GOING TO CUT SOMEONE'S HEAD OFF WITH A SCALPEL
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS
	throwforce = 5.0
	throw_speed = 3
	throw_range = 5
	hitsound = 'sound/weapons/bladeslice.ogg'
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 10000, "glass" = 5000)
	attack_verb = list("slashed", "stabbed")

/*
 * Researchable Scalpels
 */
/obj/item/scalpel/laser1
	name = "laser scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field.  This one looks basic and could be improved."
	icon_state = "scalpel_laser1_on"
	damtype = "fire"

/obj/item/scalpel/laser2
	name = "laser scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field.  This one looks somewhat advanced."
	icon_state = "scalpel_laser2_on"
	damtype = "fire"
	force = 12.0

/obj/item/scalpel/laser3
	name = "laser scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field.  This one looks to be the pinnacle of precision energy cutlery!"
	icon_state = "scalpel_laser3_on"
	damtype = "fire"
	force = 15.0

/obj/item/scalpel/manager
	name = "incision management system"
	desc = "A true extension of the surgeon's body, this marvel instantly and completely prepares an incision allowing for the immediate commencement of therapeutic steps."
	icon_state = "scalpel_manager_on"
	force = 7.5

/*
 * Circular Saw
 */
/obj/item/circular_saw
	name = "bone saw"
	desc = "For heavy duty cutting."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "saw3"
	hitsound = 'sound/weapons/bladeslice.ogg'
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	force = 0
	w_class = ITEM_SIZE_NORMAL
	throwforce = 9.0
	throw_speed = 3
	throw_range = 5
	sharpness = 25
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 20000,"glass" = 10000)
	attack_verb = list("slashed")
	sharp = 1
	edge = 1

//misc, formerly from code/defines/weapons.dm
/obj/item/bonegel
	name = "bone gel"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "bone-gel"
	force = 0
	w_class = ITEM_SIZE_SMALL
	throwforce = 1.0

/obj/item/FixOVein
	name = "FixOVein"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "fixovein"
	force = 0
	throwforce = 1.0
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 3)
	w_class = ITEM_SIZE_SMALL
	var/usage_amount = 10


/obj/item/bonesetter
	name = "bone setter"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "bone setter"
	force = 0
	throwforce = 9.0
	throw_speed = 3
	throw_range = 5
	w_class = ITEM_SIZE_SMALL
	attack_verb = list("attacked", "hit", "bludgeoned")
