DROP TABLE IF EXISTS [metadata].[MirroredWWItoDW]

GO

CREATE TABLE [metadata].[MirroredWWItoDW](
	[pipelinename] [varchar](100) NOT NULL,
	[sourceschema] [varchar](50) NOT NULL,
	[sourceobject] [varchar](50) NOT NULL,
	[sourcestartdate] [datetime2](6) NULL,
	[sourceenddate] [datetime2](6) NULL,
	[sinkschema] [varchar](100) NULL,
	[sinktable] [varchar](100) NULL,
	[loadtype] [varchar](15) NOT NULL,
	[storedprocschema] [varchar](50) NULL,
	[storedprocname] [varchar](50) NULL,
	[skipload] [bit] NOT NULL,
	[batchloaddatetime] [datetime2](6) NULL,
	[loadstatus] [varchar](15) NULL,
	[rowsupdated] [int] NULL,
	[rowsinserted] [int] NULL,
	[sinkmaxdatetime] [datetime2](6) NULL,
	[pipelinestarttime] [datetime2](6) NULL,
	[pipelineendtime] [datetime2](6) NULL
) 

GO

TRUNCATE TABLE metadata.MirroredWWItoDW


INSERT INTO [metadata].[MirroredWWItoDW]
([pipelinename], [sourceschema], [sourceobject], [sinkschema], [sinktable], [loadtype], [storedprocschema], [storedprocname], [skipload],[sourcestartdate],[sourceenddate])
SELECT
'orchestrator Load WWI to DW','wwiViews','CustomerDeliveredTo','starschema','Customer','full',NULL,NULL,0,'2013-01-01 00:00:00',NULL
UNION SELECT
'orchestrator Load WWI to DW','wwiViews','InvoicedSales','starschema','InvoicedSales','incremental','starschema','IncrLoadInvoicedSales',0,'2013-01-01 00:00:00','2013-01-08 00:00:00'
UNION SELECT
'orchestrator Load WWI to DW','wwiViews','Products','starschema','Products','full',NULL,NULL,0,'2013-01-01 00:00:00',NULL
UNION SELECT
'orchestrator Load WWI to DW','wwiViews','Salesperson','starschema','Salesperson','full',NULL,NULL,0,'2013-01-01 00:00:00',NULL
UNION SELECT
'orchestrator Load WWI to DW','wwiViews','SalesOrders','starschema','SalesOrders','incremental','starschema','IncrLoadSalesOrders',0,'2013-01-01 00:00:00','2013-01-08 00:00:00'

