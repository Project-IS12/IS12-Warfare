/*
	========
	FOOD 2.0
	========

What:	Food that goes into a stomach organ rather than doing the hacky way of
		cheating one in with lists. It also comes with cooking states af of writing this
		I'm not entirely sure how the cooking hsould be handled but Kyrah suggested that
		the items have a cook type they turn in to and change reagents over time. I guess
		the idea is that you could poison a raw steak but honestly you would cook out all
		the poisons probably so it might make more sense to just turn into a new thing entirely.
		For now I'll do it Kyrah's way in case there's something here I'm missing.

Why:	This also helps regulate the speed of nutrient consumption, another benefit
		is that it means you can eat multiple things of different reagents and they
		will react once your stomach absorbs them (rather than instantly) so it means
		you could slowly poison someone and they might not know until a little later.
*/

/*
The nutrient quick rundown:

	living mobs have something called 'nutrition this
	value is subtracted by about everything so it's basically
	the single-most important thing in mob. do you move? subtract
	nutrition. Healing over time passively? Uses nutrition. got it?
	good.

	"So we want to add nutrition to the mob."
	"No!"

	Nutriment (in Chemistry-Reagents-Food-Drinks.dm) returns
	a multiple of *10 for every nutriment it detects in a mob's
	bloodstream into the nutrition so if you must make your food
	use nutriment make it a small value like 3 (which becomes 30)
	Protein also returns a multiple of 10 so keep it in mind.
	be sure to check the .dm for your appropriate amount.

	As of writing this and after testing, it seems the blood_ingest
	has something else that adds some kind of multiplier. so keep your
	values real low because this shit gives off a lot of nutrition.

	"So why is the volume for food so high?"

	This is a remnant of th eold food code but food is a reagent container
	so you can add stuff to the food to poison/season it. I'm gonna leave it
	at 50, the old value, and see what comes of it. It is easy enough to fix.
*/

/obj/item/reagent_containers/eatable
	randpixel = 6
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	possible_transfer_amounts = null
	volume = 50 //Sets the default container amount for all food items.

	name = "Food"
	desc = "Looks edible."
	icon = 'icons/obj/food.dmi'
	icon_state = "meat"
	var/eat_message = "chomps down" // adds it to the consuming display
	var/eat_sound = null //unique chomping sounds

	var/bitesize = 3 // using this to divide the reagents. (e.g myreagent_amt/bitesize)

	var/bitecount = 0 //checking if someone chewed on it!!

	//reagents that eatables have.
	var/myreagent_amt = 10
	var/datum/reagent/myreagent = /datum/reagent/nutriment

	//COOKING VARS
	var/cooktime = 8 //how many ticks food takes to cook.
	var/cooktime_elapsed = 0
	var/cook_item = null //item it turns in to when cooking is done.
	var/cook_type = 0 //checks what you tried to cook it in (good for cooking things multiple ways!)
	var/cook_steps = 1 // for if the item has more steps during cooking (mostly a future proof thing)

	center_of_mass = "x=16;y=16"
	w_class = ITEM_SIZE_SMALL

	var/trash = null //if it spawns garbage (like old food code)

/obj/item/reagent_containers/eatable/New()
	..()
	if(myreagent)
		reagents.add_reagent(myreagent,myreagent_amt)
	else
		qdel(src) // why would you want food with nothing in it??

/obj/item/reagent_containers/eatable/attack_self(mob/user as mob)
	return


//TO DO: check for zone selection mouth, otherwise hit the person with the food.)

/obj/item/reagent_containers/eatable/attack(mob/M as mob, mob/user as mob, def_zone)

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

	if(istype(M, /mob/living/carbon))
		var/mob/living/carbon/C = M

		if(C == user)								//If you're eating it yourself
			if(istype(C,/mob/living/carbon/human))
				var/mob/living/carbon/human/H = M
				var/obj/item/organ/internal/stomach/gut = H.internal_organs_by_name[BP_STOMACH]

				//to_chat(user, "stomach is [gut]")

				if(!gut)
					to_chat(user, "You can't eat without a stomach...")
					return
				if(!H.check_has_mouth())
					to_chat(user, "Where do you intend to put \the [src]? You don't have a mouth!")
					return
				var/obj/item/blocked = H.check_mouth_coverage()
				if(blocked)
					to_chat(user, "<span class='warning'>\The [blocked] is in the way!</span>")
					return
		else
			if(!M.can_force_feed(user, src))
				return
			if(ishuman(M))
				var/mob/living/carbon/human/H = M
				var/obj/item/organ/internal/stomach/gut = H.internal_organs_by_name[BP_STOMACH]

				if(!gut)
					to_chat(user, "They have no stomach...")
					return
				if(!H.check_has_mouth())
					to_chat(user, "Where do you intend to put \the [src]? They have no mouth!")
					return
				var/obj/item/blocked = H.check_mouth_coverage()
				if(blocked)
					to_chat(user, "<span class='warning'>\The [blocked] is in the way!</span>")
					return

		/*
		//uncomment if you think it's useful, I don't.
			var/contained = reagentlist()
			admin_attack_log(user, M, "Fed the victim with [name] (Reagents: [contained])", "Was fed [src] (Reagents: [contained])", "used [src] (Reagents: [contained]) to feed")
			user.visible_message("<span class='danger'>[user] feeds [M] [src].</span>")
		*/

		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/stomach/gut = H.internal_organs_by_name[BP_STOMACH]
		var/obj/item/storage/special/stomach/gutinventory = gut.inventory
		//add a food chunk to the stomach
		if(!gut.inventory.can_be_inserted(src, user, 1))
			M.visible_message("<span class='notice'>[M] Can't eat anymore of \the [src].</span>","<span class='notice'>You feel too full to eat \the [src].</span>")
			return
		var/obj/item/reagent_containers/eatable/foodchunk/chunk = new /obj/item/reagent_containers/eatable/foodchunk(gutinventory)
		if(reagents.total_volume < myreagent_amt/bitesize)
			reagents.trans_to(chunk, reagents.total_volume)
		else
			reagents.trans_to(chunk, myreagent_amt/bitesize)

		M.visible_message("<span class='notice'>[M] [eat_message] the [name].</span>","<span class='notice'>You finish eating \the [src].</span>")
		//to_chat(user, "[chunk] was sent to the gut. it has [myreagent_amt/bitesize] worth of nutrients")

		if(reagents.total_volume < 1) //sanity check?
			//to_chat(user, "I'm dead because I only have [reagents.total_volume] left!")
			user.drop_from_inventory(src)
			M.visible_message("<span class='notice'>[M] finishes eating \the [src].</span>","<span class='notice'>You finish eating \the [src].</span>")
			qdel(src)
	return 0





/obj/item/reagent_containers/eatable/examine(mob/user)
	if(!..(user, 1))
		return
	if (bitecount==0)
		return
	else
		to_chat(user, "Something has been eating this!")

/obj/item/reagent_containers/eatable/attackby(obj/item/W as obj, mob/user as mob)
	return
	//this is for figuing out food with utensils and stuff. I'll figure it out later
	//for now people eat food with their hands like cretins


//not sure why old food has this, it's for cutting shit open that has stuff in it??
/obj/item/reagent_containers/eatable/Destroy()
	if(contents)
		for(var/atom/movable/something in contents)
			something.dropInto(loc)
	. = ..()

//cooking is based on
/obj/item/reagent_containers/eatable/proc/Cook(var/type)
	return
	//switch(type)
	//	if(NO_COOKING_METHOD)
			//burn it


/*
food chunk, this gets put in the stomach of the mob which eats the eatable
*/
/obj/item/reagent_containers/eatable/foodchunk
	name		= "Food chunk"
	desc		= "a small chunk of chewed up food."
	icon_state	= "badrecipe"