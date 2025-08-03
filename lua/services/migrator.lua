-- Configuration Migrator Service
-- Handles migration of Neovim configuration changes using journal entries

local journal = require('services.journal')

local M = {}

-- Migration registry
M.migrations = {}
M.migration_history = {}

-- Register a migration
-- @param id string: Unique migration identifier
-- @param description string: Description of the migration
-- @param up_fn function: Function to apply the migration
-- @param down_fn function: Function to rollback the migration
-- @param validator_fn function: Function to validate if migration is applied
function M.register_migration(id, description, up_fn, down_fn, validator_fn)
	M.migrations[id] = {
		id = id,
		description = description,
		up = up_fn,
		down = down_fn,
		validate = validator_fn,
		registered_at = os.time(),
	}
end

-- Apply a single migration
-- @param migration_id string: ID of the migration to apply
-- @return table: Result of the migration
function M.apply_migration(migration_id)
	local migration = M.migrations[migration_id]
	if not migration then
		return {
			success = false,
			error = "Migration not found: " .. migration_id,
		}
	end
	
	-- Check if migration is already applied
	if M.is_migration_applied(migration_id) then
		return {
			success = true,
			message = "Migration already applied: " .. migration_id,
			skipped = true,
		}
	end
	
	-- Create journal entry for the migration
	local journal_entry = journal.create_entry(
		"migration",
		"Applying migration: " .. migration.description,
		{
			migration_id = migration_id,
			action = "apply",
		}
	)
	
	-- Apply the migration
	local success, result = pcall(migration.up)
	
	if success then
		-- Update journal entry status
		journal.update_entry_status(journal_entry.id, "completed")
		
		-- Record in migration history
		table.insert(M.migration_history, {
			migration_id = migration_id,
			applied_at = os.time(),
			journal_entry_id = journal_entry.id,
		})
		
		return {
			success = true,
			message = "Migration applied successfully: " .. migration_id,
			result = result,
		}
	else
		-- Update journal entry status
		journal.update_entry_status(journal_entry.id, "failed")
		
		return {
			success = false,
			error = "Migration failed: " .. tostring(result),
			migration_id = migration_id,
		}
	end
end

-- Rollback a migration
-- @param migration_id string: ID of the migration to rollback
-- @return table: Result of the rollback
function M.rollback_migration(migration_id)
	local migration = M.migrations[migration_id]
	if not migration then
		return {
			success = false,
			error = "Migration not found: " .. migration_id,
		}
	end
	
	-- Check if migration is applied
	if not M.is_migration_applied(migration_id) then
		return {
			success = true,
			message = "Migration not applied, nothing to rollback: " .. migration_id,
			skipped = true,
		}
	end
	
	-- Create journal entry for the rollback
	local journal_entry = journal.create_entry(
		"migration",
		"Rolling back migration: " .. migration.description,
		{
			migration_id = migration_id,
			action = "rollback",
		}
	)
	
	-- Rollback the migration
	local success, result = pcall(migration.down)
	
	if success then
		-- Update journal entry status
		journal.update_entry_status(journal_entry.id, "completed")
		
		-- Remove from migration history
		for i, history_entry in ipairs(M.migration_history) do
			if history_entry.migration_id == migration_id then
				table.remove(M.migration_history, i)
				break
			end
		end
		
		return {
			success = true,
			message = "Migration rolled back successfully: " .. migration_id,
			result = result,
		}
	else
		-- Update journal entry status
		journal.update_entry_status(journal_entry.id, "failed")
		
		return {
			success = false,
			error = "Migration rollback failed: " .. tostring(result),
			migration_id = migration_id,
		}
	end
end

-- Check if a migration is applied
-- @param migration_id string: ID of the migration to check
-- @return boolean: True if migration is applied
function M.is_migration_applied(migration_id)
	for _, history_entry in ipairs(M.migration_history) do
		if history_entry.migration_id == migration_id then
			return true
		end
	end
	return false
end

-- Apply all pending migrations
-- @return table: Summary of migration results
function M.migrate_all()
	local results = {
		total_migrations = 0,
		applied = 0,
		skipped = 0,
		failed = 0,
		errors = {},
	}
	
	-- Sort migrations by ID to ensure consistent order
	local migration_ids = {}
	for id, _ in pairs(M.migrations) do
		table.insert(migration_ids, id)
	end
	table.sort(migration_ids)
	
	for _, migration_id in ipairs(migration_ids) do
		results.total_migrations = results.total_migrations + 1
		
		local result = M.apply_migration(migration_id)
		
		if result.success then
			if result.skipped then
				results.skipped = results.skipped + 1
			else
				results.applied = results.applied + 1
			end
		else
			results.failed = results.failed + 1
			table.insert(results.errors, {
				migration_id = migration_id,
				error = result.error,
			})
		end
	end
	
	return results
end

-- Reconcile migrations using journal entries
-- @return table: Reconciliation report
function M.reconcile()
	-- Custom validator function for migrations
	local validator_fn = function(entry)
		if entry.type == "migration" and entry.data.migration_id then
			local migration_id = entry.data.migration_id
			local migration = M.migrations[migration_id]
			
			if migration and migration.validate then
				-- Use the migration's validator if available
				return migration.validate()
			else
				-- Default validation: check if it's in migration history
				return M.is_migration_applied(migration_id)
			end
		end
		return true -- Non-migration entries are considered valid
	end
	
	-- Use journal's reconcile method with our validator
	local journal_report = journal.reconcile(validator_fn)
	
	-- Add migration-specific information
	local migration_report = {
		journal_report = journal_report,
		registered_migrations = vim.tbl_count(M.migrations),
		applied_migrations = #M.migration_history,
		migration_inconsistencies = {},
	}
	
	-- Check for migration-specific inconsistencies
	for _, history_entry in ipairs(M.migration_history) do
		local migration = M.migrations[history_entry.migration_id]
		if migration and migration.validate and not migration.validate() then
			table.insert(migration_report.migration_inconsistencies, {
				migration_id = history_entry.migration_id,
				issue = "applied_but_validation_failed",
				applied_at = history_entry.applied_at,
			})
		end
	end
	
	return migration_report
end

-- Get migration status
-- @return table: Status of all migrations
function M.get_status()
	local status = {
		registered_migrations = {},
		applied_migrations = {},
		pending_migrations = {},
	}
	
	-- Get all registered migrations
	for id, migration in pairs(M.migrations) do
		table.insert(status.registered_migrations, {
			id = id,
			description = migration.description,
			registered_at = migration.registered_at,
		})
		
		if M.is_migration_applied(id) then
			-- Find when it was applied
			for _, history_entry in ipairs(M.migration_history) do
				if history_entry.migration_id == id then
					table.insert(status.applied_migrations, {
						id = id,
						description = migration.description,
						applied_at = history_entry.applied_at,
					})
					break
				end
			end
		else
			table.insert(status.pending_migrations, {
				id = id,
				description = migration.description,
			})
		end
	end
	
	return status
end

-- Example migrations for Neovim configuration
M.register_migration(
	"001_setup_lazy_nvim",
	"Setup lazy.nvim plugin manager",
	function()
		-- This would setup lazy.nvim if not already setup
		print("Setting up lazy.nvim plugin manager")
		return true
	end,
	function()
		-- This would remove lazy.nvim setup
		print("Removing lazy.nvim plugin manager setup")
		return true
	end,
	function()
		-- Check if lazy.nvim is setup
		return package.loaded["lazy"] ~= nil
	end
)

M.register_migration(
	"002_configure_lsp",
	"Configure LSP settings",
	function()
		-- This would configure LSP settings
		print("Configuring LSP settings")
		return true
	end,
	function()
		-- This would remove LSP configuration
		print("Removing LSP configuration")
		return true
	end,
	function()
		-- Check if LSP is configured
		return vim.lsp ~= nil and next(vim.lsp.get_active_clients()) ~= nil
	end
)

M.register_migration(
	"003_setup_treesitter",
	"Setup Treesitter configuration",
	function()
		-- This would setup Treesitter
		print("Setting up Treesitter configuration")
		return true
	end,
	function()
		-- This would remove Treesitter setup
		print("Removing Treesitter configuration")
		return true
	end,
	function()
		-- Check if Treesitter is setup
		return package.loaded["nvim-treesitter"] ~= nil
	end
)

return M

