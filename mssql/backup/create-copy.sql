DECLARE @dbname nvarchar(100);
DECLARE @dbfile nvarchar(100);
DECLARE @logfile nvarchar(100);
DECLARE @bkpname nvarchar(100);

SELECT @dbname = N'db_' + CONVERT(NCHAR(8), GETDATE(), 112);

IF OBJECT_ID(@dbname, N'U') IS NULL
BEGIN
	SELECT @bkpname = N'\\srv\backup\db_copy_' + CONVERT(NCHAR(8), GETDATE(), 112) + N'.bak';

	BACKUP DATABASE [db]
	TO DISK =  @bkpname
	WITH NOFORMAT, NOINIT,
	NAME = N'db',
	SKIP, NOREWIND, NOUNLOAD, STATS = 10;

	SELECT @dbfile = N'd:\mssql\' + @dbname + N'.mdf';
	SELECT @logfile = N'd:\mssql\' + @dbname + N'_log.ldf';

	RESTORE DATABASE @dbname
	FROM  DISK = @bkpname
	WITH MOVE N'db' TO @dbfile,
	MOVE N'db_log' TO @logfile,
	NOUNLOAD, STATS = 10;
END