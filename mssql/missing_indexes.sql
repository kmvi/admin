use dbname
go

select top 25 [recommended index] =
	'-- create index [missing_index_' + object_name(mid.object_id) + '_' +
	cast(mid.index_handle as nvarchar) + '] on ' +
	mid.statement + ' (' + isnull(mid.equality_columns,'') +
	', ' + isnull(mid.inequality_columns,'') + ');',
	[compilation count] = migs.unique_compiles,
	[user seeks] = migs.user_seeks,
	[user scans] = migs.user_scans,
	[avg cost] = cast(migs.avg_total_user_cost as int),
	[avg user impact] = cast(migs.avg_user_impact as int)
from sys.dm_db_missing_index_groups mig
	join sys.dm_db_missing_index_group_stats migs
		on migs.group_handle = mig.index_group_handle
	join sys.dm_db_missing_index_details mid
		on mig.index_handle = mid.index_handle
			and mid.database_id = db_id()
order by 3 desc, 5 desc, 6 desc