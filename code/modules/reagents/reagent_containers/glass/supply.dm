//Combo supply packs of chemical jars, split into two
/decl/hierarchy/supply_pack/reagents/base
	name = "Chemistry - Basic Chemicals"
	contains = list(
		/obj/item/reagent_containers/glass/jar/aluminum,
		/obj/item/reagent_containers/glass/jar/carbon,
		/obj/item/reagent_containers/glass/jar/copper,
		/obj/item/reagent_containers/glass/jar/ethanol,
		/obj/item/reagent_containers/glass/jar/iron,
		/obj/item/reagent_containers/glass/jar/silicon,
		//obj/item/reagent_containers/glass/jar/sugar,
		/obj/item/reagent_containers/glass/jar/sulfur
		)
	cost = 50
	containertype = /obj/structure/closet/crate/secure
	containername = "chemical crate"
	access = list(access_chemistry)

/decl/hierarchy/supply_pack/reagents/restricted
	name = "Chemistry - Restricted Chemicals"
	contains = list(
		/obj/item/reagent_containers/glass/jar/acetone,
		/obj/item/reagent_containers/glass/jar/ammonia,
		/obj/item/reagent_containers/glass/jar/hydrazine,
		/obj/item/reagent_containers/glass/jar/hydrochloric,
		/obj/item/reagent_containers/glass/jar/lithium,
		/obj/item/reagent_containers/glass/jar/mercury,
		/obj/item/reagent_containers/glass/jar/phosphorus,
		/obj/item/reagent_containers/glass/jar/potassium,
		/obj/item/reagent_containers/glass/jar/radium,
		/obj/item/reagent_containers/glass/jar/sodium,
		/obj/item/reagent_containers/glass/jar/sulphuric_acid
		)
	cost = 100
	containertype = /obj/structure/closet/crate/secure
	containername = "chemical crate"
	access = list(access_chemistry)

// Individual chemical supply packs.
// Chemistry-restricted (raw reagents excluding sugar/water)
//      Datum path  Contents type                                              Supply pack name                Container name             Cost Container access
SEC_PACK(hydrazine, /obj/item/reagent_containers/glass/jar/hydrazine,   "Chemistry - Hydrazine",        "hydrazine crate",         15, access_chemistry)
SEC_PACK(lithium,   /obj/item/reagent_containers/glass/jar/lithium,     "Chemistry - Lithium",          "lithium crate",           15, access_chemistry)
SEC_PACK(carbon,    /obj/item/reagent_containers/glass/jar/carbon,      "Chemistry - Carbon dust",      "carbon crate",            10, access_chemistry)
SEC_PACK(ammonia,   /obj/item/reagent_containers/glass/jar/ammonia,     "Chemistry - Ammonia",          "ammonia crate",           15, access_chemistry)
SEC_PACK(acetone,   /obj/item/reagent_containers/glass/jar/acetone,     "Chemistry - Acetone",          "acetone crate",           15, access_chemistry)
SEC_PACK(sodium,    /obj/item/reagent_containers/glass/jar/sodium,      "Chemistry - Sodium",           "sodium crate",            15, access_chemistry)
SEC_PACK(aluminium, /obj/item/reagent_containers/glass/jar/aluminum,    "Chemistry - Aluminum powder",  "aluminum crate",          10, access_chemistry)
SEC_PACK(silicon,   /obj/item/reagent_containers/glass/jar/silicon,     "Chemistry - Silicon",          "silicon crate",           10, access_chemistry)
SEC_PACK(phosphorus,/obj/item/reagent_containers/glass/jar/phosphorus,  "Chemistry - Phosphorus",       "phosphorus crate",        15, access_chemistry)
SEC_PACK(sulfur,    /obj/item/reagent_containers/glass/jar/sulfur,      "Chemistry - Sulfur",           "sulfur crate",            10, access_chemistry)
SEC_PACK(hclacid,   /obj/item/reagent_containers/glass/jar/hydrochloric,"Chemistry - Hydrochloric acid","hydrochloric acid crate", 15, access_chemistry)
SEC_PACK(potassium, /obj/item/reagent_containers/glass/jar/potassium,   "Chemistry - Potassium",        "potassium crate",         15, access_chemistry)
SEC_PACK(iron,      /obj/item/reagent_containers/glass/jar/iron,        "Chemistry - Ferrum dust",      "ferrum dust crate",       10, access_chemistry)
SEC_PACK(copper,    /obj/item/reagent_containers/glass/jar/copper,      "Chemistry - Cuprum dust",      "cuprum dust crate",       10, access_chemistry)
SEC_PACK(mercury,   /obj/item/reagent_containers/glass/jar/mercury,     "Chemistry - Quicksilver",      "quicksilver crate",       15, access_chemistry)
SEC_PACK(radium,    /obj/item/reagent_containers/glass/jar/radium,      "Chemistry - Radium",           "radium crate",            15, access_chemistry)
SEC_PACK(ethanol,   /obj/item/reagent_containers/glass/jar/ethanol,     "Chemistry - Ethanol",          "ethanol crate",           10, access_chemistry)
SEC_PACK(sacid,     /obj/item/reagent_containers/glass/jar/sulphuric_acid,"Chemistry - Sulfuric Acid",  "sulfuric acid crate",     15, access_chemistry)
//SEC_PACK(tungsten,  /obj/item/reagent_containers/chem_disp_cartridge/tungsten,   "Reagent refill - Tungsten",      "tungsten reagent cartridge crate",      10, access_chemistry)
