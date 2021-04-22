/obj/item/tagnabber
	name = "Tagnabber"
	desc = "Use this on a downed soldier to remove their dogtag!"
	icon_state = "nullrod"
	item_state = "nullrod"
	slot_flags = SLOT_BELT
	w_class = ITEM_SIZE_NORMAL

/obj/item/tagnabber/attack(mob/living/M, mob/living/user, target_zone, special)
	. = ..()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/card/id/O = H.get_equipped_item(slot_wear_id)
		var/obj/item/storage/S = user.get_equipped_item(slot_back)

		if(!H.stat)
			to_chat(user, SPAN_NOTICE("[H] is conscious, this will take about 5 seconds..."))
			if(!do_after(user, 5 SECONDS, H))
				to_chat(user, SPAN_NOTICE("You couldn't grab anything!"))
				return

		if(O && istype(O))  // if there is a dog tag
			if(S && istype(S))  // if there is a backpack
				if(S.can_be_inserted(O, user))  // if the backpack can take the dog tag
					S.handle_item_insertion(O)
					user.visible_message(SPAN_NOTICE("\The [user] extracts \the [O] from \the [M] and puts it in \the [S]"))

				else if(user.put_in_any_hand_if_possible(O))  // if it cant, try to put it in hands
					user.visible_message(SPAN_NOTICE("\The [user] extracts \the [O] from \the [M] and places it in their hand."))

				else  // no free hands
					to_chat(user, SPAN_NOTICE("There is a [O] but you have no backpack or hand to put it!"))

			else if(user.put_in_any_hand_if_possible(O))  // if no backpack, try to put in hands
				user.visible_message(SPAN_NOTICE("\The [user] extracts \the [O] from \the [M] and places it in their hand."))

			else  // if no free hands
				to_chat(user, SPAN_NOTICE("There is a [O] but you have no backpack or hand to put it!"))

		else  // if theres no dog tag
			to_chat(user, SPAN_NOTICE("\The [H] has nothing to take!"))


