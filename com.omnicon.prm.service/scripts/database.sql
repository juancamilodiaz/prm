USE [master]
GO
/****** Object:  User [admin]    Script Date: 20/09/2017 05:00:54 p.m. ******/
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'admin')
CREATE USER [admin] FOR LOGIN [admin] WITH DEFAULT_SCHEMA=[db_accessadmin]
GO
ALTER ROLE [db_owner] ADD MEMBER [admin]
GO
ALTER ROLE [db_accessadmin] ADD MEMBER [admin]
GO
ALTER ROLE [db_securityadmin] ADD MEMBER [admin]
GO
ALTER ROLE [db_ddladmin] ADD MEMBER [admin]
GO
ALTER ROLE [db_backupoperator] ADD MEMBER [admin]
GO
ALTER ROLE [db_datareader] ADD MEMBER [admin]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [admin]
GO
ALTER ROLE [db_denydatareader] ADD MEMBER [admin]
GO
ALTER ROLE [db_denydatawriter] ADD MEMBER [admin]
GO
/****** Object:  Table [dbo].[Project]    Script Date: 20/09/2017 05:00:54 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Project]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Project](
	[id] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[name] [varchar](50) NULL,
	[start_date] [date] NULL,
	[end_date] [date] NULL,
	[enabled] [bit] NULL,
 CONSTRAINT [PK_Project] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ProjectResources]    Script Date: 20/09/2017 05:00:55 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProjectResources]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ProjectResources](
	[id] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[project_id] [numeric](18, 0) NOT NULL,
	[resource_id] [numeric](18, 0) NOT NULL,
	[project_name] [varchar](50) NOT NULL,
	[resource_name] [varchar](50) NOT NULL,
	[start_date] [date] NULL,
	[end_date] [date] NULL,
	[hours] [float] NOT NULL,
	[lead] [bit] NOT NULL,
 CONSTRAINT [PK_ProjectResources] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Resource]    Script Date: 20/09/2017 05:00:55 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Resource]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Resource](
	[id] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[name] [varchar](50) NULL,
	[last_name] [varchar](50) NULL,
	[email] [varchar](50) NULL,
	[photo] [varchar](50) NULL,
	[engineer_range] [varchar](2) NULL,
	[enabled] [bit] NULL,
 CONSTRAINT [PK_Resource] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ResourceSkills]    Script Date: 20/09/2017 05:00:55 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ResourceSkills]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ResourceSkills](
	[id] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[resource_id] [numeric](18, 0) NOT NULL,
	[skill_id] [numeric](18, 0) NOT NULL,
	[name] [varchar](50) NULL,
	[value] [int] NULL,
 CONSTRAINT [PK_ResourceSkills] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Skill]    Script Date: 20/09/2017 05:00:55 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Skill]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Skill](
	[id] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[name] [varchar](50) NULL,
 CONSTRAINT [PK_Skill] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[Project] ON 

INSERT [dbo].[Project] ([id], [name], [start_date], [end_date], [enabled]) VALUES (CAST(1 AS Numeric(18, 0)), N'PRM', CAST(N'2017-08-28' AS Date), CAST(N'2017-09-25' AS Date), 1)
INSERT [dbo].[Project] ([id], [name], [start_date], [end_date], [enabled]) VALUES (CAST(2 AS Numeric(18, 0)), N'GOSCE', CAST(N'2017-06-10' AS Date), CAST(N'2017-10-11' AS Date), 1)
INSERT [dbo].[Project] ([id], [name], [start_date], [end_date], [enabled]) VALUES (CAST(3 AS Numeric(18, 0)), N'CAN', CAST(N'2017-01-01' AS Date), CAST(N'2017-09-30' AS Date), 1)
INSERT [dbo].[Project] ([id], [name], [start_date], [end_date], [enabled]) VALUES (CAST(4 AS Numeric(18, 0)), N'MLO', CAST(N'2017-04-01' AS Date), CAST(N'2017-12-31' AS Date), 1)
SET IDENTITY_INSERT [dbo].[Project] OFF
SET IDENTITY_INSERT [dbo].[ProjectResources] ON 

INSERT [dbo].[ProjectResources] ([id], [project_id], [resource_id], [project_name], [resource_name], [start_date], [end_date], [hours], [lead]) VALUES (CAST(629 AS Numeric(18, 0)), CAST(1 AS Numeric(18, 0)), CAST(23 AS Numeric(18, 0)), N'PRM', N'Anderson Diaz', CAST(N'2017-09-03' AS Date), CAST(N'2017-09-20' AS Date), 104, 0)
INSERT [dbo].[ProjectResources] ([id], [project_id], [resource_id], [project_name], [resource_name], [start_date], [end_date], [hours], [lead]) VALUES (CAST(630 AS Numeric(18, 0)), CAST(1 AS Numeric(18, 0)), CAST(22 AS Numeric(18, 0)), N'PRM', N'Juan Torres', CAST(N'2017-09-03' AS Date), CAST(N'2017-09-20' AS Date), 104, 0)
INSERT [dbo].[ProjectResources] ([id], [project_id], [resource_id], [project_name], [resource_name], [start_date], [end_date], [hours], [lead]) VALUES (CAST(631 AS Numeric(18, 0)), CAST(1 AS Numeric(18, 0)), CAST(24 AS Numeric(18, 0)), N'PRM', N'Juan Diaz', CAST(N'2017-09-03' AS Date), CAST(N'2017-09-20' AS Date), 104, 0)
INSERT [dbo].[ProjectResources] ([id], [project_id], [resource_id], [project_name], [resource_name], [start_date], [end_date], [hours], [lead]) VALUES (CAST(632 AS Numeric(18, 0)), CAST(3 AS Numeric(18, 0)), CAST(23 AS Numeric(18, 0)), N'CAN', N'Anderson Diaz', CAST(N'2017-09-21' AS Date), CAST(N'2017-09-29' AS Date), 56, 0)
INSERT [dbo].[ProjectResources] ([id], [project_id], [resource_id], [project_name], [resource_name], [start_date], [end_date], [hours], [lead]) VALUES (CAST(633 AS Numeric(18, 0)), CAST(2 AS Numeric(18, 0)), CAST(22 AS Numeric(18, 0)), N'GOSCE', N'Juan Torres', CAST(N'2017-10-11' AS Date), CAST(N'2017-10-11' AS Date), 8, 0)
INSERT [dbo].[ProjectResources] ([id], [project_id], [resource_id], [project_name], [resource_name], [start_date], [end_date], [hours], [lead]) VALUES (CAST(634 AS Numeric(18, 0)), CAST(2 AS Numeric(18, 0)), CAST(10 AS Numeric(18, 0)), N'GOSCE', N'German Valencia', CAST(N'2017-08-01' AS Date), CAST(N'2017-10-06' AS Date), 392, 0)
INSERT [dbo].[ProjectResources] ([id], [project_id], [resource_id], [project_name], [resource_name], [start_date], [end_date], [hours], [lead]) VALUES (CAST(635 AS Numeric(18, 0)), CAST(4 AS Numeric(18, 0)), CAST(4 AS Numeric(18, 0)), N'MLO', N'Camilo Naranjo', CAST(N'2017-09-03' AS Date), CAST(N'2017-10-06' AS Date), 200, 0)
INSERT [dbo].[ProjectResources] ([id], [project_id], [resource_id], [project_name], [resource_name], [start_date], [end_date], [hours], [lead]) VALUES (CAST(642 AS Numeric(18, 0)), CAST(2 AS Numeric(18, 0)), CAST(5 AS Numeric(18, 0)), N'GOSCE', N'David Balcazar', CAST(N'2017-09-01' AS Date), CAST(N'2017-09-30' AS Date), 80, 0)
INSERT [dbo].[ProjectResources] ([id], [project_id], [resource_id], [project_name], [resource_name], [start_date], [end_date], [hours], [lead]) VALUES (CAST(647 AS Numeric(18, 0)), CAST(3 AS Numeric(18, 0)), CAST(5 AS Numeric(18, 0)), N'CAN', N'David Balcazar', CAST(N'2017-09-15' AS Date), CAST(N'2017-09-15' AS Date), 2, 1)
INSERT [dbo].[ProjectResources] ([id], [project_id], [resource_id], [project_name], [resource_name], [start_date], [end_date], [hours], [lead]) VALUES (CAST(648 AS Numeric(18, 0)), CAST(3 AS Numeric(18, 0)), CAST(5 AS Numeric(18, 0)), N'CAN', N'David Balcazar', CAST(N'2017-09-18' AS Date), CAST(N'2017-09-18' AS Date), 7, 0)
INSERT [dbo].[ProjectResources] ([id], [project_id], [resource_id], [project_name], [resource_name], [start_date], [end_date], [hours], [lead]) VALUES (CAST(649 AS Numeric(18, 0)), CAST(2 AS Numeric(18, 0)), CAST(6 AS Numeric(18, 0)), N'GOSCE', N'Diego Guevara', CAST(N'2017-09-01' AS Date), CAST(N'2017-09-30' AS Date), 168, 0)
INSERT [dbo].[ProjectResources] ([id], [project_id], [resource_id], [project_name], [resource_name], [start_date], [end_date], [hours], [lead]) VALUES (CAST(650 AS Numeric(18, 0)), CAST(4 AS Numeric(18, 0)), CAST(11 AS Numeric(18, 0)), N'MLO', N'Jaime Salazar', CAST(N'2017-09-01' AS Date), CAST(N'2017-09-30' AS Date), 168, 0)
INSERT [dbo].[ProjectResources] ([id], [project_id], [resource_id], [project_name], [resource_name], [start_date], [end_date], [hours], [lead]) VALUES (CAST(651 AS Numeric(18, 0)), CAST(2 AS Numeric(18, 0)), CAST(22 AS Numeric(18, 0)), N'GOSCE', N'Juan Torres', CAST(N'2017-10-09' AS Date), CAST(N'2017-10-10' AS Date), 16, 0)
SET IDENTITY_INSERT [dbo].[ProjectResources] OFF
SET IDENTITY_INSERT [dbo].[Resource] ON 

INSERT [dbo].[Resource] ([id], [name], [last_name], [email], [photo], [engineer_range], [enabled]) VALUES (CAST(1 AS Numeric(18, 0)), N'Alejandro', N'Vizcaino', N'Alejandro.Vizcaino@omnicon.cc', N'test', N'E4', 1)
INSERT [dbo].[Resource] ([id], [name], [last_name], [email], [photo], [engineer_range], [enabled]) VALUES (CAST(2 AS Numeric(18, 0)), N'Ana', N'Rodriguez', N'Ana.Rodriguez@omnicon.cc', N'test', N'E1', 1)
INSERT [dbo].[Resource] ([id], [name], [last_name], [email], [photo], [engineer_range], [enabled]) VALUES (CAST(3 AS Numeric(18, 0)), N'Stephanie', N'Restrepo', N'Stephanie.Restrepo@omnicon.cc', N'/photos/resources/Stephanie.Restrepo.jpg', N'E1', 1)
INSERT [dbo].[Resource] ([id], [name], [last_name], [email], [photo], [engineer_range], [enabled]) VALUES (CAST(4 AS Numeric(18, 0)), N'Camilo', N'Naranjo', N'Camilo.Naranjo@omnicon.cc', N'/photos/resources/Camilo.Naranjo.jpg', N'E1', 1)
INSERT [dbo].[Resource] ([id], [name], [last_name], [email], [photo], [engineer_range], [enabled]) VALUES (CAST(5 AS Numeric(18, 0)), N'David', N'Balcazar', N'David.Balcazar@omnicon.cc', N'/photos/resources/David.Balcazar.jpg', N'E1', 1)
INSERT [dbo].[Resource] ([id], [name], [last_name], [email], [photo], [engineer_range], [enabled]) VALUES (CAST(6 AS Numeric(18, 0)), N'Diego', N'Guevara', N'Diego.Guevara@omnicon.cc', N'/photos/resources/Diego.Guevara.jpg', N'E1', 1)
INSERT [dbo].[Resource] ([id], [name], [last_name], [email], [photo], [engineer_range], [enabled]) VALUES (CAST(7 AS Numeric(18, 0)), N'Diego', N'Paz', N'Diego.Paz@omnicon.cc', N'test', N'E4', 1)
INSERT [dbo].[Resource] ([id], [name], [last_name], [email], [photo], [engineer_range], [enabled]) VALUES (CAST(8 AS Numeric(18, 0)), N'Edgar', N'Escalante', N'Edgar.Escalante@omnicon.cc', N'/photos/resources/Edgar.Escalante.jpg', N'E1', 1)
INSERT [dbo].[Resource] ([id], [name], [last_name], [email], [photo], [engineer_range], [enabled]) VALUES (CAST(9 AS Numeric(18, 0)), N'Edward', N'Gallego', N'Edward.Gallego@omnicon.cc', N'/photos/resources/Edward.Gallego.jpg', N'E1', 1)
INSERT [dbo].[Resource] ([id], [name], [last_name], [email], [photo], [engineer_range], [enabled]) VALUES (CAST(10 AS Numeric(18, 0)), N'German', N'Valencia', N'German.Valencia@omnicon.cc', N'/photos/resources/German.Valencia.jpg', N'E1', 1)
INSERT [dbo].[Resource] ([id], [name], [last_name], [email], [photo], [engineer_range], [enabled]) VALUES (CAST(11 AS Numeric(18, 0)), N'Jaime', N'Salazar', N'Jaime.Salazar@omnicon.cc', N'/photos/resources/Jaime.Salazar.jpg', N'E1', 1)
INSERT [dbo].[Resource] ([id], [name], [last_name], [email], [photo], [engineer_range], [enabled]) VALUES (CAST(12 AS Numeric(18, 0)), N'Johan', N'Porras', N'Johan.Porras@omnicon.cc', N'/photos/resources/Johan.Porras.jpg', N'E1', 1)
INSERT [dbo].[Resource] ([id], [name], [last_name], [email], [photo], [engineer_range], [enabled]) VALUES (CAST(13 AS Numeric(18, 0)), N'Jose', N'Aguirre', N'Jose.Aguirre@omnicon.cc', N'/photos/resources/Jose.Aguirre.jpg', N'E1', 1)
INSERT [dbo].[Resource] ([id], [name], [last_name], [email], [photo], [engineer_range], [enabled]) VALUES (CAST(14 AS Numeric(18, 0)), N'Jose', N'Torres', N'Jose.Torres@omnicon.cc', N'/photos/resources/Jose.Torres.jpg', N'E1', 1)
INSERT [dbo].[Resource] ([id], [name], [last_name], [email], [photo], [engineer_range], [enabled]) VALUES (CAST(15 AS Numeric(18, 0)), N'Juan', N'Ardila', N'Juan.Ardila@omnicon.cc', N'test', N'E1', 0)
INSERT [dbo].[Resource] ([id], [name], [last_name], [email], [photo], [engineer_range], [enabled]) VALUES (CAST(16 AS Numeric(18, 0)), N'Juan', N'Trujillo', N'Juan.Trujillo@omnicon.cc', N'/photos/resources/Juan.Trujillo.jpg', N'E1', 1)
INSERT [dbo].[Resource] ([id], [name], [last_name], [email], [photo], [engineer_range], [enabled]) VALUES (CAST(17 AS Numeric(18, 0)), N'Julieth', N'Villota', N'Julieth.Villota@omnicon.cc', N'/photos/resources/Julieth.Villota.jpg', N'E1', 1)
INSERT [dbo].[Resource] ([id], [name], [last_name], [email], [photo], [engineer_range], [enabled]) VALUES (CAST(18 AS Numeric(18, 0)), N'Karol', N'Gallardo', N'Karol.Gallardo@omnicon.cc', N'/photos/resources/Karol.Gallardo.jpg', N'E1', 1)
INSERT [dbo].[Resource] ([id], [name], [last_name], [email], [photo], [engineer_range], [enabled]) VALUES (CAST(19 AS Numeric(18, 0)), N'Nelly', N' Segura', N'Nelly. Segura@omnicon.cc', N'/photos/resources/Nelly. Segura.jpg', N'E1', 1)
INSERT [dbo].[Resource] ([id], [name], [last_name], [email], [photo], [engineer_range], [enabled]) VALUES (CAST(20 AS Numeric(18, 0)), N'Patricia', N'Vargas', N'Patricia.Vargas@omnicon.cc', N'/photos/resources/Patricia.Vargas.jpg', N'E1', 1)
INSERT [dbo].[Resource] ([id], [name], [last_name], [email], [photo], [engineer_range], [enabled]) VALUES (CAST(21 AS Numeric(18, 0)), N'Sebastian', N'Orozco', N'Sebastian.Orozco@omnicon.cc', N'/photos/resources/Sebastian.Orozco.jpg', N'E1', 1)
INSERT [dbo].[Resource] ([id], [name], [last_name], [email], [photo], [engineer_range], [enabled]) VALUES (CAST(22 AS Numeric(18, 0)), N'Juan', N'Torres', N'Juan.Torres@omnicon.cc', N'/photos/resources/Juan.Torres.jpg', N'E1', 1)
INSERT [dbo].[Resource] ([id], [name], [last_name], [email], [photo], [engineer_range], [enabled]) VALUES (CAST(23 AS Numeric(18, 0)), N'Anderson', N'Diaz', N'Anderson.Diaz@omnicon.cc', N'test', N'E3', 1)
INSERT [dbo].[Resource] ([id], [name], [last_name], [email], [photo], [engineer_range], [enabled]) VALUES (CAST(24 AS Numeric(18, 0)), N'Juan', N'Diaz', N'Juan.Diaz@omnicon.cc', N'test', N'E3', 1)
INSERT [dbo].[Resource] ([id], [name], [last_name], [email], [photo], [engineer_range], [enabled]) VALUES (CAST(25 AS Numeric(18, 0)), N'Manuel', N'Barona', N'Manuel.Barona@omnicon.cc', N'/photos/resources/Manuel.Barona.jpg', N'E1', 1)
INSERT [dbo].[Resource] ([id], [name], [last_name], [email], [photo], [engineer_range], [enabled]) VALUES (CAST(26 AS Numeric(18, 0)), N'Julian', N'Espinosa', N'Julian.Espinosa@omnicon.cc', N'/photos/resources/Julian.Espinosa.jpg', N'E1', 1)
SET IDENTITY_INSERT [dbo].[Resource] OFF
SET IDENTITY_INSERT [dbo].[ResourceSkills] ON 

INSERT [dbo].[ResourceSkills] ([id], [resource_id], [skill_id], [name], [value]) VALUES (CAST(85 AS Numeric(18, 0)), CAST(2 AS Numeric(18, 0)), CAST(47 AS Numeric(18, 0)), N'MOM', 88)
INSERT [dbo].[ResourceSkills] ([id], [resource_id], [skill_id], [name], [value]) VALUES (CAST(86 AS Numeric(18, 0)), CAST(2 AS Numeric(18, 0)), CAST(48 AS Numeric(18, 0)), N'English', 90)
INSERT [dbo].[ResourceSkills] ([id], [resource_id], [skill_id], [name], [value]) VALUES (CAST(141 AS Numeric(18, 0)), CAST(23 AS Numeric(18, 0)), CAST(50 AS Numeric(18, 0)), N'Savigent', 100)
INSERT [dbo].[ResourceSkills] ([id], [resource_id], [skill_id], [name], [value]) VALUES (CAST(144 AS Numeric(18, 0)), CAST(24 AS Numeric(18, 0)), CAST(50 AS Numeric(18, 0)), N'Savigent', 80)
INSERT [dbo].[ResourceSkills] ([id], [resource_id], [skill_id], [name], [value]) VALUES (CAST(147 AS Numeric(18, 0)), CAST(23 AS Numeric(18, 0)), CAST(48 AS Numeric(18, 0)), N'English', 61)
INSERT [dbo].[ResourceSkills] ([id], [resource_id], [skill_id], [name], [value]) VALUES (CAST(148 AS Numeric(18, 0)), CAST(23 AS Numeric(18, 0)), CAST(49 AS Numeric(18, 0)), N'HTML', 70)
INSERT [dbo].[ResourceSkills] ([id], [resource_id], [skill_id], [name], [value]) VALUES (CAST(149 AS Numeric(18, 0)), CAST(1 AS Numeric(18, 0)), CAST(48 AS Numeric(18, 0)), N'English', 99)
INSERT [dbo].[ResourceSkills] ([id], [resource_id], [skill_id], [name], [value]) VALUES (CAST(150 AS Numeric(18, 0)), CAST(11 AS Numeric(18, 0)), CAST(50 AS Numeric(18, 0)), N'Savigent', 100)
INSERT [dbo].[ResourceSkills] ([id], [resource_id], [skill_id], [name], [value]) VALUES (CAST(154 AS Numeric(18, 0)), CAST(1 AS Numeric(18, 0)), CAST(52 AS Numeric(18, 0)), N'Soft Skills', 30)
SET IDENTITY_INSERT [dbo].[ResourceSkills] OFF
SET IDENTITY_INSERT [dbo].[Skill] ON 

INSERT [dbo].[Skill] ([id], [name]) VALUES (CAST(47 AS Numeric(18, 0)), N'MOM')
INSERT [dbo].[Skill] ([id], [name]) VALUES (CAST(48 AS Numeric(18, 0)), N'English')
INSERT [dbo].[Skill] ([id], [name]) VALUES (CAST(49 AS Numeric(18, 0)), N'HTML')
INSERT [dbo].[Skill] ([id], [name]) VALUES (CAST(50 AS Numeric(18, 0)), N'Savigent')
INSERT [dbo].[Skill] ([id], [name]) VALUES (CAST(52 AS Numeric(18, 0)), N'Soft Skills')
INSERT [dbo].[Skill] ([id], [name]) VALUES (CAST(53 AS Numeric(18, 0)), N'Mapping')
INSERT [dbo].[Skill] ([id], [name]) VALUES (CAST(333 AS Numeric(18, 0)), N'test')
SET IDENTITY_INSERT [dbo].[Skill] OFF
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProjectResources_Project]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProjectResources]'))
ALTER TABLE [dbo].[ProjectResources]  WITH CHECK ADD  CONSTRAINT [FK_ProjectResources_Project] FOREIGN KEY([project_id])
REFERENCES [dbo].[Project] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProjectResources_Project]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProjectResources]'))
ALTER TABLE [dbo].[ProjectResources] CHECK CONSTRAINT [FK_ProjectResources_Project]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProjectResources_Resource]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProjectResources]'))
ALTER TABLE [dbo].[ProjectResources]  WITH CHECK ADD  CONSTRAINT [FK_ProjectResources_Resource] FOREIGN KEY([resource_id])
REFERENCES [dbo].[Resource] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProjectResources_Resource]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProjectResources]'))
ALTER TABLE [dbo].[ProjectResources] CHECK CONSTRAINT [FK_ProjectResources_Resource]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ResourceSkills_Resource]') AND parent_object_id = OBJECT_ID(N'[dbo].[ResourceSkills]'))
ALTER TABLE [dbo].[ResourceSkills]  WITH CHECK ADD  CONSTRAINT [FK_ResourceSkills_Resource] FOREIGN KEY([resource_id])
REFERENCES [dbo].[Resource] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ResourceSkills_Resource]') AND parent_object_id = OBJECT_ID(N'[dbo].[ResourceSkills]'))
ALTER TABLE [dbo].[ResourceSkills] CHECK CONSTRAINT [FK_ResourceSkills_Resource]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ResourceSkills_Skill]') AND parent_object_id = OBJECT_ID(N'[dbo].[ResourceSkills]'))
ALTER TABLE [dbo].[ResourceSkills]  WITH CHECK ADD  CONSTRAINT [FK_ResourceSkills_Skill] FOREIGN KEY([skill_id])
REFERENCES [dbo].[Skill] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ResourceSkills_Skill]') AND parent_object_id = OBJECT_ID(N'[dbo].[ResourceSkills]'))
ALTER TABLE [dbo].[ResourceSkills] CHECK CONSTRAINT [FK_ResourceSkills_Skill]
GO
