#define VENDING_CATEGORY_NORMAL  1 //Item is dispensed normally
#define VENDING_CATEGORY_HIDDEN  2 //Item is hidden (contraband)
#define VENDING_CATEGORY_PREMIUM 4 //Item requires a coin (premium item)

/**
 *  Datum used to hold information about a product in a vending machine
 */

/datum/stored_items/vending_products
	item_name = "generic" // Display name for the product
	var/price = 0              // Price to buy one
	var/display_color = null   // Display color for vending machine listing
	var/category = VENDING_CATEGORY_NORMAL //Normal, Contraband or premium.

/datum/stored_items/vending_products/New(var/atom/storing_object, var/path, var/name = null, var/amount = 0, var/price = 0, var/color = null, var/category = VENDING_CATEGORY_NORMAL)
	..()
	src.price = price
	src.display_color = color
	src.category = category
