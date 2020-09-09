
/obj/item/organ/external/head
	organ_tag = BP_HEAD
	icon_name = "head"
	name = "head"
	slot_flags = SLOT_BELT
	max_damage = 100
	min_broken_damage = 50
	w_class = ITEM_SIZE_NORMAL
	body_part = HEAD
	vital = 1
	parent_organ = BP_CHEST
	joint = "jaw"
	amputation_point = "neck"
	gendered_icon = 1
	encased = "skull"
	artery_name = "carotid artery"
	cavity_name = "cranial"
	arterial_bleed_severity = 5
	break_sound = "headsmash"

	var/can_intake_reagents = 1
	var/eye_icon = "eyes_s"
	var/eye_icon_location = 'icons/mob/human_face.dmi'
	var/has_lips
	var/list/teeth_list = list()
	var/max_teeth = 32

/obj/item/organ/external/head/droplimb(clean, disintegrate = DROPLIMB_EDGE, ignore_children, silent)
	for(var/obj/item/stack/teeth/T in src)
		qdel(T)
	..()
	if(disintegrate == DROPLIMB_BLUNT)
		if(teeth_list.len)
			for(var/obj/item/stack/teeth/T in teeth_list)//Somehow this is generating teeth twice.
				qdel(T)

/obj/item/organ/external/head/fracture()//Your head now has way more health but if you break it you're gonna fucking feel it.
	..()
	for(var/obj/item/organ/internal/brain/B in src)
		B.take_damage(50)


/obj/item/organ/external/head/set_dna(var/datum/dna/new_dna)
	..()
	eye_icon = species.eye_icon
	eye_icon_location = species.eye_icon_location

/obj/item/organ/external/head/get_agony_multiplier()
	return (owner && owner.headcheck(organ_tag)) ? 1.50 : 1

/obj/item/organ/external/head/robotize(var/company, var/skip_prosthetics, var/keep_organs)
	if(company)
		var/datum/robolimb/R = all_robolimbs[company]
		if(R)
			can_intake_reagents = R.can_eat
			eye_icon = R.use_eye_icon
	. = ..(company, skip_prosthetics, 1)
	has_lips = null

/obj/item/organ/external/head/removed()
	if(owner)
		SetName("[owner.real_name]'s head")
		owner.drop_from_inventory(owner.glasses)
		owner.drop_from_inventory(owner.head)
		owner.drop_from_inventory(owner.l_ear)
		owner.drop_from_inventory(owner.r_ear)
		owner.drop_from_inventory(owner.wear_mask)
		spawn(1)
			owner.update_hair()
	..()

/obj/item/organ/external/head/take_damage(brute, burn, damage_flags, used_weapon = null)
	. = ..()
	if (!disfigured)
		if (brute_dam > 40)
			if (prob(50))
				disfigure("brute")
		if (burn_dam > 40)
			disfigure("burn")

/obj/item/organ/external/head/no_eyes
	eye_icon = "blank_eyes"

/obj/item/organ/external/head/update_icon()

	..()

	if(owner)
		if(eye_icon)
			var/icon/eyes_icon = new/icon(eye_icon_location, eye_icon)
			var/obj/item/organ/internal/eyes/eyes = owner.internal_organs_by_name[owner.species.vision_organ ? owner.species.vision_organ : BP_EYES]
			if(eyes)
				eyes_icon.Blend(rgb(eyes.eye_colour[1], eyes.eye_colour[2], eyes.eye_colour[3]), ICON_ADD)
			else
				eyes_icon.Blend(rgb(128,0,0), ICON_ADD)
			mob_icon.Blend(eyes_icon, ICON_OVERLAY)
			overlays |= eyes_icon

		if(owner.lip_style && robotic < ORGAN_ROBOT && (species && (species.appearance_flags & HAS_LIPS)))
			var/icon/lip_icon = new/icon('icons/mob/human_face.dmi', "lips_[owner.lip_style]_s")
			overlays |= lip_icon
			mob_icon.Blend(lip_icon, ICON_OVERLAY)

		overlays |= get_hair_icon()

	return mob_icon

/obj/item/organ/external/head/proc/get_hair_icon()
	var/image/res = image(species.icon_template,"")
	if(owner.f_style)
		var/datum/sprite_accessory/facial_hair_style = GLOB.facial_hair_styles_list[owner.f_style]
		if(facial_hair_style && facial_hair_style.species_allowed && (species.get_bodytype(owner) in facial_hair_style.species_allowed))
			var/icon/facial_s = new/icon("icon" = facial_hair_style.icon, "icon_state" = "[facial_hair_style.icon_state]_s")
			if(facial_hair_style.do_colouration)
				facial_s.Blend(rgb(owner.r_facial, owner.g_facial, owner.b_facial), facial_hair_style.blend)
			res.overlays |= facial_s

	if(owner.h_style)
		var/style = owner.h_style
		var/datum/sprite_accessory/hair/hair_style = GLOB.hair_styles_list[style]
		if(owner.head && (owner.head.flags_inv & BLOCKHEADHAIR))
			if(!(hair_style.flags & VERY_SHORT))
				hair_style = GLOB.hair_styles_list["Short Hair"]
		if(hair_style && (species.get_bodytype(owner) in hair_style.species_allowed))
			var/icon/hair_s = new/icon("icon" = hair_style.icon, "icon_state" = "[hair_style.icon_state]_s")
			if(hair_style.do_colouration && islist(h_col) && h_col.len >= 3)
				hair_s.Blend(rgb(h_col[1], h_col[2], h_col[3]), hair_style.blend)
			res.overlays |= hair_s
	return res


/obj/item/organ/external/head/proc/get_teeth() //returns collective amount of teeth
	var/amt = 0
	if(!teeth_list) teeth_list = list()
	for(var/obj/item/stack/teeth/T in teeth_list)
		amt += T.amount
	return amt

/obj/item/organ/external/head/proc/knock_out_teeth(throw_dir, num=32) //Won't support knocking teeth out of a dismembered head or anything like that yet.
	num = Clamp(num, 1, 32)
	var/done = FALSE
	if(teeth_list && teeth_list.len) //We still have teeth
		var/stacks = rand(1,3)
		for(var/curr = 1 to stacks) //Random amount of teeth stacks
			var/obj/item/stack/teeth/teeth = pick(teeth_list)
			if(!teeth || teeth.zero_amount()) return //No teeth left, abort!
			var/drop = 1 //Calculate the amount of teeth in the stack
			var/obj/item/stack/teeth/T = new teeth.type(owner.loc, drop)
			teeth.use(drop)
			T.add_blood(owner)
			playsound(owner, "trauma", 75, 0)
			var/turf/target = get_turf(owner.loc)
			var/range = rand(1, 3)
			for(var/i = 1; i < range; i++)
				var/turf/new_turf = get_step(target, throw_dir)
				target = new_turf
				if(new_turf.density)
					break
			T.throw_at(get_edge_target_turf(T,pick(GLOB.alldirs)),rand(1,3),30)
			T.loc:add_blood(owner)

			teeth.zero_amount() //Try to delete the teeth
			GLOB.teeth_lost += drop
			done = TRUE
	return done


/obj/item/stack/teeth
	name = "teeth"
	singular_name = "tooth"
	w_class = 1
	force = 0
	throwforce = 0
	max_amount = 32
	gender = PLURAL
	desc = "Welp. Someone had their teeth knocked out."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "tooth1"
	drop_sound = null

/obj/item/stack/teeth/New()
	..()
	icon_state = "tooth[rand(1,3)]"

/obj/item/stack/teeth/human
	name = "human teeth"
	singular_name = "human tooth"

/obj/item/stack/teeth/generic //Used for species without unique teeth defined yet
	name = "teeth"

/obj/item/stack/proc/zero_amount()//Teeth shit
	if(amount < 1)
		qdel(src)
		return 1
	return 0