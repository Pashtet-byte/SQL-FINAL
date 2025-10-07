CREATE DATABASE FactoryDB
USE FactoryDB

-- ОСНОВНЫЕ ТАБЛИЦЫ
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[AgentType](
    [ID] [int] IDENTITY(1,1) NOT NULL,
    [Title] [nvarchar](50) NOT NULL,
    [Image] [nvarchar](100) NULL,
 CONSTRAINT [PK_AgentType] PRIMARY KEY CLUSTERED ([ID] ASC)
);

CREATE TABLE [dbo].[Agent](
    [ID] [int] IDENTITY(1,1) NOT NULL,
    [Title] [nvarchar](150) NOT NULL,
    [AgentTypeID] [int] NOT NULL,
    [Address] [nvarchar](300) NULL,
    [INN] [varchar](12) NOT NULL,
    [KPP] [varchar](9) NULL,
    [DirectorName] [nvarchar](100) NULL,
    [Phone] [nvarchar](20) NOT NULL,
    [Email] [nvarchar](255) NULL,
    [Logo] [nvarchar](100) NULL,
    [Priority] [int] NOT NULL,
 CONSTRAINT [PK_Agent] PRIMARY KEY CLUSTERED ([ID] ASC)
);

CREATE TABLE [dbo].[AgentPriorityHistory](
    [ID] [int] IDENTITY(1,1) NOT NULL,
    [AgentID] [int] NOT NULL,
    [ChangeDate] [datetime] NOT NULL,
    [PriorityValue] [int] NOT NULL,
 CONSTRAINT [PK_AgentPriorityHistory] PRIMARY KEY CLUSTERED ([ID] ASC)
);

CREATE TABLE [dbo].[MaterialType](
    [ID] [int] IDENTITY(1,1) NOT NULL,
    [Title] [nvarchar](50) NOT NULL,
    [DefectedPercent] [float] NOT NULL,
 CONSTRAINT [PK_MaterialType] PRIMARY KEY CLUSTERED ([ID] ASC)
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
 CONSTRAINT [PK_Material] PRIMARY KEY CLUSTERED ([ID] ASC)
);

CREATE TABLE [dbo].[MaterialCountHistory](
    [ID] [int] IDENTITY(1,1) NOT NULL,
    [MaterialID] [int] NOT NULL,
    [ChangeDate] [datetime] NOT NULL,
    [CountValue] [float] NOT NULL,
 CONSTRAINT [PK_MaterialCountHistory] PRIMARY KEY CLUSTERED ([ID] ASC)
);

CREATE TABLE [dbo].[Supplier](
    [ID] [int] IDENTITY(1,1) NOT NULL,
    [Title] [nvarchar](150) NOT NULL,
    [INN] [varchar](12) NOT NULL,
    [StartDate] [date] NOT NULL,
    [QualityRating] [int] NULL,
    [SupplierType] [nvarchar](20) NULL,
 CONSTRAINT [PK_Supplier] PRIMARY KEY CLUSTERED ([ID] ASC)
);

CREATE TABLE [dbo].[MaterialSupplier](
    [MaterialID] [int] NOT NULL,
    [SupplierID] [int] NOT NULL,
 CONSTRAINT [PK_MaterialSupplier] PRIMARY KEY CLUSTERED ([MaterialID] ASC, [SupplierID] ASC)
);

CREATE TABLE [dbo].[ProductType](
    [ID] [int] IDENTITY(1,1) NOT NULL,
    [Title] [nvarchar](50) NOT NULL,
    [DefectedPercent] [float] NOT NULL,
 CONSTRAINT [PK_ProductType] PRIMARY KEY CLUSTERED ([ID] ASC)
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
 CONSTRAINT [PK_Product] PRIMARY KEY CLUSTERED ([ID] ASC)
);

CREATE TABLE [dbo].[ProductCostHistory](
    [ID] [int] IDENTITY(1,1) NOT NULL,
    [ProductID] [int] NOT NULL,
    [ChangeDate] [datetime] NOT NULL,
    [CostValue] [decimal](10, 2) NOT NULL,
 CONSTRAINT [PK_ProductCostHistory] PRIMARY KEY CLUSTERED ([ID] ASC)
);

CREATE TABLE [dbo].[ProductMaterial](
    [ProductID] [int] NOT NULL,
    [MaterialID] [int] NOT NULL,
    [Count] [float] NULL,
 CONSTRAINT [PK_ProductMaterial] PRIMARY KEY CLUSTERED ([ProductID] ASC, [MaterialID] ASC)
);

CREATE TABLE [dbo].[ProductSale](
    [ID] [int] IDENTITY(1,1) NOT NULL,
    [AgentID] [int] NOT NULL,
    [ProductID] [int] NOT NULL,
    [SaleDate] [date] NOT NULL,
    [ProductCount] [int] NOT NULL,
 CONSTRAINT [PK_ProductSale] PRIMARY KEY CLUSTERED ([ID] ASC)
);

CREATE TABLE [dbo].[Shop](
    [ID] [int] IDENTITY(1,1) NOT NULL,
    [Title] [nvarchar](150) NOT NULL,
    [Address] [nvarchar](300) NULL,
    [AgentID] [int] NOT NULL,
 CONSTRAINT [PK_Shop] PRIMARY KEY CLUSTERED ([ID] ASC)
);

-- РАСШИРЕННЫЕ ТАБЛИЦЫ СИСТЕМЫ
CREATE TABLE [dbo].[UserRoles](
    [RoleID] [int] IDENTITY(1,1) NOT NULL,
    [RoleName] [nvarchar](50) NOT NULL,
    [Description] [nvarchar](200) NULL,
 CONSTRAINT [PK_UserRoles] PRIMARY KEY CLUSTERED ([RoleID] ASC)
);

CREATE TABLE [dbo].[SystemUsers](
    [UserID] [int] IDENTITY(1,1) NOT NULL,
    [Username] [nvarchar](50) NOT NULL,
    [PasswordHash] [nvarchar](255) NOT NULL,
    [Email] [nvarchar](255) NULL,
    [RoleID] [int] NOT NULL,
    [EmployeeID] [int] NULL,
    [IsActive] [bit] NOT NULL DEFAULT 1,
    [LastLogin] [datetime] NULL,
    [CreatedDate] [datetime] NOT NULL DEFAULT GETDATE(),
 CONSTRAINT [PK_SystemUsers] PRIMARY KEY CLUSTERED ([UserID] ASC)
);

CREATE TABLE [dbo].[Permissions](
    [PermissionID] [int] IDENTITY(1,1) NOT NULL,
    [PermissionName] [nvarchar](100) NOT NULL,
    [Description] [nvarchar](200) NULL,
 CONSTRAINT [PK_Permissions] PRIMARY KEY CLUSTERED ([PermissionID] ASC)
);

CREATE TABLE [dbo].[RolePermissions](
    [RoleID] [int] NOT NULL,
    [PermissionID] [int] NOT NULL,
 CONSTRAINT [PK_RolePermissions] PRIMARY KEY CLUSTERED ([RoleID] ASC, [PermissionID] ASC)
);

CREATE TABLE [dbo].[AgentExtended](
    [AgentID] [int] NOT NULL,
    [SalesVolume] [decimal](15,2) NOT NULL DEFAULT 0,
    [DiscountRate] [decimal](5,2) NOT NULL DEFAULT 0,
    [ActiveShopsCount] [int] NOT NULL DEFAULT 0,
    [PerformanceRating] [int] NOT NULL DEFAULT 0,
    [LastOrderDate] [date] NULL,
    [TotalOrders] [int] NOT NULL DEFAULT 0,
    [TotalRevenue] [decimal](15,2) NOT NULL DEFAULT 0,
 CONSTRAINT [PK_AgentExtended] PRIMARY KEY CLUSTERED ([AgentID] ASC)
);

CREATE TABLE [dbo].[DiscountRules](
    [RuleID] [int] IDENTITY(1,1) NOT NULL,
    [MinSalesVolume] [decimal](15,2) NOT NULL,
    [MaxSalesVolume] [decimal](15,2) NULL,
    [DiscountPercent] [decimal](5,2) NOT NULL,
    [EffectiveDate] [date] NOT NULL,
    [ExpiryDate] [date] NULL,
    [IsActive] [bit] NOT NULL DEFAULT 1,
 CONSTRAINT [PK_DiscountRules] PRIMARY KEY CLUSTERED ([RuleID] ASC)
);

CREATE TABLE [dbo].[ProductionPlan](
    [PlanID] [int] IDENTITY(1,1) NOT NULL,
    [ProductID] [int] NOT NULL,
    [PlannedQuantity] [int] NOT NULL,
    [StartDate] [date] NOT NULL,
    [EndDate] [date] NOT NULL,
    [WorkshopNumber] [int] NOT NULL,
    [RequiredPersonnel] [int] NOT NULL,
    [Status] [nvarchar](20) NOT NULL DEFAULT 'PLANNED',
    [ActualStartDate] [date] NULL,
    [ActualEndDate] [date] NULL,
    [CompletedQuantity] [int] NOT NULL DEFAULT 0,
 CONSTRAINT [PK_ProductionPlan] PRIMARY KEY CLUSTERED ([PlanID] ASC)
);

CREATE TABLE [dbo].[ProductSpecification](
    [SpecificationID] [int] IDENTITY(1,1) NOT NULL,
    [ProductID] [int] NOT NULL,
    [MaterialID] [int] NOT NULL,
    [RequiredQuantity] [decimal](10,3) NOT NULL,
    [WastePercent] [decimal](5,2) NOT NULL DEFAULT 0,
    [Unit] [nvarchar](10) NOT NULL,
 CONSTRAINT [PK_ProductSpecification] PRIMARY KEY CLUSTERED ([SpecificationID] ASC)
);

CREATE TABLE [dbo].[QualityControl](
    [ControlID] [int] IDENTITY(1,1) NOT NULL,
    [ProductID] [int] NOT NULL,
    [BatchNumber] [nvarchar](50) NOT NULL,
    [ControlDate] [date] NOT NULL,
    [InspectorID] [int] NOT NULL,
    [Result] [nvarchar](20) NOT NULL,
    [DefectsCount] [int] NOT NULL DEFAULT 0,
    [Notes] [nvarchar](500) NULL,
    [ProductionPlanID] [int] NULL,
 CONSTRAINT [PK_QualityControl] PRIMARY KEY CLUSTERED ([ControlID] ASC)
);

CREATE TABLE [dbo].[DeliverySchedule](
    [DeliveryID] [int] IDENTITY(1,1) NOT NULL,
    [ProductSaleID] [int] NOT NULL,
    [AgentID] [int] NOT NULL,
    [PlannedDate] [date] NOT NULL,
    [ActualDate] [date] NULL,
    [DeliveryAddress] [nvarchar](300) NOT NULL,
    [Status] [nvarchar](20) NOT NULL DEFAULT 'PLANNED',
    [TransportType] [nvarchar](50) NULL,
    [DriverName] [nvarchar](100) NULL,
    [ContactPhone] [nvarchar](20) NULL,
 CONSTRAINT [PK_DeliverySchedule] PRIMARY KEY CLUSTERED ([DeliveryID] ASC)
);

CREATE TABLE [dbo].[ProductOrder](
    [OrderID] [int] IDENTITY(1,1) NOT NULL,
    [AgentID] [int] NOT NULL,
    [OrderDate] [date] NOT NULL,
    [RequiredDate] [date] NOT NULL,
    [Status] [nvarchar](20) NOT NULL DEFAULT 'NEW',
    [TotalAmount] [decimal](15,2) NOT NULL DEFAULT 0,
    [DiscountAmount] [decimal](15,2) NOT NULL DEFAULT 0,
    [FinalAmount] [decimal](15,2) NOT NULL DEFAULT 0,
    [ManagerID] [int] NULL,
    [Notes] [nvarchar](500) NULL,
 CONSTRAINT [PK_ProductOrder] PRIMARY KEY CLUSTERED ([OrderID] ASC)
);

CREATE TABLE [dbo].[OrderDetails](
    [OrderDetailID] [int] IDENTITY(1,1) NOT NULL,
    [OrderID] [int] NOT NULL,
    [ProductID] [int] NOT NULL,
    [Quantity] [int] NOT NULL,
    [UnitPrice] [decimal](10,2) NOT NULL,
    [Discount] [decimal](5,2) NOT NULL DEFAULT 0,
    [LineTotal] [decimal](15,2) NOT NULL,
 CONSTRAINT [PK_OrderDetails] PRIMARY KEY CLUSTERED ([OrderDetailID] ASC)
);

CREATE TABLE [dbo].[MaterialPurchase](
    [PurchaseID] [int] IDENTITY(1,1) NOT NULL,
    [SupplierID] [int] NOT NULL,
    [MaterialID] [int] NOT NULL,
    [OrderDate] [date] NOT NULL,
    [ExpectedDate] [date] NOT NULL,
    [ReceivedDate] [date] NULL,
    [Quantity] [decimal](10,3) NOT NULL,
    [UnitPrice] [decimal](10,2) NOT NULL,
    [TotalAmount] [decimal](15,2) NOT NULL,
    [Status] [nvarchar](20) NOT NULL DEFAULT 'ORDERED',
    [QualityRating] [int] NULL,
 CONSTRAINT [PK_MaterialPurchase] PRIMARY KEY CLUSTERED ([PurchaseID] ASC)
);

CREATE TABLE [dbo].[Employee](
    [EmployeeID] [int] IDENTITY(1,1) NOT NULL,
    [FirstName] [nvarchar](50) NOT NULL,
    [LastName] [nvarchar](50) NOT NULL,
    [MiddleName] [nvarchar](50) NULL,
    [Position] [nvarchar](100) NOT NULL,
    [Department] [nvarchar](100) NOT NULL,
    [HireDate] [date] NOT NULL,
    [BirthDate] [date] NULL,
    [Phone] [nvarchar](20) NULL,
    [Email] [nvarchar](255) NULL,
    [WorkshopNumber] [int] NULL,
    [IsActive] [bit] NOT NULL DEFAULT 1,
 CONSTRAINT [PK_Employee] PRIMARY KEY CLUSTERED ([EmployeeID] ASC)
);

-- ВНЕШНИЕ КЛЮЧИ
ALTER TABLE [dbo].[Agent] ADD CONSTRAINT [FK_Agent_AgentType] FOREIGN KEY([AgentTypeID]) REFERENCES [dbo].[AgentType] ([ID]);
ALTER TABLE [dbo].[AgentPriorityHistory] ADD CONSTRAINT [FK_AgentPriorityHistory_Agent] FOREIGN KEY([AgentID]) REFERENCES [dbo].[Agent] ([ID]);
ALTER TABLE [dbo].[Material] ADD CONSTRAINT [FK_Material_MaterialType] FOREIGN KEY([MaterialTypeID]) REFERENCES [dbo].[MaterialType] ([ID]);
ALTER TABLE [dbo].[MaterialCountHistory] ADD CONSTRAINT [FK_MaterialCountHistory_Material] FOREIGN KEY([MaterialID]) REFERENCES [dbo].[Material] ([ID]);
ALTER TABLE [dbo].[MaterialSupplier] ADD CONSTRAINT [FK_MaterialSupplier_Material] FOREIGN KEY([MaterialID]) REFERENCES [dbo].[Material] ([ID]);
ALTER TABLE [dbo].[MaterialSupplier] ADD CONSTRAINT [FK_MaterialSupplier_Supplier] FOREIGN KEY([SupplierID]) REFERENCES [dbo].[Supplier] ([ID]);
ALTER TABLE [dbo].[Product] ADD CONSTRAINT [FK_Product_ProductType] FOREIGN KEY([ProductTypeID]) REFERENCES [dbo].[ProductType] ([ID]);
ALTER TABLE [dbo].[ProductCostHistory] ADD CONSTRAINT [FK_ProductCostHistory_Product] FOREIGN KEY([ProductID]) REFERENCES [dbo].[Product] ([ID]);
ALTER TABLE [dbo].[ProductMaterial] ADD CONSTRAINT [FK_ProductMaterial_Material] FOREIGN KEY([MaterialID]) REFERENCES [dbo].[Material] ([ID]);
ALTER TABLE [dbo].[ProductMaterial] ADD CONSTRAINT [FK_ProductMaterial_Product] FOREIGN KEY([ProductID]) REFERENCES [dbo].[Product] ([ID]);
ALTER TABLE [dbo].[ProductSale] ADD CONSTRAINT [FK_ProductSale_Agent] FOREIGN KEY([AgentID]) REFERENCES [dbo].[Agent] ([ID]);
ALTER TABLE [dbo].[ProductSale] ADD CONSTRAINT [FK_ProductSale_Product] FOREIGN KEY([ProductID]) REFERENCES [dbo].[Product] ([ID]);
ALTER TABLE [dbo].[Shop] ADD CONSTRAINT [FK_Shop_Agent] FOREIGN KEY([AgentID]) REFERENCES [dbo].[Agent] ([ID]);
ALTER TABLE [dbo].[SystemUsers] ADD CONSTRAINT [FK_SystemUsers_UserRoles] FOREIGN KEY([RoleID]) REFERENCES [dbo].[UserRoles] ([RoleID]);
ALTER TABLE [dbo].[SystemUsers] ADD CONSTRAINT [FK_SystemUsers_Employee] FOREIGN KEY([EmployeeID]) REFERENCES [dbo].[Employee] ([EmployeeID]);
ALTER TABLE [dbo].[AgentExtended] ADD CONSTRAINT [FK_AgentExtended_Agent] FOREIGN KEY([AgentID]) REFERENCES [dbo].[Agent] ([ID]);
ALTER TABLE [dbo].[ProductionPlan] ADD CONSTRAINT [FK_ProductionPlan_Product] FOREIGN KEY([ProductID]) REFERENCES [dbo].[Product] ([ID]);
ALTER TABLE [dbo].[ProductSpecification] ADD CONSTRAINT [FK_ProductSpecification_Product] FOREIGN KEY([ProductID]) REFERENCES [dbo].[Product] ([ID]);
ALTER TABLE [dbo].[ProductSpecification] ADD CONSTRAINT [FK_ProductSpecification_Material] FOREIGN KEY([MaterialID]) REFERENCES [dbo].[Material] ([ID]);
ALTER TABLE [dbo].[QualityControl] ADD CONSTRAINT [FK_QualityControl_Product] FOREIGN KEY([ProductID]) REFERENCES [dbo].[Product] ([ID]);
ALTER TABLE [dbo].[QualityControl] ADD CONSTRAINT [FK_QualityControl_ProductionPlan] FOREIGN KEY([ProductionPlanID]) REFERENCES [dbo].[ProductionPlan] ([PlanID]);
ALTER TABLE [dbo].[QualityControl] ADD CONSTRAINT [FK_QualityControl_Employee] FOREIGN KEY([InspectorID]) REFERENCES [dbo].[Employee] ([EmployeeID]);
ALTER TABLE [dbo].[DeliverySchedule] ADD CONSTRAINT [FK_DeliverySchedule_ProductSale] FOREIGN KEY([ProductSaleID]) REFERENCES [dbo].[ProductSale] ([ID]);
ALTER TABLE [dbo].[DeliverySchedule] ADD CONSTRAINT [FK_DeliverySchedule_Agent] FOREIGN KEY([AgentID]) REFERENCES [dbo].[Agent] ([ID]);
ALTER TABLE [dbo].[ProductOrder] ADD CONSTRAINT [FK_ProductOrder_Agent] FOREIGN KEY([AgentID]) REFERENCES [dbo].[Agent] ([ID]);
ALTER TABLE [dbo].[ProductOrder] ADD CONSTRAINT [FK_ProductOrder_SystemUsers] FOREIGN KEY([ManagerID]) REFERENCES [dbo].[SystemUsers] ([UserID]);
ALTER TABLE [dbo].[OrderDetails] ADD CONSTRAINT [FK_OrderDetails_ProductOrder] FOREIGN KEY([OrderID]) REFERENCES [dbo].[ProductOrder] ([OrderID]);
ALTER TABLE [dbo].[OrderDetails] ADD CONSTRAINT [FK_OrderDetails_Product] FOREIGN KEY([ProductID]) REFERENCES [dbo].[Product] ([ID]);
ALTER TABLE [dbo].[MaterialPurchase] ADD CONSTRAINT [FK_MaterialPurchase_Supplier] FOREIGN KEY([SupplierID]) REFERENCES [dbo].[Supplier] ([ID]);
ALTER TABLE [dbo].[MaterialPurchase] ADD CONSTRAINT [FK_MaterialPurchase_Material] FOREIGN KEY([MaterialID]) REFERENCES [dbo].[Material] ([ID]);
ALTER TABLE [dbo].[RolePermissions] ADD CONSTRAINT [FK_RolePermissions_UserRoles] FOREIGN KEY([RoleID]) REFERENCES [dbo].[UserRoles] ([RoleID]);
ALTER TABLE [dbo].[RolePermissions] ADD CONSTRAINT [FK_RolePermissions_Permissions] FOREIGN KEY([PermissionID]) REFERENCES [dbo].[Permissions] ([PermissionID]);

-- ДОБАВЛЕНИЕ ВСЕХ ДАННЫХ ИЗ MATERIALS_K_IMPORT.CSV
INSERT INTO [dbo].[MaterialType] ([Title], [DefectedPercent])
SELECT DISTINCT [Тип материала], 0.0
FROM (VALUES
    ('Гранулы', 0.0),
    ('Краски', 0.0),
    ('Нитки', 0.0)
) AS types([Тип материала], [DefectedPercent])
WHERE NOT EXISTS (SELECT 1 FROM [dbo].[MaterialType] WHERE [Title] = types.[Тип материала]);

INSERT INTO [dbo].[Material] (
    [Title], 
    [MaterialTypeID], 
    [Image], 
    [Cost], 
    [CountInStock], 
    [MinCount], 
    [CountInPack], 
    [Unit]
)
SELECT 
    [Наименование материала],
    mt.[ID],
    CASE 
        WHEN [Изображение] IN ('не указано', 'отсутствует', 'нет', '') THEN NULL 
        ELSE [Изображение] 
    END,
    CAST(REPLACE(REPLACE(REPLACE(REPLACE([Цена], ' руб.', ''), ' рублей', ''), ' ₽', ''), 'рублей', '') AS DECIMAL(10,2)),
    CAST(CASE 
        WHEN [Количество на складе] LIKE '%в наличии%' THEN REPLACE(REPLACE([Количество на складе], ' в наличии', ''), 'в наличии', '')
        WHEN [Количество на складе] LIKE '%На складе:%' THEN REPLACE([Количество на складе], 'На складе:', '')
        WHEN [Количество на складе] LIKE '%На складе%' THEN REPLACE([Количество на складе], 'На складе', '')
        ELSE [Количество на складе]
    END AS FLOAT),
    [Минимальное количество],
    [Количество в упаковке],
    [Единица измерения]
FROM (VALUES
    ('Гранулы белый 2x2', 'Гранулы', 'не указано', '47680.00', '76', 8, 7, 'л'),
    ('Нить серый 1x0', 'Краски', 'не указано', '27456', 'На складе: 978', 42, 1, 'м'),
    ('Нить белый 1x3', 'Нитки', 'не указано', '2191 руб.', '406 в наличии', 27, 8, 'м'),
    ('Нить цветной 1x1', 'Краски', '\materials\image_5.jpeg', '8619', '424', 10, 3, 'г'),
    ('Нить цветной 2x0', 'Краски', 'отсутствует', '16856.00 ₽', '395 в наличии', 26, 2, 'м'),
    ('Краска синий 2x2', 'Краски', 'не указано', '403.00', '334', 48, 6, 'л'),
    ('Нить синий 0x2', 'Нитки', 'отсутствует', '7490 рублей', '654', 10, 9, 'м'),
    ('Гранулы серый 2x2', 'Гранулы', 'не указано', '15478.00 ₽', '648 в наличии', 17, 7, 'л'),
    ('Краска синий 1x2', 'Краски', 'отсутствует', '44490.00', '640', 50, 2, 'л'),
    ('Нить зеленый 2x0', 'Краски', '\materials\image_10.jpeg', '28301.00 ₽', 'На складе: 535', 45, 5, 'м'),
    ('Гранулы синий 1x2', 'Гранулы', 'не указано', '9242', 'На складе: 680', 6, 3, 'кг'),
    ('Нить синий 3x2', 'Нитки', 'отсутствует', '10878 рублей', '529 в наличии', 13, 1, 'м'),
    ('Краска белый 2x2', 'Краски', '\materials\image_3.jpeg', '29906.00', '659 в наличии', 35, 1, 'л'),
    ('Краска зеленый 0x3', 'Краски', 'не указано', '24073 рублей', '50 в наличии', 48, 2, 'л'),
    ('Нить зеленый 2x3', 'Нитки', 'отсутствует', '20057.00', '649', 25, 7, 'г'),
    ('Краска белый 2x1', 'Краски', 'не указано', '3353 рублей', '790', 8, 2, 'л'),
    ('Нить серый 2x3', 'Нитки', 'не указано', '22452 руб.', 'На складе: 431', 40, 1, 'г'),
    ('Гранулы серый 3x2', 'Гранулы', 'нет', '29943 руб.', 'На складе: 96', 9, 5, 'л'),
    ('Краска серый 3x2', 'Краски', 'отсутствует', '55064.00 ₽', '806', 50, 3, 'л'),
    ('Гранулы белый 0x3', 'Гранулы', 'нет', '7183.00', '538 в наличии', 11, 3, 'кг'),
    ('Краска цветной 1x1', 'Краски', 'отсутствует', '43466 рублей', '784 в наличии', 22, 3, 'л'),
    ('Гранулы белый 1x0', 'Гранулы', 'нет', '27718 рублей', 'На складе: 980', 41, 3, 'кг'),
    ('Краска серый 0x2', 'Краски', 'отсутствует', '33227 рублей', '679', 36, 3, 'кг'),
    ('Гранулы серый 3x3', 'Гранулы', 'нет', '15170.00 ₽', '2', 38, 5, 'л'),
    ('Краска серый 3x0', 'Краски', 'не указано', '19352 руб.', '341 в наличии', 38, 7, 'кг'),
    ('Гранулы синий 2x1', 'Гранулы', '\materials\image_2.jpeg', '231 рублей', '273 в наличии', 17, 9, 'л'),
    ('Гранулы синий 0x2', 'Гранулы', 'не указано', '41646.00', '576', 36, 9, 'л'),
    ('Нить цветной 1x0', 'Нитки', 'не указано', '24948 руб.', '91 в наличии', 38, 5, 'г'),
    ('Краска зеленый 2x2', 'Краски', 'не указано', '19014.00 ₽', 'На складе: 752', 36, 2, 'кг'),
    ('Краска цветной 1x3', 'Краски', 'отсутствует', '268.00', '730', 5, 9, 'кг'),
    ('Краска серый 2x0', 'Краски', 'не указано', '35256 рублей', 'На складе: 131', 22, 2, 'л'),
    ('Нить зеленый 2x1', 'Нитки', 'не указано', '34556.00', '802 в наличии', 16, 6, 'м'),
    ('Краска цветной 0x3', 'Краски', 'нет', '3322 руб.', '324', 9, 10, 'л'),
    ('Нить белый 2x3', 'Нитки', 'не указано', '10823.00', 'На складе: 283', 41, 3, 'г'),
    ('Гранулы синий 3x0', 'Гранулы', 'не указано', '16665', '411 в наличии', 8, 1, 'кг'),
    ('Гранулы синий 1x3', 'Гранулы', 'нет', '5668 руб.', '41 в наличии', 30, 8, 'л'),
    ('Нить цветной 2x1', 'Краски', 'нет', '7615 рублей', '150', 22, 3, 'м'),
    ('Гранулы серый 3x0', 'Гранулы', '\materials\image_7.jpeg', '702.00', 'На складе: 0', 5, 4, 'л'),
    ('Краска синий 3x0', 'Краски', 'нет', '38644.00', '523 в наличии', 42, 7, 'л'),
    ('Нить зеленый 0x0', 'Краски', 'не указано', '41827.00 ₽', 'На складе: 288', 43, 8, 'м'),
    ('Гранулы белый 1x2', 'Гранулы', 'нет', '8129', '77 в наличии', 46, 4, 'л'),
    ('Краска белый 3x0', 'Краски', 'нет', '51471 рублей', 'На складе: 609', 48, 5, 'кг'),
    ('Краска цветной 0x1', 'Краски', 'отсутствует', '54401.00', '43', 8, 6, 'л'),
    ('Нить серый 1x1', 'Нитки', 'отсутствует', '14474 рублей', 'На складе: 372', 22, 5, 'м'),
    ('Краска синий 2x1', 'Краски', 'нет', '46848 руб.', 'На складе: 642', 29, 9, 'л'),
    ('Нить серый 3x0', 'Нитки', 'отсутствует', '29503 руб.', 'На складе: 409', 19, 1, 'м'),
    ('Краска зеленый 3x3', 'Краски', 'отсутствует', '27710.00 ₽', '601 в наличии', 32, 6, 'л'),
    ('Краска синий 2x0', 'Краски', 'отсутствует', '40074 рублей', 'На складе: 135', 50, 7, 'л'),
    ('Гранулы синий 2x3', 'Гранулы', 'не указано', '53482.00 ₽', '749 в наличии', 45, 2, 'л'),
    ('Нить синий 0x3', 'Краски', 'не указано', '32087 руб.', '615', 22, 8, 'м'),
    ('Нить синий 3x3', 'Нитки', 'отсутствует', '45774', 'На складе: 140', 12, 7, 'г'),
    ('Краска зеленый 2x3', 'Краски', 'нет', '44978.00', '485 в наличии', 8, 2, 'л'),
    ('Нить синий 3x0', 'Нитки', 'отсутствует', '44407', '67 в наличии', 23, 10, 'м'),
    ('Гранулы серый 2x1', 'Гранулы', 'нет', '50339.00', '779', 44, 7, 'кг'),
    ('Краска зеленый 0x1', 'Краски', 'нет', '30581 рублей', '869', 7, 2, 'л'),
    ('Краска синий 0x0', 'Краски', 'не указано', '18656.00', '796', 29, 8, 'кг'),
    ('Краска серый 2x1', 'Краски', 'отсутствует', '46579 руб.', '706', 45, 5, 'л'),
    ('Нить белый 0x1', 'Нитки', 'не указано', '36883.00 ₽', '101', 43, 10, 'м'),
    ('Гранулы зеленый 1x2', 'Гранулы', 'нет', '45083', '575 в наличии', 15, 9, 'л'),
    ('Краска серый 0x1', 'Краски', 'не указано', '35063.00', '768 в наличии', 27, 2, 'л'),
    ('Гранулы цветной 0x1', 'Гранулы', 'нет', '24488.00 ₽', '746', 50, 3, 'л'),
    ('Гранулы белый 3x1', 'Гранулы', 'отсутствует', '43711', 'На складе: 995', 27, 8, 'л'),
    ('Нить зеленый 0x2', 'Нитки', 'отсутствует', '17429 рублей', '578 в наличии', 20, 2, 'м'),
    ('Гранулы зеленый 0x2', 'Гранулы', 'нет', '38217', 'На складе: 206', 34, 4, 'л'),
    ('Краска цветной 1x2', 'Краски', 'не указано', '47701 рублей', 'На складе: 299', 50, 10, 'л'),
    ('Краска зеленый 1x0', 'Краски', 'нет', '52189 руб.', 'На складе: 626', 17, 8, 'кг'),
    ('Гранулы серый 0x0', 'Гранулы', 'не указано', '16715.00 ₽', 'На складе: 608', 12, 5, 'л'),
    ('Гранулы синий 0x3', 'Гранулы', 'отсутствует', '45134 руб.', 'На складе: 953', 48, 5, 'кг'),
    ('Краска цветной 2x1', 'Краски', 'не указано', '1846 рублей', 'На складе: 325', 45, 1, 'л'),
    ('Нить синий 2x3', 'Краски', 'отсутствует', '43659', 'На складе: 10', 21, 5, 'м'),
    ('Нить синий 2x1', 'Краски', 'не указано', '12283', 'На складе: 948', 13, 9, 'г'),
    ('Гранулы белый 1x1', 'Гранулы', 'отсутствует', '6557.00 ₽', '93 в наличии', 11, 4, 'л'),
    ('Краска синий 1x3', 'Краски', 'отсутствует', '38230 руб.', '265 в наличии', 17, 6, 'кг'),
    ('Краска зеленый 3x0', 'Краски', '\materials\image_1.jpeg', '20226.00 ₽', '261', 7, 2, 'л'),
    ('Нить зеленый 1x0', 'Нитки', 'не указано', '8105.00', 'На складе: 304', 43, 9, 'г'),
    ('Краска цветной 0x2', 'Краски', 'нет', '2600.00', '595 в наличии', 38, 7, 'л'),
    ('Нить синий 3x1', 'Краски', 'нет', '4920 руб.', 'На складе: 579', 48, 7, 'м'),
    ('Краска зеленый 0x2', 'Краски', 'отсутствует', '39809 рублей', 'На складе: 139', 23, 9, 'л'),
    ('Краска синий 3x3', 'Краски', 'нет', '46545 руб.', '740', 24, 6, 'кг'),
    ('Краска зеленый 1x1', 'Краски', '\materials\image_6.jpeg', '40583 рублей', '103', 34, 2, 'кг'),
    ('Краска цветной 2x3', 'Краски', 'не указано', '46502 рублей', '443 в наличии', 46, 9, 'л'),
    ('Нить цветной 3x0', 'Нитки', 'отсутствует', '53651.00', 'На складе: 989', 14, 1, 'м'),
    ('Гранулы серый 2x3', 'Гранулы', 'не указано', '47757.00 ₽', '467', 28, 6, 'л'),
    ('Краска белый 1x0', 'Краски', 'нет', '3543 руб.', '95 в наличии', 6, 6, 'л'),
    ('Гранулы серый 3x1', 'Гранулы', 'не указано', '10899 руб.', '762', 6, 10, 'кг'),
    ('Гранулы серый 2x0', 'Гранулы', '\materials\image_8.jpeg', '8939 рублей', '312', 21, 3, 'кг'),
    ('Нить белый 0x2', 'Нитки', 'отсутствует', '29271.00', '43', 19, 4, 'г'),
    ('Гранулы зеленый 1x1', 'Гранулы', '\materials\image_4.jpeg', '46455.00 ₽', '10 в наличии', 19, 4, 'л'),
    ('Нить серый 0x2', 'Краски', '\materials\image_9.jpeg', '45744.00', 'На складе: 504', 10, 3, 'м'),
    ('Гранулы белый 0x2', 'Гранулы', 'нет', '9330.00', 'На складе: 581', 40, 2, 'л'),
    ('Нить цветной 3x2', 'Нитки', 'отсутствует', '2939', '831', 46, 3, 'м'),
    ('Гранулы белый 3x0', 'Гранулы', 'не указано', '50217 рублей', '208', 7, 6, 'л'),
    ('Нить серый 1x2', 'Нитки', 'нет', '30198.00', 'На складе: 292', 30, 1, 'м'),
    ('Краска белый 0x1', 'Краски', 'отсутствует', '19777 руб.', '423', 47, 7, 'л'),
    ('Гранулы цветной 0x3', 'Гранулы', 'нет', '1209 руб.', '723', 44, 7, 'кг'),
    ('Нить серый 1x3', 'Краски', 'отсутствует', '32002 рублей', 'На складе: 489', 25, 1, 'г'),
    ('Гранулы белый 2x3', 'Гранулы', 'нет', '32446', '274', 8, 4, 'л'),
    ('Краска зеленый 3x1', 'Краски', 'отсутствует', '32487 руб.', '657 в наличии', 19, 10, 'л'),
    ('Гранулы цветной 3x2', 'Гранулы', 'нет', '28596.00 ₽', '32', 45, 1, 'л'),
    ('Нить белый 2x0', 'Краски', 'отсутствует', '46684', 'На складе: 623', 23, 2, 'м')
) AS csv_data(
    [Наименование материала], 
    [Тип материала], 
    [Изображение], 
    [Цена], 
    [Количество на складе], 
    [Минимальное количество], 
    [Количество в упаковке], 
    [Единица измерения]
)
INNER JOIN [dbo].[MaterialType] mt ON csv_data.[Тип материала] = mt.[Title]
WHERE NOT EXISTS (SELECT 1 FROM [dbo].[Material] m WHERE m.[Title] = csv_data.[Наименование материала]);

CREATE VIEW [dbo].[SalesDashboard] AS
SELECT 
    a.ID AS AgentID, a.Title AS AgentName, atype.Title AS AgentType,
    COUNT(ps.ID) AS OrdersCount, SUM(ps.ProductCount * p.MinCostForAgent) AS TotalSales,
    AVG(a.Priority) AS AgentPriority, (SELECT COUNT(*) FROM Shop s WHERE s.AgentID = a.ID) AS ShopsCount,
    ae.DiscountRate AS CurrentDiscount, ae.PerformanceRating, ae.LastOrderDate
FROM Agent a
INNER JOIN AgentType atype ON a.AgentTypeID = atype.ID
LEFT JOIN ProductSale ps ON a.ID = ps.AgentID
LEFT JOIN Product p ON ps.ProductID = p.ID
LEFT JOIN AgentExtended ae ON a.ID = ae.AgentID
GROUP BY a.ID, a.Title, atype.Title, ae.DiscountRate, ae.PerformanceRating, ae.LastOrderDate;

CREATE VIEW [dbo].[ProductionDashboard] AS
SELECT 
    p.ID AS ProductID, 
    p.Title AS ProductName, 
    pt.Title AS ProductType,
    COUNT(ps.ID) AS MonthlySales, 
    SUM(COALESCE(m.CountInStock, 0)) AS MaterialsStock,
    (SELECT COUNT(*) FROM ProductionPlan pp WHERE pp.ProductID = p.ID AND pp.Status = 'IN_PROGRESS') AS ActiveProduction,
    (SELECT SUM(PlannedQuantity) FROM ProductionPlan pp WHERE pp.ProductID = p.ID AND pp.Status = 'COMPLETED' 
     AND MONTH(pp.ActualEndDate) = MONTH(GETDATE()) AND YEAR(pp.ActualEndDate) = YEAR(GETDATE())) AS MonthlyProduction,
    NULL AS AvgQualityRating
FROM Product p
LEFT JOIN ProductType pt ON p.ProductTypeID = pt.ID
LEFT JOIN ProductSale ps ON p.ID = ps.ProductID AND MONTH(ps.SaleDate) = MONTH(GETDATE()) AND YEAR(ps.SaleDate) = YEAR(GETDATE())
LEFT JOIN ProductMaterial pm ON p.ID = pm.ProductID
LEFT JOIN Material m ON pm.MaterialID = m.ID
GROUP BY p.ID, p.Title, pt.Title;

CREATE VIEW [dbo].[SupplierDashboard] AS
SELECT 
    s.ID AS SupplierID, s.Title AS SupplierName, s.SupplierType, s.QualityRating,
    COUNT(ms.MaterialID) AS SuppliedMaterials, (SELECT COUNT(DISTINCT MaterialID) FROM MaterialSupplier WHERE SupplierID = s.ID) AS UniqueMaterials,
    (SELECT COUNT(*) FROM MaterialPurchase mp WHERE mp.SupplierID = s.ID AND mp.Status = 'RECEIVED') AS CompletedOrders,
    (SELECT AVG(QualityRating) FROM MaterialPurchase mp WHERE mp.SupplierID = s.ID AND mp.QualityRating IS NOT NULL) AS AvgDeliveryQuality,
    (SELECT SUM(TotalAmount) FROM MaterialPurchase mp WHERE mp.SupplierID = s.ID AND YEAR(mp.OrderDate) = YEAR(GETDATE())) AS AnnualVolume
FROM Supplier s
LEFT JOIN MaterialSupplier ms ON s.ID = ms.SupplierID
GROUP BY s.ID, s.Title, s.SupplierType, s.QualityRating;

CREATE VIEW [dbo].[WarehouseDashboard] AS
SELECT 
    m.ID AS MaterialID, m.Title AS MaterialName, mt.Title AS MaterialType,
    m.CountInStock AS CurrentStock, m.MinCount AS MinimumStock, m.Unit,
    m.Cost AS UnitCost, (m.CountInStock * m.Cost) AS StockValue,
    CASE 
        WHEN m.CountInStock <= m.MinCount THEN 'КРИТИЧЕСКИЙ'
        WHEN m.CountInStock <= m.MinCount * 1.5 THEN 'НИЗКИЙ'
        ELSE 'НОРМАЛЬНЫЙ'
    END AS StockStatus,
    (SELECT COUNT(*) FROM MaterialSupplier ms WHERE ms.MaterialID = m.ID) AS SupplierCount,
    (SELECT SUM(Quantity) FROM MaterialPurchase mp WHERE mp.MaterialID = m.ID AND mp.Status = 'ORDERED') AS OrderedQuantity
FROM Material m
INNER JOIN MaterialType mt ON m.MaterialTypeID = mt.ID;

CREATE VIEW [dbo].[BusinessMetrics] AS
SELECT 
    (SELECT SUM(ProductCount * MinCostForAgent) FROM ProductSale ps 
     JOIN Product p ON ps.ProductID = p.ID WHERE YEAR(SaleDate) = YEAR(GETDATE())) AS AnnualRevenue,
    (SELECT SUM(FinalAmount) FROM ProductOrder WHERE YEAR(OrderDate) = YEAR(GETDATE()) AND Status = 'COMPLETED') AS OrderRevenue,
    (SELECT AVG(OrdersCount) FROM (SELECT AgentID, COUNT(*) AS OrdersCount FROM ProductSale WHERE YEAR(SaleDate) = YEAR(GETDATE()) GROUP BY AgentID) ac) AS AvgOrdersPerAgent,
    (SELECT AVG(CountInStock / NULLIF(MinCount, 0)) FROM Material WHERE MinCount > 0) AS StockTurnoverRatio,
    (SELECT AVG(QualityRating) FROM Supplier WHERE QualityRating > 0) AS AvgSupplierRating,
    (SELECT COUNT(*) FROM ProductionPlan WHERE Status = 'COMPLETED' AND YEAR(ActualEndDate) = YEAR(GETDATE())) AS CompletedProductionOrders,
    (SELECT AVG(DATEDIFF(day, ActualStartDate, ActualEndDate)) FROM ProductionPlan WHERE Status = 'COMPLETED' AND ActualStartDate IS NOT NULL) AS AvgProductionDays,
    (SELECT COUNT(*) FROM ProductSale WHERE DATEDIFF(day, SaleDate, GETDATE()) <= 30) AS MonthlyOrders,
    (SELECT COUNT(*) FROM QualityControl WHERE Result = 'PASS' AND MONTH(ControlDate) = MONTH(GETDATE())) AS QualityPassed,
    (SELECT COUNT(*) FROM QualityControl WHERE Result = 'FAIL' AND MONTH(ControlDate) = MONTH(GETDATE())) AS QualityFailed;

-- ХРАНИМЫЕ ПРОЦЕДУРЫ
CREATE PROCEDURE [dbo].[CalculateAgentDiscount] @AgentID INT AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @SalesVolume DECIMAL(15,2), @DiscountRate DECIMAL(5,2);
    SELECT @SalesVolume = COALESCE(SUM(ps.ProductCount * p.MinCostForAgent), 0)
    FROM ProductSale ps INNER JOIN Product p ON ps.ProductID = p.ID
    WHERE ps.AgentID = @AgentID AND YEAR(ps.SaleDate) = YEAR(GETDATE());
    SELECT TOP 1 @DiscountRate = DiscountPercent FROM DiscountRules
    WHERE @SalesVolume >= MinSalesVolume AND (MaxSalesVolume IS NULL OR @SalesVolume <= MaxSalesVolume)
    AND IsActive = 1 AND EffectiveDate <= GETDATE() AND (ExpiryDate IS NULL OR ExpiryDate >= GETDATE())
    ORDER BY DiscountPercent DESC;
    IF @DiscountRate IS NULL SET @DiscountRate = 0;
    IF EXISTS (SELECT 1 FROM AgentExtended WHERE AgentID = @AgentID)
        UPDATE AgentExtended SET SalesVolume = @SalesVolume, DiscountRate = @DiscountRate,
        PerformanceRating = CASE WHEN @SalesVolume > 1000000 THEN 5 WHEN @SalesVolume > 500000 THEN 4
        WHEN @SalesVolume > 100000 THEN 3 WHEN @SalesVolume > 50000 THEN 2 ELSE 1 END WHERE AgentID = @AgentID;
    ELSE
        INSERT INTO AgentExtended (AgentID, SalesVolume, DiscountRate, PerformanceRating)
        VALUES (@AgentID, @SalesVolume, @DiscountRate, CASE WHEN @SalesVolume > 1000000 THEN 5 
        WHEN @SalesVolume > 500000 THEN 4 WHEN @SalesVolume > 100000 THEN 3 WHEN @SalesVolume > 50000 THEN 2 ELSE 1 END);
    SELECT @DiscountRate AS CalculatedDiscount;
END;

CREATE PROCEDURE [dbo].[CreateProductionPlan] @ProductID INT, @PlannedQuantity INT, @StartDate DATE, @WorkshopNumber INT, @RequiredPersonnel INT AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @EndDate DATE = DATEADD(day, 7, @StartDate);
    IF NOT EXISTS (SELECT 1 FROM ProductSpecification ps INNER JOIN Material m ON ps.MaterialID = m.ID
        WHERE ps.ProductID = @ProductID AND m.CountInStock < (ps.RequiredQuantity * @PlannedQuantity * (1 + ps.WastePercent/100)))
    BEGIN
        INSERT INTO ProductionPlan (ProductID, PlannedQuantity, StartDate, EndDate, WorkshopNumber, RequiredPersonnel, Status)
        VALUES (@ProductID, @PlannedQuantity, @StartDate, @EndDate, @WorkshopNumber, @RequiredPersonnel, 'PLANNED');
        SELECT 'SUCCESS' AS Result, SCOPE_IDENTITY() AS PlanID;
    END ELSE BEGIN
        SELECT 'ERROR' AS Result, 'Недостаточно материалов для производства' AS Message;
    END
END;

CREATE PROCEDURE [dbo].[ProcessProductOrder] @OrderID INT AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        DECLARE @AgentID INT, @DiscountRate DECIMAL(5,2), @TotalAmount DECIMAL(15,2), @FinalAmount DECIMAL(15,2);
        SELECT @AgentID = AgentID FROM ProductOrder WHERE OrderID = @OrderID;
        EXEC CalculateAgentDiscount @AgentID;
        SELECT @DiscountRate = DiscountRate FROM AgentExtended WHERE AgentID = @AgentID;
        SELECT @TotalAmount = SUM(Quantity * UnitPrice) FROM OrderDetails WHERE OrderID = @OrderID;
        SET @FinalAmount = @TotalAmount * (1 - @DiscountRate/100);
        UPDATE ProductOrder SET TotalAmount = @TotalAmount, DiscountAmount = @TotalAmount * (@DiscountRate/100),
        FinalAmount = @FinalAmount, Status = 'PROCESSING' WHERE OrderID = @OrderID;
        INSERT INTO ProductSale (AgentID, ProductID, SaleDate, ProductCount)
        SELECT @AgentID, ProductID, GETDATE(), Quantity FROM OrderDetails WHERE OrderID = @OrderID;
        UPDATE AgentExtended SET TotalOrders = TotalOrders + 1, TotalRevenue = TotalRevenue + @FinalAmount,
        LastOrderDate = GETDATE() WHERE AgentID = @AgentID;
        COMMIT TRANSACTION;
        SELECT 'SUCCESS' AS Result, @FinalAmount AS FinalAmount;
    END TRY BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT 'ERROR' AS Result, ERROR_MESSAGE() AS Message;
    END CATCH
END;

CREATE PROCEDURE [dbo].[CheckLowStock] AS
BEGIN
    SET NOCOUNT ON;
    SELECT m.ID AS MaterialID, m.Title AS MaterialName, m.CountInStock AS CurrentStock, m.MinCount AS MinimumStock,
    m.Unit, (m.MinCount - m.CountInStock) AS RequiredQuantity,
    (SELECT TOP 1 s.Title FROM MaterialSupplier ms INNER JOIN Supplier s ON ms.SupplierID = s.ID 
     WHERE ms.MaterialID = m.ID ORDER BY s.QualityRating DESC) AS RecommendedSupplier
    FROM Material m WHERE m.CountInStock <= m.MinCount ORDER BY (m.MinCount - m.CountInStock) DESC;
END;

CREATE PROCEDURE [dbo].[GetAgentPerformanceReport] @StartDate DATE = NULL, @EndDate DATE = NULL AS
BEGIN
    SET NOCOUNT ON;
    IF @StartDate IS NULL SET @StartDate = DATEADD(month, -1, GETDATE());
    IF @EndDate IS NULL SET @EndDate = GETDATE();
    SELECT a.ID AS AgentID, a.Title AS AgentName, atype.Title AS AgentType,
    COUNT(ps.ID) AS OrdersCount, SUM(ps.ProductCount * p.MinCostForAgent) AS TotalSales,
    ae.DiscountRate AS CurrentDiscount, ae.PerformanceRating,
    (SELECT COUNT(*) FROM Shop s WHERE s.AgentID = a.ID) AS ActiveShops,
    DATEDIFF(day, MIN(ps.SaleDate), MAX(ps.SaleDate)) AS ActivityPeriodDays
    FROM Agent a INNER JOIN AgentType atype ON a.AgentTypeID = atype.ID
    LEFT JOIN ProductSale ps ON a.ID = ps.AgentID AND ps.SaleDate BETWEEN @StartDate AND @EndDate
    LEFT JOIN Product p ON ps.ProductID = p.ID LEFT JOIN AgentExtended ae ON a.ID = ae.AgentID
    GROUP BY a.ID, a.Title, atype.Title, ae.DiscountRate, ae.PerformanceRating ORDER BY TotalSales DESC;
END;

-- ТРИГГЕРЫ
CREATE TRIGGER [dbo].[TR_ProductionPlan_UpdateStock] ON [dbo].[ProductionPlan] AFTER UPDATE AS
BEGIN SET NOCOUNT ON;
    IF UPDATE(Status) AND EXISTS (SELECT 1 FROM inserted WHERE Status = 'COMPLETED')
    BEGIN
        UPDATE m SET CountInStock = CountInStock - (ps.RequiredQuantity * i.CompletedQuantity * (1 + ps.WastePercent/100))
        FROM Material m INNER JOIN ProductSpecification ps ON m.ID = ps.MaterialID
        INNER JOIN inserted i ON ps.ProductID = i.ProductID INNER JOIN deleted d ON i.PlanID = d.PlanID
        WHERE d.Status != 'COMPLETED' AND i.Status = 'COMPLETED';
        INSERT INTO MaterialCountHistory (MaterialID, ChangeDate, CountValue)
        SELECT ps.MaterialID, GETDATE(), -(ps.RequiredQuantity * i.CompletedQuantity * (1 + ps.WastePercent/100))
        FROM ProductSpecification ps INNER JOIN inserted i ON ps.ProductID = i.ProductID
        INNER JOIN deleted d ON i.PlanID = d.PlanID WHERE d.Status != 'COMPLETED' AND i.Status = 'COMPLETED';
    END
END;

CREATE TRIGGER [dbo].[TR_ProductSale_UpdateAgentStats] ON [dbo].[ProductSale] AFTER INSERT AS
BEGIN SET NOCOUNT ON;
    UPDATE ae SET ActiveShopsCount = (SELECT COUNT(*) FROM Shop s WHERE s.AgentID = ae.AgentID),
    LastOrderDate = GETDATE() FROM AgentExtended ae INNER JOIN inserted i ON ae.AgentID = i.AgentID;
    DECLARE @AgentID INT; SELECT @AgentID = AgentID FROM inserted; EXEC CalculateAgentDiscount @AgentID;
END;

CREATE TRIGGER [dbo].[TR_Material_CheckMinStock] ON [dbo].[Material] AFTER UPDATE AS
BEGIN SET NOCOUNT ON;
    IF UPDATE(CountInStock) AND EXISTS (SELECT 1 FROM inserted i WHERE i.CountInStock <= i.MinCount)
    BEGIN PRINT 'ВНИМАНИЕ: Обнаружены материалы с низким запасом!'; END
END;

-- НАЧАЛЬНЫЕ ДАННЫЕ СИСТЕМЫ
INSERT INTO [dbo].[UserRoles] ([RoleName], [Description]) VALUES
('Администратор', 'Полный доступ ко всем функциям системы'),
('Менеджер по продажам', 'Управление агентами и заказами'),
('Начальник производства', 'Планирование и контроль производства'),
('Снабженец', 'Управление поставщиками и закупками'),
('Кладовщик', 'Управление складскими остатками'),
('Контролер качества', 'Контроль качества продукции'),
('Агент', 'Просмотр каталога и размещение заказов');

INSERT INTO [dbo].[Permissions] ([PermissionName], [Description]) VALUES
('AGENT_VIEW', 'Просмотр информации об агентах'), ('AGENT_EDIT', 'Редактирование данных агентов'),
('ORDER_CREATE', 'Создание заказов'), ('ORDER_VIEW', 'Просмотр заказов'), ('ORDER_PROCESS', 'Обработка заказов'),
('PRODUCTION_PLAN', 'Планирование производства'), ('PRODUCTION_VIEW', 'Просмотр производственных планов'),
('MATERIAL_MANAGE', 'Управление материалами'), ('SUPPLIER_MANAGE', 'Управление поставщиками'),
('QUALITY_CONTROL', 'Контроль качества'), ('REPORTS_VIEW', 'Просмотр отчетов'), ('SYSTEM_ADMIN', 'Администрирование системы');

INSERT INTO [dbo].[RolePermissions] ([RoleID], [PermissionID]) 
SELECT r.RoleID, p.PermissionID FROM UserRoles r, Permissions p WHERE r.RoleName = 'Администратор';

INSERT INTO [dbo].[DiscountRules] ([MinSalesVolume], [MaxSalesVolume], [DiscountPercent], [EffectiveDate], [ExpiryDate]) VALUES
(0, 50000, 0, '2020-01-01', NULL), (50000, 100000, 5, '2020-01-01', NULL), (100000, 500000, 10, '2020-01-01', NULL),
(500000, 1000000, 15, '2020-01-01', NULL), (1000000, NULL, 20, '2020-01-01', NULL);

INSERT INTO [dbo].[Employee] ([FirstName], [LastName], [Position], [Department], [HireDate]) VALUES
('Иван', 'Петров', 'Менеджер по продажам', 'Отдел продаж', '2020-01-15'),
('Мария', 'Сидорова', 'Начальник производства', 'Производственный отдел', '2019-03-10'),
('Алексей', 'Козлов', 'Снабженец', 'Отдел снабжения', '2020-06-20'),
('Ольга', 'Николаева', 'Кладовщик', 'Склад', '2021-02-01'),
('Дмитрий', 'Васильев', 'Контролер качества', 'ОТК', '2020-09-15');

INSERT INTO [dbo].[SystemUsers] ([Username], [PasswordHash], [Email], [RoleID], [EmployeeID]) VALUES
('admin', 'hashed_password_1', 'admin@company.com', 1, 1),
('sales_manager', 'hashed_password_2', 'sales@company.com', 2, 1),
('production_head', 'hashed_password_3', 'production@company.com', 3, 2),
('supply_manager', 'hashed_password_4', 'supply@company.com', 4, 3),
('warehouse_keeper', 'hashed_password_5', 'warehouse@company.com', 5, 4);

-- СТАТИСТИКА ПО МАТЕРИАЛАМ
SELECT 
    mt.Title AS MaterialType,
    COUNT(m.ID) AS MaterialCount,
    SUM(m.CountInStock) AS TotalStock,
    AVG(m.Cost) AS AvgCost,
    SUM(m.CountInStock * m.Cost) AS TotalValue
FROM Material m
INNER JOIN MaterialType mt ON m.MaterialTypeID = mt.ID
GROUP BY mt.Title
ORDER BY MaterialCount DESC;

-- МАТЕРИАЛЫ С НИЗКИМ ЗАПАСОМ
SELECT 
    Title,
    CountInStock,
    MinCount,
    Unit,
    CASE 
        WHEN CountInStock <= MinCount THEN 'КРИТИЧЕСКИЙ'
        WHEN CountInStock <= MinCount * 1.5 THEN 'НИЗКИЙ'
        ELSE 'НОРМАЛЬНЫЙ'
    END AS StockStatus
FROM Material
WHERE CountInStock <= MinCount * 1.5
ORDER BY CountInStock ASC;