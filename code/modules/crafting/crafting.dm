/mob/living/carbon/human/verb/craft()
	set name = "Craft Items"
	set category = "IC"

	if(stat) //zombie goasts pls go
		return

	if(!crafting_recipes)
		return

	var/dat = ""
	var/turf/spot = get_step(src, dir)
	if(!spot.Adjacent(src))
		src << "<span class='warning'>You need more space to work.</span>"
		return
	for(var/name in crafting_recipes)
		var/datum/crafting_recipe/R = crafting_recipes[name]
		if(R.can_make(src, spot))
			dat += "<A href='?src=\ref[src];craft=[name]'>[R.name]</A> "
			dat += "Parts: "
			var/list/parts = list()
			for(var/T in R.parts)
				var/atom/A = T
				parts += "[initial(A.name)] x[R.parts[T]]"
			dat += english_list(parts)
			if(R.tools)
				dat+= ". Tools needed: "
				var/list/tools = list()
				for(var/T in R.tools)
					var/atom/A = T
					tools += "[initial(A.name)]"
				dat += english_list(tools)
			dat += ".<br>"
	if(!dat)
		src << "<span class='notice'>You can't think of anything you can make with what you have in here.</span>"
		return
	var/datum/browser/popup = new(src, "craft", "Craft", 300, 300)
	popup.set_content(dat)
	popup.open()

/datum/crafting_recipe
	var/name = "" 			//in-game display name
	var/list/parts 			//type paths of items consumed associated with how many are needed
	var/list/tools 			//type paths of items needed but not consumed
	var/list/result 		//type path of item resulting from this craft

	var/time = 0 			//time in 1/10th of second
	var/base_chance = 100 	//base chance to get it right without skills

/datum/crafting_recipe/proc/check_parts(var/list/things)
	if(!parts)
		return 1
	var/list/needs = parts.Copy()
	for(var/atom/movable/A in things)
		for(var/T in needs)
			if(istype(A,T))
				if(istype(A, /obj/item/stack))
					var/obj/item/stack/S = A
					needs[T] -= S.amount
				else
					needs[T] -= 1
				if(needs[T] <= 0) //don't need any more of this type
					needs -= T
		if(!needs.len)
			return 1
	return 0

/datum/crafting_recipe/proc/check_tools(var/list/things)
	for(var/T in tools)
		if(!(locate(T) in things))
			return 0
	return 1

/datum/crafting_recipe/proc/use_ingridients(var/list/things)
	var/list/needs = parts.Copy()
	var/list/to_del = list()
	for(var/T in needs)
		if(ispath(T, /obj/item/stack))
			for(var/obj/item/stack/S in things)
				if(needs[T] >= 0 && istype(S, T))
					if(S.amount >= needs[T])
						S.use(needs[T])
						needs[T] = 0
					else
						needs[T] -= S.amount
						things -= S
						qdel(S)
		else
			for(var/atom/movable/A in things)
				if(needs[T] && istype(A,T))
					needs[T] -= 1
					things -= A
					to_del += A
		if(needs[T] <= 0) //don't need any more of this type
			continue

	for(var/atom/A in to_del)
		to_del -= A
		qdel(A)

	if(!needs.len)
		return 1
	return 0

/datum/crafting_recipe/proc/can_make(var/mob/user, var/turf/spot)
	var/list/things = spot.contents + user.contents
	return check_parts(things) && check_tools(things)

/datum/crafting_recipe/proc/make(var/mob/user, var/turf/spot)
	if(!can_make(user,spot))
		return 0
	user << "<span class='notice'>You start making \a [name].</span>"
	if(do_after(user, time))
		if(!can_make(user,spot))
			user << "<span class='warning'>You are missing some things to make \a [name].</span>"
			return 0
		use_ingridients(spot.contents + user.contents)
		if(prob(base_chance))  //Add whatever skill bonuses here
			for(var/T in result)
				for(var/i = 1 to result[T])
					new T(spot)
			user << "<span class='notice'>You make \a [name].</span>"
		else
			user << "<span class='warning'>You've failed to make \a [name].</span>"