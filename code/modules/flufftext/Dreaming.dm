
var/list/dreams = list(
	"a dogtag","a bottle","a familiar face","a crewmember","a toolbox","a soldier","the captain",
	"voices from all around","none of this is real","a doctor","an ally","darkness",
	"light","a catastrophe","a loved one","a gun","warmth","freezing","the sun",
	"a hat","a ruined fortress","a planet","air","the medical bay","blinking lights",
	"a blue light","an abandoned laboratory","NanoTrasen", "pirates", "mercenaries","blood","healing","power","respect",
	"riches","space","a crash","happiness","pride","a fall","water","flames","ice","melons","flying","the eggs","money",
	"a station engineer","the janitor","the atmospheric technician",
	"a cargo technician","the botanist","a shaft miner","the psychologist","the chemist",
	"the virologist","the roboticist","a chef","the bartender","a chaplain","a librarian","a mouse",
	"a beach","a smokey room","a voice","the cold","a mouse","an operating table","the rain",
	"an unathi","a tajaran","the ai core","a beaker of strange liquid","the supermatter", "a creature built completely of stolen flesh",
	"a GAS", "a being made of light", "the commanding officer", "an old friend", "the tower", "the man with no face", "a field of flowers", "an old home", "the merc",
	"a surgery table", "a needle", "a blade", "an ocean", "right behind you", "standing above you", "someone near by", "a place forgotten",
	)

mob/living/carbon/proc/dream()
	dreaming = 1

	spawn(0)
		for(var/i = rand(1,4),i > 0, i--)
			to_chat(src, "<span class='notice'><i>... [pick(GLOB.lone_thoughts)] ...</i></span>")
			sleep(rand(40,70))
			if(paralysis <= 0)
				dreaming = 0
				return 0
		dreaming = 0
		return 1

mob/living/carbon/proc/handle_dreams()
	if(client && !dreaming && prob(5))
		dream()

mob/living/carbon/var/dreaming = 0
