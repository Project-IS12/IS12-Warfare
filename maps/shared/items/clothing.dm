//I'LL MOVE THIS SOMEWHERE ELSE SOON AS I GET TO IT
/obj/item/clothing/under/rank/undertaker
	name = "undertaker's uniform"
	desc = "A suit worn by that creepy guy who messes with dead bodies."
	icon_state = "undertaker"
	worn_state = "undertaker"
	item_state = "undertaker"


/obj/item/clothing/suit/undertaker
	name = "undertaker's garments"
	desc = "To protect you from the disease of the dead."
	icon_state = "undertaker"
	item_state = "undertaker"

/obj/item/clothing/mask/gas/undertaker
	name = "undertaker's helm"
	desc = "To ward off the evil smells."
	icon_state = "undertaker"
	item_state = "undertaker"

/obj/item/clothing/gloves/undertaker
	name = "undertaker's gloves"
	desc = "To keep you from touching those gross dead people."
	icon_state = "undertaker"
	item_state = "undertaker"

/obj/item/clothing/shoes/undertaker//Child of jackboots to avoid copy and paste.
	name = "undertaker's boots"
	desc = "Better to use these to step in blood, than your bare feet."
	icon_state = "undertaker"
	item_state = "undertaker"


/obj/item/clothing/suit/armor/vest/opvest
	name = "armored vest"
	desc = "It provides some armor and some storage. Not really the best at either though."
	icon_state = "opvest"
	item_state = "opvest"
	armor = list(melee = 60, bullet = 35, laser = 40, energy = 35, bomb = 30, bio = 0, rad = 0)


/obj/item/clothing/suit/armor/vest/opvest/norifle
	allowed = list(/obj/item/device/radio,/obj/item/reagent_containers/spray/pepper,/obj/item/ammo_magazine,/obj/item/ammo_casing)

/obj/item/clothing/head/helmet/siege
	name = "seige helmet"
	desc = "Better than a baseball cap. But not by much."
	icon_state = "siege_helmet"
	item_state = "siege_helmet"
	armor = list(melee = 50, bullet = 25, laser = 35, energy = 35, bomb = 30, bio = 0, rad = 0)

/obj/item/clothing/under/syndicate/soldier
	name = "underclothing"
	desc = "Some old garmets. Fit for a soldier."

/obj/item/clothing/gloves/thick/swat/combat
	name = "combat gloves"
	desc = "Thick black gloves that make you feel empowered."
	armor = list(melee = 25, bullet = 50, laser = 50,energy = 25, bomb = 30, bio = 0, rad = 0)