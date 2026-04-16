CREATE TABLE Role (
    RoleID   INT          IDENTITY(1,1),
    RoleName VARCHAR(100) NOT NULL UNIQUE,
    CONSTRAINT PK_Role PRIMARY KEY (RoleID)
);

CREATE TABLE Users (
    UserID         INT           IDENTITY(1,1),
    RoleID         INT           NOT NULL,
    FullName       NVARCHAR(255) NOT NULL,
    Email          NVARCHAR(255) NOT NULL UNIQUE,
    PasswordHash   NVARCHAR(255) NOT NULL,
    ProfilePicture NVARCHAR(512),
    UserType       NVARCHAR(100),
    AccountStatus  NVARCHAR(50)  DEFAULT 'Active',
    LastLoginAt    DATETIME2,
    CreatedAt      DATETIME2     DEFAULT GETDATE(),
    CONSTRAINT PK_Users      PRIMARY KEY (UserID),
    CONSTRAINT FK_Users_Role FOREIGN KEY (RoleID)
        REFERENCES Role(RoleID)
);

CREATE TABLE Login_Logs (
    LogID        INT           IDENTITY(1,1),
    UserID       INT,
    LoginAt      DATETIME2     DEFAULT GETDATE(),
    IpAddress    NVARCHAR(45)  NOT NULL,
    DeviceInfo   NVARCHAR(255),
    LoginSuccess BIT           NOT NULL DEFAULT 0,
    CONSTRAINT PK_Login_Logs        PRIMARY KEY (LogID),
    CONSTRAINT FK_Login_Logs_Users  FOREIGN KEY (UserID)
        REFERENCES Users(UserID) ON DELETE SET NULL
);

CREATE TABLE Courses (
    CourseID        INT            IDENTITY(1,1),
    Title           NVARCHAR(255)  NOT NULL,
    Description     NVARCHAR(MAX),
    DifficultyLevel NVARCHAR(50),
    ThumbnailURL    NVARCHAR(512),
    Status          NVARCHAR(50)   DEFAULT 'Draft',
    CreatedAt       DATETIME2      DEFAULT GETDATE(),
    CONSTRAINT PK_Courses PRIMARY KEY (CourseID)
);

CREATE TABLE Enrollments (
    EnrollmentID INT       IDENTITY(1,1),
    UserID       INT       NOT NULL,
    CourseID     INT       NOT NULL,
    EnrolledAt   DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT PK_Enrollments         PRIMARY KEY (EnrollmentID),
    CONSTRAINT FK_Enrollments_Users   FOREIGN KEY (UserID)
        REFERENCES Users(UserID)   ON DELETE CASCADE,
    CONSTRAINT FK_Enrollments_Courses FOREIGN KEY (CourseID)
        REFERENCES Courses(CourseID) ON DELETE CASCADE,
    CONSTRAINT UQ_User_Course UNIQUE (UserID, CourseID)
);

CREATE TABLE Modules (
    ModuleID         INT            IDENTITY(1,1),
    CourseID         INT            NOT NULL,
    Title            NVARCHAR(255)  NOT NULL,
    Content          NVARCHAR(MAX),
    OrderIndex       INT            NOT NULL,
    EstimatedMinutes INT,
    CONSTRAINT PK_Modules         PRIMARY KEY (ModuleID),
    CONSTRAINT FK_Modules_Courses FOREIGN KEY (CourseID)
        REFERENCES Courses(CourseID) ON DELETE CASCADE
);


CREATE TABLE UserProgress (
    ProgressID  INT       IDENTITY(1,1),
    UserID      INT       NOT NULL,
    ModuleID    INT       NOT NULL,
    IsCompleted BIT       NOT NULL DEFAULT 0,
    CompletedAt DATETIME2,
    CONSTRAINT PK_UserProgress         PRIMARY KEY (ProgressID),
    CONSTRAINT FK_UserProgress_Users   FOREIGN KEY (UserID)
        REFERENCES Users(UserID)   ON DELETE CASCADE,
    CONSTRAINT FK_UserProgress_Modules FOREIGN KEY (ModuleID)
        REFERENCES Modules(ModuleID) ON DELETE NO ACTION,
    CONSTRAINT UQ_User_Module UNIQUE (UserID, ModuleID)
);

CREATE TABLE Quizzes (
    QuizID          INT           IDENTITY(1,1),
    ModuleID        INT           NOT NULL UNIQUE,
    Title           NVARCHAR(255) NOT NULL,
    PassMarkPercent DECIMAL(5,2)  NOT NULL DEFAULT 60.00,
    CONSTRAINT PK_Quizzes         PRIMARY KEY (QuizID),
    CONSTRAINT FK_Quizzes_Modules FOREIGN KEY (ModuleID)
        REFERENCES Modules(ModuleID) ON DELETE CASCADE
);

CREATE TABLE Questions (
    QuestionID    INT            IDENTITY(1,1),
    QuizID        INT            NOT NULL,
    QuestionText  NVARCHAR(MAX)  NOT NULL,
    OptionA       NVARCHAR(512)  NOT NULL,
    OptionB       NVARCHAR(512)  NOT NULL,
    OptionC       NVARCHAR(512)  NOT NULL,
    OptionD       NVARCHAR(512)  NOT NULL,
    CorrectAnswer CHAR(1)        NOT NULL,
    HintText      NVARCHAR(MAX),
    CONSTRAINT PK_Questions         PRIMARY KEY (QuestionID),
    CONSTRAINT FK_Questions_Quizzes FOREIGN KEY (QuizID)
        REFERENCES Quizzes(QuizID) ON DELETE CASCADE
);

CREATE TABLE Quiz_Attempts (
    AttemptID      INT       IDENTITY(1,1),
    UserID         INT       NOT NULL,
    QuizID         INT       NOT NULL,
    Score          INT       NOT NULL,
    TotalQuestions INT       NOT NULL,
    IsPassed       BIT       NOT NULL DEFAULT 0,
    AttemptedAt    DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT PK_Quiz_Attempts         PRIMARY KEY (AttemptID),
    CONSTRAINT FK_Quiz_Attempts_Users   FOREIGN KEY (UserID)
        REFERENCES Users(UserID)   ON DELETE CASCADE,
    CONSTRAINT FK_Quiz_Attempts_Quizzes FOREIGN KEY (QuizID)
        REFERENCES Quizzes(QuizID) ON DELETE NO ACTION
);

INSERT INTO Role (RoleName) VALUES ('Admin');
INSERT INTO Role (RoleName) VALUES ('Member');