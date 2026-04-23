-- Drop tables in reverse order of dependencies to avoid constraint errors
IF OBJECT_ID('dbo.Quiz_Attempt', 'U') IS NOT NULL DROP TABLE dbo.Quiz_Attempt;
IF OBJECT_ID('dbo.Question', 'U') IS NOT NULL DROP TABLE dbo.Question;
IF OBJECT_ID('dbo.Quiz', 'U') IS NOT NULL DROP TABLE dbo.Quiz;
IF OBJECT_ID('dbo.UserProgress', 'U') IS NOT NULL DROP TABLE dbo.UserProgress;
IF OBJECT_ID('dbo.Enrollment', 'U') IS NOT NULL DROP TABLE dbo.Enrollment;
IF OBJECT_ID('dbo.Module', 'U') IS NOT NULL DROP TABLE dbo.Module;
IF OBJECT_ID('dbo.Login_Log', 'U') IS NOT NULL DROP TABLE dbo.Login_Log;
IF OBJECT_ID('dbo.[User]', 'U') IS NOT NULL DROP TABLE dbo.[User];
IF OBJECT_ID('dbo.Course', 'U') IS NOT NULL DROP TABLE dbo.Course;
IF OBJECT_ID('dbo.Role', 'U') IS NOT NULL DROP TABLE dbo.Role;

-- Create Tables
CREATE TABLE Role (
    RoleID   INT          IDENTITY(1,1),
    RoleName VARCHAR(100) NOT NULL UNIQUE,
    CONSTRAINT PK_Role PRIMARY KEY (RoleID)
);

CREATE TABLE [User] (
    UserID         INT           IDENTITY(1,1),
    RoleID         INT           NOT NULL,
    FullName       NVARCHAR(255) NOT NULL,
    Email          NVARCHAR(255) NOT NULL UNIQUE,
    PasswordHash   NVARCHAR(255) NOT NULL,
    ProfilePicture NVARCHAR(512),
    UserProfession NVARCHAR(100),
    AccountStatus  NVARCHAR(50)  DEFAULT 'Active',
    CreatedAt      DATETIME2     DEFAULT GETDATE(),
    CONSTRAINT PK_User      PRIMARY KEY (UserID),
    CONSTRAINT FK_User_Role FOREIGN KEY (RoleID)
        REFERENCES Role(RoleID)
);

CREATE TABLE Login_Log (
    LogID        INT           IDENTITY(1,1),
    UserID       INT,
    LoginAt      DATETIME2     DEFAULT GETDATE(),
    IpAddress    NVARCHAR(45)  NOT NULL,
    DeviceInfo   NVARCHAR(255),
    LoginSuccess BIT           NOT NULL DEFAULT 0,
    CONSTRAINT PK_Login_Log        PRIMARY KEY (LogID),
    CONSTRAINT FK_Login_Log_User  FOREIGN KEY (UserID)
        REFERENCES [User](UserID) ON DELETE SET NULL
);

CREATE TABLE Course (
    CourseID        INT            IDENTITY(1,1),
    Title           NVARCHAR(255)  NOT NULL,
    Description     NVARCHAR(MAX),
    DifficultyLevel NVARCHAR(50),
    ThumbnailURL    NVARCHAR(512),
    Status          NVARCHAR(50)   DEFAULT 'Draft',
    CreatedAt       DATETIME2      DEFAULT GETDATE(),
    CONSTRAINT PK_Course PRIMARY KEY (CourseID)
);

CREATE TABLE Enrollment (
    EnrollmentID INT       IDENTITY(1,1),
    UserID       INT       NOT NULL,
    CourseID     INT       NOT NULL,
    EnrolledAt   DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT PK_Enrollment         PRIMARY KEY (EnrollmentID),
    CONSTRAINT FK_Enrollment_User   FOREIGN KEY (UserID)
        REFERENCES [User](UserID)   ON DELETE CASCADE,
    CONSTRAINT FK_Enrollment_Course FOREIGN KEY (CourseID)
        REFERENCES Course(CourseID) ON DELETE CASCADE,
    CONSTRAINT UQ_User_Course UNIQUE (UserID, CourseID)
);

CREATE TABLE Module (
    ModuleID         INT            IDENTITY(1,1),
    CourseID         INT            NOT NULL,
    Title            NVARCHAR(255)  NOT NULL,
    Content          NVARCHAR(MAX),
    OrderIndex       INT            NOT NULL,
    EstimatedMinutes INT,
    CONSTRAINT PK_Module         PRIMARY KEY (ModuleID),
    CONSTRAINT FK_Module_Course FOREIGN KEY (CourseID)
        REFERENCES Course(CourseID) ON DELETE CASCADE
);


CREATE TABLE UserProgress (
    ProgressID  INT       IDENTITY(1,1),
    UserID      INT       NOT NULL,
    ModuleID    INT       NOT NULL,
    IsCompleted BIT       NOT NULL DEFAULT 0,
    CompletedAt DATETIME2,
    CONSTRAINT PK_UserProgress         PRIMARY KEY (ProgressID),
    CONSTRAINT FK_UserProgress_User   FOREIGN KEY (UserID)
        REFERENCES [User](UserID)   ON DELETE CASCADE,
    CONSTRAINT FK_UserProgress_Module FOREIGN KEY (ModuleID)
        REFERENCES Module(ModuleID) ON DELETE NO ACTION,
    CONSTRAINT UQ_User_Module UNIQUE (UserID, ModuleID)
);

CREATE TABLE Quiz (
    QuizID          INT           IDENTITY(1,1),
    ModuleID        INT           NOT NULL UNIQUE,
    Title           NVARCHAR(255) NOT NULL,
    PassMarkPercent DECIMAL(5,2)  NOT NULL DEFAULT 60.00,
    CONSTRAINT PK_Quiz         PRIMARY KEY (QuizID),
    CONSTRAINT FK_Quiz_Module FOREIGN KEY (ModuleID)
        REFERENCES Module(ModuleID) ON DELETE CASCADE
);

CREATE TABLE Question (
    QuestionID    INT            IDENTITY(1,1),
    QuizID        INT            NOT NULL,
    QuestionText  NVARCHAR(MAX)  NOT NULL,
    OptionA       NVARCHAR(512)  NOT NULL,
    OptionB       NVARCHAR(512)  NOT NULL,
    OptionC       NVARCHAR(512)  NOT NULL,
    OptionD       NVARCHAR(512)  NOT NULL,
    CorrectAnswer CHAR(1)        NOT NULL,
    HintText      NVARCHAR(MAX),
    CONSTRAINT PK_Question         PRIMARY KEY (QuestionID),
    CONSTRAINT FK_Question_Quiz FOREIGN KEY (QuizID)
        REFERENCES Quiz(QuizID) ON DELETE CASCADE
);

CREATE TABLE Quiz_Attempt (
    AttemptID      INT       IDENTITY(1,1),
    UserID         INT       NOT NULL,
    QuizID         INT       NOT NULL,
    Score          INT       NOT NULL,
    TotalQuestions INT       NOT NULL,
    IsPassed       BIT       NOT NULL DEFAULT 0,
    AttemptedAt    DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT PK_Quiz_Attempt         PRIMARY KEY (AttemptID),
    CONSTRAINT FK_Quiz_Attempt_User   FOREIGN KEY (UserID)
        REFERENCES [User](UserID)   ON DELETE CASCADE,
    CONSTRAINT FK_Quiz_Attempt_Quiz FOREIGN KEY (QuizID)
        REFERENCES Quiz(QuizID) ON DELETE NO ACTION
);

-- Seed Initial Data
INSERT INTO Role (RoleName) VALUES ('Admin');
INSERT INTO Role (RoleName) VALUES ('Member');

-- Dummy Users for Testing
-- RoleID 1 = Admin, RoleID 2 = Member
INSERT INTO [User] (RoleID, FullName, Email, PasswordHash, UserProfession, AccountStatus) 
VALUES (1, 'System Administrator', 'admin@growwealth.com', 'admin123', 'IT Specialist', 'Active');

INSERT INTO [User] (RoleID, FullName, Email, PasswordHash, UserProfession, AccountStatus) 
VALUES (2, 'Ahmad Zaki', 'ahmad@email.com', 'password123', 'University Student', 'Active');

INSERT INTO [User] (RoleID, FullName, Email, PasswordHash, UserProfession, AccountStatus) 
VALUES (2, 'Sarah Jenkins', 'sarah@email.com', 'password123', 'Young Professional', 'Active');