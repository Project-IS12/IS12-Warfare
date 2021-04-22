/obj/item/material/stick
	name = "stick"
	desc = "You feel the urge to poke someone with this."
	icon_state = "stick"
	item_state = "stickmat"
	force_divisor = 0.1
	thrown_force_divisor = 0.1
	w_class = ITEM_SIZE_NORMAL
	default_material = "wood"
	attack_verb = list("poked", "jabbed")


/obj/item/material/stick/attack_self(mob/user as mob)
	user.visible_message(SPAN_WARNING("\The [user] snaps [src]."), SPAN_WARNING("You snap [src]."))
	shatter(0)


/obj/item/material/stick/attackby(obj/item/W as obj, mob/user as mob)
	if(W.sharp && W.edge && !sharp)
		user.visible_message(SPAN_WARNING("[user] sharpens [src] with [W]."), SPAN_WARNING("You sharpen [src] using [W]."))
		sharp = 1 //Sharpen stick
		SetName("sharpened " + name)
		update_force()
	return ..()


/obj/item/material/stick/attack(mob/M, mob/user)
	if(user != M && user.a_intent == I_HELP)
		//Playful poking is its own thing
		user.visible_message(SPAN_NOTICE("[user] pokes [M] with [src]."), SPAN_NOTICE("You poke [M] with [src]."))
		//Consider adding a check to see if target is dead
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		user.do_attack_animation(M)
		return
	return ..()
