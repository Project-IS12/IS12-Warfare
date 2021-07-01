// Something to remember when setting priorities: SS_TICKER runs before Normal, which runs before SS_BACKGROUND.
// Each group has its own priority bracket.
// SS_BACKGROUND handles high server load differently than Normal and SS_TICKER do.
// Higher priority also means a larger share of a given tick before sleep checks.

// SS_TICKER
// < none >

#define SS_PRIORITY_DEFAULT 50          // Default priority for both normal and background processes

// Normal
#define SS_PRIORITY_OVERLAY        500	// Applies overlays. May cause overlay pop-in if it gets behind.
#define SS_PRIORITY_CHAT           400	// Goonchat queue
#define SS_PRIORITY_MOB            100	// Mob Life().
#define SS_PRIORITY_MACHINERY      100	// Machinery + powernet ticks.
#define SS_PRIORITY_AIR             80	// ZAS processing.
#define SS_PRIORITY_AO              65	// Ambien occlusion shit
#define SS_PRIORITY_EVENT           20	// Event processing and queue handling.
#define SS_PRIORITY_ALARMS          20  // Alarm processing.
#define SS_PRIORITY_AIRFLOW         15	// Object movement from ZAS airflow.


// SS_BACKGROUND
#define SS_PRIORITY_OBJECTS       60	// processing_objects processing.
#define SS_PRIORITY_NANOUI        40   // Updates to nanoui uis.
#define SS_PRIORITY_PROCESSING    30	// Generic datum processor. Replaces objects processor.
#define SS_PRIORITY_GARBAGE       25	// Garbage collection.
#define SS_PRIORITY_VINES         25	// Spreading vine effects.
#define SS_PRIORITY_WIRELESS      10	// Wireless connection setup.
#define SS_PRIORITY_PING          10	// Client ping.
#define SS_PRIORITY_PROJECTILES   10	// Projectile processing!


// Subsystem init_order, from highest priority to lowest priority
// Subsystems shutdown in the reverse of the order they initialize in
// The numbers just define the ordering, they are meaningless otherwise.

#define INIT_BAY_LEGACY      21
#define INIT_ORDER_ASPECTS   20
#define INIT_ORDER_SKYBOX    19
#define INIT_ORDER_JOBS      15
#define INIT_ORDER_EVENTS    14
#define INIT_ORDER_MAPPING   12
#define INIT_ORDER_ATOMS     11
#define INIT_ORDER_MACHINES   9
#define INIT_ORDER_AO         5
#define INIT_ORDER_SHUTTLE    3
#define INIT_ORDER_TIMER      1
#define INIT_ORDER_DEFAULT    0
#define INIT_ORDER_AIR       -1
#define INIT_ORDER_OVERLAY   -6
#define INIT_ORDER_LIGHTING -20
#define INIT_OPEN_SPACE    -150
#define INIT_ORDER_TICKER  -205
#define INIT_ORDER_CHAT    -210 //Should be last to ensure chat remains smooth during init.
