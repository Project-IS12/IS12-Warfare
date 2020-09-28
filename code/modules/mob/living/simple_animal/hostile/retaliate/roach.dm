/mob/living/simple_animal/hostile/retaliate/roach
	name = "Dog Roach"
	desc = "A monstrous, dog-sized cockroach. These huge mutants can be everywhere where humans are, on ships, planets and stations."
	icon_state = "roach"
	icon_living = "roach"
	icon_dead = "roach_dead"
	emote_see = list("chirps loudly", "cleans its whiskers with forelegs")
	speak_chance = 5
	turns_per_move = 3
	response_help = "pets the"
	response_disarm = "pushes aside"
	response_harm = "stamps on"
	meat_type = /obj/item/reagent_containers/food/snacks/meat/roachmeat
	meat_amount = 3
	speed = 4
	maxHealth = 50
	health = 50

	mob_size = MOB_SMALL
	density = 0 //Swarming roaches! They also more robust that way.

	harm_intent_damage = 3
	melee_damage_lower = 1
	melee_damage_upper = 4
	attacktext = "bitten"
	attack_sound = 'sound/voice/insect_battle_bite.ogg'

	faction = "roach"

/mob/living/simple_animal/hostile/retaliate/roach/FindTarget()
	. = ..()
	if(.)
		visible_emote("charges at [.]!")
		playsound(src, 'sound/voice/insect_battle_screeching.ogg', 30, 1, -3)

/mob/living/simple_animal/hostile/retaliate/roach/AttackingTarget()
	. =..()
	var/mob/living/L = .
	if(istype(L))
		if(prob(5))
			L.Weaken(3)
			L.visible_message("<span class='danger'>\the [src] knocks down \the [L]!</span>")

/mob/living/simple_animal/hostile/retaliate/roach/tank
	name = "Tank Roach"
	desc = "A monstrous, dog-sized cockroach. This one looks more robust than others."
	icon_state = "panzer"
	icon_living = "panzer"
	icon_dead = "panzer_dead"
	meat_amount = 4
	turns_per_move = 2
	maxHealth = 100
	health = 100

	mob_size = MOB_MEDIUM
	density = 1

/mob/living/simple_animal/hostile/retaliate/roach/hunter
	name = "Jager Roach"
	desc = "A monstrous, dog-sized cockroach. This one have a bigger claws."
	icon_state = "jager"
	icon_living = "jager"
	icon_dead = "jager_dead"
	meat_amount = 3
	turns_per_move = 2
	melee_damage_lower = 3
	melee_damage_upper = 10

/mob/living/simple_animal/hostile/retaliate/roach/fuhrer
	name = "Master Roach"
	desc = "A glorious leader of cockroaches. Literally Hitler."
	icon_state = "fuhrer"
	icon_living = "fuhrer"
	icon_dead = "fuhrer_dead"
	meat_amount = 5
	turns_per_move = 4
	maxHealth = 60
	health = 60

	melee_damage_lower = 3
	melee_damage_upper = 20

/mob/living/simple_animal/hostile/retaliate/roach/support
	name = "Seuche Roach"
	desc = "A monstrous, dog-sized cockroach. This one smells like hell and secretes strange vapors."
	icon_state = "seuche"
	icon_living = "seuche"
	icon_dead = "seuche_dead"
	meat_amount = 3
	turns_per_move = 4
	maxHealth = 20
	health = 20

	melee_damage_upper = 3


/mob/living/simple_animal/hostile/retaliate/roach/support/New()
	..()
	create_reagents(100)

/mob/living/simple_animal/hostile/retaliate/roach/support/proc/gas_attack()
	if(!(reagents.has_reagent(/datum/reagent/toxin/blattedin, 20) && health <= 0))
		return
	var/location = get_turf(src)
	var/datum/effect/effect/system/smoke_spread/chem/S = new
	S.attach(location)
	S.set_up(src.reagents, src.reagents.total_volume, 0, location)
	src.visible_message("<span class='danger'>\the [src] secrete strange vapors!</span>")
	spawn(0)
		S.start()
	reagents.clear_reagents()
	return

/mob/living/simple_animal/hostile/retaliate/roach/support/Life()
	..()
	reagents.add_reagent(/datum/reagent/toxin/blattedin, 1)
	if(reagents.has_reagent(/datum/reagent/toxin/blattedin, 20)&&prob(7))
		gas_attack()

/mob/living/simple_animal/hostile/retaliate/roach/support/FindTarget()
	. = ..()
	if(.)
		visible_emote("charges at [.] in clouds of poison!")
		gas_attack()


/mob/living/simple_animal/hostile/fire_roach
	name = "Firefly Roach"
	desc = "Quite the nasty thing. Beware it's name is literal."
	icon_state = "firefly_roach"
	icon_living = "firefly_roach"
	icon_dead = "firefly_dead"
	health = 250
	maxHealth = 250
	melee_damage_lower = 2
	melee_damage_upper = 3
	attacktext = "clawed"
	projectilesound = 'sound/effects/fire01.ogg'
	projectiletype = /obj/item/projectile/flamer
	faction = "roach"
	speed = 4
	ranged = TRUE