/* First aid storage
 * Contains:
 *		First Aid Kits
 * 		Pill Bottles
 */

/*
 * First Aid Kits
 */
/obj/item/storage/firstaid
	name = "first-aid kit"
	desc = "It's an emergency medical kit for those serious boo-boos."
	icon_state = "firstaid"
	throw_speed = 2
	throw_range = 8
	max_w_class = ITEM_SIZE_SMALL
	max_storage_space = DEFAULT_BOX_STORAGE
	use_sound = 'sound/effects/storage/briefcase.ogg'

/obj/item/storage/firstaid/empty
	icon_state = "firstaid"
	name = "First-Aid (empty)"

/obj/item/storage/firstaid/fire
	name = "fire first-aid kit"
	desc = "It's an emergency medical kit for when the toxins lab <i>-spontaneously-</i> burns down."
	icon_state = "ointment"
	item_state = "firstaid-ointment"

	startswith = list(
		/obj/item/device/healthanalyzer,
		/obj/item/reagent_containers/hypospray/autoinjector,
		/obj/item/stack/medical/ointment,
		/obj/item/storage/pill_bottle/kelotane,
		/obj/item/storage/pill_bottle/paracetamol
		)

/obj/item/storage/firstaid/fire/New()
	..()
	icon_state = pick("ointment","firefirstaid")

/obj/item/storage/firstaid/regular
	icon_state = "firstaid"

	startswith = list(
		/obj/item/stack/medical/bruise_pack = 2,
		/obj/item/stack/medical/ointment = 1,
		/obj/item/device/healthanalyzer,
		/obj/item/storage/pill_bottle/inaprovaline,
		/obj/item/storage/pill_bottle/antidexafen,
		/obj/item/storage/pill_bottle/paracetamol
		)

/obj/item/storage/firstaid/toxin
	name = "toxin first aid"
	desc = "Used to treat when you have a high amount of toxins in your body."
	icon_state = "antitoxin"
	item_state = "firstaid-toxin"

	startswith = list(
		/obj/item/reagent_containers/syringe/antitoxin = 3,
		/obj/item/storage/pill_bottle/antitox,
		/obj/item/device/healthanalyzer,
		)

/obj/item/storage/firstaid/toxin/New()
	..()
	icon_state = pick("antitoxin","antitoxfirstaid","antitoxfirstaid2","antitoxfirstaid3")

/obj/item/storage/firstaid/o2
	name = "oxygen deprivation first aid"
	desc = "A box full of oxygen goodies."
	icon_state = "o2"
	item_state = "firstaid-o2"

	startswith = list(
		/obj/item/storage/pill_bottle/dexalin,
		/obj/item/reagent_containers/hypospray/autoinjector,
		/obj/item/reagent_containers/syringe/inaprovaline,
		/obj/item/device/healthanalyzer,
		)

/obj/item/storage/firstaid/adv
	name = "advanced first-aid kit"
	desc = "Contains advanced medical treatments."
	icon_state = "advfirstaid"
	item_state = "firstaid-advanced"

	startswith = list(
		/obj/item/reagent_containers/hypospray/autoinjector,
		/obj/item/stack/medical/advanced/bruise_pack = 3,
		/obj/item/stack/medical/advanced/ointment = 2,
		/obj/item/stack/medical/splint
		)

/obj/item/storage/firstaid/combat
	name = "combat medical kit"
	desc = "Contains advanced medical treatments."
	icon_state = "bezerk"
	item_state = "firstaid-advanced"

	startswith = list(
		/obj/item/storage/pill_bottle/bicaridine,
		/obj/item/storage/pill_bottle/dermaline,
		/obj/item/storage/pill_bottle/dexalin_plus,
		/obj/item/storage/pill_bottle/dylovene,
		/obj/item/storage/pill_bottle/tramadol,
		/obj/item/storage/pill_bottle/spaceacillin,
		/obj/item/stack/medical/splint,
		)

/obj/item/storage/firstaid/surgery
	name = "surgery kit"
	desc = "Contains tools for surgery. Has precise foam fitting for safe transport and automatically sterilizes the content between uses."
	icon_state = "surgerykit"
	item_state = "firstaid-surgery"

	storage_slots = 14
	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = null

	can_hold = list(
		/obj/item/bonesetter,
		/obj/item/cautery,
		/obj/item/circular_saw,
		/obj/item/hemostat,
		/obj/item/retractor,
		/obj/item/scalpel,
		/obj/item/surgicaldrill,
		/obj/item/bonegel,
		/obj/item/suture,
		/obj/item/FixOVein,
		/obj/item/stack/medical/advanced/bruise_pack,
		/obj/item/stack/nanopaste
		)

	startswith = list(
		/obj/item/bonesetter,
		/obj/item/cautery,
		/obj/item/circular_saw,
		/obj/item/hemostat,
		/obj/item/retractor,
		/obj/item/scalpel,
		/obj/item/surgicaldrill,
		/obj/item/bonegel,
		/obj/item/suture,
		/obj/item/stack/medical/advanced/bruise_pack
		)

/*
 * Pill Bottles
 */
/obj/item/storage/pill_bottle
	name = "pill bottle"
	desc = "It's an airtight container for storing medication."
	icon_state = "pill_canister"
	icon = 'icons/obj/chemical.dmi'
	item_state = "contsolid"
	w_class = ITEM_SIZE_SMALL
	max_w_class = ITEM_SIZE_TINY
	max_storage_space = 21
	can_hold = list(/obj/item/reagent_containers/pill,/obj/item/dice,/obj/item/paper)
	allow_quick_gather = 1
	use_to_pickup = 1
	use_sound = 'sound/effects/storage/pillbottle.ogg'

/obj/item/storage/pill_bottle/attack_self(mob/living/user)
	if(user.get_inactive_hand())
		to_chat(user, "<span class='notice'>You need an empty hand to take something out.</span>")
		return
	if(contents.len)
		var/obj/item/I = contents[1]
		if(!remove_from_storage(I,user))
			return
		if(user.put_in_inactive_hand(I))
			to_chat(user, "<span class='notice'>You take \the [I] out of \the [src].</span>")
			playsound(user, use_sound, 100)
			if(iscarbon(user))
				var/mob/living/carbon/C = user
				C.swap_hand()
		else
			I.dropInto(loc)
			to_chat(user, "<span class='notice'>You fumble around with \the [src] and drop \the [I] on the floor.</span>")
	else
		to_chat(user, "<span class='warning'>\The [src] is empty.</span>")

/obj/item/storage/pill_bottle/antitox
	name = "bottle of Dylovene pills"
	desc = "Contains pills used to counter toxins."

	startswith = list(/obj/item/reagent_containers/pill/antitox = 21)

/obj/item/storage/pill_bottle/bicaridine
	name = "bottle of Bicaridine pills"
	desc = "Contains pills used to stabilize the severely injured."

	startswith = list(/obj/item/reagent_containers/pill/bicaridine = 21)

/obj/item/storage/pill_bottle/dexalin_plus
	name = "bottle of Dexalin Plus pills"
	desc = "Contains pills used to treat extreme cases of oxygen deprivation."

	startswith = list(/obj/item/reagent_containers/pill/dexalin_plus = 14)

/obj/item/storage/pill_bottle/dexalin
	name = "bottle of Dexalin pills"
	desc = "Contains pills used to treat oxygen deprivation."

	startswith = list(/obj/item/reagent_containers/pill/dexalin = 21)

/obj/item/storage/pill_bottle/dermaline
	name = "bottle of Dermaline pills"
	desc = "Contains pills used to treat burn wounds."

	startswith = list(/obj/item/reagent_containers/pill/dermaline = 14)

/obj/item/storage/pill_bottle/dylovene
	name = "bottle of Dylovene pills"
	desc = "Contains pills used to treat toxic substances in the blood."

	startswith = list(/obj/item/reagent_containers/pill/dylovene = 21)

/obj/item/storage/pill_bottle/inaprovaline
	name = "bottle of Inaprovaline pills"
	desc = "Contains pills used to stabilize patients."

	startswith = list(/obj/item/reagent_containers/pill/inaprovaline = 21)

/obj/item/storage/pill_bottle/kelotane
	name = "bottle of kelotane pills"
	desc = "Contains pills used to treat burns."

	startswith = list(/obj/item/reagent_containers/pill/kelotane = 21)

/obj/item/storage/pill_bottle/spaceacillin
	name = "bottle of Spaceacillin pills"
	desc = "A theta-lactam antibiotic. Effective against many diseases likely to be encountered in space."

	startswith = list(/obj/item/reagent_containers/pill/spaceacillin = 14)

/obj/item/storage/pill_bottle/tramadol
	name = "bottle of Tramadol pills"
	desc = "Contains pills used to relieve pain."

	startswith = list(/obj/item/reagent_containers/pill/tramadol = 14)

//Baycode specific Psychiatry pills.
/obj/item/storage/pill_bottle/citalopram
	name = "bottle of Citalopram pills"
	desc = "Mild antidepressant. For use in individuals suffering from depression or anxiety. 15u dose per pill."

	startswith = list(/obj/item/reagent_containers/pill/citalopram = 21)

/obj/item/storage/pill_bottle/methylphenidate
	name = "bottle of Methylphenidate pills"
	desc = "Mental stimulant. For use in individuals suffering from ADHD, or general concentration issues. 15u dose per pill."

	startswith = list(/obj/item/reagent_containers/pill/methylphenidate = 21)

/obj/item/storage/pill_bottle/paroxetine
	name = "bottle of Paroxetine pills"
	desc = "High-strength antidepressant. Only for use in severe depression. 10u dose per pill. <span class='warning'>WARNING: side-effects may include hallucinations.</span>"

	startswith = list(/obj/item/reagent_containers/pill/paroxetine = 14)

/obj/item/storage/pill_bottle/antidexafen
	name = "bottle of cold medicine pills"
	desc = "All-in-one cold medicine. 15u dose per pill. Safe for babies like you!"

	startswith = list(/obj/item/reagent_containers/pill/antidexafen = 21)

/obj/item/storage/pill_bottle/paracetamol
	name = "bottle of paracetamol"
	desc = "Mild painkiller, also known as Tylenol. Won't fix the cause of your headache (unlike cyanide), but might make it bearable."

	startswith = list(/obj/item/reagent_containers/pill/paracetamol = 21)
