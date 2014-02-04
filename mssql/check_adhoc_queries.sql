use [dbname]
go

select usecounts, objtype into #0001
from sys.dm_exec_cached_plans
where (usecounts > 1) and (objtype <> 'View')
and (objtype <> 'Proc') and (objtype <> 'Adhoc')
go

select usecounts, objtype into #0002
from sys.dm_exec_cached_plans
where (usecounts > 1) and (objtype <> 'View')
and (objtype <> 'Proc') and (objtype <> 'Prepared')
go

select count(*) as prepared_count from #0001
go

select count(*) as adhoc_count from #0002
go

drop table #0001
drop table #0002

-- if adhoc_count > 10000 and adhoc_count > prepared_cont then consider to enable "Optimize of Adhoc Workloads" option