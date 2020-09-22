/*
					=======
					STOMACH
					=======

what:		The organ which processes what your body
			has consumed.

			Stomachs will check the reagent of the food you take
			and if it isn't in the list of acceptable reagents
			it will react badly to the transfer.

why:		It seems very weird that this organ is missing!
			I plan to rectify this and remove all the magic
			code regarding 'bite size'. This will also force
			you to vomit if the stomach does any of the
			following:
						-eat too much
						-eat something nasty (poo)
						-become sick
			The benefit of a stomach is that by eating food
			you could also force chunks of food to spew back
			out into the floor (which is gross but cool)

checklist:	stomach class [x]
			stomach process [/]
				- Get a list of things eaten [/]
				- React based on things eaten [/]
				- Pain on eating when bruised [?]
				- Puking when hurt [/]


issues:		CHEM_BLOOD doesn't actually react to nutrients...

t.Fridge

*/
/obj/item/organ/internal/stomach
	name = "stomach"
	icon_state = "stomach"
	w_class = ITEM_SIZE_SMALL
	organ_tag = BP_STOMACH
	parent_organ = BP_CHEST
	min_bruised_damage = 25
	min_broken_damage = 45
	max_damage = 80
	var/eat_delay = 5
	var/eat_time = 0
	var/consume_amount = 0.2 //how many units of the reagents does the mob absorb each absorb_contents() call
	//consume amount is sent directly to blood, some crazy shit happens with nutrition, check "eatable.dm" for details

	var/obj/item/storage/special/inventory

	/*
	the list of acceptable reagents that the stomach accepts, by default nutriments, drinks, and ethanol are okay
	I may need to change this due to the nature of reagents being so broad but
	*/
//	var/list/accepted_reagents = list(/datum/reagent/nutriment, /datum/reagent/drink /datum/reagent/ethanol)


/*
This is the stomach inventory that is based off of Kyrah's
special inventory. I think it would be cool if you could
directly access the stomach contents of someone, or something.
Why? Well it could help with an autopsy (trying to figure out
what killed someone) or perhaps certain creatures could eat things
and well. the stomach is where such a thing would end up so you gotta
cut it out and check it.

*/
/obj/item/storage/special/stomach
	max_w_class = ITEM_SIZE_SMALL
	storage_slots = 6 //default for a human, change it to be more for other animals or less

/obj/item/organ/internal/stomach/New()
	inventory = new /obj/item/storage/special/stomach()
	inventory.loc = src
	inventory.name = name

/obj/item/organ/internal/stomach/Process()
	..()

	if(!owner)
		return

	if(world.time - eat_time >= eat_delay)
		eat_time = world.time
		absorb_contents()

		//if the stomach is 'broken' it should definitely fuck shit up
		if(is_broken())
			if(prob(2))
				owner.vomit()

/*
	===============
	Absorb contents
	===============

Purpose:	This is what's going to cycle through the contents of the stomach
			and add the food chunk's reagents to the ingest container of a human
			if the food chunk is empty then qdel itself

*/
/obj/item/organ/internal/stomach/proc/absorb_contents()
	for(var/obj/item/reagent_containers/eatable/F in inventory)
		if(F.reagents.total_volume < consume_amount)
			F.reagents.trans_to_mob(owner, F.reagents.total_volume, CHEM_BLOOD)
		//	to_chat(owner, "[F] sent [F.reagents.total_volume] of whats left.")
		else
			F.reagents.trans_to_mob(owner, consume_amount, CHEM_BLOOD)
		//	to_chat(owner, "[F] sent [consume_amount] of foodthing, I hope.")

		if(F.reagents.total_volume < 0.1)
			var/obj/item/organ/internal/bowels/B = owner.internal_organs_by_name[BP_BOWELS]
			if(!B)
				to_chat(owner, "You feel a weight in your stomach that just wont go away...")
				return
			var/obj/item/storage/special/bowels/I = B.inventory
			if(!I)
				to_chat(owner, "this shouldn't trigger.")
				return
			to_chat(owner, "[F] moved to the bowels.")
			F.forceMove(I)

	return

///obj/item/organ/internal/stomach/proc/eat()
	//eat function for a mob. I figure this may be the best place for it since it is definitely stomach related.

//if you can reach the stomach as an item, draggin it to yourself will open contents.
/obj/item/organ/internal/stomach/MouseDrop(atom/over)
	inventory.attack_hand(usr)