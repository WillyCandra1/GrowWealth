<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/Master/after_landing.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="GrowWealth.Pages.Member.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .dash-header {
            margin-bottom: 2rem;
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .dash-header-text h1 {
            font-size: 2.5rem;
            margin-bottom: 0.35rem;
            color: var(--gw-ink);
        }

        .dash-header-text h1 em {
            font-style: italic;
            color: var(--gw-accent);
            font-weight: 500;
        }

        .dash-header-text p {
            color: var(--gw-ink-muted);
            font-size: 1rem;
            margin: 0;
        }

        .dash-date {
            color: var(--gw-ink-muted);
            font-size: 0.88rem;
            font-variant-numeric: tabular-nums;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 1.25rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background-color: var(--gw-surface);
            border: 1px solid var(--gw-line);
            border-radius: 16px;
            padding: 1.6rem 1.75rem;
            position: relative;
            overflow: hidden;
        }

        .stat-card.accent {
            background: linear-gradient(135deg, #0b6b3a 0%, #094f2b 100%);
            border-color: transparent;
            color: white;
        }

        .stat-card.accent .stat-label,
        .stat-card.accent .stat-value,
        .stat-card.accent .stat-trend { color: white; }

        .stat-card.accent .stat-trend { opacity: 0.85; }

        .stat-label {
            font-size: 0.75rem;
            font-weight: 600;
            color: var(--gw-ink-muted);
            text-transform: uppercase;
            letter-spacing: 0.1em;
            margin-bottom: 0.85rem;
        }

        .stat-value {
            font-family: var(--gw-serif);
            font-size: 2.75rem;
            font-weight: 600;
            color: var(--gw-ink);
            line-height: 1;
            letter-spacing: -0.02em;
            font-variant-numeric: tabular-nums;
        }

        .stat-value .stat-unit {
            font-size: 1.5rem;
            color: var(--gw-ink-muted);
            margin-left: 0.15rem;
        }

        .stat-card.accent .stat-value .stat-unit { color: rgba(255,255,255,0.7); }

        .stat-trend {
            font-size: 0.82rem;
            color: var(--gw-ink-muted);
            margin-top: 0.7rem;
        }

        .two-column {
            display: grid;
            grid-template-columns: 1.65fr 1fr;
            gap: 1.5rem;
            margin-bottom: 1.5rem;
        }

        .panel {
            background-color: var(--gw-surface);
            border: 1px solid var(--gw-line);
            border-radius: 16px;
            padding: 1.75rem;
        }

        .panel-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid var(--gw-line-soft);
        }

        .panel-header h2 {
            font-size: 1.25rem;
            margin: 0;
            color: var(--gw-ink);
        }

        .panel-header .panel-meta {
            font-size: 0.82rem;
            color: var(--gw-ink-muted);
            font-weight: 500;
        }

        .course-progress-row {
            padding: 1rem 0;
            border-bottom: 1px solid var(--gw-line-soft);
        }

        .course-progress-row:last-of-type { border-bottom: none; }

        .course-progress-top {
            display: flex;
            justify-content: space-between;
            align-items: baseline;
            margin-bottom: 0.55rem;
        }

        .course-progress-title {
            font-weight: 600;
            color: var(--gw-ink);
            font-size: 0.98rem;
        }

        .course-progress-fraction {
            color: var(--gw-ink-muted);
            font-size: 0.85rem;
            font-variant-numeric: tabular-nums;
        }

        .progress-track {
            height: 6px;
            background-color: var(--gw-line-soft);
            border-radius: 999px;
            overflow: hidden;
        }

        .progress-fill {
            height: 100%;
            background: linear-gradient(90deg, var(--gw-accent) 0%, #0d8048 100%);
            border-radius: 999px;
            transition: width 0.8s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .course-progress-percent {
            font-size: 0.82rem;
            color: var(--gw-ink-muted);
            margin-top: 0.45rem;
            font-variant-numeric: tabular-nums;
        }

        .continue-row {
            margin-top: 1.5rem;
            padding-top: 1.25rem;
            border-top: 1px solid var(--gw-line-soft);
        }

        .btn-continue {
            background-color: var(--gw-ink);
            color: var(--gw-paper);
            border: 1px solid var(--gw-ink);
            padding: 0.7rem 1.4rem;
            border-radius: 6px;
            font-family: var(--gw-sans);
            font-size: 0.92rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.18s;
        }

        .btn-continue:hover {
            background-color: var(--gw-accent-dark);
            border-color: var(--gw-accent-dark);
        }

        .btn-continue:disabled {
            opacity: 0.45;
            cursor: not-allowed;
        }

        .quiz-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.85rem 0;
            border-bottom: 1px solid var(--gw-line-soft);
        }

        .quiz-row:last-of-type { border-bottom: none; }

        .quiz-row-info { flex: 1; min-width: 0; }

        .quiz-row-title {
            color: var(--gw-ink);
            font-size: 0.93rem;
            font-weight: 500;
            display: block;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .quiz-row-sub {
            color: var(--gw-ink-muted);
            font-size: 0.78rem;
            margin-top: 0.15rem;
        }

        .score-pill {
            padding: 0.3rem 0.75rem;
            border-radius: 999px;
            font-size: 0.85rem;
            font-weight: 600;
            font-variant-numeric: tabular-nums;
            margin-left: 1rem;
            flex-shrink: 0;
        }

        .score-pill.pass {
            background-color: var(--gw-accent-soft);
            color: var(--gw-accent);
        }

        .score-pill.fail {
            background-color: var(--gw-rose-soft);
            color: var(--gw-rose);
        }

        .activity-row {
            display: flex;
            align-items: center;
            padding: 0.95rem 0;
            border-bottom: 1px solid var(--gw-line-soft);
            font-size: 0.92rem;
        }

        .activity-row:last-of-type { border-bottom: none; }

        .activity-icon {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background-color: var(--gw-accent-soft);
            color: var(--gw-accent);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 0.85rem;
            font-weight: 700;
            font-family: var(--gw-serif);
            margin-right: 0.85rem;
            flex-shrink: 0;
        }

        .activity-icon.quiz { background-color: var(--gw-gold-soft); color: var(--gw-gold); }
        .activity-icon.enroll { background-color: #e3eaf4; color: #2d4a5c; }

        .activity-text {
            flex: 1;
            color: var(--gw-ink);
        }

        .activity-time {
            color: var(--gw-ink-muted);
            font-size: 0.8rem;
            white-space: nowrap;
            margin-left: 1rem;
            font-variant-numeric: tabular-nums;
        }

        .empty-state {
            color: var(--gw-ink-muted);
            font-size: 0.92rem;
            padding: 1.5rem 0;
            text-align: center;
            font-style: italic;
        }

        @media (max-width: 960px) {
            .stats-grid { grid-template-columns: 1fr; }
            .two-column { grid-template-columns: 1fr; }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div class="dash-header">
        <div class="dash-header-text">
            <h1>Welcome back, <em><asp:Literal ID="litWelcomeName" runat="server"></asp:Literal></em></h1>
            <p>Pick up where you left off and keep building your financial knowledge.</p>
        </div>
        <div class="dash-date">
            <asp:Literal ID="litToday" runat="server"></asp:Literal>
        </div>
    </div>

    <div class="stats-grid">
        <div class="stat-card accent">
            <div class="stat-label">Courses enrolled</div>
            <div class="stat-value">
                <asp:Literal ID="litCoursesEnrolled" runat="server" Text="0"></asp:Literal>
            </div>
            <div class="stat-trend">
                <asp:Literal ID="litCoursesTrend" runat="server"></asp:Literal>
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-label">Modules completed</div>
            <div class="stat-value">
                <asp:Literal ID="litModulesCompleted" runat="server" Text="0"></asp:Literal>
                <span class="stat-unit">/ <asp:Literal ID="litModulesTotal" runat="server" Text="0"></asp:Literal></span>
            </div>
            <div class="stat-trend">
                <asp:Literal ID="litModulesTrend" runat="server"></asp:Literal>
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-label">Average quiz score</div>
            <div class="stat-value">
                <asp:Literal ID="litAvgQuizScore" runat="server" Text="0"></asp:Literal>
                <span class="stat-unit">%</span>
            </div>
            <div class="stat-trend">
                <asp:Literal ID="litQuizTrend" runat="server"></asp:Literal>
            </div>
        </div>
    </div>

    <div class="two-column">

        <div class="panel">
            <div class="panel-header">
                <h2>Course progress</h2>
                <span class="panel-meta">
                    <asp:Literal ID="litCourseCount" runat="server"></asp:Literal>
                </span>
            </div>

            <asp:Repeater ID="rptCourseProgress" runat="server">
                <ItemTemplate>
                    <div class="course-progress-row">
                        <div class="course-progress-top">
                            <span class="course-progress-title"><%# Eval("CourseTitle") %></span>
                            <span class="course-progress-fraction"><%# Eval("CompletedModules") %> / <%# Eval("TotalModules") %> modules</span>
                        </div>
                        <div class="progress-track">
                            <div class="progress-fill" style="width: <%# Eval("PercentComplete") %>%;"></div>
                        </div>
                        <div class="course-progress-percent"><%# Eval("PercentComplete") %>% complete</div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <asp:Panel ID="pnlNoCourses" runat="server" Visible="false">
                <div class="empty-state">You haven't enrolled in any course yet. Visit the Courses page to get started.</div>
            </asp:Panel>

            <div class="continue-row">
                <asp:Button ID="btnContinue" runat="server" Text="Continue learning &rarr;"
                    CssClass="btn-continue" OnClick="btnContinue_Click" />
            </div>
        </div>

        <div class="panel">
            <div class="panel-header">
                <h2>Recent quiz scores</h2>
                <span class="panel-meta">Last 5</span>
            </div>

            <asp:Repeater ID="rptRecentQuizzes" runat="server">
                <ItemTemplate>
                    <div class="quiz-row">
                        <div class="quiz-row-info">
                            <span class="quiz-row-title"><%# Eval("QuizTitle") %></span>
                            <span class="quiz-row-sub"><%# Eval("AttemptedDate") %></span>
                        </div>
                        <span class='<%# Convert.ToInt32(Eval("ScorePercent")) >= 60 ? "score-pill pass" : "score-pill fail" %>'>
                            <%# Eval("ScorePercent") %>%
                        </span>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <asp:Panel ID="pnlNoQuizzes" runat="server" Visible="false">
                <div class="empty-state">No quiz attempts yet. Take a quiz at the end of any module.</div>
            </asp:Panel>
        </div>
    </div>

    <div class="panel">
        <div class="panel-header">
            <h2>Recent activity</h2>
            <span class="panel-meta">Across your account</span>
        </div>

        <asp:Repeater ID="rptRecentActivity" runat="server">
            <ItemTemplate>
                <div class="activity-row">
                    <span class='<%# "activity-icon " + Eval("IconClass") %>'><%# Eval("IconText") %></span>
                    <span class="activity-text"><%# Eval("Description") %></span>
                    <span class="activity-time"><%# Eval("RelativeTime") %></span>
                </div>
            </ItemTemplate>
        </asp:Repeater>

        <asp:Panel ID="pnlNoActivity" runat="server" Visible="false">
            <div class="empty-state">No activity to show yet.</div>
        </asp:Panel>
    </div>

</asp:Content>
