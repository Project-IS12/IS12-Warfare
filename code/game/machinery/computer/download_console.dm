/obj/machinery/computer/downloadconsole
	name = "download console"
	icon_state = "oldcomp"
	icon_keyboard = null
	icon_screen = "library"
	use_power = 0
	var/can_record_tape = TRUE

/obj/machinery/computer/downloadconsole/attack_hand(mob/user) //later do file size check %_%
	if(!can_record_tape)
		to_chat(user, SPAN_WARNING("Spess dial-up is so slow! I must to wait."))
		return
	var/sound/S = input("Pick music") as sound|null
	if(S)
		can_record_tape = FALSE
		var/N = input("Input cassette name", "[pick("LEHA SPECIAL FORCES","SET ME FREE","UF BEST HITS 2065", "Bomb-a-Nyti explosives factory")]") as text|null
		var/obj/item/device/cassette/casseta = new()
		casseta.sound_inside = S
		casseta.name = "\"[N]\" magn-o-tape "
		casseta.loc = src.loc
		casseta.uploader_idiot = user.name
		to_chat(user, SPAN_NOTICE("Tape completed!"))
		log_and_message_admins("downloaded music with name [html_encode(N)]! if he loaded shit - just <b>ban</b>. Location = [get_area(user)]")
		spawn(3 MINUTES)
			can_record_tape = TRUE