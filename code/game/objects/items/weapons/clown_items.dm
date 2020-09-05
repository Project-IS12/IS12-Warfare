/* Clown Items
 * Contains:
 * 		Banana Peels
 *		Bike Horns
 */

/*
 * Banana Peals
 */
/obj/item/weapon/bananapeel/Crossed(AM as mob|obj)
	if (istype(AM, /mob/living))
		var/mob/living/M = AM
		M.slip("the [src.name]",4)
/*
 * Bike Horns
 */
/obj/item/weapon/bikehorn
	name = "bike horn"
	desc = "A horn off of a bicycle."
	icon = 'icons/obj/items.dmi'
	icon_state = "bike_horn"
	item_state = "bike_horn"
	throwforce = 3
	w_class = ITEM_SIZE_SMALL
	throw_speed = 3
	throw_range = 15
	attack_verb = list("HONKED")
	var/spam_flag = 0

/obj/item/weapon/bikehorn/attack_self(mob/user as mob)
	if (spam_flag == 0)
		spam_flag = 1
		playsound(src.loc, 'sound/items/bikehorn.ogg', 50, 1)
		src.add_fingerprint(user)
		spawn(20)
			spam_flag = 0
	return

/obj/item/weapon/randy
	name = "Plushie Leha"
	icon = 'icons/obj/items.dmi'
	icon_state = "rendos"
	item_state = "bike_horn"
	w_class = ITEM_SIZE_SMALL
	var/list/jokes = list("Дорогая, я назвал нашего сына лайбеб!", "Но зато у нас есть лайбеб!", "Люблю мягкие игрушки из твердых людей..", "Я теперь сверхчеловек!", "Мне еще и помогать тебе лайбах имитировать?", "пишу донос", "слишком много войны...", "начинай за собой следить и все наладится", "Остался, разобрался, значит - мешком ебнутый", "необходимое зло, чтобы получить результат")
	var/list/rendos_sounds = list('sound/voice/allo.ogg')
	var/spam_flag = 0

/obj/item/weapon/randy/attack_self(mob/user)
	if(!spam_flag)
		spam_flag = 1
		playsound(src.loc, pick(rendos_sounds), 50, 1)
		user.visible_message("<b>[src.name]</b> says, \"[pick(jokes)]\"")
		spawn(40)
			spam_flag = 0