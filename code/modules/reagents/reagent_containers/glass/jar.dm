/obj/item/reagent_containers/glass/jar
	name = "chemical jar"
	desc = "Old and dusty. The kind you would find in the laboratory of some mad scientist."
	icon = 'icons/obj/items/chem_jars.dmi'
	icon_state = "generic"

	item_state = "chemjar"
	can_be_placed_into = list()
	atom_flags = 0x0000
	volume = 120
	w_class = ITEM_SIZE_NORMAL //this is mainly because chemmasters and grinders now check for beaker "size"

	var/content = "nothing"

/obj/item/reagent_containers/glass/jar/update_icon()
	overlays.Cut()

	if (!is_open_container())
		var/image/lid = image(icon, src, "lid")
		overlays += lid

/obj/item/reagent_containers/glass/jar/New()
	..()
	name = "[content] [initial(name)]"
	desc += " The faded label reads: <b>[content]</b>."
	update_icon()

/obj/item/reagent_containers/glass/jar/acetone
	icon_state = "acetone"
	content = "acetone"
	New()
		..()
		reagents.add_reagent(/datum/reagent/acetone, rand(volume/2,volume))

/obj/item/reagent_containers/glass/jar/ammonia
	icon_state = "ammonia"
	content = "ammonia"
	New()
		..()
		reagents.add_reagent(/datum/reagent/ammonia, rand(volume/2,volume))

/obj/item/reagent_containers/glass/jar/aluminum
	icon_state = "aluminum"
	content = "aluminum powder"
	New()
		..()
		reagents.add_reagent(/datum/reagent/aluminum, rand(volume/2,volume))

/obj/item/reagent_containers/glass/jar/carbon
	icon_state = "carbon"
	content = "carbon dust"
	New()
		..()
		reagents.add_reagent(/datum/reagent/carbon, rand(volume/2,volume))

/obj/item/reagent_containers/glass/jar/copper
	icon_state = "copper"
	content = "cuprum dust"
	New()
		..()
		reagents.add_reagent(/datum/reagent/copper, rand(volume/2,volume))

/obj/item/reagent_containers/glass/jar/ethanol
	icon_state = "ethanol"
	content = "ethanol"
	New()
		..()
		reagents.add_reagent(/datum/reagent/ethanol, rand(volume/2,volume))

/obj/item/reagent_containers/glass/jar/hydrazine
	icon_state = "hydrazine"
	content = "hydrazine"
	New()
		..()
		reagents.add_reagent(/datum/reagent/hydrazine, rand(volume/2,volume))

/obj/item/reagent_containers/glass/jar/hydrochloric
	icon_state = "hydrochloric_acid"
	content = "hydrochloric acid"
	New()
		..()
		reagents.add_reagent(/datum/reagent/acid/hydrochloric, rand(volume/2,volume))

/obj/item/reagent_containers/glass/jar/iron
	icon_state = "iron"
	content = "ferrum dust"
	New()
		..()
		reagents.add_reagent(/datum/reagent/iron, rand(volume/2,volume))

/obj/item/reagent_containers/glass/jar/lithium
	icon_state = "lithium"
	content = "lithium"
	New()
		..()
		reagents.add_reagent(/datum/reagent/lithium, rand(volume/2,volume))

/obj/item/reagent_containers/glass/jar/mercury
	icon_state = "mercury"
	content = "quicksilver"
	New()
		..()
		reagents.add_reagent(/datum/reagent/mercury, rand(volume/2,volume))

/obj/item/reagent_containers/glass/jar/phosphorus
	icon_state = "phosphorus"
	content = "phosphorus dust"
	New()
		..()
		reagents.add_reagent(/datum/reagent/phosphorus, rand(volume/2,volume))

/obj/item/reagent_containers/glass/jar/potassium
	icon_state = "potassium"
	content = "potassium"
	New()
		..()
		reagents.add_reagent(/datum/reagent/potassium, rand(volume/2,volume))

/obj/item/reagent_containers/glass/jar/radium
	icon_state = "radium"
	content = "radium"
	New()
		..()
		reagents.add_reagent(/datum/reagent/radium, rand(volume/2,volume))

/obj/item/reagent_containers/glass/jar/silicon
	icon_state = "silicon"
	content = "silicon"
	New()
		..()
		reagents.add_reagent(/datum/reagent/silicon, rand(volume/2,volume))

/obj/item/reagent_containers/glass/jar/sodium
	icon_state = "sodium"
	content = "natrium"
	New()
		..()
		reagents.add_reagent(/datum/reagent/sodium, rand(volume/2,volume))

/obj/item/reagent_containers/glass/jar/sugar
	icon_state = "sugar"
	content = "sugar"
	New()
		..()
		reagents.add_reagent(/datum/reagent/sugar, rand(volume/2,volume))

/obj/item/reagent_containers/glass/jar/sulfur
	icon_state = "sulfur"
	content = "sulfur"
	New()
		..()
		reagents.add_reagent(/datum/reagent/sulfur, rand(volume/2,volume))

/obj/item/reagent_containers/glass/jar/sulphuric_acid
	icon_state = "sulphuric_acid"
	content = "sulphuric acid"
	New()
		..()
		reagents.add_reagent(/datum/reagent/acid, rand(volume/2,volume))
