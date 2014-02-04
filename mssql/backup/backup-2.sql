DECLARE @FileName NVARCHAR(256);

IF DATEPART(WEEKDAY, GETDATE()) = 1
BEGIN
   SELECT @FileName = N'\\srv\backup\db_' + CONVERT(NCHAR(8), GETDATE(), 112) + N'_base.bak';
   BACKUP DATABASE [db]
   TO  DISK = @FileName
    WITH NOFORMAT, NOINIT,
    NAME = N'db - Full',
    SKIP, NOREWIND, NOUNLOAD,  STATS = 10
END
ELSE
BEGIN
    SELECT @FileName = N'\\srv\backup\db_' + CONVERT(NCHAR(8), GETDATE(), 112) + N'_diff.bak';
    BACKUP DATABASE [db]
    TO  DISK = @FileName
    WITH DIFFERENTIAL, NOFORMAT, NOINIT,
    NAME = N'db - Differential',
    SKIP, NOREWIND, NOUNLOAD,  STATS = 10
END