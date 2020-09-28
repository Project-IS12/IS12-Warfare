/mob/living/simple_animal/hostile/retaliate/rat
	name = "Rat"
	desc = "They prey at night, they stalk at night, they're a rat."
	icon_state = "rat"
	icon_living = "rat"
	icon_dead = "rat_dead"
	icon_gib = "rat_gib"
	emote_see = list("squeaks loudly", "cleans its whiskers with its paws")
	speak_chance = 5
	turns_per_move = 3
	response_help = "pets the"
	response_disarm = "pushes aside"
	response_harm = "kicks"
	meat_type = /obj/item/reagent_containers/food/snacks/meat/rat_meat
	meat_amount = 3
	speed = 4
	maxHealth = 10
	health = 10

	mob_size = MOB_SMALL
	density = 0 //So they don't get in the way.

	harm_intent_damage = 3
	melee_damage_lower = 1
	melee_damage_upper = 4
	attacktext = "bitten"
	attack_sound = 'sound/voice/rat_attack.ogg'

	faction = "mining"


/mob/living/simple_animal/hostile/retaliate/rat/New()
	..()
	if(prob(25))
		icon_state = "rat_giant"
		icon_living = "rat_giant"
		icon_dead = "rat_giant_dead"
		desc = "He looks like a giant rat who makes all of the rules."


/mob/living/simple_animal/hostile/retaliate/rat/FindTarget()
	. = ..()
	if(.)
		visible_emote("angrily stares at [.]!")

/mob/living/simple_animal/hostile/retaliate/rat/AttackingTarget()
	. =..()
	var/mob/living/L = .
	if(istype(L))
		if(prob(1))
			L.Weaken(1)
			L.visible_message("<span class='danger'>\the [src] knocks down \the [L]!</span>")


/mob/living/simple_animal/hostile/retaliate/rat/Life()
	..()
	if(prob(1))
		playsound(src, 'sound/voice/rat_life1.ogg', 30, 1, -3)
	var/birthday = rand(1,1000)
	if(birthday == 1)
		var/mob/living/carbon/human/H = pick(viewers(world.view,src))
		if(H.ckey)
			say("[H.name] it's your birthday today! Cake and icecream is on its way!")