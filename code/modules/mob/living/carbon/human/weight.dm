#define OVERLOAD_NONE 0
#define OVERLOAD_LIGHT 1
#define OVERLOAD_MEDIUM 2
#define OVERLOAD_HIGH 4
#define OVERLOAD_EXTREME 8

/obj/
	var/weight = 0

//Use New() proc to add custom weight to items, this proc is just temporary solution for items that don't have custom weight//

/obj/New()
	..()
	if(w_class == INFINITY)
		weight = 150
	else
		weight = w_class*w_class / 2

//Adding weights to mob//

/mob/living
	var/baseweight = 0
	var/baseload = 0
	var/weight = 0
	var/loads = 0

//Updates all weight variables//

/mob/living/proc/updateweight()
	baseload = 10 + round(STAT_LEVEL(str) * STAT_LEVEL(end) / 4)
	baseweight = (STAT_LEVEL(str) + STAT_LEVEL(end)) * 4
	weight = baseweight + check_weight()
	loads = check_weight()
//to_chat(world, "baseload is [baseload], load is [loads], overweight is [overweight].")

//Checks sum weight of /obj/item/ stuff on the mob, except organs//

/mob/living/proc/check_weight()
	var/weight_sum = 0
	for(var/obj/item/O in contents)
		if(!istype(O, /obj/item/organ))
			if(!istype(O, /obj/item/storage,))
				weight_sum += O.weight
		if(istype(O, /obj/item/storage))
			var/obj/item/storage/ST = O
			weight_sum += ST.check_my_weight()
	return weight_sum

//Checks sum weight of /obj/item/ stuff in the backpack, also does loop for other storages in case there is one inside of other//

/obj/item/storage/proc/check_my_weight()
	var/weight_sum = 0
	for(var/obj/item/O in contents)
		weight_sum += O.weight
		if(istype(O, /obj/item/storage))
			var/obj/item/storage/ST = O
			weight_sum += ST.check_my_weight()
	return weight_sum

/mob/living/proc/overweight()
	if(loads < baseload * 2)
		return OVERLOAD_NONE
	if(loads > baseload * 2)
		return OVERLOAD_LIGHT
	if(loads > baseload * 3)
		return OVERLOAD_MEDIUM
	if(loads > baseload * 6)
		return OVERLOAD_HIGH
	if(loads > baseload * 10)
		return OVERLOAD_EXTREME

/mob/living/proc/overweighttxt()
	switch (overweight())
		if(OVERLOAD_LIGHT)
			return "It's slightly uncomfortable to carry this."
		if(OVERLOAD_MEDIUM)
			return "It's quite heavy to carry."
		if(OVERLOAD_HIGH)
			return "This is too heavy to carry!"
		if(OVERLOAD_EXTREME)
			return "I am OVERLOADED!"

#undef OVERLOAD_NONE
#undef OVERLOAD_LIGHT
#undef OVERLOAD_MEDIUM
#undef OVERLOAD_HIGH
#undef OVERLOAD_EXTREME
