create table test1 (riskdate date, policy varchar(256), legname varchar(256));

insert into Test1 VALUES ('20160731','P1','ITS ALL ABOUT P1');
insert into Test1 VALUES ('20160730','P1','ITS ALL ABOUT P1');
insert into Test1 VALUES ('20160729','P1','ITS ALL ABOUT P1');
insert into Test1 VALUES ('20160728','P1','ITS ALL ABOUT P1');
insert into Test1 VALUES ('20160727','P1','ITS ALL ABOUT P1');
insert into Test1 VALUES ('20160726','P1','ITS ALL ABOUT P1');
insert into Test1 VALUES ('20160725','P1','ITS ALL ABOUT P1');
insert into Test1 VALUES ('20160724','P1','ITS ALL ABOUT P1');
insert into Test1 VALUES ('20160723','P1','ITS ALL ABOUT P1');
insert into Test1 VALUES ('20160722','P1','ITS ALL ABOUT P1');

insert into Test1 VALUES ('20160731','P2','ITS ALL ABOUT P2');
insert into Test1 VALUES ('20160730','P2','ITS ALL ABOUT P2');
insert into Test1 VALUES ('20160729','P2','ITS ALL ABOUT P2');
insert into Test1 VALUES ('20160728','P2','ITS ALL ABOUT P2');
insert into Test1 VALUES ('20160727','P2','ITS ALL ABOUT P2');
insert into Test1 VALUES ('20160726','P2','ITS ALL ABOUT P2');
insert into Test1 VALUES ('20160725','P2','ITS ALL ABOUT P2');
insert into Test1 VALUES ('20160724','P2','ITS ALL ABOUT P2');
insert into Test1 VALUES ('20160723','P2','ITS ALL ABOUT P2');
insert into Test1 VALUES ('20160722','P2','ITS ALL ABOUT P2');

insert into Test1 VALUES ('20160731','P3','ITS ALL ABOUT');
insert into Test1 VALUES ('20160730','P3','ITS ALL ABOUT');
insert into Test1 VALUES ('20160729','P3','ITS ALL ABOUT');
insert into Test1 VALUES ('20160728','P3','ITS ALL ABOUT');
insert into Test1 VALUES ('20160727','P3','ITS ALL ABOUT');
insert into Test1 VALUES ('20160726','P3','ITS ALL ABOUT');
insert into Test1 VALUES ('20160725','P3','ITS ALL ABOUT');
insert into Test1 VALUES ('20160724','P3','ITS ALL ABOUT');
insert into Test1 VALUES ('20160723','P3','ITS ALL ABOUT');
insert into Test1 VALUES ('20160722','P3','ITS ALL ABOUT');

insert into Test1 VALUES ('20160731','P4','ITS ALL ABOUT');
insert into Test1 VALUES ('20160730','P4','ITS ALL ABOUT');
insert into Test1 VALUES ('20160729','P4','ITS ALL ABOUT');
insert into Test1 VALUES ('20160728','P4','ITS ALL ABOUT');
insert into Test1 VALUES ('20160727','P4','ITS ALL ABOUT');
insert into Test1 VALUES ('20160726','P4','ITS ALL ABOUT');
insert into Test1 VALUES ('20160725','P1','ITS ALL ABOUT');
insert into Test1 VALUES ('20160724','P2','ITS ALL ABOUT');
insert into Test1 VALUES ('20160723','P3','ITS ALL ABOUT');
insert into Test1 VALUES ('20160722','P4','ITS ALL ABOUT');

SELECT * FROM TEST1 where riskdate <= '20160726'

select * from test1 where legname <= 'p1'


-- Test by Policy /Leg Name --

ALTER DATABASE TEST ADD FILEGROUP P1;
ALTER DATABASE TEST ADD FILEGROUP P2;
ALTER DATABASE TEST ADD FILEGROUP P3;

ALTER DATABASE TEST ADD FILE (NAME='P1FILE', FILENAME='C:\ANTANY\SQL11Data\P1') TO FILEGROUP P1
ALTER DATABASE TEST ADD FILE (NAME='P2FILE', FILENAME='C:\ANTANY\SQL11Data\P2') TO FILEGROUP P2
ALTER DATABASE TEST ADD FILE (NAME='P3FILE', FILENAME='C:\ANTANY\SQL11Data\P3') TO FILEGROUP P3


CREATE PARTITION FUNCTION [PartitionByLeg](varchar(256)) AS RANGE LEFT FOR VALUES ('p1','p2');

CREATE PARTITION SCHEME [PartitionByLeg] AS PARTITION [PartitionByLeg] TO ([p1], [p2],[P3]);

CREATE CLUSTERED INDEX [idx_Test1] ON TEST1 (RISKDATE,POLICY) ON [PartitionByLeg](LEGNAME);

CREATE CLUSTERED INDEX [idx_Test1] ON TEST1 (RISKDATE,POLICY) WITH (DROP_EXISTING = ON) ON [PartitionByLeg](policy)

--- drop

CREATE CLUSTERED INDEX [idx_Test1] ON TEST1 (RISKDATE,POLICY) WITH (DROP_EXISTING = ON) ON [PRIMARY]

DROP INDEX [idx_Test1] ON TEST1;

DROP PARTITION SCHEME [PartitionByLeg];

DROP PARTITION FUNCTION [PartitionByLeg]

ALTER DATABASE TEST REMOVE FILE P1FILE;
ALTER DATABASE TEST REMOVE FILE P2FILE;
ALTER DATABASE TEST REMOVE FILE P3FILE;

ALTER DATABASE TEST REMOVE FILEGROUP P1;
ALTER DATABASE TEST REMOVE FILEGROUP P2;
ALTER DATABASE TEST REMOVE FILEGROUP P3;
-- END OF POLICY -- 

-- SET UP BY RISK DATE


ALTER DATABASE TEST ADD FILEGROUP R1;
ALTER DATABASE TEST ADD FILEGROUP R2;
ALTER DATABASE TEST ADD FILEGROUP R3;



ALTER DATABASE TEST ADD FILE (NAME=r1file, filename='c:\antany\SQL11Data\r1.ndf') to filegroup r1;
ALTER DATABASE TEST ADD FILE (NAME=r2file, filename='c:\antany\SQL11Data\r2.ndf') to filegroup r2;
ALTER DATABASE TEST ADD FILE (NAME=r3file, filename='c:\antany\SQL11Data\r3.ndf') to filegroup r3;

create partition function partitionbydate(date) as range left for values ('2016-07-23','2016-07-26');

create partition scheme partitionbydate as partition partitionbydate to (r1,r2,r3);

CREATE CLUSTERED INDEX [idx_Test1] ON TEST1 (RISKDATE,POLICY)  ON partitionbydate (riskdate)

-- change to schema --

ALTER DATABASE TEST ADD FILEGROUP R4;
ALTER DATABASE TEST ADD FILE (NAME=r4file, filename='c:\antany\SQL11Data\r4.ndf') to filegroup r4;
alter partition scheme partitionbydate next used r4
ALTER PARTITION FUNCTION partitionbydate() split range ('2016-07-29');

ALTER DATABASE TEST ADD FILEGROUP R5;
ALTER DATABASE TEST ADD FILE (NAME=r5file, filename='c:\antany\SQL11Data\r5.ndf') to filegroup r5;
alter partition scheme partitionbydate next used r5
ALTER PARTITION FUNCTION partitionbydate() split range ('2016-07-31');

ALTER DATABASE TEST ADD FILEGROUP R6;
ALTER DATABASE TEST ADD FILE (NAME=r6file, filename='c:\antany\SQL11Data\r6.ndf') to filegroup r6;
alter partition scheme partitionbydate next used r6
ALTER PARTITION FUNCTION partitionbydate() split range ('2016-08-02');

ALTER PARTITION FUNCTION partitionbyDate() merge range('2016-07-26');

alter partition scheme partitionbydate next used r2
ALTER PARTITION FUNCTION partitionbyDate() split range('2016-07-26');

DBCC SHRINKFILE (N'R1file' , 1)

DBCC SHRINKFILE (N'R2' , 1)

DBCC SHRINKFILE (N'R3' , 1)

DBCC SHRINKFILE (N'R4' , 1)


select * fr

update statistics TEST1;

CREATE CLUSTERED INDEX [idx_Test1] ON TEST1 (RISKDATE,POLICY) WITH (DROP_EXISTING = ON) ON partitionbydate (riskdate)
--


ALTER DATABASE Test
    ADD FILEGROUP D1;

ALTER DATABASE Test
    ADD FILEGROUP D2;
	
ALTER DATABASE Test
    ADD FILEGROUP D3;

ALTER DATABASE Test
    ADD FILEGROUP D4;

ALTER DATABASE Test
    ADD FILEGROUP D5;
	
ALTER DATABASE Test
    ADD FILEGROUP D6;

ALTER DATABASE Test
    ADD FILEGROUP D7;

ALTER DATABASE Test
    ADD FILEGROUP D8;
	
ALTER DATABASE Test
    ADD FILEGROUP D9;

ALTER DATABASE Test
    ADD FILEGROUP D10;

--

ALTER DATABASE tEST
ADD FILE (
NAME = [D1Part],
FILENAME = 'c:\antany\SQL11Data\Test1.ndf',
SIZE = 4 MB,
MAXSIZE = UNLIMITED,
FILEGROWTH = 1 MB
) TO FILEGROUP [D1];

ALTER DATABASE tEST
ADD FILE (
NAME = [D2Part],
FILENAME = 'c:\antany\SQL11Data\Temp1.ndf',
SIZE = 4 MB,
MAXSIZE = UNLIMITED,
FILEGROWTH = 1 MB
) TO FILEGROUP [D2];



--

CREATE PARTITION FUNCTION [PartitionByDate](Date) AS RANGE LEFT FOR VALUES ('20160726');

CREATE PARTITION SCHEME [PartitionByDate] AS PARTITION [PartitionByDate] TO ([D1], [PRIMARY]);

CREATE CLUSTERED INDEX [idx_Test1] ON Test1
(
    [RiskDate] ASC,
    [Policy] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF,DROP_EXISTING = ON, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF,ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PartitionByDate]([RiskDate]);


CREATE CLUSTERED INDEX [idx_Test1] ON TEST1 (RISKDATE,POLICY) WITH (DROP_EXISTING = ON) ON [D2];


drop INDEX [idx_Test1] ON Test1;

drop PARTITION FUNCTION  [PartitionByDate];

alter database test remove file [D1Part];

alter database test remove filegroup [d1];

select * from sys.partitions

select * from sys.destination_data_spaces 


select * from sys.objects o where o.name like 'PRIMARY'

 SELECT
     SCHEMA_NAME(t.schema_id) AS SchemaName
    ,OBJECT_NAME(i.object_id) AS ObjectName
    ,p.partition_number AS PartitionNumber
    ,fg.name AS Filegroup_Name
    ,p.rows AS 'Rows'
    ,au.total_pages AS 'TotalDataPages'
    ,CASE boundary_value_on_right
        WHEN 1 THEN 'less than'
        ELSE 'less than or equal to'
     END AS 'Comparison'
    ,value AS 'ComparisonValue'
    ,p.data_compression_desc AS 'DataCompression'
    ,p.partition_id
FROM sys.partitions p
    JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id
    JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_id
    JOIN sys.partition_functions f ON f.function_id = ps.function_id
    LEFT JOIN sys.partition_range_values rv ON f.function_id = rv.function_id AND p.partition_number = rv.boundary_id
    JOIN sys.destination_data_spaces dds ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number
    JOIN sys.filegroups fg ON dds.data_space_id = fg.data_space_id
    JOIN (SELECT container_id, sum(total_pages) as total_pages
            FROM sys.allocation_units
            GROUP BY container_id) AS au ON au.container_id = p.partition_id 
    JOIN sys.tables t ON p.object_id = t.object_id
WHERE i.index_id < 2
ORDER BY ObjectName,p.partition_number;
GO

SELECT O.Name as TableName, I.Name as IndexName, I.Type, I.type_desc as IndexType, ps.name as PartitionSchema
 FROM sys.objects O
 INNER JOIN sys.partitions p on P.object_id = O.object_id
 INNER JOIN sys.indexes i on p.object_id = i.object_id and p.index_id = i.index_id
 INNER JOIN sys.data_spaces ds on i.data_space_id = ds.data_space_id
 INNER JOIN sys.partition_schemes ps on ds.data_space_id = ps.data_space_id
 WHERE p.partition_number = 1


 SELECT OBJECT_NAME(i.[object_id]) AS [ObjectName]
    ,i.[index_id] AS [IndexID]
    ,i.[name] AS [IndexName]
    ,i.[type_desc] AS [IndexType]
    ,i.[data_space_id] AS [DatabaseSpaceID]
    ,f.[name] AS [FileGroup]
    ,d.[physical_name] AS [DatabaseFileName]
FROM [sys].[indexes] i
INNER JOIN [sys].[filegroups] f
    ON f.[data_space_id] = i.[data_space_id]
INNER JOIN [sys].[database_files] d
    ON f.[data_space_id] = d.[data_space_id]
INNER JOIN [sys].[data_spaces] s
    ON f.[data_space_id] = s.[data_space_id]
WHERE OBJECTPROPERTY(i.[object_id], 'IsUserTable') = 1
ORDER BY OBJECT_NAME(i.[object_id])
    ,f.[name]
    ,i.[data_space_id]
GO

 select * from sys.indexes

 select * from sys.index_columns where object_id = 245575913

 select * from sys.co

 dbcc SHRINKFILE('R3FILE');

SELECT
     o.name
    ,o.object_id
    ,p.index_id
    ,p.partition_id
    ,p.partition_number
    ,p.rows
FROM sys.objects o
    JOIN sys.partitions p ON o.object_id = p.object_id
WHERE o.name IN ('Test1')
ORDER BY o.name,p.partition_number;
GO


exec sp_ta

select * from sy