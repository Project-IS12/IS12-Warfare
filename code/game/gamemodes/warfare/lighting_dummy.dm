//Warfare daylight lightings dummies. Thank fuck lighting isn't additive. Todo: make this into a schedulable subsystem HOLY FUCK this will lag on big maps.
GLOBAL_LIST_EMPTY(lighting_dummies)

/obj/effect/lighting_dummy
    name = "lighting dammy"
    desc = "you literally should not be able to see or interact with this."
    anchored = TRUE
    invisibility = 101
//For nightfare.
/obj/effect/lighting_dummy/daylight/Initialize()
    . = ..()
    GLOB.lighting_dummies += src
    if(aspect_chosen(/datum/aspect/nightfare)) //For init. Note this will probably force this mode on until behavior has been made for deactivating aspects.
        return
    set_light(3, 3, "#28284f")
/obj/effect/lighting_dummy/Destroy() //Shouldn't happen but let's prevent runtimes.
    . = ..()
    GLOB.lighting_dummies -= src

/obj/effect/lighting_dummy/ex_act()
    return


/obj/effect/lighting_dummy/flare
    mouse_opacity = 0
    invisibility = 0
    icon = 'icons/obj/items/mortars.dmi'
    icon_state = "redFlare"
    plane = EFFECTS_ABOVE_LIGHTING_PLANE
    light_power = 6
    light_range = 10
    light_color = COLOR_RED

    Initialize()
        . = ..()
        QDEL_IN(src, 3 MINUTES)

/obj/effect/lighting_dummy/flare/blue
    icon_state = "blueFlare"
    light_color = COLOR_BLUE