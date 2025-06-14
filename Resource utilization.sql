-- This script retrieves resource utilization metrics from Azure SQL Database and SQL Server.
-- It includes queries to monitor CPU, memory, I/O, and wait statistics. 
SELECT 
    end_time,
    avg_data_io_percent,
    avg_log_write_percent,
    avg_cpu_percent,
    avg_memory_usage_percent
FROM sys.dm_db_resource_stats
ORDER BY end_time DESC;
-- Note: The sys.dm_db_resource_stats view provides real-time resource utilization metrics.
-- The data is collected every 5 minutes and is retained for approximately one hour in Azure SQL Database.



SELECT 
    total_request_count,
    total_cpu_limit_violation_count,
    total_queue_duration_ms,
    total_cpu_usage_ms,
    total_log_io_wait_time_ms,
    total_data_io_wait_time_ms
FROM sys.dm_db_resource_governor_workload_groups_stats;
-- Note: The sys.dm_db_resource_governor_workload_groups_stats view provides statistics for workload groups in SQL Server Resource Governor.
-- It includes total request counts, CPU limit violations, queue durations, CPU usage, and I/O wait times.




SELECT 
    wait_type, 
    wait_time_ms, 
    waiting_tasks_count
FROM sys.dm_db_wait_stats
WHERE wait_type IN ('PAGEIOLATCH_SH', 'PAGEIOLATCH_EX', 'WRITELOG')
ORDER BY wait_time_ms DESC;
-- Note: The sys.dm_db_wait_stats view provides information about wait statistics in SQL Server.
-- The query filters for specific wait types related to I/O and log operations, which can indicate resource contention or performance issues.



SELECT 

    DB_NAME(database_id) AS [Database],

    file_id,

    io_stall_read_ms, num_of_reads,

    io_stall_write_ms, num_of_writes,

    CAST(io_stall_read_ms AS FLOAT)/NULLIF(num_of_reads, 0) AS avg_read_latency_ms,

    CAST(io_stall_write_ms AS FLOAT)/NULLIF(num_of_writes, 0) AS avg_write_latency_ms

FROM sys.dm_io_virtual_file_stats(NULL, NULL);

-- Note: The sys.dm_io_virtual_file_stats view provides I/O statistics for database files.
-- The query retrieves read and write latency metrics, which can help identify performance bottlenecks related to disk I/O.
-- This script retrieves resource utilization metrics from SQL Server.
-- It includes queries to monitor CPU, memory, I/O, and wait statistics
-- for performance tuning and optimization.
-- This script retrieves resource utilization metrics from SQL Server.



SELECT
    s.session_id,
    r.status,
    r.command,
    r.cpu_time,
    r.total_elapsed_time,
    t.text AS sql_text,
    tsu.internal_objects_alloc_page_count,
    tsu.user_objects_alloc_page_count
FROM sys.dm_exec_requests r
JOIN sys.dm_exec_sessions s ON r.session_id = s.session_id
JOIN sys.dm_exec_sql_text(r.sql_handle) t ON r.sql_handle = t.sql_handle
JOIN sys.dm_db_task_space_usage tsu ON r.task_address = tsu.task_address
ORDER BY tsu.internal_objects_alloc_page_count DESC;
-- Note: The sys.dm_exec_requests view provides information about currently executing requests.
-- The sys.dm_exec_sessions view provides information about active sessions.
-- The sys.dm_exec_sql_text function retrieves the SQL text for a given request.
-- The sys.dm_db_task_space_usage view provides information about space usage for tasks.
-- This script retrieves resource utilization metrics from SQL Server.
-- It includes queries to monitor CPU, memory, I/O, and wait statistics
-- for performance tuning and optimization.
-- This script retrieves resource utilization metrics from SQL Server.



-- This query lists the top 20 queries that reference tempdb and have the highest logical writes.
-- It shows how often each query ran, their logical reads/writes, and execution times.
-- The actual SQL text and execution plan for each query are included.
-- This helps identify queries that heavily use tempdb, useful for troubleshooting performance.
SELECT TOP 20 
    qs.execution_count,
    qs.total_logical_writes,
    qs.total_logical_reads,
    qs.creation_time,
    qs.last_execution_time,
    SUBSTRING(qt.text, (qs.statement_start_offset / 2) + 1,
        ((CASE qs.statement_end_offset
          WHEN -1 THEN DATALENGTH(qt.text)
          ELSE qs.statement_end_offset END
          - qs.statement_start_offset) / 2) + 1) AS query_text,
    qp.query_plan
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) qt
CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) qp
WHERE qt.text LIKE '%tempdb%'
ORDER BY qs.total_logical_writes DESC;
-- Note: The sys.dm_exec_query_stats view provides execution statistics for cached query plans.
-- The sys.dm_exec_sql_text function retrieves the SQL text for a given query.
-- The sys.dm_exec_query_plan function retrieves the query execution plan for a given query.

