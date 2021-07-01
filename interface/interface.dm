//Please use mob or src (not usr) in these procs. This way they can be called in the same fashion as procs.
/client/verb/wiki()
	set name = "Wiki"
	set desc = "Visit the wiki."
	set hidden = 1
	if( config.wikiurl )
		if(alert("This will open the wiki in your browser. Are you sure?",,"Yes","No")=="No")
			return
		src << link(config.wikiurl)
	else
		to_chat(src, "<span class='warning'>The wiki URL is not set in the server configuration.</span>")
	return

/client/verb/forum()
	set name = "Forum"
	set desc = "Visit the forum."
	set hidden = 1
	if( config.forumurl )
		if(alert("This will open the forum in your browser. Are you sure?",,"Yes","No")=="No")
			return
		src << link(config.forumurl)
	else
		to_chat(src, "<span class='warning'>The forum URL is not set in the server configuration.</span>")
	return

#define RULES_FILE "config/rules.html"
/client/verb/rules()
	set name = "Rules"
	set category = "OOC"
	set desc = "Show Server Rules."
	src << browse(file(RULES_FILE), "window=rules;size=480x320")
#undef RULES_FILE

#define LORE_FILE "config/lore.html"
/client/verb/lore_splash()
	set name = "Lore"
	set desc = "Links to the beginner Lore wiki."
	set hidden = 1
	show_browser(src, file(LORE_FILE), "window=lore;size=480x320")
#undef LORE_FILE

/client/verb/hotkeys_help()
	set name = "View Controls"
	set category = "OOC"

	var/dat

	var/admin = {"<span class='interface'>
<h3>Admin:</h3>
<br>F5 = Aghost (admin-ghost)
<br>F6 = player-panel-new
<br>F7 = admin-pm
<br>F8 = Invisimin
</span>"}

	var/hotkey_mode = {"<span class='interface'>
<h3>Hotkey-Mode: (hotkey-mode must be on)</h3>
<br>TAB = toggle hotkey-mode
<br>a = left
<br>s = down
<br>d = right
<br>w = up
<br>pgup = move-upwards
<br>pgdown = move-down
<br>q = drop
<br>e = equip
<br>r = throw
<br>t = say
<br>c = toggle combat mode
<br>o = OOC
<br>5 = emote
<br>x = swap-hand
<br>z = activate held object (or y)
<br>f = toggle fixeye
<br>shift+f = look up
<br>shift+x = wield weapon
<br>shift+z = toggle safety/unjam gun
<br>1 = help-intent
<br>2 = disarm-intent
<br>3 = grab-intent
<br>4 = harm-intent
<br>space OR v = crouch
</span>"}

	var/other = {"<span class='interface'>
<h3>Any-Mode: (hotkey doesn't need to be on)</h3>
<br>Ctrl+a = left
<br>Ctrl+s = down
<br>Ctrl+d = right
<br>Ctrl+w = up
<br>Ctrl+q = drop
<br>Ctrl+e = equip
<br>Ctrl+r = throw
<br>Ctrl+x or Middle Mouse = swap-hand
<br>Ctrl+z = activate held object (or Ctrl+y)
<br>Ctrl+f = cycle-intents-left
<br>Ctrl+g = cycle-intents-right
<br>Ctrl+1 = help-intent
<br>Ctrl+2 = disarm-intent
<br>Ctrl+3 = grab-intent
<br>Ctrl+4 = harm-intent
<br>F1 = adminhelp
<br>F2 = ooc
<br>F3 = say
<br>F4 = emote
<br>DEL = pull
<br>INS = cycle-intents-right
<br>HOME = drop
<br>PGUP or Middle Mouse = swap-hand
<br>PGDN = activate held object
<br>END = throw
<br>Ctrl + Click = drag
<br>Shift + Click = examine
<br>Alt + Click = show entities on turf
<br>Ctrl + Alt + Click = interact with certain items
</span>"}

	var/special_controls = {"<span class='interface'>
<h3>Speacial Controls:</h3>
<br>look up = RMB+Fixeye button OR Shift+F
<br>look into distance = ALT+RMB
<br>give = RMB+help intent
<br>wave friendly = RMB+help intent at a distance
<br>threaten = RMB+harm intent at a distance
<br>toggle fullscreen = CTRL+ENTER
<br>jump = select "jump" on the UI and middle click
<br>kick = select "kick" on the UI and middle click
</span>"}

	var/gun_controls = {"<span class='interface'>
<h3>Weapon controls:</h3>
<br>toggle safety = RMB on gun OR shift+z
<br>do special attack = RMB + harm intent + combat mode
<br>unload gun = click drag into empty hand
<br>clean gun = ALT + Click on gun
<br>unjam gun = RMB on gun when it's jammed
</span>"}

	var/robot_hotkey_mode = {"<span class='interface'>
<h3>Hotkey-Mode: (hotkey-mode must be on)</h3>
<br>TAB = toggle hotkey-mode
<br>a = left
<br>s = down
<br>d = right
<br>w = up
<br>q = unequip active module
<br>t = say
<br>x = cycle active modules
<br>z = activate held object (or y)
<br>f = cycle-intents-left
<br>g = cycle-intents-right
<br>1 = activate module 1
<br>2 = activate module 2
<br>3 = activate module 3
<br>4 = toggle intents
<br>5 = emote
</span>"}

	var/robot_other = {"<span class='interface'>
<h3>Any-Mode: (hotkey doesn't need to be on)</h3>
<br>Ctrl+a = left
<br>Ctrl+s = down
<br>Ctrl+d = right
<br>Ctrl+w = up
<br>Ctrl+q = unequip active module
<br>Ctrl+x = cycle active modules
<br>Ctrl+z = activate held object (or Ctrl+y)
<br>Ctrl+f = cycle-intents-left
<br>Ctrl+g = cycle-intents-right
<br>Ctrl+1 = activate module 1
<br>Ctrl+2 = activate module 2
<br>Ctrl+3 = activate module 3
<br>Ctrl+4 = toggle intents
<br>F1 = adminhelp
<br>F2 = ooc
<br>F3 = say
<br>F4 = emote
<br>DEL = pull
<br>INS = toggle intents
<br>PGUP = cycle active modules
<br>PGDN = activate held object
<br>Ctrl + Click = drag or bolt doors
<br>Shift + Click = examine or open doors
<br>Alt + Click = show entities on turf
<br>Ctrl + Alt + Click = electrify doors
</span>"}

	if(isrobot(src.mob))
		dat += robot_hotkey_mode
		dat += robot_other
	else
		dat += hotkey_mode
		dat += other
		dat += special_controls
		dat += gun_controls
	if(holder)
		dat += admin
	src << browse(dat, "window=controls")
