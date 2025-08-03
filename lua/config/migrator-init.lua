-- Initialize and configure the migrator service
-- This file demonstrates how to use the migrator with journal entries

local migrator = require('services.migrator')
local journal = require('services.journal')

local M = {}

-- Initialize the migrator system
function M.setup()
	-- Create a journal entry for migrator initialization
	journal.create_entry(
		"system",
		"Initializing migrator system",
		{ component = "migrator", version = "1.0.0" }
	)
	
	print("Migrator system initialized")
	print("Registered migrations: " .. vim.tbl_count(migrator.migrations))
end

-- Run all pending migrations
function M.run_migrations()
	print("Running all pending migrations...")
	local results = migrator.migrate_all()
	
	print(string.format(
		"Migration complete: %d applied, %d skipped, %d failed",
		results.applied,
		results.skipped,
		results.failed
	))
	
	if results.failed > 0 then
		print("Failed migrations:")
		for _, error in ipairs(results.errors) do
			print(string.format("  - %s: %s", error.migration_id, error.error))
		end
	end
	
	return results
end

-- Show migration status
function M.show_status()
	local status = migrator.get_status()
	
	print("=== Migration Status ===")
	print("Registered migrations: " .. #status.registered_migrations)
	print("Applied migrations: " .. #status.applied_migrations)
	print("Pending migrations: " .. #status.pending_migrations)
	
	if #status.pending_migrations > 0 then
		print("\nPending migrations:")
		for _, migration in ipairs(status.pending_migrations) do
			print(string.format("  - %s: %s", migration.id, migration.description))
		end
	end
	
	if #status.applied_migrations > 0 then
		print("\nApplied migrations:")
		for _, migration in ipairs(status.applied_migrations) do
			print(string.format("  - %s: %s (applied at %s)", 
				migration.id, 
				migration.description,
				os.date("%Y-%m-%d %H:%M:%S", migration.applied_at)
			))
		end
	end
end

-- Run reconciliation
function M.reconcile()
	print("Running reconciliation...")
	local report = migrator.reconcile()
	
	print("=== Reconciliation Report ===")
	print("Total journal entries: " .. report.journal_report.total_entries)
	print("Pending entries: " .. report.journal_report.pending_entries)
	print("Completed entries: " .. report.journal_report.completed_entries)
	print("Failed entries: " .. report.journal_report.failed_entries)
	print("Registered migrations: " .. report.registered_migrations)
	print("Applied migrations: " .. report.applied_migrations)
	
	if #report.journal_report.inconsistencies > 0 then
		print("\nJournal inconsistencies found:")
		for _, inconsistency in ipairs(report.journal_report.inconsistencies) do
			print(string.format("  - %s: %s", inconsistency.entry_id, inconsistency.issue))
		end
	end
	
	if #report.migration_inconsistencies > 0 then
		print("\nMigration inconsistencies found:")
		for _, inconsistency in ipairs(report.migration_inconsistencies) do
			print(string.format("  - %s: %s", inconsistency.migration_id, inconsistency.issue))
		end
	end
	
	return report
end

-- Export journal to file
function M.export_journal(filepath)
	filepath = filepath or vim.fn.stdpath('config') .. '/migration-journal.log'
	local success = journal.export_to_file(filepath)
	
	if success then
		print("Journal exported to: " .. filepath)
	else
		print("Failed to export journal to: " .. filepath)
	end
	
	return success
end

-- Create user commands for easy access
function M.create_commands()
	vim.api.nvim_create_user_command('MigratorStatus', function()
		M.show_status()
	end, { desc = 'Show migration status' })
	
	vim.api.nvim_create_user_command('MigratorRun', function()
		M.run_migrations()
	end, { desc = 'Run all pending migrations' })
	
	vim.api.nvim_create_user_command('MigratorReconcile', function()
		M.reconcile()
	end, { desc = 'Run migration reconciliation' })
	
	vim.api.nvim_create_user_command('MigratorExport', function(opts)
		M.export_journal(opts.args ~= '' and opts.args or nil)
	end, { 
		desc = 'Export migration journal to file',
		nargs = '?',
		complete = 'file'
	})
end

return M

