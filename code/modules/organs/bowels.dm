/*
		======
		Bowels
		======


What:		Bowels will recieve the food chunks from the stomach. Once they have food chunks
			they will begin a cycle to produce stool. Stool will only arise when a certain
			number of food chunks have entered. Once there is stool it will begin a timer
			for how long it has to go until it will automatically come out. (like a timebomb)
			I shall be trying to work with Matt's poo code to make sure this works.

			I think that it may be best if each feces has its own poo timer so that it's possible
			that the stool can remain in the body without having to actually shit until a threshold
			passes. This would allow for the players to eat and not need to worry about using the
			bathroom for a little while. A cool thing about this whole digestive system is that
			we could possibly force people to have different levels (on top of randomly setting their
			nutrition amount) so people start the round starving and some people start the round needing
			to shit. It would be worth trying out.

			Currently the bowels ONLY recieve food chunks (maybe liquid) because everything else will
			sit in the stomach. Since it is a storage slot however it could be possible to open up
			the bowels and stick something in it.

Broken:		Currently no plans for broken bowels, maybe it forces shit instantly

Missing:	Missing bowels will cause the stomach to return its send code. This means that
			eventually the mob in question will not be able to eat as their stomach feels
			full but they also wont be able to shit to remove it. This means that they either
			starve to death or get their stomach pumped.
*/



/obj/item/organ/internal/bowels
	name = "bowels"
	icon_state = "stomach"
	w_class = ITEM_SIZE_SMALL
	organ_tag = BP_BOWELS
	parent_organ = BP_CHEST
	min_bruised_damage = 25
	min_broken_damage = 45
	max_damage = 80
	var/process_delay = 10
	var/process_time = 0
	var/food_to_stool_ratio = 4 //takes this many food chunks to make 1 stool
	var/food_count = 0
	var/stool_count = 0 //might not need this but whatever.
	var/obj/item/storage/special/inventory

/obj/item/storage/special/bowels
	max_w_class = ITEM_SIZE_SMALL
	storage_slots = 12 //default for a human. Max stool will be 4-5 the rest of the space is for food chunk processing.


/obj/item/organ/internal/bowels/New()
	inventory = new /obj/item/storage/special/bowels()
	inventory.loc = src
	inventory.name = name

/obj/item/organ/internal/bowels/Process()

	if(!owner)
		return

	if(world.time - process_time >= process_delay)
		process_time = world.time
		process_contents()


/obj/item/organ/internal/bowels/proc/process_contents()
	for(var/obj/item/reagent_containers/eatable/F in inventory)
		if(istype(F, /obj/item/reagent_containers/eatable/poo))
			continue
		food_count += 1
		to_chat(owner, "food count is [food_count]")
		if(food_count >= 4)
			for(F in inventory)
				qdel(F)
				food_count -=1
				if(food_count <=0)
					to_chat(owner, "I make a poo poo")
					new /obj/item/reagent_containers/eatable/poo(inventory)
					//make poo
					break

	food_count = 0
	for(var/obj/item/W in inventory)
		if(W)
			to_chat(owner, "bowels contains [W]")