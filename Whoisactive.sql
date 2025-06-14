--execute who is active with blockers query and exection plan

EXEC sp_WhoIsActive
    @find_block_leaders = 1,
	@get_plans = 1
    @sort_order = '[blocked_session_count] DESC'