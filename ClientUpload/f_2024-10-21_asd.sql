USE [master]
GO
/****** Object:  Database [HelpDeskSystem]    Script Date: 10/21/2024 8:07:18 AM ******/
CREATE DATABASE [HelpDeskSystem]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'HelpDeskSystem', FILENAME = N'D:\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\HelpDeskSystem.mdf' , SIZE = 73728KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'HelpDeskSystem_log', FILENAME = N'D:\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\HelpDeskSystem_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [HelpDeskSystem] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [HelpDeskSystem].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [HelpDeskSystem] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [HelpDeskSystem] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [HelpDeskSystem] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [HelpDeskSystem] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [HelpDeskSystem] SET ARITHABORT OFF 
GO
ALTER DATABASE [HelpDeskSystem] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [HelpDeskSystem] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [HelpDeskSystem] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [HelpDeskSystem] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [HelpDeskSystem] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [HelpDeskSystem] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [HelpDeskSystem] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [HelpDeskSystem] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [HelpDeskSystem] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [HelpDeskSystem] SET  ENABLE_BROKER 
GO
ALTER DATABASE [HelpDeskSystem] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [HelpDeskSystem] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [HelpDeskSystem] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [HelpDeskSystem] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [HelpDeskSystem] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [HelpDeskSystem] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [HelpDeskSystem] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [HelpDeskSystem] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [HelpDeskSystem] SET  MULTI_USER 
GO
ALTER DATABASE [HelpDeskSystem] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [HelpDeskSystem] SET DB_CHAINING OFF 
GO
ALTER DATABASE [HelpDeskSystem] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [HelpDeskSystem] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [HelpDeskSystem] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [HelpDeskSystem] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [HelpDeskSystem] SET QUERY_STORE = ON
GO
ALTER DATABASE [HelpDeskSystem] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [HelpDeskSystem]
GO
/****** Object:  Table [dbo].[SystemCodeDetails]    Script Date: 10/21/2024 8:07:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SystemCodeDetails](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](max) NOT NULL,
	[Description] [nvarchar](max) NOT NULL,
	[OrderNo] [int] NULL,
	[SystemCodeId] [int] NOT NULL,
	[DelTime] [datetime2](7) NULL,
	[Note] [nvarchar](max) NULL,
	[CreatedById] [nvarchar](450) NOT NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[ModifiedById] [nvarchar](450) NULL,
	[ModifiedOn] [datetime2](7) NULL,
 CONSTRAINT [PK_SystemCodeDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Tickets]    Script Date: 10/21/2024 8:07:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tickets](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](max) NOT NULL,
	[Description] [nvarchar](max) NOT NULL,
	[CreatedById] [nvarchar](450) NOT NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[DelTime] [datetime2](7) NULL,
	[Note] [nvarchar](max) NULL,
	[SubCategoryId] [int] NOT NULL,
	[PriorityId] [int] NOT NULL,
	[StatusId] [int] NOT NULL,
	[Attachment] [nvarchar](max) NULL,
	[AssignedOn] [datetime2](7) NULL,
	[AssignedToId] [nvarchar](450) NULL,
	[ModifiedById] [nvarchar](450) NULL,
	[ModifiedOn] [datetime2](7) NULL,
 CONSTRAINT [PK_Tickets] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[TicketsSummaryView]    Script Date: 10/21/2024 8:07:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create   view [dbo].[TicketsSummaryView]
as
select 
COUNT(t1.Id) as TotalTickets,
SUM(case when t2.Code = 'Assigned' then 1 else 0 end) as AssignedTickets, 
SUM(case when t2.Code = 'Pending' then 1 else 0 end) as PendingTickets,
SUM(case when t2.Code = 'Resolved' then 1 else 0 end) as ResolvedTickets, 
SUM(case when t2.Code = 'Closed' then 1 else 0 end) as ClosedTickets
from Tickets t1
join SystemCodeDetails t2 on t1.StatusId = t2.Id
where t1.DelTime is null
GO
/****** Object:  View [dbo].[TicketsPriorityView]    Script Date: 10/21/2024 8:07:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   view [dbo].[TicketsPriorityView]
as
select 
COUNT(t1.Id) as TotalTickets,
SUM(case when t2.Code = 'Low' then 1 else 0 end) as LowTickets, 
SUM(case when t2.Code = 'Medium' then 1 else 0 end) as MediumTickets,
SUM(case when t2.Code = 'High' then 1 else 0 end) as HighTickets
from Tickets t1
join SystemCodeDetails t2 on t1.PriorityId = t2.Id
where t1.DelTime is null
GO
/****** Object:  Table [dbo].[__EFMigrationsHistory]    Script Date: 10/21/2024 8:07:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[__EFMigrationsHistory](
	[MigrationId] [nvarchar](150) NOT NULL,
	[ProductVersion] [nvarchar](32) NOT NULL,
 CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY CLUSTERED 
(
	[MigrationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetRoleClaims]    Script Date: 10/21/2024 8:07:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetRoleClaims](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RoleId] [nvarchar](450) NOT NULL,
	[ClaimType] [nvarchar](max) NULL,
	[ClaimValue] [nvarchar](max) NULL,
 CONSTRAINT [PK_AspNetRoleClaims] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetRoles]    Script Date: 10/21/2024 8:07:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetRoles](
	[Id] [nvarchar](450) NOT NULL,
	[Name] [nvarchar](256) NULL,
	[NormalizedName] [nvarchar](256) NULL,
	[ConcurrencyStamp] [nvarchar](max) NULL,
	[CreatedById] [nvarchar](450) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[DelTime] [datetime2](7) NULL,
	[Discriminator] [nvarchar](8) NOT NULL,
	[ModifiedById] [nvarchar](450) NULL,
	[ModifiedOn] [datetime2](7) NULL,
	[Note] [nvarchar](max) NULL,
 CONSTRAINT [PK_AspNetRoles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserClaims]    Script Date: 10/21/2024 8:07:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserClaims](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [nvarchar](450) NOT NULL,
	[ClaimType] [nvarchar](max) NULL,
	[ClaimValue] [nvarchar](max) NULL,
 CONSTRAINT [PK_AspNetUserClaims] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserLogins]    Script Date: 10/21/2024 8:07:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserLogins](
	[LoginProvider] [nvarchar](450) NOT NULL,
	[ProviderKey] [nvarchar](450) NOT NULL,
	[ProviderDisplayName] [nvarchar](max) NULL,
	[UserId] [nvarchar](450) NOT NULL,
 CONSTRAINT [PK_AspNetUserLogins] PRIMARY KEY CLUSTERED 
(
	[LoginProvider] ASC,
	[ProviderKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserRoles]    Script Date: 10/21/2024 8:07:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserRoles](
	[UserId] [nvarchar](450) NOT NULL,
	[RoleId] [nvarchar](450) NOT NULL,
 CONSTRAINT [PK_AspNetUserRoles] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUsers]    Script Date: 10/21/2024 8:07:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUsers](
	[Id] [nvarchar](450) NOT NULL,
	[UserName] [nvarchar](256) NULL,
	[NormalizedUserName] [nvarchar](256) NULL,
	[Email] [nvarchar](256) NULL,
	[NormalizedEmail] [nvarchar](256) NULL,
	[EmailConfirmed] [bit] NOT NULL,
	[PasswordHash] [nvarchar](max) NULL,
	[SecurityStamp] [nvarchar](max) NULL,
	[ConcurrencyStamp] [nvarchar](max) NULL,
	[PhoneNumber] [nvarchar](max) NULL,
	[PhoneNumberConfirmed] [bit] NOT NULL,
	[TwoFactorEnabled] [bit] NOT NULL,
	[LockoutEnd] [datetimeoffset](7) NULL,
	[LockoutEnabled] [bit] NOT NULL,
	[AccessFailedCount] [int] NOT NULL,
	[DOB] [date] NOT NULL,
	[DelTime] [datetime2](7) NULL,
	[Name] [nvarchar](max) NOT NULL,
	[Note] [nvarchar](max) NULL,
	[CreatedById] [nvarchar](450) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[ModifiedById] [nvarchar](450) NULL,
	[ModifiedOn] [datetime2](7) NULL,
	[GenderId] [int] NOT NULL,
	[RoleId] [nvarchar](450) NOT NULL,
	[IsLocked] [bit] NULL,
 CONSTRAINT [PK_AspNetUsers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserTokens]    Script Date: 10/21/2024 8:07:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserTokens](
	[UserId] [nvarchar](450) NOT NULL,
	[LoginProvider] [nvarchar](450) NOT NULL,
	[Name] [nvarchar](450) NOT NULL,
	[Value] [nvarchar](max) NULL,
 CONSTRAINT [PK_AspNetUserTokens] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[LoginProvider] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AuditTrails]    Script Date: 10/21/2024 8:07:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AuditTrails](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Action] [nvarchar](max) NOT NULL,
	[Module] [nvarchar](max) NOT NULL,
	[AffectedTable] [nvarchar](max) NOT NULL,
	[TimeStamp] [datetime2](7) NOT NULL,
	[UserId] [nvarchar](450) NOT NULL,
	[OldValues] [nvarchar](max) NULL,
	[NewValues] [nvarchar](max) NULL,
	[AffectedColumns] [nvarchar](max) NULL,
	[DelTime] [datetime2](7) NULL,
	[Note] [nvarchar](max) NULL,
	[PrimaryKey] [nvarchar](max) NULL,
 CONSTRAINT [PK_AuditTrails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Comments]    Script Date: 10/21/2024 8:07:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Comments](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Description] [nvarchar](max) NOT NULL,
	[TicketId] [int] NOT NULL,
	[CreatedById] [nvarchar](450) NOT NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[DelTime] [datetime2](7) NULL,
	[Note] [nvarchar](max) NULL,
	[ModifiedById] [nvarchar](450) NULL,
	[ModifiedOn] [datetime2](7) NULL,
 CONSTRAINT [PK_Comments] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Departments]    Script Date: 10/21/2024 8:07:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Departments](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](max) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[CreatedById] [nvarchar](450) NOT NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[ModifiedById] [nvarchar](450) NULL,
	[ModifiedOn] [datetime2](7) NULL,
	[DelTime] [datetime2](7) NULL,
	[Note] [nvarchar](max) NULL,
 CONSTRAINT [PK_Departments] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SystemCodes]    Script Date: 10/21/2024 8:07:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SystemCodes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](max) NOT NULL,
	[Description] [nvarchar](max) NOT NULL,
	[DelTime] [datetime2](7) NULL,
	[Note] [nvarchar](max) NULL,
	[CreatedById] [nvarchar](450) NOT NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[ModifiedById] [nvarchar](450) NULL,
	[ModifiedOn] [datetime2](7) NULL,
 CONSTRAINT [PK_SystemCodes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SystemSettings]    Script Date: 10/21/2024 8:07:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SystemSettings](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](max) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[Value] [int] NOT NULL,
	[CreatedById] [nvarchar](450) NOT NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[ModifiedById] [nvarchar](450) NULL,
	[ModifiedOn] [datetime2](7) NULL,
	[DelTime] [datetime2](7) NULL,
	[Note] [nvarchar](max) NULL,
 CONSTRAINT [PK_SystemSettings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SystemTasks]    Script Date: 10/21/2024 8:07:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SystemTasks](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ParentId] [int] NULL,
	[Code] [nvarchar](max) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[OrderNo] [int] NULL,
	[CreatedById] [nvarchar](450) NOT NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[ModifiedById] [nvarchar](450) NULL,
	[ModifiedOn] [datetime2](7) NULL,
	[DelTime] [datetime2](7) NULL,
	[Note] [nvarchar](max) NULL,
 CONSTRAINT [PK_SystemTasks] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TicketCategories]    Script Date: 10/21/2024 8:07:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TicketCategories](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](max) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[DelTime] [datetime2](7) NULL,
	[Note] [nvarchar](max) NULL,
	[CreatedById] [nvarchar](450) NOT NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[ModifiedById] [nvarchar](450) NULL,
	[ModifiedOn] [datetime2](7) NULL,
 CONSTRAINT [PK_TicketCategories] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TicketResolutions]    Script Date: 10/21/2024 8:07:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TicketResolutions](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TicketId] [int] NOT NULL,
	[Description] [nvarchar](max) NOT NULL,
	[StatusId] [int] NOT NULL,
	[CreatedById] [nvarchar](450) NOT NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[ModifiedById] [nvarchar](450) NULL,
	[ModifiedOn] [datetime2](7) NULL,
	[DelTime] [datetime2](7) NULL,
	[Note] [nvarchar](max) NULL,
 CONSTRAINT [PK_TicketResolutions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TicketSubCategories]    Script Date: 10/21/2024 8:07:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TicketSubCategories](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CategoryId] [int] NOT NULL,
	[Code] [nvarchar](max) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[DelTime] [datetime2](7) NULL,
	[Note] [nvarchar](max) NULL,
	[CreatedById] [nvarchar](450) NOT NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[ModifiedById] [nvarchar](450) NULL,
	[ModifiedOn] [datetime2](7) NULL,
 CONSTRAINT [PK_TicketSubCategories] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserRoleProfiles]    Script Date: 10/21/2024 8:07:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserRoleProfiles](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TaskId] [int] NOT NULL,
	[RoleId] [nvarchar](450) NOT NULL,
	[CreatedById] [nvarchar](450) NOT NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[ModifiedById] [nvarchar](450) NULL,
	[ModifiedOn] [datetime2](7) NULL,
	[DelTime] [datetime2](7) NULL,
	[Note] [nvarchar](max) NULL,
 CONSTRAINT [PK_UserRoleProfiles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'00000000000000_CreateIdentitySchema', N'8.0.8')
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20240829070603_default', N'8.0.8')
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20240829071251_appuser', N'8.0.8')
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20240829073624_ticket', N'8.0.8')
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20240829080137_comment', N'8.0.8')
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20240829101242_audittrail', N'8.0.8')
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20240831085156_ticketcategory', N'8.0.8')
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20240831090441_ticketcategory2', N'8.0.8')
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20240831110222_ticketsubcategory', N'8.0.8')
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20240902103156_moreTicket', N'8.0.8')
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20240903073144_systemcode', N'8.0.8')
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20240903074558_systemcode2', N'8.0.8')
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20240903092810_modticket', N'8.0.8')
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20240903120528_moreticket2', N'8.0.8')
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20240903135159_department', N'8.0.8')
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20240907100341_solution', N'8.0.8')
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20240909085935_assticket', N'8.0.8')
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20240909102319_modassticket', N'8.0.8')
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20240909102634_modassticket2', N'8.0.8')
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20240909113715_modattach', N'8.0.8')
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20240911081750_systemtask', N'8.0.8')
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20240911082552_moduser', N'8.0.8')
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20240911101206_systemsetting', N'8.0.8')
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20240911102920_modsystemsetting', N'8.0.8')
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20240912071615_userroles', N'8.0.8')
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20240914123107_gender', N'8.0.8')
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20240914123313_modgender', N'8.0.8')
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20240915071356_modaudit', N'8.0.8')
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20241008003537_userlock', N'8.0.8')
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20241018085757_approle', N'8.0.10')
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20241018100100_approle2', N'8.0.10')
GO
INSERT [dbo].[AspNetRoles] ([Id], [Name], [NormalizedName], [ConcurrencyStamp], [CreatedById], [CreatedOn], [DelTime], [Discriminator], [ModifiedById], [ModifiedOn], [Note]) VALUES (N'27c5880b-5900-4a54-b9ae-7de5f24c73f1', N'test123', NULL, NULL, NULL, CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2), NULL, N'AppRole', N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-19T18:46:58.8644261' AS DateTime2), NULL)
INSERT [dbo].[AspNetRoles] ([Id], [Name], [NormalizedName], [ConcurrencyStamp], [CreatedById], [CreatedOn], [DelTime], [Discriminator], [ModifiedById], [ModifiedOn], [Note]) VALUES (N'449ff925-d655-41d9-a5e3-ac4f4f472ddd', N'123', N'123', NULL, N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-18T21:53:08.5581259' AS DateTime2), NULL, N'AppRole', NULL, NULL, NULL)
INSERT [dbo].[AspNetRoles] ([Id], [Name], [NormalizedName], [ConcurrencyStamp], [CreatedById], [CreatedOn], [DelTime], [Discriminator], [ModifiedById], [ModifiedOn], [Note]) VALUES (N'70ea0da2-45f4-44bc-809d-1becc2198498', N'Normal User', N'NORMAL USER', NULL, NULL, CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2), NULL, N'AppRole', NULL, NULL, NULL)
INSERT [dbo].[AspNetRoles] ([Id], [Name], [NormalizedName], [ConcurrencyStamp], [CreatedById], [CreatedOn], [DelTime], [Discriminator], [ModifiedById], [ModifiedOn], [Note]) VALUES (N'b750fcb9-71f0-4434-a37e-1c3e0ab9461b', N'Admin', N'ADMIN', NULL, NULL, CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2), NULL, N'AppRole', NULL, NULL, NULL)
INSERT [dbo].[AspNetRoles] ([Id], [Name], [NormalizedName], [ConcurrencyStamp], [CreatedById], [CreatedOn], [DelTime], [Discriminator], [ModifiedById], [ModifiedOn], [Note]) VALUES (N'bff28742-3bad-4431-83f7-7a81d75e3b31', N'test2222', NULL, NULL, N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-18T17:11:34.0000000' AS DateTime2), NULL, N'AppRole', N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-18T22:31:30.9014344' AS DateTime2), NULL)
GO
INSERT [dbo].[AspNetUserRoles] ([UserId], [RoleId]) VALUES (N'1f70a729-996a-45de-b002-0e2b62ab2d8c', N'27c5880b-5900-4a54-b9ae-7de5f24c73f1')
INSERT [dbo].[AspNetUserRoles] ([UserId], [RoleId]) VALUES (N'1f70a729-996a-45de-b002-0e2b62ab2d8c', N'70ea0da2-45f4-44bc-809d-1becc2198498')
INSERT [dbo].[AspNetUserRoles] ([UserId], [RoleId]) VALUES (N'3a55e370-2d81-4506-96fe-e6c614ed44e8', N'70ea0da2-45f4-44bc-809d-1becc2198498')
INSERT [dbo].[AspNetUserRoles] ([UserId], [RoleId]) VALUES (N'8788c5e7-1463-4215-99fe-8701d5e83199', N'70ea0da2-45f4-44bc-809d-1becc2198498')
INSERT [dbo].[AspNetUserRoles] ([UserId], [RoleId]) VALUES (N'9feae18c-6e8c-46fe-9d32-76e59a80cf35', N'70ea0da2-45f4-44bc-809d-1becc2198498')
INSERT [dbo].[AspNetUserRoles] ([UserId], [RoleId]) VALUES (N'147df890-1c7c-4fc5-a78b-0262e832f25c', N'b750fcb9-71f0-4434-a37e-1c3e0ab9461b')
INSERT [dbo].[AspNetUserRoles] ([UserId], [RoleId]) VALUES (N'1f70a729-996a-45de-b002-0e2b62ab2d8c', N'b750fcb9-71f0-4434-a37e-1c3e0ab9461b')
INSERT [dbo].[AspNetUserRoles] ([UserId], [RoleId]) VALUES (N'9ce84dc8-b263-44b2-8104-604de18c51da', N'b750fcb9-71f0-4434-a37e-1c3e0ab9461b')
INSERT [dbo].[AspNetUserRoles] ([UserId], [RoleId]) VALUES (N'9feae18c-6e8c-46fe-9d32-76e59a80cf35', N'b750fcb9-71f0-4434-a37e-1c3e0ab9461b')
GO
INSERT [dbo].[AspNetUsers] ([Id], [UserName], [NormalizedUserName], [Email], [NormalizedEmail], [EmailConfirmed], [PasswordHash], [SecurityStamp], [ConcurrencyStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnd], [LockoutEnabled], [AccessFailedCount], [DOB], [DelTime], [Name], [Note], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn], [GenderId], [RoleId], [IsLocked]) VALUES (N'147df890-1c7c-4fc5-a78b-0262e832f25c', N'test3@gmail.com', N'TEST3@GMAIL.COM', N'test3@gmail.com', N'TEST3@GMAIL.COM', 1, N'AQAAAAIAAYagAAAAEOWg6DpLlEex7tDZ+s+bRTk1cWpuETbV7+JAVI1uzvrxrvb8o67YVt+uYWm+vOgYKw==', N'BX6KDT4BRYJ4U22ISEOLBIOKVEGGI4FO', N'9ce52d95-5a2b-4631-83bf-62558c20f0c3', N'12312312312', 1, 0, NULL, 1, 0, CAST(N'2024-10-16' AS Date), CAST(N'2024-10-19T19:07:00.9522821' AS DateTime2), N'test3', NULL, NULL, CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2), N'8788c5e7-1463-4215-99fe-8701d5e83199', CAST(N'2024-10-07T15:05:08.0913994' AS DateTime2), 26, N'b750fcb9-71f0-4434-a37e-1c3e0ab9461b', NULL)
INSERT [dbo].[AspNetUsers] ([Id], [UserName], [NormalizedUserName], [Email], [NormalizedEmail], [EmailConfirmed], [PasswordHash], [SecurityStamp], [ConcurrencyStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnd], [LockoutEnabled], [AccessFailedCount], [DOB], [DelTime], [Name], [Note], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn], [GenderId], [RoleId], [IsLocked]) VALUES (N'1f70a729-996a-45de-b002-0e2b62ab2d8c', N'321@gmail.com', N'321@GMAIL.COM', N'321@gmail.com', N'321@GMAIL.COM', 1, N'AQAAAAIAAYagAAAAELCK+5ks4yN4xBv2MWdHtIoW7OfldUNXDdjyP/vHvFwHT5i/AhBY11nHTleHfzx36g==', N'4A5EP4JZUIQE5UDEMI4BGNJ7OBRNLE55', N'ec617fdb-bb8d-4233-8fc4-a5943ffa1e1d', N'0968444503', 1, 0, NULL, 1, 0, CAST(N'2024-09-18' AS Date), NULL, N'321', NULL, NULL, CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-16T14:58:30.3618987' AS DateTime2), 27, N'b750fcb9-71f0-4434-a37e-1c3e0ab9461b', NULL)
INSERT [dbo].[AspNetUsers] ([Id], [UserName], [NormalizedUserName], [Email], [NormalizedEmail], [EmailConfirmed], [PasswordHash], [SecurityStamp], [ConcurrencyStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnd], [LockoutEnabled], [AccessFailedCount], [DOB], [DelTime], [Name], [Note], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn], [GenderId], [RoleId], [IsLocked]) VALUES (N'2744be36-c5f4-442e-bcf3-5d7f59f5f139', N'hehe@gmail.com', N'HEHE@GMAIL.COM', N'hehe@gmail.com', N'HEHE@GMAIL.COM', 0, N'AQAAAAIAAYagAAAAELsCBH7KpbQ+F3ETdnfkcIR87AInimWsM8s016Xmgf7+lWtwEXvRX/qjCs0bSa0OPA==', N'VDXWVAGYPWY2TJHA3FA7UTHBXJUHUXHT', N'08757159-6c7e-411d-836c-f24fc89421fa', NULL, 0, 0, NULL, 1, 0, CAST(N'2024-09-12' AS Date), NULL, N'hehe', NULL, NULL, CAST(N'2024-09-14T20:01:31.2729762' AS DateTime2), NULL, NULL, 27, N'70ea0da2-45f4-44bc-809d-1becc2198498', NULL)
INSERT [dbo].[AspNetUsers] ([Id], [UserName], [NormalizedUserName], [Email], [NormalizedEmail], [EmailConfirmed], [PasswordHash], [SecurityStamp], [ConcurrencyStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnd], [LockoutEnabled], [AccessFailedCount], [DOB], [DelTime], [Name], [Note], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn], [GenderId], [RoleId], [IsLocked]) VALUES (N'3a55e370-2d81-4506-96fe-e6c614ed44e8', N'sssssssss@gmail.com', N'SSSSSSSSS@GMAIL.COM', N'sssssssss@gmail.com', N'SSSSSSSSS@GMAIL.COM', 1, N'AQAAAAIAAYagAAAAEIdWOD/zZhni5OMhhau/TBj4zR8GgyiccbV7kXKQ8P/vZ5Erm5BYWn+wEDx7TzH5EQ==', N'346PGSE7WS4ALNEWMRAVQXRRZCVFYYW6', N'777a5644-7dbb-4ca1-bfac-85cb39996704', N'213123123', 1, 0, NULL, 1, 0, CAST(N'2024-10-23' AS Date), NULL, N'sssss', NULL, N'147df890-1c7c-4fc5-a78b-0262e832f25c', CAST(N'2024-10-06T22:02:39.0488035' AS DateTime2), NULL, NULL, 26, N'70ea0da2-45f4-44bc-809d-1becc2198498', NULL)
INSERT [dbo].[AspNetUsers] ([Id], [UserName], [NormalizedUserName], [Email], [NormalizedEmail], [EmailConfirmed], [PasswordHash], [SecurityStamp], [ConcurrencyStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnd], [LockoutEnabled], [AccessFailedCount], [DOB], [DelTime], [Name], [Note], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn], [GenderId], [RoleId], [IsLocked]) VALUES (N'8788c5e7-1463-4215-99fe-8701d5e83199', N'd@gmail.com', N'D@GMAIL.COM', N'd@gmail.com', N'D@GMAIL.COM', 0, N'AQAAAAIAAYagAAAAEG5bGbF2qME5xlU3CaiTvE8MR12azOQwPwgbjGwVlfDQgCF0yZVZHdb7by9tF3XfVg==', N'VHWZQQTH2OJDF3JLSP2APE4FSDIIQOWG', N'21d4109e-5cdd-4dfb-a4fb-80d851280fb8', NULL, 0, 0, NULL, 1, 0, CAST(N'2024-10-11' AS Date), NULL, N'ddddd', NULL, NULL, CAST(N'2024-10-07T14:46:15.0944016' AS DateTime2), NULL, NULL, 26, N'70ea0da2-45f4-44bc-809d-1becc2198498', 0)
INSERT [dbo].[AspNetUsers] ([Id], [UserName], [NormalizedUserName], [Email], [NormalizedEmail], [EmailConfirmed], [PasswordHash], [SecurityStamp], [ConcurrencyStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnd], [LockoutEnabled], [AccessFailedCount], [DOB], [DelTime], [Name], [Note], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn], [GenderId], [RoleId], [IsLocked]) VALUES (N'9ce84dc8-b263-44b2-8104-604de18c51da', N'aaa@gmail.com', N'AAA@GMAIL.COM', N'aaa@gmail.com', N'AAA@GMAIL.COM', 1, N'AQAAAAIAAYagAAAAEDKtEdW5j2oHTW67F7q2+Dsjlmy/66YEqCC+VC/TCp4N4dBT65/haT7QzwFUlFWH0A==', N'QIIC5H7WE6NSA6TXSX6DXZFGSJROYXJ4', N'f638a062-16ef-4415-96a9-bb61c9a72ec1', N'21312321312', 1, 0, NULL, 1, 0, CAST(N'2024-10-17' AS Date), NULL, N'aaa12312', NULL, NULL, CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2), N'147df890-1c7c-4fc5-a78b-0262e832f25c', CAST(N'2024-10-06T21:53:28.7980692' AS DateTime2), 27, N'b750fcb9-71f0-4434-a37e-1c3e0ab9461b', NULL)
INSERT [dbo].[AspNetUsers] ([Id], [UserName], [NormalizedUserName], [Email], [NormalizedEmail], [EmailConfirmed], [PasswordHash], [SecurityStamp], [ConcurrencyStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnd], [LockoutEnabled], [AccessFailedCount], [DOB], [DelTime], [Name], [Note], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn], [GenderId], [RoleId], [IsLocked]) VALUES (N'9feae18c-6e8c-46fe-9d32-76e59a80cf35', N'qwe@gmail.com', N'QWE@GMAIL.COM', N'qwe@gmail.com', N'QWE@GMAIL.COM', 1, N'AQAAAAIAAYagAAAAEF+Wz1n6Z0ub43eKLg2aLBOJ+Bqemc6MVkuh5Wf6OJw50aKeQGDNVmGzP4IWxhrb4w==', N'KACKZNSYWLKVMDLLEEY5UHWXGS7PIIGK', N'f5b430d6-3a0d-4119-8118-8c823c358cc5', N'123123123', 1, 0, NULL, 1, 0, CAST(N'2024-10-18' AS Date), NULL, N'qwe', NULL, NULL, CAST(N'2024-10-16T15:18:01.4198621' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-16T16:12:13.1948299' AS DateTime2), 26, N'70ea0da2-45f4-44bc-809d-1becc2198498', NULL)
INSERT [dbo].[AspNetUsers] ([Id], [UserName], [NormalizedUserName], [Email], [NormalizedEmail], [EmailConfirmed], [PasswordHash], [SecurityStamp], [ConcurrencyStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnd], [LockoutEnabled], [AccessFailedCount], [DOB], [DelTime], [Name], [Note], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn], [GenderId], [RoleId], [IsLocked]) VALUES (N'abd2e740-5be8-4ede-8e8a-54dddacbe04c', N'test@gmail.com', N'TEST@GMAIL.COM', N'test@gmail.com', N'TEST@GMAIL.COM', 1, N'AQAAAAIAAYagAAAAEO2CGi69KEfqfnVT8uRpdZO5IaHtYagyvFwdzZzV6XCY+oAk335YpBRILVeCEkmqMw==', N'BYIPKFS3UTYDNL672GBE2ZB7CIPJ7UZW', N'5acbc010-5677-43c2-80d8-ddaa68b10b83', N'1111111111111', 1, 0, NULL, 1, 0, CAST(N'2024-09-09' AS Date), NULL, N'test', NULL, NULL, CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2), NULL, NULL, 27, N'27c5880b-5900-4a54-b9ae-7de5f24c73f1', NULL)
INSERT [dbo].[AspNetUsers] ([Id], [UserName], [NormalizedUserName], [Email], [NormalizedEmail], [EmailConfirmed], [PasswordHash], [SecurityStamp], [ConcurrencyStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnd], [LockoutEnabled], [AccessFailedCount], [DOB], [DelTime], [Name], [Note], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn], [GenderId], [RoleId], [IsLocked]) VALUES (N'cad322e8-dcc1-4acc-adb9-b74a85420521', N'test2@gmail.com', N'TEST2@GMAIL.COM', N'test2@gmail.com', N'TEST2@GMAIL.COM', 1, N'AQAAAAIAAYagAAAAEAOqcJ4ZJ5Ay6yr5iLM51RvVoFbu4JzNqm+wsK6lY6pgh+r1E5Sz67U/qywSk4RJkw==', N'RX2YXLY5BRC5HFMNSRIOOLWJUTYPYVHC', N'2085bb62-44f0-4bc4-889b-8bccf692601a', N'12345674562', 1, 0, NULL, 1, 0, CAST(N'2024-10-22' AS Date), NULL, N'test2', NULL, NULL, CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2), NULL, NULL, 27, N'70ea0da2-45f4-44bc-809d-1becc2198498', NULL)
INSERT [dbo].[AspNetUsers] ([Id], [UserName], [NormalizedUserName], [Email], [NormalizedEmail], [EmailConfirmed], [PasswordHash], [SecurityStamp], [ConcurrencyStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnd], [LockoutEnabled], [AccessFailedCount], [DOB], [DelTime], [Name], [Note], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn], [GenderId], [RoleId], [IsLocked]) VALUES (N'd904d1b5-0a2c-4c39-9804-27b42f658ece', N'123@gmail.com', N'123@GMAIL.COM', N'123@gmail.com', N'123@GMAIL.COM', 0, N'AQAAAAIAAYagAAAAEPhw+EvjKTS2rRIR6vSw9R6tpK8Woe9bJkwwkG474YiO9Z2EQXHusuIUowFnx3V+EQ==', N'3AVUJKBJCWWRFMIGYKZOYMTNS2CILJNQ', N'6e01e45c-d4b3-4c2d-9979-44204f2d334e', NULL, 0, 0, NULL, 1, 0, CAST(N'2024-09-12' AS Date), NULL, N'123', NULL, NULL, CAST(N'2024-09-11T15:26:49.2661572' AS DateTime2), NULL, NULL, 26, N'b750fcb9-71f0-4434-a37e-1c3e0ab9461b', NULL)
GO
SET IDENTITY_INSERT [dbo].[AuditTrails] ON 

INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1421, N'Create', N'Ticket', N'Ticket', CAST(N'2024-10-10T20:03:08.1663616' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"AssignedOn":null,"AssignedToId":null,"Attachment":null,"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-10T20:03:08.1284189+07:00","DelTime":null,"Description":"123","ModifiedById":null,"ModifiedOn":null,"Note":null,"PriorityId":23,"StatusId":17,"SubCategoryId":2,"Title":"123"}', NULL, NULL, NULL, N'{"Id":-2147482647}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1422, N'Create', N'TicketResolution', N'TicketResolution', CAST(N'2024-10-10T20:04:48.2793458' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-10T20:04:48.1972681+07:00","DelTime":null,"Description":"Assign to user test3","ModifiedById":null,"ModifiedOn":null,"Note":null,"StatusId":17,"TicketId":12}', NULL, NULL, NULL, N'{"Id":-2147482647}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1423, N'Update', N'Ticket', N'Ticket', CAST(N'2024-10-10T20:04:48.3548864' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"AssignedOn":"2024-10-10T20:04:48.1909123+07:00","AssignedToId":"147df890-1c7c-4fc5-a78b-0262e832f25c","Attachment":null,"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-10T20:03:08.1284189","DelTime":null,"Description":"123","ModifiedById":null,"ModifiedOn":null,"Note":null,"PriorityId":23,"StatusId":17,"SubCategoryId":2,"Title":"123"}', N'["AssignedOn","AssignedToId","Attachment","CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","PriorityId","StatusId","SubCategoryId","Title"]', NULL, NULL, N'{"Id":12}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1424, N'Create', N'TicketResolution', N'TicketResolution', CAST(N'2024-10-10T20:06:06.4892745' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-10T20:06:06.4870136+07:00","DelTime":null,"Description":"done","ModifiedById":null,"ModifiedOn":null,"Note":null,"StatusId":19,"TicketId":12}', NULL, NULL, NULL, N'{"Id":-2147482646}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1425, N'Update', N'Ticket', N'Ticket', CAST(N'2024-10-10T20:06:06.4896893' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"AssignedOn":"2024-10-10T20:04:48.1909123","AssignedToId":"147df890-1c7c-4fc5-a78b-0262e832f25c","Attachment":null,"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-10T20:03:08.1284189","DelTime":null,"Description":"123","ModifiedById":null,"ModifiedOn":null,"Note":null,"PriorityId":23,"StatusId":19,"SubCategoryId":2,"Title":"123"}', N'["AssignedOn","AssignedToId","Attachment","CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","PriorityId","StatusId","SubCategoryId","Title"]', NULL, NULL, N'{"Id":12}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1426, N'Update', N'Ticket', N'Ticket', CAST(N'2024-10-10T20:06:24.8041200' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"AssignedOn":null,"AssignedToId":null,"Attachment":null,"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-10T20:03:08","DelTime":null,"Description":"123","ModifiedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","ModifiedOn":"2024-10-10T20:06:24.8036662+07:00","Note":null,"PriorityId":23,"StatusId":19,"SubCategoryId":3,"Title":"123"}', N'["AssignedOn","AssignedToId","Attachment","CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","PriorityId","StatusId","SubCategoryId","Title"]', NULL, NULL, N'{"Id":12}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1427, N'Update', N'Ticket', N'Ticket', CAST(N'2024-10-10T20:06:37.0255552' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"AssignedOn":null,"AssignedToId":null,"Attachment":null,"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-10T20:03:08","DelTime":"2024-10-10T20:06:37.0253133+07:00","Description":"123","ModifiedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","ModifiedOn":"2024-10-10T20:06:24.8036662","Note":null,"PriorityId":23,"StatusId":19,"SubCategoryId":3,"Title":"123"}', N'["AssignedOn","AssignedToId","Attachment","CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","PriorityId","StatusId","SubCategoryId","Title"]', NULL, NULL, N'{"Id":12}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1428, N'Create', N'Ticket', N'Ticket', CAST(N'2024-10-10T20:07:47.7378041' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"AssignedOn":null,"AssignedToId":null,"Attachment":null,"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-10T20:07:47.7007064+07:00","DelTime":null,"Description":"123","ModifiedById":null,"ModifiedOn":null,"Note":null,"PriorityId":22,"StatusId":16,"SubCategoryId":2,"Title":"123"}', NULL, NULL, NULL, N'{"Id":-2147482647}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1429, N'Create', N'TicketResolution', N'TicketResolution', CAST(N'2024-10-10T20:08:02.9495332' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-10T20:08:02.9161959+07:00","DelTime":null,"Description":"Assign to user test3","ModifiedById":null,"ModifiedOn":null,"Note":null,"StatusId":17,"TicketId":13}', NULL, NULL, NULL, N'{"Id":-2147482647}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1430, N'Update', N'Ticket', N'Ticket', CAST(N'2024-10-10T20:08:02.9500883' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"AssignedOn":"2024-10-10T20:08:02.9158624+07:00","AssignedToId":"147df890-1c7c-4fc5-a78b-0262e832f25c","Attachment":null,"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-10T20:07:47.7007064","DelTime":null,"Description":"123","ModifiedById":null,"ModifiedOn":null,"Note":null,"PriorityId":22,"StatusId":17,"SubCategoryId":2,"Title":"123"}', N'["AssignedOn","AssignedToId","Attachment","CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","PriorityId","StatusId","SubCategoryId","Title"]', NULL, NULL, N'{"Id":13}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1431, N'Create', N'Ticket', N'Ticket', CAST(N'2024-10-10T22:12:45.3486635' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"AssignedOn":null,"AssignedToId":null,"Attachment":null,"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-10T22:12:45.219105+07:00","DelTime":null,"Description":"123","ModifiedById":null,"ModifiedOn":null,"Note":null,"PriorityId":21,"StatusId":15,"SubCategoryId":2,"Title":"123"}', NULL, NULL, NULL, N'{"Id":-2147482647}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1454, N'Update', N'Ticket', N'Ticket', CAST(N'2024-10-11T22:39:12.9450968' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"AssignedOn":null,"AssignedToId":null,"Attachment":null,"CreatedById":"d904d1b5-0a2c-4c39-9804-27b42f658ece","CreatedOn":"2024-09-11T15:37:26","DelTime":null,"Description":"hehe1","ModifiedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","ModifiedOn":"2024-10-10T19:57:37.8144526","Note":null,"PriorityId":23,"StatusId":15,"SubCategoryId":3,"Title":"hehe1"}', N'["AssignedOn","AssignedToId","Attachment","CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","PriorityId","StatusId","SubCategoryId","Title"]', NULL, NULL, N'{"Id":7}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1455, N'Update', N'Ticket', N'Ticket', CAST(N'2024-10-11T22:39:13.0368889' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"AssignedOn":null,"AssignedToId":null,"Attachment":null,"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-09-15T14:17:06.0541708","DelTime":null,"Description":"hehe2","ModifiedById":null,"ModifiedOn":null,"Note":null,"PriorityId":23,"StatusId":15,"SubCategoryId":2,"Title":"hehe2"}', N'["AssignedOn","AssignedToId","Attachment","CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","PriorityId","StatusId","SubCategoryId","Title"]', NULL, NULL, N'{"Id":8}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1456, N'Update', N'Ticket', N'Ticket', CAST(N'2024-10-11T22:39:13.0377466' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"AssignedOn":null,"AssignedToId":null,"Attachment":null,"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-09-22T17:01:01.231803","DelTime":null,"Description":"hehe3","ModifiedById":null,"ModifiedOn":null,"Note":null,"PriorityId":23,"StatusId":15,"SubCategoryId":2,"Title":"hehe3"}', N'["AssignedOn","AssignedToId","Attachment","CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","PriorityId","StatusId","SubCategoryId","Title"]', NULL, NULL, N'{"Id":9}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1457, N'Update', N'Ticket', N'Ticket', CAST(N'2024-10-11T22:39:13.0378272' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"AssignedOn":"2024-10-10T20:08:02.9158624","AssignedToId":"147df890-1c7c-4fc5-a78b-0262e832f25c","Attachment":null,"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-10T20:07:47.7007064","DelTime":null,"Description":"123","ModifiedById":null,"ModifiedOn":null,"Note":null,"PriorityId":21,"StatusId":17,"SubCategoryId":2,"Title":"123"}', N'["AssignedOn","AssignedToId","Attachment","CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","PriorityId","StatusId","SubCategoryId","Title"]', NULL, NULL, N'{"Id":13}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1458, N'Update', N'Ticket', N'Ticket', CAST(N'2024-10-11T22:39:13.0378821' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"AssignedOn":null,"AssignedToId":null,"Attachment":null,"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-10T22:12:45.219105","DelTime":null,"Description":"123","ModifiedById":null,"ModifiedOn":null,"Note":null,"PriorityId":21,"StatusId":15,"SubCategoryId":2,"Title":"123"}', N'["AssignedOn","AssignedToId","Attachment","CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","PriorityId","StatusId","SubCategoryId","Title"]', NULL, NULL, N'{"Id":14}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1459, N'Update', N'TicketResolution', N'TicketResolution', CAST(N'2024-10-11T23:12:27.9444583' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-10T20:04:48.1972681","DelTime":"2024-10-11T23:12:27.9252896+07:00","Description":"Assign to user test3","ModifiedById":null,"ModifiedOn":null,"Note":null,"StatusId":17,"TicketId":12}', N'["CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","StatusId","TicketId"]', NULL, NULL, N'{"Id":1049}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1460, N'Update', N'TicketResolution', N'TicketResolution', CAST(N'2024-10-11T23:12:28.0479770' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-10T20:06:06.4870136","DelTime":"2024-10-11T23:12:27.9254762+07:00","Description":"done","ModifiedById":null,"ModifiedOn":null,"Note":null,"StatusId":19,"TicketId":12}', N'["CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","StatusId","TicketId"]', NULL, NULL, N'{"Id":1050}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1461, N'Update', N'Ticket', N'Ticket', CAST(N'2024-10-11T23:12:28.0497104' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"AssignedOn":null,"AssignedToId":null,"Attachment":null,"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-10T20:03:08","DelTime":"2024-10-11T23:12:27.9254789+07:00","Description":"123","ModifiedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","ModifiedOn":"2024-10-10T20:06:24.8036662","Note":null,"PriorityId":21,"StatusId":19,"SubCategoryId":3,"Title":"123"}', N'["AssignedOn","AssignedToId","Attachment","CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","PriorityId","StatusId","SubCategoryId","Title"]', NULL, NULL, N'{"Id":12}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1462, N'Update', N'Ticket', N'Ticket', CAST(N'2024-10-11T23:12:30.8489259' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"AssignedOn":null,"AssignedToId":null,"Attachment":null,"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-09-15T14:17:06.0541708","DelTime":"2024-10-11T23:12:30.8485276+07:00","Description":"hehe2","ModifiedById":null,"ModifiedOn":null,"Note":null,"PriorityId":23,"StatusId":15,"SubCategoryId":2,"Title":"hehe2"}', N'["AssignedOn","AssignedToId","Attachment","CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","PriorityId","StatusId","SubCategoryId","Title"]', NULL, NULL, N'{"Id":8}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1463, N'Update', N'TicketResolution', N'TicketResolution', CAST(N'2024-10-11T23:12:33.3304678' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-10T20:08:02.9161959","DelTime":"2024-10-11T23:12:33.3303048+07:00","Description":"Assign to user test3","ModifiedById":null,"ModifiedOn":null,"Note":null,"StatusId":17,"TicketId":13}', N'["CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","StatusId","TicketId"]', NULL, NULL, N'{"Id":1051}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1464, N'Update', N'Ticket', N'Ticket', CAST(N'2024-10-11T23:12:33.3305903' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"AssignedOn":"2024-10-10T20:08:02.9158624","AssignedToId":"147df890-1c7c-4fc5-a78b-0262e832f25c","Attachment":null,"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-10T20:07:47.7007064","DelTime":"2024-10-11T23:12:33.3303371+07:00","Description":"123","ModifiedById":null,"ModifiedOn":null,"Note":null,"PriorityId":21,"StatusId":17,"SubCategoryId":2,"Title":"123"}', N'["AssignedOn","AssignedToId","Attachment","CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","PriorityId","StatusId","SubCategoryId","Title"]', NULL, NULL, N'{"Id":13}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1465, N'Update', N'Ticket', N'Ticket', CAST(N'2024-10-11T23:17:33.3919187' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"AssignedOn":null,"AssignedToId":null,"Attachment":null,"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-10T22:12:45.219105","DelTime":"2024-10-11T23:17:33.3917858+07:00","Description":"123","ModifiedById":null,"ModifiedOn":null,"Note":null,"PriorityId":21,"StatusId":15,"SubCategoryId":2,"Title":"123"}', N'["AssignedOn","AssignedToId","Attachment","CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","PriorityId","StatusId","SubCategoryId","Title"]', NULL, NULL, N'{"Id":14}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1466, N'Update', N'Ticket', N'Ticket', CAST(N'2024-10-11T23:17:54.3157684' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"AssignedOn":null,"AssignedToId":null,"Attachment":null,"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-10T16:49:06","DelTime":"2024-10-11T23:17:54.3155793+07:00","Description":"ewq","ModifiedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","ModifiedOn":"2024-10-10T16:49:30.121169","Note":null,"PriorityId":21,"StatusId":15,"SubCategoryId":2,"Title":"ewq"}', N'["AssignedOn","AssignedToId","Attachment","CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","PriorityId","StatusId","SubCategoryId","Title"]', NULL, NULL, N'{"Id":11}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1467, N'Update', N'Ticket', N'Ticket', CAST(N'2024-10-11T23:17:58.2833809' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"AssignedOn":null,"AssignedToId":null,"Attachment":null,"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-10T16:49:06","DelTime":"2024-10-11T23:17:58.2833042+07:00","Description":"ewq","ModifiedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","ModifiedOn":"2024-10-10T16:49:30.121169","Note":null,"PriorityId":21,"StatusId":15,"SubCategoryId":2,"Title":"ewq"}', N'["AssignedOn","AssignedToId","Attachment","CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","PriorityId","StatusId","SubCategoryId","Title"]', NULL, NULL, N'{"Id":11}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1468, N'Update', N'TicketResolution', N'TicketResolution', CAST(N'2024-10-11T23:18:03.8947798' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"d904d1b5-0a2c-4c39-9804-27b42f658ece","CreatedOn":"2024-09-11T15:37:39.652314","DelTime":"2024-10-11T23:18:03.894656+07:00","Description":"Assign to user 123","ModifiedById":null,"ModifiedOn":null,"Note":null,"StatusId":17,"TicketId":7}', N'["CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","StatusId","TicketId"]', NULL, NULL, N'{"Id":1026}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1469, N'Update', N'TicketResolution', N'TicketResolution', CAST(N'2024-10-11T23:18:03.8949455' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"d904d1b5-0a2c-4c39-9804-27b42f658ece","CreatedOn":"2024-09-11T15:37:57.9349872","DelTime":"2024-10-11T23:18:03.8946647+07:00","Description":"done","ModifiedById":null,"ModifiedOn":null,"Note":null,"StatusId":19,"TicketId":7}', N'["CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","StatusId","TicketId"]', NULL, NULL, N'{"Id":1027}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1470, N'Update', N'TicketResolution', N'TicketResolution', CAST(N'2024-10-11T23:18:03.8949767' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-10T16:49:54.1978907","DelTime":"2024-10-11T23:18:03.894665+07:00","Description":"Assign to user test3","ModifiedById":null,"ModifiedOn":null,"Note":null,"StatusId":17,"TicketId":7}', N'["CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","StatusId","TicketId"]', NULL, NULL, N'{"Id":1043}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1471, N'Update', N'TicketResolution', N'TicketResolution', CAST(N'2024-10-11T23:18:03.8949958' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-10T16:50:04.5762448","DelTime":"2024-10-11T23:18:03.8946652+07:00","Description":"Assign to user 321","ModifiedById":null,"ModifiedOn":null,"Note":null,"StatusId":17,"TicketId":7}', N'["CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","StatusId","TicketId"]', NULL, NULL, N'{"Id":1044}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1472, N'Update', N'TicketResolution', N'TicketResolution', CAST(N'2024-10-11T23:18:03.8950426' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-10T19:56:32.414263","DelTime":"2024-10-11T23:18:03.8946655+07:00","Description":"Assign to user test3","ModifiedById":null,"ModifiedOn":null,"Note":null,"StatusId":17,"TicketId":7}', N'["CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","StatusId","TicketId"]', NULL, NULL, N'{"Id":1045}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1473, N'Update', N'TicketResolution', N'TicketResolution', CAST(N'2024-10-11T23:18:03.8950630' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-10T19:56:54.7201672","DelTime":"2024-10-11T23:18:03.8946657+07:00","Description":"done","ModifiedById":null,"ModifiedOn":null,"Note":null,"StatusId":19,"TicketId":7}', N'["CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","StatusId","TicketId"]', NULL, NULL, N'{"Id":1046}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1474, N'Update', N'TicketResolution', N'TicketResolution', CAST(N'2024-10-11T23:18:03.8950798' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-10T19:57:13.8657486","DelTime":"2024-10-11T23:18:03.894666+07:00","Description":"Closed by owner","ModifiedById":null,"ModifiedOn":null,"Note":null,"StatusId":18,"TicketId":7}', N'["CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","StatusId","TicketId"]', NULL, NULL, N'{"Id":1047}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1475, N'Update', N'TicketResolution', N'TicketResolution', CAST(N'2024-10-11T23:18:03.8950968' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-10T19:57:18.047448","DelTime":"2024-10-11T23:18:03.8946662+07:00","Description":"Re-open by owner","ModifiedById":null,"ModifiedOn":null,"Note":null,"StatusId":15,"TicketId":7}', N'["CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","StatusId","TicketId"]', NULL, NULL, N'{"Id":1048}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1476, N'Update', N'Ticket', N'Ticket', CAST(N'2024-10-11T23:18:03.8951152' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"AssignedOn":null,"AssignedToId":null,"Attachment":null,"CreatedById":"d904d1b5-0a2c-4c39-9804-27b42f658ece","CreatedOn":"2024-09-11T15:37:26","DelTime":"2024-10-11T23:18:03.8946669+07:00","Description":"hehe1","ModifiedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","ModifiedOn":"2024-10-10T19:57:37.8144526","Note":null,"PriorityId":23,"StatusId":15,"SubCategoryId":3,"Title":"hehe1"}', N'["AssignedOn","AssignedToId","Attachment","CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","PriorityId","StatusId","SubCategoryId","Title"]', NULL, NULL, N'{"Id":7}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1477, N'Update', N'Ticket', N'Ticket', CAST(N'2024-10-11T23:22:08.7574152' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"AssignedOn":null,"AssignedToId":null,"Attachment":null,"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-09-22T17:01:01.231803","DelTime":"2024-10-11T23:22:08.744859+07:00","Description":"hehe3","ModifiedById":null,"ModifiedOn":null,"Note":null,"PriorityId":23,"StatusId":15,"SubCategoryId":2,"Title":"hehe3"}', N'["AssignedOn","AssignedToId","Attachment","CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","PriorityId","StatusId","SubCategoryId","Title"]', NULL, NULL, N'{"Id":9}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1478, N'Update', N'Comment', N'Comment', CAST(N'2024-10-11T23:22:15.2759021' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"d904d1b5-0a2c-4c39-9804-27b42f658ece","CreatedOn":"2024-09-11T15:37:02.5017145","DelTime":"2024-10-11T23:22:15.2547286+07:00","Description":"hehe","ModifiedById":null,"ModifiedOn":null,"Note":null,"TicketId":6}', N'["CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","TicketId"]', NULL, NULL, N'{"Id":5}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1479, N'Update', N'TicketResolution', N'TicketResolution', CAST(N'2024-10-11T23:22:15.2768356' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"d904d1b5-0a2c-4c39-9804-27b42f658ece","CreatedOn":"2024-09-11T15:38:04.9801655","DelTime":"2024-10-11T23:22:15.2680432+07:00","Description":"Closed by owner","ModifiedById":null,"ModifiedOn":null,"Note":null,"StatusId":18,"TicketId":6}', N'["CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","StatusId","TicketId"]', NULL, NULL, N'{"Id":1028}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1480, N'Update', N'TicketResolution', N'TicketResolution', CAST(N'2024-10-11T23:22:15.2769156' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-08T17:54:25.0361919","DelTime":"2024-10-11T23:22:15.2681298+07:00","Description":"Re-open by owner","ModifiedById":null,"ModifiedOn":null,"Note":null,"StatusId":15,"TicketId":6}', N'["CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","StatusId","TicketId"]', NULL, NULL, N'{"Id":1029}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1481, N'Update', N'TicketResolution', N'TicketResolution', CAST(N'2024-10-11T23:22:15.2769545' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-08T17:57:57.6589232","DelTime":"2024-10-11T23:22:15.2681318+07:00","Description":"Closed by owner","ModifiedById":null,"ModifiedOn":null,"Note":null,"StatusId":18,"TicketId":6}', N'["CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","StatusId","TicketId"]', NULL, NULL, N'{"Id":1030}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1482, N'Update', N'TicketResolution', N'TicketResolution', CAST(N'2024-10-11T23:22:15.2769971' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-08T17:58:02.361586","DelTime":"2024-10-11T23:22:15.2681342+07:00","Description":"Re-open by owner","ModifiedById":null,"ModifiedOn":null,"Note":null,"StatusId":15,"TicketId":6}', N'["CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","StatusId","TicketId"]', NULL, NULL, N'{"Id":1031}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1483, N'Update', N'TicketResolution', N'TicketResolution', CAST(N'2024-10-11T23:22:15.2770412' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-09T08:59:02.062937","DelTime":"2024-10-11T23:22:15.2681357+07:00","Description":"done","ModifiedById":null,"ModifiedOn":null,"Note":null,"StatusId":19,"TicketId":6}', N'["CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","StatusId","TicketId"]', NULL, NULL, N'{"Id":1032}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1484, N'Update', N'TicketResolution', N'TicketResolution', CAST(N'2024-10-11T23:22:15.2770764' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-09T08:59:37.5179152","DelTime":"2024-10-11T23:22:15.2681372+07:00","Description":"Assign to user test","ModifiedById":null,"ModifiedOn":null,"Note":null,"StatusId":17,"TicketId":6}', N'["CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","StatusId","TicketId"]', NULL, NULL, N'{"Id":1033}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1485, N'Update', N'TicketResolution', N'TicketResolution', CAST(N'2024-10-11T23:22:15.2771091' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-09T08:59:54.2957598","DelTime":"2024-10-11T23:22:15.2681391+07:00","Description":"Closed by owner","ModifiedById":null,"ModifiedOn":null,"Note":null,"StatusId":18,"TicketId":6}', N'["CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","StatusId","TicketId"]', NULL, NULL, N'{"Id":1034}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1486, N'Update', N'TicketResolution', N'TicketResolution', CAST(N'2024-10-11T23:22:15.2771465' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-09T08:59:58.1839417","DelTime":"2024-10-11T23:22:15.2681413+07:00","Description":"Re-open by owner","ModifiedById":null,"ModifiedOn":null,"Note":null,"StatusId":15,"TicketId":6}', N'["CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","StatusId","TicketId"]', NULL, NULL, N'{"Id":1035}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1487, N'Update', N'TicketResolution', N'TicketResolution', CAST(N'2024-10-11T23:22:15.2771843' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-09T09:00:14.553903","DelTime":"2024-10-11T23:22:15.2681434+07:00","Description":"Closed by owner","ModifiedById":null,"ModifiedOn":null,"Note":null,"StatusId":18,"TicketId":6}', N'["CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","StatusId","TicketId"]', NULL, NULL, N'{"Id":1036}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1488, N'Update', N'TicketResolution', N'TicketResolution', CAST(N'2024-10-11T23:22:15.2772444' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-09T09:00:16.2138484","DelTime":"2024-10-11T23:22:15.2681459+07:00","Description":"Re-open by owner","ModifiedById":null,"ModifiedOn":null,"Note":null,"StatusId":15,"TicketId":6}', N'["CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","StatusId","TicketId"]', NULL, NULL, N'{"Id":1037}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1489, N'Update', N'TicketResolution', N'TicketResolution', CAST(N'2024-10-11T23:22:15.2772822' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-09T09:02:27.7774626","DelTime":"2024-10-11T23:22:15.2681483+07:00","Description":"Closed by owner","ModifiedById":null,"ModifiedOn":null,"Note":null,"StatusId":18,"TicketId":6}', N'["CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","StatusId","TicketId"]', NULL, NULL, N'{"Id":1038}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1490, N'Update', N'TicketResolution', N'TicketResolution', CAST(N'2024-10-11T23:22:15.2773147' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-09T09:02:35.9350625","DelTime":"2024-10-11T23:22:15.2681498+07:00","Description":"Re-open by owner","ModifiedById":null,"ModifiedOn":null,"Note":null,"StatusId":15,"TicketId":6}', N'["CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","StatusId","TicketId"]', NULL, NULL, N'{"Id":1039}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1491, N'Update', N'TicketResolution', N'TicketResolution', CAST(N'2024-10-11T23:22:15.2773520' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-10T13:06:17.0961196","DelTime":"2024-10-11T23:22:15.2681593+07:00","Description":"Assign to user test3","ModifiedById":null,"ModifiedOn":null,"Note":null,"StatusId":17,"TicketId":6}', N'["CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","StatusId","TicketId"]', NULL, NULL, N'{"Id":1040}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1492, N'Update', N'TicketResolution', N'TicketResolution', CAST(N'2024-10-11T23:22:15.2773879' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-10T13:06:22.317572","DelTime":"2024-10-11T23:22:15.2681611+07:00","Description":"Assign to user test3","ModifiedById":null,"ModifiedOn":null,"Note":null,"StatusId":17,"TicketId":6}', N'["CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","StatusId","TicketId"]', NULL, NULL, N'{"Id":1041}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1493, N'Update', N'TicketResolution', N'TicketResolution', CAST(N'2024-10-11T23:22:15.2774286' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-10T13:16:55.9194858","DelTime":"2024-10-11T23:22:15.2681628+07:00","Description":"Assign to user sssss","ModifiedById":null,"ModifiedOn":null,"Note":null,"StatusId":17,"TicketId":6}', N'["CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","StatusId","TicketId"]', NULL, NULL, N'{"Id":1042}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1494, N'Update', N'Ticket', N'Ticket', CAST(N'2024-10-11T23:22:15.2774610' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"AssignedOn":"2024-10-10T13:16:55.9147655","AssignedToId":"3a55e370-2d81-4506-96fe-e6c614ed44e8","Attachment":"Ticket_Attachment_20241006_Mau-giay-xac-nhan-thuc-tap.doc","CreatedById":"d904d1b5-0a2c-4c39-9804-27b42f658ece","CreatedOn":"2024-09-11T15:36:54","DelTime":"2024-10-11T23:22:15.2681645+07:00","Description":"hehe","ModifiedById":"147df890-1c7c-4fc5-a78b-0262e832f25c","ModifiedOn":"2024-10-06T21:17:08.4706159","Note":null,"PriorityId":23,"StatusId":17,"SubCategoryId":3,"Title":"hehe312312312"}', N'["AssignedOn","AssignedToId","Attachment","CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","PriorityId","StatusId","SubCategoryId","Title"]', NULL, NULL, N'{"Id":6}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1495, N'Create', N'Ticket', N'Ticket', CAST(N'2024-10-11T23:30:57.6228418' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"AssignedOn":null,"AssignedToId":null,"Attachment":null,"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-11T23:30:57.5927216+07:00","DelTime":null,"Description":"123","ModifiedById":null,"ModifiedOn":null,"Note":null,"PriorityId":21,"StatusId":15,"SubCategoryId":2,"Title":"123"}', NULL, NULL, NULL, N'{"Id":-2147482647}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1496, N'Create', N'TicketResolution', N'TicketResolution', CAST(N'2024-10-11T23:31:12.2200376' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-11T23:31:12.1647472+07:00","DelTime":null,"Description":"done","ModifiedById":null,"ModifiedOn":null,"Note":null,"StatusId":19,"TicketId":15}', NULL, NULL, NULL, N'{"Id":-2147482647}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1497, N'Update', N'Ticket', N'Ticket', CAST(N'2024-10-11T23:31:12.2220822' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"AssignedOn":null,"AssignedToId":null,"Attachment":null,"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-11T23:30:57.5927216","DelTime":null,"Description":"123","ModifiedById":null,"ModifiedOn":null,"Note":null,"PriorityId":21,"StatusId":19,"SubCategoryId":2,"Title":"123"}', N'["AssignedOn","AssignedToId","Attachment","CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","PriorityId","StatusId","SubCategoryId","Title"]', NULL, NULL, N'{"Id":15}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1498, N'Create', N'TicketResolution', N'TicketResolution', CAST(N'2024-10-11T23:31:24.4703610' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-11T23:31:24.4563307+07:00","DelTime":null,"Description":"Assign to user hehe","ModifiedById":null,"ModifiedOn":null,"Note":null,"StatusId":17,"TicketId":15}', NULL, NULL, NULL, N'{"Id":-2147482646}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1499, N'Update', N'Ticket', N'Ticket', CAST(N'2024-10-11T23:31:24.4710912' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"AssignedOn":"2024-10-11T23:31:24.4562536+07:00","AssignedToId":"2744be36-c5f4-442e-bcf3-5d7f59f5f139","Attachment":null,"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-11T23:30:57.5927216","DelTime":null,"Description":"123","ModifiedById":null,"ModifiedOn":null,"Note":null,"PriorityId":21,"StatusId":17,"SubCategoryId":2,"Title":"123"}', N'["AssignedOn","AssignedToId","Attachment","CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","PriorityId","StatusId","SubCategoryId","Title"]', NULL, NULL, N'{"Id":15}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1500, N'Create', N'TicketResolution', N'TicketResolution', CAST(N'2024-10-11T23:31:37.9168378' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-11T23:31:37.9130879+07:00","DelTime":null,"Description":"123","ModifiedById":null,"ModifiedOn":null,"Note":null,"StatusId":16,"TicketId":9}', NULL, NULL, NULL, N'{"Id":-2147482645}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1501, N'Update', N'Ticket', N'Ticket', CAST(N'2024-10-11T23:31:37.9169724' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"AssignedOn":null,"AssignedToId":null,"Attachment":null,"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-09-22T17:01:01.231803","DelTime":null,"Description":"hehe3","ModifiedById":null,"ModifiedOn":null,"Note":null,"PriorityId":23,"StatusId":16,"SubCategoryId":2,"Title":"hehe3"}', N'["AssignedOn","AssignedToId","Attachment","CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","PriorityId","StatusId","SubCategoryId","Title"]', NULL, NULL, N'{"Id":9}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1502, N'Create', N'TicketResolution', N'TicketResolution', CAST(N'2024-10-11T23:31:49.4893734' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-11T23:31:49.48867+07:00","DelTime":null,"Description":"Assign to user test3","ModifiedById":null,"ModifiedOn":null,"Note":null,"StatusId":17,"TicketId":9}', NULL, NULL, NULL, N'{"Id":-2147482644}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1503, N'Update', N'Ticket', N'Ticket', CAST(N'2024-10-11T23:31:49.4896240' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"AssignedOn":"2024-10-11T23:31:49.4886227+07:00","AssignedToId":"147df890-1c7c-4fc5-a78b-0262e832f25c","Attachment":null,"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-09-22T17:01:01.231803","DelTime":null,"Description":"hehe3","ModifiedById":null,"ModifiedOn":null,"Note":null,"PriorityId":23,"StatusId":17,"SubCategoryId":2,"Title":"hehe3"}', N'["AssignedOn","AssignedToId","Attachment","CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","PriorityId","StatusId","SubCategoryId","Title"]', NULL, NULL, N'{"Id":9}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1504, N'Create', N'TicketResolution', N'TicketResolution', CAST(N'2024-10-11T23:31:56.6455126' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-11T23:31:56.6427834+07:00","DelTime":null,"Description":"Closed by owner","ModifiedById":null,"ModifiedOn":null,"Note":null,"StatusId":18,"TicketId":9}', NULL, NULL, NULL, N'{"Id":-2147482643}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1505, N'Update', N'Ticket', N'Ticket', CAST(N'2024-10-11T23:31:56.6456442' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"AssignedOn":"2024-10-11T23:31:49.4886227","AssignedToId":"147df890-1c7c-4fc5-a78b-0262e832f25c","Attachment":null,"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-09-22T17:01:01.231803","DelTime":null,"Description":"hehe3","ModifiedById":null,"ModifiedOn":null,"Note":null,"PriorityId":23,"StatusId":18,"SubCategoryId":2,"Title":"hehe3"}', N'["AssignedOn","AssignedToId","Attachment","CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","PriorityId","StatusId","SubCategoryId","Title"]', NULL, NULL, N'{"Id":9}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1506, N'Update', N'Ticket', N'Ticket', CAST(N'2024-10-11T23:35:34.2815179' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"AssignedOn":"2024-10-10T13:16:55.9147655","AssignedToId":"3a55e370-2d81-4506-96fe-e6c614ed44e8","Attachment":"Ticket_Attachment_20241006_Mau-giay-xac-nhan-thuc-tap.doc","CreatedById":"d904d1b5-0a2c-4c39-9804-27b42f658ece","CreatedOn":"2024-09-11T15:36:54","DelTime":"2024-10-11T23:35:34.2657207+07:00","Description":"hehe","ModifiedById":"147df890-1c7c-4fc5-a78b-0262e832f25c","ModifiedOn":"2024-10-06T21:17:08.4706159","Note":null,"PriorityId":23,"StatusId":17,"SubCategoryId":3,"Title":"hehe312312312"}', N'["AssignedOn","AssignedToId","Attachment","CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","PriorityId","StatusId","SubCategoryId","Title"]', NULL, NULL, N'{"Id":6}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1507, N'Update', N'Ticket', N'Ticket', CAST(N'2024-10-11T23:35:37.8190703' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"AssignedOn":null,"AssignedToId":null,"Attachment":"qwe_2024-10-10_qwindows.dll","CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-10T13:25:32.9206639","DelTime":"2024-10-11T23:35:37.8186746+07:00","Description":"qwe","ModifiedById":null,"ModifiedOn":null,"Note":null,"PriorityId":21,"StatusId":15,"SubCategoryId":3,"Title":"qwe"}', N'["AssignedOn","AssignedToId","Attachment","CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","PriorityId","StatusId","SubCategoryId","Title"]', NULL, NULL, N'{"Id":10}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1508, N'Update', N'TicketResolution', N'TicketResolution', CAST(N'2024-10-11T23:35:47.1877379' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-11T23:31:37.9130879","DelTime":"2024-10-11T23:35:47.1829605+07:00","Description":"123","ModifiedById":null,"ModifiedOn":null,"Note":null,"StatusId":16,"TicketId":9}', N'["CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","StatusId","TicketId"]', NULL, NULL, N'{"Id":1054}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1509, N'Update', N'TicketResolution', N'TicketResolution', CAST(N'2024-10-11T23:35:47.1881038' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-11T23:31:49.48867","DelTime":"2024-10-11T23:35:47.1829645+07:00","Description":"Assign to user test3","ModifiedById":null,"ModifiedOn":null,"Note":null,"StatusId":17,"TicketId":9}', N'["CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","StatusId","TicketId"]', NULL, NULL, N'{"Id":1055}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1510, N'Update', N'TicketResolution', N'TicketResolution', CAST(N'2024-10-11T23:35:47.1882086' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-11T23:31:56.6427834","DelTime":"2024-10-11T23:35:47.1829646+07:00","Description":"Closed by owner","ModifiedById":null,"ModifiedOn":null,"Note":null,"StatusId":18,"TicketId":9}', N'["CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","StatusId","TicketId"]', NULL, NULL, N'{"Id":1056}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1511, N'Update', N'Ticket', N'Ticket', CAST(N'2024-10-11T23:35:47.1882585' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"AssignedOn":"2024-10-11T23:31:49.4886227","AssignedToId":"147df890-1c7c-4fc5-a78b-0262e832f25c","Attachment":null,"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-09-22T17:01:01.231803","DelTime":"2024-10-11T23:35:47.1829646+07:00","Description":"hehe3","ModifiedById":null,"ModifiedOn":null,"Note":null,"PriorityId":23,"StatusId":18,"SubCategoryId":2,"Title":"hehe3"}', N'["AssignedOn","AssignedToId","Attachment","CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","PriorityId","StatusId","SubCategoryId","Title"]', NULL, NULL, N'{"Id":9}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1512, N'Create', N'Ticket', N'Ticket', CAST(N'2024-10-11T23:45:45.8016951' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"AssignedOn":null,"AssignedToId":null,"Attachment":null,"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-11T23:45:45.7744191+07:00","DelTime":null,"Description":"321","ModifiedById":null,"ModifiedOn":null,"Note":null,"PriorityId":21,"StatusId":15,"SubCategoryId":2,"Title":"321"}', NULL, NULL, NULL, N'{"Id":-2147482647}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1513, N'Create', N'Ticket', N'Ticket', CAST(N'2024-10-11T23:45:54.5443259' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"AssignedOn":null,"AssignedToId":null,"Attachment":null,"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-11T23:45:54.5432361+07:00","DelTime":null,"Description":"111","ModifiedById":null,"ModifiedOn":null,"Note":null,"PriorityId":21,"StatusId":15,"SubCategoryId":2,"Title":"111"}', NULL, NULL, NULL, N'{"Id":-2147482646}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1514, N'Create', N'TicketResolution', N'TicketResolution', CAST(N'2024-10-11T23:46:04.4008165' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-11T23:46:04.3724726+07:00","DelTime":null,"Description":"Assign to user sssss","ModifiedById":null,"ModifiedOn":null,"Note":null,"StatusId":17,"TicketId":17}', NULL, NULL, NULL, N'{"Id":-2147482647}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1515, N'Update', N'Ticket', N'Ticket', CAST(N'2024-10-11T23:46:04.4010629' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"AssignedOn":"2024-10-11T23:46:04.3723249+07:00","AssignedToId":"3a55e370-2d81-4506-96fe-e6c614ed44e8","Attachment":null,"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-11T23:45:54.5432361","DelTime":null,"Description":"111","ModifiedById":null,"ModifiedOn":null,"Note":null,"PriorityId":21,"StatusId":17,"SubCategoryId":2,"Title":"111"}', N'["AssignedOn","AssignedToId","Attachment","CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","PriorityId","StatusId","SubCategoryId","Title"]', NULL, NULL, N'{"Id":17}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1516, N'Create', N'TicketResolution', N'TicketResolution', CAST(N'2024-10-11T23:46:13.1511790' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-11T23:46:13.1503231+07:00","DelTime":null,"Description":"Assign to user aaa12312","ModifiedById":null,"ModifiedOn":null,"Note":null,"StatusId":17,"TicketId":16}', NULL, NULL, NULL, N'{"Id":-2147482646}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1517, N'Update', N'Ticket', N'Ticket', CAST(N'2024-10-11T23:46:13.1513634' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"AssignedOn":"2024-10-11T23:46:13.1502825+07:00","AssignedToId":"9ce84dc8-b263-44b2-8104-604de18c51da","Attachment":null,"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-11T23:45:45.7744191","DelTime":null,"Description":"321","ModifiedById":null,"ModifiedOn":null,"Note":null,"PriorityId":21,"StatusId":17,"SubCategoryId":2,"Title":"321"}', N'["AssignedOn","AssignedToId","Attachment","CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","PriorityId","StatusId","SubCategoryId","Title"]', NULL, NULL, N'{"Id":16}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1518, N'Create', N'TicketResolution', N'TicketResolution', CAST(N'2024-10-11T23:46:21.6287146' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-11T23:46:21.6269808+07:00","DelTime":null,"Description":"3123","ModifiedById":null,"ModifiedOn":null,"Note":null,"StatusId":16,"TicketId":17}', NULL, NULL, NULL, N'{"Id":-2147482645}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1519, N'Update', N'Ticket', N'Ticket', CAST(N'2024-10-11T23:46:21.6291249' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"AssignedOn":"2024-10-11T23:46:04.3723249","AssignedToId":"3a55e370-2d81-4506-96fe-e6c614ed44e8","Attachment":null,"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-11T23:45:54.5432361","DelTime":null,"Description":"111","ModifiedById":null,"ModifiedOn":null,"Note":null,"PriorityId":21,"StatusId":16,"SubCategoryId":2,"Title":"111"}', N'["AssignedOn","AssignedToId","Attachment","CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","PriorityId","StatusId","SubCategoryId","Title"]', NULL, NULL, N'{"Id":17}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1520, N'Create', N'TicketResolution', N'TicketResolution', CAST(N'2024-10-11T23:46:30.0278273' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-11T23:46:30.026946+07:00","DelTime":null,"Description":"1231","ModifiedById":null,"ModifiedOn":null,"Note":null,"StatusId":19,"TicketId":16}', NULL, NULL, NULL, N'{"Id":-2147482644}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1521, N'Update', N'Ticket', N'Ticket', CAST(N'2024-10-11T23:46:30.0279324' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"AssignedOn":"2024-10-11T23:46:13.1502825","AssignedToId":"9ce84dc8-b263-44b2-8104-604de18c51da","Attachment":null,"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-11T23:45:45.7744191","DelTime":null,"Description":"321","ModifiedById":null,"ModifiedOn":null,"Note":null,"PriorityId":21,"StatusId":19,"SubCategoryId":2,"Title":"321"}', N'["AssignedOn","AssignedToId","Attachment","CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","PriorityId","StatusId","SubCategoryId","Title"]', NULL, NULL, N'{"Id":16}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1522, N'Update', N'TicketResolution', N'TicketResolution', CAST(N'2024-10-11T23:46:36.6424339' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-11T23:46:13.1503231","DelTime":"2024-10-11T23:46:36.6418405+07:00","Description":"Assign to user aaa12312","ModifiedById":null,"ModifiedOn":null,"Note":null,"StatusId":17,"TicketId":16}', N'["CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","StatusId","TicketId"]', NULL, NULL, N'{"Id":1058}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1523, N'Update', N'TicketResolution', N'TicketResolution', CAST(N'2024-10-11T23:46:36.6425821' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-11T23:46:30.026946","DelTime":"2024-10-11T23:46:36.6419436+07:00","Description":"1231","ModifiedById":null,"ModifiedOn":null,"Note":null,"StatusId":19,"TicketId":16}', N'["CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","StatusId","TicketId"]', NULL, NULL, N'{"Id":1060}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1524, N'Update', N'Ticket', N'Ticket', CAST(N'2024-10-11T23:46:36.6426104' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"AssignedOn":"2024-10-11T23:46:13.1502825","AssignedToId":"9ce84dc8-b263-44b2-8104-604de18c51da","Attachment":null,"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-11T23:45:45.7744191","DelTime":"2024-10-11T23:46:36.6419441+07:00","Description":"321","ModifiedById":null,"ModifiedOn":null,"Note":null,"PriorityId":21,"StatusId":19,"SubCategoryId":2,"Title":"321"}', N'["AssignedOn","AssignedToId","Attachment","CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","PriorityId","StatusId","SubCategoryId","Title"]', NULL, NULL, N'{"Id":16}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1525, N'Update', N'TicketResolution', N'TicketResolution', CAST(N'2024-10-11T23:46:38.9263181' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-11T23:31:12.1647472","DelTime":"2024-10-11T23:46:38.9260035+07:00","Description":"done","ModifiedById":null,"ModifiedOn":null,"Note":null,"StatusId":19,"TicketId":15}', N'["CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","StatusId","TicketId"]', NULL, NULL, N'{"Id":1052}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1526, N'Update', N'TicketResolution', N'TicketResolution', CAST(N'2024-10-11T23:46:38.9266576' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-11T23:31:24.4563307","DelTime":"2024-10-11T23:46:38.9260046+07:00","Description":"Assign to user hehe","ModifiedById":null,"ModifiedOn":null,"Note":null,"StatusId":17,"TicketId":15}', N'["CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","StatusId","TicketId"]', NULL, NULL, N'{"Id":1053}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1527, N'Update', N'Ticket', N'Ticket', CAST(N'2024-10-11T23:46:38.9267269' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"AssignedOn":"2024-10-11T23:31:24.4562536","AssignedToId":"2744be36-c5f4-442e-bcf3-5d7f59f5f139","Attachment":null,"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-11T23:30:57.5927216","DelTime":"2024-10-11T23:46:38.9260049+07:00","Description":"123","ModifiedById":null,"ModifiedOn":null,"Note":null,"PriorityId":21,"StatusId":17,"SubCategoryId":2,"Title":"123"}', N'["AssignedOn","AssignedToId","Attachment","CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","PriorityId","StatusId","SubCategoryId","Title"]', NULL, NULL, N'{"Id":15}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1528, N'Create', N'TicketResolution', N'TicketResolution', CAST(N'2024-10-12T15:37:39.6781581' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-12T15:37:39.509542+07:00","DelTime":null,"Description":"dinbe","ModifiedById":null,"ModifiedOn":null,"Note":null,"StatusId":19,"TicketId":17}', NULL, NULL, NULL, N'{"Id":-2147482647}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1529, N'Update', N'Ticket', N'Ticket', CAST(N'2024-10-12T15:37:39.7412864' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"AssignedOn":"2024-10-11T23:46:04.3723249","AssignedToId":"3a55e370-2d81-4506-96fe-e6c614ed44e8","Attachment":null,"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-11T23:45:54.5432361","DelTime":null,"Description":"111","ModifiedById":null,"ModifiedOn":null,"Note":null,"PriorityId":21,"StatusId":19,"SubCategoryId":2,"Title":"111"}', N'["AssignedOn","AssignedToId","Attachment","CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","PriorityId","StatusId","SubCategoryId","Title"]', NULL, NULL, N'{"Id":17}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1530, N'Create', N'Ticket', N'Ticket', CAST(N'2024-10-12T15:38:57.1284435' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"AssignedOn":null,"AssignedToId":null,"Attachment":null,"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-12T15:38:57.1266532+07:00","DelTime":null,"Description":"123","ModifiedById":null,"ModifiedOn":null,"Note":null,"PriorityId":21,"StatusId":15,"SubCategoryId":2,"Title":"123"}', NULL, NULL, NULL, N'{"Id":-2147482647}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1531, N'Create', N'Ticket', N'Ticket', CAST(N'2024-10-12T15:39:25.0495004' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"AssignedOn":null,"AssignedToId":null,"Attachment":null,"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-12T15:39:25.0491975+07:00","DelTime":null,"Description":"321","ModifiedById":null,"ModifiedOn":null,"Note":null,"PriorityId":21,"StatusId":15,"SubCategoryId":2,"Title":"321"}', NULL, NULL, NULL, N'{"Id":-2147482646}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1532, N'Create', N'TicketResolution', N'TicketResolution', CAST(N'2024-10-12T15:39:30.6076195' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-12T15:39:30.5972616+07:00","DelTime":null,"Description":"312","ModifiedById":null,"ModifiedOn":null,"Note":null,"StatusId":19,"TicketId":19}', NULL, NULL, NULL, N'{"Id":-2147482646}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1533, N'Update', N'Ticket', N'Ticket', CAST(N'2024-10-12T15:39:30.6077143' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"AssignedOn":null,"AssignedToId":null,"Attachment":null,"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-12T15:39:25.0491975","DelTime":null,"Description":"321","ModifiedById":null,"ModifiedOn":null,"Note":null,"PriorityId":21,"StatusId":19,"SubCategoryId":2,"Title":"321"}', N'["AssignedOn","AssignedToId","Attachment","CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","PriorityId","StatusId","SubCategoryId","Title"]', NULL, NULL, N'{"Id":19}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1534, N'Update', N'Ticket', N'Ticket', CAST(N'2024-10-14T18:07:30.3235435' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"AssignedOn":null,"AssignedToId":null,"Attachment":null,"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-12T15:38:57.1266532","DelTime":"2024-10-14T18:07:29.7315733+07:00","Description":"123","ModifiedById":null,"ModifiedOn":null,"Note":null,"PriorityId":21,"StatusId":15,"SubCategoryId":2,"Title":"123"}', N'["AssignedOn","AssignedToId","Attachment","CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","PriorityId","StatusId","SubCategoryId","Title"]', NULL, NULL, N'{"Id":18}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1535, N'Update', N'TicketResolution', N'TicketResolution', CAST(N'2024-10-14T18:08:34.1222266' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-12T15:39:30.5972616","DelTime":"2024-10-14T18:08:34.1107779+07:00","Description":"312","ModifiedById":null,"ModifiedOn":null,"Note":null,"StatusId":19,"TicketId":19}', N'["CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","StatusId","TicketId"]', NULL, NULL, N'{"Id":1062}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1536, N'Update', N'Ticket', N'Ticket', CAST(N'2024-10-14T18:08:34.1246603' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"AssignedOn":null,"AssignedToId":null,"Attachment":null,"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-12T15:39:25.0491975","DelTime":"2024-10-14T18:08:34.1107804+07:00","Description":"321","ModifiedById":null,"ModifiedOn":null,"Note":null,"PriorityId":21,"StatusId":19,"SubCategoryId":2,"Title":"321"}', N'["AssignedOn","AssignedToId","Attachment","CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","PriorityId","StatusId","SubCategoryId","Title"]', NULL, NULL, N'{"Id":19}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1537, N'Create', N'Ticket', N'Ticket', CAST(N'2024-10-15T14:42:35.0678380' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"AssignedOn":null,"AssignedToId":null,"Attachment":null,"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-15T14:42:34.4081615+07:00","DelTime":null,"Description":"aa","ModifiedById":null,"ModifiedOn":null,"Note":null,"PriorityId":21,"StatusId":15,"SubCategoryId":2,"Title":"aa"}', NULL, NULL, NULL, N'{"Id":-2147482647}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1538, N'Create', N'Ticket', N'Ticket', CAST(N'2024-10-15T14:42:54.0148714' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"AssignedOn":null,"AssignedToId":null,"Attachment":null,"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-15T14:42:54.0128126+07:00","DelTime":null,"Description":"bb","ModifiedById":null,"ModifiedOn":null,"Note":null,"PriorityId":21,"StatusId":15,"SubCategoryId":2,"Title":"bb"}', NULL, NULL, NULL, N'{"Id":-2147482646}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1539, N'Create', N'Ticket', N'Ticket', CAST(N'2024-10-15T14:43:22.1004446' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"AssignedOn":null,"AssignedToId":null,"Attachment":null,"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-15T14:43:22.0984792+07:00","DelTime":null,"Description":"gg","ModifiedById":null,"ModifiedOn":null,"Note":null,"PriorityId":21,"StatusId":15,"SubCategoryId":2,"Title":"ggg"}', NULL, NULL, NULL, N'{"Id":-2147482645}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1540, N'Create', N'Ticket', N'Ticket', CAST(N'2024-10-15T14:43:37.0513199' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"AssignedOn":null,"AssignedToId":null,"Attachment":null,"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-15T14:43:37.0508173+07:00","DelTime":null,"Description":"ccc","ModifiedById":null,"ModifiedOn":null,"Note":null,"PriorityId":21,"StatusId":15,"SubCategoryId":2,"Title":"ccc"}', NULL, NULL, NULL, N'{"Id":-2147482644}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1541, N'Update', N'Ticket', N'Ticket', CAST(N'2024-10-15T14:44:02.6511611' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"AssignedOn":null,"AssignedToId":null,"Attachment":null,"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-15T14:42:34","DelTime":null,"Description":"aaa","ModifiedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","ModifiedOn":"2024-10-15T14:44:02.6455455+07:00","Note":null,"PriorityId":21,"StatusId":15,"SubCategoryId":2,"Title":"aaaa"}', N'["AssignedOn","AssignedToId","Attachment","CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","PriorityId","StatusId","SubCategoryId","Title"]', NULL, NULL, N'{"Id":20}')
GO
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1542, N'Create', N'Ticket', N'Ticket', CAST(N'2024-10-15T14:44:16.9311051' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"AssignedOn":null,"AssignedToId":null,"Attachment":null,"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-15T14:44:16.9305623+07:00","DelTime":null,"Description":"d","ModifiedById":null,"ModifiedOn":null,"Note":null,"PriorityId":21,"StatusId":15,"SubCategoryId":2,"Title":"d"}', NULL, NULL, NULL, N'{"Id":-2147482643}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1543, N'Create', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T13:39:43.0174946' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-16T13:39:42.713994+07:00","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"27c5880b-5900-4a54-b9ae-7de5f24c73f1","TaskId":1}', NULL, NULL, NULL, N'{"Id":-2147482647}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1544, N'Create', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T13:39:43.2216671' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-16T13:39:42.7440741+07:00","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"27c5880b-5900-4a54-b9ae-7de5f24c73f1","TaskId":2}', NULL, NULL, NULL, N'{"Id":-2147482646}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1545, N'Create', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T13:39:43.2218623' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-16T13:39:42.7453723+07:00","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"27c5880b-5900-4a54-b9ae-7de5f24c73f1","TaskId":3}', NULL, NULL, NULL, N'{"Id":-2147482645}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1546, N'Delete', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T13:39:43.2219462' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-08T07:03:53.9392137","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"27c5880b-5900-4a54-b9ae-7de5f24c73f1","TaskId":1}', NULL, NULL, NULL, NULL, N'{"Id":135}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1547, N'Delete', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T13:39:43.2220211' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-08T07:03:53.9393789","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"27c5880b-5900-4a54-b9ae-7de5f24c73f1","TaskId":2}', NULL, NULL, NULL, NULL, N'{"Id":136}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1548, N'Delete', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T13:39:43.2220837' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-08T07:03:53.9393956","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"27c5880b-5900-4a54-b9ae-7de5f24c73f1","TaskId":3}', NULL, NULL, NULL, NULL, N'{"Id":137}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1549, N'Delete', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T13:39:43.2221402' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-08T07:03:53.9394056","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"27c5880b-5900-4a54-b9ae-7de5f24c73f1","TaskId":5}', NULL, NULL, NULL, NULL, N'{"Id":138}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1550, N'Delete', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T13:39:43.2222125' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-08T07:03:53.9394192","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"27c5880b-5900-4a54-b9ae-7de5f24c73f1","TaskId":6}', NULL, NULL, NULL, NULL, N'{"Id":139}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1551, N'Delete', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T13:39:43.2222683' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-08T07:03:53.939429","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"27c5880b-5900-4a54-b9ae-7de5f24c73f1","TaskId":7}', NULL, NULL, NULL, NULL, N'{"Id":140}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1552, N'Delete', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T13:39:43.2223206' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-08T07:03:53.9394369","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"27c5880b-5900-4a54-b9ae-7de5f24c73f1","TaskId":8}', NULL, NULL, NULL, NULL, N'{"Id":141}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1553, N'Delete', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T13:39:43.2223754' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-08T07:03:53.939445","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"27c5880b-5900-4a54-b9ae-7de5f24c73f1","TaskId":9}', NULL, NULL, NULL, NULL, N'{"Id":142}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1554, N'Delete', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T13:39:43.2224265' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-08T07:03:53.9394839","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"27c5880b-5900-4a54-b9ae-7de5f24c73f1","TaskId":10}', NULL, NULL, NULL, NULL, N'{"Id":143}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1555, N'Delete', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T13:39:43.2224812' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-08T07:03:53.9394962","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"27c5880b-5900-4a54-b9ae-7de5f24c73f1","TaskId":11}', NULL, NULL, NULL, NULL, N'{"Id":144}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1556, N'Delete', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T13:39:43.2225370' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-08T07:03:53.9395058","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"27c5880b-5900-4a54-b9ae-7de5f24c73f1","TaskId":12}', NULL, NULL, NULL, NULL, N'{"Id":145}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1557, N'Delete', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T13:39:43.2226084' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-08T07:03:53.9395147","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"27c5880b-5900-4a54-b9ae-7de5f24c73f1","TaskId":13}', NULL, NULL, NULL, NULL, N'{"Id":146}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1558, N'Create', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T13:40:03.7522243' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-16T13:40:03.7515288+07:00","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"70ea0da2-45f4-44bc-809d-1becc2198498","TaskId":1}', NULL, NULL, NULL, N'{"Id":-2147482644}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1559, N'Create', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T13:40:03.7523339' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-16T13:40:03.7517203+07:00","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"70ea0da2-45f4-44bc-809d-1becc2198498","TaskId":2}', NULL, NULL, NULL, N'{"Id":-2147482643}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1560, N'Create', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T13:40:03.7523766' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-16T13:40:03.7517876+07:00","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"70ea0da2-45f4-44bc-809d-1becc2198498","TaskId":3}', NULL, NULL, NULL, N'{"Id":-2147482642}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1561, N'Delete', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T13:40:03.7524231' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', N'{"CreatedById":"8788c5e7-1463-4215-99fe-8701d5e83199","CreatedOn":"2024-10-07T14:48:44.3256655","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"70ea0da2-45f4-44bc-809d-1becc2198498","TaskId":1}', NULL, NULL, NULL, NULL, N'{"Id":36}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1562, N'Delete', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T13:40:03.7524638' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', N'{"CreatedById":"8788c5e7-1463-4215-99fe-8701d5e83199","CreatedOn":"2024-10-07T14:48:44.3449931","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"70ea0da2-45f4-44bc-809d-1becc2198498","TaskId":2}', NULL, NULL, NULL, NULL, N'{"Id":37}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1563, N'Delete', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T13:40:03.7525017' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', N'{"CreatedById":"8788c5e7-1463-4215-99fe-8701d5e83199","CreatedOn":"2024-10-07T14:48:44.345918","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"70ea0da2-45f4-44bc-809d-1becc2198498","TaskId":3}', NULL, NULL, NULL, NULL, N'{"Id":38}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1564, N'Delete', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T13:40:03.7525366' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', N'{"CreatedById":"8788c5e7-1463-4215-99fe-8701d5e83199","CreatedOn":"2024-10-07T14:48:44.3459721","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"70ea0da2-45f4-44bc-809d-1becc2198498","TaskId":5}', NULL, NULL, NULL, NULL, N'{"Id":39}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1565, N'Delete', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T13:40:03.7525690' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', N'{"CreatedById":"8788c5e7-1463-4215-99fe-8701d5e83199","CreatedOn":"2024-10-07T14:48:44.3459975","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"70ea0da2-45f4-44bc-809d-1becc2198498","TaskId":6}', NULL, NULL, NULL, NULL, N'{"Id":40}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1566, N'Delete', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T13:40:03.7526088' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', N'{"CreatedById":"8788c5e7-1463-4215-99fe-8701d5e83199","CreatedOn":"2024-10-07T14:48:44.3460453","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"70ea0da2-45f4-44bc-809d-1becc2198498","TaskId":7}', NULL, NULL, NULL, NULL, N'{"Id":41}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1567, N'Delete', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T13:40:03.7526418' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', N'{"CreatedById":"8788c5e7-1463-4215-99fe-8701d5e83199","CreatedOn":"2024-10-07T14:48:44.3460752","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"70ea0da2-45f4-44bc-809d-1becc2198498","TaskId":8}', NULL, NULL, NULL, NULL, N'{"Id":42}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1568, N'Delete', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T13:40:03.7526756' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', N'{"CreatedById":"8788c5e7-1463-4215-99fe-8701d5e83199","CreatedOn":"2024-10-07T14:48:44.3461014","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"70ea0da2-45f4-44bc-809d-1becc2198498","TaskId":9}', NULL, NULL, NULL, NULL, N'{"Id":43}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1569, N'Delete', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T13:40:03.7527061' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', N'{"CreatedById":"8788c5e7-1463-4215-99fe-8701d5e83199","CreatedOn":"2024-10-07T14:48:44.346127","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"70ea0da2-45f4-44bc-809d-1becc2198498","TaskId":10}', NULL, NULL, NULL, NULL, N'{"Id":44}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1570, N'Delete', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T13:40:03.7527661' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', N'{"CreatedById":"8788c5e7-1463-4215-99fe-8701d5e83199","CreatedOn":"2024-10-07T14:48:44.3461497","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"70ea0da2-45f4-44bc-809d-1becc2198498","TaskId":11}', NULL, NULL, NULL, NULL, N'{"Id":45}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1571, N'Delete', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T13:40:03.7528048' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', N'{"CreatedById":"8788c5e7-1463-4215-99fe-8701d5e83199","CreatedOn":"2024-10-07T14:48:44.3461866","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"70ea0da2-45f4-44bc-809d-1becc2198498","TaskId":12}', NULL, NULL, NULL, NULL, N'{"Id":46}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1572, N'Delete', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T13:40:03.7528357' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', N'{"CreatedById":"8788c5e7-1463-4215-99fe-8701d5e83199","CreatedOn":"2024-10-07T14:48:44.3462092","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"70ea0da2-45f4-44bc-809d-1becc2198498","TaskId":13}', NULL, NULL, NULL, NULL, N'{"Id":47}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1573, N'Create', N'SystemTask', N'SystemTask', CAST(N'2024-10-16T14:04:49.7552777' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"Code":"Departments","CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-16T14:04:49.6660492+07:00","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Name":"Departments","Note":null,"OrderNo":1,"ParentId":null}', NULL, NULL, NULL, N'{"Id":-2147482647}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1574, N'Create', N'SystemTask', N'SystemTask', CAST(N'2024-10-16T14:08:33.3214700' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"Code":"System","CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-16T14:08:33.3182321+07:00","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Name":"System","Note":null,"OrderNo":1,"ParentId":null}', NULL, NULL, NULL, N'{"Id":-2147482646}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1575, N'Update', N'SystemTask', N'SystemTask', CAST(N'2024-10-16T14:08:47.3755372' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"Code":"SystemTasks","CreatedById":"d904d1b5-0a2c-4c39-9804-27b42f658ece","CreatedOn":"2024-09-11T16:07:06","DelTime":null,"ModifiedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","ModifiedOn":"2024-10-16T14:08:47.3719878+07:00","Name":"System Tasks","Note":null,"OrderNo":1,"ParentId":15}', N'["Code","CreatedById","CreatedOn","DelTime","ModifiedById","ModifiedOn","Name","Note","OrderNo","ParentId"]', NULL, NULL, N'{"Id":12}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1576, N'Create', N'SystemTask', N'SystemTask', CAST(N'2024-10-16T14:09:22.0336977' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"Code":"SystemSettings","CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-16T14:09:22.0303487+07:00","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Name":"System Settings","Note":null,"OrderNo":2,"ParentId":15}', NULL, NULL, NULL, N'{"Id":-2147482645}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1577, N'Create', N'SystemTask', N'SystemTask', CAST(N'2024-10-16T14:13:40.2684859' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"Code":"RolesProfile","CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-16T14:13:40.2664279+07:00","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Name":"RolesProfile","Note":null,"OrderNo":2,"ParentId":10}', NULL, NULL, NULL, N'{"Id":-2147482644}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1578, N'Update', N'SystemTask', N'SystemTask', CAST(N'2024-10-16T14:16:37.0292644' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"Code":"SystemCodes","CreatedById":"d904d1b5-0a2c-4c39-9804-27b42f658ece","CreatedOn":"2024-09-11T16:06:01","DelTime":null,"ModifiedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","ModifiedOn":"2024-10-16T14:16:37.0230303+07:00","Name":"System Codes","Note":null,"OrderNo":2,"ParentId":15}', N'["Code","CreatedById","CreatedOn","DelTime","ModifiedById","ModifiedOn","Name","Note","OrderNo","ParentId"]', NULL, NULL, N'{"Id":8}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1579, N'Update', N'SystemTask', N'SystemTask', CAST(N'2024-10-16T14:16:47.9683914' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"Code":"SystemCodeDetails","CreatedById":"d904d1b5-0a2c-4c39-9804-27b42f658ece","CreatedOn":"2024-09-11T16:06:21","DelTime":null,"ModifiedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","ModifiedOn":"2024-10-16T14:16:47.9649883+07:00","Name":"System Code Details","Note":null,"OrderNo":3,"ParentId":8}', N'["Code","CreatedById","CreatedOn","DelTime","ModifiedById","ModifiedOn","Name","Note","OrderNo","ParentId"]', NULL, NULL, N'{"Id":9}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1580, N'Update', N'SystemTask', N'SystemTask', CAST(N'2024-10-16T14:17:26.6422848' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"Code":"SystemTasks","CreatedById":"d904d1b5-0a2c-4c39-9804-27b42f658ece","CreatedOn":"2024-09-11T16:07:06","DelTime":null,"ModifiedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","ModifiedOn":"2024-10-16T14:17:26.64138+07:00","Name":"System Tasks","Note":null,"OrderNo":2,"ParentId":15}', N'["Code","CreatedById","CreatedOn","DelTime","ModifiedById","ModifiedOn","Name","Note","OrderNo","ParentId"]', NULL, NULL, N'{"Id":12}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1581, N'Create', N'SystemTask', N'SystemTask', CAST(N'2024-10-16T14:18:48.4964566' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"Code":"ErrorLogs","CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-16T14:18:48.4953273+07:00","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Name":"Error Logs","Note":null,"OrderNo":2,"ParentId":15}', NULL, NULL, NULL, N'{"Id":-2147482643}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1582, N'Update', N'SystemTask', N'SystemTask', CAST(N'2024-10-16T14:19:12.8614182' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"Code":"AuditTrails","CreatedById":"d904d1b5-0a2c-4c39-9804-27b42f658ece","CreatedOn":"2024-09-11T16:03:24","DelTime":null,"ModifiedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","ModifiedOn":"2024-10-16T14:19:12.8604627+07:00","Name":"Audit Trails","Note":null,"OrderNo":2,"ParentId":15}', N'["Code","CreatedById","CreatedOn","DelTime","ModifiedById","ModifiedOn","Name","Note","OrderNo","ParentId"]', NULL, NULL, N'{"Id":5}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1583, N'Update', N'AppUser', N'AppUser', CAST(N'2024-10-16T14:58:30.3978332' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"AccessFailedCount":0,"ConcurrencyStamp":"ec617fdb-bb8d-4233-8fc4-a5943ffa1e1d","CreatedById":null,"CreatedOn":"0001-01-01T00:00:00","DOB":"2024-09-18","DelTime":null,"Email":"321@gmail.com","EmailConfirmed":true,"GenderId":27,"IsLocked":null,"LockoutEnabled":true,"LockoutEnd":null,"ModifiedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","ModifiedOn":"2024-10-16T14:58:30.3618987+07:00","Name":"321","NormalizedEmail":"321@GMAIL.COM","NormalizedUserName":"321@GMAIL.COM","Note":null,"PasswordHash":"AQAAAAIAAYagAAAAELCK+5ks4yN4xBv2MWdHtIoW7OfldUNXDdjyP/vHvFwHT5i/AhBY11nHTleHfzx36g==","PhoneNumber":"0968444503","PhoneNumberConfirmed":true,"RoleId":"b750fcb9-71f0-4434-a37e-1c3e0ab9461b","SecurityStamp":"4A5EP4JZUIQE5UDEMI4BGNJ7OBRNLE55","TwoFactorEnabled":false,"UserName":"321@gmail.com"}', N'["AccessFailedCount","ConcurrencyStamp","CreatedById","CreatedOn","DOB","DelTime","Email","EmailConfirmed","GenderId","IsLocked","LockoutEnabled","LockoutEnd","ModifiedById","ModifiedOn","Name","NormalizedEmail","NormalizedUserName","Note","PasswordHash","PhoneNumber","PhoneNumberConfirmed","RoleId","SecurityStamp","TwoFactorEnabled","UserName"]', NULL, NULL, N'{"Id":"1f70a729-996a-45de-b002-0e2b62ab2d8c"}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1584, N'Create', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T14:59:35.4405006' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-16T14:59:35.3994975+07:00","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"b750fcb9-71f0-4434-a37e-1c3e0ab9461b","TaskId":1}', NULL, NULL, NULL, N'{"Id":-2147482647}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1585, N'Create', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T14:59:35.4407734' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-16T14:59:35.4083034+07:00","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"b750fcb9-71f0-4434-a37e-1c3e0ab9461b","TaskId":2}', NULL, NULL, NULL, N'{"Id":-2147482646}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1586, N'Create', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T14:59:35.4408800' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-16T14:59:35.4092174+07:00","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"b750fcb9-71f0-4434-a37e-1c3e0ab9461b","TaskId":3}', NULL, NULL, NULL, N'{"Id":-2147482645}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1587, N'Create', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T14:59:35.4409491' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-16T14:59:35.4092983+07:00","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"b750fcb9-71f0-4434-a37e-1c3e0ab9461b","TaskId":6}', NULL, NULL, NULL, N'{"Id":-2147482644}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1588, N'Create', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T14:59:35.4410250' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-16T14:59:35.4093431+07:00","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"b750fcb9-71f0-4434-a37e-1c3e0ab9461b","TaskId":7}', NULL, NULL, NULL, N'{"Id":-2147482643}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1589, N'Create', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T14:59:35.4410753' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-16T14:59:35.4093811+07:00","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"b750fcb9-71f0-4434-a37e-1c3e0ab9461b","TaskId":10}', NULL, NULL, NULL, N'{"Id":-2147482642}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1590, N'Create', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T14:59:35.4411297' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-16T14:59:35.4094244+07:00","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"b750fcb9-71f0-4434-a37e-1c3e0ab9461b","TaskId":17}', NULL, NULL, NULL, N'{"Id":-2147482641}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1591, N'Create', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T14:59:35.4411717' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-16T14:59:35.4094592+07:00","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"b750fcb9-71f0-4434-a37e-1c3e0ab9461b","TaskId":11}', NULL, NULL, NULL, N'{"Id":-2147482640}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1592, N'Create', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T14:59:35.4412373' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-16T14:59:35.4094956+07:00","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"b750fcb9-71f0-4434-a37e-1c3e0ab9461b","TaskId":13}', NULL, NULL, NULL, N'{"Id":-2147482639}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1593, N'Create', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T14:59:35.4412857' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-16T14:59:35.4095313+07:00","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"b750fcb9-71f0-4434-a37e-1c3e0ab9461b","TaskId":14}', NULL, NULL, NULL, N'{"Id":-2147482638}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1594, N'Create', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T14:59:35.4413275' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-16T14:59:35.4095785+07:00","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"b750fcb9-71f0-4434-a37e-1c3e0ab9461b","TaskId":15}', NULL, NULL, NULL, N'{"Id":-2147482637}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1595, N'Create', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T14:59:35.4413845' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-16T14:59:35.409673+07:00","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"b750fcb9-71f0-4434-a37e-1c3e0ab9461b","TaskId":5}', NULL, NULL, NULL, N'{"Id":-2147482636}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1596, N'Create', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T14:59:35.4414532' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-16T14:59:35.4097108+07:00","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"b750fcb9-71f0-4434-a37e-1c3e0ab9461b","TaskId":8}', NULL, NULL, NULL, N'{"Id":-2147482635}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1597, N'Create', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T14:59:35.4415091' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-16T14:59:35.4097429+07:00","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"b750fcb9-71f0-4434-a37e-1c3e0ab9461b","TaskId":12}', NULL, NULL, NULL, N'{"Id":-2147482634}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1598, N'Create', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T14:59:35.4415789' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-16T14:59:35.4097869+07:00","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"b750fcb9-71f0-4434-a37e-1c3e0ab9461b","TaskId":16}', NULL, NULL, NULL, N'{"Id":-2147482633}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1599, N'Create', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T14:59:35.4416681' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-16T14:59:35.4098372+07:00","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"b750fcb9-71f0-4434-a37e-1c3e0ab9461b","TaskId":18}', NULL, NULL, NULL, N'{"Id":-2147482632}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1600, N'Delete', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T14:59:35.4417403' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-07T16:44:37.5483747","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"b750fcb9-71f0-4434-a37e-1c3e0ab9461b","TaskId":1}', NULL, NULL, NULL, NULL, N'{"Id":77}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1601, N'Delete', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T14:59:35.4417925' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-07T16:44:37.5485477","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"b750fcb9-71f0-4434-a37e-1c3e0ab9461b","TaskId":2}', NULL, NULL, NULL, NULL, N'{"Id":78}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1602, N'Delete', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T14:59:35.4418435' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-07T16:44:37.5485814","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"b750fcb9-71f0-4434-a37e-1c3e0ab9461b","TaskId":3}', NULL, NULL, NULL, NULL, N'{"Id":79}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1603, N'Delete', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T14:59:35.4418815' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-07T16:44:37.5487285","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"b750fcb9-71f0-4434-a37e-1c3e0ab9461b","TaskId":5}', NULL, NULL, NULL, NULL, N'{"Id":80}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1604, N'Delete', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T14:59:35.4419364' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-07T16:44:37.5487665","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"b750fcb9-71f0-4434-a37e-1c3e0ab9461b","TaskId":6}', NULL, NULL, NULL, NULL, N'{"Id":81}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1605, N'Delete', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T14:59:35.4420171' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-07T16:44:37.548794","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"b750fcb9-71f0-4434-a37e-1c3e0ab9461b","TaskId":7}', NULL, NULL, NULL, NULL, N'{"Id":82}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1606, N'Delete', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T14:59:35.4420574' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-07T16:44:37.5488207","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"b750fcb9-71f0-4434-a37e-1c3e0ab9461b","TaskId":8}', NULL, NULL, NULL, NULL, N'{"Id":83}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1607, N'Delete', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T14:59:35.4421016' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-07T16:44:37.5488411","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"b750fcb9-71f0-4434-a37e-1c3e0ab9461b","TaskId":9}', NULL, NULL, NULL, NULL, N'{"Id":84}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1608, N'Delete', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T14:59:35.4421363' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-07T16:44:37.5488651","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"b750fcb9-71f0-4434-a37e-1c3e0ab9461b","TaskId":10}', NULL, NULL, NULL, NULL, N'{"Id":85}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1609, N'Delete', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T14:59:35.4422162' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-07T16:44:37.5489029","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"b750fcb9-71f0-4434-a37e-1c3e0ab9461b","TaskId":11}', NULL, NULL, NULL, NULL, N'{"Id":86}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1610, N'Delete', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T14:59:35.4422649' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-07T16:44:37.5489518","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"b750fcb9-71f0-4434-a37e-1c3e0ab9461b","TaskId":12}', NULL, NULL, NULL, NULL, N'{"Id":87}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1611, N'Delete', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T14:59:35.4423012' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-07T16:44:37.5489754","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"b750fcb9-71f0-4434-a37e-1c3e0ab9461b","TaskId":13}', NULL, NULL, NULL, NULL, N'{"Id":88}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1612, N'Create', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T15:05:23.0248144' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-16T15:04:05.3953418+07:00","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"b750fcb9-71f0-4434-a37e-1c3e0ab9461b","TaskId":1}', NULL, NULL, NULL, N'{"Id":-2147482647}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1613, N'Create', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T15:05:23.2607661' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-16T15:04:19.5631948+07:00","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"b750fcb9-71f0-4434-a37e-1c3e0ab9461b","TaskId":2}', NULL, NULL, NULL, N'{"Id":-2147482646}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1614, N'Create', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T15:05:23.2609571' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-16T15:04:22.2892417+07:00","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"b750fcb9-71f0-4434-a37e-1c3e0ab9461b","TaskId":3}', NULL, NULL, NULL, N'{"Id":-2147482645}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1615, N'Create', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T15:05:23.2610709' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-16T15:04:24.434443+07:00","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"b750fcb9-71f0-4434-a37e-1c3e0ab9461b","TaskId":6}', NULL, NULL, NULL, N'{"Id":-2147482644}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1616, N'Create', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T15:05:23.2611736' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-16T15:04:26.9354541+07:00","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"b750fcb9-71f0-4434-a37e-1c3e0ab9461b","TaskId":7}', NULL, NULL, NULL, N'{"Id":-2147482643}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1617, N'Create', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T15:05:23.2612797' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-16T15:04:29.1435849+07:00","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"b750fcb9-71f0-4434-a37e-1c3e0ab9461b","TaskId":10}', NULL, NULL, NULL, N'{"Id":-2147482642}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1618, N'Create', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T15:05:23.2613317' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-16T15:04:31.8651849+07:00","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"b750fcb9-71f0-4434-a37e-1c3e0ab9461b","TaskId":17}', NULL, NULL, NULL, N'{"Id":-2147482641}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1619, N'Create', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T15:05:23.2614422' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-16T15:04:38.8985758+07:00","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"b750fcb9-71f0-4434-a37e-1c3e0ab9461b","TaskId":11}', NULL, NULL, NULL, N'{"Id":-2147482640}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1620, N'Create', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T15:05:23.2615089' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-16T15:04:41.7006827+07:00","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"b750fcb9-71f0-4434-a37e-1c3e0ab9461b","TaskId":13}', NULL, NULL, NULL, N'{"Id":-2147482639}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1621, N'Create', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T15:05:23.2615658' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-16T15:04:45.788558+07:00","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"b750fcb9-71f0-4434-a37e-1c3e0ab9461b","TaskId":14}', NULL, NULL, NULL, N'{"Id":-2147482638}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1622, N'Create', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T15:05:23.2616470' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-16T15:04:50.6122819+07:00","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"b750fcb9-71f0-4434-a37e-1c3e0ab9461b","TaskId":15}', NULL, NULL, NULL, N'{"Id":-2147482637}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1623, N'Create', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T15:05:23.2617132' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-16T15:04:56.65264+07:00","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"b750fcb9-71f0-4434-a37e-1c3e0ab9461b","TaskId":5}', NULL, NULL, NULL, N'{"Id":-2147482636}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1624, N'Create', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T15:05:23.2617657' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-16T15:05:04.5912581+07:00","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"b750fcb9-71f0-4434-a37e-1c3e0ab9461b","TaskId":8}', NULL, NULL, NULL, N'{"Id":-2147482635}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1625, N'Create', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T15:05:23.2618464' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-16T15:05:08.4614345+07:00","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"b750fcb9-71f0-4434-a37e-1c3e0ab9461b","TaskId":12}', NULL, NULL, NULL, N'{"Id":-2147482634}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1626, N'Create', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T15:05:23.2619135' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-16T15:05:12.3624263+07:00","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"b750fcb9-71f0-4434-a37e-1c3e0ab9461b","TaskId":16}', NULL, NULL, NULL, N'{"Id":-2147482633}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1627, N'Create', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T15:05:23.2620107' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-16T15:05:16.5898718+07:00","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"b750fcb9-71f0-4434-a37e-1c3e0ab9461b","TaskId":18}', NULL, NULL, NULL, N'{"Id":-2147482632}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1628, N'Delete', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T15:05:23.2620883' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-16T14:59:35.3994975","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"b750fcb9-71f0-4434-a37e-1c3e0ab9461b","TaskId":1}', NULL, NULL, NULL, NULL, N'{"Id":153}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1629, N'Delete', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T15:05:23.2621576' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-16T14:59:35.4083034","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"b750fcb9-71f0-4434-a37e-1c3e0ab9461b","TaskId":2}', NULL, NULL, NULL, NULL, N'{"Id":154}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1630, N'Delete', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T15:05:23.2622242' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-16T14:59:35.4092174","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"b750fcb9-71f0-4434-a37e-1c3e0ab9461b","TaskId":3}', NULL, NULL, NULL, NULL, N'{"Id":155}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1631, N'Delete', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T15:05:23.2622757' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-16T14:59:35.4092983","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"b750fcb9-71f0-4434-a37e-1c3e0ab9461b","TaskId":6}', NULL, NULL, NULL, NULL, N'{"Id":156}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1632, N'Delete', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T15:05:23.2623278' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-16T14:59:35.4093431","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"b750fcb9-71f0-4434-a37e-1c3e0ab9461b","TaskId":7}', NULL, NULL, NULL, NULL, N'{"Id":157}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1633, N'Delete', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T15:05:23.2624218' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-16T14:59:35.4093811","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"b750fcb9-71f0-4434-a37e-1c3e0ab9461b","TaskId":10}', NULL, NULL, NULL, NULL, N'{"Id":158}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1634, N'Delete', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T15:05:23.2625996' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-16T14:59:35.4094244","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"b750fcb9-71f0-4434-a37e-1c3e0ab9461b","TaskId":17}', NULL, NULL, NULL, NULL, N'{"Id":159}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1635, N'Delete', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T15:05:23.2626491' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-16T14:59:35.4094592","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"b750fcb9-71f0-4434-a37e-1c3e0ab9461b","TaskId":11}', NULL, NULL, NULL, NULL, N'{"Id":160}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1636, N'Delete', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T15:05:23.2627338' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-16T14:59:35.4094956","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"b750fcb9-71f0-4434-a37e-1c3e0ab9461b","TaskId":13}', NULL, NULL, NULL, NULL, N'{"Id":161}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1637, N'Delete', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T15:05:23.2627804' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-16T14:59:35.4095313","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"b750fcb9-71f0-4434-a37e-1c3e0ab9461b","TaskId":14}', NULL, NULL, NULL, NULL, N'{"Id":162}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1638, N'Delete', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T15:05:23.2628308' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-16T14:59:35.4095785","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"b750fcb9-71f0-4434-a37e-1c3e0ab9461b","TaskId":15}', NULL, NULL, NULL, NULL, N'{"Id":163}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1639, N'Delete', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T15:05:23.2628866' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-16T14:59:35.409673","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"b750fcb9-71f0-4434-a37e-1c3e0ab9461b","TaskId":5}', NULL, NULL, NULL, NULL, N'{"Id":164}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1640, N'Delete', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T15:05:23.2629555' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-16T14:59:35.4097108","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"b750fcb9-71f0-4434-a37e-1c3e0ab9461b","TaskId":8}', NULL, NULL, NULL, NULL, N'{"Id":165}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1641, N'Delete', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T15:05:23.2630052' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-16T14:59:35.4097429","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"b750fcb9-71f0-4434-a37e-1c3e0ab9461b","TaskId":12}', NULL, NULL, NULL, NULL, N'{"Id":166}')
GO
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1642, N'Delete', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T15:05:23.2630528' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-16T14:59:35.4097869","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"b750fcb9-71f0-4434-a37e-1c3e0ab9461b","TaskId":16}', NULL, NULL, NULL, NULL, N'{"Id":167}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1643, N'Delete', N'UserRoleProfile', N'UserRoleProfile', CAST(N'2024-10-16T15:05:23.2631293' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-16T14:59:35.4098372","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Note":null,"RoleId":"b750fcb9-71f0-4434-a37e-1c3e0ab9461b","TaskId":18}', NULL, NULL, NULL, NULL, N'{"Id":168}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1644, N'Update', N'AppUser', N'AppUser', CAST(N'2024-10-16T15:19:16.4312324' AS DateTime2), N'9feae18c-6e8c-46fe-9d32-76e59a80cf35', NULL, N'{"AccessFailedCount":0,"ConcurrencyStamp":"e52a55e5-bfa2-4d04-905a-0de8ea8b8307","CreatedById":null,"CreatedOn":"2024-10-16T15:18:01.4198621","DOB":"2024-10-18","DelTime":null,"Email":"qwe@gmail.com","EmailConfirmed":true,"GenderId":26,"IsLocked":null,"LockoutEnabled":true,"LockoutEnd":null,"ModifiedById":"9feae18c-6e8c-46fe-9d32-76e59a80cf35","ModifiedOn":"2024-10-16T15:19:16.4132166+07:00","Name":"qwe","NormalizedEmail":"QWE@GMAIL.COM","NormalizedUserName":"QWE@GMAIL.COM","Note":null,"PasswordHash":"AQAAAAIAAYagAAAAEGZ+ZavfD/6gvBs0Ml58Bc5Fz8hslEet9c1ZENd5X6CI78bmrzTvl7IFzyKIvQXFyg==","PhoneNumber":"123123123","PhoneNumberConfirmed":true,"RoleId":"b750fcb9-71f0-4434-a37e-1c3e0ab9461b","SecurityStamp":"ITWE3QV4ISZQSA3H2ZRVMAICOOA3CFCH","TwoFactorEnabled":false,"UserName":"qwe@gmail.com"}', N'["AccessFailedCount","ConcurrencyStamp","CreatedById","CreatedOn","DOB","DelTime","Email","EmailConfirmed","GenderId","IsLocked","LockoutEnabled","LockoutEnd","ModifiedById","ModifiedOn","Name","NormalizedEmail","NormalizedUserName","Note","PasswordHash","PhoneNumber","PhoneNumberConfirmed","RoleId","SecurityStamp","TwoFactorEnabled","UserName"]', NULL, NULL, N'{"Id":"9feae18c-6e8c-46fe-9d32-76e59a80cf35"}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1645, N'Update', N'SystemTask', N'SystemTask', CAST(N'2024-10-16T15:33:20.0041740' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"Code":"RolesProfile","CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-16T14:13:40","DelTime":null,"ModifiedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","ModifiedOn":"2024-10-16T15:33:19.9352184+07:00","Name":"RolesProfile","Note":null,"OrderNo":2,"ParentId":11}', N'["Code","CreatedById","CreatedOn","DelTime","ModifiedById","ModifiedOn","Name","Note","OrderNo","ParentId"]', NULL, NULL, N'{"Id":17}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1646, N'Update', N'AppUser', N'AppUser', CAST(N'2024-10-16T16:12:13.2518610' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"AccessFailedCount":0,"ConcurrencyStamp":"f5b430d6-3a0d-4119-8118-8c823c358cc5","CreatedById":null,"CreatedOn":"2024-10-16T15:18:01.4198621","DOB":"2024-10-18","DelTime":null,"Email":"qwe@gmail.com","EmailConfirmed":true,"GenderId":26,"IsLocked":null,"LockoutEnabled":true,"LockoutEnd":null,"ModifiedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","ModifiedOn":"2024-10-16T16:12:13.1948299+07:00","Name":"qwe","NormalizedEmail":"QWE@GMAIL.COM","NormalizedUserName":"QWE@GMAIL.COM","Note":null,"PasswordHash":"AQAAAAIAAYagAAAAEF+Wz1n6Z0ub43eKLg2aLBOJ+Bqemc6MVkuh5Wf6OJw50aKeQGDNVmGzP4IWxhrb4w==","PhoneNumber":"123123123","PhoneNumberConfirmed":true,"RoleId":"70ea0da2-45f4-44bc-809d-1becc2198498","SecurityStamp":"KACKZNSYWLKVMDLLEEY5UHWXGS7PIIGK","TwoFactorEnabled":false,"UserName":"qwe@gmail.com"}', N'["AccessFailedCount","ConcurrencyStamp","CreatedById","CreatedOn","DOB","DelTime","Email","EmailConfirmed","GenderId","IsLocked","LockoutEnabled","LockoutEnd","ModifiedById","ModifiedOn","Name","NormalizedEmail","NormalizedUserName","Note","PasswordHash","PhoneNumber","PhoneNumberConfirmed","RoleId","SecurityStamp","TwoFactorEnabled","UserName"]', NULL, NULL, N'{"Id":"9feae18c-6e8c-46fe-9d32-76e59a80cf35"}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1647, N'Create', N'Comment', N'Comment', CAST(N'2024-10-17T17:00:48.6961392' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-17T17:00:48.450554+07:00","DelTime":null,"Description":"123","ModifiedById":null,"ModifiedOn":null,"Note":null,"TicketId":17}', NULL, NULL, NULL, N'{"Id":-2147482647}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1651, N'Update', N'Comment', N'Comment', CAST(N'2024-10-17T17:17:50.4041701' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-17T17:00:48","DelTime":null,"Description":"321","ModifiedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","ModifiedOn":"2024-10-17T17:17:50.3776087+07:00","Note":null,"TicketId":17}', N'["CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","TicketId"]', NULL, NULL, N'{"Id":1}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1652, N'Update', N'Comment', N'Comment', CAST(N'2024-10-17T17:18:07.5197218' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-17T17:00:48","DelTime":"2024-10-17T17:18:07.5193412+07:00","Description":"321","ModifiedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","ModifiedOn":"2024-10-17T17:17:50.3776087","Note":null,"TicketId":17}', N'["CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","TicketId"]', NULL, NULL, N'{"Id":1}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1653, N'Create', N'Comment', N'Comment', CAST(N'2024-10-18T14:48:50.7769882' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-18T14:48:50.5949545+07:00","DelTime":null,"Description":"quick","ModifiedById":null,"ModifiedOn":null,"Note":null,"TicketId":17}', NULL, NULL, NULL, N'{"Id":-2147482647}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1654, N'Create', N'Comment', N'Comment', CAST(N'2024-10-18T14:49:21.5618296' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-18T14:49:21.5607078+07:00","DelTime":null,"Description":"asd","ModifiedById":null,"ModifiedOn":null,"Note":null,"TicketId":23}', NULL, NULL, NULL, N'{"Id":-2147482646}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1655, N'Create', N'Comment', N'Comment', CAST(N'2024-10-18T14:49:28.1096886' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-18T14:49:28.1091382+07:00","DelTime":null,"Description":"dsa","ModifiedById":null,"ModifiedOn":null,"Note":null,"TicketId":23}', NULL, NULL, NULL, N'{"Id":-2147482645}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1656, N'Create', N'Comment', N'Comment', CAST(N'2024-10-18T15:12:07.5716048' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-18T15:12:07.4931416+07:00","DelTime":null,"Description":"321","ModifiedById":null,"ModifiedOn":null,"Note":null,"TicketId":17}', NULL, NULL, NULL, N'{"Id":-2147482647}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1657, N'Update', N'Comment', N'Comment', CAST(N'2024-10-18T15:12:56.0412791' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-18T15:12:07","DelTime":null,"Description":"11111","ModifiedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","ModifiedOn":"2024-10-18T15:12:56.0399319+07:00","Note":null,"TicketId":17}', N'["CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","TicketId"]', NULL, NULL, N'{"Id":5}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1658, N'Update', N'AppRole', N'AppRole', CAST(N'2024-10-18T22:31:31.0136264' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"ConcurrencyStamp":null,"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-18T17:11:34","DelTime":null,"ModifiedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","ModifiedOn":"2024-10-18T22:31:30.9014344+07:00","Name":"test2222","NormalizedName":null,"Note":null}', N'["ConcurrencyStamp","CreatedById","CreatedOn","DelTime","ModifiedById","ModifiedOn","Name","NormalizedName","Note"]', NULL, NULL, N'{"Id":"bff28742-3bad-4431-83f7-7a81d75e3b31"}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1659, N'Create', N'SystemCode', N'SystemCode', CAST(N'2024-10-18T22:55:29.1893404' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"Code":"test","CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-18T22:55:29.1523784+07:00","DelTime":null,"Description":"test","ModifiedById":null,"ModifiedOn":null,"Note":null}', NULL, NULL, NULL, N'{"Id":-2147482647}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1660, N'Update', N'SystemCode', N'SystemCode', CAST(N'2024-10-18T22:55:39.4865536' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"Code":"test1233","CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-18T22:55:29","DelTime":null,"Description":"test123","ModifiedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","ModifiedOn":"2024-10-18T22:55:39.4856595+07:00","Note":null}', N'["Code","CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note"]', NULL, NULL, N'{"Id":14}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1661, N'Update', N'SystemCode', N'SystemCode', CAST(N'2024-10-18T22:56:01.4843945' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"Code":"test1233","CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-18T22:55:29","DelTime":"2024-10-18T22:56:01.4841492+07:00","Description":"test123","ModifiedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","ModifiedOn":"2024-10-18T22:55:39.4856595","Note":null}', N'["Code","CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note"]', NULL, NULL, N'{"Id":14}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1662, N'Update', N'SystemCodeDetail', N'SystemCodeDetail', CAST(N'2024-10-19T12:42:05.2789152' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"Code":"Pending","CreatedById":"d904d1b5-0a2c-4c39-9804-27b42f658ece","CreatedOn":"2024-09-11T15:31:53","DelTime":null,"Description":"Pending","ModifiedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","ModifiedOn":"2024-10-19T12:42:05.1144666+07:00","Note":null,"OrderNo":null,"SystemCodeId":7}', N'["Code","CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","OrderNo","SystemCodeId"]', NULL, NULL, N'{"Id":24}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1663, N'Create', N'Ticket', N'Ticket', CAST(N'2024-10-19T12:50:09.2817906' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"AssignedOn":null,"AssignedToId":null,"Attachment":null,"CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-19T12:50:09.2711057+07:00","DelTime":null,"Description":"222","ModifiedById":null,"ModifiedOn":null,"Note":null,"PriorityId":21,"StatusId":15,"SubCategoryId":3,"Title":"222"}', NULL, NULL, NULL, N'{"Id":-2147482647}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1664, N'Update', N'Ticket', N'Ticket', CAST(N'2024-10-19T12:50:57.7416094' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"AssignedOn":null,"AssignedToId":null,"Attachment":"23232_2024-10-19_Mau-giay-xac-nhan-thuc-tap.doc","CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-19T12:50:09","DelTime":null,"Description":"232323","ModifiedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","ModifiedOn":"2024-10-19T12:50:57.7413134+07:00","Note":null,"PriorityId":21,"StatusId":15,"SubCategoryId":2,"Title":"23232"}', N'["AssignedOn","AssignedToId","Attachment","CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","PriorityId","StatusId","SubCategoryId","Title"]', NULL, NULL, N'{"Id":25}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1665, N'Update', N'Ticket', N'Ticket', CAST(N'2024-10-19T12:51:04.3337784' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"AssignedOn":null,"AssignedToId":null,"Attachment":"23232_2024-10-19_Mau-giay-xac-nhan-thuc-tap.doc","CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-19T12:50:09","DelTime":"2024-10-19T12:51:04.3331435+07:00","Description":"232323","ModifiedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","ModifiedOn":"2024-10-19T12:50:57.7413134","Note":null,"PriorityId":21,"StatusId":15,"SubCategoryId":2,"Title":"23232"}', N'["AssignedOn","AssignedToId","Attachment","CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","PriorityId","StatusId","SubCategoryId","Title"]', NULL, NULL, N'{"Id":25}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1666, N'Create', N'SystemCode', N'SystemCode', CAST(N'2024-10-19T15:52:21.3842480' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"Code":"test","CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-19T15:52:21.2005651+07:00","DelTime":null,"Description":"tset","ModifiedById":null,"ModifiedOn":null,"Note":null}', NULL, NULL, NULL, N'{"Id":-2147482647}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1669, N'Create', N'SystemCodeDetail', N'SystemCodeDetail', CAST(N'2024-10-19T15:56:28.3123913' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"Code":"test","CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-19T15:56:28.2632065+07:00","DelTime":null,"Description":"test","ModifiedById":null,"ModifiedOn":null,"Note":null,"OrderNo":null,"SystemCodeId":15}', NULL, NULL, NULL, N'{"Id":-2147482647}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1671, N'Update', N'SystemCodeDetail', N'SystemCodeDetail', CAST(N'2024-10-19T16:00:20.3992748' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"Code":"test123","CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-19T15:56:28","DelTime":null,"Description":"test123","ModifiedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","ModifiedOn":"2024-10-19T16:00:20.3709218+07:00","Note":null,"OrderNo":null,"SystemCodeId":15}', N'["Code","CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","OrderNo","SystemCodeId"]', NULL, NULL, N'{"Id":31}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1672, N'Update', N'SystemCodeDetail', N'SystemCodeDetail', CAST(N'2024-10-19T16:00:24.4655892' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"Code":"test123","CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-19T15:56:28","DelTime":"2024-10-19T16:00:24.4653033+07:00","Description":"test123","ModifiedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","ModifiedOn":"2024-10-19T16:00:20.3709218","Note":null,"OrderNo":null,"SystemCodeId":15}', N'["Code","CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note","OrderNo","SystemCodeId"]', NULL, NULL, N'{"Id":31}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1673, N'Update', N'SystemCode', N'SystemCode', CAST(N'2024-10-19T16:00:47.9945182' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"Code":"test","CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-19T15:52:21.2005651","DelTime":"2024-10-19T16:00:47.9914713+07:00","Description":"tset","ModifiedById":null,"ModifiedOn":null,"Note":null}', N'["Code","CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note"]', NULL, NULL, N'{"Id":15}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1674, N'Update', N'SystemCode', N'SystemCode', CAST(N'2024-10-19T16:01:03.3849274' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"Code":"Action","CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-08T15:51:59","DelTime":null,"Description":"Audit Trail Action 123","ModifiedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","ModifiedOn":"2024-10-19T16:01:03.3843903+07:00","Note":null}', N'["Code","CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note"]', NULL, NULL, N'{"Id":13}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1675, N'Update', N'SystemCode', N'SystemCode', CAST(N'2024-10-19T16:01:07.4106427' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"Code":"Action","CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-08T15:51:59","DelTime":null,"Description":"Audit Trail Action ","ModifiedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","ModifiedOn":"2024-10-19T16:01:07.4101909+07:00","Note":null}', N'["Code","CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note"]', NULL, NULL, N'{"Id":13}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1676, N'Update', N'SystemCode', N'SystemCode', CAST(N'2024-10-19T16:01:14.7425518' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"Code":"Action","CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-08T15:51:59","DelTime":null,"Description":"Audit Trail Action","ModifiedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","ModifiedOn":"2024-10-19T16:01:14.7419719+07:00","Note":null}', N'["Code","CreatedById","CreatedOn","DelTime","Description","ModifiedById","ModifiedOn","Note"]', NULL, NULL, N'{"Id":13}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1677, N'Create', N'SystemTask', N'SystemTask', CAST(N'2024-10-19T16:49:28.5011013' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"Code":"tse","CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-19T16:49:28.4637278+07:00","DelTime":null,"ModifiedById":null,"ModifiedOn":null,"Name":"tse","Note":null,"OrderNo":1,"ParentId":null}', NULL, NULL, NULL, N'{"Id":-2147482647}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1678, N'Update', N'SystemTask', N'SystemTask', CAST(N'2024-10-19T16:49:37.8632692' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"Code":"tse","CreatedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","CreatedOn":"2024-10-19T16:49:28","DelTime":null,"ModifiedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","ModifiedOn":"2024-10-19T16:49:37.8622513+07:00","Name":"tse","Note":null,"OrderNo":1,"ParentId":3}', N'["Code","CreatedById","CreatedOn","DelTime","ModifiedById","ModifiedOn","Name","Note","OrderNo","ParentId"]', NULL, NULL, N'{"Id":19}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1679, N'Update', N'AppRole', N'AppRole', CAST(N'2024-10-19T18:46:58.9505522' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"ConcurrencyStamp":null,"CreatedById":null,"CreatedOn":"0001-01-01T00:00:00","DelTime":null,"ModifiedById":"1f70a729-996a-45de-b002-0e2b62ab2d8c","ModifiedOn":"2024-10-19T18:46:58.8644261+07:00","Name":"test123","NormalizedName":null,"Note":null}', N'["ConcurrencyStamp","CreatedById","CreatedOn","DelTime","ModifiedById","ModifiedOn","Name","NormalizedName","Note"]', NULL, NULL, N'{"Id":"27c5880b-5900-4a54-b9ae-7de5f24c73f1"}')
INSERT [dbo].[AuditTrails] ([Id], [Action], [Module], [AffectedTable], [TimeStamp], [UserId], [OldValues], [NewValues], [AffectedColumns], [DelTime], [Note], [PrimaryKey]) VALUES (1680, N'Update', N'AppUser', N'AppUser', CAST(N'2024-10-19T19:07:00.9822269' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', NULL, N'{"AccessFailedCount":0,"ConcurrencyStamp":"9ce52d95-5a2b-4631-83bf-62558c20f0c3","CreatedById":null,"CreatedOn":"0001-01-01T00:00:00","DOB":"2024-10-16","DelTime":"2024-10-19T19:07:00.9522821+07:00","Email":"test3@gmail.com","EmailConfirmed":true,"GenderId":26,"IsLocked":null,"LockoutEnabled":true,"LockoutEnd":null,"ModifiedById":"8788c5e7-1463-4215-99fe-8701d5e83199","ModifiedOn":"2024-10-07T15:05:08.0913994","Name":"test3","NormalizedEmail":"TEST3@GMAIL.COM","NormalizedUserName":"TEST3@GMAIL.COM","Note":null,"PasswordHash":"AQAAAAIAAYagAAAAEOWg6DpLlEex7tDZ+s+bRTk1cWpuETbV7+JAVI1uzvrxrvb8o67YVt+uYWm+vOgYKw==","PhoneNumber":"12312312312","PhoneNumberConfirmed":true,"RoleId":"b750fcb9-71f0-4434-a37e-1c3e0ab9461b","SecurityStamp":"BX6KDT4BRYJ4U22ISEOLBIOKVEGGI4FO","TwoFactorEnabled":false,"UserName":"test3@gmail.com"}', N'["AccessFailedCount","ConcurrencyStamp","CreatedById","CreatedOn","DOB","DelTime","Email","EmailConfirmed","GenderId","IsLocked","LockoutEnabled","LockoutEnd","ModifiedById","ModifiedOn","Name","NormalizedEmail","NormalizedUserName","Note","PasswordHash","PhoneNumber","PhoneNumberConfirmed","RoleId","SecurityStamp","TwoFactorEnabled","UserName"]', NULL, NULL, N'{"Id":"147df890-1c7c-4fc5-a78b-0262e832f25c"}')
SET IDENTITY_INSERT [dbo].[AuditTrails] OFF
GO
SET IDENTITY_INSERT [dbo].[Comments] ON 

INSERT [dbo].[Comments] ([Id], [Description], [TicketId], [CreatedById], [CreatedOn], [DelTime], [Note], [ModifiedById], [ModifiedOn]) VALUES (1, N'321', 17, N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-17T17:00:48.0000000' AS DateTime2), CAST(N'2024-10-17T17:18:07.5193412' AS DateTime2), NULL, N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-17T17:17:50.3776087' AS DateTime2))
INSERT [dbo].[Comments] ([Id], [Description], [TicketId], [CreatedById], [CreatedOn], [DelTime], [Note], [ModifiedById], [ModifiedOn]) VALUES (2, N'quick', 17, N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-18T14:48:50.5949545' AS DateTime2), NULL, NULL, NULL, NULL)
INSERT [dbo].[Comments] ([Id], [Description], [TicketId], [CreatedById], [CreatedOn], [DelTime], [Note], [ModifiedById], [ModifiedOn]) VALUES (3, N'asd', 23, N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-18T14:49:21.5607078' AS DateTime2), NULL, NULL, NULL, NULL)
INSERT [dbo].[Comments] ([Id], [Description], [TicketId], [CreatedById], [CreatedOn], [DelTime], [Note], [ModifiedById], [ModifiedOn]) VALUES (4, N'dsa', 23, N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-18T14:49:28.1091382' AS DateTime2), NULL, NULL, NULL, NULL)
INSERT [dbo].[Comments] ([Id], [Description], [TicketId], [CreatedById], [CreatedOn], [DelTime], [Note], [ModifiedById], [ModifiedOn]) VALUES (5, N'11111', 17, N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-18T15:12:07.0000000' AS DateTime2), NULL, NULL, N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-18T15:12:56.0399319' AS DateTime2))
SET IDENTITY_INSERT [dbo].[Comments] OFF
GO
SET IDENTITY_INSERT [dbo].[SystemCodeDetails] ON 

INSERT [dbo].[SystemCodeDetails] ([Id], [Code], [Description], [OrderNo], [SystemCodeId], [DelTime], [Note], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn]) VALUES (15, N'Pending', N'Pending', NULL, 5, NULL, NULL, N'd904d1b5-0a2c-4c39-9804-27b42f658ece', CAST(N'2024-09-11T15:30:02.1726342' AS DateTime2), NULL, NULL)
INSERT [dbo].[SystemCodeDetails] ([Id], [Code], [Description], [OrderNo], [SystemCodeId], [DelTime], [Note], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn]) VALUES (16, N'Waiting', N'Waiting', NULL, 5, NULL, NULL, N'd904d1b5-0a2c-4c39-9804-27b42f658ece', CAST(N'2024-09-11T15:30:16.7055067' AS DateTime2), NULL, NULL)
INSERT [dbo].[SystemCodeDetails] ([Id], [Code], [Description], [OrderNo], [SystemCodeId], [DelTime], [Note], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn]) VALUES (17, N'Assigned', N'Assigned', NULL, 5, NULL, NULL, N'd904d1b5-0a2c-4c39-9804-27b42f658ece', CAST(N'2024-09-11T15:30:45.7726954' AS DateTime2), NULL, NULL)
INSERT [dbo].[SystemCodeDetails] ([Id], [Code], [Description], [OrderNo], [SystemCodeId], [DelTime], [Note], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn]) VALUES (18, N'Closed', N'Closed', NULL, 5, NULL, NULL, N'd904d1b5-0a2c-4c39-9804-27b42f658ece', CAST(N'2024-09-11T15:30:53.1591405' AS DateTime2), NULL, NULL)
INSERT [dbo].[SystemCodeDetails] ([Id], [Code], [Description], [OrderNo], [SystemCodeId], [DelTime], [Note], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn]) VALUES (19, N'Resolved', N'Resolved', NULL, 5, NULL, NULL, N'd904d1b5-0a2c-4c39-9804-27b42f658ece', CAST(N'2024-09-11T15:31:03.3007636' AS DateTime2), NULL, NULL)
INSERT [dbo].[SystemCodeDetails] ([Id], [Code], [Description], [OrderNo], [SystemCodeId], [DelTime], [Note], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn]) VALUES (20, N'ReOpen', N'Re-open', NULL, 5, NULL, NULL, N'd904d1b5-0a2c-4c39-9804-27b42f658ece', CAST(N'2024-09-11T15:31:15.5867151' AS DateTime2), NULL, NULL)
INSERT [dbo].[SystemCodeDetails] ([Id], [Code], [Description], [OrderNo], [SystemCodeId], [DelTime], [Note], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn]) VALUES (21, N'Low', N'Low', NULL, 6, NULL, NULL, N'd904d1b5-0a2c-4c39-9804-27b42f658ece', CAST(N'2024-09-11T15:31:27.6116464' AS DateTime2), NULL, NULL)
INSERT [dbo].[SystemCodeDetails] ([Id], [Code], [Description], [OrderNo], [SystemCodeId], [DelTime], [Note], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn]) VALUES (22, N'Medium', N'Medium', NULL, 6, NULL, NULL, N'd904d1b5-0a2c-4c39-9804-27b42f658ece', CAST(N'2024-09-11T15:31:34.2691151' AS DateTime2), NULL, NULL)
INSERT [dbo].[SystemCodeDetails] ([Id], [Code], [Description], [OrderNo], [SystemCodeId], [DelTime], [Note], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn]) VALUES (23, N'High', N'High', NULL, 6, NULL, NULL, N'd904d1b5-0a2c-4c39-9804-27b42f658ece', CAST(N'2024-09-11T15:31:41.2697951' AS DateTime2), NULL, NULL)
INSERT [dbo].[SystemCodeDetails] ([Id], [Code], [Description], [OrderNo], [SystemCodeId], [DelTime], [Note], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn]) VALUES (24, N'Pending', N'Pending', NULL, 7, NULL, NULL, N'd904d1b5-0a2c-4c39-9804-27b42f658ece', CAST(N'2024-09-11T15:31:53.0000000' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-19T12:42:05.1144666' AS DateTime2))
INSERT [dbo].[SystemCodeDetails] ([Id], [Code], [Description], [OrderNo], [SystemCodeId], [DelTime], [Note], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn]) VALUES (25, N'Resolved', N'Resolved', NULL, 7, NULL, NULL, N'd904d1b5-0a2c-4c39-9804-27b42f658ece', CAST(N'2024-09-11T15:32:00.9155002' AS DateTime2), NULL, NULL)
INSERT [dbo].[SystemCodeDetails] ([Id], [Code], [Description], [OrderNo], [SystemCodeId], [DelTime], [Note], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn]) VALUES (26, N'Male', N'Male', NULL, 12, NULL, NULL, N'd904d1b5-0a2c-4c39-9804-27b42f658ece', CAST(N'2024-09-11T15:32:00.9155002' AS DateTime2), NULL, NULL)
INSERT [dbo].[SystemCodeDetails] ([Id], [Code], [Description], [OrderNo], [SystemCodeId], [DelTime], [Note], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn]) VALUES (27, N'Female', N'Female', NULL, 12, NULL, NULL, N'd904d1b5-0a2c-4c39-9804-27b42f658ece', CAST(N'2024-09-11T15:32:00.9155002' AS DateTime2), NULL, NULL)
INSERT [dbo].[SystemCodeDetails] ([Id], [Code], [Description], [OrderNo], [SystemCodeId], [DelTime], [Note], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn]) VALUES (28, N'Create', N'Create', 1, 13, NULL, NULL, N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-08T15:52:49.8127096' AS DateTime2), NULL, NULL)
INSERT [dbo].[SystemCodeDetails] ([Id], [Code], [Description], [OrderNo], [SystemCodeId], [DelTime], [Note], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn]) VALUES (29, N'Edit', N'Edit', 2, 13, NULL, NULL, N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-08T15:53:04.5264527' AS DateTime2), NULL, NULL)
INSERT [dbo].[SystemCodeDetails] ([Id], [Code], [Description], [OrderNo], [SystemCodeId], [DelTime], [Note], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn]) VALUES (30, N'Delete', N'Delete', 3, 13, NULL, NULL, N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-08T15:53:22.8287026' AS DateTime2), NULL, NULL)
INSERT [dbo].[SystemCodeDetails] ([Id], [Code], [Description], [OrderNo], [SystemCodeId], [DelTime], [Note], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn]) VALUES (31, N'test123', N'test123', NULL, 15, CAST(N'2024-10-19T16:00:24.4653033' AS DateTime2), NULL, N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-19T15:56:28.0000000' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-19T16:00:20.3709218' AS DateTime2))
SET IDENTITY_INSERT [dbo].[SystemCodeDetails] OFF
GO
SET IDENTITY_INSERT [dbo].[SystemCodes] ON 

INSERT [dbo].[SystemCodes] ([Id], [Code], [Description], [DelTime], [Note], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn]) VALUES (5, N'Status', N'Ticket Status', NULL, NULL, N'd904d1b5-0a2c-4c39-9804-27b42f658ece', CAST(N'2024-09-11T15:27:58.3910685' AS DateTime2), NULL, NULL)
INSERT [dbo].[SystemCodes] ([Id], [Code], [Description], [DelTime], [Note], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn]) VALUES (6, N'Priority', N'Ticket Priorities', NULL, NULL, N'd904d1b5-0a2c-4c39-9804-27b42f658ece', CAST(N'2024-09-11T15:28:07.7539039' AS DateTime2), NULL, NULL)
INSERT [dbo].[SystemCodes] ([Id], [Code], [Description], [DelTime], [Note], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn]) VALUES (7, N'ResolutionStatus', N'Ticket Resolution Status', NULL, NULL, N'd904d1b5-0a2c-4c39-9804-27b42f658ece', CAST(N'2024-09-11T15:28:21.9453305' AS DateTime2), NULL, NULL)
INSERT [dbo].[SystemCodes] ([Id], [Code], [Description], [DelTime], [Note], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn]) VALUES (12, N'Gender', N'Gender', NULL, NULL, N'd904d1b5-0a2c-4c39-9804-27b42f658ece', CAST(N'2024-09-11T15:28:21.9453305' AS DateTime2), NULL, NULL)
INSERT [dbo].[SystemCodes] ([Id], [Code], [Description], [DelTime], [Note], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn]) VALUES (13, N'Action', N'Audit Trail Action', NULL, NULL, N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-08T15:51:59.0000000' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-19T16:01:14.7419719' AS DateTime2))
INSERT [dbo].[SystemCodes] ([Id], [Code], [Description], [DelTime], [Note], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn]) VALUES (14, N'test1233', N'test123', CAST(N'2024-10-18T22:56:01.4841492' AS DateTime2), NULL, N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-18T22:55:29.0000000' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-18T22:55:39.4856595' AS DateTime2))
INSERT [dbo].[SystemCodes] ([Id], [Code], [Description], [DelTime], [Note], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn]) VALUES (15, N'test', N'tset', CAST(N'2024-10-19T16:00:47.9914713' AS DateTime2), NULL, N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-19T15:52:21.2005651' AS DateTime2), NULL, NULL)
SET IDENTITY_INSERT [dbo].[SystemCodes] OFF
GO
SET IDENTITY_INSERT [dbo].[SystemSettings] ON 

INSERT [dbo].[SystemSettings] ([Id], [Code], [Name], [Value], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn], [DelTime], [Note]) VALUES (1, N'test', N'test', 5, N'd904d1b5-0a2c-4c39-9804-27b42f658ece', CAST(N'2024-09-11T17:18:08.7613531' AS DateTime2), NULL, NULL, NULL, NULL)
INSERT [dbo].[SystemSettings] ([Id], [Code], [Name], [Value], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn], [DelTime], [Note]) VALUES (2, N'TicketResolutionDays', N'Ticket Resolution Days', 5, N'd904d1b5-0a2c-4c39-9804-27b42f658ece', CAST(N'2024-09-11T17:39:16.0000000' AS DateTime2), N'd904d1b5-0a2c-4c39-9804-27b42f658ece', CAST(N'2024-09-11T17:40:37.1962082' AS DateTime2), NULL, NULL)
SET IDENTITY_INSERT [dbo].[SystemSettings] OFF
GO
SET IDENTITY_INSERT [dbo].[SystemTasks] ON 

INSERT [dbo].[SystemTasks] ([Id], [ParentId], [Code], [Name], [OrderNo], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn], [DelTime], [Note]) VALUES (1, NULL, N'Dashboard', N'Dashboard', 1, N'd904d1b5-0a2c-4c39-9804-27b42f658ece', CAST(N'2024-09-11T15:48:23.0000000' AS DateTime2), N'd904d1b5-0a2c-4c39-9804-27b42f658ece', CAST(N'2024-09-11T16:00:23.4245241' AS DateTime2), NULL, NULL)
INSERT [dbo].[SystemTasks] ([Id], [ParentId], [Code], [Name], [OrderNo], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn], [DelTime], [Note]) VALUES (2, NULL, N'Tickets', N'Tickets', 1, N'd904d1b5-0a2c-4c39-9804-27b42f658ece', CAST(N'2024-09-11T15:50:04.0000000' AS DateTime2), N'd904d1b5-0a2c-4c39-9804-27b42f658ece', CAST(N'2024-09-11T16:02:50.7795614' AS DateTime2), NULL, NULL)
INSERT [dbo].[SystemTasks] ([Id], [ParentId], [Code], [Name], [OrderNo], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn], [DelTime], [Note]) VALUES (3, 2, N'Comments', N'Ticket Comments', 2, N'd904d1b5-0a2c-4c39-9804-27b42f658ece', CAST(N'2024-09-11T15:50:19.0000000' AS DateTime2), N'd904d1b5-0a2c-4c39-9804-27b42f658ece', CAST(N'2024-09-11T16:05:19.0866891' AS DateTime2), NULL, NULL)
INSERT [dbo].[SystemTasks] ([Id], [ParentId], [Code], [Name], [OrderNo], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn], [DelTime], [Note]) VALUES (5, 15, N'AuditTrails', N'Audit Trails', 2, N'd904d1b5-0a2c-4c39-9804-27b42f658ece', CAST(N'2024-09-11T16:03:24.0000000' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-16T14:19:12.8604627' AS DateTime2), NULL, NULL)
INSERT [dbo].[SystemTasks] ([Id], [ParentId], [Code], [Name], [OrderNo], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn], [DelTime], [Note]) VALUES (6, NULL, N'TicketCategories', N'Ticket Categories', 1, N'd904d1b5-0a2c-4c39-9804-27b42f658ece', CAST(N'2024-09-11T16:03:58.8103929' AS DateTime2), NULL, NULL, NULL, NULL)
INSERT [dbo].[SystemTasks] ([Id], [ParentId], [Code], [Name], [OrderNo], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn], [DelTime], [Note]) VALUES (7, 6, N'TicketSubCategories', N'Ticket Sub-Categories', 2, N'd904d1b5-0a2c-4c39-9804-27b42f658ece', CAST(N'2024-09-11T16:05:09.0978524' AS DateTime2), NULL, NULL, NULL, NULL)
INSERT [dbo].[SystemTasks] ([Id], [ParentId], [Code], [Name], [OrderNo], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn], [DelTime], [Note]) VALUES (8, 15, N'SystemCodes', N'System Codes', 2, N'd904d1b5-0a2c-4c39-9804-27b42f658ece', CAST(N'2024-09-11T16:06:01.0000000' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-16T14:16:37.0230303' AS DateTime2), NULL, NULL)
INSERT [dbo].[SystemTasks] ([Id], [ParentId], [Code], [Name], [OrderNo], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn], [DelTime], [Note]) VALUES (9, 8, N'SystemCodeDetails', N'System Code Details', 3, N'd904d1b5-0a2c-4c39-9804-27b42f658ece', CAST(N'2024-09-11T16:06:21.0000000' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-16T14:16:47.9649883' AS DateTime2), NULL, NULL)
INSERT [dbo].[SystemTasks] ([Id], [ParentId], [Code], [Name], [OrderNo], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn], [DelTime], [Note]) VALUES (10, NULL, N'Users', N'Users', 1, N'd904d1b5-0a2c-4c39-9804-27b42f658ece', CAST(N'2024-09-11T16:06:30.8011955' AS DateTime2), NULL, NULL, NULL, NULL)
INSERT [dbo].[SystemTasks] ([Id], [ParentId], [Code], [Name], [OrderNo], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn], [DelTime], [Note]) VALUES (11, NULL, N'Roles', N'Roles', 1, N'd904d1b5-0a2c-4c39-9804-27b42f658ece', CAST(N'2024-09-11T16:06:46.8468660' AS DateTime2), NULL, NULL, NULL, NULL)
INSERT [dbo].[SystemTasks] ([Id], [ParentId], [Code], [Name], [OrderNo], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn], [DelTime], [Note]) VALUES (12, 15, N'SystemTasks', N'System Tasks', 2, N'd904d1b5-0a2c-4c39-9804-27b42f658ece', CAST(N'2024-09-11T16:07:06.0000000' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-16T14:17:26.6413800' AS DateTime2), NULL, NULL)
INSERT [dbo].[SystemTasks] ([Id], [ParentId], [Code], [Name], [OrderNo], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn], [DelTime], [Note]) VALUES (13, NULL, N'Logout', N'Logout', 1, N'd904d1b5-0a2c-4c39-9804-27b42f658ece', CAST(N'2024-09-11T16:07:35.0759828' AS DateTime2), NULL, NULL, NULL, NULL)
INSERT [dbo].[SystemTasks] ([Id], [ParentId], [Code], [Name], [OrderNo], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn], [DelTime], [Note]) VALUES (14, NULL, N'Departments', N'Departments', 1, N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-16T14:04:49.6660492' AS DateTime2), NULL, NULL, NULL, NULL)
INSERT [dbo].[SystemTasks] ([Id], [ParentId], [Code], [Name], [OrderNo], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn], [DelTime], [Note]) VALUES (15, NULL, N'System', N'System', 1, N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-16T14:08:33.3182321' AS DateTime2), NULL, NULL, NULL, NULL)
INSERT [dbo].[SystemTasks] ([Id], [ParentId], [Code], [Name], [OrderNo], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn], [DelTime], [Note]) VALUES (16, 15, N'SystemSettings', N'System Settings', 2, N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-16T14:09:22.0303487' AS DateTime2), NULL, NULL, NULL, NULL)
INSERT [dbo].[SystemTasks] ([Id], [ParentId], [Code], [Name], [OrderNo], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn], [DelTime], [Note]) VALUES (17, 11, N'RolesProfile', N'RolesProfile', 2, N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-16T14:13:40.0000000' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-16T15:33:19.9352184' AS DateTime2), NULL, NULL)
INSERT [dbo].[SystemTasks] ([Id], [ParentId], [Code], [Name], [OrderNo], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn], [DelTime], [Note]) VALUES (18, 15, N'ErrorLogs', N'Error Logs', 2, N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-16T14:18:48.4953273' AS DateTime2), NULL, NULL, NULL, NULL)
INSERT [dbo].[SystemTasks] ([Id], [ParentId], [Code], [Name], [OrderNo], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn], [DelTime], [Note]) VALUES (19, 3, N'tse', N'tse', 1, N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-19T16:49:28.0000000' AS DateTime2), N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-19T16:49:37.8622513' AS DateTime2), NULL, NULL)
SET IDENTITY_INSERT [dbo].[SystemTasks] OFF
GO
SET IDENTITY_INSERT [dbo].[TicketCategories] ON 

INSERT [dbo].[TicketCategories] ([Id], [Code], [Name], [DelTime], [Note], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn]) VALUES (2, N'Default', N'Default Tickets', NULL, NULL, N'd904d1b5-0a2c-4c39-9804-27b42f658ece', CAST(N'2024-09-11T15:28:52.7699021' AS DateTime2), NULL, NULL)
INSERT [dbo].[TicketCategories] ([Id], [Code], [Name], [DelTime], [Note], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn]) VALUES (3, N'hehe', N'hehe', NULL, NULL, N'd904d1b5-0a2c-4c39-9804-27b42f658ece', CAST(N'2024-09-11T15:28:58.2744358' AS DateTime2), NULL, NULL)
SET IDENTITY_INSERT [dbo].[TicketCategories] OFF
GO
SET IDENTITY_INSERT [dbo].[TicketResolutions] ON 

INSERT [dbo].[TicketResolutions] ([Id], [TicketId], [Description], [StatusId], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn], [DelTime], [Note]) VALUES (1057, 17, N'Assign to user sssss', 17, N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-11T23:46:04.3724726' AS DateTime2), NULL, NULL, NULL, NULL)
INSERT [dbo].[TicketResolutions] ([Id], [TicketId], [Description], [StatusId], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn], [DelTime], [Note]) VALUES (1059, 17, N'3123', 16, N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-11T23:46:21.6269808' AS DateTime2), NULL, NULL, NULL, NULL)
INSERT [dbo].[TicketResolutions] ([Id], [TicketId], [Description], [StatusId], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn], [DelTime], [Note]) VALUES (1061, 17, N'dinbe', 19, N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-12T15:37:39.5095420' AS DateTime2), NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[TicketResolutions] OFF
GO
SET IDENTITY_INSERT [dbo].[Tickets] ON 

INSERT [dbo].[Tickets] ([Id], [Title], [Description], [CreatedById], [CreatedOn], [DelTime], [Note], [SubCategoryId], [PriorityId], [StatusId], [Attachment], [AssignedOn], [AssignedToId], [ModifiedById], [ModifiedOn]) VALUES (17, N'111', N'111', N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-11T23:45:54.5432361' AS DateTime2), NULL, NULL, 2, 23, 19, NULL, CAST(N'2024-10-11T23:46:04.3723249' AS DateTime2), N'3a55e370-2d81-4506-96fe-e6c614ed44e8', NULL, NULL)
INSERT [dbo].[Tickets] ([Id], [Title], [Description], [CreatedById], [CreatedOn], [DelTime], [Note], [SubCategoryId], [PriorityId], [StatusId], [Attachment], [AssignedOn], [AssignedToId], [ModifiedById], [ModifiedOn]) VALUES (20, N'aaaa', N'aaa', N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-15T14:42:34.0000000' AS DateTime2), NULL, NULL, 2, 21, 15, NULL, NULL, NULL, N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-15T14:44:02.6455455' AS DateTime2))
INSERT [dbo].[Tickets] ([Id], [Title], [Description], [CreatedById], [CreatedOn], [DelTime], [Note], [SubCategoryId], [PriorityId], [StatusId], [Attachment], [AssignedOn], [AssignedToId], [ModifiedById], [ModifiedOn]) VALUES (21, N'bb', N'bb', N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-15T14:42:54.0128126' AS DateTime2), NULL, NULL, 2, 21, 15, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[Tickets] ([Id], [Title], [Description], [CreatedById], [CreatedOn], [DelTime], [Note], [SubCategoryId], [PriorityId], [StatusId], [Attachment], [AssignedOn], [AssignedToId], [ModifiedById], [ModifiedOn]) VALUES (22, N'ggg', N'gg', N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-15T14:43:22.0984792' AS DateTime2), NULL, NULL, 2, 21, 15, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[Tickets] ([Id], [Title], [Description], [CreatedById], [CreatedOn], [DelTime], [Note], [SubCategoryId], [PriorityId], [StatusId], [Attachment], [AssignedOn], [AssignedToId], [ModifiedById], [ModifiedOn]) VALUES (23, N'ccc', N'ccc', N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-15T14:43:37.0508173' AS DateTime2), NULL, NULL, 2, 21, 15, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[Tickets] ([Id], [Title], [Description], [CreatedById], [CreatedOn], [DelTime], [Note], [SubCategoryId], [PriorityId], [StatusId], [Attachment], [AssignedOn], [AssignedToId], [ModifiedById], [ModifiedOn]) VALUES (24, N'd', N'd', N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-15T14:44:16.9305623' AS DateTime2), NULL, NULL, 2, 21, 15, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[Tickets] ([Id], [Title], [Description], [CreatedById], [CreatedOn], [DelTime], [Note], [SubCategoryId], [PriorityId], [StatusId], [Attachment], [AssignedOn], [AssignedToId], [ModifiedById], [ModifiedOn]) VALUES (25, N'23232', N'232323', N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-19T12:50:09.0000000' AS DateTime2), CAST(N'2024-10-19T12:51:04.3331435' AS DateTime2), NULL, 2, 21, 15, N'23232_2024-10-19_Mau-giay-xac-nhan-thuc-tap.doc', NULL, NULL, N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-19T12:50:57.7413134' AS DateTime2))
SET IDENTITY_INSERT [dbo].[Tickets] OFF
GO
SET IDENTITY_INSERT [dbo].[TicketSubCategories] ON 

INSERT [dbo].[TicketSubCategories] ([Id], [CategoryId], [Code], [Name], [DelTime], [Note], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn]) VALUES (2, 2, N'Defaultsub', N'Default sub Tickets', NULL, NULL, N'd904d1b5-0a2c-4c39-9804-27b42f658ece', CAST(N'2024-09-11T15:29:12.6915152' AS DateTime2), NULL, NULL)
INSERT [dbo].[TicketSubCategories] ([Id], [CategoryId], [Code], [Name], [DelTime], [Note], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn]) VALUES (3, 3, N'hehe', N'hehe', NULL, NULL, N'd904d1b5-0a2c-4c39-9804-27b42f658ece', CAST(N'2024-09-11T15:29:30.7987941' AS DateTime2), NULL, NULL)
SET IDENTITY_INSERT [dbo].[TicketSubCategories] OFF
GO
SET IDENTITY_INSERT [dbo].[UserRoleProfiles] ON 

INSERT [dbo].[UserRoleProfiles] ([Id], [TaskId], [RoleId], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn], [DelTime], [Note]) VALUES (147, 1, N'27c5880b-5900-4a54-b9ae-7de5f24c73f1', N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-16T13:39:42.7139940' AS DateTime2), NULL, NULL, NULL, NULL)
INSERT [dbo].[UserRoleProfiles] ([Id], [TaskId], [RoleId], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn], [DelTime], [Note]) VALUES (148, 2, N'27c5880b-5900-4a54-b9ae-7de5f24c73f1', N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-16T13:39:42.7440741' AS DateTime2), NULL, NULL, NULL, NULL)
INSERT [dbo].[UserRoleProfiles] ([Id], [TaskId], [RoleId], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn], [DelTime], [Note]) VALUES (149, 3, N'27c5880b-5900-4a54-b9ae-7de5f24c73f1', N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-16T13:39:42.7453723' AS DateTime2), NULL, NULL, NULL, NULL)
INSERT [dbo].[UserRoleProfiles] ([Id], [TaskId], [RoleId], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn], [DelTime], [Note]) VALUES (150, 1, N'70ea0da2-45f4-44bc-809d-1becc2198498', N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-16T13:40:03.7515288' AS DateTime2), NULL, NULL, NULL, NULL)
INSERT [dbo].[UserRoleProfiles] ([Id], [TaskId], [RoleId], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn], [DelTime], [Note]) VALUES (151, 2, N'70ea0da2-45f4-44bc-809d-1becc2198498', N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-16T13:40:03.7517203' AS DateTime2), NULL, NULL, NULL, NULL)
INSERT [dbo].[UserRoleProfiles] ([Id], [TaskId], [RoleId], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn], [DelTime], [Note]) VALUES (152, 3, N'70ea0da2-45f4-44bc-809d-1becc2198498', N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-16T13:40:03.7517876' AS DateTime2), NULL, NULL, NULL, NULL)
INSERT [dbo].[UserRoleProfiles] ([Id], [TaskId], [RoleId], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn], [DelTime], [Note]) VALUES (169, 1, N'b750fcb9-71f0-4434-a37e-1c3e0ab9461b', N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-16T15:04:05.3953418' AS DateTime2), NULL, NULL, NULL, NULL)
INSERT [dbo].[UserRoleProfiles] ([Id], [TaskId], [RoleId], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn], [DelTime], [Note]) VALUES (170, 2, N'b750fcb9-71f0-4434-a37e-1c3e0ab9461b', N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-16T15:04:19.5631948' AS DateTime2), NULL, NULL, NULL, NULL)
INSERT [dbo].[UserRoleProfiles] ([Id], [TaskId], [RoleId], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn], [DelTime], [Note]) VALUES (171, 3, N'b750fcb9-71f0-4434-a37e-1c3e0ab9461b', N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-16T15:04:22.2892417' AS DateTime2), NULL, NULL, NULL, NULL)
INSERT [dbo].[UserRoleProfiles] ([Id], [TaskId], [RoleId], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn], [DelTime], [Note]) VALUES (172, 6, N'b750fcb9-71f0-4434-a37e-1c3e0ab9461b', N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-16T15:04:24.4344430' AS DateTime2), NULL, NULL, NULL, NULL)
INSERT [dbo].[UserRoleProfiles] ([Id], [TaskId], [RoleId], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn], [DelTime], [Note]) VALUES (173, 7, N'b750fcb9-71f0-4434-a37e-1c3e0ab9461b', N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-16T15:04:26.9354541' AS DateTime2), NULL, NULL, NULL, NULL)
INSERT [dbo].[UserRoleProfiles] ([Id], [TaskId], [RoleId], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn], [DelTime], [Note]) VALUES (174, 10, N'b750fcb9-71f0-4434-a37e-1c3e0ab9461b', N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-16T15:04:29.1435849' AS DateTime2), NULL, NULL, NULL, NULL)
INSERT [dbo].[UserRoleProfiles] ([Id], [TaskId], [RoleId], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn], [DelTime], [Note]) VALUES (175, 17, N'b750fcb9-71f0-4434-a37e-1c3e0ab9461b', N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-16T15:04:31.8651849' AS DateTime2), NULL, NULL, NULL, NULL)
INSERT [dbo].[UserRoleProfiles] ([Id], [TaskId], [RoleId], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn], [DelTime], [Note]) VALUES (176, 11, N'b750fcb9-71f0-4434-a37e-1c3e0ab9461b', N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-16T15:04:38.8985758' AS DateTime2), NULL, NULL, NULL, NULL)
INSERT [dbo].[UserRoleProfiles] ([Id], [TaskId], [RoleId], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn], [DelTime], [Note]) VALUES (177, 13, N'b750fcb9-71f0-4434-a37e-1c3e0ab9461b', N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-16T15:04:41.7006827' AS DateTime2), NULL, NULL, NULL, NULL)
INSERT [dbo].[UserRoleProfiles] ([Id], [TaskId], [RoleId], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn], [DelTime], [Note]) VALUES (178, 14, N'b750fcb9-71f0-4434-a37e-1c3e0ab9461b', N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-16T15:04:45.7885580' AS DateTime2), NULL, NULL, NULL, NULL)
INSERT [dbo].[UserRoleProfiles] ([Id], [TaskId], [RoleId], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn], [DelTime], [Note]) VALUES (179, 15, N'b750fcb9-71f0-4434-a37e-1c3e0ab9461b', N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-16T15:04:50.6122819' AS DateTime2), NULL, NULL, NULL, NULL)
INSERT [dbo].[UserRoleProfiles] ([Id], [TaskId], [RoleId], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn], [DelTime], [Note]) VALUES (180, 5, N'b750fcb9-71f0-4434-a37e-1c3e0ab9461b', N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-16T15:04:56.6526400' AS DateTime2), NULL, NULL, NULL, NULL)
INSERT [dbo].[UserRoleProfiles] ([Id], [TaskId], [RoleId], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn], [DelTime], [Note]) VALUES (181, 8, N'b750fcb9-71f0-4434-a37e-1c3e0ab9461b', N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-16T15:05:04.5912581' AS DateTime2), NULL, NULL, NULL, NULL)
INSERT [dbo].[UserRoleProfiles] ([Id], [TaskId], [RoleId], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn], [DelTime], [Note]) VALUES (182, 12, N'b750fcb9-71f0-4434-a37e-1c3e0ab9461b', N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-16T15:05:08.4614345' AS DateTime2), NULL, NULL, NULL, NULL)
INSERT [dbo].[UserRoleProfiles] ([Id], [TaskId], [RoleId], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn], [DelTime], [Note]) VALUES (183, 16, N'b750fcb9-71f0-4434-a37e-1c3e0ab9461b', N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-16T15:05:12.3624263' AS DateTime2), NULL, NULL, NULL, NULL)
INSERT [dbo].[UserRoleProfiles] ([Id], [TaskId], [RoleId], [CreatedById], [CreatedOn], [ModifiedById], [ModifiedOn], [DelTime], [Note]) VALUES (184, 18, N'b750fcb9-71f0-4434-a37e-1c3e0ab9461b', N'1f70a729-996a-45de-b002-0e2b62ab2d8c', CAST(N'2024-10-16T15:05:16.5898718' AS DateTime2), NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[UserRoleProfiles] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_AspNetRoleClaims_RoleId]    Script Date: 10/21/2024 8:07:19 AM ******/
CREATE NONCLUSTERED INDEX [IX_AspNetRoleClaims_RoleId] ON [dbo].[AspNetRoleClaims]
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_AspNetRoles_CreatedById]    Script Date: 10/21/2024 8:07:19 AM ******/
CREATE NONCLUSTERED INDEX [IX_AspNetRoles_CreatedById] ON [dbo].[AspNetRoles]
(
	[CreatedById] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_AspNetRoles_ModifiedById]    Script Date: 10/21/2024 8:07:19 AM ******/
CREATE NONCLUSTERED INDEX [IX_AspNetRoles_ModifiedById] ON [dbo].[AspNetRoles]
(
	[ModifiedById] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [RoleNameIndex]    Script Date: 10/21/2024 8:07:19 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [RoleNameIndex] ON [dbo].[AspNetRoles]
(
	[NormalizedName] ASC
)
WHERE ([NormalizedName] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_AspNetUserClaims_UserId]    Script Date: 10/21/2024 8:07:19 AM ******/
CREATE NONCLUSTERED INDEX [IX_AspNetUserClaims_UserId] ON [dbo].[AspNetUserClaims]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_AspNetUserLogins_UserId]    Script Date: 10/21/2024 8:07:19 AM ******/
CREATE NONCLUSTERED INDEX [IX_AspNetUserLogins_UserId] ON [dbo].[AspNetUserLogins]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_AspNetUserRoles_RoleId]    Script Date: 10/21/2024 8:07:19 AM ******/
CREATE NONCLUSTERED INDEX [IX_AspNetUserRoles_RoleId] ON [dbo].[AspNetUserRoles]
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [EmailIndex]    Script Date: 10/21/2024 8:07:19 AM ******/
CREATE NONCLUSTERED INDEX [EmailIndex] ON [dbo].[AspNetUsers]
(
	[NormalizedEmail] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_AspNetUsers_CreatedById]    Script Date: 10/21/2024 8:07:19 AM ******/
CREATE NONCLUSTERED INDEX [IX_AspNetUsers_CreatedById] ON [dbo].[AspNetUsers]
(
	[CreatedById] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_AspNetUsers_GenderId]    Script Date: 10/21/2024 8:07:19 AM ******/
CREATE NONCLUSTERED INDEX [IX_AspNetUsers_GenderId] ON [dbo].[AspNetUsers]
(
	[GenderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_AspNetUsers_ModifiedById]    Script Date: 10/21/2024 8:07:19 AM ******/
CREATE NONCLUSTERED INDEX [IX_AspNetUsers_ModifiedById] ON [dbo].[AspNetUsers]
(
	[ModifiedById] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_AspNetUsers_RoleId]    Script Date: 10/21/2024 8:07:19 AM ******/
CREATE NONCLUSTERED INDEX [IX_AspNetUsers_RoleId] ON [dbo].[AspNetUsers]
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UserNameIndex]    Script Date: 10/21/2024 8:07:19 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UserNameIndex] ON [dbo].[AspNetUsers]
(
	[NormalizedUserName] ASC
)
WHERE ([NormalizedUserName] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_AuditTrails_UserId]    Script Date: 10/21/2024 8:07:19 AM ******/
CREATE NONCLUSTERED INDEX [IX_AuditTrails_UserId] ON [dbo].[AuditTrails]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Comments_CreatedById]    Script Date: 10/21/2024 8:07:19 AM ******/
CREATE NONCLUSTERED INDEX [IX_Comments_CreatedById] ON [dbo].[Comments]
(
	[CreatedById] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Comments_ModifiedById]    Script Date: 10/21/2024 8:07:19 AM ******/
CREATE NONCLUSTERED INDEX [IX_Comments_ModifiedById] ON [dbo].[Comments]
(
	[ModifiedById] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Comments_TicketId]    Script Date: 10/21/2024 8:07:19 AM ******/
CREATE NONCLUSTERED INDEX [IX_Comments_TicketId] ON [dbo].[Comments]
(
	[TicketId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Departments_CreatedById]    Script Date: 10/21/2024 8:07:19 AM ******/
CREATE NONCLUSTERED INDEX [IX_Departments_CreatedById] ON [dbo].[Departments]
(
	[CreatedById] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Departments_ModifiedById]    Script Date: 10/21/2024 8:07:19 AM ******/
CREATE NONCLUSTERED INDEX [IX_Departments_ModifiedById] ON [dbo].[Departments]
(
	[ModifiedById] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_SystemCodeDetails_CreatedById]    Script Date: 10/21/2024 8:07:19 AM ******/
CREATE NONCLUSTERED INDEX [IX_SystemCodeDetails_CreatedById] ON [dbo].[SystemCodeDetails]
(
	[CreatedById] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_SystemCodeDetails_ModifiedById]    Script Date: 10/21/2024 8:07:19 AM ******/
CREATE NONCLUSTERED INDEX [IX_SystemCodeDetails_ModifiedById] ON [dbo].[SystemCodeDetails]
(
	[ModifiedById] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_SystemCodeDetails_SystemCodeId]    Script Date: 10/21/2024 8:07:19 AM ******/
CREATE NONCLUSTERED INDEX [IX_SystemCodeDetails_SystemCodeId] ON [dbo].[SystemCodeDetails]
(
	[SystemCodeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_SystemCodes_CreatedById]    Script Date: 10/21/2024 8:07:19 AM ******/
CREATE NONCLUSTERED INDEX [IX_SystemCodes_CreatedById] ON [dbo].[SystemCodes]
(
	[CreatedById] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_SystemCodes_ModifiedById]    Script Date: 10/21/2024 8:07:19 AM ******/
CREATE NONCLUSTERED INDEX [IX_SystemCodes_ModifiedById] ON [dbo].[SystemCodes]
(
	[ModifiedById] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_SystemSettings_CreatedById]    Script Date: 10/21/2024 8:07:19 AM ******/
CREATE NONCLUSTERED INDEX [IX_SystemSettings_CreatedById] ON [dbo].[SystemSettings]
(
	[CreatedById] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_SystemSettings_ModifiedById]    Script Date: 10/21/2024 8:07:19 AM ******/
CREATE NONCLUSTERED INDEX [IX_SystemSettings_ModifiedById] ON [dbo].[SystemSettings]
(
	[ModifiedById] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_SystemTasks_CreatedById]    Script Date: 10/21/2024 8:07:19 AM ******/
CREATE NONCLUSTERED INDEX [IX_SystemTasks_CreatedById] ON [dbo].[SystemTasks]
(
	[CreatedById] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_SystemTasks_ModifiedById]    Script Date: 10/21/2024 8:07:19 AM ******/
CREATE NONCLUSTERED INDEX [IX_SystemTasks_ModifiedById] ON [dbo].[SystemTasks]
(
	[ModifiedById] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_SystemTasks_ParentId]    Script Date: 10/21/2024 8:07:19 AM ******/
CREATE NONCLUSTERED INDEX [IX_SystemTasks_ParentId] ON [dbo].[SystemTasks]
(
	[ParentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_TicketCategories_CreatedById]    Script Date: 10/21/2024 8:07:19 AM ******/
CREATE NONCLUSTERED INDEX [IX_TicketCategories_CreatedById] ON [dbo].[TicketCategories]
(
	[CreatedById] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_TicketCategories_ModifiedById]    Script Date: 10/21/2024 8:07:19 AM ******/
CREATE NONCLUSTERED INDEX [IX_TicketCategories_ModifiedById] ON [dbo].[TicketCategories]
(
	[ModifiedById] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_TicketResolutions_CreatedById]    Script Date: 10/21/2024 8:07:19 AM ******/
CREATE NONCLUSTERED INDEX [IX_TicketResolutions_CreatedById] ON [dbo].[TicketResolutions]
(
	[CreatedById] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_TicketResolutions_ModifiedById]    Script Date: 10/21/2024 8:07:19 AM ******/
CREATE NONCLUSTERED INDEX [IX_TicketResolutions_ModifiedById] ON [dbo].[TicketResolutions]
(
	[ModifiedById] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_TicketResolutions_StatusId]    Script Date: 10/21/2024 8:07:19 AM ******/
CREATE NONCLUSTERED INDEX [IX_TicketResolutions_StatusId] ON [dbo].[TicketResolutions]
(
	[StatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_TicketResolutions_TicketId]    Script Date: 10/21/2024 8:07:19 AM ******/
CREATE NONCLUSTERED INDEX [IX_TicketResolutions_TicketId] ON [dbo].[TicketResolutions]
(
	[TicketId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Tickets_AssignedToId]    Script Date: 10/21/2024 8:07:19 AM ******/
CREATE NONCLUSTERED INDEX [IX_Tickets_AssignedToId] ON [dbo].[Tickets]
(
	[AssignedToId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Tickets_CreatedById]    Script Date: 10/21/2024 8:07:19 AM ******/
CREATE NONCLUSTERED INDEX [IX_Tickets_CreatedById] ON [dbo].[Tickets]
(
	[CreatedById] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Tickets_ModifiedById]    Script Date: 10/21/2024 8:07:19 AM ******/
CREATE NONCLUSTERED INDEX [IX_Tickets_ModifiedById] ON [dbo].[Tickets]
(
	[ModifiedById] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Tickets_PriorityId]    Script Date: 10/21/2024 8:07:19 AM ******/
CREATE NONCLUSTERED INDEX [IX_Tickets_PriorityId] ON [dbo].[Tickets]
(
	[PriorityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Tickets_StatusId]    Script Date: 10/21/2024 8:07:19 AM ******/
CREATE NONCLUSTERED INDEX [IX_Tickets_StatusId] ON [dbo].[Tickets]
(
	[StatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Tickets_SubCategoryId]    Script Date: 10/21/2024 8:07:19 AM ******/
CREATE NONCLUSTERED INDEX [IX_Tickets_SubCategoryId] ON [dbo].[Tickets]
(
	[SubCategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_TicketSubCategories_CategoryId]    Script Date: 10/21/2024 8:07:19 AM ******/
CREATE NONCLUSTERED INDEX [IX_TicketSubCategories_CategoryId] ON [dbo].[TicketSubCategories]
(
	[CategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_TicketSubCategories_CreatedById]    Script Date: 10/21/2024 8:07:19 AM ******/
CREATE NONCLUSTERED INDEX [IX_TicketSubCategories_CreatedById] ON [dbo].[TicketSubCategories]
(
	[CreatedById] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_TicketSubCategories_ModifiedById]    Script Date: 10/21/2024 8:07:19 AM ******/
CREATE NONCLUSTERED INDEX [IX_TicketSubCategories_ModifiedById] ON [dbo].[TicketSubCategories]
(
	[ModifiedById] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_UserRoleProfiles_CreatedById]    Script Date: 10/21/2024 8:07:19 AM ******/
CREATE NONCLUSTERED INDEX [IX_UserRoleProfiles_CreatedById] ON [dbo].[UserRoleProfiles]
(
	[CreatedById] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_UserRoleProfiles_ModifiedById]    Script Date: 10/21/2024 8:07:19 AM ******/
CREATE NONCLUSTERED INDEX [IX_UserRoleProfiles_ModifiedById] ON [dbo].[UserRoleProfiles]
(
	[ModifiedById] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_UserRoleProfiles_RoleId]    Script Date: 10/21/2024 8:07:19 AM ******/
CREATE NONCLUSTERED INDEX [IX_UserRoleProfiles_RoleId] ON [dbo].[UserRoleProfiles]
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_UserRoleProfiles_TaskId]    Script Date: 10/21/2024 8:07:19 AM ******/
CREATE NONCLUSTERED INDEX [IX_UserRoleProfiles_TaskId] ON [dbo].[UserRoleProfiles]
(
	[TaskId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AspNetRoles] ADD  DEFAULT ('0001-01-01T00:00:00.0000000') FOR [CreatedOn]
GO
ALTER TABLE [dbo].[AspNetUsers] ADD  DEFAULT ('0001-01-01') FOR [DOB]
GO
ALTER TABLE [dbo].[AspNetUsers] ADD  DEFAULT (N'') FOR [Name]
GO
ALTER TABLE [dbo].[AspNetUsers] ADD  DEFAULT ('0001-01-01T00:00:00.0000000') FOR [CreatedOn]
GO
ALTER TABLE [dbo].[AspNetUsers] ADD  DEFAULT ((0)) FOR [GenderId]
GO
ALTER TABLE [dbo].[AspNetUsers] ADD  DEFAULT (N'') FOR [RoleId]
GO
ALTER TABLE [dbo].[SystemCodeDetails] ADD  DEFAULT (N'') FOR [CreatedById]
GO
ALTER TABLE [dbo].[SystemCodeDetails] ADD  DEFAULT ('0001-01-01T00:00:00.0000000') FOR [CreatedOn]
GO
ALTER TABLE [dbo].[SystemCodes] ADD  DEFAULT (N'') FOR [CreatedById]
GO
ALTER TABLE [dbo].[SystemCodes] ADD  DEFAULT ('0001-01-01T00:00:00.0000000') FOR [CreatedOn]
GO
ALTER TABLE [dbo].[Tickets] ADD  DEFAULT ((0)) FOR [SubCategoryId]
GO
ALTER TABLE [dbo].[Tickets] ADD  DEFAULT ((0)) FOR [PriorityId]
GO
ALTER TABLE [dbo].[Tickets] ADD  DEFAULT ((0)) FOR [StatusId]
GO
ALTER TABLE [dbo].[AspNetRoleClaims]  WITH CHECK ADD  CONSTRAINT [FK_AspNetRoleClaims_AspNetRoles_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[AspNetRoles] ([Id])
GO
ALTER TABLE [dbo].[AspNetRoleClaims] CHECK CONSTRAINT [FK_AspNetRoleClaims_AspNetRoles_RoleId]
GO
ALTER TABLE [dbo].[AspNetRoles]  WITH CHECK ADD  CONSTRAINT [FK_AspNetRoles_AspNetUsers_CreatedById] FOREIGN KEY([CreatedById])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[AspNetRoles] CHECK CONSTRAINT [FK_AspNetRoles_AspNetUsers_CreatedById]
GO
ALTER TABLE [dbo].[AspNetRoles]  WITH CHECK ADD  CONSTRAINT [FK_AspNetRoles_AspNetUsers_ModifiedById] FOREIGN KEY([ModifiedById])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[AspNetRoles] CHECK CONSTRAINT [FK_AspNetRoles_AspNetUsers_ModifiedById]
GO
ALTER TABLE [dbo].[AspNetUserClaims]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUserClaims_AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[AspNetUserClaims] CHECK CONSTRAINT [FK_AspNetUserClaims_AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[AspNetUserLogins]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUserLogins_AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[AspNetUserLogins] CHECK CONSTRAINT [FK_AspNetUserLogins_AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[AspNetUserRoles]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUserRoles_AspNetRoles_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[AspNetRoles] ([Id])
GO
ALTER TABLE [dbo].[AspNetUserRoles] CHECK CONSTRAINT [FK_AspNetUserRoles_AspNetRoles_RoleId]
GO
ALTER TABLE [dbo].[AspNetUserRoles]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUserRoles_AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[AspNetUserRoles] CHECK CONSTRAINT [FK_AspNetUserRoles_AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[AspNetUsers]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUsers_AspNetRoles_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[AspNetRoles] ([Id])
GO
ALTER TABLE [dbo].[AspNetUsers] CHECK CONSTRAINT [FK_AspNetUsers_AspNetRoles_RoleId]
GO
ALTER TABLE [dbo].[AspNetUsers]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUsers_AspNetUsers_CreatedById] FOREIGN KEY([CreatedById])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[AspNetUsers] CHECK CONSTRAINT [FK_AspNetUsers_AspNetUsers_CreatedById]
GO
ALTER TABLE [dbo].[AspNetUsers]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUsers_AspNetUsers_ModifiedById] FOREIGN KEY([ModifiedById])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[AspNetUsers] CHECK CONSTRAINT [FK_AspNetUsers_AspNetUsers_ModifiedById]
GO
ALTER TABLE [dbo].[AspNetUsers]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUsers_SystemCodeDetails_GenderId] FOREIGN KEY([GenderId])
REFERENCES [dbo].[SystemCodeDetails] ([Id])
GO
ALTER TABLE [dbo].[AspNetUsers] CHECK CONSTRAINT [FK_AspNetUsers_SystemCodeDetails_GenderId]
GO
ALTER TABLE [dbo].[AspNetUserTokens]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUserTokens_AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[AspNetUserTokens] CHECK CONSTRAINT [FK_AspNetUserTokens_AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[AuditTrails]  WITH CHECK ADD  CONSTRAINT [FK_AuditTrails_AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[AuditTrails] CHECK CONSTRAINT [FK_AuditTrails_AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[Comments]  WITH CHECK ADD  CONSTRAINT [FK_Comments_AspNetUsers_CreatedById] FOREIGN KEY([CreatedById])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[Comments] CHECK CONSTRAINT [FK_Comments_AspNetUsers_CreatedById]
GO
ALTER TABLE [dbo].[Comments]  WITH CHECK ADD  CONSTRAINT [FK_Comments_AspNetUsers_ModifiedById] FOREIGN KEY([ModifiedById])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[Comments] CHECK CONSTRAINT [FK_Comments_AspNetUsers_ModifiedById]
GO
ALTER TABLE [dbo].[Comments]  WITH CHECK ADD  CONSTRAINT [FK_Comments_Tickets_TicketId] FOREIGN KEY([TicketId])
REFERENCES [dbo].[Tickets] ([Id])
GO
ALTER TABLE [dbo].[Comments] CHECK CONSTRAINT [FK_Comments_Tickets_TicketId]
GO
ALTER TABLE [dbo].[Departments]  WITH CHECK ADD  CONSTRAINT [FK_Departments_AspNetUsers_CreatedById] FOREIGN KEY([CreatedById])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[Departments] CHECK CONSTRAINT [FK_Departments_AspNetUsers_CreatedById]
GO
ALTER TABLE [dbo].[Departments]  WITH CHECK ADD  CONSTRAINT [FK_Departments_AspNetUsers_ModifiedById] FOREIGN KEY([ModifiedById])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[Departments] CHECK CONSTRAINT [FK_Departments_AspNetUsers_ModifiedById]
GO
ALTER TABLE [dbo].[SystemCodeDetails]  WITH CHECK ADD  CONSTRAINT [FK_SystemCodeDetails_AspNetUsers_CreatedById] FOREIGN KEY([CreatedById])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[SystemCodeDetails] CHECK CONSTRAINT [FK_SystemCodeDetails_AspNetUsers_CreatedById]
GO
ALTER TABLE [dbo].[SystemCodeDetails]  WITH CHECK ADD  CONSTRAINT [FK_SystemCodeDetails_AspNetUsers_ModifiedById] FOREIGN KEY([ModifiedById])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[SystemCodeDetails] CHECK CONSTRAINT [FK_SystemCodeDetails_AspNetUsers_ModifiedById]
GO
ALTER TABLE [dbo].[SystemCodeDetails]  WITH CHECK ADD  CONSTRAINT [FK_SystemCodeDetails_SystemCodes_SystemCodeId] FOREIGN KEY([SystemCodeId])
REFERENCES [dbo].[SystemCodes] ([Id])
GO
ALTER TABLE [dbo].[SystemCodeDetails] CHECK CONSTRAINT [FK_SystemCodeDetails_SystemCodes_SystemCodeId]
GO
ALTER TABLE [dbo].[SystemCodes]  WITH CHECK ADD  CONSTRAINT [FK_SystemCodes_AspNetUsers_CreatedById] FOREIGN KEY([CreatedById])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[SystemCodes] CHECK CONSTRAINT [FK_SystemCodes_AspNetUsers_CreatedById]
GO
ALTER TABLE [dbo].[SystemCodes]  WITH CHECK ADD  CONSTRAINT [FK_SystemCodes_AspNetUsers_ModifiedById] FOREIGN KEY([ModifiedById])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[SystemCodes] CHECK CONSTRAINT [FK_SystemCodes_AspNetUsers_ModifiedById]
GO
ALTER TABLE [dbo].[SystemSettings]  WITH CHECK ADD  CONSTRAINT [FK_SystemSettings_AspNetUsers_CreatedById] FOREIGN KEY([CreatedById])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[SystemSettings] CHECK CONSTRAINT [FK_SystemSettings_AspNetUsers_CreatedById]
GO
ALTER TABLE [dbo].[SystemSettings]  WITH CHECK ADD  CONSTRAINT [FK_SystemSettings_AspNetUsers_ModifiedById] FOREIGN KEY([ModifiedById])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[SystemSettings] CHECK CONSTRAINT [FK_SystemSettings_AspNetUsers_ModifiedById]
GO
ALTER TABLE [dbo].[SystemTasks]  WITH CHECK ADD  CONSTRAINT [FK_SystemTasks_AspNetUsers_CreatedById] FOREIGN KEY([CreatedById])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[SystemTasks] CHECK CONSTRAINT [FK_SystemTasks_AspNetUsers_CreatedById]
GO
ALTER TABLE [dbo].[SystemTasks]  WITH CHECK ADD  CONSTRAINT [FK_SystemTasks_AspNetUsers_ModifiedById] FOREIGN KEY([ModifiedById])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[SystemTasks] CHECK CONSTRAINT [FK_SystemTasks_AspNetUsers_ModifiedById]
GO
ALTER TABLE [dbo].[SystemTasks]  WITH CHECK ADD  CONSTRAINT [FK_SystemTasks_SystemTasks_ParentId] FOREIGN KEY([ParentId])
REFERENCES [dbo].[SystemTasks] ([Id])
GO
ALTER TABLE [dbo].[SystemTasks] CHECK CONSTRAINT [FK_SystemTasks_SystemTasks_ParentId]
GO
ALTER TABLE [dbo].[TicketCategories]  WITH CHECK ADD  CONSTRAINT [FK_TicketCategories_AspNetUsers_CreatedById] FOREIGN KEY([CreatedById])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[TicketCategories] CHECK CONSTRAINT [FK_TicketCategories_AspNetUsers_CreatedById]
GO
ALTER TABLE [dbo].[TicketCategories]  WITH CHECK ADD  CONSTRAINT [FK_TicketCategories_AspNetUsers_ModifiedById] FOREIGN KEY([ModifiedById])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[TicketCategories] CHECK CONSTRAINT [FK_TicketCategories_AspNetUsers_ModifiedById]
GO
ALTER TABLE [dbo].[TicketResolutions]  WITH CHECK ADD  CONSTRAINT [FK_TicketResolutions_AspNetUsers_CreatedById] FOREIGN KEY([CreatedById])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[TicketResolutions] CHECK CONSTRAINT [FK_TicketResolutions_AspNetUsers_CreatedById]
GO
ALTER TABLE [dbo].[TicketResolutions]  WITH CHECK ADD  CONSTRAINT [FK_TicketResolutions_AspNetUsers_ModifiedById] FOREIGN KEY([ModifiedById])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[TicketResolutions] CHECK CONSTRAINT [FK_TicketResolutions_AspNetUsers_ModifiedById]
GO
ALTER TABLE [dbo].[TicketResolutions]  WITH CHECK ADD  CONSTRAINT [FK_TicketResolutions_SystemCodeDetails_StatusId] FOREIGN KEY([StatusId])
REFERENCES [dbo].[SystemCodeDetails] ([Id])
GO
ALTER TABLE [dbo].[TicketResolutions] CHECK CONSTRAINT [FK_TicketResolutions_SystemCodeDetails_StatusId]
GO
ALTER TABLE [dbo].[TicketResolutions]  WITH CHECK ADD  CONSTRAINT [FK_TicketResolutions_Tickets_TicketId] FOREIGN KEY([TicketId])
REFERENCES [dbo].[Tickets] ([Id])
GO
ALTER TABLE [dbo].[TicketResolutions] CHECK CONSTRAINT [FK_TicketResolutions_Tickets_TicketId]
GO
ALTER TABLE [dbo].[Tickets]  WITH CHECK ADD  CONSTRAINT [FK_Tickets_AspNetUsers_AssignedToId] FOREIGN KEY([AssignedToId])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[Tickets] CHECK CONSTRAINT [FK_Tickets_AspNetUsers_AssignedToId]
GO
ALTER TABLE [dbo].[Tickets]  WITH CHECK ADD  CONSTRAINT [FK_Tickets_AspNetUsers_CreatedById] FOREIGN KEY([CreatedById])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[Tickets] CHECK CONSTRAINT [FK_Tickets_AspNetUsers_CreatedById]
GO
ALTER TABLE [dbo].[Tickets]  WITH CHECK ADD  CONSTRAINT [FK_Tickets_AspNetUsers_ModifiedById] FOREIGN KEY([ModifiedById])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[Tickets] CHECK CONSTRAINT [FK_Tickets_AspNetUsers_ModifiedById]
GO
ALTER TABLE [dbo].[Tickets]  WITH CHECK ADD  CONSTRAINT [FK_Tickets_SystemCodeDetails_PriorityId] FOREIGN KEY([PriorityId])
REFERENCES [dbo].[SystemCodeDetails] ([Id])
GO
ALTER TABLE [dbo].[Tickets] CHECK CONSTRAINT [FK_Tickets_SystemCodeDetails_PriorityId]
GO
ALTER TABLE [dbo].[Tickets]  WITH CHECK ADD  CONSTRAINT [FK_Tickets_SystemCodeDetails_StatusId] FOREIGN KEY([StatusId])
REFERENCES [dbo].[SystemCodeDetails] ([Id])
GO
ALTER TABLE [dbo].[Tickets] CHECK CONSTRAINT [FK_Tickets_SystemCodeDetails_StatusId]
GO
ALTER TABLE [dbo].[Tickets]  WITH CHECK ADD  CONSTRAINT [FK_Tickets_TicketSubCategories_SubCategoryId] FOREIGN KEY([SubCategoryId])
REFERENCES [dbo].[TicketSubCategories] ([Id])
GO
ALTER TABLE [dbo].[Tickets] CHECK CONSTRAINT [FK_Tickets_TicketSubCategories_SubCategoryId]
GO
ALTER TABLE [dbo].[TicketSubCategories]  WITH CHECK ADD  CONSTRAINT [FK_TicketSubCategories_AspNetUsers_CreatedById] FOREIGN KEY([CreatedById])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[TicketSubCategories] CHECK CONSTRAINT [FK_TicketSubCategories_AspNetUsers_CreatedById]
GO
ALTER TABLE [dbo].[TicketSubCategories]  WITH CHECK ADD  CONSTRAINT [FK_TicketSubCategories_AspNetUsers_ModifiedById] FOREIGN KEY([ModifiedById])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[TicketSubCategories] CHECK CONSTRAINT [FK_TicketSubCategories_AspNetUsers_ModifiedById]
GO
ALTER TABLE [dbo].[TicketSubCategories]  WITH CHECK ADD  CONSTRAINT [FK_TicketSubCategories_TicketCategories_CategoryId] FOREIGN KEY([CategoryId])
REFERENCES [dbo].[TicketCategories] ([Id])
GO
ALTER TABLE [dbo].[TicketSubCategories] CHECK CONSTRAINT [FK_TicketSubCategories_TicketCategories_CategoryId]
GO
ALTER TABLE [dbo].[UserRoleProfiles]  WITH CHECK ADD  CONSTRAINT [FK_UserRoleProfiles_AspNetRoles_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[AspNetRoles] ([Id])
GO
ALTER TABLE [dbo].[UserRoleProfiles] CHECK CONSTRAINT [FK_UserRoleProfiles_AspNetRoles_RoleId]
GO
ALTER TABLE [dbo].[UserRoleProfiles]  WITH CHECK ADD  CONSTRAINT [FK_UserRoleProfiles_AspNetUsers_CreatedById] FOREIGN KEY([CreatedById])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[UserRoleProfiles] CHECK CONSTRAINT [FK_UserRoleProfiles_AspNetUsers_CreatedById]
GO
ALTER TABLE [dbo].[UserRoleProfiles]  WITH CHECK ADD  CONSTRAINT [FK_UserRoleProfiles_AspNetUsers_ModifiedById] FOREIGN KEY([ModifiedById])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[UserRoleProfiles] CHECK CONSTRAINT [FK_UserRoleProfiles_AspNetUsers_ModifiedById]
GO
ALTER TABLE [dbo].[UserRoleProfiles]  WITH CHECK ADD  CONSTRAINT [FK_UserRoleProfiles_SystemTasks_TaskId] FOREIGN KEY([TaskId])
REFERENCES [dbo].[SystemTasks] ([Id])
GO
ALTER TABLE [dbo].[UserRoleProfiles] CHECK CONSTRAINT [FK_UserRoleProfiles_SystemTasks_TaskId]
GO
USE [master]
GO
ALTER DATABASE [HelpDeskSystem] SET  READ_WRITE 
GO
