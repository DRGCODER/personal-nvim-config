-- Journal Entry Service
-- Manages journal entries for configuration changes and migrations

local M = {}

-- Journal entry storage
M.entries = {}

-- Create a new journal entry
-- @param type string: Type of entry (migration, config_change, plugin_install, etc.)
-- @param description string: Description of the change
-- @param data table: Additional data related to the entry
-- @return table: The created journal entry
function M.create_entry(type, description, data)
	local entry = {
		id = os.time() .. "_" .. math.random(1000, 9999),
		timestamp = os.time(),
		type = type,
		description = description,
		data = data or {},
		status = "pending",
	}
	
	table.insert(M.entries, entry)
	return entry
end

-- Get all journal entries
-- @return table: Array of all journal entries
function M.get_all_entries()
	return M.entries
end

-- Get journal entries by type
-- @param type string: Type of entries to retrieve
-- @return table: Array of entries matching the type
function M.get_entries_by_type(type)
	local filtered = {}
	for _, entry in ipairs(M.entries) do
		if entry.type == type then
			table.insert(filtered, entry)
		end
	end
	return filtered
end

-- Update journal entry status
-- @param entry_id string: ID of the entry to update
-- @param status string: New status (pending, completed, failed, rolled_back)
-- @return boolean: Success status
function M.update_entry_status(entry_id, status)
	for _, entry in ipairs(M.entries) do
		if entry.id == entry_id then
			entry.status = status
			entry.updated_at = os.time()
			return true
		end
	end
	return false
end

-- Reconcile method - ensures consistency between journal and actual state
-- @param validator_fn function: Function to validate if changes are applied
-- @return table: Reconciliation report
function M.reconcile(validator_fn)
	local report = {
		total_entries = #M.entries,
		pending_entries = 0,
		completed_entries = 0,
		failed_entries = 0,
		inconsistencies = {},
	}
	
	for _, entry in ipairs(M.entries) do
		if entry.status == "pending" then
			report.pending_entries = report.pending_entries + 1
		elseif entry.status == "completed" then
			report.completed_entries = report.completed_entries + 1
			
			-- Validate if the change is actually applied
			if validator_fn and not validator_fn(entry) then
				table.insert(report.inconsistencies, {
					entry_id = entry.id,
					issue = "marked_completed_but_not_applied",
					description = entry.description,
				})
			end
		elseif entry.status == "failed" then
			report.failed_entries = report.failed_entries + 1
		end
	end
	
	return report
end

-- Clear journal entries older than specified days
-- @param days number: Number of days to keep entries
-- @return number: Number of entries removed
function M.cleanup_old_entries(days)
	local cutoff_time = os.time() - (days * 24 * 60 * 60)
	local removed_count = 0
	local new_entries = {}
	
	for _, entry in ipairs(M.entries) do
		if entry.timestamp >= cutoff_time then
			table.insert(new_entries, entry)
		else
			removed_count = removed_count + 1
		end
	end
	
	M.entries = new_entries
	return removed_count
end

-- Export journal entries to a file
-- @param filepath string: Path to export file
-- @return boolean: Success status
function M.export_to_file(filepath)
	local file = io.open(filepath, "w")
	if not file then
		return false
	end
	
	file:write("-- Neovim Configuration Journal Export\n")
	file:write("-- Generated at: " .. os.date("%Y-%m-%d %H:%M:%S") .. "\n\n")
	
	for _, entry in ipairs(M.entries) do
		file:write(string.format("Entry ID: %s\n", entry.id))
		file:write(string.format("Timestamp: %s\n", os.date("%Y-%m-%d %H:%M:%S", entry.timestamp)))
		file:write(string.format("Type: %s\n", entry.type))
		file:write(string.format("Status: %s\n", entry.status))
		file:write(string.format("Description: %s\n", entry.description))
		
		if next(entry.data) then
			file:write("Data:\n")
			for key, value in pairs(entry.data) do
				file:write(string.format("  %s: %s\n", key, tostring(value)))
			end
		end
		
		file:write("\n" .. string.rep("-", 50) .. "\n\n")
	end
	
	file:close()
	return true
end

return M

