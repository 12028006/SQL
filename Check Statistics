SELECT 
    s.name AS SchemaName,
    o.name AS TableName,
    stats.name AS StatsName,
    stats.auto_created,
    stats.user_created,
    stats.no_recompute,
    stats.has_filter,
    stats.filter_definition,
    sp.last_updated,
    sp.rows,
    sp.rows_sampled,
    sp.modification_counter
FROM sys.stats AS stats
JOIN sys.objects AS o ON stats.object_id = o.object_id
JOIN sys.schemas AS s ON o.schema_id = s.schema_id
OUTER APPLY sys.dm_db_stats_properties(stats.object_id, stats.stats_id) AS sp
WHERE o.type = 'U' -- Only user tables
ORDER BY sp.last_updated DESC;
