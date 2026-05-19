USE master;
GO

IF DB_ID('GrowWealthDB') IS NOT NULL
BEGIN
    ALTER DATABASE GrowWealthDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE GrowWealthDB;
END
GO

CREATE DATABASE GrowWealthDB;
GO

USE GrowWealthDB;
GO

/* ------------------------------------------------------------
   Schema
   ------------------------------------------------------------ */

CREATE TABLE Role (
    RoleID      INT IDENTITY(1,1) PRIMARY KEY,
    RoleName    NVARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE [User] (
    UserID          INT IDENTITY(1,1) PRIMARY KEY,
    FullName        NVARCHAR(120) NOT NULL,
    Email           NVARCHAR(160) NOT NULL UNIQUE,
    PasswordHash    NVARCHAR(255) NOT NULL,
    RoleID          INT NOT NULL,
    AccountStatus   NVARCHAR(20) NOT NULL DEFAULT 'Active',
    ProfilePicture  NVARCHAR(500) NULL,
    CreatedAt       DATETIME NOT NULL DEFAULT GETDATE(),
    LastLogin       DATETIME NULL,
    CONSTRAINT FK_User_Role FOREIGN KEY (RoleID) REFERENCES Role(RoleID)
);

CREATE TABLE Course (
    CourseID        INT IDENTITY(1,1) PRIMARY KEY,
    Title           NVARCHAR(200) NOT NULL,
    Description     NVARCHAR(1000) NOT NULL,
    Difficulty      NVARCHAR(20) NOT NULL,
    EstimatedHours  INT NOT NULL DEFAULT 6,
    IsActive        BIT NOT NULL DEFAULT 1
);

CREATE TABLE Module (
    ModuleID            INT IDENTITY(1,1) PRIMARY KEY,
    CourseID            INT NOT NULL,
    Title               NVARCHAR(200) NOT NULL,
    Content             NVARCHAR(MAX) NOT NULL,
    OrderIndex          INT NOT NULL DEFAULT 1,
    EstimatedMinutes    INT NOT NULL DEFAULT 15,
    CONSTRAINT FK_Module_Course FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
);

CREATE TABLE Enrollment (
    UserID      INT NOT NULL,
    CourseID    INT NOT NULL,
    EnrolledAt  DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT PK_Enrollment PRIMARY KEY (UserID, CourseID),
    CONSTRAINT FK_Enrol_User FOREIGN KEY (UserID) REFERENCES [User](UserID),
    CONSTRAINT FK_Enrol_Course FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
);

CREATE TABLE UserProgress (
    UserID          INT NOT NULL,
    ModuleID        INT NOT NULL,
    IsCompleted     BIT NOT NULL DEFAULT 0,
    CompletedAt     DATETIME NULL,
    CONSTRAINT PK_UserProgress PRIMARY KEY (UserID, ModuleID),
    CONSTRAINT FK_UP_User FOREIGN KEY (UserID) REFERENCES [User](UserID),
    CONSTRAINT FK_UP_Module FOREIGN KEY (ModuleID) REFERENCES Module(ModuleID)
);

CREATE TABLE Quiz (
    QuizID      INT IDENTITY(1,1) PRIMARY KEY,
    ModuleID    INT NOT NULL,
    Title       NVARCHAR(200) NOT NULL,
    PassMark    INT NOT NULL DEFAULT 60,
    CONSTRAINT FK_Quiz_Module FOREIGN KEY (ModuleID) REFERENCES Module(ModuleID)
);

CREATE TABLE Question (
    QuestionID      INT IDENTITY(1,1) PRIMARY KEY,
    QuizID          INT NOT NULL,
    QuestionText    NVARCHAR(1000) NOT NULL,
    OptionA         NVARCHAR(500) NOT NULL,
    OptionB         NVARCHAR(500) NOT NULL,
    OptionC         NVARCHAR(500) NOT NULL,
    OptionD         NVARCHAR(500) NOT NULL,
    CorrectOption   CHAR(1) NOT NULL,
    OrderIndex      INT NOT NULL DEFAULT 1,
    CONSTRAINT FK_Question_Quiz FOREIGN KEY (QuizID) REFERENCES Quiz(QuizID)
);

CREATE TABLE Quiz_Attempt (
    AttemptID       INT IDENTITY(1,1) PRIMARY KEY,
    UserID          INT NOT NULL,
    QuizID          INT NOT NULL,
    Score           INT NOT NULL,
    TotalQuestions  INT NOT NULL,
    AttemptedAt     DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_QA_User FOREIGN KEY (UserID) REFERENCES [User](UserID),
    CONSTRAINT FK_QA_Quiz FOREIGN KEY (QuizID) REFERENCES Quiz(QuizID)
);

CREATE TABLE Login_Log (
    LogID       INT IDENTITY(1,1) PRIMARY KEY,
    UserID      INT NULL,
    LoginTime   DATETIME NOT NULL DEFAULT GETDATE(),
    IPAddress   NVARCHAR(60) NULL,
    Success     BIT NOT NULL DEFAULT 1,
    FailReason  NVARCHAR(200) NULL,
    CONSTRAINT FK_LL_User FOREIGN KEY (UserID) REFERENCES [User](UserID)
);

CREATE TABLE InvestmentSimulation (
    SimID                   INT IDENTITY(1,1) PRIMARY KEY,
    UserID                  INT NOT NULL,
    InitialAmount           DECIMAL(18, 2) NOT NULL,
    MonthlyContribution     DECIMAL(18, 2) NOT NULL,
    AnnualRate              DECIMAL(6, 3) NOT NULL,
    DurationYears           INT NOT NULL,
    CompoundingPerYear      INT NOT NULL DEFAULT 12,
    FinalValue              DECIMAL(18, 2) NOT NULL,
    InterestEarned          DECIMAL(18, 2) NOT NULL,
    RunAt                   DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Sim_User FOREIGN KEY (UserID) REFERENCES [User](UserID)
);
GO

/* ------------------------------------------------------------
   Roles
   ------------------------------------------------------------ */

INSERT INTO Role (RoleName) VALUES ('Admin'), ('Member');
GO

/* ------------------------------------------------------------
   Users
   Admin password: admin123
   Member password (everyone except suspended): password123
   ------------------------------------------------------------ */

INSERT INTO [User] (FullName, Email, PasswordHash, RoleID, AccountStatus, CreatedAt, LastLogin)
VALUES
    ('Admin Wong', 'admin@growwealth.com', 'admin123', 1, 'Active', DATEADD(month, -8, GETDATE()), DATEADD(hour, -2, GETDATE())),
    ('Ahmad Faizal', 'ahmad@email.com', 'password123', 2, 'Active', DATEADD(month, -5, GETDATE()), DATEADD(hour, -6, GETDATE())),
    ('Lim Wei Ling', 'weiling@email.com', 'password123', 2, 'Active', DATEADD(month, -4, GETDATE()), DATEADD(day, -1, GETDATE())),
    ('Priya Subramaniam', 'priya@email.com', 'password123', 2, 'Active', DATEADD(month, -3, GETDATE()), DATEADD(day, -2, GETDATE())),
    ('Tan Chee Keong', 'cheekeong@email.com', 'password123', 2, 'Active', DATEADD(month, -2, GETDATE()), DATEADD(day, -3, GETDATE())),
    ('Siti Nurhaliza', 'siti@email.com', 'password123', 2, 'Active', DATEADD(month, -2, GETDATE()), DATEADD(day, -1, GETDATE())),
    ('Daniel Foo', 'daniel@email.com', 'password123', 2, 'Suspended', DATEADD(month, -6, GETDATE()), DATEADD(day, -30, GETDATE()));
GO

/* ------------------------------------------------------------
   Courses (3)
   ------------------------------------------------------------ */

INSERT INTO Course (Title, Description, Difficulty, EstimatedHours, IsActive)
VALUES
    ('Personal Finance Foundations',
     'Build the foundation of your financial life. Learn budgeting, saving habits, managing debt, and how to keep your money working for you from day one.',
     'Beginner', 5, 1),
    ('Investing Essentials',
     'Move from saving to investing. Understand stocks, bonds, unit trusts, risk, diversification, and how to actually open and use an investment account in Malaysia.',
     'Intermediate', 7, 1),
    ('Advanced Wealth Building',
     'Take your portfolio to the next level. Asset allocation, rebalancing, tax-efficient investing, retirement planning, and how to protect what you''ve built.',
     'Advanced', 8, 1);
GO
USE GrowWealthDB;
GO

/* ------------------------------------------------------------
   Modules — 5 per course = 15 total
   ------------------------------------------------------------ */

/* ===== Course 1: Personal Finance Foundations ===== */

INSERT INTO Module (CourseID, Title, Content, OrderIndex, EstimatedMinutes) VALUES
(1, 'Understanding Money & Mindset',
N'<p>Before any spreadsheet, your relationship with money is shaped by years of subtle inputs — your family, your friends, and the culture you grew up in. Personal finance is more behavioural than mathematical. People who handle money well are rarely the ones who know the most formulas; they''re the ones who have built habits that quietly compound for decades.</p>
<p>Start by separating <strong>needs</strong> from <strong>wants</strong>. Needs keep you alive and earning — rent, food, utilities, transport to work. Wants make life enjoyable — dining out, the latest phone, a weekend getaway. Neither is wrong, but treating wants as needs is the single most common reason capable earners struggle financially.</p>
<p>Money has three jobs: to <em>spend</em>, to <em>save</em>, and to <em>grow</em>. Most beginners only do the first. By the end of this course you''ll be doing all three deliberately. A useful first exercise is to track every ringgit you spend for two weeks. Don''t try to change anything — just look. Most people are shocked by where their money actually goes.</p>
<p>Financial security is not a number in a bank account. It''s the gap between what you earn and what you spend, multiplied by time. Close that gap deliberately and let time do the work.</p>',
 1, 12),

(1, 'Building Your First Budget',
N'<p>A budget is not a punishment — it''s a plan that tells your money what to do before someone else does. The simplest framework that actually works for most people is the <strong>50/30/20 rule</strong>: 50% of take-home pay to needs, 30% to wants, 20% to savings and debt repayment.</p>
<p>Apply this to a typical Malaysian fresh graduate earning RM 3,500 net. That''s RM 1,750 for needs (rent, food, transport, utilities, phone), RM 1,050 for wants, and RM 700 to save or repay debt. If your rent alone is RM 1,500, your "needs" allocation is broken — the answer is usually a cheaper room or a flatmate, not skipping savings.</p>
<p>Two non-negotiable categories sit inside that 20%: an <strong>emergency fund</strong> covering 3–6 months of essential expenses, and any <strong>high-interest debt</strong> (credit cards above 15% interest). Until both are handled, investing doesn''t make sense — the math is against you.</p>
<p>Pick a tracking tool you''ll actually use. A spreadsheet, an app like Money Lover, or even a notebook all work equally well. The best budget is the one you''ll keep using next month. Review it weekly for the first month, then monthly thereafter.</p>',
 2, 15),

(1, 'Saving Strategies That Stick',
N'<p>Most people save what''s left at the end of the month. The trouble is, there''s rarely anything left. Successful savers flip this completely: they <strong>pay themselves first</strong>. The moment salary lands, money for savings moves into a separate account — automatically, before any spending happens.</p>
<p>Set up a <strong>standing instruction</strong> with your bank that transfers a fixed amount to a separate savings or investment account on payday. This single trick does more for your wealth than any cleverness about interest rates. Out of sight, out of mind, out of reach for impulse spending.</p>
<p>Where to park your emergency fund matters. Don''t leave it in your normal current account — you''ll see it and spend it. Use a high-yield savings account or a money-market fund. In Malaysia, products like Tabung Haji, ASB (for eligible groups), or fixed deposits laddered across 3-, 6-, 9-, and 12-month terms work well. The interest will be modest — that''s fine. The job of an emergency fund is to be there, not to grow.</p>
<p>Set savings goals with names and deadlines: "RM 12,000 emergency fund by December" beats "save more this year". Specific, measurable, and time-bound goals are the ones that get completed.</p>',
 3, 14),

(1, 'Managing Debt Wisely',
N'<p>Not all debt is equal. <strong>Productive debt</strong> finances things that grow in value or earn you income — a home loan, a student loan, a business loan. <strong>Consumptive debt</strong> finances things that lose value the moment you use them — credit cards, personal loans for lifestyle, car loans beyond what you need.</p>
<p>Credit card interest in Malaysia typically sits between 15% and 18% per year. No safe, legal investment reliably beats that. Paying off a credit card balance is mathematically equivalent to earning a guaranteed 15–18% return — the highest risk-free return you''ll ever find. Make it priority one.</p>
<p>Two methods work for paying off multiple debts. The <strong>avalanche method</strong> targets the highest-interest debt first while paying minimums on the rest — mathematically optimal. The <strong>snowball method</strong> targets the smallest balance first — psychologically motivating. Both work. Pick the one you''ll stick with.</p>
<p>Never use new debt to pay old debt unless you''re consolidating at a clearly lower rate. And before taking on new debt, ask one question: "If my income stopped tomorrow, could I still service this?" If the answer is no, the loan is too big.</p>',
 4, 13),

(1, 'Setting Financial Goals',
N'<p>Goals without dates are dreams. Dreams don''t earn interest. To turn financial intentions into outcomes, every goal needs three things: a clear amount, a deadline, and a monthly commitment.</p>
<p>Group your goals by timeframe. <strong>Short-term</strong> (under 1 year): emergency fund, new laptop, a trip. <strong>Medium-term</strong> (1–5 years): wedding, car down payment, postgraduate study. <strong>Long-term</strong> (5+ years): house deposit, children''s education, retirement. The timeframe determines where the money should sit — cash for short-term, bonds and balanced funds for medium-term, equities for long-term.</p>
<p>Work the math backwards. To save RM 60,000 for a house deposit in 5 years, you need RM 1,000 a month — assuming zero return. Add a modest 4% annual return and the monthly figure drops to about RM 905. Time and rate do real work; don''t underestimate them.</p>
<p>Write your top 3 goals down and put them somewhere you''ll see them daily — your phone wallpaper, a sticky note on your laptop. Visible goals get pursued. Forgotten goals get abandoned.</p>',
 5, 11);

GO

/* ===== Course 2: Investing Essentials ===== */

INSERT INTO Module (CourseID, Title, Content, OrderIndex, EstimatedMinutes) VALUES
(2, 'What Investing Really Means',
N'<p>Saving and investing are different jobs. <strong>Saving</strong> protects money you''ll need soon — its purpose is preservation, not growth. <strong>Investing</strong> puts money to work for the long term, accepting short-term volatility in exchange for higher returns over many years.</p>
<p>The reason investing matters is simple: <strong>inflation</strong>. If prices rise 3% a year and your savings earn 1.5%, your money is losing purchasing power even though the number is going up. Over 20 years, that drift is enormous. Investing is how you keep up.</p>
<p>The miracle is <strong>compound growth</strong>. Money invested earns returns; those returns earn their own returns; and over decades the curve goes vertical. RM 500 invested every month for 30 years at 7% annual return becomes about RM 612,000, even though you only put in RM 180,000. Two thirds of the result is interest on interest.</p>
<p>To benefit from compounding, you need two things: <strong>time</strong> and <strong>discipline</strong>. Starting at 25 instead of 35 doesn''t double your retirement portfolio — it roughly triples it. The earliest ringgit you invest is the most valuable ringgit you''ll ever own.</p>',
 1, 12),

(2, 'Stocks, Bonds, and Funds',
N'<p>Three building blocks make up most investment portfolios. A <strong>stock</strong> (or share) is part-ownership of a company. When the company grows, the value of your share grows; companies may also pay you a portion of their profit as a <strong>dividend</strong>. Stocks have the highest long-term return — and the most short-term volatility.</p>
<p>A <strong>bond</strong> is a loan you make to a government or company. You receive regular interest payments (coupons) and get your principal back at the bond''s maturity. Bonds are typically less volatile than stocks and produce more predictable income. In Malaysia, retail investors can access bonds through the Bursa BIX platform.</p>
<p>A <strong>unit trust</strong> (or mutual fund) pools money from many investors to buy a diversified basket of stocks, bonds, or both — managed by professionals. Unit trusts in Malaysia charge an upfront sales charge (typically 2–5%) plus an annual management fee (1–1.8%). Convenient, but those fees compound against you.</p>
<p>A modern alternative is the <strong>ETF</strong> (exchange-traded fund) — a fund that trades like a stock. ETFs typically have far lower fees and offer instant diversification. For most beginners, a single global index ETF is often the simplest sensible starting point.</p>',
 2, 14),

(2, 'Risk vs Return',
N'<p>The first rule of investing: <strong>higher potential return always comes with higher risk</strong>. Anyone who promises otherwise is selling you something. Your job as an investor is not to avoid risk, but to take it deliberately and proportionally to your situation.</p>
<p>Two questions determine your appropriate risk level. <strong>How long</strong> until you need this money? Money you need next year shouldn''t be in stocks. Money you won''t touch for 20 years probably <em>should</em> be heavily in stocks. <strong>How will you behave</strong> when the market falls 30%? If you''d panic-sell, your real risk tolerance is lower than you think — adjust accordingly.</p>
<p>Volatility (price swings) is not the same as permanent loss. A diversified stock portfolio that drops 30% in a year has not "lost" anything until you sell. Historically, equity markets have recovered every drawdown given enough time. Selling at the bottom turns paper losses into real ones.</p>
<p>One concept makes risk manageable: <strong>diversification</strong>. Spreading investments across many companies, sectors, and countries means no single bad outcome wrecks you. The closer your portfolio looks to "the entire global economy", the more resilient it becomes.</p>',
 3, 13),

(2, 'How Markets Work',
N'<p>A stock market is just a place where buyers and sellers meet to exchange ownership of companies. In Malaysia, the main exchange is <strong>Bursa Malaysia</strong>. The companies you can buy shares in are public companies that have completed an <strong>IPO</strong> (initial public offering) to raise money from the public.</p>
<p>Stock prices move every second the market is open. In the short term, prices are driven by news, sentiment, and trading flows — they look chaotic and unpredictable, because they are. In the long term, prices follow company earnings. Better businesses with growing profits eventually have higher share prices; the journey is just noisy.</p>
<p>You''ll see broad <strong>indices</strong> quoted everywhere — the KLCI in Malaysia (top 30 companies on Bursa), the S&P 500 in the US, the MSCI World globally. An index is a measuring stick for "how the market did", and it''s also something you can buy via an index fund or ETF — owning a tiny slice of every company in the index at once.</p>
<p>Markets in any single country can go through long flat or down periods. <strong>Global diversification</strong> — holding companies across many countries — has historically been one of the simplest ways to smooth long-term returns.</p>',
 4, 13),

(2, 'Opening Your First Investment Account',
N'<p>To buy stocks or ETFs on Bursa Malaysia, you need a <strong>CDS</strong> (Central Depository System) account and a <strong>trading account</strong> with a broker. Major retail brokers in Malaysia include Rakuten Trade, Maybank Investment, CIMB, and Hong Leong Investment Bank — all of which now offer fully online onboarding.</p>
<p>To open one, you''ll typically need your MyKad, a recent bank statement, and a selfie for ID verification. The whole process is usually done in under 30 minutes, and accounts are activated within 1–3 business days. Most brokers have no monthly fee — you only pay when you trade.</p>
<p>For <strong>unit trusts</strong>, you can invest through banks, agents, or platforms like FSMOne and iFAST. For <strong>EPF members</strong>, the i-Invest channel lets you invest part of your EPF Account 1 into approved unit trusts directly, at lower sales charges than retail.</p>
<p>Before placing your first trade, decide your strategy on paper. What will you buy, in what proportion, and on what schedule? <strong>Dollar-cost averaging</strong> (investing a fixed amount on the same date every month) removes timing decisions and is the simplest sensible default for most beginners. Set it up, automate it, and resist the urge to fiddle.</p>',
 5, 16);

GO

/* ===== Course 3: Advanced Wealth Building ===== */

INSERT INTO Module (CourseID, Title, Content, OrderIndex, EstimatedMinutes) VALUES
(3, 'Asset Allocation Strategy',
N'<p>Once you''ve mastered the basics, the single most consequential decision in your investing life is your <strong>asset allocation</strong> — the split between equities (stocks), fixed income (bonds), and cash. Studies have repeatedly found that allocation explains 80–90% of long-term return variation between portfolios; specific stock picks explain far less.</p>
<p>A classic starting point is the rule <strong>"110 minus your age in equities"</strong>. At 30, that''s 80% equities and 20% bonds. At 60, that''s 50/50. The logic: younger investors have more time to recover from drawdowns, so they can carry more risk; older investors need stability and income.</p>
<p>Within equities, diversify across <strong>geographies</strong> (Malaysia, developed markets, emerging markets) and <strong>sectors</strong>. Within bonds, mix government and high-grade corporate, short and medium duration. A practical sample portfolio for a 30-year-old: 50% global equities, 20% Malaysian equities, 20% bonds, 10% cash or alternatives.</p>
<p>Document your allocation as a written policy statement. When markets are wild and your gut wants to act, the document is what keeps you disciplined. Plans you wrote in calm don''t need to be revisited in panic.</p>',
 1, 15),

(3, 'Portfolio Rebalancing',
N'<p>Markets move, and so does your allocation. If equities rally hard, your 60/40 portfolio drifts to 75/25 — quietly carrying more risk than you signed up for. <strong>Rebalancing</strong> is the discipline of periodically selling what has grown beyond target and buying what has fallen below, returning the portfolio to its plan.</p>
<p>Two simple rebalancing methods work for retail investors. <strong>Calendar rebalancing</strong>: review once a year (typically January) and adjust. <strong>Threshold rebalancing</strong>: rebalance whenever any asset class drifts more than 5 percentage points from target. Both work. Calendar is easier; threshold can be slightly more efficient.</p>
<p>Rebalancing forces the right behaviour at exactly the right time. After a stock crash, equities are below target — you buy more. After a long bull run, equities are above target — you trim. You''re mechanically buying low and selling high without any forecasting.</p>
<p>Watch transaction costs and taxes. In tax-advantaged accounts (EPF i-Invest, PRS), rebalance freely. In taxable accounts, prefer using new contributions to rebalance — direct fresh money to under-target assets — to avoid triggering capital events unnecessarily.</p>',
 2, 14),

(3, 'Tax-Efficient Investing',
N'<p>Malaysia has a relatively investor-friendly tax regime, but smart structuring still matters. Currently, there is no capital gains tax on most listed equities, no tax on Bursa-listed dividend income for individuals, and no inheritance tax. Returns from EPF and SSPN are tax-exempt. Take advantage of these — they''re not permanent.</p>
<p>The <strong>Private Retirement Scheme (PRS)</strong> offers an annual tax relief of up to RM 3,000 on contributions until 2025. That''s a guaranteed first-year return of up to 24% (depending on your tax bracket) before any market performance. For higher-income earners, maxing PRS is one of the highest-return moves available.</p>
<p>Other tax reliefs worth using: medical insurance (up to RM 3,000), education insurance (up to RM 3,000), lifestyle relief, and SSPN savings for children''s tertiary education. None are huge in isolation; combined, they meaningfully lower your effective tax rate.</p>
<p>Foreign-source income remitted into Malaysia is now generally taxable (with transitional exemptions). If you hold offshore investments, plan remittances carefully and document timing — keeping records prevents painful disputes later.</p>',
 3, 14),

(3, 'Retirement Planning',
N'<p>Most Malaysians dramatically under-save for retirement. The official EPF target — having 1× your annual salary by 30, 3× by 40, 6× by 50 — is the bare minimum. To actually maintain your lifestyle, plan for 10–12× annual expenses by retirement age.</p>
<p>The <strong>4% rule</strong> is a useful planning shorthand. If you have a portfolio of 25× your annual expenses, withdrawing 4% per year (adjusted for inflation) has historically had a high probability of lasting 30+ years. Need RM 6,000/month in retirement? You need roughly RM 1.8 million invested.</p>
<p>That sounds daunting, but compounding does the lifting. Starting at 25 with RM 500/month at 7% return for 40 years gets you over RM 1.3 million. Adding contributions as your income grows easily clears the target. The painful version: starting at 45 with the same monthly amount gets you under RM 250,000.</p>
<p>Layer your retirement income across three sources: <strong>EPF</strong> (mandatory savings), <strong>PRS</strong> (tax-advantaged voluntary), and <strong>personal investments</strong> (full flexibility). Don''t rely on a single channel — diversification applies to income sources, not just portfolios.</p>',
 4, 15),

(3, 'Protecting Your Wealth',
N'<p>Building wealth is half the work; protecting it is the other half. Three layers of protection deserve attention: insurance, an estate plan, and behavioural defences against fraud and bad decisions.</p>
<p><strong>Insurance</strong> covers low-probability, high-impact events. Essentials for most adults: <em>medical insurance</em> (catastrophic illness can wipe out a decade of savings), <em>term life insurance</em> if you have dependants (10× annual income is a common rule of thumb), and <em>disability insurance</em> if your income is irreplaceable. Avoid investment-linked policies (ILPs) that bundle insurance with investing — they''re usually expensive in both directions.</p>
<p><strong>Estate planning</strong> isn''t only for the wealthy. A simple written <strong>will</strong> ensures your assets go where you want and prevents long, expensive probate disputes. Update it after major life events (marriage, children, property purchase). Malaysian Muslims should also understand <em>faraid</em> requirements when planning their estate.</p>
<p><strong>Behavioural defences</strong> may be the most underrated. Most large financial losses come from scams, panic-selling, and chasing speculative bets — not from market crashes. Build rules in advance: never invest in something you can''t explain in one paragraph, never act on tips from chat groups, and sleep on any decision involving more than 5% of your net worth.</p>',
 5, 14);

GO
USE GrowWealthDB;
GO

/* ------------------------------------------------------------
   Quizzes — one per module = 15 quizzes
   ------------------------------------------------------------ */

INSERT INTO Quiz (ModuleID, Title, PassMark) VALUES
(1,  'Money Mindset Quiz', 60),
(2,  'Budgeting Basics Quiz', 60),
(3,  'Saving Strategies Quiz', 60),
(4,  'Debt Management Quiz', 60),
(5,  'Financial Goals Quiz', 60),
(6,  'Investing Fundamentals Quiz', 60),
(7,  'Asset Classes Quiz', 60),
(8,  'Risk vs Return Quiz', 60),
(9,  'How Markets Work Quiz', 60),
(10, 'Opening Accounts Quiz', 60),
(11, 'Asset Allocation Quiz', 60),
(12, 'Rebalancing Quiz', 60),
(13, 'Tax Planning Quiz', 60),
(14, 'Retirement Planning Quiz', 60),
(15, 'Wealth Protection Quiz', 60);
GO

/* ------------------------------------------------------------
   Questions — 5 per quiz = 75 total
   QuizID is the same as ModuleID since they were inserted in order
   ------------------------------------------------------------ */

/* Quiz 1 — Money Mindset */
INSERT INTO Question (QuizID, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, OrderIndex) VALUES
(1, 'According to the module, what mainly separates people who handle money well from others?',
    'They know more financial formulas', 'They earn higher incomes',
    'They have built better habits', 'They have wealthy families', 'C', 1),
(1, 'Which of the following best describes a "want"?',
    'Rent on your primary home', 'Groceries for the week',
    'Transport to your job', 'A weekend trip abroad', 'D', 2),
(1, 'The three jobs of money mentioned in the module are:',
    'Spend, save, and grow', 'Earn, save, and donate',
    'Spend, lend, and borrow', 'Earn, store, and forget', 'A', 3),
(1, 'What is the recommended first exercise for understanding your spending?',
    'Cut all dining out for a month', 'Track every ringgit for two weeks without changing anything',
    'Sell items you don''t need', 'Open three new savings accounts', 'B', 4),
(1, 'Financial security is best described as:',
    'A specific bank balance', 'Owning property',
    'The gap between income and spending, over time', 'Having multiple credit cards', 'C', 5);

/* Quiz 2 — Budgeting Basics */
INSERT INTO Question (QuizID, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, OrderIndex) VALUES
(2, 'In the 50/30/20 budgeting rule, what does the 20% represent?',
    'Wants', 'Needs',
    'Savings and debt repayment', 'Taxes', 'C', 1),
(2, 'Which of these is classified as a need rather than a want?',
    'The latest smartphone', 'Streaming subscriptions',
    'Transport to work', 'Coffee with friends', 'C', 2),
(2, 'Roughly how many months of essential expenses should an emergency fund cover?',
    '1 month', '3 to 6 months',
    '12 to 18 months', '24 months', 'B', 3),
(2, 'Why should high-interest debt be cleared before investing?',
    'It blocks your credit card use', 'The interest rate beats most safe investment returns',
    'Banks require it', 'Investments are taxed more', 'B', 4),
(2, 'The best budget is described as:',
    'The one with the most categories', 'The one your bank prepares for you',
    'The one you''ll keep using next month', 'The one designed by an accountant', 'C', 5);

/* Quiz 3 — Saving Strategies */
INSERT INTO Question (QuizID, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, OrderIndex) VALUES
(3, 'The "pay yourself first" approach means:',
    'Treating yourself to luxuries first', 'Moving money to savings before any spending',
    'Paying off relatives first', 'Buying assets before clearing rent', 'B', 1),
(3, 'Why is keeping an emergency fund in your normal current account a bad idea?',
    'It earns no interest', 'It might be frozen',
    'You''ll see it and be tempted to spend it', 'Banks don''t allow it', 'C', 2),
(3, 'Which of these is suitable for parking an emergency fund?',
    'A stock in a single tech company', 'High-yield savings or money-market fund',
    'A long-dated corporate bond', 'Cryptocurrency', 'B', 3),
(3, 'A "standing instruction" helps your savings because:',
    'It earns extra interest', 'It moves money automatically before you can spend it',
    'It hides your account', 'It eliminates banking fees', 'B', 4),
(3, 'Which is the better way to phrase a savings goal?',
    '"Save more this year"', '"Be financially smart"',
    '"RM 12,000 emergency fund by December"', '"Earn more interest"', 'C', 5);

/* Quiz 4 — Debt Management */
INSERT INTO Question (QuizID, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, OrderIndex) VALUES
(4, 'Which is an example of productive debt?',
    'Credit card balance for a holiday', 'Personal loan for a wedding',
    'Home loan for a primary residence', 'Loan for branded fashion', 'C', 1),
(4, 'Roughly what range is typical for credit card interest in Malaysia?',
    '3% to 5% per year', '8% to 10% per year',
    '15% to 18% per year', '25% to 30% per year', 'C', 2),
(4, 'The debt avalanche method targets:',
    'Smallest balance first', 'Highest interest rate first',
    'Most recently taken debt', 'Debts owed to family', 'B', 3),
(4, 'The debt snowball method is best described as:',
    'Pay highest-interest debt first', 'Pay smallest balance first for psychological wins',
    'Borrow more to consolidate', 'Skip minimum payments', 'B', 4),
(4, 'Before taking on new debt, the key question to ask is:',
    'How much can I borrow?', 'What perks does the bank offer?',
    'If my income stopped tomorrow, could I still service this?', 'How long is the loan tenure?', 'C', 5);

/* Quiz 5 — Financial Goals */
INSERT INTO Question (QuizID, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, OrderIndex) VALUES
(5, 'A short-term financial goal typically has a timeframe of:',
    'Under 1 year', '3 to 5 years',
    '5 to 10 years', '10+ years', 'A', 1),
(5, 'For a long-term goal of 10+ years, the most suitable allocation is generally:',
    'All cash', 'Mostly fixed deposits',
    'Heavier in equities', 'Crypto only', 'C', 2),
(5, 'Which of the three is essential for every financial goal?',
    'A clear amount, deadline, and monthly commitment', 'A bank manager',
    'A side income', 'A debt collector''s number', 'A', 3),
(5, 'Goals without dates are described in the module as:',
    'Stretch targets', 'Dreams',
    'Mission statements', 'Bonus goals', 'B', 4),
(5, 'Why does the module recommend writing your top goals where you''ll see them daily?',
    'To impress visitors', 'Visible goals get pursued; forgotten ones get abandoned',
    'It''s required by the bank', 'To track your friends'' progress', 'B', 5);

/* Quiz 6 — Investing Fundamentals */
INSERT INTO Question (QuizID, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, OrderIndex) VALUES
(6, 'The main job of saving (versus investing) is:',
    'Preservation of money you''ll need soon', 'Aggressive growth',
    'Tax avoidance', 'Wealth transfer', 'A', 1),
(6, 'Inflation is a problem because it:',
    'Increases bank profits', 'Erodes the purchasing power of cash savings',
    'Causes interest to drop', 'Cancels out bond coupons', 'B', 2),
(6, 'The "miracle" of compound growth refers to:',
    'Bonus dividends', 'Returns earning their own returns over time',
    'Bank loyalty schemes', 'Tax rebates compounding', 'B', 3),
(6, 'In the example given, RM 500/month for 30 years at 7% becomes roughly:',
    'RM 180,000', 'RM 350,000',
    'RM 612,000', 'RM 1.5 million', 'C', 4),
(6, 'The earliest ringgit you invest is the most valuable because:',
    'It earns more interest in nominal terms today', 'It compounds for the longest time',
    'Inflation can''t touch it', 'Brokers reward early investors', 'B', 5);

/* Quiz 7 — Asset Classes */
INSERT INTO Question (QuizID, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, OrderIndex) VALUES
(7, 'Owning a share (stock) of a company means:',
    'You lent money to the company', 'You own part of the company',
    'You insured the company', 'You manage the company', 'B', 1),
(7, 'A bond is essentially:',
    'Ownership of a company', 'A loan to a government or company',
    'A type of insurance', 'A foreign currency contract', 'B', 2),
(7, 'Which generally has the highest long-term return AND highest short-term volatility?',
    'Cash', 'Bonds',
    'Stocks', 'Fixed deposits', 'C', 3),
(7, 'An ETF (exchange-traded fund) usually offers:',
    'Higher fees than unit trusts', 'Lower fees and trades on a stock exchange',
    'Guaranteed returns', 'A bank loan to invest', 'B', 4),
(7, 'A unit trust in Malaysia typically charges:',
    'No fees at all', 'Only a one-time RM 10 fee',
    'A sales charge plus an annual management fee', 'A government tax of 12%', 'C', 5);

/* Quiz 8 — Risk vs Return */
INSERT INTO Question (QuizID, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, OrderIndex) VALUES
(8, 'The first rule of investing stated in the module is:',
    'Always sell at peaks', 'Higher potential return comes with higher risk',
    'Diversification eliminates risk', 'Brokers know best', 'B', 1),
(8, 'Money you need next year should generally:',
    'Be fully in stocks', 'Not be in stocks',
    'Be in cryptocurrency', 'Be borrowed against', 'B', 2),
(8, 'Volatility (price swings) is:',
    'Exactly the same as permanent loss', 'Different from permanent loss until you sell',
    'Always negative', 'Only present in bonds', 'B', 3),
(8, 'Diversification works by:',
    'Picking the single best stock', 'Spreading risk so no one bad outcome wrecks you',
    'Borrowing to invest more', 'Timing market dips perfectly', 'B', 4),
(8, 'If you''d panic-sell during a 30% drop, this suggests:',
    'You should borrow more to buy', 'Your real risk tolerance is lower than you think',
    'You''re ready for crypto', 'You should switch to day trading', 'B', 5);

/* Quiz 9 — How Markets Work */
INSERT INTO Question (QuizID, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, OrderIndex) VALUES
(9, 'Malaysia''s main stock exchange is:',
    'NASDAQ', 'NYSE',
    'Bursa Malaysia', 'Hang Seng', 'C', 1),
(9, 'An IPO is when:',
    'A company goes private', 'A company first offers shares to the public',
    'A bond matures', 'A unit trust closes', 'B', 2),
(9, 'In the long term, share prices follow:',
    'Social media buzz', 'Company earnings',
    'Lunar cycles', 'Government press releases', 'B', 3),
(9, 'An index like the KLCI is best described as:',
    'A guaranteed return product', 'A measuring stick for how the market did',
    'A type of bond', 'A bank''s internal scorecard', 'B', 4),
(9, 'Global diversification helps because:',
    'It eliminates all losses', 'No single country''s market drives your whole result',
    'Foreign investments are tax-free everywhere', 'It removes the need to rebalance', 'B', 5);

/* Quiz 10 — Opening Accounts */
INSERT INTO Question (QuizID, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, OrderIndex) VALUES
(10, 'To trade on Bursa Malaysia you need a CDS account and:',
    'An EPF account', 'A trading account with a broker',
    'A current account at any bank', 'A foreign passport', 'B', 1),
(10, 'EPF i-Invest allows members to:',
    'Withdraw all EPF savings', 'Invest part of Account 1 into approved unit trusts',
    'Borrow against Account 2', 'Buy property directly via EPF', 'B', 2),
(10, 'Dollar-cost averaging means:',
    'Buying a single lump sum at the lowest price', 'Investing a fixed amount on a regular schedule',
    'Only buying when the market drops', 'Selling whenever prices rise', 'B', 3),
(10, 'Documents typically needed to open a brokerage account include:',
    'MyKad and a recent bank statement', 'A medical certificate',
    'A driving licence and police report', 'A school transcript', 'A', 4),
(10, 'For most beginners, the simplest sensible default is:',
    'Day trading penny stocks', 'Automated monthly investing and resisting the urge to fiddle',
    'All-in on the latest IPO', 'Borrowing to invest', 'B', 5);

/* Quiz 11 — Asset Allocation */
INSERT INTO Question (QuizID, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, OrderIndex) VALUES
(11, 'Studies suggest asset allocation explains roughly what share of long-term return variation?',
    '10–20%', '40–50%',
    '80–90%', 'About 5%', 'C', 1),
(11, 'Using the "110 minus age" rule, a 30-year-old has what equities weight?',
    '50%', '70%',
    '80%', '100%', 'C', 2),
(11, 'Within equities, diversifying across geographies and sectors helps reduce:',
    'Tax bills', 'Concentration risk',
    'Brokerage commissions', 'Inflation', 'B', 3),
(11, 'A documented allocation policy is most useful for:',
    'Showing off to friends', 'Keeping you disciplined when markets are wild',
    'Avoiding all taxes', 'Reducing bank fees', 'B', 4),
(11, 'Which of these is a sensible 30-year-old portfolio described in the module?',
    'All cash', '100% cryptocurrency',
    '50% global equities, 20% Malaysian equities, 20% bonds, 10% cash', '100% Malaysian small caps', 'C', 5);

/* Quiz 12 — Rebalancing */
INSERT INTO Question (QuizID, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, OrderIndex) VALUES
(12, 'Rebalancing means:',
    'Selling everything and starting over', 'Bringing the portfolio back to its target allocation',
    'Doubling down on the winner', 'Switching to a new broker', 'B', 1),
(12, 'Calendar rebalancing typically happens:',
    'Every trading day', 'Once a year',
    'Only after a crash', 'Every leap year', 'B', 2),
(12, 'Threshold rebalancing kicks in when an asset class drifts by roughly:',
    '0.5 percentage points', '5 percentage points',
    '20 percentage points', '50 percentage points', 'B', 3),
(12, 'Rebalancing mechanically achieves what desirable behaviour?',
    'Buying high and selling low', 'Buying low and selling high without forecasting',
    'Eliminating volatility', 'Lowering taxes to zero', 'B', 4),
(12, 'In taxable accounts, the preferred way to rebalance is often:',
    'Sell winners aggressively', 'Use new contributions to top up under-target assets',
    'Borrow to buy more', 'Wait for retirement', 'B', 5);

/* Quiz 13 — Tax Planning */
INSERT INTO Question (QuizID, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, OrderIndex) VALUES
(13, 'Currently in Malaysia, capital gains on most listed equities are:',
    'Taxed at 30%', 'Taxed at 15%',
    'Generally not taxed', 'Taxed only for foreigners', 'C', 1),
(13, 'The Private Retirement Scheme (PRS) tax relief is up to:',
    'RM 500 per year', 'RM 1,000 per year',
    'RM 3,000 per year (until 2025)', 'RM 10,000 per year', 'C', 2),
(13, 'Why might maxing PRS be one of the highest-return moves available?',
    'It''s a guaranteed first-year tax saving', 'It pays a fixed 20% return',
    'It''s insured by Bank Negara', 'It avoids EPF contributions', 'A', 3),
(13, 'Which of these is NOT a Malaysian tax relief mentioned in the module?',
    'PRS contribution relief', 'Medical insurance relief',
    'SSPN savings relief', 'Designer clothing relief', 'D', 4),
(13, 'Foreign-source income remitted into Malaysia is now generally:',
    'Always tax-free', 'Generally taxable (with transitional exemptions)',
    'Confiscated', 'Only taxable for retirees', 'B', 5);

/* Quiz 14 — Retirement Planning */
INSERT INTO Question (QuizID, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, OrderIndex) VALUES
(14, 'The EPF rough target by age 50 is:',
    '1× annual salary', '3× annual salary',
    '6× annual salary', '20× annual salary', 'C', 1),
(14, 'The 4% rule suggests your portfolio should be roughly:',
    '5× annual expenses', '10× annual expenses',
    '25× annual expenses', '100× annual expenses', 'C', 2),
(14, 'To support RM 6,000/month in retirement under the 4% rule, you need roughly:',
    'RM 200,000', 'RM 500,000',
    'RM 900,000', 'RM 1.8 million', 'D', 3),
(14, 'Starting at 25 instead of 45 with the same contribution makes a huge difference because of:',
    'Tax breaks', 'Compound growth over more years',
    'Lower fees for young investors', 'Bank loyalty bonuses', 'B', 4),
(14, 'The module recommends layering retirement income across:',
    'EPF only', 'PRS only',
    'EPF, PRS, and personal investments', 'Property only', 'C', 5);

/* Quiz 15 — Wealth Protection */
INSERT INTO Question (QuizID, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, OrderIndex) VALUES
(15, 'The role of insurance is to cover:',
    'Daily expenses', 'Low-probability, high-impact events',
    'Vacation costs', 'Tax bills', 'B', 1),
(15, 'A common rule of thumb for term life cover for someone with dependants is:',
    '1× annual income', '3× annual income',
    '10× annual income', '50× annual income', 'C', 2),
(15, 'Why does the module suggest avoiding investment-linked policies (ILPs)?',
    'They aren''t legal', 'They tend to be expensive for both insurance and investing',
    'They guarantee 20% returns', 'Only foreigners can buy them', 'B', 3),
(15, 'Estate planning matters because:',
    'It''s only for the very rich', 'A simple will prevents long, costly probate disputes',
    'It eliminates all inheritance tax', 'It increases EPF returns', 'B', 4),
(15, 'Most large financial losses come from:',
    'Market crashes alone', 'Scams, panic-selling, and chasing speculative bets',
    'Government policy', 'Bank failures', 'B', 5);

GO
USE GrowWealthDB;
GO

/* ------------------------------------------------------------
   Enrollments
   ------------------------------------------------------------ */

INSERT INTO Enrollment (UserID, CourseID, EnrolledAt) VALUES
-- Ahmad (most progressed): 3 courses
(2, 1, DATEADD(month, -5, GETDATE())),
(2, 2, DATEADD(month, -3, GETDATE())),
(2, 3, DATEADD(month, -1, GETDATE())),
-- Wei Ling: 2 courses
(3, 1, DATEADD(month, -4, GETDATE())),
(3, 2, DATEADD(month, -2, GETDATE())),
-- Priya: 2 courses
(4, 1, DATEADD(month, -3, GETDATE())),
(4, 2, DATEADD(week, -3, GETDATE())),
-- Chee Keong: 1 course
(5, 1, DATEADD(month, -2, GETDATE())),
-- Siti: 1 course
(6, 1, DATEADD(week, -5, GETDATE()));

GO

/* ------------------------------------------------------------
   UserProgress — varied completion
   ------------------------------------------------------------ */

-- Ahmad: completed all of Course 1, 4 of 5 in Course 2, 2 of 5 in Course 3
INSERT INTO UserProgress (UserID, ModuleID, IsCompleted, CompletedAt) VALUES
(2, 1, 1, DATEADD(month, -5, GETDATE())),
(2, 2, 1, DATEADD(month, -5, GETDATE())),
(2, 3, 1, DATEADD(month, -4, GETDATE())),
(2, 4, 1, DATEADD(month, -4, GETDATE())),
(2, 5, 1, DATEADD(month, -4, GETDATE())),
(2, 6, 1, DATEADD(month, -3, GETDATE())),
(2, 7, 1, DATEADD(month, -3, GETDATE())),
(2, 8, 1, DATEADD(month, -2, GETDATE())),
(2, 9, 1, DATEADD(month, -2, GETDATE())),
(2, 11, 1, DATEADD(week, -3, GETDATE())),
(2, 12, 1, DATEADD(week, -1, GETDATE()));

-- Wei Ling: completed 4 of 5 Course 1, 2 of 5 Course 2
INSERT INTO UserProgress (UserID, ModuleID, IsCompleted, CompletedAt) VALUES
(3, 1, 1, DATEADD(month, -4, GETDATE())),
(3, 2, 1, DATEADD(month, -4, GETDATE())),
(3, 3, 1, DATEADD(month, -3, GETDATE())),
(3, 4, 1, DATEADD(month, -3, GETDATE())),
(3, 6, 1, DATEADD(month, -2, GETDATE())),
(3, 7, 1, DATEADD(week, -2, GETDATE()));

-- Priya: completed 3 of 5 Course 1, 1 of 5 Course 2
INSERT INTO UserProgress (UserID, ModuleID, IsCompleted, CompletedAt) VALUES
(4, 1, 1, DATEADD(month, -3, GETDATE())),
(4, 2, 1, DATEADD(month, -3, GETDATE())),
(4, 3, 1, DATEADD(month, -2, GETDATE())),
(4, 6, 1, DATEADD(week, -2, GETDATE()));

-- Chee Keong: completed 2 of 5 Course 1
INSERT INTO UserProgress (UserID, ModuleID, IsCompleted, CompletedAt) VALUES
(5, 1, 1, DATEADD(month, -2, GETDATE())),
(5, 2, 1, DATEADD(month, -1, GETDATE()));

-- Siti: completed 1 of 5 Course 1
INSERT INTO UserProgress (UserID, ModuleID, IsCompleted, CompletedAt) VALUES
(6, 1, 1, DATEADD(week, -4, GETDATE()));

GO

/* ------------------------------------------------------------
   Quiz Attempts — varied scores across users
   QuizID = ModuleID (same insertion order)
   ------------------------------------------------------------ */

INSERT INTO Quiz_Attempt (UserID, QuizID, Score, TotalQuestions, AttemptedAt) VALUES
-- Ahmad's attempts
(2, 1, 4, 5, DATEADD(month, -5, GETDATE())),
(2, 1, 5, 5, DATEADD(month, -5, GETDATE())),
(2, 2, 5, 5, DATEADD(month, -5, GETDATE())),
(2, 3, 4, 5, DATEADD(month, -4, GETDATE())),
(2, 4, 5, 5, DATEADD(month, -4, GETDATE())),
(2, 5, 5, 5, DATEADD(month, -4, GETDATE())),
(2, 6, 4, 5, DATEADD(month, -3, GETDATE())),
(2, 7, 5, 5, DATEADD(month, -3, GETDATE())),
(2, 8, 4, 5, DATEADD(month, -2, GETDATE())),
(2, 9, 5, 5, DATEADD(month, -2, GETDATE())),
(2, 11, 4, 5, DATEADD(week, -3, GETDATE())),
(2, 12, 5, 5, DATEADD(week, -1, GETDATE())),
-- Wei Ling's attempts
(3, 1, 3, 5, DATEADD(month, -4, GETDATE())),
(3, 1, 5, 5, DATEADD(month, -4, GETDATE())),
(3, 2, 4, 5, DATEADD(month, -4, GETDATE())),
(3, 3, 4, 5, DATEADD(month, -3, GETDATE())),
(3, 4, 3, 5, DATEADD(month, -3, GETDATE())),
(3, 4, 5, 5, DATEADD(month, -3, GETDATE())),
(3, 6, 4, 5, DATEADD(month, -2, GETDATE())),
(3, 7, 5, 5, DATEADD(week, -2, GETDATE())),
-- Priya's attempts
(4, 1, 4, 5, DATEADD(month, -3, GETDATE())),
(4, 2, 5, 5, DATEADD(month, -3, GETDATE())),
(4, 3, 3, 5, DATEADD(month, -2, GETDATE())),
(4, 3, 5, 5, DATEADD(month, -2, GETDATE())),
(4, 6, 4, 5, DATEADD(week, -2, GETDATE())),
-- Chee Keong's attempts
(5, 1, 3, 5, DATEADD(month, -2, GETDATE())),
(5, 1, 4, 5, DATEADD(month, -2, GETDATE())),
(5, 2, 4, 5, DATEADD(month, -1, GETDATE())),
-- Siti's attempts
(6, 1, 2, 5, DATEADD(week, -4, GETDATE())),
(6, 1, 4, 5, DATEADD(week, -4, GETDATE())),
-- Daniel (suspended) - past attempts
(7, 1, 3, 5, DATEADD(month, -5, GETDATE())),
(7, 2, 4, 5, DATEADD(month, -5, GETDATE()));

GO

/* ------------------------------------------------------------
   Login Logs — recent activity
   ------------------------------------------------------------ */

INSERT INTO Login_Log (UserID, LoginTime, IPAddress, Success, FailReason) VALUES
(1, DATEADD(hour, -2, GETDATE()), '203.115.20.14', 1, NULL),
(1, DATEADD(day, -1, GETDATE()), '203.115.20.14', 1, NULL),
(1, DATEADD(day, -3, GETDATE()), '203.115.20.14', 1, NULL),
(2, DATEADD(hour, -6, GETDATE()), '60.51.103.22', 1, NULL),
(2, DATEADD(day, -1, GETDATE()), '60.51.103.22', 1, NULL),
(2, DATEADD(day, -2, GETDATE()), '60.51.103.22', 1, NULL),
(2, DATEADD(day, -4, GETDATE()), '60.51.103.22', 1, NULL),
(3, DATEADD(day, -1, GETDATE()), '115.164.55.18', 1, NULL),
(3, DATEADD(day, -2, GETDATE()), '115.164.55.18', 1, NULL),
(3, DATEADD(day, -5, GETDATE()), '115.164.55.18', 1, NULL),
(4, DATEADD(day, -2, GETDATE()), '175.139.42.10', 1, NULL),
(4, DATEADD(day, -3, GETDATE()), '175.139.42.10', 1, NULL),
(5, DATEADD(day, -3, GETDATE()), '202.188.66.7', 1, NULL),
(6, DATEADD(day, -1, GETDATE()), '210.187.81.45', 1, NULL),
(6, DATEADD(day, -4, GETDATE()), '210.187.81.45', 1, NULL),
(NULL, DATEADD(day, -2, GETDATE()), '113.210.45.99', 0, 'Invalid credentials'),
(NULL, DATEADD(day, -5, GETDATE()), '203.82.81.30', 0, 'Invalid credentials'),
(7, DATEADD(day, -30, GETDATE()), '120.142.21.55', 0, 'Account suspended');

GO

/* ------------------------------------------------------------
   Investment Simulations — sample lab runs
   ------------------------------------------------------------ */

INSERT INTO InvestmentSimulation
    (UserID, InitialAmount, MonthlyContribution, AnnualRate, DurationYears, CompoundingPerYear, FinalValue, InterestEarned, RunAt)
VALUES
    (2, 10000.00, 500.00,  7.000, 20, 12, 299826.50, 169826.50, DATEADD(month, -2, GETDATE())),
    (2, 50000.00, 1000.00, 8.000, 10, 12, 295018.40, 125018.40, DATEADD(week, -3, GETDATE())),
    (2, 5000.00,  300.00,  6.500, 15, 12, 102441.20, 43441.20,  DATEADD(week, -1, GETDATE())),
    (3, 20000.00, 800.00,  7.500, 25, 12, 805264.80, 545264.80, DATEADD(month, -1, GETDATE())),
    (3, 15000.00, 600.00,  6.000, 20, 12, 327552.10, 168552.10, DATEADD(week, -2, GETDATE())),
    (4, 8000.00,  400.00,  7.000, 15, 12, 153720.30, 73720.30,  DATEADD(week, -2, GETDATE())),
    (5, 5000.00,  250.00,  5.500, 10, 12, 49215.60,  14215.60,  DATEADD(week, -1, GETDATE())),
    (6, 3000.00,  200.00,  6.000, 25, 12, 152822.40, 89822.40,  DATEADD(day, -5, GETDATE()));

GO

PRINT 'Grow Wealth database seeded successfully.';
PRINT '------------------------------------------';
PRINT 'Admin login:    admin@growwealth.com / admin123';
PRINT 'Member login:   ahmad@email.com      / password123';
PRINT '                weiling@email.com    / password123';
PRINT '                priya@email.com      / password123';
PRINT '                cheekeong@email.com  / password123';
PRINT '                siti@email.com       / password123';
PRINT 'Suspended:      daniel@email.com     / password123';
GO
