CREATE DATABASE FactoryDB1
USE FactoryDB1

-- ==========================================
-- СТРУКТУРА ИЗ enhanced_database_structure.sql
-- ==========================================

-- Дополнительные справочники
CREATE TABLE [dbo].[Region](
    [ID] [int] IDENTITY(1,1) NOT NULL,
    [Name] [nvarchar](100) NOT NULL,
    [Code] [varchar](10) NOT NULL,
    [DeliveryMultiplier] [decimal](3,2) DEFAULT 1.0,
    [IsActive] [bit] DEFAULT 1,
    CONSTRAINT [PK_Region] PRIMARY KEY ([ID])
);

CREATE TABLE [dbo].[City](
    [ID] [int] IDENTITY(1,1) NOT NULL,
    [Name] [nvarchar](100) NOT NULL,
    [RegionID] [int] NOT NULL,
    [PostalCode] [varchar](6),
    [Latitude] [decimal](9,6),
    [Longitude] [decimal](9,6),
    CONSTRAINT [PK_City] PRIMARY KEY ([ID]),
    CONSTRAINT [FK_City_Region] FOREIGN KEY([RegionID]) REFERENCES [dbo].[Region]([ID])
);

-- Расширенная система пользователей
CREATE TABLE [dbo].[UserRole](
    [ID] [int] IDENTITY(1,1) NOT NULL,
    [RoleName] [nvarchar](50) NOT NULL,
    [Description] [nvarchar](255),
    [Permissions] [nvarchar](max),
    CONSTRAINT [PK_UserRole] PRIMARY KEY ([ID])
);

CREATE TABLE [dbo].[User](
    [ID] [int] IDENTITY(1,1) NOT NULL,
    [Login] [nvarchar](50) NOT NULL,
    [PasswordHash] [varchar](255) NOT NULL,
    [Email] [nvarchar](255),
    [FirstName] [nvarchar](50),
    [LastName] [nvarchar](50),
    [MiddleName] [nvarchar](50),
    [Phone] [nvarchar](20),
    [IsActive] [bit] DEFAULT 1,
    [CreatedAt] [datetime] DEFAULT GETDATE(),
    [LastLoginAt] [datetime],
    [FailedLoginCount] [int] DEFAULT 0,
    [UserRoleID] [int],
    CONSTRAINT [PK_User] PRIMARY KEY ([ID]),
    CONSTRAINT [FK_User_UserRole] FOREIGN KEY([UserRoleID]) REFERENCES [dbo].[UserRole]([ID])
);

-- Расширенная система сотрудников
CREATE TABLE [dbo].[Department](
    [ID] [int] IDENTITY(1,1) NOT NULL,
    [Name] [nvarchar](100) NOT NULL,
    [Description] [nvarchar](255),
    [HeadEmployeeID] [int],
    [IsActive] [bit] DEFAULT 1,
    CONSTRAINT [PK_Department] PRIMARY KEY ([ID])
);

CREATE TABLE [dbo].[Position](
    [ID] [int] IDENTITY(1,1) NOT NULL,
    [Title] [nvarchar](100) NOT NULL,
    [Description] [nvarchar](255),
    [BaseSalary] [decimal](10,2),
    [RequiredExperience] [int],
    [IsActive] [bit] DEFAULT 1,
    CONSTRAINT [PK_Position] PRIMARY KEY ([ID])
);

CREATE TABLE [dbo].[Employee](
    [ID] [int] IDENTITY(1,1) NOT NULL,
    [PersonalNumber] [varchar](20) NOT NULL,
    [FirstName] [nvarchar](50) NOT NULL,
    [LastName] [nvarchar](50) NOT NULL,
    [MiddleName] [nvarchar](50),
    [BirthDate] [date],
    [PassportSeries] [varchar](4),
    [PassportNumber] [varchar](6),
    [PassportIssueDate] [date],
    [PassportIssuer] [nvarchar](255),
    [BankAccount] [varchar](20),
    [BankBIC] [varchar](9),
    [INN] [varchar](12),
    [SNILS] [varchar](14),
    [Phone] [nvarchar](20),
    [Email] [nvarchar](255),
    [Address] [nvarchar](500),
    [HireDate] [date],
    [FireDate] [date],
    [DepartmentID] [int],
    [PositionID] [int],
    [UserID] [int],
    [HasFamily] [bit],
    [HealthRestrictions] [nvarchar](max),
    [Specialization] [nvarchar](max),
    [IsActive] [bit] DEFAULT 1,
    CONSTRAINT [PK_Employee] PRIMARY KEY ([ID]),
    CONSTRAINT [FK_Employee_Department] FOREIGN KEY([DepartmentID]) REFERENCES [dbo].[Department]([ID]),
    CONSTRAINT [FK_Employee_Position] FOREIGN KEY([PositionID]) REFERENCES [dbo].[Position]([ID]),
    CONSTRAINT [FK_Employee_User] FOREIGN KEY([UserID]) REFERENCES [dbo].[User]([ID])
);

-- Система контроля доступа
CREATE TABLE [dbo].[AccessPoint](
    [ID] [int] IDENTITY(1,1) NOT NULL,
    [Name] [nvarchar](100) NOT NULL,
    [Location] [nvarchar](255),
    [Type] [nvarchar](20),
    [IsActive] [bit] DEFAULT 1,
    CONSTRAINT [PK_AccessPoint] PRIMARY KEY ([ID])
);

CREATE TABLE [dbo].[NFCCard](
    [ID] [int] IDENTITY(1,1) NOT NULL,
    [CardNumber] [varchar](20) NOT NULL,
    [EmployeeID] [int] NOT NULL,
    [IssueDate] [datetime] DEFAULT GETDATE(),
    [ExpiryDate] [datetime],
    [IsActive] [bit] DEFAULT 1,
    [IsBlocked] [bit] DEFAULT 0,
    CONSTRAINT [PK_NFCCard] PRIMARY KEY ([ID]),
    CONSTRAINT [FK_NFCCard_Employee] FOREIGN KEY([EmployeeID]) REFERENCES [dbo].[Employee]([ID])
);

CREATE TABLE [dbo].[AccessLog](
    [ID] [bigint] IDENTITY(1,1) NOT NULL,
    [EmployeeID] [int] NOT NULL,
    [AccessPointID] [int] NOT NULL,
    [AccessTime] [datetime] NOT NULL,
    [AccessType] [varchar](10),
    [IsSuccessful] [bit] DEFAULT 1,
    [CardNumber] [varchar](20),
    CONSTRAINT [PK_AccessLog] PRIMARY KEY ([ID]),
    CONSTRAINT [FK_AccessLog_Employee] FOREIGN KEY([EmployeeID]) REFERENCES [dbo].[Employee]([ID]),
    CONSTRAINT [FK_AccessLog_AccessPoint] FOREIGN KEY([AccessPointID]) REFERENCES [dbo].[AccessPoint]([ID])
);

-- Система смен и графиков
CREATE TABLE [dbo].[Shift](
    [ID] [int] IDENTITY(1,1) NOT NULL,
    [Name] [nvarchar](50) NOT NULL,
    [StartTime] [time] NOT NULL,
    [EndTime] [time] NOT NULL,
    [BreakDuration] [int] DEFAULT 60,
    [IsActive] [bit] DEFAULT 1,
    CONSTRAINT [PK_Shift] PRIMARY KEY ([ID])
);

CREATE TABLE [dbo].[WorkSchedule](
    [ID] [bigint] IDENTITY(1,1) NOT NULL,
    [EmployeeID] [int] NOT NULL,
    [WorkDate] [date] NOT NULL,
    [ShiftID] [int] NOT NULL,
    [ActualStartTime] [datetime],
    [ActualEndTime] [datetime],
    [Status] [nvarchar](20),
    [Notes] [nvarchar](255),
    CONSTRAINT [PK_WorkSchedule] PRIMARY KEY ([ID]),
    CONSTRAINT [FK_WorkSchedule_Employee] FOREIGN KEY([EmployeeID]) REFERENCES [dbo].[Employee]([ID]),
    CONSTRAINT [FK_WorkSchedule_Shift] FOREIGN KEY([ShiftID]) REFERENCES [dbo].[Shift]([ID])
);

-- Базовые таблицы (из исходной структуры)
CREATE TABLE [dbo].[AgentType](
    [ID] [int] IDENTITY(1,1) NOT NULL,
    [Title] [nvarchar](50) NOT NULL,
    [Image] [nvarchar](100) NULL,
 CONSTRAINT [PK_AgentType] PRIMARY KEY ([ID])
);

CREATE TABLE [dbo].[Agent] (
    [ID] INT IDENTITY(1,1) PRIMARY KEY,
    [FirstName] NVARCHAR(50) NOT NULL,
    [LastName] NVARCHAR(50) NOT NULL,
    [MiddleName] NVARCHAR(50) NULL,
    [Email] NVARCHAR(100) NOT NULL,
    [Phone] NVARCHAR(20) NOT NULL,
    [UserID] INT NULL,
    [CityID] INT NULL,
    [IsActive] BIT DEFAULT 1,
    [RegistrationDate] DATETIME DEFAULT GETDATE(),
    CONSTRAINT [FK_Agent_User] FOREIGN KEY ([UserID]) REFERENCES [User]([ID]),
    CONSTRAINT [FK_Agent_City] FOREIGN KEY ([CityID]) REFERENCES [City]([ID])
);

CREATE TABLE [dbo].[MaterialType](
    [ID] [int] IDENTITY(1,1) NOT NULL,
    [Title] [nvarchar](50) NOT NULL,
    [DefectedPercent] [float] NOT NULL,
 CONSTRAINT [PK_MaterialType] PRIMARY KEY ([ID])
);

CREATE TABLE [dbo].[Material](
    [ID] [int] IDENTITY(1,1) NOT NULL,
    [Title] [nvarchar](100) NOT NULL,
    [CountInPack] [int] NOT NULL,
    [Unit] [nvarchar](10) NOT NULL,
    [CountInStock] [float] NULL,
    [MinCount] [float] NOT NULL,
    [Description] [nvarchar](max) NULL,
    [Cost] [decimal](10, 2) NOT NULL,
    [Image] [nvarchar](100) NULL,
    [MaterialTypeID] [int] NOT NULL,
 CONSTRAINT [PK_Material] PRIMARY KEY ([ID]),
 CONSTRAINT [FK_Material_MaterialType] FOREIGN KEY([MaterialTypeID]) REFERENCES [dbo].[MaterialType]([ID])
);

CREATE TABLE [dbo].[ProductType](
    [ID] [int] IDENTITY(1,1) NOT NULL,
    [Title] [nvarchar](50) NOT NULL,
    [DefectedPercent] [float] NOT NULL,
 CONSTRAINT [PK_ProductType] PRIMARY KEY ([ID])
);

CREATE TABLE [dbo].[Product](
    [ID] [int] IDENTITY(1,1) NOT NULL,
    [Title] [nvarchar](100) NOT NULL,
    [ProductTypeID] [int] NULL,
    [ArticleNumber] [nvarchar](10) NOT NULL,
    [Description] [nvarchar](max) NULL,
    [Image] [nvarchar](100) NULL,
    [ProductionPersonCount] [int] NULL,
    [ProductionWorkshopNumber] [int] NULL,
    [MinCostForAgent] [decimal](10, 2) NOT NULL,
 CONSTRAINT [PK_Product] PRIMARY KEY ([ID]),
 CONSTRAINT [FK_Product_ProductType] FOREIGN KEY([ProductTypeID]) REFERENCES [dbo].[ProductType]([ID])
);

CREATE TABLE [dbo].[ProductMaterial](
    [ProductID] [int] NOT NULL,
    [MaterialID] [int] NOT NULL,
    [Count] [float] NULL,
 CONSTRAINT [PK_ProductMaterial] PRIMARY KEY ([ProductID], [MaterialID]),
 CONSTRAINT [FK_ProductMaterial_Product] FOREIGN KEY([ProductID]) REFERENCES [dbo].[Product]([ID]),
 CONSTRAINT [FK_ProductMaterial_Material] FOREIGN KEY([MaterialID]) REFERENCES [dbo].[Material]([ID])
);

CREATE TABLE [dbo].[Shop](
    [ID] [int] IDENTITY(1,1) NOT NULL,
    [Title] [nvarchar](150) NOT NULL,
    [Address] [nvarchar](300) NULL,
    [AgentID] [int] NOT NULL,
 CONSTRAINT [PK_Shop] PRIMARY KEY ([ID]),
 CONSTRAINT [FK_Shop_Agent] FOREIGN KEY([AgentID]) REFERENCES [dbo].[Agent]([ID])
);

-- Расширенная система заявок
CREATE TABLE [dbo].[OrderStatus](
    [ID] [int] IDENTITY(1,1) NOT NULL,
    [StatusName] [nvarchar](50) NOT NULL,
    [Description] [nvarchar](255),
    [SortOrder] [int],
    [Color] [varchar](7),
    CONSTRAINT [PK_OrderStatus] PRIMARY KEY ([ID])
);

CREATE TABLE [dbo].[PaymentType](
    [ID] [int] IDENTITY(1,1) NOT NULL,
    [Name] [nvarchar](50) NOT NULL,
    [Description] [nvarchar](255),
    [RequiresAdvance] [bit] DEFAULT 0,
    [AdvancePercent] [decimal](5,2),
    CONSTRAINT [PK_PaymentType] PRIMARY KEY ([ID])
);

CREATE TABLE [dbo].[Order](
    [ID] [int] IDENTITY(1,1) NOT NULL,
    [OrderNumber] [varchar](20) NOT NULL,
    [AgentID] [int] NOT NULL,
    [ManagerID] [int] NOT NULL,
    [CreateDate] [datetime] DEFAULT GETDATE(),
    [RequiredDate] [date],
    [CompletedDate] [datetime],
    [OrderStatusID] [int] NOT NULL,
    [PaymentTypeID] [int] NOT NULL,
    [TotalAmount] [decimal](15,2),
    [PaidAmount] [decimal](15,2) DEFAULT 0,
    [DiscountPercent] [decimal](5,2) DEFAULT 0,
    [DeliveryAddress] [nvarchar](500),
    [DeliveryDate] [date],
    [DeliveryCost] [decimal](10,2),
    [IsDeliveryRequired] [bit] DEFAULT 0,
    [Notes] [nvarchar](max),
    [CancelReason] [nvarchar](255),
    [CancelDate] [datetime],
    CONSTRAINT [PK_Order] PRIMARY KEY ([ID]),
    CONSTRAINT [FK_Order_Agent] FOREIGN KEY([AgentID]) REFERENCES [dbo].[Agent]([ID]),
    CONSTRAINT [FK_Order_Manager] FOREIGN KEY([ManagerID]) REFERENCES [dbo].[Employee]([ID]),
    CONSTRAINT [FK_Order_OrderStatus] FOREIGN KEY([OrderStatusID]) REFERENCES [dbo].[OrderStatus]([ID]),
    CONSTRAINT [FK_Order_PaymentType] FOREIGN KEY([PaymentTypeID]) REFERENCES [dbo].[PaymentType]([ID])
);
CREATE TABLE [dbo].[OrderItem](
    [ID] [int] IDENTITY(1,1) NULL,
    [OrderID] [int] NOT NULL,
    [ProductID] [int] NOT NULL,
    [Quantity] [int] NOT NULL,
    [UnitPrice] [decimal](10,2) NOT NULL,
    [TotalPrice] [decimal](15,2) NOT NULL,
    [ProductionStartDate] [datetime],
    [ProductionEndDate] [datetime],
    [QualityCheckDate] [datetime],
    [QualityStatus] [nvarchar](20),
    [QualityNotes] [nvarchar](255),
    CONSTRAINT [PK_OrderItem] PRIMARY KEY ([ID]),
    CONSTRAINT [FK_OrderItem_Order] FOREIGN KEY([OrderID]) REFERENCES [dbo].[Order]([ID]),
    CONSTRAINT [FK_OrderItem_Product] FOREIGN KEY([ProductID]) REFERENCES [dbo].[Product]([ID])
);
ALTER TABLE [dbo].[OrderItem] ALTER COLUMN [ProductID] INT NULL;

-- Система производства
CREATE TABLE [dbo].[Workshop](
    [ID] [int] IDENTITY(1,1) NOT NULL,
    [Number] [int] NOT NULL,
    [Name] [nvarchar](100),
    [Description] [nvarchar](255),
    [MaxCapacity] [int],
    [IsActive] [bit] DEFAULT 1,
    CONSTRAINT [PK_Workshop] PRIMARY KEY ([ID])
);

CREATE TABLE [dbo].[Equipment](
    [ID] [int] IDENTITY(1,1) NOT NULL,
    [Name] [nvarchar](100) NOT NULL,
    [SerialNumber] [varchar](50),
    [WorkshopID] [int] NOT NULL,
    [InstallDate] [date],
    [LastMaintenanceDate] [date],
    [NextMaintenanceDate] [date],
    [Status] [nvarchar](20),
    [RequiredSpecialization] [nvarchar](max),
    CONSTRAINT [PK_Equipment] PRIMARY KEY ([ID]),
    CONSTRAINT [FK_Equipment_Workshop] FOREIGN KEY([WorkshopID]) REFERENCES [dbo].[Workshop]([ID])
);

CREATE TABLE [dbo].[ProductionTask](
    [ID] [int] IDENTITY(1,1) NOT NULL,
    [OrderItemID] [int] NOT NULL,
    [WorkshopID] [int] NOT NULL,
    [ResponsibleEmployeeID] [int] NOT NULL,
    [PlannedStartDate] [datetime] NOT NULL,
    [PlannedEndDate] [datetime] NOT NULL,
    [ActualStartDate] [datetime],
    [ActualEndDate] [datetime],
    [Status] [nvarchar](20),
    [Priority] [int] DEFAULT 5,
    [Notes] [nvarchar](max),
    CONSTRAINT [PK_ProductionTask] PRIMARY KEY ([ID]),
    CONSTRAINT [FK_ProductionTask_OrderItem] FOREIGN KEY([OrderItemID]) REFERENCES [dbo].[OrderItem]([ID]),
    CONSTRAINT [FK_ProductionTask_Workshop] FOREIGN KEY([WorkshopID]) REFERENCES [dbo].[Workshop]([ID]),
    CONSTRAINT [FK_ProductionTask_Employee] FOREIGN KEY([ResponsibleEmployeeID]) REFERENCES [dbo].[Employee]([ID])
);
ALTER TABLE [dbo].[ProductionTask] ALTER COLUMN [OrderItemID] INT NULL;
ALTER TABLE [dbo].[ProductionTask] ALTER COLUMN [WorkshopID] INT NULL;
ALTER TABLE [dbo].[ProductionTask] ALTER COLUMN [ResponsibleEmployeeID] INT NULL;

-- Система складского учета
CREATE TABLE [dbo].[Warehouse](
    [ID] [int] IDENTITY(1,1) NOT NULL,
    [Name] [nvarchar](100) NOT NULL,
    [Address] [nvarchar](255),
    [ResponsibleEmployeeID] [int],
    [IsActive] [bit] DEFAULT 1,
    CONSTRAINT [PK_Warehouse] PRIMARY KEY ([ID]),
    CONSTRAINT [FK_Warehouse_Employee] FOREIGN KEY([ResponsibleEmployeeID]) REFERENCES [dbo].[Employee]([ID])
);

CREATE TABLE [dbo].[WarehouseZone](
    [ID] [int] IDENTITY(1,1) NOT NULL,
    [WarehouseID] [int] NOT NULL,
    [ZoneName] [nvarchar](50) NOT NULL,
    [Temperature] [decimal](4,1),
    [Humidity] [decimal](5,2),
    [IsClimateControlled] [bit] DEFAULT 0,
    CONSTRAINT [PK_WarehouseZone] PRIMARY KEY ([ID]),
    CONSTRAINT [FK_WarehouseZone_Warehouse] FOREIGN KEY([WarehouseID]) REFERENCES [dbo].[Warehouse]([ID])
);

CREATE TABLE [dbo].[MaterialLocation](
    [ID] [int] IDENTITY(1,1) NOT NULL,
    [MaterialID] [int] NOT NULL,
    [WarehouseZoneID] [int] NOT NULL,
    [Quantity] [decimal](10,3) NOT NULL,
    [ReservedQuantity] [decimal](10,3) DEFAULT 0,
    [LastUpdateDate] [datetime] DEFAULT GETDATE(),
    CONSTRAINT [PK_MaterialLocation] PRIMARY KEY ([ID]),
    CONSTRAINT [FK_MaterialLocation_Material] FOREIGN KEY([MaterialID]) REFERENCES [dbo].[Material]([ID]),
    CONSTRAINT [FK_MaterialLocation_WarehouseZone] FOREIGN KEY([WarehouseZoneID]) REFERENCES [dbo].[WarehouseZone]([ID])
);

-- Дополнительные таблицы истории и логирования
CREATE TABLE [dbo].[SystemLog](
    [ID] [bigint] IDENTITY(1,1) NOT NULL,
    [LogDate] [datetime] DEFAULT GETDATE(),
    [LogLevel] [varchar](10),
    [UserID] [int],
    [Action] [nvarchar](100),
    [TableName] [nvarchar](50),
    [RecordID] [int],
    [OldValues] [nvarchar](max),
    [NewValues] [nvarchar](max),
    [IPAddress] [varchar](45),
    [UserAgent] [nvarchar](255),
    CONSTRAINT [PK_SystemLog] PRIMARY KEY ([ID]),
    CONSTRAINT [FK_SystemLog_User] FOREIGN KEY([UserID]) REFERENCES [dbo].[User]([ID])
);

CREATE TABLE [dbo].[NotificationTemplate](
    [ID] [int] IDENTITY(1,1) NOT NULL,
    [Name] [nvarchar](100) NOT NULL,
    [Subject] [nvarchar](255),
    [Body] [nvarchar](max),
    [Type] [varchar](20),
    [IsActive] [bit] DEFAULT 1,
    CONSTRAINT [PK_NotificationTemplate] PRIMARY KEY ([ID])
);

CREATE TABLE [dbo].[Notification](
    [ID] [bigint] IDENTITY(1,1) NOT NULL,
    [TemplateID] [int] NOT NULL,
    [RecipientID] [int] NOT NULL,
    [Subject] [nvarchar](255),
    [Body] [nvarchar](max),
    [Type] [varchar](20),
    [Status] [varchar](20),
    [CreateDate] [datetime] DEFAULT GETDATE(),
    [SendDate] [datetime],
    [ReadDate] [datetime],
    [ErrorMessage] [nvarchar](255),
    CONSTRAINT [PK_Notification] PRIMARY KEY ([ID]),
    CONSTRAINT [FK_Notification_Template] FOREIGN KEY([TemplateID]) REFERENCES [dbo].[NotificationTemplate]([ID])
);

-- Аналитические таблицы
CREATE TABLE [dbo].[ReportTemplate](
    [ID] [int] IDENTITY(1,1) NOT NULL,
    [Name] [nvarchar](100) NOT NULL,
    [Description] [nvarchar](255),
    [SQLQuery] [nvarchar](max),
    [Parameters] [nvarchar](max),
    [CreatedBy] [int],
    [CreatedDate] [datetime] DEFAULT GETDATE(),
    [IsActive] [bit] DEFAULT 1,
    CONSTRAINT [PK_ReportTemplate] PRIMARY KEY ([ID]),
    CONSTRAINT [FK_ReportTemplate_User] FOREIGN KEY([CreatedBy]) REFERENCES [dbo].[User]([ID])
);

CREATE TABLE [dbo].[AgentSalesPlan](
    [ID] [int] IDENTITY(1,1) NOT NULL,
    [AgentID] [int] NOT NULL,
    [Year] [int] NOT NULL,
    [Month] [int] NOT NULL,
    [PlannedAmount] [decimal](15,2),
    [ActualAmount] [decimal](15,2) DEFAULT 0,
    [BonusPercent] [decimal](5,2),
    [CreatedDate] [datetime] DEFAULT GETDATE(),
    CONSTRAINT [PK_AgentSalesPlan] PRIMARY KEY ([ID]),
    CONSTRAINT [FK_AgentSalesPlan_Agent] FOREIGN KEY([AgentID]) REFERENCES [dbo].[Agent]([ID])
);

-- ==========================================
-- ВСТАВКА ДАННЫХ ИЗ enhanced_reference_data.csv
-- ==========================================
SET IDENTITY_INSERT [dbo].[WarehouseZone] OFF;
SET IDENTITY_INSERT [dbo].[Warehouse] OFF;
SET IDENTITY_INSERT [dbo].[Equipment] OFF;
SET IDENTITY_INSERT [dbo].[Workshop] OFF;
SET IDENTITY_INSERT [dbo].[PaymentType] OFF;
SET IDENTITY_INSERT [dbo].[OrderStatus] OFF;
SET IDENTITY_INSERT [dbo].[Shift] OFF;
SET IDENTITY_INSERT [dbo].[AccessPoint] OFF;
SET IDENTITY_INSERT [dbo].[Employee] OFF;
SET IDENTITY_INSERT [dbo].[User] OFF;
SET IDENTITY_INSERT [dbo].[Position] OFF;
SET IDENTITY_INSERT [dbo].[Department] OFF;
SET IDENTITY_INSERT [dbo].[UserRole] OFF;
SET IDENTITY_INSERT [dbo].[City] OFF;
SET IDENTITY_INSERT [dbo].[Region] OFF;

-- [AGENT]
SET IDENTITY_INSERT [dbo].[Agent] ON;
INSERT INTO [dbo].[Agent] ([ID], [FirstName], [LastName], [MiddleName], [Email], [Phone], [UserID], [IsActive])
VALUES
(1, 'Иван', 'Иванов', 'Иванович', 'agent1@company.ru', '+79990000001', NULL, 1),
(2, 'Петр', 'Петров', 'Петрович', 'agent2@company.ru', '+79990000002', NULL, 1),
(3, 'Сергей', 'Сергеев', 'Сергеевич', 'agent3@company.ru', '+79990000003', NULL, 1),
(4, 'Анна', 'Андреева', 'Андреевна', 'agent4@company.ru', '+79990000004', NULL, 1),
(5, 'Мария', 'Маркова', 'Марковна', 'agent5@company.ru', '+79990000005', NULL, 1),
(6, 'Алексей', 'Алексеев', 'Алексеевич', 'agent6@company.ru', '+79990000006', NULL, 1),
(7, 'Дмитрий', 'Дмитриев', 'Дмитриевич', 'agent7@company.ru', '+79990000007', NULL, 1),
(8, 'Ольга', 'Ольгова', 'Ольговна', 'agent8@company.ru', '+79990000008', NULL, 1),
(9, 'Елена', 'Еленова', 'Еленовна', 'agent9@company.ru', '+79990000009', NULL, 1),
(10, 'Николай', 'Николаев', 'Николаевич', 'agent10@company.ru', '+79990000010', NULL, 1),
(11, 'Татьяна', 'Татьянова', 'Татьяновна', 'agent11@company.ru', '+79990000011', NULL, 1),
(12, 'Виктор', 'Викторов', 'Викторович', 'agent12@company.ru', '+79990000012', NULL, 1),
(13, 'Юлия', 'Юльева', 'Юльевна', 'agent13@company.ru', '+79990000013', NULL, 1),
(14, 'Андрей', 'Андреев', 'Андреевич', 'agent14@company.ru', '+79990000014', NULL, 1),
(15, 'Наталья', 'Натальева', 'Натальевна', 'agent15@company.ru', '+79990000015', NULL, 1),
(16, 'Михаил', 'Михайлов', 'Михайлович', 'agent16@company.ru', '+79990000016', NULL, 1),
(17, 'Светлана', 'Светлова', 'Светловна', 'agent17@company.ru', '+79990000017', NULL, 1),
(18, 'Артем', 'Артемов', 'Артемович', 'agent18@company.ru', '+79990000018', NULL, 1),
(19, 'Екатерина', 'Екатеринова', 'Екатериновна', 'agent19@company.ru', '+79990000019', NULL, 1),
(20, 'Павел', 'Павлов', 'Павлович', 'agent20@company.ru', '+79990000020', NULL, 1);
SET IDENTITY_INSERT [dbo].[Agent] OFF;

-- [REGION]
SET IDENTITY_INSERT [dbo].[Region] ON;
INSERT INTO [dbo].[Region] ([ID], [Name], [Code], [DeliveryMultiplier], [IsActive])
VALUES
(1, 'Центральный федеральный округ', 'ЦФО', 1.0, 1),
(2, 'Северо-Западный федеральный округ', 'СЗФО', 1.2, 1),
(3, 'Южный федеральный округ', 'ЮФО', 1.1, 1),
(4, 'Северо-Кавказский федеральный округ', 'СКФО', 1.3, 1),
(5, 'Приволжский федеральный округ', 'ПФО', 1.1, 1),
(6, 'Уральский федеральный округ', 'УФО', 1.2, 1),
(7, 'Сибирский федеральный округ', 'СФО', 1.4, 1),
(8, 'Дальневосточный федеральный округ', 'ДВФО', 1.6, 1);
SET IDENTITY_INSERT [dbo].[Region] OFF;

-- [CITY]
SET IDENTITY_INSERT [dbo].[City] ON;
INSERT INTO [dbo].[City] ([ID], [Name], [RegionID], [PostalCode], [Latitude], [Longitude])
VALUES
(1, 'Москва', 1, '101000', 55.7558, 37.6176),
(2, 'Санкт-Петербург', 2, '190000', 59.9311, 30.3609),
(3, 'Новосибирск', 7, '630000', 55.0084, 82.9357),
(4, 'Екатеринбург', 6, '620000', 56.8431, 60.6454),
(5, 'Нижний Новгород', 5, '603000', 56.2965, 43.9361),
(6, 'Казань', 5, '420000', 55.8304, 49.0661),
(7, 'Челябинск', 6, '454000', 55.1644, 61.4368),
(8, 'Омск', 7, '644000', 54.9885, 73.3242),
(9, 'Самара', 5, '443000', 53.2001, 50.15),
(10, 'Ростов-на-Дону', 3, '344000', 47.2357, 39.7015),
(11, 'Уфа', 5, '450000', 54.7388, 55.9721),
(12, 'Красноярск', 7, '660000', 56.0184, 92.8672),
(13, 'Воронеж', 1, '394000', 51.6720, 39.1843),
(14, 'Пермь', 5, '614000', 58.0105, 56.2502),
(15, 'Волгоград', 3, '400000', 48.7080, 44.5133);
SET IDENTITY_INSERT [dbo].[City] OFF;

-- [USER_ROLES]
SET IDENTITY_INSERT [dbo].[UserRole] ON;
INSERT INTO [dbo].[UserRole] ([ID], [RoleName], [Description], [Permissions])
VALUES
(1, 'Администратор', 'Полный доступ к системе', '{"users": "full", "orders": "full", "reports": "full", "settings": "full"}'),
(2, 'Менеджер', 'Управление агентами и заказами', '{"agents": "full", "orders": "full", "reports": "read"}'),
(3, 'Мастер производства', 'Управление производством', '{"production": "full", "materials": "full", "equipment": "read"}'),
(4, 'Аналитик', 'Работа с отчетами и аналитикой', '{"reports": "full", "analytics": "full", "orders": "read"}'),
(5, 'Кладовщик', 'Управление складом', '{"materials": "full", "warehouse": "full", "inventory": "full"}'),
(6, 'Агент', 'Просмотр своих данных', '{"profile": "read", "orders": "own"}'),
(7, 'Бухгалтер', 'Финансовые операции', '{"payments": "full", "reports": "financial", "agents": "read"}'),
(8, 'Оператор', 'Базовый доступ', '{"orders": "read", "materials": "read", "reports": "basic"}');
SET IDENTITY_INSERT [dbo].[UserRole] OFF;

-- [DEPARTMENTS]
SET IDENTITY_INSERT [dbo].[Department] ON;
INSERT INTO [dbo].[Department] ([ID], [Name], [Description], [IsActive])
VALUES
(1, 'Управление', 'Административные функции', 1),
(2, 'Производство', 'Изготовление продукции', 1),
(3, 'Склад', 'Складские операции', 1),
(4, 'Отдел продаж', 'Работа с агентами', 1),
(5, 'Аналитический отдел', 'Анализ и планирование', 1),
(6, 'Бухгалтерия', 'Финансовый учет', 1),
(7, 'IT-отдел', 'Техническая поддержка', 1),
(8, 'Отдел кадров', 'Управление персоналом', 1),
(9, 'Служба безопасности', 'Контроль доступа', 1),
(10, 'Логистика', 'Доставка и транспорт', 1);
SET IDENTITY_INSERT [dbo].[Department] OFF;

-- [POSITIONS]
SET IDENTITY_INSERT [dbo].[Position] ON;
INSERT INTO [dbo].[Position] ([ID], [Title], [Description], [BaseSalary], [RequiredExperience], [IsActive])
VALUES
(1, 'Генеральный директор', 'Руководство компанией', 150000, 60, 1),
(2, 'Менеджер по продажам', 'Работа с агентами', 65000, 12, 1),
(3, 'Мастер производства', 'Контроль производства', 75000, 24, 1),
(4, 'Аналитик', 'Анализ данных', 55000, 6, 1),
(5, 'Кладовщик', 'Складские операции', 40000, 0, 1),
(6, 'Бухгалтер', 'Ведение учета', 50000, 12, 1),
(7, 'Системный администратор', 'IT поддержка', 70000, 24, 1),
(8, 'HR-менеджер', 'Управление персоналом', 60000, 12, 1),
(9, 'Охранник', 'Обеспечение безопасности', 35000, 0, 1),
(10, 'Водитель', 'Доставка продукции', 45000, 12, 1),
(11, 'Оператор производства', 'Работа на оборудовании', 42000, 3, 1),
(12, 'Контролер качества', 'Проверка продукции', 48000, 6, 1);
SET IDENTITY_INSERT [dbo].[Position] OFF;

-- ==========================================
-- ВСТАВКА ДАННЫХ ИЗ enhanced_test_data.csv
-- ==========================================

-- [USER]
SET IDENTITY_INSERT [dbo].[User] ON;
INSERT INTO [dbo].[User] ([ID], [Login], [Email], [FirstName], [LastName], [MiddleName], [UserRoleID], [IsActive], [PasswordHash])
VALUES
(1, 'смирнов.к1', 'смирнов.к1@company.ru', 'Кирилл', 'Смирнов', 'Дмитриевич', 3, 1, 'temp_hash_1'),
(2, 'соколов.т2', 'соколов.т2@company.ru', 'Татьяна', 'Соколов', 'Алексеевна', 4, 1, 'temp_hash_2'),
(3, 'михайлова.д3', 'михайлова.д3@company.ru', 'Дмитрий', 'Михайлова', 'Максимович', 7, 1, 'temp_hash_3'),
(4, 'смирнов.а4', 'смирнов.а4@company.ru', 'Алексей', 'Смирнов', 'Максимович', 7, 1, 'temp_hash_4'),
(5, 'попова.а5', 'попова.а5@company.ru', 'Александр', 'Попова', 'Дмитриевич', 8, 1, 'temp_hash_5'),
(6, 'михайлов.к6', 'михайлов.к6@company.ru', 'Кирилл', 'Михайлов', 'Сергеевна', 5, 1, 'temp_hash_6'),
(7, 'соколова.т7', 'соколова.т7@company.ru', 'Татьяна', 'Соколова', 'Сергеевич', 8, 1, 'temp_hash_7'),
(8, 'новикова.е8', 'новикова.е8@company.ru', 'Елена', 'Новикова', 'Александрович', 4, 1, 'temp_hash_8'),
(9, 'михайлова.м9', 'михайлова.м9@company.ru', 'Мария', 'Михайлова', 'Александрович', 7, 1, 'temp_hash_9'),
(10, 'иванова.с10', 'иванова.с10@company.ru', 'Светлана', 'Иванова', 'Андреевна', 5, 1, 'temp_hash_10'),
(11, 'васильев.а11', 'васильев.а11@company.ru', 'Анна', 'Васильев', 'Андреевич', 2, 1, 'temp_hash_11'),
(12, 'петров.м12', 'петров.м12@company.ru', 'Мария', 'Петров', 'Дмитриевич', 8, 1, 'temp_hash_12'),
(13, 'новиков.и13', 'новиков.и13@company.ru', 'Илья', 'Новиков', 'Александрович', 8, 1, 'temp_hash_13'),
(14, 'попова.а14', 'попова.а14@company.ru', 'Алексей', 'Попова', 'Александровна', 6, 1, 'temp_hash_14'),
(15, 'попова.а15', 'попова.а15@company.ru', 'Анна', 'Попова', 'Дмитриевич', 3, 1, 'temp_hash_15'),
(16, 'михайлов.м16', 'михайлов.м16@company.ru', 'Максим', 'Михайлов', 'Алексеевич', 8, 1, 'temp_hash_16'),
(17, 'васильев.е17', 'васильев.е17@company.ru', 'Елена', 'Васильев', 'Сергеевна', 3, 1, 'temp_hash_17'),
(18, 'соколова.и18', 'соколова.и18@company.ru', 'Ирина', 'Соколова', 'Дмитриевич', 2, 1, 'temp_hash_18'),
(19, 'иванов.и19', 'иванов.и19@company.ru', 'Илья', 'Иванов', 'Максимович', 6, 1, 'temp_hash_19'),
(20, 'кузнецова.с20', 'кузнецова.с20@company.ru', 'Сергей', 'Кузнецова', 'Сергеевич', 2, 1, 'temp_hash_20'),
(21, 'соколова.ю21', 'соколова.ю21@company.ru', 'Юлия', 'Соколова', 'Андреевич', 7, 1, 'temp_hash_21'),
(22, 'смирнова.и22', 'смирнова.и22@company.ru', 'Илья', 'Смирнова', 'Алексеевна', 2, 1, 'temp_hash_22'),
(23, 'кузнецов.е23', 'кузнецов.е23@company.ru', 'Екатерина', 'Кузнецов', 'Андреевна', 3, 1, 'temp_hash_23'),
(24, 'михайлова.м24', 'михайлова.м24@company.ru', 'Максим', 'Михайлова', 'Александрович', 5, 1, 'temp_hash_24'),
(25, 'михайлова.а25', 'михайлова.а25@company.ru', 'Андрей', 'Михайлова', 'Андреевна', 7, 1, 'temp_hash_25'),
(26, 'попов.а26', 'попов.а26@company.ru', 'Александр', 'Попов', 'Александровна', 3, 1, 'temp_hash_26'),
(27, 'соколова.с27', 'соколова.с27@company.ru', 'Светлана', 'Соколова', 'Алексеевич', 3, 1, 'temp_hash_27'),
(28, 'иванов.м28', 'иванов.м28@company.ru', 'Мария', 'Иванов', 'Дмитриевич', 5, 1, 'temp_hash_28'),
(29, 'васильев.н29', 'васильев.н29@company.ru', 'Наталья', 'Васильев', 'Александрович', 2, 1, 'temp_hash_29'),
(30, 'васильева.ю30', 'васильева.ю30@company.ru', 'Юлия', 'Васильева', 'Андреевич', 3, 1, 'temp_hash_30'),
(31, 'иванова.с31', 'иванова.с31@company.ru', 'Сергей', 'Иванова', 'Алексеевна', 4, 1, 'temp_hash_31'),
(32, 'попов.а32', 'попов.а32@company.ru', 'Анна', 'Попов', 'Андреевна', 4, 1, 'temp_hash_32'),
(33, 'михайлова.с33', 'михайлова.с33@company.ru', 'Сергей', 'Михайлова', 'Дмитриевна', 8, 1, 'temp_hash_33'),
(34, 'васильева.е34', 'васильева.е34@company.ru', 'Екатерина', 'Васильева', 'Дмитриевич', 7, 1, 'temp_hash_34'),
(35, 'васильев.к35', 'васильев.к35@company.ru', 'Кирилл', 'Васильев', 'Дмитриевич', 2, 1, 'temp_hash_35'),
(36, 'кузнецов.с36', 'кузнецов.с36@company.ru', 'Сергей', 'Кузнецов', 'Сергеевна', 8, 1, 'temp_hash_36'),
(37, 'попова.с37', 'попова.с37@company.ru', 'Светлана', 'Попова', 'Александровна', 5, 1, 'temp_hash_37'),
(38, 'петров.м38', 'петров.м38@company.ru', 'Максим', 'Петров', 'Андреевич', 7, 1, 'temp_hash_38'),
(39, 'михайлова.д39', 'михайлова.д39@company.ru', 'Дмитрий', 'Михайлова', 'Алексеевна', 6, 1, 'temp_hash_39'),
(40, 'васильев.с40', 'васильев.с40@company.ru', 'Сергей', 'Васильев', 'Андреевна', 3, 1, 'temp_hash_40'),
(41, 'петров.к41', 'петров.к41@company.ru', 'Кирилл', 'Петров', 'Александрович', 8, 1, 'temp_hash_41'),
(42, 'соколов.м42', 'соколов.м42@company.ru', 'Мария', 'Соколов', 'Алексеевич', 3, 1, 'temp_hash_42'),
(43, 'васильев.т43', 'васильев.т43@company.ru', 'Татьяна', 'Васильев', 'Андреевич', 3, 1, 'temp_hash_43'),
(44, 'васильев.а44', 'васильев.а44@company.ru', 'Александр', 'Васильев', 'Андреевна', 2, 1, 'temp_hash_44'),
(45, 'федоров.ю45', 'федоров.ю45@company.ru', 'Юлия', 'Федоров', 'Максимович', 6, 1, 'temp_hash_45'),
(46, 'смирнова.м46', 'смирнова.м46@company.ru', 'Мария', 'Смирнова', 'Алексеевна', 4, 1, 'temp_hash_46'),
(47, 'иванов.н47', 'иванов.н47@company.ru', 'Наталья', 'Иванов', 'Дмитриевич', 6, 1, 'temp_hash_47'),
(48, 'соколова.е48', 'соколова.е48@company.ru', 'Елена', 'Соколова', 'Алексеевна', 6, 1, 'temp_hash_48'),
(49, 'федоров.е49', 'федоров.е49@company.ru', 'Елена', 'Федоров', 'Александровна', 4, 1, 'temp_hash_49'),
(50, 'иванова.с50', 'иванова.с50@company.ru', 'Сергей', 'Иванова', 'Дмитриевич', 8, 1, 'temp_hash_50');
SET IDENTITY_INSERT [dbo].[User] OFF;

-- [EMPLOYEES]
SET IDENTITY_INSERT [dbo].[Employee] ON;
INSERT INTO [dbo].[Employee] ([ID], [PersonalNumber], [FirstName], [LastName], [MiddleName], [BirthDate], [HireDate], [DepartmentID], [PositionID], [UserID], [Phone], [Email], [HasFamily], [IsActive])
VALUES
(1, 'EMP0001', 'Кирилл', 'Смирнов', 'Дмитриевич', '1990-04-20', '2023-10-22', 1, 6, 1, '+79870631944', 'смирнов.к1@company.ru', 1, 1),
(2, 'EMP0002', 'Татьяна', 'Соколов', 'Алексеевна', '1987-06-25', '2021-05-27', 2, 1, 2, '+79741473243', 'соколов.т2@company.ru', 1, 1),
(3, 'EMP0003', 'Дмитрий', 'Михайлова', 'Максимович', '1983-01-10', '2019-12-28', 4, 5, 3, '+79328426893', 'михайлова.д3@company.ru', 1, 1),
(4, 'EMP0004', 'Алексей', 'Смирнов', 'Максимович', '1984-11-09', '2021-02-13', 9, 3, 4, '+79985877526', 'смирнов.а4@company.ru', 0, 1),
(5, 'EMP0005', 'Александр', 'Попова', 'Дмитриевич', '1978-12-05', '2020-05-19', 2, 1, 5, '+79234602983', 'попова.а5@company.ru', 0, 1),
(6, 'EMP0006', 'Кирилл', 'Михайлов', 'Сергеевна', '1988-02-09', '2022-02-25', 4, 9, 6, '+79722209725', 'михайлов.к6@company.ru', 0, 1),
(7, 'EMP0007', 'Татьяна', 'Соколова', 'Сергеевич', '1990-01-12', '2023-02-25', 9, 8, 7, '+79559563337', 'соколова.т7@company.ru', 1, 1),
(8, 'EMP0008', 'Елена', 'Новикова', 'Александрович', '1980-10-10', '2016-09-16', 3, 5, 8, '+79767304241', 'новикова.е8@company.ru', 0, 1),
(9, 'EMP0009', 'Мария', 'Михайлова', 'Александрович', '1971-08-08', '2018-07-15', 1, 4, 9, '+79541704043', 'михайлова.м9@company.ru', 1, 1),
(10, 'EMP0010', 'Светлана', 'Иванова', 'Андреевна', '1982-01-18', '2019-04-13', 3, 8, 10, '+79798780920', 'иванова.с10@company.ru', 1, 1),
(11, 'EMP0011', 'Анна', 'Васильев', 'Андреевич', '1992-07-28', '2018-08-23', 8, 1, 11, '+79039922469', 'васильев.а11@company.ru', 1, 1),
(12, 'EMP0012', 'Мария', 'Петров', 'Дмитриевич', '1981-07-24', '2019-06-14', 4, 8, 12, '+79271226953', 'петров.м12@company.ru', 0, 1),
(13, 'EMP0013', 'Илья', 'Новиков', 'Александрович', '1990-05-11', '2016-05-03', 9, 11, 13, '+79349963877', 'новиков.и13@company.ru', 1, 1),
(14, 'EMP0014', 'Алексей', 'Попова', 'Александровна', '1983-12-07', '2021-02-09', 10, 2, 14, '+79783984035', 'попова.а14@company.ru', 0, 1),
(15, 'EMP0015', 'Анна', 'Попова', 'Дмитриевич', '1974-02-05', '2021-08-15', 9, 4, 15, '+79457476301', 'попова.а15@company.ru', 1, 1),
(16, 'EMP0016', 'Максим', 'Михайлов', 'Алексеевич', '1971-01-18', '2021-06-13', 10, 6, 16, '+79752919574', 'михайлов.м16@company.ru', 0, 1),
(17, 'EMP0017', 'Елена', 'Васильев', 'Сергеевна', '1998-09-24', '2018-04-07', 5, 2, 17, '+79829298693', 'васильев.е17@company.ru', 1, 1),
(18, 'EMP0018', 'Ирина', 'Соколова', 'Дмитриевич', '1982-11-18', '2019-03-12', 9, 10, 18, '+79812726578', 'соколова.и18@company.ru', 1, 1),
(19, 'EMP0019', 'Илья', 'Иванов', 'Максимович', '1979-05-03', '2023-03-23', 9, 5, 19, '+79689259070', 'иванов.и19@company.ru', 1, 1),
(20, 'EMP0020', 'Сергей', 'Кузнецова', 'Сергеевич', '1987-02-02', '2023-12-13', 7, 8, 20, '+79861480743', 'кузнецова.с20@company.ru', 0, 1),
(21, 'EMP0021', 'Юлия', 'Соколова', 'Андреевич', '1989-12-08', '2017-11-08', 8, 2, 21, '+79209064752', 'соколова.ю21@company.ru', 0, 1),
(22, 'EMP0022', 'Илья', 'Смирнова', 'Алексеевна', '1994-09-14', '2021-05-19', 9, 9, 22, '+79487297450', 'смирнова.и22@company.ru', 0, 1),
(23, 'EMP0023', 'Екатерина', 'Кузнецов', 'Андреевна', '1991-02-26', '2016-04-28', 5, 9, 23, '+79466941690', 'кузнецов.е23@company.ru', 0, 1),
(24, 'EMP0024', 'Максим', 'Михайлова', 'Александрович', '1987-03-19', '2021-09-23', 3, 2, 24, '+79781085950', 'михайлова.м24@company.ru', 1, 1),
(25, 'EMP0025', 'Андрей', 'Михайлова', 'Андреевна', '1986-07-06', '2016-01-03', 10, 6, 25, '+79312112963', 'михайлова.а25@company.ru', 1, 1),
(26, 'EMP0026', 'Александр', 'Попов', 'Александровна', '1989-12-24', '2024-06-12', 9, 4, 26, '+79565020304', 'попов.а26@company.ru', 0, 1),
(27, 'EMP0027', 'Светлана', 'Соколова', 'Алексеевич', '1983-01-08', '2019-06-23', 7, 1, 27, '+79085522470', 'соколова.с27@company.ru', 0, 1),
(28, 'EMP0028', 'Мария', 'Иванов', 'Дмитриевич', '1970-04-28', '2018-08-26', 1, 4, 28, '+79477643805', 'иванов.м28@company.ru', 1, 1),
(29, 'EMP0029', 'Наталья', 'Васильев', 'Александрович', '1985-07-27', '2024-06-22', 7, 8, 29, '+79630188695', 'васильев.н29@company.ru', 0, 1),
(30, 'EMP0030', 'Юлия', 'Васильева', 'Андреевич', '1972-06-09', '2019-06-15', 5, 9, 30, '+79963037796', 'васильева.ю30@company.ru', 1, 1),
(31, 'EMP0031', 'Сергей', 'Иванова', 'Алексеевна', '1980-04-02', '2024-08-06', 1, 6, 31, '+79014108910', 'иванова.с31@company.ru', 1, 1),
(32, 'EMP0032', 'Анна', 'Попов', 'Андреевна', '1998-06-18', '2015-11-07', 8, 6, 32, '+79978001455', 'попов.а32@company.ru', 1, 1),
(33, 'EMP0033', 'Сергей', 'Михайлова', 'Дмитриевна', '1990-04-16', '2020-08-03', 7, 11, 33, '+79912929602', 'михайлова.с33@company.ru', 0, 1),
(34, 'EMP0034', 'Екатерина', 'Васильева', 'Дмитриевич', '1982-11-18', '2021-08-05', 6, 3, 34, '+79106271970', 'васильева.е34@company.ru', 0, 1),
(35, 'EMP0035', 'Кирилл', 'Васильев', 'Дмитриевич', '1981-06-05', '2016-07-16', 6, 5, 35, '+79635314974', 'васильев.к35@company.ru', 1, 1),
(36, 'EMP0036', 'Сергей', 'Кузнецов', 'Сергеевна', '1990-08-05', '2021-07-22', 7, 10, 36, '+79072946924', 'кузнецов.с36@company.ru', 1, 1),
(37, 'EMP0037', 'Светлана', 'Попова', 'Александровна', '1988-02-05', '2022-05-14', 10, 4, 37, '+79092195517', 'попова.с37@company.ru', 1, 1),
(38, 'EMP0038', 'Максим', 'Петров', 'Андреевич', '1995-12-13', '2021-09-14', 8, 12, 38, '+79880015136', 'петров.м38@company.ru', 1, 1),
(39, 'EMP0039', 'Дмитрий', 'Михайлова', 'Алексеевна', '1994-02-06', '2021-10-21', 7, 3, 39, '+79112026632', 'михайлова.д39@company.ru', 0, 1),
(40, 'EMP0040', 'Сергей', 'Васильев', 'Андреевна', '1986-11-06', '2017-05-11', 7, 3, 40, '+79307758108', 'васильев.с40@company.ru', 1, 1),
(41, 'EMP0041', 'Кирилл', 'Петров', 'Александрович', '1972-03-11', '2018-06-10', 2, 10, 41, '+79785607139', 'петров.к41@company.ru', 0, 1),
(42, 'EMP0042', 'Мария', 'Соколов', 'Алексеевич', '1975-11-18', '2020-04-09', 6, 12, 42, '+79725426485', 'соколов.м42@company.ru', 0, 1),
(43, 'EMP0043', 'Татьяна', 'Васильев', 'Андреевич', '1976-06-20', '2017-08-01', 5, 2, 43, '+79077384729', 'васильев.т43@company.ru', 1, 1),
(44, 'EMP0044', 'Александр', 'Васильев', 'Андреевна', '1996-09-28', '2023-07-23', 8, 1, 44, '+79252084164', 'васильев.а44@company.ru', 0, 1),
(45, 'EMP0045', 'Юлия', 'Федоров', 'Максимович', '1978-11-27', '2020-10-21', 3, 11, 45, '+79572332571', 'федоров.ю45@company.ru', 0, 1),
(46, 'EMP0046', 'Мария', 'Смирнова', 'Алексеевна', '1993-03-06', '2016-09-03', 5, 7, 46, '+79928962488', 'смирнова.м46@company.ru', 0, 1),
(47, 'EMP0047', 'Наталья', 'Иванов', 'Дмитриевич', '1974-11-26', '2016-02-21', 10, 6, 47, '+79827059173', 'иванов.н47@company.ru', 0, 1),
(48, 'EMP0048', 'Елена', 'Соколова', 'Алексеевна', '1972-04-07', '2020-04-13', 8, 5, 48, '+79722902224', 'соколова.е48@company.ru', 0, 1),
(49, 'EMP0049', 'Елена', 'Федоров', 'Александровна', '1973-03-05', '2020-04-11', 5, 10, 49, '+79310267607', 'федоров.е49@company.ru', 1, 1),
(50, 'EMP0050', 'Сергей', 'Иванова', 'Дмитриевич', '1992-09-01', '2020-01-18', 5, 2, 50, '+79791162393', 'иванова.с50@company.ru', 1, 1);
SET IDENTITY_INSERT [dbo].[Employee] OFF;

-- [ACCESS_POINTS]
SET IDENTITY_INSERT [dbo].[AccessPoint] ON;
INSERT INTO [dbo].[AccessPoint] ([ID], [Name], [Location], [Type], [IsActive])
VALUES
(1, 'Главный вход', 'Административное здание - главный вход', 'Turnstile', 1),
(2, 'Вход в цех №1', 'Производственный корпус - цех 1', 'Door', 1),
(3, 'Вход в цех №2', 'Производственный корпус - цех 2', 'Door', 1),
(4, 'Вход в цех №3', 'Производственный корпус - цех 3', 'Door', 1),
(5, 'Склад сырья', 'Складской комплекс - входная зона', 'Door', 1),
(6, 'Склад готовой продукции', 'Складской комплекс - отгрузочная зона', 'Door', 1),
(7, 'Административная зона', 'Офисное здание - 2 этаж', 'Door', 1),
(8, 'Лаборатория', 'Производственный корпус - лаборатория', 'Door', 1),
(9, 'Парковка', 'Территория предприятия - шлагбаум', 'Gate', 1),
(10, 'Столовая', 'Административное здание - столовая', 'Door', 1);
SET IDENTITY_INSERT [dbo].[AccessPoint] OFF;

-- [SHIFTS]
SET IDENTITY_INSERT [dbo].[Shift] ON;
INSERT INTO [dbo].[Shift] ([ID], [Name], [StartTime], [EndTime], [BreakDuration], [IsActive])
VALUES
(1, 'Дневная смена', '08:00:00', '17:00:00', 60, 1),
(2, 'Ночная смена', '20:00:00', '05:00:00', 60, 1),
(3, 'Сокращенная смена', '09:00:00', '15:00:00', 30, 1),
(4, 'Удлиненная смена', '07:00:00', '19:00:00', 90, 1),
(5, 'Гибкая смена', '10:00:00', '18:00:00', 60, 1);
SET IDENTITY_INSERT [dbo].[Shift] OFF;

-- [ORDER_STATUSES]
SET IDENTITY_INSERT [dbo].[OrderStatus] ON;
INSERT INTO [dbo].[OrderStatus] ([ID], [StatusName], [Description], [SortOrder], [Color])
VALUES
(1, 'Новый', 'Заявка создана', 1, '#007bff'),
(2, 'На рассмотрении', 'Заявка рассматривается менеджером', 2, '#ffc107'),
(3, 'Подтвержден', 'Заявка подтверждена и ожидает оплаты', 3, '#17a2b8'),
(4, 'Оплачен', 'Получена предоплата', 4, '#28a745'),
(5, 'В производстве', 'Продукция запущена в производство', 5, '#fd7e14'),
(6, 'Готов к отгрузке', 'Производство завершено', 6, '#20c997'),
(7, 'Отгружен', 'Продукция отгружена', 7, '#6f42c1'),
(8, 'Доставлен', 'Продукция доставлена агенту', 8, '#198754'),
(9, 'Завершен', 'Заказ полностью выполнен', 9, '#28a745'),
(10, 'Отменен', 'Заказ отменен', 99, '#dc3545');
SET IDENTITY_INSERT [dbo].[OrderStatus] OFF;

-- [PAYMENT_TYPES]
SET IDENTITY_INSERT [dbo].[PaymentType] ON;
INSERT INTO [dbo].[PaymentType] ([ID], [Name], [Description], [RequiresAdvance], [AdvancePercent])
VALUES
(1, 'Безналичный расчет', 'Перевод на расчетный счет', 1, 30.00),
(2, 'Наличный расчет', 'Оплата наличными при получении', 0, 0.00),
(3, 'Банковская карта', 'Оплата картой при получении', 0, 0.00),
(4, 'Рассрочка', 'Оплата в рассрочку', 1, 50.00),
(5, 'Постоплата', 'Оплата после доставки', 0, 0.00);
SET IDENTITY_INSERT [dbo].[PaymentType] OFF;

-- [WORKSHOPS]
SET IDENTITY_INSERT [dbo].[Workshop] ON;
INSERT INTO [dbo].[Workshop] ([ID], [Number], [Name], [Description], [MaxCapacity], [IsActive])
VALUES
(1, 1, 'Цех подготовки материалов', 'Обработка и подготовка сырья', 20, 1),
(2, 2, 'Цех основного производства', 'Изготовление продукции', 30, 1),
(3, 3, 'Цех упаковки', 'Упаковка готовой продукции', 15, 1),
(4, 4, 'Цех контроля качества', 'Проверка качества продукции', 10, 1),
(5, 5, 'Экспериментальный цех', 'Разработка новой продукции', 8, 1);
SET IDENTITY_INSERT [dbo].[Workshop] OFF;

-- [EQUIPMENT]
SET IDENTITY_INSERT [dbo].[Equipment] ON;
INSERT INTO [dbo].[Equipment] ([ID], [Name], [SerialNumber], [WorkshopID], [Status], [RequiredSpecialization])
VALUES
(1, 'Станок токарный ТВ-320', 'SN001234', 1, 'Working', '["токарные работы"]'),
(2, 'Фрезерный станок ФС-250', 'SN001235', 1, 'Working', '["фрезерные работы"]'),
(3, 'Линия сборки ЛС-100', 'SN002001', 2, 'Working', '["сборка"]'),
(4, 'Пресс гидравлический ПГ-500', 'SN002002', 2, 'Working', '["прессование"]'),
(5, 'Упаковочная машина УМ-50', 'SN003001', 3, 'Working', '["упаковка"]'),
(6, 'Конвейер упаковки КУ-200', 'SN003002', 3, 'Working', '["упаковка"]'),
(7, 'Спектрометр анализа СА-М1', 'SN004001', 4, 'Working', '["контроль качества"]'),
(8, 'Микроскоп цифровой МЦ-100', 'SN004002', 4, 'Working', '["контроль качества"]'),
(9, '3D принтер Прототип-1', 'SN005001', 5, 'Maintenance', '["3D печать"]'),
(10, 'Лазерный гравер ЛГ-20', 'SN005002', 5, 'Working', '["гравировка"]');
SET IDENTITY_INSERT [dbo].[Equipment] OFF;

-- [WAREHOUSES]
SET IDENTITY_INSERT [dbo].[Warehouse] ON;
INSERT INTO [dbo].[Warehouse] ([ID], [Name], [Address], [ResponsibleEmployeeID], [IsActive])
VALUES
(1, 'Основной склад', 'Складской комплекс корпус А', 25, 1),
(2, 'Склад готовой продукции', 'Складской комплекс корпус Б', 26, 1),
(3, 'Временный склад', 'Производственная площадка участок 3', 27, 1);
SET IDENTITY_INSERT [dbo].[Warehouse] OFF;

-- [WAREHOUSE_ZONES]
SET IDENTITY_INSERT [dbo].[WarehouseZone] ON;
INSERT INTO [dbo].[WarehouseZone] ([ID], [WarehouseID], [ZoneName], [Temperature], [Humidity], [IsClimateControlled])
VALUES
(1, 1, 'Зона А1', 20.0, 45.0, 1),
(2, 1, 'Зона А2', 18.0, 40.0, 1),
(3, 1, 'Зона А3', 22.0, 50.0, 0),
(4, 2, 'Зона Б1', 20.0, 45.0, 1),
(5, 2, 'Зона Б2', 20.0, 45.0, 1),
(6, 3, 'Зона В1', 15.0, 60.0, 0);
SET IDENTITY_INSERT [dbo].[WarehouseZone] OFF;

-- ==========================================
-- ВСТАВКА ДАННЫХ ИЗ enhanced_transactional_data.csv
-- ==========================================

-- [ACCESS_LOGS_SAMPLE]
SET IDENTITY_INSERT [dbo].[AccessLog] ON;
INSERT INTO [dbo].[AccessLog] ([ID], [EmployeeID], [AccessPointID], [AccessTime], [AccessType], [IsSuccessful])
VALUES
(1, 1, 1, '2024-01-01 08:02:41', 'IN', 1),
(2, 1, 6, '2024-01-01 10:04:41', 'OUT', 1),
(3, 1, 7, '2024-01-01 09:43:41', 'IN', 0),
(4, 1, 8, '2024-01-01 13:38:41', 'IN', 0),
(5, 1, 1, '2024-01-01 18:37:29', 'OUT', 1),
(6, 2, 1, '2024-01-01 09:43:41', 'IN', 1),
(7, 2, 3, '2024-01-01 13:03:41', 'OUT', 1),
(8, 2, 5, '2024-01-01 12:14:41', 'OUT', 1),
(9, 2, 7, '2024-01-01 11:34:41', 'OUT', 1),
(10, 2, 8, '2024-01-01 15:24:41', 'IN', 1),
(11, 2, 1, '2024-01-01 17:38:03', 'OUT', 1),
(12, 3, 1, '2024-01-01 09:23:46', 'IN', 1),
(13, 3, 7, '2024-01-01 15:17:46', 'IN', 1),
(14, 3, 3, '2024-01-01 10:57:46', 'IN', 1),
(15, 3, 3, '2024-01-01 12:04:46', 'IN', 1),
(16, 3, 4, '2024-01-01 15:44:46', 'IN', 1),
(17, 3, 1, '2024-01-01 16:20:59', 'OUT', 1),
(18, 4, 1, '2024-01-01 09:02:22', 'IN', 1),
(19, 4, 2, '2024-01-01 14:34:22', 'OUT', 1),
(20, 4, 10, '2024-01-01 15:35:22', 'OUT', 1),
(21, 4, 1, '2024-01-01 19:03:14', 'OUT', 1),
(22, 5, 1, '2024-01-01 07:10:35', 'IN', 1),
(23, 5, 4, '2024-01-01 13:37:35', 'OUT', 1),
(24, 5, 4, '2024-01-01 10:52:35', 'OUT', 0),
(25, 5, 7, '2024-01-01 15:04:35', 'OUT', 1),
(26, 5, 4, '2024-01-01 08:37:35', 'OUT', 1),
(27, 5, 7, '2024-01-01 16:07:35', 'OUT', 1),
(28, 5, 7, '2024-01-01 15:02:35', 'OUT', 1),
(29, 5, 5, '2024-01-01 15:23:35', 'IN', 1),
(30, 5, 1, '2024-01-01 16:23:00', 'OUT', 1),
(31, 6, 1, '2024-01-01 09:58:54', 'IN', 1),
(32, 6, 5, '2024-01-01 13:16:54', 'IN', 1),
(33, 6, 6, '2024-01-01 13:00:54', 'OUT', 1),
(34, 6, 1, '2024-01-01 20:22:30', 'OUT', 1),
(35, 7, 1, '2024-01-01 07:38:44', 'IN', 1),
(36, 7, 5, '2024-01-01 11:20:44', 'OUT', 1),
(37, 7, 5, '2024-01-01 09:22:44', 'OUT', 1),
(38, 7, 4, '2024-01-01 14:35:44', 'IN', 1),
(39, 7, 7, '2024-01-01 16:09:44', 'OUT', 1),
(40, 7, 1, '2024-01-01 17:09:32', 'OUT', 1),
(41, 8, 1, '2024-01-01 09:44:37', 'IN', 1),
(42, 8, 4, '2024-01-01 12:03:37', 'OUT', 1),
(43, 8, 6, '2024-01-01 14:14:37', 'OUT', 1),
(44, 8, 7, '2024-01-01 17:28:37', 'IN', 1),
(45, 8, 1, '2024-01-01 20:28:28', 'OUT', 1),
(46, 9, 1, '2024-01-01 08:22:02', 'IN', 1),
(47, 9, 10, '2024-01-01 11:17:02', 'IN', 0),
(48, 9, 4, '2024-01-01 09:37:02', 'IN', 1),
(49, 9, 7, '2024-01-01 12:35:02', 'IN', 1),
(50, 9, 3, '2024-01-01 10:19:02', 'OUT', 1),
(51, 9, 5, '2024-01-01 12:26:02', 'IN', 0),
(52, 9, 4, '2024-01-01 16:24:02', 'OUT', 1),
(53, 9, 1, '2024-01-01 20:04:16', 'OUT', 1),
(54, 10, 1, '2024-01-01 07:14:33', 'IN', 1),
(55, 10, 5, '2024-01-01 10:05:33', 'IN', 1),
(56, 10, 4, '2024-01-01 14:09:33', 'OUT', 1),
(57, 10, 1, '2024-01-01 20:20:21', 'OUT', 1),
(58, 11, 1, '2024-01-01 09:20:56', 'IN', 1),
(59, 11, 4, '2024-01-01 12:22:56', 'OUT', 1),
(60, 11, 4, '2024-01-01 11:34:56', 'IN', 1),
(61, 11, 7, '2024-01-01 17:53:56', 'IN', 1),
(62, 11, 3, '2024-01-01 16:35:56', 'OUT', 1),
(63, 11, 1, '2024-01-01 17:00:46', 'OUT', 1),
(64, 12, 1, '2024-01-01 09:11:00', 'IN', 1),
(65, 12, 4, '2024-01-01 13:56:00', 'IN', 1),
(66, 12, 3, '2024-01-01 17:37:00', 'IN', 1),
(67, 12, 6, '2024-01-01 13:35:00', 'OUT', 1),
(68, 12, 7, '2024-01-01 17:00:00', 'OUT', 1),
(69, 12, 1, '2024-01-01 17:19:10', 'OUT', 1),
(70, 13, 1, '2024-01-01 09:10:30', 'IN', 1),
(71, 13, 6, '2024-01-01 12:09:30', 'OUT', 1),
(72, 13, 6, '2024-01-01 11:18:30', 'OUT', 1),
(73, 13, 5, '2024-01-01 13:54:30', 'IN', 1),
(74, 13, 10, '2024-01-01 12:21:30', 'OUT', 0),
(75, 13, 10, '2024-01-01 13:45:30', 'OUT', 1),
(76, 13, 1, '2024-01-01 17:49:23', 'OUT', 1),
(77, 14, 1, '2024-01-01 09:16:24', 'IN', 1),
(78, 14, 3, '2024-01-01 11:18:24', 'IN', 1),
(79, 14, 8, '2024-01-01 12:28:24', 'OUT', 1),
(80, 14, 1, '2024-01-01 18:43:13', 'OUT', 1),
(81, 15, 1, '2024-01-01 07:57:42', 'IN', 1),
(82, 15, 2, '2024-01-01 14:21:42', 'OUT', 0),
(83, 15, 7, '2024-01-01 14:26:42', 'IN', 1),
(84, 15, 5, '2024-01-01 13:39:42', 'OUT', 1),
(85, 15, 4, '2024-01-01 11:11:42', 'IN', 0),
(86, 15, 1, '2024-01-01 16:19:01', 'OUT', 1),
(87, 16, 1, '2024-01-01 09:51:01', 'IN', 1),
(88, 16, 5, '2024-01-01 17:35:01', 'IN', 1),
(89, 16, 7, '2024-01-01 13:53:01', 'OUT', 1),
(90, 16, 4, '2024-01-01 11:56:01', 'OUT', 0),
(91, 16, 8, '2024-01-01 15:09:01', 'IN', 1),
(92, 16, 8, '2024-01-01 18:23:01', 'IN', 1),
(93, 16, 6, '2024-01-01 11:17:01', 'OUT', 0),
(94, 16, 4, '2024-01-01 15:33:01', 'OUT', 1),
(95, 16, 1, '2024-01-01 19:01:42', 'OUT', 1),
(96, 17, 1, '2024-01-01 09:12:45', 'IN', 1),
(97, 17, 7, '2024-01-01 15:59:45', 'IN', 1),
(98, 17, 7, '2024-01-01 12:21:45', 'OUT', 1),
(99, 17, 4, '2024-01-01 14:14:45', 'OUT', 0),
(100, 17, 1, '2024-01-01 19:26:10', 'OUT', 1),
(101, 18, 1, '2024-01-01 07:46:55', 'IN', 1),
(102, 18, 2, '2024-01-01 09:28:55', 'IN', 1),
(103, 18, 8, '2024-01-01 09:51:55', 'IN', 1),
(104, 18, 3, '2024-01-01 11:10:55', 'OUT', 1),
(105, 18, 7, '2024-01-01 09:37:55', 'IN', 0),
(106, 18, 8, '2024-01-01 12:47:55', 'OUT', 0),
(107, 18, 8, '2024-01-01 10:43:55', 'IN', 0),
(108, 18, 1, '2024-01-01 20:57:42', 'OUT', 1),
(109, 19, 1, '2024-01-01 09:23:57', 'IN', 1),
(110, 19, 2, '2024-01-01 12:01:57', 'OUT', 1),
(111, 19, 8, '2024-01-01 10:31:57', 'OUT', 1),
(112, 19, 1, '2024-01-01 16:57:04', 'OUT', 1),
(113, 20, 1, '2024-01-01 09:08:12', 'IN', 1),
(114, 20, 6, '2024-01-01 14:47:12', 'OUT', 1),
(115, 20, 8, '2024-01-01 16:42:12', 'IN', 1),
(116, 20, 5, '2024-01-01 15:05:12', 'OUT', 0),
(117, 20, 1, '2024-01-01 18:33:57', 'OUT', 1),
(118, 21, 1, '2024-01-01 09:48:46', 'IN', 1),
(119, 21, 7, '2024-01-01 11:38:46', 'OUT', 1),
(120, 21, 10, '2024-01-01 12:23:46', 'OUT', 1),
(121, 21, 1, '2024-01-01 17:29:13', 'OUT', 1),
(122, 22, 1, '2024-01-01 09:41:36', 'IN', 1),
(123, 22, 6, '2024-01-01 14:56:36', 'OUT', 1),
(124, 22, 6, '2024-01-01 12:27:36', 'OUT', 1),
(125, 22, 6, '2024-01-01 14:19:36', 'IN', 1),
(126, 22, 5, '2024-01-01 17:35:36', 'IN', 1),
(127, 22, 4, '2024-01-01 15:08:36', 'IN', 1),
(128, 22, 2, '2024-01-01 16:41:36', 'IN', 1),
(129, 22, 6, '2024-01-01 15:27:36', 'OUT', 1),
(130, 22, 1, '2024-01-01 16:39:19', 'OUT', 1),
(131, 23, 1, '2024-01-01 09:55:12', 'IN', 1),
(132, 23, 6, '2024-01-01 18:11:12', 'IN', 1),
(133, 23, 8, '2024-01-01 17:44:12', 'IN', 0),
(134, 23, 5, '2024-01-01 12:15:12', 'IN', 1),
(135, 23, 8, '2024-01-01 12:22:12', 'OUT', 0),
(136, 23, 10, '2024-01-01 14:12:12', 'IN', 1),
(137, 23, 8, '2024-01-01 11:23:12', 'IN', 1),
(138, 23, 5, '2024-01-01 17:16:12', 'IN', 1),
(139, 23, 10, '2024-01-01 17:18:12', 'IN', 1),
(140, 23, 1, '2024-01-01 17:26:12', 'OUT', 1),
(141, 24, 1, '2024-01-01 07:47:53', 'IN', 1),
(142, 24, 7, '2024-01-01 12:44:53', 'IN', 0),
(143, 24, 4, '2024-01-01 13:52:53', 'OUT', 1),
(144, 24, 3, '2024-01-01 10:05:53', 'IN', 1),
(145, 24, 7, '2024-01-01 15:17:53', 'OUT', 1),
(146, 24, 4, '2024-01-01 15:31:53', 'OUT', 1),
(147, 24, 10, '2024-01-01 14:53:53', 'OUT', 0),
(148, 24, 10, '2024-01-01 13:14:53', 'OUT', 1),
(149, 24, 1, '2024-01-01 19:51:29', 'OUT', 1),
(150, 25, 1, '2024-01-01 08:01:15', 'IN', 1),
(151, 25, 5, '2024-01-01 13:41:15', 'OUT', 1),
(152, 25, 3, '2024-01-01 15:39:15', 'IN', 1),
(153, 25, 1, '2024-01-01 18:14:37', 'OUT', 1),
(154, 26, 1, '2024-01-01 07:24:42', 'IN', 1),
(155, 26, 4, '2024-01-01 15:33:42', 'OUT', 1),
(156, 26, 10, '2024-01-01 15:23:42', 'OUT', 0),
(157, 26, 7, '2024-01-01 08:54:42', 'IN', 1),
(158, 26, 4, '2024-01-01 15:22:42', 'OUT', 1),
(159, 26, 1, '2024-01-01 20:22:46', 'OUT', 1),
(160, 27, 1, '2024-01-01 09:17:09', 'IN', 1),
(161, 27, 6, '2024-01-01 11:35:09', 'OUT', 1),
(162, 27, 4, '2024-01-01 16:13:09', 'OUT', 0),
(163, 27, 5, '2024-01-01 10:48:09', 'IN', 0),
(164, 27, 4, '2024-01-01 12:29:09', 'IN', 1),
(165, 27, 6, '2024-01-01 11:17:09', 'OUT', 1),
(166, 27, 8, '2024-01-01 12:53:09', 'IN', 1),
(167, 27, 2, '2024-01-01 11:21:09', 'OUT', 1),
(168, 27, 2, '2024-01-01 10:45:09', 'IN', 1),
(169, 27, 1, '2024-01-01 19:34:51', 'OUT', 1),
(170, 28, 1, '2024-01-01 09:15:43', 'IN', 1),
(171, 28, 2, '2024-01-01 17:00:43', 'OUT', 1),
(172, 28, 7, '2024-01-01 15:26:43', 'OUT', 1),
(173, 28, 2, '2024-01-01 16:05:43', 'OUT', 1),
(174, 28, 4, '2024-01-01 15:35:43', 'IN', 1),
(175, 28, 2, '2024-01-01 11:31:43', 'IN', 0),
(176, 28, 6, '2024-01-01 17:58:43', 'IN', 1),
(177, 28, 5, '2024-01-01 12:37:43', 'IN', 1),
(178, 28, 7, '2024-01-01 15:58:43', 'OUT', 1),
(179, 28, 1, '2024-01-01 20:49:00', 'OUT', 1),
(180, 29, 1, '2024-01-01 07:20:54', 'IN', 1),
(181, 29, 3, '2024-01-01 14:12:54', 'OUT', 1),
(182, 29, 7, '2024-01-01 13:15:54', 'OUT', 1),
(183, 29, 3, '2024-01-01 16:01:54', 'IN', 0),
(184, 29, 6, '2024-01-01 12:19:54', 'OUT', 1),
(185, 29, 10, '2024-01-01 08:50:54', 'IN', 0),
(186, 29, 7, '2024-01-01 10:58:54', 'IN', 1),
(187, 29, 6, '2024-01-01 08:56:54', 'IN', 1),
(188, 29, 1, '2024-01-01 20:37:32', 'OUT', 1),
(189, 30, 1, '2024-01-01 07:15:44', 'IN', 1),
(190, 30, 8, '2024-01-01 09:59:44', 'OUT', 1),
(191, 30, 7, '2024-01-01 12:58:44', 'IN', 1),
(192, 30, 1, '2024-01-01 17:56:23', 'OUT', 1),
(193, 31, 1, '2024-01-01 09:48:07', 'IN', 1),
(194, 31, 2, '2024-01-01 12:35:07', 'IN', 1),
(195, 31, 5, '2024-01-01 13:01:07', 'IN', 1),
(196, 31, 4, '2024-01-01 13:41:07', 'OUT', 1),
(197, 31, 1, '2024-01-01 16:52:52', 'OUT', 1),
(198, 32, 1, '2024-01-01 07:15:51', 'IN', 1),
(199, 32, 6, '2024-01-01 09:21:51', 'IN', 0),
(200, 32, 8, '2024-01-01 09:38:51', 'OUT', 1),
(201, 32, 6, '2024-01-01 12:17:51', 'IN', 1),
(202, 32, 5, '2024-01-01 08:27:51', 'OUT', 0),
(203, 32, 5, '2024-01-01 08:55:51', 'IN', 1),
(204, 32, 7, '2024-01-01 14:31:51', 'IN', 1),
(205, 32, 1, '2024-01-01 16:43:32', 'OUT', 1),
(206, 33, 1, '2024-01-01 09:09:37', 'IN', 1),
(207, 33, 5, '2024-01-01 13:36:37', 'OUT', 1),
(208, 33, 2, '2024-01-01 15:15:37', 'IN', 1),
(209, 33, 5, '2024-01-01 11:03:37', 'OUT', 1),
(210, 33, 8, '2024-01-01 17:03:37', 'IN', 0),
(211, 33, 5, '2024-01-01 15:47:37', 'OUT', 0),
(212, 33, 2, '2024-01-01 11:06:37', 'OUT', 1),
(213, 33, 7, '2024-01-01 16:04:37', 'IN', 0),
(214, 33, 1, '2024-01-01 17:07:39', 'OUT', 1),
(215, 34, 1, '2024-01-01 07:16:13', 'IN', 1),
(216, 34, 6, '2024-01-01 16:07:13', 'IN', 1),
(217, 34, 6, '2024-01-01 13:00:13', 'OUT', 0),
(218, 34, 10, '2024-01-01 13:27:13', 'OUT', 1),
(219, 34, 3, '2024-01-01 14:41:13', 'IN', 1),
(220, 34, 10, '2024-01-01 09:18:13', 'OUT', 1),
(221, 34, 5, '2024-01-01 09:33:13', 'OUT', 0),
(222, 34, 1, '2024-01-01 18:04:16', 'OUT', 1),
(223, 35, 1, '2024-01-01 07:31:32', 'IN', 1),
(224, 35, 8, '2024-01-01 09:53:32', 'IN', 0),
(225, 35, 6, '2024-01-01 11:24:32', 'OUT', 0),
(226, 35, 3, '2024-01-01 14:09:32', 'OUT', 1),
(227, 35, 10, '2024-01-01 08:54:32', 'OUT', 1),
(228, 35, 1, '2024-01-01 16:15:02', 'OUT', 1),
(229, 36, 1, '2024-01-01 09:05:30', 'IN', 1),
(230, 36, 3, '2024-01-01 15:14:30', 'OUT', 1),
(231, 36, 3, '2024-01-01 16:40:30', 'OUT', 1),
(232, 36, 10, '2024-01-01 16:54:30', 'OUT', 0),
(233, 36, 10, '2024-01-01 14:21:30', 'OUT', 1),
(234, 36, 7, '2024-01-01 13:56:30', 'IN', 1),
(235, 36, 6, '2024-01-01 11:46:30', 'OUT', 1),
(236, 36, 1, '2024-01-01 17:21:31', 'OUT', 1),
(237, 37, 1, '2024-01-01 07:31:23', 'IN', 1),
(238, 37, 10, '2024-01-01 12:36:23', 'IN', 0),
(239, 37, 3, '2024-01-01 13:03:23', 'IN', 1),
(240, 37, 3, '2024-01-01 12:43:23', 'IN', 1),
(241, 37, 8, '2024-01-01 13:02:23', 'IN', 0),
(242, 37, 10, '2024-01-01 10:34:23', 'IN', 1),
(243, 37, 10, '2024-01-01 11:03:23', 'OUT', 1),
(244, 37, 8, '2024-01-01 16:30:23', 'OUT', 0),
(245, 37, 1, '2024-01-01 16:14:22', 'OUT', 1),
(246, 38, 1, '2024-01-01 08:55:08', 'IN', 1),
(247, 38, 7, '2024-01-01 15:50:08', 'OUT', 0),
(248, 38, 6, '2024-01-01 14:20:08', 'IN', 1),
(249, 38, 4, '2024-01-01 16:35:08', 'IN', 0),
(250, 38, 10, '2024-01-01 15:24:08', 'OUT', 1),
(251, 38, 7, '2024-01-01 10:51:08', 'IN', 1),
(252, 38, 3, '2024-01-01 14:15:08', 'OUT', 0),
(253, 38, 10, '2024-01-01 10:59:08', 'OUT', 0),
(254, 38, 8, '2024-01-01 16:50:08', 'OUT', 1),
(255, 38, 1, '2024-01-01 20:09:11', 'OUT', 1),
(256, 39, 1, '2024-01-01 08:38:16', 'IN', 1),
(257, 39, 6, '2024-01-01 13:33:16', 'IN', 1),
(258, 39, 3, '2024-01-01 11:18:16', 'OUT', 1),
(259, 39, 2, '2024-01-01 13:21:16', 'IN', 1),
(260, 39, 2, '2024-01-01 17:18:16', 'IN', 1),
(261, 39, 2, '2024-01-01 17:33:16', 'IN', 1),
(262, 39, 1, '2024-01-01 16:36:37', 'OUT', 1),
(263, 40, 1, '2024-01-01 09:15:44', 'IN', 1),
(264, 40, 3, '2024-01-01 15:48:44', 'OUT', 1),
(265, 40, 5, '2024-01-01 17:04:44', 'OUT', 1),
(266, 40, 8, '2024-01-01 11:49:44', 'OUT', 1),
(267, 40, 2, '2024-01-01 18:03:44', 'OUT', 1),
(268, 40, 3, '2024-01-01 10:40:44', 'OUT', 1),
(269, 40, 1, '2024-01-01 19:26:16', 'OUT', 1),
(270, 41, 1, '2024-01-01 08:39:08', 'IN', 1),
(271, 41, 8, '2024-01-01 13:11:08', 'IN', 1),
(272, 41, 4, '2024-01-01 10:28:08', 'IN', 1),
(273, 41, 5, '2024-01-01 16:21:08', 'OUT', 1),
(274, 41, 6, '2024-01-01 10:15:08', 'OUT', 0),
(275, 41, 5, '2024-01-01 09:49:08', 'OUT', 0),
(276, 41, 7, '2024-01-01 11:20:08', 'IN', 1),
(277, 41, 4, '2024-01-01 10:09:08', 'OUT', 1),
(278, 41, 1, '2024-01-01 17:12:03', 'OUT', 1),
(279, 42, 1, '2024-01-01 07:40:43', 'IN', 1),
(280, 42, 7, '2024-01-01 09:47:43', 'IN', 1),
(281, 42, 8, '2024-01-01 14:47:43', 'IN', 1),
(282, 42, 4, '2024-01-01 11:37:43', 'IN', 1),
(283, 42, 5, '2024-01-01 10:03:43', 'IN', 1),
(284, 42, 10, '2024-01-01 13:32:43', 'OUT', 1),
(285, 42, 3, '2024-01-01 08:46:43', 'IN', 1),
(286, 42, 6, '2024-01-01 14:31:43', 'IN', 0),
(287, 42, 1, '2024-01-01 17:18:46', 'OUT', 1),
(288, 43, 1, '2024-01-01 09:13:27', 'IN', 1),
(289, 43, 3, '2024-01-01 14:17:27', 'IN', 0),
(290, 43, 2, '2024-01-01 17:09:27', 'IN', 1),
(291, 43, 10, '2024-01-01 14:01:27', 'IN', 1),
(292, 43, 4, '2024-01-01 16:40:27', 'OUT', 0),
(293, 43, 5, '2024-01-01 11:27:27', 'OUT', 1),
(294, 43, 10, '2024-01-01 11:04:27', 'IN', 1),
(295, 43, 1, '2024-01-01 18:40:16', 'OUT', 1),
(296, 44, 1, '2024-01-01 09:39:22', 'IN', 1),
(297, 44, 6, '2024-01-01 13:23:22', 'OUT', 1),
(298, 44, 2, '2024-01-01 11:01:22', 'OUT', 1),
(299, 44, 5, '2024-01-01 17:51:22', 'IN', 1),
(300, 44, 2, '2024-01-01 12:39:22', 'OUT', 0),
(301, 44, 2, '2024-01-01 12:11:22', 'OUT', 1),
(302, 44, 7, '2024-01-01 18:00:22', 'OUT', 1),
(303, 44, 1, '2024-01-01 20:11:18', 'OUT', 1),
(304, 45, 1, '2024-01-01 09:33:58', 'IN', 1),
(305, 45, 2, '2024-01-01 11:25:58', 'OUT', 0),
(306, 45, 4, '2024-01-01 14:18:58', 'IN', 1),
(307, 45, 6, '2024-01-01 17:37:58', 'IN', 0),
(308, 45, 2, '2024-01-01 12:18:58', 'OUT', 1),
(309, 45, 2, '2024-01-01 18:05:58', 'IN', 0),
(310, 45, 1, '2024-01-01 20:09:26', 'OUT', 1),
(311, 46, 1, '2024-01-01 08:40:41', 'IN', 1),
(312, 46, 2, '2024-01-01 10:44:41', 'IN', 1),
(313, 46, 10, '2024-01-01 13:02:41', 'IN', 1),
(314, 46, 3, '2024-01-01 13:42:41', 'IN', 1),
(315, 46, 3, '2024-01-01 10:02:41', 'OUT', 1),
(316, 46, 1, '2024-01-01 18:37:19', 'OUT', 1),
(317, 47, 1, '2024-01-01 09:23:53', 'IN', 1),
(318, 47, 8, '2024-01-01 14:29:53', 'OUT', 1),
(319, 47, 2, '2024-01-01 12:26:53', 'OUT', 1),
(320, 47, 4, '2024-01-01 16:09:53', 'IN', 1),
(321, 47, 5, '2024-01-01 15:22:53', 'IN', 1),
(322, 47, 3, '2024-01-01 13:13:53', 'IN', 1),
(323, 47, 3, '2024-01-01 12:47:53', 'IN', 1),
(324, 47, 1, '2024-01-01 17:40:25', 'OUT', 1),
(325, 48, 1, '2024-01-01 08:21:02', 'IN', 1),
(326, 48, 10, '2024-01-01 17:07:02', 'OUT', 1),
(327, 48, 3, '2024-01-01 15:12:02', 'IN', 0),
(328, 48, 10, '2024-01-01 09:33:02', 'OUT', 0),
(329, 48, 4, '2024-01-01 16:59:02', 'OUT', 1),
(330, 48, 1, '2024-01-01 16:39:33', 'OUT', 1),
(331, 49, 1, '2024-01-01 08:12:44', 'IN', 1),
(332, 49, 2, '2024-01-01 10:08:44', 'OUT', 1),
(333, 49, 6, '2024-01-01 13:03:44', 'OUT', 0),
(334, 49, 1, '2024-01-01 16:45:29', 'OUT', 1),
(335, 50, 1, '2024-01-01 08:56:06', 'IN', 1),
(336, 50, 8, '2024-01-01 15:33:06', 'OUT', 1),
(337, 50, 7, '2024-01-01 16:49:06', 'IN', 1),
(338, 50, 7, '2024-01-01 10:01:06', 'IN', 1),
(339, 50, 2, '2024-01-01 13:53:06', 'IN', 1),
(340, 50, 3, '2024-01-01 17:26:06', 'OUT', 1),
(341, 50, 1, '2024-01-01 17:58:50', 'OUT', 1),
(342, 1, 1, '2024-01-02 08:06:44', 'IN', 1),
(343, 1, 7, '2024-01-02 09:14:44', 'IN', 0),
(344, 1, 8, '2024-01-02 12:19:44', 'IN', 1),
(345, 1, 10, '2024-01-02 15:38:44', 'IN', 1),
(346, 1, 3, '2024-01-02 12:03:44', 'OUT', 1),
(347, 1, 10, '2024-01-02 11:41:44', 'IN', 0),
(348, 1, 6, '2024-01-02 12:24:44', 'IN', 1),
(349, 1, 1, '2024-01-02 19:13:14', 'OUT', 1),
(350, 2, 1, '2024-01-02 09:50:46', 'IN', 1),
(351, 2, 7, '2024-01-02 18:37:46', 'OUT', 1),
(352, 2, 2, '2024-01-02 17:31:46', 'IN', 0),
(353, 2, 2, '2024-01-02 17:24:46', 'OUT', 0),
(354, 2, 8, '2024-01-02 16:03:46', 'IN', 0),
(355, 2, 1, '2024-01-02 17:46:47', 'OUT', 1),
(356, 3, 1, '2024-01-02 07:14:26', 'IN', 1),
(357, 3, 2, '2024-01-02 13:46:26', 'IN', 1),
(358, 3, 10, '2024-01-02 09:51:26', 'IN', 1),
(359, 3, 7, '2024-01-02 10:23:26', 'OUT', 1),
(360, 3, 8, '2024-01-02 09:01:26', 'IN', 1),
(361, 3, 1, '2024-01-02 16:11:03', 'OUT', 1),
(362, 4, 1, '2024-01-02 08:16:24', 'IN', 1),
(363, 4, 6, '2024-01-02 12:00:24', 'IN', 1),
(364, 4, 3, '2024-01-02 10:06:24', 'OUT', 1),
(365, 4, 6, '2024-01-02 13:35:24', 'IN', 1),
(366, 4, 1, '2024-01-02 20:12:13', 'OUT', 1),
(367, 5, 1, '2024-01-02 09:36:16', 'IN', 1),
(368, 5, 6, '2024-01-02 17:51:16', 'IN', 1),
(369, 5, 2, '2024-01-02 11:19:16', 'IN', 1),
(370, 5, 5, '2024-01-02 15:44:16', 'IN', 1),
(371, 5, 5, '2024-01-02 14:27:16', 'IN', 1),
(372, 5, 4, '2024-01-02 16:59:16', 'IN', 1),
(373, 5, 5, '2024-01-02 12:35:16', 'OUT', 1),
(374, 5, 2, '2024-01-02 11:12:16', 'IN', 0),
(375, 5, 4, '2024-01-02 17:44:16', 'IN', 1),
(376, 5, 1, '2024-01-02 16:35:18', 'OUT', 1),
(377, 6, 1, '2024-01-02 09:27:43', 'IN', 1),
(378, 6, 4, '2024-01-02 18:23:43', 'OUT', 1),
(379, 6, 10, '2024-01-02 17:19:43', 'OUT', 1),
(380, 6, 2, '2024-01-02 14:54:43', 'OUT', 1),
(381, 6, 7, '2024-01-02 12:50:43', 'IN', 0),
(382, 6, 2, '2024-01-02 14:48:43', 'OUT', 1),
(383, 6, 2, '2024-01-02 14:26:43', 'OUT', 1),
(384, 6, 6, '2024-01-02 14:46:43', 'IN', 1),
(385, 6, 4, '2024-01-02 11:15:43', 'OUT', 1),
(386, 6, 1, '2024-01-02 16:18:31', 'OUT', 1),
(387, 7, 1, '2024-01-02 09:35:55', 'IN', 1),
(388, 7, 4, '2024-01-02 13:25:55', 'OUT', 1),
(389, 7, 4, '2024-01-02 16:15:55', 'IN', 1),
(390, 7, 5, '2024-01-02 11:58:55', 'IN', 0),
(391, 7, 2, '2024-01-02 12:13:55', 'IN', 1),
(392, 7, 8, '2024-01-02 14:19:55', 'OUT', 1),
(393, 7, 5, '2024-01-02 12:00:55', 'IN', 1),
(394, 7, 6, '2024-01-02 13:54:55', 'OUT', 0),
(395, 7, 1, '2024-01-02 16:32:17', 'OUT', 1),
(396, 8, 1, '2024-01-02 09:02:01', 'IN', 1),
(397, 8, 10, '2024-01-02 14:18:01', 'OUT', 1),
(398, 8, 5, '2024-01-02 15:32:01', 'OUT', 1),
(399, 8, 6, '2024-01-02 13:10:01', 'OUT', 1),
(400, 8, 3, '2024-01-02 11:40:01', 'IN', 1),
(401, 8, 5, '2024-01-02 16:38:01', 'OUT', 1),
(402, 8, 5, '2024-01-02 13:06:01', 'IN', 1),
(403, 8, 5, '2024-01-02 14:14:01', 'IN', 0),
(404, 8, 1, '2024-01-02 17:12:37', 'OUT', 1),
(405, 9, 1, '2024-01-02 07:25:14', 'IN', 1),
(406, 9, 7, '2024-01-02 13:00:14', 'IN', 1),
(407, 9, 2, '2024-01-02 15:37:14', 'OUT', 1),
(408, 9, 8, '2024-01-02 10:57:14', 'OUT', 1),
(409, 9, 1, '2024-01-02 19:42:53', 'OUT', 1),
(410, 10, 1, '2024-01-02 09:51:30', 'IN', 1),
(411, 10, 2, '2024-01-02 17:33:30', 'OUT', 1),
(412, 10, 2, '2024-01-02 12:06:30', 'OUT', 1),
(413, 10, 1, '2024-01-02 17:14:29', 'OUT', 1),
(414, 11, 1, '2024-01-02 08:15:03', 'IN', 1),
(415, 11, 5, '2024-01-02 11:36:03', 'IN', 1),
(416, 11, 2, '2024-01-02 12:05:03', 'IN', 1),
(417, 11, 1, '2024-01-02 17:48:32', 'OUT', 1),
(418, 12, 1, '2024-01-02 09:46:06', 'IN', 1),
(419, 12, 10, '2024-01-02 16:41:06', 'OUT', 1),
(420, 12, 10, '2024-01-02 14:28:06', 'OUT', 1),
(421, 12, 3, '2024-01-02 14:32:06', 'IN', 1),
(422, 12, 4, '2024-01-02 12:28:06', 'OUT', 1),
(423, 12, 1, '2024-01-02 19:32:33', 'OUT', 1),
(424, 13, 1, '2024-01-02 09:25:58', 'IN', 1),
(425, 13, 2, '2024-01-02 14:20:58', 'OUT', 1),
(426, 13, 2, '2024-01-02 17:47:58', 'OUT', 1),
(427, 13, 4, '2024-01-02 11:23:58', 'IN', 1),
(428, 13, 1, '2024-01-02 18:44:04', 'OUT', 1),
(429, 14, 1, '2024-01-02 08:41:09', 'IN', 1),
(430, 14, 2, '2024-01-02 12:55:09', 'IN', 1),
(431, 14, 8, '2024-01-02 16:03:09', 'OUT', 0),
(432, 14, 10, '2024-01-02 14:50:09', 'OUT', 1),
(433, 14, 1, '2024-01-02 20:01:17', 'OUT', 1),
(434, 15, 1, '2024-01-02 09:10:18', 'IN', 1),
(435, 15, 5, '2024-01-02 11:24:18', 'IN', 1),
(436, 15, 4, '2024-01-02 14:01:18', 'IN', 1),
(437, 15, 4, '2024-01-02 13:10:18', 'IN', 1),
(438, 15, 6, '2024-01-02 13:48:18', 'OUT', 1),
(439, 15, 5, '2024-01-02 12:39:18', 'OUT', 0),
(440, 15, 1, '2024-01-02 19:05:23', 'OUT', 1),
(441, 16, 1, '2024-01-02 08:21:09', 'IN', 1),
(442, 16, 5, '2024-01-02 14:09:09', 'IN', 0),
(443, 16, 5, '2024-01-02 12:54:09', 'OUT', 1),
(444, 16, 6, '2024-01-02 14:38:09', 'OUT', 1),
(445, 16, 8, '2024-01-02 14:18:09', 'OUT', 1),
(446, 16, 4, '2024-01-02 12:01:09', 'IN', 1),
(447, 16, 10, '2024-01-02 16:33:09', 'IN', 1),
(448, 16, 1, '2024-01-02 17:37:07', 'OUT', 1),
(449, 17, 1, '2024-01-02 09:07:22', 'IN', 1),
(450, 17, 3, '2024-01-02 12:07:22', 'OUT', 1),
(451, 17, 2, '2024-01-02 10:23:22', 'IN', 1),
(452, 17, 1, '2024-01-02 16:25:52', 'OUT', 1),
(453, 18, 1, '2024-01-02 07:13:31', 'IN', 1),
(454, 18, 7, '2024-01-02 12:04:31', 'IN', 1),
(455, 18, 8, '2024-01-02 11:20:31', 'OUT', 1),
(456, 18, 3, '2024-01-02 09:39:31', 'OUT', 1),
(457, 18, 1, '2024-01-02 16:25:26', 'OUT', 1),
(458, 19, 1, '2024-01-02 07:08:11', 'IN', 1),
(459, 19, 2, '2024-01-02 09:23:11', 'IN', 0),
(460, 19, 5, '2024-01-02 08:47:11', 'IN', 1),
(461, 19, 3, '2024-01-02 11:48:11', 'IN', 0),
(462, 19, 4, '2024-01-02 09:47:11', 'IN', 1),
(463, 19, 7, '2024-01-02 08:59:11', 'IN', 1),
(464, 19, 1, '2024-01-02 20:39:03', 'OUT', 1),
(465, 20, 1, '2024-01-02 08:36:12', 'IN', 1),
(466, 20, 3, '2024-01-02 11:55:12', 'OUT', 1),
(467, 20, 3, '2024-01-02 14:45:12', 'IN', 0),
(468, 20, 3, '2024-01-02 15:23:12', 'IN', 1),
(469, 20, 6, '2024-01-02 10:13:12', 'OUT', 1),
(470, 20, 1, '2024-01-02 20:36:02', 'OUT', 1),
(471, 21, 1, '2024-01-02 08:47:16', 'IN', 1),
(472, 21, 4, '2024-01-02 10:14:16', 'IN', 1),
(473, 21, 10, '2024-01-02 14:28:16', 'IN', 1),
(474, 21, 8, '2024-01-02 16:12:16', 'OUT', 1),
(475, 21, 2, '2024-01-02 10:50:16', 'IN', 1),
(476, 21, 7, '2024-01-02 16:32:16', 'OUT', 1),
(477, 21, 4, '2024-01-02 15:06:16', 'OUT', 1),
(478, 21, 1, '2024-01-02 16:05:56', 'OUT', 1),
(479, 22, 1, '2024-01-02 08:59:27', 'IN', 1),
(480, 22, 8, '2024-01-02 17:16:27', 'IN', 0),
(481, 22, 5, '2024-01-02 15:13:27', 'OUT', 1),
(482, 22, 8, '2024-01-02 16:51:27', 'IN', 0),
(483, 22, 8, '2024-01-02 15:26:27', 'IN', 1),
(484, 22, 1, '2024-01-02 17:59:03', 'OUT', 1),
(485, 23, 1, '2024-01-02 07:40:36', 'IN', 1),
(486, 23, 6, '2024-01-02 09:55:36', 'IN', 1),
(487, 23, 5, '2024-01-02 15:53:36', 'OUT', 1),
(488, 23, 5, '2024-01-02 15:15:36', 'IN', 1),
(489, 23, 3, '2024-01-02 14:26:36', 'IN', 0),
(490, 23, 7, '2024-01-02 11:53:36', 'OUT', 1),
(491, 23, 1, '2024-01-02 17:31:32', 'OUT', 1),
(492, 24, 1, '2024-01-02 09:31:29', 'IN', 1),
(493, 24, 6, '2024-01-02 14:20:29', 'IN', 0),
(494, 24, 5, '2024-01-02 17:48:29', 'OUT', 0),
(495, 24, 4, '2024-01-02 11:33:29', 'OUT', 1),
(496, 24, 8, '2024-01-02 15:37:29', 'IN', 1),
(497, 24, 8, '2024-01-02 15:07:29', 'IN', 0),
(498, 24, 10, '2024-01-02 12:54:29', 'IN', 1),
(499, 24, 10, '2024-01-02 17:07:29', 'IN', 1),
(500, 24, 2, '2024-01-02 16:53:29', 'OUT', 1),
(501, 24, 1, '2024-01-02 18:52:26', 'OUT', 1),
(502, 25, 1, '2024-01-02 07:19:52', 'IN', 1),
(503, 25, 10, '2024-01-02 15:50:52', 'IN', 0),
(504, 25, 4, '2024-01-02 13:25:52', 'OUT', 1),
(505, 25, 7, '2024-01-02 08:33:52', 'IN', 1),
(506, 25, 10, '2024-01-02 13:31:52', 'OUT', 1),
(507, 25, 5, '2024-01-02 11:45:52', 'OUT', 1),
(508, 25, 2, '2024-01-02 11:45:52', 'OUT', 1),
(509, 25, 6, '2024-01-02 10:47:52', 'IN', 1),
(510, 25, 1, '2024-01-02 16:48:04', 'OUT', 1),
(511, 26, 1, '2024-01-02 09:07:11', 'IN', 1),
(512, 26, 8, '2024-01-02 14:09:11', 'IN', 1),
(513, 26, 3, '2024-01-02 14:05:11', 'OUT', 0),
(514, 26, 7, '2024-01-02 12:10:11', 'OUT', 0),
(515, 26, 4, '2024-01-02 11:23:11', 'OUT', 0),
(516, 26, 3, '2024-01-02 13:27:11', 'IN', 1),
(517, 26, 4, '2024-01-02 12:50:11', 'OUT', 1),
(518, 26, 8, '2024-01-02 11:07:11', 'OUT', 1),
(519, 26, 1, '2024-01-02 20:15:02', 'OUT', 1),
(520, 27, 1, '2024-01-02 09:10:09', 'IN', 1),
(521, 27, 7, '2024-01-02 10:47:09', 'IN', 1),
(522, 27, 6, '2024-01-02 11:42:09', 'IN', 0),
(523, 27, 7, '2024-01-02 15:36:09', 'IN', 0),
(524, 27, 6, '2024-01-02 14:27:09', 'OUT', 1),
(525, 27, 7, '2024-01-02 14:19:09', 'IN', 1),
(526, 27, 7, '2024-01-02 16:48:09', 'IN', 1),
(527, 27, 1, '2024-01-02 20:41:12', 'OUT', 1),
(528, 28, 1, '2024-01-02 07:29:16', 'IN', 1),
(529, 28, 8, '2024-01-02 14:35:16', 'OUT', 0),
(530, 28, 3, '2024-01-02 14:39:16', 'IN', 1),
(531, 28, 5, '2024-01-02 15:09:16', 'IN', 1),
(532, 28, 3, '2024-01-02 14:34:16', 'OUT', 1),
(533, 28, 10, '2024-01-02 15:19:16', 'IN', 1),
(534, 28, 2, '2024-01-02 13:00:16', 'OUT', 0),
(535, 28, 1, '2024-01-02 19:13:49', 'OUT', 1),
(536, 29, 1, '2024-01-02 08:18:09', 'IN', 1),
(537, 29, 2, '2024-01-02 09:39:09', 'OUT', 0),
(538, 29, 7, '2024-01-02 15:28:09', 'IN', 0),
(539, 29, 8, '2024-01-02 16:49:09', 'IN', 0),
(540, 29, 3, '2024-01-02 16:25:09', 'IN', 0),
(541, 29, 5, '2024-01-02 12:43:09', 'IN', 1),
(542, 29, 2, '2024-01-02 16:54:09', 'OUT', 0),
(543, 29, 1, '2024-01-02 20:02:29', 'OUT', 1),
(544, 30, 1, '2024-01-02 08:45:21', 'IN', 1),
(545, 30, 6, '2024-01-02 16:35:21', 'IN', 1),
(546, 30, 5, '2024-01-02 10:54:21', 'IN', 0),
(547, 30, 1, '2024-01-02 20:42:17', 'OUT', 1),
(548, 31, 1, '2024-01-02 09:49:00', 'IN', 1),
(549, 31, 4, '2024-01-02 11:48:00', 'IN', 0),
(550, 31, 2, '2024-01-02 18:21:00', 'IN', 1),
(551, 31, 2, '2024-01-02 14:51:00', 'OUT', 1),
(552, 31, 7, '2024-01-02 16:38:00', 'OUT', 0),
(553, 31, 3, '2024-01-02 15:15:00', 'IN', 1),
(554, 31, 10, '2024-01-02 17:59:00', 'IN', 0),
(555, 31, 2, '2024-01-02 15:11:00', 'OUT', 0),
(556, 31, 1, '2024-01-02 20:18:50', 'OUT', 1),
(557, 32, 1, '2024-01-02 08:22:17', 'IN', 1),
(558, 32, 3, '2024-01-02 12:08:17', 'IN', 1),
(559, 32, 2, '2024-01-02 11:14:17', 'OUT', 0),
(560, 32, 1, '2024-01-02 16:58:42', 'OUT', 1),
(561, 33, 1, '2024-01-02 07:29:35', 'IN', 1),
(562, 33, 2, '2024-01-02 10:56:35', 'IN', 1),
(563, 33, 4, '2024-01-02 13:22:35', 'OUT', 0),
(564, 33, 3, '2024-01-02 12:06:35', 'OUT', 1),
(565, 33, 6, '2024-01-02 10:39:35', 'OUT', 1),
(566, 33, 7, '2024-01-02 13:27:35', 'IN', 1),
(567, 33, 5, '2024-01-02 13:45:35', 'IN', 0),
(568, 33, 1, '2024-01-02 17:22:36', 'OUT', 1),
(569, 34, 1, '2024-01-02 07:23:59', 'IN', 1),
(570, 34, 7, '2024-01-02 09:22:59', 'IN', 0),
(571, 34, 6, '2024-01-02 13:58:59', 'OUT', 1),
(572, 34, 10, '2024-01-02 14:09:59', 'OUT', 0),
(573, 34, 1, '2024-01-02 18:53:27', 'OUT', 1),
(574, 35, 1, '2024-01-02 08:35:46', 'IN', 1),
(575, 35, 7, '2024-01-02 10:57:46', 'OUT', 0),
(576, 35, 10, '2024-01-02 15:14:46', 'OUT', 1),
(577, 35, 10, '2024-01-02 12:50:46', 'IN', 0),
(578, 35, 3, '2024-01-02 12:44:46', 'IN', 1),
(579, 35, 10, '2024-01-02 17:30:46', 'OUT', 1),
(580, 35, 3, '2024-01-02 15:59:46', 'IN', 0),
(581, 35, 2, '2024-01-02 16:48:46', 'IN', 1),
(582, 35, 1, '2024-01-02 16:00:39', 'OUT', 1),
(583, 36, 1, '2024-01-02 09:06:21', 'IN', 1),
(584, 36, 2, '2024-01-02 12:34:21', 'IN', 1),
(585, 36, 3, '2024-01-02 12:33:21', 'OUT', 0),
(586, 36, 3, '2024-01-02 11:56:21', 'OUT', 1),
(587, 36, 10, '2024-01-02 16:32:21', 'IN', 1),
(588, 36, 2, '2024-01-02 12:13:21', 'IN', 1),
(589, 36, 2, '2024-01-02 14:24:21', 'IN', 0),
(590, 36, 3, '2024-01-02 11:41:21', 'IN', 1),
(591, 36, 1, '2024-01-02 16:56:59', 'OUT', 1),
(592, 37, 1, '2024-01-02 07:43:00', 'IN', 1),
(593, 37, 4, '2024-01-02 12:27:00', 'OUT', 0),
(594, 37, 10, '2024-01-02 11:24:00', 'OUT', 1),
(595, 37, 7, '2024-01-02 10:25:00', 'IN', 1),
(596, 37, 10, '2024-01-02 14:50:00', 'IN', 0),
(597, 37, 8, '2024-01-02 11:01:00', 'IN', 1),
(598, 37, 8, '2024-01-02 16:06:00', 'OUT', 1),
(599, 37, 1, '2024-01-02 17:24:47', 'OUT', 1),
(600, 38, 1, '2024-01-02 09:13:58', 'IN', 1);
SET IDENTITY_INSERT [dbo].[AccessLog] OFF;

-- [ORDERS]
SET IDENTITY_INSERT [dbo].[Order] ON;
INSERT INTO [dbo].[Order] ([ID], [OrderNumber], [AgentID], [ManagerID], [CreateDate], [OrderStatusID], [PaymentTypeID], [TotalAmount], [DiscountPercent], [IsDeliveryRequired])
VALUES
(1, 'ORD-00001', 14, 12, '20240810', 2, 3, 283418, 10, 1),
(2, 'ORD-00002', 9, 12, '20240302', 9, 2, 204096, 15, 0),
(3, 'ORD-00003', 12, 3, '20240317', 1, 4, 364360, 10, 1),
(4, 'ORD-00004', 12, 6, '20240516', 9, 4, 84978, 0, 1),
(5, 'ORD-00005', 1, 12, '20240219', 3, 4, 110140, 10, 0),
(6, 'ORD-00006', 3, 12, '20240326', 4, 3, 139056, 10, 0),
(7, 'ORD-00007', 13, 6, '20240802', 1, 2, 312553, 10, 0),
(8, 'ORD-00008', 12, 3, '20240726', 3, 1, 244105, 5, 1),
(9, 'ORD-00009', 8, 12, '20241001', 10, 5, 182958, 10, 1),
(10, 'ORD-00010', 19, 12, '20240605', 1, 3, 455428, 15, 1),
(11, 'ORD-00011', 15, 6, '20240531', 4, 1, 382445, 15, 0),
(12, 'ORD-00012', 11, 6, '20240628', 8, 3, 313019, 5, 1),
(13, 'ORD-00013', 14, 12, '20240807', 9, 2, 115779, 15, 1),
(14, 'ORD-00014', 8, 6, '20240616', 7, 3, 94627, 5, 0),
(15, 'ORD-00015', 9, 12, '20240430', 8, 3, 85425, 10, 1),
(16, 'ORD-00016', 8, 12, '20240811', 5, 1, 321535, 0, 0),
(17, 'ORD-00017', 20, 3, '20240219', 7, 1, 300137, 5, 1),
(18, 'ORD-00018', 1, 6, '20240818', 4, 1, 394397, 15, 0),
(19, 'ORD-00019', 12, 12, '20240802', 3, 2, 387156, 15, 0),
(20, 'ORD-00020', 12, 12, '20240625', 5, 1, 242395, 10, 0),
(21, 'ORD-00021', 7, 3, '20240205', 7, 1, 136574, 10, 0),
(22, 'ORD-00022', 18, 6, '20240514', 4, 5, 265584, 5, 1),
(23, 'ORD-00023', 2, 6, '20240307', 9, 5, 399373, 5, 1),
(24, 'ORD-00024', 8, 3, '20240519', 4, 5, 385960, 5, 0),
(25, 'ORD-00025', 1, 12, '20240215', 8, 1, 77097, 15, 0),
(26, 'ORD-00026', 16, 3, '20240309', 10, 3, 305700, 10, 1),
(27, 'ORD-00027', 14, 12, '20240823', 4, 3, 137848, 5, 0),
(28, 'ORD-00028', 20, 12, '20240707', 9, 4, 288424, 0, 0),
(29, 'ORD-00029', 2, 12, '20240424', 8, 2, 489291, 15, 1),
(30, 'ORD-00030', 4, 6, '20240428', 8, 1, 277281, 0, 0),
(31, 'ORD-00031', 12, 12, '20240816', 1, 3, 158136, 10, 1),
(32, 'ORD-00032', 12, 6, '20240417', 6, 3, 171338, 5, 0),
(33, 'ORD-00033', 12, 3, '20240906', 3, 1, 374287, 15, 0),
(34, 'ORD-00034', 5, 3, '20240901', 7, 1, 154296, 15, 0),
(35, 'ORD-00035', 2, 12, '20240818', 8, 1, 79083, 15, 1),
(36, 'ORD-00036', 3, 3, '20240220', 10, 5, 327092, 5, 1),
(37, 'ORD-00037', 14, 6, '20240409', 6, 5, 492421, 5, 0),
(38, 'ORD-00038', 16, 3, '20240824', 6, 2, 102442, 10, 0),
(39, 'ORD-00039', 4, 3, '20240314', 6, 2, 259503, 0, 1),
(40, 'ORD-00040', 11, 3, '20240824', 9, 2, 396913, 0, 1),
(41, 'ORD-00041', 16, 12, '20240624', 9, 3, 374672, 0, 1),
(42, 'ORD-00042', 20, 3, '20240521', 9, 3, 212282, 0, 0),
(43, 'ORD-00043', 17, 12, '20240928', 2, 3, 342099, 0, 1),
(44, 'ORD-00044', 5, 6, '20240717', 7, 3, 236504, 15, 0),
(45, 'ORD-00045', 17, 6, '20240316', 9, 1, 416333, 5, 1),
(46, 'ORD-00046', 6, 3, '20241007', 6, 4, 76735, 15, 0),
(47, 'ORD-00047', 19, 6, '20240102', 8, 5, 65816, 10, 1),
(48, 'ORD-00048', 18, 3, '20240517', 6, 3, 76472, 10, 0),
(49, 'ORD-00049', 14, 6, '20240525', 10, 1, 66740, 0, 0),
(50, 'ORD-00050', 20, 3, '20240127', 1, 1, 115993, 0, 0);
SET IDENTITY_INSERT [dbo].[Order] OFF;

-- [ORDER_ITEMS]
SET IDENTITY_INSERT [dbo].[OrderItem] ON;
INSERT INTO [dbo].[OrderItem] ([ID], [OrderID], [ProductID], [Quantity], [UnitPrice], [TotalPrice], [QualityStatus])
VALUES
(1, 1, NULL, 85, 2574, 218790, 'Passed'),
(2, 1, NULL, 49, 4509, 220941, 'Passed'),
(3, 1, NULL, 43, 2450, 105350, 'Pending'),
(4, 1, NULL, 90, 3783, 340470, 'Failed'),
(5, 1, NULL, 92, 4526, 416392, 'Passed'),
(6, 2, NULL, 2, 579, 1158, 'Passed'),
(7, 2, NULL, 33, 4282, 141306, 'Pending'),
(8, 3, NULL, 13, 1453, 18889, 'Passed'),
(9, 4, NULL, 14, 3147, 44058, 'Pending'),
(10, 4, NULL, 43, 1274, 54782, 'Failed'),
(11, 5, NULL, 38, 3606, 137028, 'Pending'),
(12, 5, NULL, 72, 2225, 160200, 'Failed'),
(13, 5, NULL, 47, 4358, 204826, 'Passed'),
(14, 5, NULL, 42, 3700, 155400, 'Passed'),
(15, 6, NULL, 67, 1975, 132325, 'Passed'),
(16, 6, NULL, 90, 1144, 102960, 'Pending'),
(17, 6, NULL, 83, 4970, 412510, 'Passed'),
(18, 6, NULL, 10, 2228, 22280, 'Passed'),
(19, 7, NULL, 38, 3494, 132772, 'Passed'),
(20, 7, NULL, 75, 4629, 347175, 'Passed'),
(21, 8, NULL, 6, 3012, 18072, 'Pending'),
(22, 8, NULL, 74, 3787, 280238, 'Passed'),
(23, 9, NULL, 84, 3294, 276696, 'Failed'),
(24, 9, NULL, 13, 4847, 63011, 'Pending'),
(25, 9, NULL, 57, 2793, 159201, 'Passed'),
(26, 9, NULL, 14, 1103, 15442, 'Passed'),
(27, 9, NULL, 64, 3616, 231424, 'Passed'),
(28, 10, NULL, 30, 1607, 48210, 'Passed'),
(29, 10, NULL, 61, 2457, 149877, 'Passed'),
(30, 11, NULL, 71, 1402, 99542, 'Passed'),
(31, 11, NULL, 50, 1237, 61850, 'Passed'),
(32, 11, NULL, 3, 1206, 3618, 'Pending'),
(33, 11, NULL, 65, 723, 46995, 'Failed'),
(34, 12, NULL, 92, 3101, 285292, 'Passed'),
(35, 13, NULL, 14, 986, 13804, 'Pending'),
(36, 14, NULL, 9, 2251, 20259, 'Passed'),
(37, 14, NULL, 26, 873, 22698, 'Passed'),
(38, 14, NULL, 50, 2193, 109650, 'Passed'),
(39, 14, NULL, 28, 4886, 136808, 'Failed'),
(40, 15, NULL, 16, 4293, 68688, 'Passed'),
(41, 15, NULL, 12, 1813, 21756, 'Passed'),
(42, 15, NULL, 64, 4591, 293824, 'Failed'),
(43, 15, NULL, 97, 2127, 206319, 'Passed'),
(44, 16, NULL, 25, 1343, 33575, 'Pending'),
(45, 16, NULL, 28, 2952, 82656, 'Passed'),
(46, 16, NULL, 97, 2370, 229890, 'Failed'),
(47, 16, NULL, 22, 3609, 79398, 'Passed'),
(48, 16, NULL, 55, 3862, 212410, 'Passed'),
(49, 17, NULL, 96, 3361, 322656, 'Passed'),
(50, 17, NULL, 35, 1989, 69615, 'Pending');
SET IDENTITY_INSERT [dbo].[OrderItem] OFF;

-- [PRODUCTION_TASKS]
SET IDENTITY_INSERT [dbo].[ProductionTask] ON;
INSERT INTO [dbo].[ProductionTask] ([ID], [OrderItemID], [WorkshopID], [ResponsibleEmployeeID], [PlannedStartDate], [PlannedEndDate], [Status], [Priority])
VALUES
(1, NULL, NULL, NULL, '20240307', '20240320', 'Completed', 10),
(2, NULL, NULL, NULL, '20240308', '20240313', 'InProgress', 5),
(3, NULL, NULL, NULL, '20240520', '20240523', 'InProgress', 8),
(4, NULL, NULL, NULL, '20240519', '20240522', 'Completed', 1),
(5, NULL, NULL, NULL, '20241003', '20241017', 'Completed', 3),
(6, NULL, NULL, NULL, '20241008', '20241011', 'InProgress', 8),
(7, NULL, NULL, NULL, '20241006', '20241013', 'InProgress', 6),
(8, NULL, NULL, NULL, '20241003', '20241010', 'Completed', 3),
(9, NULL, NULL, NULL, '20241004', '20241016', 'Completed', 9),
(10, NULL, NULL, NULL, '20240630', '20240708', 'Completed', 5),
(11, NULL, NULL, NULL, '20240809', '20240815', 'Completed', 8),
(12, NULL, NULL, NULL, '20240619', '20240626', 'InProgress', 5),
(13, NULL, NULL, NULL, '20240622', '20240703', 'Planned', 2),
(14, NULL, NULL, NULL, '20240620', '20240628', 'InProgress', 8),
(15, NULL, NULL, NULL, '20240620', '20240624', 'Completed', 10),
(16, NULL, NULL, NULL, '20240506', '20240518', 'Planned', 1),
(17, NULL, NULL, NULL, '20240501', '20240511', 'InProgress', 7),
(18, NULL, NULL, NULL, '20240501', '20240512', 'Completed', 2),
(19, NULL, NULL, NULL, '20240503', '20240509', 'Planned', 1),
(20, NULL, NULL, NULL, '20240814', '20240816', 'Planned', 3),
(21, NULL, NULL, NULL, '20240815', '20240826', 'Planned', 1),
(22, NULL, NULL, NULL, '20240814', '20240821', 'Completed', 6),
(23, NULL, NULL, NULL, '20240818', '20240821', 'InProgress', 2),
(24, NULL, NULL, NULL, '20240818', '20240827', 'InProgress', 1),
(25, NULL, NULL, NULL, '20240226', '20240306', 'Planned', 1),
(26, NULL, NULL, NULL, '20240226', '20240304', 'InProgress', 9),
(27, NULL, NULL, NULL, '20240630', '20240709', 'InProgress', 3),
(28, NULL, NULL, NULL, '20240211', '20240214', 'Planned', 4),
(29, NULL, NULL, NULL, '20240209', '20240215', 'Completed', 6),
(30, NULL, NULL, NULL, '20240309', '20240320', 'Planned', 10),
(31, NULL, NULL, NULL, '20240216', '20240226', 'Planned', 6),
(32, NULL, NULL, NULL, '20240221', '20240224', 'InProgress', 10),
(33, NULL, NULL, NULL, '20240220', '20240305', 'InProgress', 1),
(34, NULL, NULL, NULL, '20240222', '20240229', 'InProgress', 10),
(35, NULL, NULL, NULL, '20240310', '20240316', 'InProgress', 3),
(36, NULL, NULL, NULL, '20240709', '20240719', 'Completed', 2),
(37, NULL, NULL, NULL, '20240710', '20240718', 'InProgress', 4),
(38, NULL, NULL, NULL, '20240709', '20240719', 'InProgress', 1),
(39, NULL, NULL, NULL, '20240712', '20240726', 'Completed', 5),
(40, NULL, NULL, NULL, '20240709', '20240716', 'Completed', 3),
(41, NULL, NULL, NULL, '20240428', '20240430', 'Completed', 6),
(42, NULL, NULL, NULL, '20240427', '20240428', 'Planned', 7),
(43, NULL, NULL, NULL, '20240430', '20240509', 'Planned', 7),
(44, NULL, NULL, NULL, '20240427', '20240502', 'Completed', 9),
(45, NULL, NULL, NULL, '20240430', '20240502', 'Completed', 1),
(46, NULL, NULL, NULL, '20240505', '20240513', 'InProgress', 8),
(47, NULL, NULL, NULL, '20240418', '20240429', 'InProgress', 1),
(48, NULL, NULL, NULL, '20240424', '20240426', 'InProgress', 3),
(49, NULL, NULL, NULL, '20240421', '20240504', 'Completed', 5),
(50, NULL, NULL, NULL, '20240420', '20240426', 'Completed', 8);
SET IDENTITY_INSERT [dbo].[ProductionTask] OFF;

-- Представление для дашборда
CREATE VIEW DashboardMetrics AS
SELECT 
    (SELECT COUNT(*) FROM [Order] WHERE CreateDate >= CAST(GETDATE() AS DATE)) as TodayOrders,
    (SELECT COUNT(*) FROM [Order] WHERE OrderStatusID = 5) as InProduction,
    (SELECT COUNT(*) FROM Employee WHERE IsActive = 1) as ActiveEmployees,
    (SELECT COUNT(*) FROM Material WHERE CountInStock < MinCount) as LowStockMaterials,
    (SELECT SUM(TotalAmount) FROM [Order] WHERE MONTH(CreateDate) = MONTH(GETDATE()) AND YEAR(CreateDate) = YEAR(GETDATE())) as MonthlyRevenue;

-- ==========================================
-- СЛОЖНЫЕ АНАЛИТИЧЕСКИЕ ЗАПРОСЫ
-- ==========================================

-- ТОП АГЕНТОВ ПО ПРОДАЖАМ
WITH AgentSalesStats AS (
    SELECT 
        a.ID as AgentID,
        a.FirstName as AgentName,
        COUNT(DISTINCT o.ID) as OrderCount,
        SUM(o.TotalAmount) as TotalSales,
        MAX(o.CreateDate) as LastOrderDate
    FROM Agent a
    LEFT JOIN [Order] o ON a.ID = o.AgentID
    GROUP BY a.ID, a.FirstName
)
SELECT 
    ROW_NUMBER() OVER (ORDER BY TotalSales DESC) as Rating,
    AgentName,
    OrderCount,
    TotalSales,
    DATEDIFF(DAY, LastOrderDate, GETDATE()) as DaysSinceLastOrder,
    CASE 
        WHEN TotalSales > 1000000 THEN 'Платиновый'
        WHEN TotalSales > 500000 THEN 'Золотой'
        WHEN TotalSales > 200000 THEN 'Серебряный'
        ELSE 'Бронзовый'
    END as ClientStatus
FROM AgentSalesStats
WHERE TotalSales > 0 OR OrderCount > 0
ORDER BY TotalSales DESC;

-- АНАЛИЗ ЗАГРУЗКИ ПРОИЗВОДСТВЕННЫХ МОЩНОСТЕЙ
SELECT 
    w.Name as WorkshopName,
    w.MaxCapacity,
    COUNT(pt.ID) as ActiveTasks,
    ROUND(CAST(COUNT(pt.ID) AS FLOAT) / w.MaxCapacity * 100, 2) as LoadPercentage,
    AVG(DATEDIFF(DAY, pt.PlannedStartDate, pt.PlannedEndDate)) as AvgTaskDuration,
    SUM(CASE WHEN pt.Status = 'Completed' THEN 1 ELSE 0 END) as CompletedTasks,
    SUM(CASE WHEN pt.Status = 'InProgress' THEN 1 ELSE 0 END) as InProgressTasks,
    SUM(CASE WHEN pt.PlannedEndDate < GETDATE() AND pt.Status != 'Completed' THEN 1 ELSE 0 END) as OverdueTasks
FROM Workshop w
LEFT JOIN ProductionTask pt ON w.ID = pt.WorkshopID 
    AND pt.PlannedStartDate >= DATEADD(MONTH, -3, GETDATE())
GROUP BY w.ID, w.Name, w.MaxCapacity
ORDER BY LoadPercentage DESC;

-- АНАЛИТИКА ПОСЕЩАЕМОСТИ И ПУНКТУАЛЬНОСТИ СОТРУДНИКОВ
WITH EmployeeAttendance AS (
    SELECT 
        e.ID as EmployeeID,
        e.FirstName + ' ' + e.LastName as EmployeeName,
        d.Name as Department,
        p.Title as Position,
        COUNT(DISTINCT CAST(al.AccessTime AS DATE)) as WorkDays,
        MIN(al.AccessTime) as FirstAccess,
        MAX(al.AccessTime) as LastAccess
    FROM Employee e
    LEFT JOIN Department d ON e.DepartmentID = d.ID
    LEFT JOIN Position p ON e.PositionID = p.ID
    LEFT JOIN AccessLog al ON e.ID = al.EmployeeID
    GROUP BY e.ID, e.FirstName, e.LastName, d.Name, p.Title
)
SELECT 
    EmployeeName,
    Department,
    Position,
    WorkDays,
    FirstAccess,
    LastAccess,
    CASE 
        WHEN WorkDays > 0 THEN 'Есть данные'
        ELSE 'Нет данных в AccessLog'
    END as Status
FROM EmployeeAttendance
ORDER BY WorkDays DESC;

-- ФИНАНСОВАЯ АНАЛИТИКА ПО ЗАКАЗАМ
SELECT 
    YEAR(o.CreateDate) as Year,
    MONTH(o.CreateDate) as Month,
    DATENAME(MONTH, o.CreateDate) as MonthName,
    COUNT(o.ID) as OrderCount,
    SUM(o.TotalAmount) as TotalRevenue,
    SUM(o.PaidAmount) as PaidAmount,
    SUM(o.TotalAmount - o.PaidAmount) as Debt,
    AVG(o.TotalAmount) as AvgOrderAmount,
    SUM(CASE WHEN o.OrderStatusID = 9 THEN o.TotalAmount ELSE 0 END) as CompletedRevenue,
    COUNT(CASE WHEN o.OrderStatusID = 10 THEN 1 END) as CancelledOrders,
    ROUND(
        CAST(COUNT(CASE WHEN o.OrderStatusID = 9 THEN 1 END) AS FLOAT) / 
        COUNT(o.ID) * 100, 2
    ) as CompletionRate
FROM [Order] o
WHERE o.CreateDate >= DATEADD(YEAR, -2, GETDATE())
GROUP BY YEAR(o.CreateDate), MONTH(o.CreateDate), DATENAME(MONTH, o.CreateDate)
ORDER BY Year DESC, Month DESC;