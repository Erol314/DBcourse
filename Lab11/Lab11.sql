IF EXISTS (SELECT * FROM master.dbo.sysdevices WHERE name='device01')
EXEC sp_dropdevice 'device01' , 'delfile'
GO

exec sp_addumpdevice 'DISK', 'device01', 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Backup\exercitiul1.bak'
GO

Backup database University
to device01 with format, Name = N'University-Full Database backup'
GO
--(2)
IF EXISTS (SELECT * FROM master.dbo.sysdevices WHERE name='device02')
EXEC sp_dropdevice 'device02' , 'delfile';

EXEC sp_addumpdevice 'DISK', 'device02','C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Backup\exercitiul2.bak'
GO 
BACKUP DATABASE University
TO device02 WITH FORMAT,
NAME = N'universitatea - Differential Database Backup'
GO
--(3)
IF EXISTS (SELECT * FROM master.dbo.sysdevices WHERE name='backup_Log')
EXEC sp_dropdevice 'backup_Log' , 'delfile';

GO
EXEC sp_addumpdevice 'DISK', 'backup_Log', 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Backup\exercitiul3.bak'

GO
BACKUP LOG University TO backup_Log
GO
--(4)
IF EXISTS (SELECT * FROM master.sys.databases WHERE name='universitatea_lab11')
DROP DATABASE universitatea_lab11;
GO
Restore database universitatea_lab11
from disk = 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Backup\exercitiul1.bak'
WITH MOVE 'University' TO 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Backup\data.mdf',
MOVE 'University_log' TO 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Backup\log.ldf',
NORECOVERY
GO
RESTORE LOG universitatea_lab11
FROM DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Backup\exercitiul3.bak'
WITH NORECOVERY
GO
RESTORE DATABASE universitatea_lab11
FROM DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Backup\exercitiul2.bak'
WITH 
NORECOVERY
GO