USE [master]
GO
/****** Object:  Database [prm]    Script Date: 2/7/2018 12:59:42 PM ******/
CREATE DATABASE [prm]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'prm', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\prm.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'prm_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\prm_log.ldf' , SIZE = 2304KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [prm] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [prm].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [prm] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [prm] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [prm] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [prm] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [prm] SET ARITHABORT OFF 
GO
ALTER DATABASE [prm] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [prm] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [prm] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [prm] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [prm] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [prm] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [prm] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [prm] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [prm] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [prm] SET  DISABLE_BROKER 
GO
ALTER DATABASE [prm] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [prm] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [prm] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [prm] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [prm] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [prm] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [prm] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [prm] SET RECOVERY FULL 
GO
ALTER DATABASE [prm] SET  MULTI_USER 
GO
ALTER DATABASE [prm] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [prm] SET DB_CHAINING OFF 
GO
ALTER DATABASE [prm] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [prm] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [prm] SET DELAYED_DURABILITY = DISABLED 
GO
USE [prm]
GO
/****** Object:  User [admin]    Script Date: 2/7/2018 12:59:43 PM ******/
CREATE USER [admin] FOR LOGIN [admin] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  Table [dbo].[ProductivityReport]    Script Date: 2/7/2018 12:59:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductivityReport](
	[id] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[task_id] [numeric](18, 0) NOT NULL,
	[resource_id] [numeric](18, 0) NOT NULL,
	[hours] [numeric](18, 2) NOT NULL,
	[hours_billable] [numeric](18, 2) NOT NULL,
 CONSTRAINT [PK_ProductivityReport] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProductivityTasks]    Script Date: 2/7/2018 12:59:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductivityTasks](
	[id] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[project_id] [numeric](18, 0) NOT NULL,
	[name] [nvarchar](50) NOT NULL,
	[total_execute] [numeric](18, 2) NOT NULL,
	[scheduled] [numeric](18, 2) NOT NULL,
	[progress] [numeric](18, 2) NOT NULL,
	[is_out_of_scope] [bit] NOT NULL,
	[total_billable] [numeric](18, 2) NOT NULL,
 CONSTRAINT [PK_ProductivityTasks] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Project]    Script Date: 2/7/2018 12:59:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Project](
	[id] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[name] [varchar](50) NULL,
	[start_date] [date] NULL,
	[end_date] [date] NULL,
	[enabled] [bit] NULL,
	[operation_center] [nvarchar](50) NOT NULL,
	[work_order] [int] NOT NULL,
	[leader_id] [numeric](18, 0) NULL,
	[cost] [decimal](19, 4) NULL,
 CONSTRAINT [PK_Project] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProjectForecast]    Script Date: 2/7/2018 12:59:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProjectForecast](
	[id] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[name] [varchar](50) NOT NULL,
	[business_unit] [varchar](50) NOT NULL,
	[region] [varchar](50) NOT NULL,
	[description] [varchar](140) NULL,
	[start_date] [date] NOT NULL,
	[end_date] [date] NOT NULL,
	[hours] [float] NOT NULL,
	[number_sites] [numeric](18, 0) NOT NULL,
	[number_process_per_site] [numeric](18, 0) NOT NULL,
	[number_process_total] [numeric](18, 0) NOT NULL,
	[estimate_cost] [float] NOT NULL,
	[billing_date] [date] NOT NULL,
	[status] [varchar](50) NOT NULL,
 CONSTRAINT [PK_ProjectForecast] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProjectForecastAssigns]    Script Date: 2/7/2018 12:59:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProjectForecastAssigns](
	[id] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[projectForecast_id] [numeric](18, 0) NOT NULL,
	[projectForecast_name] [varchar](50) NOT NULL,
	[type_id] [numeric](18, 0) NOT NULL,
	[type_name] [varchar](50) NOT NULL,
	[number_resources] [int] NOT NULL,
 CONSTRAINT [PK_ProjectForecastAssigns] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProjectForecastTypes]    Script Date: 2/7/2018 12:59:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProjectForecastTypes](
	[id] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[projectForecast_id] [numeric](18, 0) NOT NULL,
	[type_id] [numeric](18, 0) NOT NULL,
 CONSTRAINT [PK_ProjectForecastTypes] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProjectResources]    Script Date: 2/7/2018 12:59:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
GO
/****** Object:  Table [dbo].[ProjectTypes]    Script Date: 2/7/2018 12:59:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProjectTypes](
	[id] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[project_id] [numeric](18, 0) NOT NULL,
	[type_id] [numeric](18, 0) NOT NULL,
	[type_name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_ProjectTypes] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Resource]    Script Date: 2/7/2018 12:59:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Resource](
	[id] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[name] [varchar](50) NULL,
	[last_name] [varchar](50) NULL,
	[email] [varchar](50) NULL,
	[photo] [varchar](50) NULL,
	[engineer_range] [varchar](2) NULL,
	[enabled] [bit] NULL,
	[visa_us] [nvarchar](50) NULL,
 CONSTRAINT [PK_Resource] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ResourceSkills]    Script Date: 2/7/2018 12:59:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
GO
/****** Object:  Table [dbo].[ResourceTypes]    Script Date: 2/7/2018 12:59:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ResourceTypes](
	[id] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[resource_id] [numeric](18, 0) NOT NULL,
	[type_id] [numeric](18, 0) NOT NULL,
	[type_name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_ResourceTypes] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Settings]    Script Date: 2/7/2018 12:59:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Settings](
	[id] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](50) NOT NULL,
	[value] [nvarchar](800) NOT NULL,
	[type] [nvarchar](50) NOT NULL,
	[description] [nvarchar](500) NULL,
 CONSTRAINT [PK_Settings] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Skill]    Script Date: 2/7/2018 12:59:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Skill](
	[id] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[name] [varchar](50) NULL,
 CONSTRAINT [PK_Skill] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Training]    Script Date: 2/7/2018 12:59:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Training](
	[id] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[type_id] [numeric](18, 0) NOT NULL,
	[skill_id] [numeric](18, 0) NOT NULL,
	[name] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_training] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TrainingResources]    Script Date: 2/7/2018 12:59:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TrainingResources](
	[id] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[training_id] [numeric](18, 0) NOT NULL,
	[resource_id] [numeric](18, 0) NOT NULL,
	[start_date] [date] NULL,
	[end_date] [date] NULL,
	[duration] [int] NULL,
	[progress] [int] NULL,
	[test_result] [int] NULL,
	[result_status] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_TrainingResources] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Type]    Script Date: 2/7/2018 12:59:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Type](
	[id] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](50) NOT NULL,
	[apply_to] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_type] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TypeSkills]    Script Date: 2/7/2018 12:59:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TypeSkills](
	[id] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[type_id] [numeric](18, 0) NOT NULL,
	[skill_id] [numeric](18, 0) NOT NULL,
	[skill_name] [varchar](50) NOT NULL,
	[value] [int] NOT NULL,
 CONSTRAINT [PK_ProjectTypeSkills] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[ProductivityReport] ON 

INSERT [dbo].[ProductivityReport] ([id], [task_id], [resource_id], [hours], [hours_billable]) VALUES (CAST(8 AS Numeric(18, 0)), CAST(1 AS Numeric(18, 0)), CAST(9 AS Numeric(18, 0)), CAST(30.00 AS Numeric(18, 2)), CAST(25.00 AS Numeric(18, 2)))
INSERT [dbo].[ProductivityReport] ([id], [task_id], [resource_id], [hours], [hours_billable]) VALUES (CAST(10 AS Numeric(18, 0)), CAST(3 AS Numeric(18, 0)), CAST(9 AS Numeric(18, 0)), CAST(6.00 AS Numeric(18, 2)), CAST(6.00 AS Numeric(18, 2)))
INSERT [dbo].[ProductivityReport] ([id], [task_id], [resource_id], [hours], [hours_billable]) VALUES (CAST(11 AS Numeric(18, 0)), CAST(19 AS Numeric(18, 0)), CAST(9 AS Numeric(18, 0)), CAST(25.00 AS Numeric(18, 2)), CAST(20.00 AS Numeric(18, 2)))
INSERT [dbo].[ProductivityReport] ([id], [task_id], [resource_id], [hours], [hours_billable]) VALUES (CAST(16 AS Numeric(18, 0)), CAST(14 AS Numeric(18, 0)), CAST(24 AS Numeric(18, 0)), CAST(7.00 AS Numeric(18, 2)), CAST(7.00 AS Numeric(18, 2)))
INSERT [dbo].[ProductivityReport] ([id], [task_id], [resource_id], [hours], [hours_billable]) VALUES (CAST(17 AS Numeric(18, 0)), CAST(14 AS Numeric(18, 0)), CAST(10027 AS Numeric(18, 0)), CAST(1.00 AS Numeric(18, 2)), CAST(1.00 AS Numeric(18, 2)))
INSERT [dbo].[ProductivityReport] ([id], [task_id], [resource_id], [hours], [hours_billable]) VALUES (CAST(18 AS Numeric(18, 0)), CAST(11 AS Numeric(18, 0)), CAST(24 AS Numeric(18, 0)), CAST(3.00 AS Numeric(18, 2)), CAST(3.00 AS Numeric(18, 2)))
INSERT [dbo].[ProductivityReport] ([id], [task_id], [resource_id], [hours], [hours_billable]) VALUES (CAST(19 AS Numeric(18, 0)), CAST(13 AS Numeric(18, 0)), CAST(24 AS Numeric(18, 0)), CAST(7.00 AS Numeric(18, 2)), CAST(7.00 AS Numeric(18, 2)))
INSERT [dbo].[ProductivityReport] ([id], [task_id], [resource_id], [hours], [hours_billable]) VALUES (CAST(20 AS Numeric(18, 0)), CAST(11 AS Numeric(18, 0)), CAST(10027 AS Numeric(18, 0)), CAST(15.00 AS Numeric(18, 2)), CAST(15.00 AS Numeric(18, 2)))
INSERT [dbo].[ProductivityReport] ([id], [task_id], [resource_id], [hours], [hours_billable]) VALUES (CAST(21 AS Numeric(18, 0)), CAST(13 AS Numeric(18, 0)), CAST(10027 AS Numeric(18, 0)), CAST(23.00 AS Numeric(18, 2)), CAST(23.00 AS Numeric(18, 2)))
INSERT [dbo].[ProductivityReport] ([id], [task_id], [resource_id], [hours], [hours_billable]) VALUES (CAST(23 AS Numeric(18, 0)), CAST(7 AS Numeric(18, 0)), CAST(20 AS Numeric(18, 0)), CAST(55.00 AS Numeric(18, 2)), CAST(55.00 AS Numeric(18, 2)))
INSERT [dbo].[ProductivityReport] ([id], [task_id], [resource_id], [hours], [hours_billable]) VALUES (CAST(27 AS Numeric(18, 0)), CAST(20 AS Numeric(18, 0)), CAST(26 AS Numeric(18, 0)), CAST(100.00 AS Numeric(18, 2)), CAST(100.00 AS Numeric(18, 2)))
INSERT [dbo].[ProductivityReport] ([id], [task_id], [resource_id], [hours], [hours_billable]) VALUES (CAST(10005 AS Numeric(18, 0)), CAST(10019 AS Numeric(18, 0)), CAST(9 AS Numeric(18, 0)), CAST(24.00 AS Numeric(18, 2)), CAST(22.00 AS Numeric(18, 2)))
INSERT [dbo].[ProductivityReport] ([id], [task_id], [resource_id], [hours], [hours_billable]) VALUES (CAST(10006 AS Numeric(18, 0)), CAST(10021 AS Numeric(18, 0)), CAST(9 AS Numeric(18, 0)), CAST(50.00 AS Numeric(18, 2)), CAST(50.00 AS Numeric(18, 2)))
INSERT [dbo].[ProductivityReport] ([id], [task_id], [resource_id], [hours], [hours_billable]) VALUES (CAST(10007 AS Numeric(18, 0)), CAST(10020 AS Numeric(18, 0)), CAST(10 AS Numeric(18, 0)), CAST(80.00 AS Numeric(18, 2)), CAST(80.00 AS Numeric(18, 2)))
INSERT [dbo].[ProductivityReport] ([id], [task_id], [resource_id], [hours], [hours_billable]) VALUES (CAST(10008 AS Numeric(18, 0)), CAST(10022 AS Numeric(18, 0)), CAST(9 AS Numeric(18, 0)), CAST(23.00 AS Numeric(18, 2)), CAST(23.00 AS Numeric(18, 2)))
INSERT [dbo].[ProductivityReport] ([id], [task_id], [resource_id], [hours], [hours_billable]) VALUES (CAST(10009 AS Numeric(18, 0)), CAST(10022 AS Numeric(18, 0)), CAST(10 AS Numeric(18, 0)), CAST(8.00 AS Numeric(18, 2)), CAST(8.00 AS Numeric(18, 2)))
INSERT [dbo].[ProductivityReport] ([id], [task_id], [resource_id], [hours], [hours_billable]) VALUES (CAST(10010 AS Numeric(18, 0)), CAST(10020 AS Numeric(18, 0)), CAST(18 AS Numeric(18, 0)), CAST(5.00 AS Numeric(18, 2)), CAST(5.00 AS Numeric(18, 2)))
INSERT [dbo].[ProductivityReport] ([id], [task_id], [resource_id], [hours], [hours_billable]) VALUES (CAST(10011 AS Numeric(18, 0)), CAST(10023 AS Numeric(18, 0)), CAST(18 AS Numeric(18, 0)), CAST(80.00 AS Numeric(18, 2)), CAST(80.00 AS Numeric(18, 2)))
INSERT [dbo].[ProductivityReport] ([id], [task_id], [resource_id], [hours], [hours_billable]) VALUES (CAST(10012 AS Numeric(18, 0)), CAST(10023 AS Numeric(18, 0)), CAST(9 AS Numeric(18, 0)), CAST(20.00 AS Numeric(18, 2)), CAST(20.00 AS Numeric(18, 2)))
INSERT [dbo].[ProductivityReport] ([id], [task_id], [resource_id], [hours], [hours_billable]) VALUES (CAST(10013 AS Numeric(18, 0)), CAST(10024 AS Numeric(18, 0)), CAST(9 AS Numeric(18, 0)), CAST(20.00 AS Numeric(18, 2)), CAST(20.00 AS Numeric(18, 2)))
INSERT [dbo].[ProductivityReport] ([id], [task_id], [resource_id], [hours], [hours_billable]) VALUES (CAST(10014 AS Numeric(18, 0)), CAST(10025 AS Numeric(18, 0)), CAST(9 AS Numeric(18, 0)), CAST(1.00 AS Numeric(18, 2)), CAST(1.00 AS Numeric(18, 2)))
INSERT [dbo].[ProductivityReport] ([id], [task_id], [resource_id], [hours], [hours_billable]) VALUES (CAST(10015 AS Numeric(18, 0)), CAST(10025 AS Numeric(18, 0)), CAST(10 AS Numeric(18, 0)), CAST(30.00 AS Numeric(18, 2)), CAST(30.00 AS Numeric(18, 2)))
INSERT [dbo].[ProductivityReport] ([id], [task_id], [resource_id], [hours], [hours_billable]) VALUES (CAST(10016 AS Numeric(18, 0)), CAST(10024 AS Numeric(18, 0)), CAST(10 AS Numeric(18, 0)), CAST(10.00 AS Numeric(18, 2)), CAST(10.00 AS Numeric(18, 2)))
INSERT [dbo].[ProductivityReport] ([id], [task_id], [resource_id], [hours], [hours_billable]) VALUES (CAST(20005 AS Numeric(18, 0)), CAST(10027 AS Numeric(18, 0)), CAST(18 AS Numeric(18, 0)), CAST(4.00 AS Numeric(18, 2)), CAST(4.00 AS Numeric(18, 2)))
INSERT [dbo].[ProductivityReport] ([id], [task_id], [resource_id], [hours], [hours_billable]) VALUES (CAST(20006 AS Numeric(18, 0)), CAST(10027 AS Numeric(18, 0)), CAST(9 AS Numeric(18, 0)), CAST(4.00 AS Numeric(18, 2)), CAST(2.00 AS Numeric(18, 2)))
INSERT [dbo].[ProductivityReport] ([id], [task_id], [resource_id], [hours], [hours_billable]) VALUES (CAST(20007 AS Numeric(18, 0)), CAST(10021 AS Numeric(18, 0)), CAST(10 AS Numeric(18, 0)), CAST(3.00 AS Numeric(18, 2)), CAST(3.00 AS Numeric(18, 2)))
INSERT [dbo].[ProductivityReport] ([id], [task_id], [resource_id], [hours], [hours_billable]) VALUES (CAST(20008 AS Numeric(18, 0)), CAST(10029 AS Numeric(18, 0)), CAST(18 AS Numeric(18, 0)), CAST(10.00 AS Numeric(18, 2)), CAST(8.00 AS Numeric(18, 2)))
SET IDENTITY_INSERT [dbo].[ProductivityReport] OFF
SET IDENTITY_INSERT [dbo].[ProductivityTasks] ON 

INSERT [dbo].[ProductivityTasks] ([id], [project_id], [name], [total_execute], [scheduled], [progress], [is_out_of_scope], [total_billable]) VALUES (CAST(1 AS Numeric(18, 0)), CAST(345 AS Numeric(18, 0)), N'TST TASK 3.1', CAST(30.00 AS Numeric(18, 2)), CAST(71.00 AS Numeric(18, 2)), CAST(61.00 AS Numeric(18, 2)), 0, CAST(25.00 AS Numeric(18, 2)))
INSERT [dbo].[ProductivityTasks] ([id], [project_id], [name], [total_execute], [scheduled], [progress], [is_out_of_scope], [total_billable]) VALUES (CAST(3 AS Numeric(18, 0)), CAST(345 AS Numeric(18, 0)), N'TST TASK 4', CAST(6.00 AS Numeric(18, 2)), CAST(60.00 AS Numeric(18, 2)), CAST(100.00 AS Numeric(18, 2)), 1, CAST(6.00 AS Numeric(18, 2)))
INSERT [dbo].[ProductivityTasks] ([id], [project_id], [name], [total_execute], [scheduled], [progress], [is_out_of_scope], [total_billable]) VALUES (CAST(7 AS Numeric(18, 0)), CAST(4 AS Numeric(18, 0)), N'Review', CAST(55.00 AS Numeric(18, 2)), CAST(10.00 AS Numeric(18, 2)), CAST(15.00 AS Numeric(18, 2)), 0, CAST(55.00 AS Numeric(18, 2)))
INSERT [dbo].[ProductivityTasks] ([id], [project_id], [name], [total_execute], [scheduled], [progress], [is_out_of_scope], [total_billable]) VALUES (CAST(11 AS Numeric(18, 0)), CAST(10370 AS Numeric(18, 0)), N'Santa Claus', CAST(18.00 AS Numeric(18, 2)), CAST(24.00 AS Numeric(18, 2)), CAST(15.00 AS Numeric(18, 2)), 0, CAST(18.00 AS Numeric(18, 2)))
INSERT [dbo].[ProductivityTasks] ([id], [project_id], [name], [total_execute], [scheduled], [progress], [is_out_of_scope], [total_billable]) VALUES (CAST(13 AS Numeric(18, 0)), CAST(10370 AS Numeric(18, 0)), N'Task 1', CAST(30.00 AS Numeric(18, 2)), CAST(10.00 AS Numeric(18, 2)), CAST(25.00 AS Numeric(18, 2)), 0, CAST(30.00 AS Numeric(18, 2)))
INSERT [dbo].[ProductivityTasks] ([id], [project_id], [name], [total_execute], [scheduled], [progress], [is_out_of_scope], [total_billable]) VALUES (CAST(14 AS Numeric(18, 0)), CAST(10370 AS Numeric(18, 0)), N'Recommendation Module', CAST(8.00 AS Numeric(18, 2)), CAST(49.00 AS Numeric(18, 2)), CAST(100.00 AS Numeric(18, 2)), 0, CAST(8.00 AS Numeric(18, 2)))
INSERT [dbo].[ProductivityTasks] ([id], [project_id], [name], [total_execute], [scheduled], [progress], [is_out_of_scope], [total_billable]) VALUES (CAST(19 AS Numeric(18, 0)), CAST(345 AS Numeric(18, 0)), N'TST TASK F', CAST(25.00 AS Numeric(18, 2)), CAST(100.00 AS Numeric(18, 2)), CAST(100.00 AS Numeric(18, 2)), 0, CAST(20.00 AS Numeric(18, 2)))
INSERT [dbo].[ProductivityTasks] ([id], [project_id], [name], [total_execute], [scheduled], [progress], [is_out_of_scope], [total_billable]) VALUES (CAST(20 AS Numeric(18, 0)), CAST(10371 AS Numeric(18, 0)), N'Task Tst', CAST(100.00 AS Numeric(18, 2)), CAST(200.00 AS Numeric(18, 2)), CAST(50.00 AS Numeric(18, 2)), 0, CAST(100.00 AS Numeric(18, 2)))
INSERT [dbo].[ProductivityTasks] ([id], [project_id], [name], [total_execute], [scheduled], [progress], [is_out_of_scope], [total_billable]) VALUES (CAST(10019 AS Numeric(18, 0)), CAST(361 AS Numeric(18, 0)), N'Recommendation Module', CAST(24.00 AS Numeric(18, 2)), CAST(49.00 AS Numeric(18, 2)), CAST(100.00 AS Numeric(18, 2)), 0, CAST(22.00 AS Numeric(18, 2)))
INSERT [dbo].[ProductivityTasks] ([id], [project_id], [name], [total_execute], [scheduled], [progress], [is_out_of_scope], [total_billable]) VALUES (CAST(10020 AS Numeric(18, 0)), CAST(361 AS Numeric(18, 0)), N'New Views', CAST(85.00 AS Numeric(18, 2)), CAST(16.00 AS Numeric(18, 2)), CAST(100.00 AS Numeric(18, 2)), 0, CAST(85.00 AS Numeric(18, 2)))
INSERT [dbo].[ProductivityTasks] ([id], [project_id], [name], [total_execute], [scheduled], [progress], [is_out_of_scope], [total_billable]) VALUES (CAST(10021 AS Numeric(18, 0)), CAST(361 AS Numeric(18, 0)), N'Add security module', CAST(53.00 AS Numeric(18, 2)), CAST(36.00 AS Numeric(18, 2)), CAST(100.00 AS Numeric(18, 2)), 0, CAST(53.00 AS Numeric(18, 2)))
INSERT [dbo].[ProductivityTasks] ([id], [project_id], [name], [total_execute], [scheduled], [progress], [is_out_of_scope], [total_billable]) VALUES (CAST(10022 AS Numeric(18, 0)), CAST(361 AS Numeric(18, 0)), N'Add reports', CAST(31.00 AS Numeric(18, 2)), CAST(36.00 AS Numeric(18, 2)), CAST(100.00 AS Numeric(18, 2)), 0, CAST(31.00 AS Numeric(18, 2)))
INSERT [dbo].[ProductivityTasks] ([id], [project_id], [name], [total_execute], [scheduled], [progress], [is_out_of_scope], [total_billable]) VALUES (CAST(10023 AS Numeric(18, 0)), CAST(361 AS Numeric(18, 0)), N'Update documentation', CAST(100.00 AS Numeric(18, 2)), CAST(12.00 AS Numeric(18, 2)), CAST(100.00 AS Numeric(18, 2)), 0, CAST(100.00 AS Numeric(18, 2)))
INSERT [dbo].[ProductivityTasks] ([id], [project_id], [name], [total_execute], [scheduled], [progress], [is_out_of_scope], [total_billable]) VALUES (CAST(10024 AS Numeric(18, 0)), CAST(361 AS Numeric(18, 0)), N'Deploy PRM 4.0', CAST(32.00 AS Numeric(18, 2)), CAST(100.00 AS Numeric(18, 2)), CAST(100.00 AS Numeric(18, 2)), 0, CAST(20.00 AS Numeric(18, 2)))
INSERT [dbo].[ProductivityTasks] ([id], [project_id], [name], [total_execute], [scheduled], [progress], [is_out_of_scope], [total_billable]) VALUES (CAST(10025 AS Numeric(18, 0)), CAST(361 AS Numeric(18, 0)), N'Out of Scope', CAST(31.00 AS Numeric(18, 2)), CAST(3.00 AS Numeric(18, 2)), CAST(100.00 AS Numeric(18, 2)), 1, CAST(31.00 AS Numeric(18, 2)))
INSERT [dbo].[ProductivityTasks] ([id], [project_id], [name], [total_execute], [scheduled], [progress], [is_out_of_scope], [total_billable]) VALUES (CAST(10027 AS Numeric(18, 0)), CAST(361 AS Numeric(18, 0)), N'Add out of scope option', CAST(8.00 AS Numeric(18, 2)), CAST(10.00 AS Numeric(18, 2)), CAST(100.00 AS Numeric(18, 2)), 1, CAST(6.00 AS Numeric(18, 2)))
INSERT [dbo].[ProductivityTasks] ([id], [project_id], [name], [total_execute], [scheduled], [progress], [is_out_of_scope], [total_billable]) VALUES (CAST(10028 AS Numeric(18, 0)), CAST(361 AS Numeric(18, 0)), N'Task ', CAST(0.00 AS Numeric(18, 2)), CAST(100.00 AS Numeric(18, 2)), CAST(0.00 AS Numeric(18, 2)), 0, CAST(0.00 AS Numeric(18, 2)))
INSERT [dbo].[ProductivityTasks] ([id], [project_id], [name], [total_execute], [scheduled], [progress], [is_out_of_scope], [total_billable]) VALUES (CAST(10029 AS Numeric(18, 0)), CAST(361 AS Numeric(18, 0)), N'Test', CAST(10.00 AS Numeric(18, 2)), CAST(80.00 AS Numeric(18, 2)), CAST(0.00 AS Numeric(18, 2)), 0, CAST(8.00 AS Numeric(18, 2)))
SET IDENTITY_INSERT [dbo].[ProductivityTasks] OFF
SET IDENTITY_INSERT [dbo].[Project] ON 

INSERT [dbo].[Project] ([id], [name], [start_date], [end_date], [enabled], [operation_center], [work_order], [leader_id], [cost]) VALUES (CAST(4 AS Numeric(18, 0)), N'Project B', CAST(N'2017-08-01' AS Date), CAST(N'2017-10-31' AS Date), 1, N'006', 1, CAST(18 AS Numeric(18, 0)), CAST(500.0000 AS Decimal(19, 4)))
INSERT [dbo].[Project] ([id], [name], [start_date], [end_date], [enabled], [operation_center], [work_order], [leader_id], [cost]) VALUES (CAST(334 AS Numeric(18, 0)), N'Project A', CAST(N'2017-10-01' AS Date), CAST(N'2017-10-31' AS Date), 1, N'006-1', 2, CAST(18 AS Numeric(18, 0)), CAST(2500.0000 AS Decimal(19, 4)))
INSERT [dbo].[Project] ([id], [name], [start_date], [end_date], [enabled], [operation_center], [work_order], [leader_id], [cost]) VALUES (CAST(335 AS Numeric(18, 0)), N'Project C', CAST(N'2017-10-06' AS Date), CAST(N'2017-10-31' AS Date), 1, N'006-2', 3, CAST(9 AS Numeric(18, 0)), CAST(15000.0000 AS Decimal(19, 4)))
INSERT [dbo].[Project] ([id], [name], [start_date], [end_date], [enabled], [operation_center], [work_order], [leader_id], [cost]) VALUES (CAST(345 AS Numeric(18, 0)), N'''Project HPD', CAST(N'2017-10-01' AS Date), CAST(N'2018-02-06' AS Date), 1, N'006-1', 5, CAST(24 AS Numeric(18, 0)), CAST(150000.0000 AS Decimal(19, 4)))
INSERT [dbo].[Project] ([id], [name], [start_date], [end_date], [enabled], [operation_center], [work_order], [leader_id], [cost]) VALUES (CAST(346 AS Numeric(18, 0)), N'Project E', CAST(N'2017-10-01' AS Date), CAST(N'2017-10-31' AS Date), 1, N'006-1', 1, CAST(10 AS Numeric(18, 0)), CAST(10000.0000 AS Decimal(19, 4)))
INSERT [dbo].[Project] ([id], [name], [start_date], [end_date], [enabled], [operation_center], [work_order], [leader_id], [cost]) VALUES (CAST(347 AS Numeric(18, 0)), N'Project F', CAST(N'2017-10-01' AS Date), CAST(N'2017-10-31' AS Date), 1, N'006-1', 6, CAST(21 AS Numeric(18, 0)), CAST(5000.0000 AS Decimal(19, 4)))
INSERT [dbo].[Project] ([id], [name], [start_date], [end_date], [enabled], [operation_center], [work_order], [leader_id], [cost]) VALUES (CAST(348 AS Numeric(18, 0)), N'Project G', CAST(N'2017-10-01' AS Date), CAST(N'2017-10-31' AS Date), 1, N'006-1', 3, CAST(9 AS Numeric(18, 0)), CAST(75000.0000 AS Decimal(19, 4)))
INSERT [dbo].[Project] ([id], [name], [start_date], [end_date], [enabled], [operation_center], [work_order], [leader_id], [cost]) VALUES (CAST(361 AS Numeric(18, 0)), N'PRM', CAST(N'2017-11-01' AS Date), CAST(N'2017-11-30' AS Date), 1, N'006-9', 3, CAST(24 AS Numeric(18, 0)), NULL)
INSERT [dbo].[Project] ([id], [name], [start_date], [end_date], [enabled], [operation_center], [work_order], [leader_id], [cost]) VALUES (CAST(10370 AS Numeric(18, 0)), N'Christmas Project', CAST(N'2017-11-01' AS Date), CAST(N'2017-12-31' AS Date), 1, N'2412', 2017, CAST(9 AS Numeric(18, 0)), NULL)
INSERT [dbo].[Project] ([id], [name], [start_date], [end_date], [enabled], [operation_center], [work_order], [leader_id], [cost]) VALUES (CAST(10371 AS Numeric(18, 0)), N'Test Juan Camilo', CAST(N'2017-11-01' AS Date), CAST(N'2017-11-30' AS Date), 1, N'006-16', 2, CAST(26 AS Numeric(18, 0)), CAST(3000.0000 AS Decimal(19, 4)))
SET IDENTITY_INSERT [dbo].[Project] OFF
SET IDENTITY_INSERT [dbo].[ProjectForecast] ON 

INSERT [dbo].[ProjectForecast] ([id], [name], [business_unit], [region], [description], [start_date], [end_date], [hours], [number_sites], [number_process_per_site], [number_process_total], [estimate_cost], [billing_date], [status]) VALUES (CAST(13 AS Numeric(18, 0)), N'HILS', N'Atuna', N'Brasil', N'13-', CAST(N'2018-11-20' AS Date), CAST(N'2018-12-20' AS Date), 0, CAST(3 AS Numeric(18, 0)), CAST(1 AS Numeric(18, 0)), CAST(0 AS Numeric(18, 0)), 80000, CAST(N'2018-03-22' AS Date), N'')
INSERT [dbo].[ProjectForecast] ([id], [name], [business_unit], [region], [description], [start_date], [end_date], [hours], [number_sites], [number_process_per_site], [number_process_total], [estimate_cost], [billing_date], [status]) VALUES (CAST(14 AS Numeric(18, 0)), N'TEST', N'Grain', N'Colombia', N'14-', CAST(N'2017-11-20' AS Date), CAST(N'2017-12-20' AS Date), 0, CAST(7 AS Numeric(18, 0)), CAST(0 AS Numeric(18, 0)), CAST(0 AS Numeric(18, 0)), 50000, CAST(N'0001-01-01' AS Date), N'')
INSERT [dbo].[ProjectForecast] ([id], [name], [business_unit], [region], [description], [start_date], [end_date], [hours], [number_sites], [number_process_per_site], [number_process_total], [estimate_cost], [billing_date], [status]) VALUES (CAST(16 AS Numeric(18, 0)), N'FEE2', N'Chicken', N'Peru', N'', CAST(N'2018-01-23' AS Date), CAST(N'2018-02-23' AS Date), 0, CAST(1 AS Numeric(18, 0)), CAST(0 AS Numeric(18, 0)), CAST(0 AS Numeric(18, 0)), 44000, CAST(N'0001-01-01' AS Date), N'')
INSERT [dbo].[ProjectForecast] ([id], [name], [business_unit], [region], [description], [start_date], [end_date], [hours], [number_sites], [number_process_per_site], [number_process_total], [estimate_cost], [billing_date], [status]) VALUES (CAST(19 AS Numeric(18, 0)), N'Test2', N'Malt', N'Uruguay', N'', CAST(N'2018-01-23' AS Date), CAST(N'2018-03-29' AS Date), 0, CAST(2 AS Numeric(18, 0)), CAST(0 AS Numeric(18, 0)), CAST(0 AS Numeric(18, 0)), 488000, CAST(N'0001-01-01' AS Date), N'')
INSERT [dbo].[ProjectForecast] ([id], [name], [business_unit], [region], [description], [start_date], [end_date], [hours], [number_sites], [number_process_per_site], [number_process_total], [estimate_cost], [billing_date], [status]) VALUES (CAST(20 AS Numeric(18, 0)), N'CASC', N'Acee', N'Belgicas', N'....', CAST(N'2018-05-31' AS Date), CAST(N'2018-08-30' AS Date), 0, CAST(4 AS Numeric(18, 0)), CAST(1 AS Numeric(18, 0)), CAST(0 AS Numeric(18, 0)), 100, CAST(N'2018-06-20' AS Date), N'Done')
SET IDENTITY_INSERT [dbo].[ProjectForecast] OFF
SET IDENTITY_INSERT [dbo].[ProjectForecastAssigns] ON 

INSERT [dbo].[ProjectForecastAssigns] ([id], [projectForecast_id], [projectForecast_name], [type_id], [type_name], [number_resources]) VALUES (CAST(57 AS Numeric(18, 0)), CAST(13 AS Numeric(18, 0)), N'', CAST(11 AS Numeric(18, 0)), N'MOM Engineer', 4)
INSERT [dbo].[ProjectForecastAssigns] ([id], [projectForecast_id], [projectForecast_name], [type_id], [type_name], [number_resources]) VALUES (CAST(58 AS Numeric(18, 0)), CAST(13 AS Numeric(18, 0)), N'', CAST(13 AS Numeric(18, 0)), N'Developer', 3)
INSERT [dbo].[ProjectForecastAssigns] ([id], [projectForecast_id], [projectForecast_name], [type_id], [type_name], [number_resources]) VALUES (CAST(10024 AS Numeric(18, 0)), CAST(20 AS Numeric(18, 0)), N'', CAST(11 AS Numeric(18, 0)), N'MOM Engineer', 2)
INSERT [dbo].[ProjectForecastAssigns] ([id], [projectForecast_id], [projectForecast_name], [type_id], [type_name], [number_resources]) VALUES (CAST(10025 AS Numeric(18, 0)), CAST(14 AS Numeric(18, 0)), N'', CAST(11 AS Numeric(18, 0)), N'MOM Engineer', 3)
INSERT [dbo].[ProjectForecastAssigns] ([id], [projectForecast_id], [projectForecast_name], [type_id], [type_name], [number_resources]) VALUES (CAST(10026 AS Numeric(18, 0)), CAST(20 AS Numeric(18, 0)), N'', CAST(13 AS Numeric(18, 0)), N'Developer', 2)
INSERT [dbo].[ProjectForecastAssigns] ([id], [projectForecast_id], [projectForecast_name], [type_id], [type_name], [number_resources]) VALUES (CAST(10027 AS Numeric(18, 0)), CAST(14 AS Numeric(18, 0)), N'', CAST(13 AS Numeric(18, 0)), N'Developer', 0)
INSERT [dbo].[ProjectForecastAssigns] ([id], [projectForecast_id], [projectForecast_name], [type_id], [type_name], [number_resources]) VALUES (CAST(10028 AS Numeric(18, 0)), CAST(16 AS Numeric(18, 0)), N'', CAST(13 AS Numeric(18, 0)), N'Developer', 1)
INSERT [dbo].[ProjectForecastAssigns] ([id], [projectForecast_id], [projectForecast_name], [type_id], [type_name], [number_resources]) VALUES (CAST(10029 AS Numeric(18, 0)), CAST(19 AS Numeric(18, 0)), N'', CAST(13 AS Numeric(18, 0)), N'Developer', 1)
SET IDENTITY_INSERT [dbo].[ProjectForecastAssigns] OFF
SET IDENTITY_INSERT [dbo].[ProjectResources] ON 

INSERT [dbo].[ProjectResources] ([id], [project_id], [resource_id], [project_name], [resource_name], [start_date], [end_date], [hours], [lead]) VALUES (CAST(34 AS Numeric(18, 0)), CAST(334 AS Numeric(18, 0)), CAST(9 AS Numeric(18, 0)), N'Project A', N'John', CAST(N'2017-10-06' AS Date), CAST(N'2017-10-23' AS Date), 96, 1)
INSERT [dbo].[ProjectResources] ([id], [project_id], [resource_id], [project_name], [resource_name], [start_date], [end_date], [hours], [lead]) VALUES (CAST(36 AS Numeric(18, 0)), CAST(335 AS Numeric(18, 0)), CAST(9 AS Numeric(18, 0)), N'Project C', N'John', CAST(N'2017-10-24' AS Date), CAST(N'2017-10-24' AS Date), 8, 0)
INSERT [dbo].[ProjectResources] ([id], [project_id], [resource_id], [project_name], [resource_name], [start_date], [end_date], [hours], [lead]) VALUES (CAST(37 AS Numeric(18, 0)), CAST(335 AS Numeric(18, 0)), CAST(18 AS Numeric(18, 0)), N'Project C', N'Juan Camilo Diaz Ruiz', CAST(N'2017-10-13' AS Date), CAST(N'2017-10-18' AS Date), 32, 0)
INSERT [dbo].[ProjectResources] ([id], [project_id], [resource_id], [project_name], [resource_name], [start_date], [end_date], [hours], [lead]) VALUES (CAST(46 AS Numeric(18, 0)), CAST(346 AS Numeric(18, 0)), CAST(10 AS Numeric(18, 0)), N'Project E', N'Foo', CAST(N'2017-10-16' AS Date), CAST(N'2017-10-16' AS Date), 8, 0)
INSERT [dbo].[ProjectResources] ([id], [project_id], [resource_id], [project_name], [resource_name], [start_date], [end_date], [hours], [lead]) VALUES (CAST(47 AS Numeric(18, 0)), CAST(347 AS Numeric(18, 0)), CAST(9 AS Numeric(18, 0)), N'Project F', N'John', CAST(N'2017-10-30' AS Date), CAST(N'2017-10-30' AS Date), 8, 0)
INSERT [dbo].[ProjectResources] ([id], [project_id], [resource_id], [project_name], [resource_name], [start_date], [end_date], [hours], [lead]) VALUES (CAST(48 AS Numeric(18, 0)), CAST(348 AS Numeric(18, 0)), CAST(18 AS Numeric(18, 0)), N'Project G', N'Juan Camilo Diaz Ruiz', CAST(N'2017-10-20' AS Date), CAST(N'2017-10-20' AS Date), 8, 0)
INSERT [dbo].[ProjectResources] ([id], [project_id], [resource_id], [project_name], [resource_name], [start_date], [end_date], [hours], [lead]) VALUES (CAST(499 AS Numeric(18, 0)), CAST(4 AS Numeric(18, 0)), CAST(20 AS Numeric(18, 0)), N'Project B', N'Juan 1 uno', CAST(N'2017-10-18' AS Date), CAST(N'2017-10-18' AS Date), 8, 1)
INSERT [dbo].[ProjectResources] ([id], [project_id], [resource_id], [project_name], [resource_name], [start_date], [end_date], [hours], [lead]) VALUES (CAST(500 AS Numeric(18, 0)), CAST(347 AS Numeric(18, 0)), CAST(21 AS Numeric(18, 0)), N'Project F', N'Juan 2 dos', CAST(N'2017-10-18' AS Date), CAST(N'2017-10-19' AS Date), 16, 0)
INSERT [dbo].[ProjectResources] ([id], [project_id], [resource_id], [project_name], [resource_name], [start_date], [end_date], [hours], [lead]) VALUES (CAST(501 AS Numeric(18, 0)), CAST(348 AS Numeric(18, 0)), CAST(22 AS Numeric(18, 0)), N'Project G', N'Juan 3', CAST(N'2017-10-18' AS Date), CAST(N'2017-10-20' AS Date), 24, 0)
INSERT [dbo].[ProjectResources] ([id], [project_id], [resource_id], [project_name], [resource_name], [start_date], [end_date], [hours], [lead]) VALUES (CAST(558 AS Numeric(18, 0)), CAST(335 AS Numeric(18, 0)), CAST(20 AS Numeric(18, 0)), N'Project C', N'Juan 1 uno', CAST(N'2017-10-19' AS Date), CAST(N'2017-10-19' AS Date), 8, 0)
INSERT [dbo].[ProjectResources] ([id], [project_id], [resource_id], [project_name], [resource_name], [start_date], [end_date], [hours], [lead]) VALUES (CAST(559 AS Numeric(18, 0)), CAST(348 AS Numeric(18, 0)), CAST(21 AS Numeric(18, 0)), N'Project G', N'Juan 2 dos', CAST(N'2017-10-25' AS Date), CAST(N'2017-10-26' AS Date), 16, 0)
INSERT [dbo].[ProjectResources] ([id], [project_id], [resource_id], [project_name], [resource_name], [start_date], [end_date], [hours], [lead]) VALUES (CAST(560 AS Numeric(18, 0)), CAST(348 AS Numeric(18, 0)), CAST(21 AS Numeric(18, 0)), N'Project G', N'Juan 2 dos', CAST(N'2017-10-30' AS Date), CAST(N'2017-10-31' AS Date), 16, 0)
INSERT [dbo].[ProjectResources] ([id], [project_id], [resource_id], [project_name], [resource_name], [start_date], [end_date], [hours], [lead]) VALUES (CAST(563 AS Numeric(18, 0)), CAST(361 AS Numeric(18, 0)), CAST(18 AS Numeric(18, 0)), N'PRM', N'Juan Camilo Diaz Ruiz', CAST(N'2017-11-01' AS Date), CAST(N'2017-11-01' AS Date), 4, 1)
INSERT [dbo].[ProjectResources] ([id], [project_id], [resource_id], [project_name], [resource_name], [start_date], [end_date], [hours], [lead]) VALUES (CAST(564 AS Numeric(18, 0)), CAST(361 AS Numeric(18, 0)), CAST(18 AS Numeric(18, 0)), N'PRM', N'Juan Camilo Diaz Ruiz', CAST(N'2017-11-02' AS Date), CAST(N'2017-11-02' AS Date), 4, 1)
INSERT [dbo].[ProjectResources] ([id], [project_id], [resource_id], [project_name], [resource_name], [start_date], [end_date], [hours], [lead]) VALUES (CAST(565 AS Numeric(18, 0)), CAST(361 AS Numeric(18, 0)), CAST(18 AS Numeric(18, 0)), N'PRM', N'Juan Camilo Diaz Ruiz', CAST(N'2017-11-03' AS Date), CAST(N'2017-11-03' AS Date), 4, 1)
INSERT [dbo].[ProjectResources] ([id], [project_id], [resource_id], [project_name], [resource_name], [start_date], [end_date], [hours], [lead]) VALUES (CAST(566 AS Numeric(18, 0)), CAST(361 AS Numeric(18, 0)), CAST(18 AS Numeric(18, 0)), N'PRM', N'Juan Camilo Diaz Ruiz', CAST(N'2017-11-06' AS Date), CAST(N'2017-11-06' AS Date), 4, 1)
INSERT [dbo].[ProjectResources] ([id], [project_id], [resource_id], [project_name], [resource_name], [start_date], [end_date], [hours], [lead]) VALUES (CAST(567 AS Numeric(18, 0)), CAST(361 AS Numeric(18, 0)), CAST(18 AS Numeric(18, 0)), N'PRM', N'Juan Camilo Diaz Ruiz', CAST(N'2017-11-07' AS Date), CAST(N'2017-11-07' AS Date), 4, 1)
INSERT [dbo].[ProjectResources] ([id], [project_id], [resource_id], [project_name], [resource_name], [start_date], [end_date], [hours], [lead]) VALUES (CAST(573 AS Numeric(18, 0)), CAST(361 AS Numeric(18, 0)), CAST(9 AS Numeric(18, 0)), N'PRM', N'John', CAST(N'2017-11-02' AS Date), CAST(N'2017-11-02' AS Date), 6, 0)
INSERT [dbo].[ProjectResources] ([id], [project_id], [resource_id], [project_name], [resource_name], [start_date], [end_date], [hours], [lead]) VALUES (CAST(574 AS Numeric(18, 0)), CAST(361 AS Numeric(18, 0)), CAST(9 AS Numeric(18, 0)), N'PRM', N'John', CAST(N'2017-11-03' AS Date), CAST(N'2017-11-03' AS Date), 6, 0)
INSERT [dbo].[ProjectResources] ([id], [project_id], [resource_id], [project_name], [resource_name], [start_date], [end_date], [hours], [lead]) VALUES (CAST(575 AS Numeric(18, 0)), CAST(361 AS Numeric(18, 0)), CAST(9 AS Numeric(18, 0)), N'PRM', N'John', CAST(N'2017-11-07' AS Date), CAST(N'2017-11-08' AS Date), 12, 0)
INSERT [dbo].[ProjectResources] ([id], [project_id], [resource_id], [project_name], [resource_name], [start_date], [end_date], [hours], [lead]) VALUES (CAST(576 AS Numeric(18, 0)), CAST(361 AS Numeric(18, 0)), CAST(9 AS Numeric(18, 0)), N'PRM', N'John', CAST(N'2017-11-09' AS Date), CAST(N'2017-11-09' AS Date), 5, 0)
INSERT [dbo].[ProjectResources] ([id], [project_id], [resource_id], [project_name], [resource_name], [start_date], [end_date], [hours], [lead]) VALUES (CAST(577 AS Numeric(18, 0)), CAST(361 AS Numeric(18, 0)), CAST(9 AS Numeric(18, 0)), N'PRM', N'John', CAST(N'2017-11-10' AS Date), CAST(N'2017-11-10' AS Date), 5, 0)
INSERT [dbo].[ProjectResources] ([id], [project_id], [resource_id], [project_name], [resource_name], [start_date], [end_date], [hours], [lead]) VALUES (CAST(10595 AS Numeric(18, 0)), CAST(10370 AS Numeric(18, 0)), CAST(24 AS Numeric(18, 0)), N'Christmas Project', N'Training Resource', CAST(N'2017-11-07' AS Date), CAST(N'2017-11-07' AS Date), 4, 0)
INSERT [dbo].[ProjectResources] ([id], [project_id], [resource_id], [project_name], [resource_name], [start_date], [end_date], [hours], [lead]) VALUES (CAST(10596 AS Numeric(18, 0)), CAST(10370 AS Numeric(18, 0)), CAST(24 AS Numeric(18, 0)), N'Christmas Project', N'Training Resource', CAST(N'2017-11-13' AS Date), CAST(N'2017-11-13' AS Date), 4, 0)
INSERT [dbo].[ProjectResources] ([id], [project_id], [resource_id], [project_name], [resource_name], [start_date], [end_date], [hours], [lead]) VALUES (CAST(10597 AS Numeric(18, 0)), CAST(10370 AS Numeric(18, 0)), CAST(24 AS Numeric(18, 0)), N'Christmas Project', N'Training Resource', CAST(N'2017-11-14' AS Date), CAST(N'2017-11-14' AS Date), 4, 0)
INSERT [dbo].[ProjectResources] ([id], [project_id], [resource_id], [project_name], [resource_name], [start_date], [end_date], [hours], [lead]) VALUES (CAST(10598 AS Numeric(18, 0)), CAST(10370 AS Numeric(18, 0)), CAST(24 AS Numeric(18, 0)), N'Christmas Project', N'Training Resource', CAST(N'2017-11-15' AS Date), CAST(N'2017-11-15' AS Date), 4, 0)
INSERT [dbo].[ProjectResources] ([id], [project_id], [resource_id], [project_name], [resource_name], [start_date], [end_date], [hours], [lead]) VALUES (CAST(10599 AS Numeric(18, 0)), CAST(10370 AS Numeric(18, 0)), CAST(24 AS Numeric(18, 0)), N'Christmas Project', N'Training Resource', CAST(N'2017-11-16' AS Date), CAST(N'2017-11-16' AS Date), 4, 0)
INSERT [dbo].[ProjectResources] ([id], [project_id], [resource_id], [project_name], [resource_name], [start_date], [end_date], [hours], [lead]) VALUES (CAST(10600 AS Numeric(18, 0)), CAST(10370 AS Numeric(18, 0)), CAST(24 AS Numeric(18, 0)), N'Christmas Project', N'Training Resource', CAST(N'2017-11-17' AS Date), CAST(N'2017-11-17' AS Date), 4, 0)
INSERT [dbo].[ProjectResources] ([id], [project_id], [resource_id], [project_name], [resource_name], [start_date], [end_date], [hours], [lead]) VALUES (CAST(10601 AS Numeric(18, 0)), CAST(10370 AS Numeric(18, 0)), CAST(24 AS Numeric(18, 0)), N'Christmas Project', N'Training Resource', CAST(N'2017-11-08' AS Date), CAST(N'2017-11-08' AS Date), 4, 0)
INSERT [dbo].[ProjectResources] ([id], [project_id], [resource_id], [project_name], [resource_name], [start_date], [end_date], [hours], [lead]) VALUES (CAST(10602 AS Numeric(18, 0)), CAST(10370 AS Numeric(18, 0)), CAST(24 AS Numeric(18, 0)), N'Christmas Project', N'Training Resource', CAST(N'2017-11-09' AS Date), CAST(N'2017-11-09' AS Date), 4, 0)
INSERT [dbo].[ProjectResources] ([id], [project_id], [resource_id], [project_name], [resource_name], [start_date], [end_date], [hours], [lead]) VALUES (CAST(10603 AS Numeric(18, 0)), CAST(10370 AS Numeric(18, 0)), CAST(24 AS Numeric(18, 0)), N'Christmas Project', N'Training Resource', CAST(N'2017-11-10' AS Date), CAST(N'2017-11-10' AS Date), 4, 0)
INSERT [dbo].[ProjectResources] ([id], [project_id], [resource_id], [project_name], [resource_name], [start_date], [end_date], [hours], [lead]) VALUES (CAST(10604 AS Numeric(18, 0)), CAST(10371 AS Numeric(18, 0)), CAST(26 AS Numeric(18, 0)), N'Test Juan Camilo', N'Kepler', CAST(N'2017-11-06' AS Date), CAST(N'2017-11-17' AS Date), 80, 1)
INSERT [dbo].[ProjectResources] ([id], [project_id], [resource_id], [project_name], [resource_name], [start_date], [end_date], [hours], [lead]) VALUES (CAST(10616 AS Numeric(18, 0)), CAST(361 AS Numeric(18, 0)), CAST(10 AS Numeric(18, 0)), N'PRM', N'Foo Bar', CAST(N'2017-11-14' AS Date), CAST(N'2017-11-14' AS Date), 10, 0)
INSERT [dbo].[ProjectResources] ([id], [project_id], [resource_id], [project_name], [resource_name], [start_date], [end_date], [hours], [lead]) VALUES (CAST(10621 AS Numeric(18, 0)), CAST(345 AS Numeric(18, 0)), CAST(9 AS Numeric(18, 0)), N'''Project HPD', N'John Doe', CAST(N'2018-01-09' AS Date), CAST(N'2018-01-16' AS Date), 48, 0)
INSERT [dbo].[ProjectResources] ([id], [project_id], [resource_id], [project_name], [resource_name], [start_date], [end_date], [hours], [lead]) VALUES (CAST(10622 AS Numeric(18, 0)), CAST(10370 AS Numeric(18, 0)), CAST(10027 AS Numeric(18, 0)), N'Christmas Project', N'Santa Claus', CAST(N'2017-11-21' AS Date), CAST(N'2017-12-31' AS Date), 232, 0)
INSERT [dbo].[ProjectResources] ([id], [project_id], [resource_id], [project_name], [resource_name], [start_date], [end_date], [hours], [lead]) VALUES (CAST(20622 AS Numeric(18, 0)), CAST(345 AS Numeric(18, 0)), CAST(20 AS Numeric(18, 0)), N'''Project HPD', N'Juan 1 uno', CAST(N'2018-01-23' AS Date), CAST(N'2018-01-24' AS Date), 16, 0)
SET IDENTITY_INSERT [dbo].[ProjectResources] OFF
SET IDENTITY_INSERT [dbo].[ProjectTypes] ON 

INSERT [dbo].[ProjectTypes] ([id], [project_id], [type_id], [type_name]) VALUES (CAST(16 AS Numeric(18, 0)), CAST(4 AS Numeric(18, 0)), CAST(7 AS Numeric(18, 0)), N'MOM Mapping')
INSERT [dbo].[ProjectTypes] ([id], [project_id], [type_id], [type_name]) VALUES (CAST(10083 AS Numeric(18, 0)), CAST(334 AS Numeric(18, 0)), CAST(2 AS Numeric(18, 0)), N'Implementation')
INSERT [dbo].[ProjectTypes] ([id], [project_id], [type_id], [type_name]) VALUES (CAST(10084 AS Numeric(18, 0)), CAST(334 AS Numeric(18, 0)), CAST(7 AS Numeric(18, 0)), N'MOM Mapping')
INSERT [dbo].[ProjectTypes] ([id], [project_id], [type_id], [type_name]) VALUES (CAST(10085 AS Numeric(18, 0)), CAST(335 AS Numeric(18, 0)), CAST(2 AS Numeric(18, 0)), N'Implementation')
INSERT [dbo].[ProjectTypes] ([id], [project_id], [type_id], [type_name]) VALUES (CAST(10093 AS Numeric(18, 0)), CAST(346 AS Numeric(18, 0)), CAST(2 AS Numeric(18, 0)), N'Implementation')
INSERT [dbo].[ProjectTypes] ([id], [project_id], [type_id], [type_name]) VALUES (CAST(10094 AS Numeric(18, 0)), CAST(347 AS Numeric(18, 0)), CAST(2 AS Numeric(18, 0)), N'Implementation')
INSERT [dbo].[ProjectTypes] ([id], [project_id], [type_id], [type_name]) VALUES (CAST(10095 AS Numeric(18, 0)), CAST(348 AS Numeric(18, 0)), CAST(2 AS Numeric(18, 0)), N'Implementation')
INSERT [dbo].[ProjectTypes] ([id], [project_id], [type_id], [type_name]) VALUES (CAST(10096 AS Numeric(18, 0)), CAST(4 AS Numeric(18, 0)), CAST(2 AS Numeric(18, 0)), N'Implementation')
INSERT [dbo].[ProjectTypes] ([id], [project_id], [type_id], [type_name]) VALUES (CAST(10108 AS Numeric(18, 0)), CAST(345 AS Numeric(18, 0)), CAST(11 AS Numeric(18, 0)), N'MOM Engineer')
INSERT [dbo].[ProjectTypes] ([id], [project_id], [type_id], [type_name]) VALUES (CAST(10109 AS Numeric(18, 0)), CAST(361 AS Numeric(18, 0)), CAST(2 AS Numeric(18, 0)), N'Implementation')
INSERT [dbo].[ProjectTypes] ([id], [project_id], [type_id], [type_name]) VALUES (CAST(20109 AS Numeric(18, 0)), CAST(10371 AS Numeric(18, 0)), CAST(2 AS Numeric(18, 0)), N'Implementation')
SET IDENTITY_INSERT [dbo].[ProjectTypes] OFF
SET IDENTITY_INSERT [dbo].[Resource] ON 

INSERT [dbo].[Resource] ([id], [name], [last_name], [email], [photo], [engineer_range], [enabled], [visa_us]) VALUES (CAST(9 AS Numeric(18, 0)), N'John', N'Doe', N'john.doe@mail.com', N'test', N'E4', 1, NULL)
INSERT [dbo].[Resource] ([id], [name], [last_name], [email], [photo], [engineer_range], [enabled], [visa_us]) VALUES (CAST(10 AS Numeric(18, 0)), N'Foo', N'Bar', N'Foo.Bar@mail.com', N'test', N'PM', 1, N'B1/B2')
INSERT [dbo].[Resource] ([id], [name], [last_name], [email], [photo], [engineer_range], [enabled], [visa_us]) VALUES (CAST(18 AS Numeric(18, 0)), N'Juan Camilo', N'Diaz Ruiz', N'juan.diaz@omnicon.cc', N'test', N'E3', 1, NULL)
INSERT [dbo].[Resource] ([id], [name], [last_name], [email], [photo], [engineer_range], [enabled], [visa_us]) VALUES (CAST(20 AS Numeric(18, 0)), N'Juan 1', N'uno', N'', N'test', N'E2', 1, NULL)
INSERT [dbo].[Resource] ([id], [name], [last_name], [email], [photo], [engineer_range], [enabled], [visa_us]) VALUES (CAST(21 AS Numeric(18, 0)), N'Juan 2', N'dos', N'', N'test', N'E2', 1, NULL)
INSERT [dbo].[Resource] ([id], [name], [last_name], [email], [photo], [engineer_range], [enabled], [visa_us]) VALUES (CAST(22 AS Numeric(18, 0)), N'Juan 3', N'tres', N'', N'test', N'E1', 1, NULL)
INSERT [dbo].[Resource] ([id], [name], [last_name], [email], [photo], [engineer_range], [enabled], [visa_us]) VALUES (CAST(24 AS Numeric(18, 0)), N'Training', N'Resource', N'', N'test', N'E4', 1, NULL)
INSERT [dbo].[Resource] ([id], [name], [last_name], [email], [photo], [engineer_range], [enabled], [visa_us]) VALUES (CAST(26 AS Numeric(18, 0)), N'Kepler', N'Da silva', N'kepler.dasilva@omnicon.cc', N'test', N'E3', 1, N'No, Mastercard')
INSERT [dbo].[Resource] ([id], [name], [last_name], [email], [photo], [engineer_range], [enabled], [visa_us]) VALUES (CAST(10027 AS Numeric(18, 0)), N'Santa', N'Claus', N'', N'test', N'', 1, NULL)
SET IDENTITY_INSERT [dbo].[Resource] OFF
SET IDENTITY_INSERT [dbo].[ResourceSkills] ON 

INSERT [dbo].[ResourceSkills] ([id], [resource_id], [skill_id], [name], [value]) VALUES (CAST(19 AS Numeric(18, 0)), CAST(10 AS Numeric(18, 0)), CAST(9 AS Numeric(18, 0)), N'MOM Fundamentals', 88)
INSERT [dbo].[ResourceSkills] ([id], [resource_id], [skill_id], [name], [value]) VALUES (CAST(20 AS Numeric(18, 0)), CAST(10 AS Numeric(18, 0)), CAST(10 AS Numeric(18, 0)), N'Savigent', 90)
INSERT [dbo].[ResourceSkills] ([id], [resource_id], [skill_id], [name], [value]) VALUES (CAST(26 AS Numeric(18, 0)), CAST(18 AS Numeric(18, 0)), CAST(10 AS Numeric(18, 0)), N'Savigent', 90)
INSERT [dbo].[ResourceSkills] ([id], [resource_id], [skill_id], [name], [value]) VALUES (CAST(27 AS Numeric(18, 0)), CAST(18 AS Numeric(18, 0)), CAST(9 AS Numeric(18, 0)), N'MOM Fundamentals', 99)
INSERT [dbo].[ResourceSkills] ([id], [resource_id], [skill_id], [name], [value]) VALUES (CAST(32 AS Numeric(18, 0)), CAST(10 AS Numeric(18, 0)), CAST(14 AS Numeric(18, 0)), N'Basic Soft Skills', 60)
INSERT [dbo].[ResourceSkills] ([id], [resource_id], [skill_id], [name], [value]) VALUES (CAST(33 AS Numeric(18, 0)), CAST(10 AS Numeric(18, 0)), CAST(17 AS Numeric(18, 0)), N'FSD', 45)
INSERT [dbo].[ResourceSkills] ([id], [resource_id], [skill_id], [name], [value]) VALUES (CAST(34 AS Numeric(18, 0)), CAST(10 AS Numeric(18, 0)), CAST(21 AS Numeric(18, 0)), N'Mockups', 20)
INSERT [dbo].[ResourceSkills] ([id], [resource_id], [skill_id], [name], [value]) VALUES (CAST(35 AS Numeric(18, 0)), CAST(10 AS Numeric(18, 0)), CAST(18 AS Numeric(18, 0)), N'Library', 71)
INSERT [dbo].[ResourceSkills] ([id], [resource_id], [skill_id], [name], [value]) VALUES (CAST(36 AS Numeric(18, 0)), CAST(18 AS Numeric(18, 0)), CAST(16 AS Numeric(18, 0)), N'CS', 80)
INSERT [dbo].[ResourceSkills] ([id], [resource_id], [skill_id], [name], [value]) VALUES (CAST(37 AS Numeric(18, 0)), CAST(10 AS Numeric(18, 0)), CAST(29 AS Numeric(18, 0)), N'Use Case Documentation', 70)
INSERT [dbo].[ResourceSkills] ([id], [resource_id], [skill_id], [name], [value]) VALUES (CAST(38 AS Numeric(18, 0)), CAST(10 AS Numeric(18, 0)), CAST(27 AS Numeric(18, 0)), N'Savigent Connectors', 30)
INSERT [dbo].[ResourceSkills] ([id], [resource_id], [skill_id], [name], [value]) VALUES (CAST(39 AS Numeric(18, 0)), CAST(10 AS Numeric(18, 0)), CAST(26 AS Numeric(18, 0)), N'Requirements Documentation', 1)
INSERT [dbo].[ResourceSkills] ([id], [resource_id], [skill_id], [name], [value]) VALUES (CAST(40 AS Numeric(18, 0)), CAST(10 AS Numeric(18, 0)), CAST(24 AS Numeric(18, 0)), N'Planning', 45)
INSERT [dbo].[ResourceSkills] ([id], [resource_id], [skill_id], [name], [value]) VALUES (CAST(41 AS Numeric(18, 0)), CAST(10 AS Numeric(18, 0)), CAST(23 AS Numeric(18, 0)), N'PFS', 25)
INSERT [dbo].[ResourceSkills] ([id], [resource_id], [skill_id], [name], [value]) VALUES (CAST(42 AS Numeric(18, 0)), CAST(10 AS Numeric(18, 0)), CAST(15 AS Numeric(18, 0)), N'Behaviorals', 66)
INSERT [dbo].[ResourceSkills] ([id], [resource_id], [skill_id], [name], [value]) VALUES (CAST(43 AS Numeric(18, 0)), CAST(10 AS Numeric(18, 0)), CAST(25 AS Numeric(18, 0)), N'Quality', 46)
INSERT [dbo].[ResourceSkills] ([id], [resource_id], [skill_id], [name], [value]) VALUES (CAST(44 AS Numeric(18, 0)), CAST(10 AS Numeric(18, 0)), CAST(28 AS Numeric(18, 0)), N'Soft Skils Specialized', 60)
INSERT [dbo].[ResourceSkills] ([id], [resource_id], [skill_id], [name], [value]) VALUES (CAST(46 AS Numeric(18, 0)), CAST(10 AS Numeric(18, 0)), CAST(19 AS Numeric(18, 0)), N'Library Services', 66)
INSERT [dbo].[ResourceSkills] ([id], [resource_id], [skill_id], [name], [value]) VALUES (CAST(55 AS Numeric(18, 0)), CAST(18 AS Numeric(18, 0)), CAST(14 AS Numeric(18, 0)), N'Basic Soft Skills', 58)
INSERT [dbo].[ResourceSkills] ([id], [resource_id], [skill_id], [name], [value]) VALUES (CAST(56 AS Numeric(18, 0)), CAST(10 AS Numeric(18, 0)), CAST(16 AS Numeric(18, 0)), N'CS', 60)
INSERT [dbo].[ResourceSkills] ([id], [resource_id], [skill_id], [name], [value]) VALUES (CAST(57 AS Numeric(18, 0)), CAST(18 AS Numeric(18, 0)), CAST(28 AS Numeric(18, 0)), N'Soft Skils Specialized', 60)
INSERT [dbo].[ResourceSkills] ([id], [resource_id], [skill_id], [name], [value]) VALUES (CAST(58 AS Numeric(18, 0)), CAST(20 AS Numeric(18, 0)), CAST(9 AS Numeric(18, 0)), N'MOM Fundamentals', 90)
INSERT [dbo].[ResourceSkills] ([id], [resource_id], [skill_id], [name], [value]) VALUES (CAST(59 AS Numeric(18, 0)), CAST(20 AS Numeric(18, 0)), CAST(10 AS Numeric(18, 0)), N'Savigent', 95)
INSERT [dbo].[ResourceSkills] ([id], [resource_id], [skill_id], [name], [value]) VALUES (CAST(60 AS Numeric(18, 0)), CAST(20 AS Numeric(18, 0)), CAST(14 AS Numeric(18, 0)), N'Basic Soft Skills', 97)
INSERT [dbo].[ResourceSkills] ([id], [resource_id], [skill_id], [name], [value]) VALUES (CAST(61 AS Numeric(18, 0)), CAST(20 AS Numeric(18, 0)), CAST(28 AS Numeric(18, 0)), N'Soft Skils Specialized', 80)
INSERT [dbo].[ResourceSkills] ([id], [resource_id], [skill_id], [name], [value]) VALUES (CAST(67 AS Numeric(18, 0)), CAST(22 AS Numeric(18, 0)), CAST(9 AS Numeric(18, 0)), N'MOM Fundamentals', 77)
INSERT [dbo].[ResourceSkills] ([id], [resource_id], [skill_id], [name], [value]) VALUES (CAST(68 AS Numeric(18, 0)), CAST(22 AS Numeric(18, 0)), CAST(10 AS Numeric(18, 0)), N'Savigent', 81)
INSERT [dbo].[ResourceSkills] ([id], [resource_id], [skill_id], [name], [value]) VALUES (CAST(69 AS Numeric(18, 0)), CAST(22 AS Numeric(18, 0)), CAST(14 AS Numeric(18, 0)), N'Basic Soft Skills', 90)
INSERT [dbo].[ResourceSkills] ([id], [resource_id], [skill_id], [name], [value]) VALUES (CAST(70 AS Numeric(18, 0)), CAST(22 AS Numeric(18, 0)), CAST(16 AS Numeric(18, 0)), N'CS', 77)
INSERT [dbo].[ResourceSkills] ([id], [resource_id], [skill_id], [name], [value]) VALUES (CAST(71 AS Numeric(18, 0)), CAST(22 AS Numeric(18, 0)), CAST(28 AS Numeric(18, 0)), N'Soft Skils Specialized', 88)
INSERT [dbo].[ResourceSkills] ([id], [resource_id], [skill_id], [name], [value]) VALUES (CAST(72 AS Numeric(18, 0)), CAST(21 AS Numeric(18, 0)), CAST(14 AS Numeric(18, 0)), N'Basic Soft Skills', 77)
INSERT [dbo].[ResourceSkills] ([id], [resource_id], [skill_id], [name], [value]) VALUES (CAST(73 AS Numeric(18, 0)), CAST(21 AS Numeric(18, 0)), CAST(19 AS Numeric(18, 0)), N'Library Services', 70)
INSERT [dbo].[ResourceSkills] ([id], [resource_id], [skill_id], [name], [value]) VALUES (CAST(74 AS Numeric(18, 0)), CAST(21 AS Numeric(18, 0)), CAST(9 AS Numeric(18, 0)), N'MOM Fundamentals', 88)
INSERT [dbo].[ResourceSkills] ([id], [resource_id], [skill_id], [name], [value]) VALUES (CAST(75 AS Numeric(18, 0)), CAST(21 AS Numeric(18, 0)), CAST(10 AS Numeric(18, 0)), N'Savigent', 70)
INSERT [dbo].[ResourceSkills] ([id], [resource_id], [skill_id], [name], [value]) VALUES (CAST(76 AS Numeric(18, 0)), CAST(21 AS Numeric(18, 0)), CAST(28 AS Numeric(18, 0)), N'Soft Skils Specialized', 66)
INSERT [dbo].[ResourceSkills] ([id], [resource_id], [skill_id], [name], [value]) VALUES (CAST(96 AS Numeric(18, 0)), CAST(20 AS Numeric(18, 0)), CAST(23 AS Numeric(18, 0)), N'PFS', 60)
INSERT [dbo].[ResourceSkills] ([id], [resource_id], [skill_id], [name], [value]) VALUES (CAST(97 AS Numeric(18, 0)), CAST(9 AS Numeric(18, 0)), CAST(14 AS Numeric(18, 0)), N'Basic Soft Skills', 60)
INSERT [dbo].[ResourceSkills] ([id], [resource_id], [skill_id], [name], [value]) VALUES (CAST(98 AS Numeric(18, 0)), CAST(9 AS Numeric(18, 0)), CAST(23 AS Numeric(18, 0)), N'PFS', 60)
INSERT [dbo].[ResourceSkills] ([id], [resource_id], [skill_id], [name], [value]) VALUES (CAST(99 AS Numeric(18, 0)), CAST(9 AS Numeric(18, 0)), CAST(16 AS Numeric(18, 0)), N'CS', 95)
INSERT [dbo].[ResourceSkills] ([id], [resource_id], [skill_id], [name], [value]) VALUES (CAST(100 AS Numeric(18, 0)), CAST(9 AS Numeric(18, 0)), CAST(28 AS Numeric(18, 0)), N'Soft Skils Specialized', 56)
INSERT [dbo].[ResourceSkills] ([id], [resource_id], [skill_id], [name], [value]) VALUES (CAST(101 AS Numeric(18, 0)), CAST(9 AS Numeric(18, 0)), CAST(9 AS Numeric(18, 0)), N'MOM Fundamentals', 66)
INSERT [dbo].[ResourceSkills] ([id], [resource_id], [skill_id], [name], [value]) VALUES (CAST(102 AS Numeric(18, 0)), CAST(24 AS Numeric(18, 0)), CAST(35 AS Numeric(18, 0)), N'Training Skill 1', 1)
SET IDENTITY_INSERT [dbo].[ResourceSkills] OFF
SET IDENTITY_INSERT [dbo].[ResourceTypes] ON 

INSERT [dbo].[ResourceTypes] ([id], [resource_id], [type_id], [type_name]) VALUES (CAST(9 AS Numeric(18, 0)), CAST(20 AS Numeric(18, 0)), CAST(11 AS Numeric(18, 0)), N'MOM Engineer')
INSERT [dbo].[ResourceTypes] ([id], [resource_id], [type_id], [type_name]) VALUES (CAST(10 AS Numeric(18, 0)), CAST(20 AS Numeric(18, 0)), CAST(13 AS Numeric(18, 0)), N'Developer')
INSERT [dbo].[ResourceTypes] ([id], [resource_id], [type_id], [type_name]) VALUES (CAST(11 AS Numeric(18, 0)), CAST(9 AS Numeric(18, 0)), CAST(11 AS Numeric(18, 0)), N'MOM Engineer')
INSERT [dbo].[ResourceTypes] ([id], [resource_id], [type_id], [type_name]) VALUES (CAST(12 AS Numeric(18, 0)), CAST(10 AS Numeric(18, 0)), CAST(11 AS Numeric(18, 0)), N'MOM Engineer')
INSERT [dbo].[ResourceTypes] ([id], [resource_id], [type_id], [type_name]) VALUES (CAST(13 AS Numeric(18, 0)), CAST(10 AS Numeric(18, 0)), CAST(13 AS Numeric(18, 0)), N'Developer')
INSERT [dbo].[ResourceTypes] ([id], [resource_id], [type_id], [type_name]) VALUES (CAST(14 AS Numeric(18, 0)), CAST(21 AS Numeric(18, 0)), CAST(13 AS Numeric(18, 0)), N'Developer')
INSERT [dbo].[ResourceTypes] ([id], [resource_id], [type_id], [type_name]) VALUES (CAST(16 AS Numeric(18, 0)), CAST(18 AS Numeric(18, 0)), CAST(13 AS Numeric(18, 0)), N'Developer')
SET IDENTITY_INSERT [dbo].[ResourceTypes] OFF
SET IDENTITY_INSERT [dbo].[Settings] ON 

INSERT [dbo].[Settings] ([id], [name], [value], [type], [description]) VALUES (CAST(1 AS Numeric(18, 0)), N'HoursOfWork', N'8.0', N'float64', N'Hours of daily work, validates the maximum hours allowed in the assignments.')
INSERT [dbo].[Settings] ([id], [name], [value], [type], [description]) VALUES (CAST(2 AS Numeric(18, 0)), N'ValidEmails', N'Alejandro.Vizcaino@omnicon.cc;Anderson.Diaz@omnicon.cc;Carlos.Castaneda@omnicon.cc;Diego.Paz@omnicon.cc;Jose.Torres@omnicon.cc;Juan.Diaz@omnicon.cc;Juan.Torres@omnicon.cc', N'string', N'List of allowed emails to be registered in the PRM.')
INSERT [dbo].[Settings] ([id], [name], [value], [type], [description]) VALUES (CAST(4 AS Numeric(18, 0)), N'EpsilonValue', N'10', N'float64', N'Value that determines the maximum tolerance in the validations of skills during the recommendation of resources.')
INSERT [dbo].[Settings] ([id], [name], [value], [type], [description]) VALUES (CAST(5 AS Numeric(18, 0)), N'SuperUsers', N'Alejandro.Vizcaino@omnicon.cc;Anderson.Diaz@omnicon.cc;Juan.Diaz@omnicon.cc;Juan.Torres@omnicon.cc', N'string', N'Super users who grant access to the application (ValidEmails) from the login screen.')
SET IDENTITY_INSERT [dbo].[Settings] OFF
SET IDENTITY_INSERT [dbo].[Skill] ON 

INSERT [dbo].[Skill] ([id], [name]) VALUES (CAST(9 AS Numeric(18, 0)), N'MOM Fundamentals')
INSERT [dbo].[Skill] ([id], [name]) VALUES (CAST(10 AS Numeric(18, 0)), N'Savigent')
INSERT [dbo].[Skill] ([id], [name]) VALUES (CAST(14 AS Numeric(18, 0)), N'Basic Soft Skills')
INSERT [dbo].[Skill] ([id], [name]) VALUES (CAST(15 AS Numeric(18, 0)), N'Behaviorals')
INSERT [dbo].[Skill] ([id], [name]) VALUES (CAST(16 AS Numeric(18, 0)), N'CS')
INSERT [dbo].[Skill] ([id], [name]) VALUES (CAST(17 AS Numeric(18, 0)), N'FSD')
INSERT [dbo].[Skill] ([id], [name]) VALUES (CAST(18 AS Numeric(18, 0)), N'Library')
INSERT [dbo].[Skill] ([id], [name]) VALUES (CAST(19 AS Numeric(18, 0)), N'Library Services')
INSERT [dbo].[Skill] ([id], [name]) VALUES (CAST(20 AS Numeric(18, 0)), N'Manufacturing Sys. Int')
INSERT [dbo].[Skill] ([id], [name]) VALUES (CAST(21 AS Numeric(18, 0)), N'Mockups')
INSERT [dbo].[Skill] ([id], [name]) VALUES (CAST(23 AS Numeric(18, 0)), N'PFS')
INSERT [dbo].[Skill] ([id], [name]) VALUES (CAST(24 AS Numeric(18, 0)), N'Planning')
INSERT [dbo].[Skill] ([id], [name]) VALUES (CAST(25 AS Numeric(18, 0)), N'Quality')
INSERT [dbo].[Skill] ([id], [name]) VALUES (CAST(26 AS Numeric(18, 0)), N'Requirements Documentation')
INSERT [dbo].[Skill] ([id], [name]) VALUES (CAST(27 AS Numeric(18, 0)), N'Savigent Connectors')
INSERT [dbo].[Skill] ([id], [name]) VALUES (CAST(28 AS Numeric(18, 0)), N'Soft Skils Specialized')
INSERT [dbo].[Skill] ([id], [name]) VALUES (CAST(29 AS Numeric(18, 0)), N'Use Case Documentation')
INSERT [dbo].[Skill] ([id], [name]) VALUES (CAST(31 AS Numeric(18, 0)), N'TST')
INSERT [dbo].[Skill] ([id], [name]) VALUES (CAST(35 AS Numeric(18, 0)), N'Training Skill 1')
INSERT [dbo].[Skill] ([id], [name]) VALUES (CAST(36 AS Numeric(18, 0)), N'Training Skill 2')
INSERT [dbo].[Skill] ([id], [name]) VALUES (CAST(37 AS Numeric(18, 0)), N'Training Skill 3')
SET IDENTITY_INSERT [dbo].[Skill] OFF
SET IDENTITY_INSERT [dbo].[Training] ON 

INSERT [dbo].[Training] ([id], [type_id], [skill_id], [name]) VALUES (CAST(1 AS Numeric(18, 0)), CAST(2 AS Numeric(18, 0)), CAST(10 AS Numeric(18, 0)), N'Savigent Workflows')
INSERT [dbo].[Training] ([id], [type_id], [skill_id], [name]) VALUES (CAST(2 AS Numeric(18, 0)), CAST(2 AS Numeric(18, 0)), CAST(10 AS Numeric(18, 0)), N'Savigent UA')
INSERT [dbo].[Training] ([id], [type_id], [skill_id], [name]) VALUES (CAST(3 AS Numeric(18, 0)), CAST(2 AS Numeric(18, 0)), CAST(10 AS Numeric(18, 0)), N'Savigent Models')
INSERT [dbo].[Training] ([id], [type_id], [skill_id], [name]) VALUES (CAST(4 AS Numeric(18, 0)), CAST(2 AS Numeric(18, 0)), CAST(10 AS Numeric(18, 0)), N'MOM')
INSERT [dbo].[Training] ([id], [type_id], [skill_id], [name]) VALUES (CAST(20 AS Numeric(18, 0)), CAST(16 AS Numeric(18, 0)), CAST(35 AS Numeric(18, 0)), N'Training 1')
INSERT [dbo].[Training] ([id], [type_id], [skill_id], [name]) VALUES (CAST(21 AS Numeric(18, 0)), CAST(16 AS Numeric(18, 0)), CAST(35 AS Numeric(18, 0)), N'Training 2')
INSERT [dbo].[Training] ([id], [type_id], [skill_id], [name]) VALUES (CAST(22 AS Numeric(18, 0)), CAST(16 AS Numeric(18, 0)), CAST(35 AS Numeric(18, 0)), N'Training 3')
INSERT [dbo].[Training] ([id], [type_id], [skill_id], [name]) VALUES (CAST(23 AS Numeric(18, 0)), CAST(16 AS Numeric(18, 0)), CAST(36 AS Numeric(18, 0)), N'Training 1')
INSERT [dbo].[Training] ([id], [type_id], [skill_id], [name]) VALUES (CAST(24 AS Numeric(18, 0)), CAST(16 AS Numeric(18, 0)), CAST(36 AS Numeric(18, 0)), N'Training 2')
INSERT [dbo].[Training] ([id], [type_id], [skill_id], [name]) VALUES (CAST(25 AS Numeric(18, 0)), CAST(16 AS Numeric(18, 0)), CAST(36 AS Numeric(18, 0)), N'Training 3')
INSERT [dbo].[Training] ([id], [type_id], [skill_id], [name]) VALUES (CAST(26 AS Numeric(18, 0)), CAST(16 AS Numeric(18, 0)), CAST(37 AS Numeric(18, 0)), N'Training 1')
INSERT [dbo].[Training] ([id], [type_id], [skill_id], [name]) VALUES (CAST(27 AS Numeric(18, 0)), CAST(16 AS Numeric(18, 0)), CAST(37 AS Numeric(18, 0)), N'Training 2')
INSERT [dbo].[Training] ([id], [type_id], [skill_id], [name]) VALUES (CAST(28 AS Numeric(18, 0)), CAST(16 AS Numeric(18, 0)), CAST(37 AS Numeric(18, 0)), N'Training 3')
SET IDENTITY_INSERT [dbo].[Training] OFF
SET IDENTITY_INSERT [dbo].[TrainingResources] ON 

INSERT [dbo].[TrainingResources] ([id], [training_id], [resource_id], [start_date], [end_date], [duration], [progress], [test_result], [result_status]) VALUES (CAST(46 AS Numeric(18, 0)), CAST(20 AS Numeric(18, 0)), CAST(24 AS Numeric(18, 0)), CAST(N'2017-10-01' AS Date), CAST(N'2017-10-30' AS Date), 168, 100, 90, N'Passed')
INSERT [dbo].[TrainingResources] ([id], [training_id], [resource_id], [start_date], [end_date], [duration], [progress], [test_result], [result_status]) VALUES (CAST(51 AS Numeric(18, 0)), CAST(21 AS Numeric(18, 0)), CAST(24 AS Numeric(18, 0)), CAST(N'2017-11-01' AS Date), CAST(N'2017-11-30' AS Date), 176, 0, 0, N'Pending')
INSERT [dbo].[TrainingResources] ([id], [training_id], [resource_id], [start_date], [end_date], [duration], [progress], [test_result], [result_status]) VALUES (CAST(52 AS Numeric(18, 0)), CAST(22 AS Numeric(18, 0)), CAST(24 AS Numeric(18, 0)), CAST(N'2017-08-07' AS Date), CAST(N'2017-08-29' AS Date), 136, 100, 60, N'Failed')
INSERT [dbo].[TrainingResources] ([id], [training_id], [resource_id], [start_date], [end_date], [duration], [progress], [test_result], [result_status]) VALUES (CAST(53 AS Numeric(18, 0)), CAST(23 AS Numeric(18, 0)), CAST(24 AS Numeric(18, 0)), CAST(N'2017-08-08' AS Date), CAST(N'2017-10-19' AS Date), 424, 100, 70, N'Passed')
INSERT [dbo].[TrainingResources] ([id], [training_id], [resource_id], [start_date], [end_date], [duration], [progress], [test_result], [result_status]) VALUES (CAST(54 AS Numeric(18, 0)), CAST(24 AS Numeric(18, 0)), CAST(24 AS Numeric(18, 0)), CAST(N'2017-11-02' AS Date), CAST(N'2017-12-19' AS Date), 272, 0, 0, N'Pending')
INSERT [dbo].[TrainingResources] ([id], [training_id], [resource_id], [start_date], [end_date], [duration], [progress], [test_result], [result_status]) VALUES (CAST(55 AS Numeric(18, 0)), CAST(25 AS Numeric(18, 0)), CAST(24 AS Numeric(18, 0)), CAST(N'2017-10-31' AS Date), CAST(N'2017-11-03' AS Date), 32, 100, 90, N'Passed')
INSERT [dbo].[TrainingResources] ([id], [training_id], [resource_id], [start_date], [end_date], [duration], [progress], [test_result], [result_status]) VALUES (CAST(56 AS Numeric(18, 0)), CAST(26 AS Numeric(18, 0)), CAST(24 AS Numeric(18, 0)), CAST(N'2017-12-12' AS Date), CAST(N'2018-02-20' AS Date), 408, 100, 89, N'Passed')
INSERT [dbo].[TrainingResources] ([id], [training_id], [resource_id], [start_date], [end_date], [duration], [progress], [test_result], [result_status]) VALUES (CAST(57 AS Numeric(18, 0)), CAST(27 AS Numeric(18, 0)), CAST(24 AS Numeric(18, 0)), CAST(N'2017-10-01' AS Date), CAST(N'2017-10-09' AS Date), 48, 100, 100, N'Passed')
INSERT [dbo].[TrainingResources] ([id], [training_id], [resource_id], [start_date], [end_date], [duration], [progress], [test_result], [result_status]) VALUES (CAST(58 AS Numeric(18, 0)), CAST(28 AS Numeric(18, 0)), CAST(24 AS Numeric(18, 0)), CAST(N'2017-10-01' AS Date), CAST(N'2017-10-09' AS Date), 48, 100, 89, N'Passed')
INSERT [dbo].[TrainingResources] ([id], [training_id], [resource_id], [start_date], [end_date], [duration], [progress], [test_result], [result_status]) VALUES (CAST(10042 AS Numeric(18, 0)), CAST(1 AS Numeric(18, 0)), CAST(9 AS Numeric(18, 0)), CAST(N'2017-11-10' AS Date), CAST(N'2017-11-22' AS Date), 72, 0, 0, N'Pending')
INSERT [dbo].[TrainingResources] ([id], [training_id], [resource_id], [start_date], [end_date], [duration], [progress], [test_result], [result_status]) VALUES (CAST(10043 AS Numeric(18, 0)), CAST(20 AS Numeric(18, 0)), CAST(9 AS Numeric(18, 0)), CAST(N'2017-11-14' AS Date), CAST(N'2017-11-24' AS Date), 72, 0, 0, N'Pending')
INSERT [dbo].[TrainingResources] ([id], [training_id], [resource_id], [start_date], [end_date], [duration], [progress], [test_result], [result_status]) VALUES (CAST(10044 AS Numeric(18, 0)), CAST(3 AS Numeric(18, 0)), CAST(21 AS Numeric(18, 0)), CAST(N'2018-01-08' AS Date), CAST(N'2018-01-25' AS Date), 112, 100, 100, N'Passed')
INSERT [dbo].[TrainingResources] ([id], [training_id], [resource_id], [start_date], [end_date], [duration], [progress], [test_result], [result_status]) VALUES (CAST(10045 AS Numeric(18, 0)), CAST(3 AS Numeric(18, 0)), CAST(10027 AS Numeric(18, 0)), CAST(N'2018-01-08' AS Date), CAST(N'2018-01-25' AS Date), 112, 100, 100, N'Passed')
INSERT [dbo].[TrainingResources] ([id], [training_id], [resource_id], [start_date], [end_date], [duration], [progress], [test_result], [result_status]) VALUES (CAST(10046 AS Numeric(18, 0)), CAST(3 AS Numeric(18, 0)), CAST(20 AS Numeric(18, 0)), CAST(N'2018-01-08' AS Date), CAST(N'2018-01-25' AS Date), 112, 100, 100, N'Passed')
INSERT [dbo].[TrainingResources] ([id], [training_id], [resource_id], [start_date], [end_date], [duration], [progress], [test_result], [result_status]) VALUES (CAST(10047 AS Numeric(18, 0)), CAST(3 AS Numeric(18, 0)), CAST(24 AS Numeric(18, 0)), CAST(N'2018-01-08' AS Date), CAST(N'2018-01-25' AS Date), 112, 100, 100, N'Passed')
INSERT [dbo].[TrainingResources] ([id], [training_id], [resource_id], [start_date], [end_date], [duration], [progress], [test_result], [result_status]) VALUES (CAST(10048 AS Numeric(18, 0)), CAST(3 AS Numeric(18, 0)), CAST(22 AS Numeric(18, 0)), CAST(N'2018-01-08' AS Date), CAST(N'2018-01-25' AS Date), 112, 100, 100, N'Passed')
SET IDENTITY_INSERT [dbo].[TrainingResources] OFF
SET IDENTITY_INSERT [dbo].[Type] ON 

INSERT [dbo].[Type] ([id], [name], [apply_to]) VALUES (CAST(2 AS Numeric(18, 0)), N'Implementation', N'Project')
INSERT [dbo].[Type] ([id], [name], [apply_to]) VALUES (CAST(7 AS Numeric(18, 0)), N'MOM Mapping', N'Project')
INSERT [dbo].[Type] ([id], [name], [apply_to]) VALUES (CAST(11 AS Numeric(18, 0)), N'MOM Engineer', N'Resource')
INSERT [dbo].[Type] ([id], [name], [apply_to]) VALUES (CAST(13 AS Numeric(18, 0)), N'Developer', N'Resource')
INSERT [dbo].[Type] ([id], [name], [apply_to]) VALUES (CAST(16 AS Numeric(18, 0)), N'Training Type', N'Project')
SET IDENTITY_INSERT [dbo].[Type] OFF
SET IDENTITY_INSERT [dbo].[TypeSkills] ON 

INSERT [dbo].[TypeSkills] ([id], [type_id], [skill_id], [skill_name], [value]) VALUES (CAST(10056 AS Numeric(18, 0)), CAST(2 AS Numeric(18, 0)), CAST(10 AS Numeric(18, 0)), N'Savigent', 80)
INSERT [dbo].[TypeSkills] ([id], [type_id], [skill_id], [skill_name], [value]) VALUES (CAST(10057 AS Numeric(18, 0)), CAST(2 AS Numeric(18, 0)), CAST(9 AS Numeric(18, 0)), N'MOM Fundamentals', 70)
INSERT [dbo].[TypeSkills] ([id], [type_id], [skill_id], [skill_name], [value]) VALUES (CAST(10058 AS Numeric(18, 0)), CAST(7 AS Numeric(18, 0)), CAST(14 AS Numeric(18, 0)), N'Basic Soft Skills', 60)
INSERT [dbo].[TypeSkills] ([id], [type_id], [skill_id], [skill_name], [value]) VALUES (CAST(10059 AS Numeric(18, 0)), CAST(2 AS Numeric(18, 0)), CAST(14 AS Numeric(18, 0)), N'Basic Soft Skills', 60)
INSERT [dbo].[TypeSkills] ([id], [type_id], [skill_id], [skill_name], [value]) VALUES (CAST(10060 AS Numeric(18, 0)), CAST(7 AS Numeric(18, 0)), CAST(9 AS Numeric(18, 0)), N'MOM Fundamentals', 80)
INSERT [dbo].[TypeSkills] ([id], [type_id], [skill_id], [skill_name], [value]) VALUES (CAST(10061 AS Numeric(18, 0)), CAST(7 AS Numeric(18, 0)), CAST(10 AS Numeric(18, 0)), N'Savigent', 90)
INSERT [dbo].[TypeSkills] ([id], [type_id], [skill_id], [skill_name], [value]) VALUES (CAST(10062 AS Numeric(18, 0)), CAST(7 AS Numeric(18, 0)), CAST(16 AS Numeric(18, 0)), N'CS', 60)
INSERT [dbo].[TypeSkills] ([id], [type_id], [skill_id], [skill_name], [value]) VALUES (CAST(10063 AS Numeric(18, 0)), CAST(7 AS Numeric(18, 0)), CAST(28 AS Numeric(18, 0)), N'Soft Skils Specialized', 62)
INSERT [dbo].[TypeSkills] ([id], [type_id], [skill_id], [skill_name], [value]) VALUES (CAST(10066 AS Numeric(18, 0)), CAST(13 AS Numeric(18, 0)), CAST(16 AS Numeric(18, 0)), N'CS', 90)
INSERT [dbo].[TypeSkills] ([id], [type_id], [skill_id], [skill_name], [value]) VALUES (CAST(10067 AS Numeric(18, 0)), CAST(13 AS Numeric(18, 0)), CAST(15 AS Numeric(18, 0)), N'Behaviorals', 80)
INSERT [dbo].[TypeSkills] ([id], [type_id], [skill_id], [skill_name], [value]) VALUES (CAST(10068 AS Numeric(18, 0)), CAST(13 AS Numeric(18, 0)), CAST(21 AS Numeric(18, 0)), N'Mockups', 60)
INSERT [dbo].[TypeSkills] ([id], [type_id], [skill_id], [skill_name], [value]) VALUES (CAST(10069 AS Numeric(18, 0)), CAST(13 AS Numeric(18, 0)), CAST(19 AS Numeric(18, 0)), N'Library Services', 80)
INSERT [dbo].[TypeSkills] ([id], [type_id], [skill_id], [skill_name], [value]) VALUES (CAST(10070 AS Numeric(18, 0)), CAST(13 AS Numeric(18, 0)), CAST(25 AS Numeric(18, 0)), N'Quality', 50)
INSERT [dbo].[TypeSkills] ([id], [type_id], [skill_id], [skill_name], [value]) VALUES (CAST(10073 AS Numeric(18, 0)), CAST(11 AS Numeric(18, 0)), CAST(23 AS Numeric(18, 0)), N'PFS', 85)
INSERT [dbo].[TypeSkills] ([id], [type_id], [skill_id], [skill_name], [value]) VALUES (CAST(10078 AS Numeric(18, 0)), CAST(11 AS Numeric(18, 0)), CAST(14 AS Numeric(18, 0)), N'Basic Soft Skills', 80)
INSERT [dbo].[TypeSkills] ([id], [type_id], [skill_id], [skill_name], [value]) VALUES (CAST(10079 AS Numeric(18, 0)), CAST(11 AS Numeric(18, 0)), CAST(9 AS Numeric(18, 0)), N'MOM Fundamentals', 60)
INSERT [dbo].[TypeSkills] ([id], [type_id], [skill_id], [skill_name], [value]) VALUES (CAST(10081 AS Numeric(18, 0)), CAST(11 AS Numeric(18, 0)), CAST(28 AS Numeric(18, 0)), N'Soft Skils Specialized', 76)
INSERT [dbo].[TypeSkills] ([id], [type_id], [skill_id], [skill_name], [value]) VALUES (CAST(10082 AS Numeric(18, 0)), CAST(11 AS Numeric(18, 0)), CAST(16 AS Numeric(18, 0)), N'CS', 74)
INSERT [dbo].[TypeSkills] ([id], [type_id], [skill_id], [skill_name], [value]) VALUES (CAST(10087 AS Numeric(18, 0)), CAST(16 AS Numeric(18, 0)), CAST(35 AS Numeric(18, 0)), N'Training Skill 1', 100)
INSERT [dbo].[TypeSkills] ([id], [type_id], [skill_id], [skill_name], [value]) VALUES (CAST(10088 AS Numeric(18, 0)), CAST(16 AS Numeric(18, 0)), CAST(36 AS Numeric(18, 0)), N'Training Skill 2', 100)
INSERT [dbo].[TypeSkills] ([id], [type_id], [skill_id], [skill_name], [value]) VALUES (CAST(10089 AS Numeric(18, 0)), CAST(16 AS Numeric(18, 0)), CAST(37 AS Numeric(18, 0)), N'Training Skill 3', 100)
SET IDENTITY_INSERT [dbo].[TypeSkills] OFF
ALTER TABLE [dbo].[ProductivityTasks] ADD  CONSTRAINT [DF_ProductivityTasks_is_out_of_scope]  DEFAULT ((0)) FOR [is_out_of_scope]
GO
ALTER TABLE [dbo].[ProductivityReport]  WITH CHECK ADD  CONSTRAINT [FK_ProductivityReport_ProductivityTasks] FOREIGN KEY([task_id])
REFERENCES [dbo].[ProductivityTasks] ([id])
GO
ALTER TABLE [dbo].[ProductivityReport] CHECK CONSTRAINT [FK_ProductivityReport_ProductivityTasks]
GO
ALTER TABLE [dbo].[ProductivityReport]  WITH CHECK ADD  CONSTRAINT [FK_ProductivityReport_Resource] FOREIGN KEY([resource_id])
REFERENCES [dbo].[Resource] ([id])
GO
ALTER TABLE [dbo].[ProductivityReport] CHECK CONSTRAINT [FK_ProductivityReport_Resource]
GO
ALTER TABLE [dbo].[ProductivityTasks]  WITH CHECK ADD  CONSTRAINT [FK_ProductivityTasks_Project] FOREIGN KEY([project_id])
REFERENCES [dbo].[Project] ([id])
GO
ALTER TABLE [dbo].[ProductivityTasks] CHECK CONSTRAINT [FK_ProductivityTasks_Project]
GO
ALTER TABLE [dbo].[Project]  WITH CHECK ADD  CONSTRAINT [FK_Project_Resource] FOREIGN KEY([leader_id])
REFERENCES [dbo].[Resource] ([id])
GO
ALTER TABLE [dbo].[Project] CHECK CONSTRAINT [FK_Project_Resource]
GO
ALTER TABLE [dbo].[ProjectForecastAssigns]  WITH CHECK ADD  CONSTRAINT [FK_ProjectForecastAssigns_ProjectForecast] FOREIGN KEY([projectForecast_id])
REFERENCES [dbo].[ProjectForecast] ([id])
GO
ALTER TABLE [dbo].[ProjectForecastAssigns] CHECK CONSTRAINT [FK_ProjectForecastAssigns_ProjectForecast]
GO
ALTER TABLE [dbo].[ProjectForecastAssigns]  WITH CHECK ADD  CONSTRAINT [FK_ProjectForecastAssigns_Type] FOREIGN KEY([type_id])
REFERENCES [dbo].[Type] ([id])
GO
ALTER TABLE [dbo].[ProjectForecastAssigns] CHECK CONSTRAINT [FK_ProjectForecastAssigns_Type]
GO
ALTER TABLE [dbo].[ProjectForecastTypes]  WITH CHECK ADD  CONSTRAINT [FK_ProjectForecastTypes_ProjectForecast] FOREIGN KEY([projectForecast_id])
REFERENCES [dbo].[ProjectForecast] ([id])
GO
ALTER TABLE [dbo].[ProjectForecastTypes] CHECK CONSTRAINT [FK_ProjectForecastTypes_ProjectForecast]
GO
ALTER TABLE [dbo].[ProjectForecastTypes]  WITH CHECK ADD  CONSTRAINT [FK_ProjectForecastTypes_Type] FOREIGN KEY([type_id])
REFERENCES [dbo].[Type] ([id])
GO
ALTER TABLE [dbo].[ProjectForecastTypes] CHECK CONSTRAINT [FK_ProjectForecastTypes_Type]
GO
ALTER TABLE [dbo].[ProjectResources]  WITH CHECK ADD  CONSTRAINT [FK_ProjectResources_Project] FOREIGN KEY([project_id])
REFERENCES [dbo].[Project] ([id])
GO
ALTER TABLE [dbo].[ProjectResources] CHECK CONSTRAINT [FK_ProjectResources_Project]
GO
ALTER TABLE [dbo].[ProjectResources]  WITH CHECK ADD  CONSTRAINT [FK_ProjectResources_Resource] FOREIGN KEY([resource_id])
REFERENCES [dbo].[Resource] ([id])
GO
ALTER TABLE [dbo].[ProjectResources] CHECK CONSTRAINT [FK_ProjectResources_Resource]
GO
ALTER TABLE [dbo].[ProjectTypes]  WITH CHECK ADD  CONSTRAINT [FK_ProjectTypes_Project] FOREIGN KEY([project_id])
REFERENCES [dbo].[Project] ([id])
GO
ALTER TABLE [dbo].[ProjectTypes] CHECK CONSTRAINT [FK_ProjectTypes_Project]
GO
ALTER TABLE [dbo].[ProjectTypes]  WITH CHECK ADD  CONSTRAINT [FK_ProjectTypes_Type] FOREIGN KEY([type_id])
REFERENCES [dbo].[Type] ([id])
GO
ALTER TABLE [dbo].[ProjectTypes] CHECK CONSTRAINT [FK_ProjectTypes_Type]
GO
ALTER TABLE [dbo].[ResourceSkills]  WITH CHECK ADD  CONSTRAINT [FK_ResourceSkills_Resource] FOREIGN KEY([resource_id])
REFERENCES [dbo].[Resource] ([id])
GO
ALTER TABLE [dbo].[ResourceSkills] CHECK CONSTRAINT [FK_ResourceSkills_Resource]
GO
ALTER TABLE [dbo].[ResourceSkills]  WITH CHECK ADD  CONSTRAINT [FK_ResourceSkills_Skill] FOREIGN KEY([skill_id])
REFERENCES [dbo].[Skill] ([id])
GO
ALTER TABLE [dbo].[ResourceSkills] CHECK CONSTRAINT [FK_ResourceSkills_Skill]
GO
ALTER TABLE [dbo].[ResourceTypes]  WITH CHECK ADD  CONSTRAINT [FK_ResourceTypes_Resource] FOREIGN KEY([resource_id])
REFERENCES [dbo].[Resource] ([id])
GO
ALTER TABLE [dbo].[ResourceTypes] CHECK CONSTRAINT [FK_ResourceTypes_Resource]
GO
ALTER TABLE [dbo].[ResourceTypes]  WITH CHECK ADD  CONSTRAINT [FK_ResourceTypes_Type] FOREIGN KEY([type_id])
REFERENCES [dbo].[Type] ([id])
GO
ALTER TABLE [dbo].[ResourceTypes] CHECK CONSTRAINT [FK_ResourceTypes_Type]
GO
ALTER TABLE [dbo].[Training]  WITH CHECK ADD  CONSTRAINT [FK_Training_Skill] FOREIGN KEY([skill_id])
REFERENCES [dbo].[Skill] ([id])
GO
ALTER TABLE [dbo].[Training] CHECK CONSTRAINT [FK_Training_Skill]
GO
ALTER TABLE [dbo].[Training]  WITH CHECK ADD  CONSTRAINT [FK_Training_Type] FOREIGN KEY([type_id])
REFERENCES [dbo].[Type] ([id])
GO
ALTER TABLE [dbo].[Training] CHECK CONSTRAINT [FK_Training_Type]
GO
ALTER TABLE [dbo].[TrainingResources]  WITH CHECK ADD  CONSTRAINT [FK_TrainingResources_Resource] FOREIGN KEY([resource_id])
REFERENCES [dbo].[Resource] ([id])
GO
ALTER TABLE [dbo].[TrainingResources] CHECK CONSTRAINT [FK_TrainingResources_Resource]
GO
ALTER TABLE [dbo].[TrainingResources]  WITH CHECK ADD  CONSTRAINT [FK_TrainingResources_Training] FOREIGN KEY([training_id])
REFERENCES [dbo].[Training] ([id])
GO
ALTER TABLE [dbo].[TrainingResources] CHECK CONSTRAINT [FK_TrainingResources_Training]
GO
ALTER TABLE [dbo].[TypeSkills]  WITH CHECK ADD  CONSTRAINT [FK_TypeSkills_Skill] FOREIGN KEY([skill_id])
REFERENCES [dbo].[Skill] ([id])
GO
ALTER TABLE [dbo].[TypeSkills] CHECK CONSTRAINT [FK_TypeSkills_Skill]
GO
ALTER TABLE [dbo].[TypeSkills]  WITH CHECK ADD  CONSTRAINT [FK_TypeSkills_Type] FOREIGN KEY([type_id])
REFERENCES [dbo].[Type] ([id])
GO
ALTER TABLE [dbo].[TypeSkills] CHECK CONSTRAINT [FK_TypeSkills_Type]
GO
USE [master]
GO
ALTER DATABASE [prm] SET  READ_WRITE 
GO
