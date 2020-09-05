//ALL SHIT FOR KIDS IN ONE FILE BECUASE I'M TIRED OF SEARCHING ALL OVER THE PLACE FOR CHILDREN SHIT
/datum/species/human/child //Oh lord here we go.
	name = "Child"
	name_plural = "Children"
	blurb = "But a child."
	total_health = 150 //Kids are weaker than adults.
	min_age = 10
	max_age = 14
	icobase = 'icons/mob/human_races/child/r_child.dmi'
	deform = 'icons/mob/human_races/child/r_child.dmi'
	damage_mask = 'icons/mob/human_races/masks/dam_mask_child.dmi'
	blood_mask = 'icons/mob/human_races/masks/blood_child.dmi'
	pixel_offset_y = -4
	spawn_flags = SPECIES_IS_RESTRICTED//No more kids becoming nuke ops.


/datum/species/human/child/handle_post_spawn(var/mob/living/carbon/human/H)
	//H.mutations.Add(CLUMSY)//So kids don't go around being commandos.
	H.age = rand(min_age,max_age)//Random age for kiddos.
	if(H.f_style)//Children don't get beards.
		H.f_style = "Shaved"
	to_chat(H, "<span class='info'><big>You're [H.age] years old! Act like it!</big></span>")
	to_chat(H, "<big><span class='warning'>CHILDREN ARE CLUMSY AND CANNOT USE GUNS OR MELEE WEAPONS! DOING SO WILL KILL YOU!</span></big>")
	H.update_eyes()	//hacky fix, i don't care and i'll never ever care
	return ..()


/obj/item/clothing/under/child_jumpsuit
	name = "grey children's jumpsuit"
	desc = "Fitted just for kids."
	icon_state = "child_grey"
	can_be_worn_by_child = TRUE
	child_exclusive = TRUE

/obj/item/clothing/shoes/child_shoes
	name = "black children's shoes"
	desc = "Shoes for the little ones."
	icon_state = "child_black"
	can_be_worn_by_child = TRUE
	child_exclusive = TRUE

/obj/item/clothing/under/child_heir
	name = "heir's clothing"
	desc = "For underaged ruling in fashion."
	icon_state = "heir"
	can_be_worn_by_child = TRUE
	child_exclusive = TRUE


/mob/living/carbon/human/proc/isChild()//Used to tell if someone is a child.
	if(species && species.name == "Child")
		return 1
	else
		return 0

/mob/living/carbon/human/child/New(var/new_loc)
	..(new_loc, "Child")

