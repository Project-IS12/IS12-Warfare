#define MAX_FIELDS 50

/*
 * Paper
 * also scraps of paper
 */

/obj/item/paper
	name = "sheet of paper"
	gender = NEUTER
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "paper"
	item_state = "paper"
	randpixel = 8
	throwforce = 0
	w_class = ITEM_SIZE_TINY
	throw_range = 1
	throw_speed = 1
	layer = ABOVE_OBJ_LAYER
	slot_flags = SLOT_HEAD
	body_parts_covered = HEAD
	attack_verb = list("bapped")

	var/info		//What's actually written on the paper.
	var/info_links	//A different version of the paper which includes html links at fields and EOF
	var/stamps		//The (text for the) stamps on the paper.
	var/fields		//Amount of user created fields
	var/free_space = MAX_PAPER_MESSAGE_LEN
	var/list/stamped
	var/list/ico[0]      //Icons and
	var/list/offset_x[0] //offsets stored for later
	var/list/offset_y[0] //usage by the photocopier
	var/rigged = 0
	var/spam_flag = 0

	var/const/deffont = "Verdana"
	var/const/signfont = "Times New Roman"
	var/const/crayonfont = "Comic Sans MS"

/obj/item/paper/New(loc, text,title)
	..(loc)
	set_content(text ? text : info, title)

/obj/item/paper/proc/set_content(text,title)
	if(title)
		SetName(title)
	info = html_encode(text)
	info = parsepencode(text)
	update_icon()
	update_space(info)
	updateinfolinks()

/obj/item/paper/update_icon()
	if(icon_state == "paper_talisman")
		return
	else if(info)
		icon_state = "paper_words"
	else
		icon_state = "paper"

/obj/item/paper/proc/update_space(var/new_text)
	if(new_text)
		free_space -= length(strip_html_properly(new_text))

/obj/item/paper/examine(mob/user)
	. = ..()
	if(name != "sheet of paper")
		to_chat(user, "It's titled '[name]'.")
	if(in_range(user, src) || isghost(user))
		show_content(usr)
	else
		to_chat(user, "<span class='notice'>You have to go closer if you want to read it.</span>")

/obj/item/paper/proc/show_content(mob/user, forceshow)
	var/can_read = (istype(user, /mob/living/carbon/human) || isghost(user) || istype(user, /mob/living/silicon)) || forceshow
	if(!forceshow && istype(user,/mob/living/silicon/ai))
		var/mob/living/silicon/ai/AI = user
		can_read = get_dist(src, AI.camera) < 2
	user << browse("<HTML><HEAD><TITLE>[name]</TITLE></HEAD><BODY bgcolor='[color]'>[can_read ? info : stars(info)][stamps]</BODY></HTML>", "window=[name]")
	onclose(user, "[name]")

/obj/item/paper/verb/rename()
	set name = "Rename paper"
	set category = "Object"
	set src in usr

	if((CLUMSY in usr.mutations) && prob(50))
		to_chat(usr, "<span class='warning'>You cut yourself on the paper.</span>")
		return
	var/n_name = sanitizeSafe(input(usr, "What would you like to label the paper?", "Paper Labelling", null)  as text, MAX_NAME_LEN)

	// We check loc one level up, so we can rename in clipboards and such. See also: /obj/item/photo/rename()
	if((loc == usr || loc.loc && loc.loc == usr) && usr.stat == 0 && n_name)
		SetName(n_name)
		add_fingerprint(usr)

/obj/item/paper/attack_self(mob/living/user as mob)
	if(user.a_intent == I_HURT)
		if(icon_state == "scrap")
			user.show_message("<span class='warning'>\The [src] is already crumpled.</span>")
			return
		//crumple dat paper
		info = stars(info,85)
		user.visible_message("\The [user] crumples \the [src] into a ball!")
		icon_state = "scrap"
		return
	user.examinate(src)
	if(rigged && (Holiday == "April Fool's Day"))
		if(spam_flag == 0)
			spam_flag = 1
			playsound(loc, 'sound/items/bikehorn.ogg', 50, 1)
			spawn(20)
				spam_flag = 0

/obj/item/paper/attack_ai(var/mob/living/silicon/ai/user)
	show_content(user)

/obj/item/paper/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(user.zone_sel.selecting == BP_EYES)
		user.visible_message("<span class='notice'>You show the paper to [M]. </span>", \
			"<span class='notice'> [user] holds up a paper and shows it to [M]. </span>")
		M.examinate(src)

	else if(user.zone_sel.selecting == BP_MOUTH) // lipstick wiping
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(H == user)
				to_chat(user, "<span class='notice'>You wipe off the lipstick with [src].</span>")
				H.lip_style = null
				H.update_body()
			else
				user.visible_message("<span class='warning'>[user] begins to wipe [H]'s lipstick off with \the [src].</span>", \
								 	 "<span class='notice'>You begin to wipe off [H]'s lipstick.</span>")
				if(do_after(user, 10, H) && do_after(H, 10, needhand = 0))	//user needs to keep their active hand, H does not.
					user.visible_message("<span class='notice'>[user] wipes [H]'s lipstick off with \the [src].</span>", \
										 "<span class='notice'>You wipe off [H]'s lipstick.</span>")
					H.lip_style = null
					H.update_body()

/obj/item/paper/proc/addtofield(var/id, var/text, var/links = 0)
	var/locid = 0
	var/laststart = 1
	var/textindex = 1
	while(locid < MAX_FIELDS) // I know this can cause infinite loops and fuck up the whole server, but the if(istart==0) should be safe as fuck
		var/istart = 0		 //^ HEY CONGRATULATIONS FUCKHEAD YOU WERE RIGHT, IT DOES BREAK THE ENTIRE SERVER!
		if(links)
			istart = findtext(info_links, "<span class=\"paper_field\">", laststart)
		else
			istart = findtext(info, "<span class=\"paper_field\">", laststart)

		if(istart==0)
			return // No field found with matching id

		laststart = istart+1
		locid++
		if(locid == id)
			var/iend = 1
			if(links)
				iend = findtext(info_links, "</span>", istart)
			else
				iend = findtext(info, "</span>", istart)

			textindex = iend
			break

	if(links)
		var/before = copytext(info_links, 1, textindex)
		var/after = copytext(info_links, textindex)
		info_links = before + text + after
	else
		var/before = copytext(info, 1, textindex)
		var/after = copytext(info, textindex)
		info = before + text + after
		updateinfolinks()

/obj/item/paper/proc/updateinfolinks()
	info_links = info
	var/i = 0
	for(i=1,i<=fields,i++)
		addtofield(i, "<font face=\"[deffont]\"><A href='?src=\ref[src];write=[i]'>write</A></font>", 1)
	info_links = info_links + "<font face=\"[deffont]\"><A href='?src=\ref[src];write=end'>write</A></font>"


/obj/item/paper/proc/clearpaper()
	info = null
	stamps = null
	free_space = MAX_PAPER_MESSAGE_LEN
	stamped = list()
	overlays.Cut()
	updateinfolinks()
	update_icon()

/obj/item/paper/proc/get_signature(var/obj/item/pen/P, mob/user as mob)
	if(P && istype(P, /obj/item/pen))
		return P.get_signature(user)
	return (user && user.real_name) ? user.real_name : "Anonymous"

/obj/item/paper/proc/parsepencode(t, obj/item/pen/P, mob/user, iscrayon)
	//t = t
	if(length(t) == 0)
		return ""

	if(findtext(t, "\[sign\]"))
		t = replacetext(t, "\[sign\]", "<font face=\"[signfont]\"><i>[get_signature(P, user)]</i></font>")

	if(iscrayon) // If it is a crayon, and he still tries to use these, make them empty!
		t = replacetext(t, "\[*\]", "")
		t = replacetext(t, "\[hr\]", "")
		t = replacetext(t, "\[small\]", "")
		t = replacetext(t, "\[/small\]", "")
		t = replacetext(t, "\[list\]", "")
		t = replacetext(t, "\[/list\]", "")
		t = replacetext(t, "\[table\]", "")
		t = replacetext(t, "\[/table\]", "")
		t = replacetext(t, "\[row\]", "")
		t = replacetext(t, "\[cell\]", "")
		t = replacetext(t, "\[logo\]", "")

	if(iscrayon)
		t = "<font face=\"[crayonfont]\" color=[P ? P.colour : "black"]><b>[t]</b></font>"
	else
		t = "<font face=\"[deffont]\" color=[P ? P.colour : "black"]>[t]</font>"

	t = pencode2html(t)

	//Count the fields
	var/laststart = 1
	while(fields < MAX_FIELDS)
		var/i = findtext(t, "<span class=\"paper_field\">", laststart)	//</span>
		if(i==0)
			break
		laststart = i+1
		fields++

	return t


/obj/item/paper/proc/burnpaper(obj/item/flame/P, mob/user)
	var/class = "warning"

	if(P.lit && !user.restrained())
		if(istype(P, /obj/item/flame/lighter/zippo))
			class = "rose"

		user.visible_message("<span class='[class]'>[user] holds \the [P] up to \the [src], it looks like \he's trying to burn it!</span>", \
		"<span class='[class]'>You hold \the [P] up to \the [src], burning it slowly.</span>")

		spawn(20)
			if(get_dist(src, user) < 2 && user.get_active_hand() == P && P.lit)
				user.visible_message("<span class='[class]'>[user] burns right through \the [src], turning it to ash. It flutters through the air before settling on the floor in a heap.</span>", \
				"<span class='[class]'>You burn right through \the [src], turning it to ash. It flutters through the air before settling on the floor in a heap.</span>")

				if(user.get_inactive_hand() == src)
					user.drop_from_inventory(src)

				new /obj/effect/decal/cleanable/ash(src.loc)
				qdel(src)

			else
				to_chat(user, "<span class='warning'>You must hold \the [P] steady to burn \the [src].</span>")


/obj/item/paper/Topic(href, href_list)
	..()
	if(!usr || (usr.stat || usr.restrained()))
		return

	if(href_list["write"])
		var/id = href_list["write"]
		//var/t = strip_html_simple(input(usr, "What text do you wish to add to " + (id=="end" ? "the end of the paper" : "field "+id) + "?", "[name]", null),8192) as message

		if(free_space <= 0)
			to_chat(usr, "<span class='info'>There isn't enough space left on \the [src] to write anything.</span>")
			return

		var/t =  sanitize(input("Enter what you want to write:", "Write", null, null) as message, free_space, extra = 0, trim = 0)

		if(!t)
			return

		var/obj/item/i = usr.get_active_hand() // Check to see if he still got that darn pen, also check if he's using a crayon or pen.
		var/iscrayon = 0

		if(istype(i, /obj/item/pen/crayon))
			iscrayon = 1


		// if paper is not in usr, then it must be near them, or in a clipboard or folder, which must be in or near usr
		if(src.loc != usr && !src.Adjacent(usr) && !((istype(src.loc, /obj/item/clipboard) || istype(src.loc, /obj/item/folder)) && (src.loc.loc == usr || src.loc.Adjacent(usr)) ) )
			return

		var/last_fields_value = fields

		t = parsepencode(t, i, usr, iscrayon) // Encode everything from pencode to html


		if(fields > MAX_FIELDS)//large amount of fields creates a heavy load on the server, see updateinfolinks() and addtofield()
			to_chat(usr, "<span class='warning'>Too many fields. Sorry, you can't do this.</span>")
			fields = last_fields_value
			return

		if(id!="end")
			addtofield(text2num(id), t) // He wants to edit a field, let him.
		else
			info += t // Oh, he wants to edit to the end of the file, let him.
			updateinfolinks()

		update_space(t)

		usr << browse("<HTML><HEAD><TITLE>[name]</TITLE></HEAD><BODY bgcolor='[color]'>[info_links][stamps]</BODY></HTML>", "window=[name]") // Update the window

		update_icon()


/obj/item/paper/attackby(obj/item/P as obj, mob/user as mob)
	..()
	var/clown = 0
	if(user.mind && (user.mind.assigned_role == "Clown"))
		clown = 1

	if(istype(P, /obj/item/tape_roll))
		var/obj/item/tape_roll/tape = P
		tape.stick(src, user)
		return

	if(istype(P, /obj/item/paper) || istype(P, /obj/item/photo))
		if (istype(P, /obj/item/paper/carbon))
			var/obj/item/paper/carbon/C = P
			if (!C.iscopy && !C.copied)
				to_chat(user, "<span class='notice'>Take off the carbon copy first.</span>")
				add_fingerprint(user)
				return
		var/obj/item/paper_bundle/B = new(src.loc)
		if (name != "paper")
			B.SetName(name)
		else if (P.name != "paper" && P.name != "photo")
			B.SetName(P.name)

		user.drop_from_inventory(P)
		user.drop_from_inventory(src)
		user.put_in_hands(B)
		src.forceMove(B)
		P.forceMove(B)

		to_chat(user, "<span class='notice'>You clip the [P.name] to [(src.name == "paper") ? "the paper" : src.name].</span>")

		B.pages.Add(src)
		B.pages.Add(P)
		B.update_icon()

	else if(istype(P, /obj/item/pen))
		if(icon_state == "scrap")
			to_chat(usr, "<span class='warning'>\The [src] is too crumpled to write on.</span>")
			return

		var/obj/item/pen/robopen/RP = P
		if ( istype(RP) && RP.mode == 2 )
			RP.RenamePaper(user,src)
		else
			user << browse("<HTML><HEAD><TITLE>[name]</TITLE></HEAD><BODY bgcolor='[color]'>[info_links][stamps]</BODY></HTML>", "window=[name]")
		return

	else if(istype(P, /obj/item/stamp) || istype(P, /obj/item/clothing/ring/seal))
		if((!in_range(src, usr) && loc != user && !( istype(loc, /obj/item/clipboard) ) && loc.loc != user && user.get_active_hand() != P))
			return

		stamps += (stamps=="" ? "<HR>" : "<BR>") + "<i>This paper has been stamped with the [P.name].</i>"

		var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
		var/x
		var/y
		if(istype(P, /obj/item/stamp/captain) || istype(P, /obj/item/stamp/centcomm))
			x = rand(-2, 0)
			y = rand(-1, 2)
		else
			x = rand(-2, 2)
			y = rand(-3, 2)
		offset_x += x
		offset_y += y
		stampoverlay.pixel_x = x
		stampoverlay.pixel_y = y

		if(istype(P, /obj/item/stamp/clown))
			if(!clown)
				to_chat(user, "<span class='notice'>You are totally unable to use the stamp. HONK!</span>")
				return

		if(!ico)
			ico = new
		ico += "paper_[P.icon_state]"
		stampoverlay.icon_state = "paper_[P.icon_state]"

		if(!stamped)
			stamped = new
		stamped += P.type
		overlays += stampoverlay

		to_chat(user, "<span class='notice'>You stamp the paper with your [P.name].</span>")

	else if(istype(P, /obj/item/flame))
		burnpaper(P, user)

	else if(istype(P, /obj/item/paper_bundle))
		var/obj/item/paper_bundle/attacking_bundle = P
		attacking_bundle.insert_sheet_at(user, (attacking_bundle.pages.len)+1, src)
		attacking_bundle.update_icon()

	add_fingerprint(user)
	return

/*
 * Premade paper
 */
/obj/item/paper/Court
	name = "Judgement"
	info = "For crimes as specified, the offender is sentenced to:<BR>\n<BR>\n"

/obj/item/paper/crumpled
	name = "paper scrap"
	icon_state = "scrap"

/obj/item/paper/crumpled/update_icon()
	return

/obj/item/paper/crumpled/bloody
	icon_state = "scrap_bloodied"

/obj/item/paper/exodus_armory
	name = "armory inventory"
	info = "<center>\[logo]<BR><b><large>NSS Exodus</large></b><BR><i><date></i><BR><i>Armoury Inventory - Revision <field></i></center><hr><center>Armoury</center><list>\[*]<b>Deployable barriers</b>: 4\[*]<b>Biohazard suit(s)</b>: 1\[*]<b>Biohazard hood(s)</b>: 1\[*]<b>Face Mask(s)</b>: 1\[*]<b>Extended-capacity emergency oxygen tank(s)</b>: 1\[*]<b>Bomb suit(s)</b>: 1\[*]<b>Bomb hood(s)</b>: 1\[*]<b>Security officer's jumpsuit(s)</b>: 1\[*]<b>Brown shoes</b>: 1\[*]<b>Handcuff(s)</b>: 14\[*]<b>R.O.B.U.S.T. cartridges</b>: 7\[*]<b>Flash(s)</b>: 4\[*]<b>Can(s) of pepperspray</b>: 4\[*]<b>Gas mask(s)</b>: 6<field></list><hr><center>Secure Armoury</center><list>\[*]<b>LAEP90 Perun energy guns</b>: 4\[*]<b>Stun Revolver(s)</b>: 1\[*]<b>Taser Gun(s)</b>: 4\[*]<b>Stun baton(s)</b>: 4\[*]<b>Airlock Brace</b>: 3\[*]<b>Maintenance Jack</b>: 1\[*]<b>Stab Vest(s)</b>: 3\[*]<b>Riot helmet(s)</b>: 3\[*]<b>Riot shield(s)</b>: 3\[*]<b>Corporate security heavy armoured vest(s)</b>: 4\[*]<b>NanoTrasen helmet(s)</b>: 4\[*]<b>Portable flasher(s)</b>: 3\[*]<b>Tracking implant(s)</b>: 4\[*]<b>Chemical implant(s)</b>: 5\[*]<b>Implanter(s)</b>: 2\[*]<b>Implant pad(s)</b>: 2\[*]<b>Locator(s)</b>: 1<field></list><hr><center>Tactical Equipment</center><list>\[*]<b>Implanter</b>: 1\[*]<b>Death Alarm implant(s)</b>: 7\[*]<b>Security radio headset(s)</b>: 4\[*]<b>Ablative vest(s)</b>: 2\[*]<b>Ablative helmet(s)</b>: 2\[*]<b>Ballistic vest(s)</b>: 2\[*]<b>Ballistic helmet(s)</b>: 2\[*]<b>Tear Gas Grenade(s)</b>: 7\[*]<b>Flashbang(s)</b>: 7\[*]<b>Beanbag Shell(s)</b>: 7\[*]<b>Stun Shell(s)</b>: 7\[*]<b>Illumination Shell(s)</b>: 7\[*]<b>W-T Remmington 29x shotgun(s)</b>: 2\[*]<b>NT Mk60 EW Halicon ion rifle(s)</b>: 2\[*]<b>Hephaestus Industries G40E laser carbine(s)</b>: 4\[*]<b>Flare(s)</b>: 4<field></list><hr><b>Warden (print)</b>:<field><b>Signature</b>:<br>"

/obj/item/paper/exodus_cmo
	name = "outgoing CMO's notes"
	info = "<I><center>To the incoming CMO of Exodus:</I></center><BR><BR>I wish you and your crew well. Do take note:<BR><BR><BR>The Medical Emergency Red Phone system has proven itself well. Take care to keep the phones in their designated places as they have been optimised for broadcast. The two handheld green radios (I have left one in this office, and one near the Emergency Entrance) are free to be used. The system has proven effective at alerting Medbay of important details, especially during power outages.<BR><BR>I think I may have left the toilet cubicle doors shut. It might be a good idea to open them so the staff and patients know they are not engaged.<BR><BR>The new syringe gun has been stored in secondary storage. I tend to prefer it stored in my office, but 'guidelines' are 'guidelines'.<BR><BR>Also in secondary storage is the grenade equipment crate. I've just realised I've left it open - you may wish to shut it.<BR><BR>There were a few problems with their installation, but the Medbay Quarantine shutters should now be working again  - they lock down the Emergency and Main entrances to prevent travel in and out. Pray you shan't have to use them.<BR><BR>The new version of the Medical Diagnostics Manual arrived. I distributed them to the shelf in the staff break room, and one on the table in the corner of this room.<BR><BR>The exam/triage room has the walking canes in it. I'm not sure why we'd need them - but there you have it.<BR><BR>Emergency Cryo bags are beside the emergency entrance, along with a kit.<BR><BR>Spare paper cups for the reception are on the left side of the reception desk.<BR><BR>I've fed Runtime. She should be fine.<BR><BR><BR><center>That should be all. Good luck!</center>"

/obj/item/paper/exodus_bartender
	name = "shotgun permit"
	info = "This permit signifies that the Bartender is permitted to posess this firearm in the bar, and ONLY the bar. Failure to adhere to this permit will result in confiscation of the weapon and possibly arrest."

/obj/item/paper/exodus_holodeck
	name = "holodeck disclaimer"
	info = "Bruises sustained in the holodeck can be healed simply by sleeping."

/obj/item/paper/workvisa
	name = "Sol Work Visa"
	info = "<center><b><large>Work Visa of the Sol Central Government</large></b></center><br><center><img src = sollogo.png><br><br><i><small>Issued on behalf of the Secretary-General.</small></i></center><hr><BR>This paper hereby permits the carrier to travel unhindered through Sol territories, colonies, and space for the purpose of work and labor."
	desc = "A flimsy piece of laminated cardboard issued by the Sol Central Government."

/obj/item/paper/workvisa/New()
	..()
	icon_state = "workvisa" //Has to be here or it'll assume default paper sprites.

/obj/item/paper/astrafare_lore1
	name = "AAS Printout"
	info = "<b><large>Automated Announcement System</large></b><br>Last Event: 671 - 4 - 2 - 49 24:38<br>Date of Printout: 671 - 4 - 2 - 49 24:38<br><br><i>Output for 5 last events.</i><br><br><b>AXIS 49</b><br>19:25 ADMIN ANNOUNCEMENT: All personnel, proceed to evacuation zone 2 immediately.<br>19:31 SF CLEAR SKY: Station admin logged off. <br>20:01 MC ANNOUNCEMENT: To all PLs. This is Command. Abandon current task. Escort the science and intelligence personnel of ''Ward Eye'' and ''Clear Sky'' through the escape tunnels. <br>20:12 GARRISON: Station admin logged off.<br>24:38 Critical Failure of S-E Systems. All devices transferred to their analogue source of energy. Printing out last state of the system.<br><br><b>GENERAL STATE: LET US ALL END THIS MISERY.</b>"

/obj/item/paper/astrafare_lore2
	name = "ATT-1 Journal N10"
	info = "<b><large>Automated Tracking Telescope-1 Journal</large></b><br><br>AS-1 D. Houch <center>671 - 4 - 1 - 35 No abnormal activity</center><br>AS-1 L. Ion	<center>671 - 4 - 1 - 36 No abnormal activity</center><br>AS-1 P. Qio <center>671 - 4 - 1 - 37 No abnormal activity (Brief luminosity shutdown)</center><br>AS-1 U. Chy	<center>671 - 4 - 1 - 38 No abnormal activity</center><br>AS-1 D. Houch <center>671 - 4 - 1 - 39 No abnormal activity</center><br>AS-1 L. Ion	<center>671 - 4 - 1 - 40 No abnormal activity</center><br>AS-2 A. Lomaster <center>671 - 4 - 1 - 41 Unknown object approached the target at 12:03 YST. Target energy luminosity decreased by 5 points.</center><br>AS-2 F. Econ <center>671 - 4 - 1 - 42 Target appears to be back to normal energy luminosity.</center><br>AS-3-PO I. Tou <center>671 - 4 - 1 - 43 Target exploded at 22:05 YST. Pieces are scattered at large variety of orbits. Estimated count of pieces is 4509. Of them are valuable and recommended to be retrieved at some point: 35. 4 of them would be inaccessible in less than 2 Cycles. 10 of them are excepted to make a landing somewhere on the planet. Main goal of observation project is concluded with technical success. All side goals are failed. All data is to be send to Intel. Tracking of pieces is to be continued.</center>"

/obj/item/paper/astrafare_lore3
	name = "The Letter"
	info = "To Head of Project ''Getaway''<br>From Director of Mt. Clear Sky, Director of Ward Eye Station, Major Aelou.<br>671 - 4 - 1 - 45<br><br>''Omen'' is down. Something destroyed it from the outside. We are to abandon current position soon since the Second SO Company can't sabotage and deceive our enemies from this place any more. We have 1 Stage left to track any valuable pieces. Our hope is that this task gets properly succeeded by First or Second Department of ''Getaway''. <br><br>Let us all end this misery."

/obj/item/paper/astrafare_lore4
	name = "CAT Printout"
	info = ">cat true -i -po<br><b>CHATTER AUTO TRANSCRIPT: CANNOT BE ENABLED. THE INSTRUCTION IS FORBIDDEN BY STATION ADMIN.</b><br>>admin override -l -d plug1 <br><b>DEVICE CHECK IS COMPLETE. SUCCESS. ADMIN OVERRIDE COMPLETE. JOINED AS ADMIN OF WARD EYE STATION.</b><br>>cat true -i -po<br><b>CHATTER AUTO TRANSCRIPT: ENABLED.</b><br><br>. . .<br>To Mountain-1 Actual, this is Sunset-1. Destroy the equipment before 1200 over.<br>Copy.<br>. . . <br>To Mountain-2 Actual, this is Sunset-1. Lead the personnel to EZ2 over. <br>Mountain-2 roger.<br>. . . <br>. . .<br>. . .<br>. . .<br>Mountain-1. This is Sunset-1. What is your status?<br>Mountain-1. This is Sunset-1 respond.<br>. . . <br>. . . <br><i>Mao. Fuck you, you fucking cunt. I will fucking kill you as soon as I-</i><br>. . . <br>. . . <br>Sunset-1. Explosives failed. We can’t destroy shit. Mao...<br>Sunset-1.<br>This is Sunset-1. State your unit.<br>Respond.<br>. . . <br>. . . <br>To Omen Actual, this is Sunset-1 Actual. Mountain-1 is down. Explosives are worthless over.<br>Sunset-1, this is Omen. We cannot show our presence. Abandon first task and proceed with second over. <br>Sunset-1 copy.<br>. . . <br>To Mountain-2 and 3. This is Sunset-1. Lead the personnel from EZ2 to escape tunnels. Over.<br>Mountain-2 copy.<br>Mountain-3 copy.<br>. . . <br>. . . <br>. . . <br>To Sky-1 Actual and Sky-2 Actual. This is Sunset-2. Abandon the Garrison and join Sunset-1. Over.<br>Copy.<br>Roger.<br>. . . <br>. . . <br>. . . <br>. . . <br>. . . <br>. . . <br>. . . <br>. . . <br>. . . <br>. . . <br>. . . <br>. . . <br>. . . <br>. . . <br><br><b>ENERGY IS LOW. PRINTING OUT LAST SESSION AND SHUTTING DOWN.</b><br>"
