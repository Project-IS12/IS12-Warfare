////////////////////////////////////////////////////////////////////////////////
/// HYPOSPRAY
////////////////////////////////////////////////////////////////////////////////

/obj/item/reagent_containers/hypospray //obsolete, use hypospray/vial for the actual hypospray item
	name = "hypospray"
	desc = "The DeForest Medical Corporation hypospray is a sterile, air-needle autoinjector for rapid administration of drugs to patients."
	icon = 'icons/obj/syringe.dmi'
	item_state = "hypo"
	icon_state = "hypo"
	origin_tech = list(TECH_MATERIAL = 4, TECH_BIO = 5)
	amount_per_transfer_from_this = 5
	unacidable = 1
	volume = 30
	possible_transfer_amounts = null
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	slot_flags = SLOT_EARS
	w_class = ITEM_SIZE_SMALL
	var/inject_sound = 'sound/items/hypoinject.ogg'

///obj/item/reagent_containers/hypospray/New() //comment this to make hypos start off empty
//	..()
//	reagents.add_reagent(/datum/reagent/tricordrazine, 30)
//	return

/obj/item/reagent_containers/hypospray/do_surgery(mob/living/carbon/M, mob/living/user)
	if(user.a_intent != I_HELP) //in case it is ever used as a surgery tool
		return ..()
	attack(M, user)
	return 1

/obj/item/reagent_containers/hypospray/attack(mob/living/M as mob, mob/user as mob)
	if(!reagents.total_volume)
		to_chat(user, "<span class='warning'>[src] is empty.</span>")
		return
	if (!istype(M))
		return

	var/mob/living/carbon/human/H = M
	if(istype(H))
		var/obj/item/organ/external/affected = H.get_organ(user.zone_sel.selecting)
		if(!affected)
			to_chat(user, "<span class='danger'>\The [H] is missing that limb!</span>")
			return
		else if(affected.robotic >= ORGAN_ROBOT)
			to_chat(user, "<span class='danger'>You cannot inject a robotic limb.</span>")
			return

	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
	//user.do_attack_animation(M)
	to_chat(user, "<span class='notice'>You inject [M] with [src].</span>")
	to_chat(M, "<span class='notice'>You feel a tiny prick!</span>")
	user.visible_message("<span class='warning'>[user] injects [M] with [src].</span>")

	if(M.reagents)
		var/contained = reagentlist()
		var/trans = reagents.trans_to_mob(M, amount_per_transfer_from_this, CHEM_BLOOD)
		admin_inject_log(user, M, src, contained, trans)
		to_chat(user, "<span class='notice'>[trans] units injected. [reagents.total_volume] units remaining in \the [src].</span>")

	playsound(M, inject_sound, 100)
	return

/obj/item/reagent_containers/hypospray/vial
	name = "hypospray"
	item_state = "autoinjector"
	desc = "The DeForest Medical Corporation hypospray is a sterile, air-needle autoinjector for rapid administration of drugs to patients. Uses a replacable 30u vial."
	var/obj/item/reagent_containers/glass/beaker/vial/loaded_vial
	volume = 0

/obj/item/reagent_containers/hypospray/vial/New()
	..()
	loaded_vial = new /obj/item/reagent_containers/glass/beaker/vial(src)
	volume = loaded_vial.volume
	reagents.maximum_volume = loaded_vial.reagents.maximum_volume

/obj/item/reagent_containers/hypospray/vial/attack_hand(mob/user as mob)
	if(user.get_inactive_hand() == src)
		if(loaded_vial)
			reagents.trans_to_holder(loaded_vial.reagents,volume)
			reagents.maximum_volume = 0
			loaded_vial.update_icon()
			user.put_in_hands(loaded_vial)
			loaded_vial = null
			to_chat(user, "You remove the vial from the [src].")
			update_icon()
			playsound(src.loc, 'sound/weapons/flipblade.ogg', 50, 1)
			return
		..()
	else
		return ..()

/obj/item/reagent_containers/hypospray/vial/attackby(obj/item/W, mob/user as mob)
	if(istype(W, /obj/item/reagent_containers/glass/beaker/vial))
		if(!loaded_vial)
			if(!do_after(user,10) || loaded_vial || !(W in user))
				return 0
			if(W.is_open_container())
				W.atom_flags ^= ATOM_FLAG_OPEN_CONTAINER
				W.update_icon()
			user.drop_item()
			W.forceMove(src)
			loaded_vial = W
			reagents.maximum_volume = loaded_vial.reagents.maximum_volume
			loaded_vial.reagents.trans_to_holder(reagents,volume)
			user.visible_message("<span class='notice'>[user] has loaded [W] into \the [src].</span>","<span class='notice'>You load \the [W] into \the [src].</span>")
			update_icon()
			playsound(src.loc, 'sound/weapons/empty.ogg', 50, 1)
		else
			to_chat(user,"<span class='notice'>\The [src] already has a vial.</span>")
	else
		..()

/obj/item/reagent_containers/hypospray/autoinjector
	name = "autoinjector"
	desc = "A rapid and safe way to administer small amounts of drugs by untrained or trained personnel."
	icon_state = "blue"
	item_state = "autoinjector"
	amount_per_transfer_from_this = 5
	volume = 5
	origin_tech = list(TECH_MATERIAL = 2, TECH_BIO = 2)
	var/list/starts_with = list(/datum/reagent/inaprovaline = 5)

/obj/item/reagent_containers/hypospray/autoinjector/New()
	..()
	for(var/T in starts_with)
		reagents.add_reagent(T, starts_with[T])
	update_icon()
	return

/obj/item/reagent_containers/hypospray/autoinjector/attack(mob/M as mob, mob/user as mob)
	..()
	if(reagents.total_volume <= 0) //Prevents autoinjectors to be refilled.
		atom_flags &= ~ATOM_FLAG_OPEN_CONTAINER
	update_icon()
	return

/obj/item/reagent_containers/hypospray/autoinjector/update_icon()
	if(reagents.total_volume > 0)
		icon_state = "[initial(icon_state)]1"
	else
		icon_state = "[initial(icon_state)]0"

/obj/item/reagent_containers/hypospray/autoinjector/examine(mob/user)
	. = ..(user)
	if(reagents && reagents.reagent_list.len)
		to_chat(user, "<span class='notice'>It is currently loaded.</span>")
	else
		to_chat(user, "<span class='notice'>It is spent.</span>")

/obj/item/reagent_containers/hypospray/autoinjector/detox
	name = "autoinjector (antitox)"
	icon_state = "green"
	starts_with = list(/datum/reagent/dylovene = 5)

/obj/item/reagent_containers/hypospray/autoinjector/pain
	name = "autoinjector (painkiller)"
	icon_state = "purple"
	starts_with = list(/datum/reagent/tramadol = 10)

/obj/item/reagent_containers/hypospray/autoinjector/combatpain
	name = "autoinjector (oxycodone)"
	icon_state = "black"
	starts_with = list(/datum/reagent/tramadol/oxycodone = 5)

/obj/item/reagent_containers/hypospray/autoinjector/revive
	name = "autoinjector (atepoine)"
	icon_state = "black"
	starts_with = list(/datum/reagent/atepoine = 10)

/obj/item/reagent_containers/hypospray/autoinjector/mindbreaker
	name = "autoinjector"
	icon_state = "black"
	starts_with = list(/datum/reagent/mindbreaker = 5)

/obj/item/reagent_containers/hypospray/autoinjector/blood
	name = "blood injector"
	desc = "A blood injector, contained O- blood."
	icon_state = "n"

	amount_per_transfer_from_this = 50
	volume = 500
	var/blood_type = "O-"

/obj/item/reagent_containers/hypospray/autoinjector/blood/New()
	..()
	if(blood_type)
		reagents.add_reagent(/datum/reagent/blood, volume, list("donor" = null, "blood_DNA" = null, "blood_type" = blood_type, "trace_chem" = null, "virus2" = list(), "antibodies" = list()))

/obj/item/reagent_containers/hypospray/autoinjector/morphine
	name = "morphine syrette"
	icon_state = "syrette_closed"
	starts_with = list(/datum/reagent/tramadol/morphine = 10)
	inject_sound = 'sound/items/syrette_inject.ogg'

/obj/item/reagent_containers/hypospray/autoinjector/morphine/update_icon()
	if(reagents.total_volume > 0)
		icon_state = "syrette_closed"
	else
		icon_state = "syrette_open"

/obj/item/reagent_containers/glass/ampule
	name = "ampule"
	desc = "An ampule. Holds reagents. Usually pain medication. Use a syrette on it to refill the syrette."
	icon = 'icons/obj/syringe.dmi'
	icon_state = "ampule"
	item_state = null
	amount_per_transfer_from_this = 10
	w_class = ITEM_SIZE_SMALL
	slot_flags = SLOT_EARS
	volume = 100
	var/closed = 1

/obj/item/reagent_containers/glass/ampule/attack_self()
	..()
	if(closed)
		to_chat(usr, "<span class='notice'>You crack \the [src], opening it.</span>")
		playsound(src, 'sound/items/plastic_rip.ogg', 100)
		atom_flags |= ATOM_FLAG_OPEN_CONTAINER
		icon_state = "[initial(icon_state)]_open"
		closed = 0
	else
		return
	update_icon()

/obj/item/reagent_containers/glass/ampule/morphine
	name = "morphine ampule"
	New()
		..()
		reagents.add_reagent(/datum/reagent/tramadol/morphine, 100)

/obj/item/reagent_containers/glass/ampule/attackby(obj/item/W, mob/user as mob)
	if(istype(W, /obj/item/reagent_containers/hypospray/autoinjector))
		var/obj/item/reagent_containers/hypospray/autoinjector/A = W
		if(src.reagents)
			var/trans = reagents.trans_to_obj(A, amount_per_transfer_from_this)
			to_chat(user, "<span class='notice'>[trans] units refilled into \the [A]. [reagents.total_volume] units remaining in \the [src].</span>")
			A.update_icon()
