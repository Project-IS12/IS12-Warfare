#define GLOBAL_PROC_REF(NAME) (/proc/NAME)

#if DM_VERSION < 515
#define PROC_REF(NAME) (.proc/NAME)
#define PROC_BY_TYPE(PATH, NAME) (PATH/proc/NAME)
#define LIBCALL call
#define DYNAMIC_CALL(OBJECT, PROC) call(OBJECT, PROC)
#else
#define PROC_REF(NAME) (nameof(.proc/NAME))
#define PROC_BY_TYPE(PATH, NAME) (nameof(PATH/proc/NAME))
#define LIBCALL call_ext
#define DYNAMIC_CALL(OBJECT, PROC) call(OBJECT, legacy_proc_name(PROC))
#endif

/proc/legacy_proc_name(proc_reference)
	// ispath() excludes proc/verb references on these BYOND versions.
	if(istext(proc_reference) || isnull(proc_reference))
		return proc_reference
	var/static/list/names = list()
	if(!(proc_reference in names))
		var/path_text = "[proc_reference]"
		names[proc_reference] = copytext(path_text, findlasttext(path_text, "/") + 1)
	return names[proc_reference]
