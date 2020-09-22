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
			to_chat(user, "<span class='notice'>[H] is conscious, this will take about 5 seconds...</span>")
			if(!do_after(user, 5 SECONDS, H))
				to_chat(user, "<span class='notice'>You couldn't grab anything!</span>")
				return

		if(O && istype(O))  // if there is a dog tag
			if(S && istype(S))  // if there is a backpack
				if(S.can_be_inserted(O, user))  // if the backpack can take the dog tag
					S.handle_item_insertion(O)
					user.visible_message("<span class='notice'>\The [user] extracts \the [O] from \the [M] and puts it in \the [S]</span>")

				else if(user.put_in_any_hand_if_possible(O))  // if it cant, try to put it in hands
					user.visible_message("<span class='notice'>\The [user] extracts \the [O] from \the [M] and places it in their hand.</span>")

				else  // no free hands
					to_chat(user, "<span class='notice'>There is a [O] but you have no backpack or hand to put it!</span>")

			else if(user.put_in_any_hand_if_possible(O))  // if no backpack, try to put in hands
				user.visible_message("<span class='notice'>\The [user] extracts \the [O] from \the [M] and places it in their hand.</span>")

			else  // if no free hands
				to_chat(user, "<span class='notice'>There is a [O] but you have no backpack or hand to put it!</span>")

		else  // if theres no dog tag
			to_chat(user, "<span class='notice'>\The [H] has nothing to take!</span>")


