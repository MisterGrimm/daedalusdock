/atom/proc/investigate_log(message, subject)
	if(!message || !subject)
		return

	var/source = "[src]"

	if(isliving(src))
		var/mob/living/source_mob = src
		source += " ([source_mob.ckey ? source_mob.ckey : "*no key*"])"

	rustg_file_append("[time_stamp("YYYY-MM-DD hh:mm:ss")] [REF(src)] ([x],[y],[z]) || [source] [message]<br>", "[GLOB.log_directory]/[subject].html")

/client/proc/investigate_show()
	set name = "Investigate"
	set category = "Admin.Game"
	if(!holder)
		return

	var/list/investigates = list(
		INVESTIGATE_ACCESSCHANGES,
		INVESTIGATE_ATMOS,
		INVESTIGATE_BOTANY,
		INVESTIGATE_CARGO,
		INVESTIGATE_CRAFTING,
		INVESTIGATE_ENGINE,
		INVESTIGATE_EXPERIMENTOR,
		INVESTIGATE_GRAVITY,
		INVESTIGATE_HALLUCINATIONS,
		INVESTIGATE_HYPERTORUS,
		INVESTIGATE_PORTAL,
		INVESTIGATE_PRESENTS,
		INVESTIGATE_RADIATION,
		INVESTIGATE_RECORDS,
		INVESTIGATE_RESEARCH,
		INVESTIGATE_WIRES,
	)

	var/list/logs_present = list("notes, memos, watchlist")
	var/list/logs_missing = list("---")

	for(var/subject in investigates)
		var/temp_file = file("[GLOB.log_directory]/[subject].html")
		if(fexists(temp_file))
			logs_present += subject
		else
			logs_missing += "[subject] (empty)"

	var/list/combined = sort_list(logs_present) + sort_list(logs_missing)

	var/selected = tgui_input_list(src, "Investigate what?", "Investigation", combined)
	if(isnull(selected))
		return
	if(!(selected in combined) || selected == "---")
		return

	selected = replacetext(selected, " (empty)", "")

	// Eventually kill this, It's now redundant.
	if(selected == "notes, memos, watchlist" && check_rights(R_ADMIN))
		browse_messages()
		return

	var/F = file("[GLOB.log_directory]/[selected].html")
	if(!fexists(F))
		to_chat(src, span_danger("No [selected] logfile was found."), confidential = TRUE)
		return
	src << browse(F,"window=investigate[selected];size=800x300")
