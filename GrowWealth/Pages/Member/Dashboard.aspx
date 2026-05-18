<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/Master/after_landing.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="GrowWealth.Pages.Member.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        /* Dashboard-specific styles (kept local so they don't affect other pages) */
        .dash-header { margin-bottom: 1.5rem; }
        .dash-header h1 { margin-bottom: 0.25rem; }
        .dash-header p { color: var(--text-secondary); margin: 0; }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 1.25rem;
            margin-bottom: 1.5rem;
        }

        .stat-card {
            background-color: var(--surface);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 1.75rem 1.5rem;
            text-align: center;
        }

        .stat-card .stat-value {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--text-primary);
            line-height: 1;
            margin-bottom: 0.5rem;
        }

        .stat-card .stat-label {
            color: var(--text-secondary);
            font-size: 0.9rem;
        }

        .dash-row {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 1.5rem;
            margin-bottom: 1.5rem;
        }

        .panel {
            background-color: var(--surface);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 1.5rem;
        }

        .panel h2 {
            font-size: 1.125rem;
            margin-bottom: 1.25rem;
        }

        .course-row { margin-bottom: 1.25rem; }
        .course-row:last-child { margin-bottom: 0; }

        .course-row-top {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 0.5rem;
        }

        .course-title { font-weight: 600; color: var(--text-primary); }
        .course-fraction { color: var(--text-secondary); font-size: 0.9rem; }

        .progress-bar {
            background-color: #ece9f5;
            height: 8px;
            border-radius: 4px;
            overflow: hidden;
        }

        .progress-fill {
            background-color: var(--primary);
            height: 100%;
        }

        .course-percent {
            font-size: 0.8rem;
            color: var(--text-secondary);
            margin-top: 0.25rem;
        }

        .quiz-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.6rem 0;
            border-bottom: 1px solid var(--border);
        }
        .quiz-row:last-child { border-bottom: none; }
        .quiz-row .quiz-title { font-size: 0.9rem; color: var(--text-primary); }

        .score-badge {
            padding: 0.25rem 0.6rem;
            border-radius: 999px;
            font-size: 0.8rem;
            font-weight: 600;
        }
        .score-good { background-color: var(--success); color: var(--success-text); }
        .score-bad { background-color: var(--error); color: var(--error-text); }

        .activity-row {
            display: flex;
            justify-content: space-between;
            padding: 0.8rem 0;
            border-bottom: 1px solid var(--border);
            font-size: 0.9rem;
        }
        .activity-row:last-child { border-bottom: none; }
        .activity-row .activity-time { color: var(--text-secondary); font-size: 0.8rem; }

        .empty-state { color: var(--text-secondary); font-size: 0.9rem; padding: 0.5rem 0; }

        @media (max-width: 900px) {
            .stats-grid { grid-template-columns: 1fr; }
            .dash-row { grid-template-columns: 1fr; }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div class="dash-header">
        <h1>My dashboard</h1>
        <p>Welcome back, <asp:Literal ID="litWelcomeName" runat="server"></asp:Literal>!</p>
    </div>

    <!-- Top stat cards -->
    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-value">
                <asp:Literal ID="litCoursesEnrolled" runat="server" Text="0"></asp:Literal>
            </div>
            <div class="stat-label">Courses enrolled</div>
        </div>
        <div class="stat-card">
            <div class="stat-value">
                <asp:Literal ID="litModulesCompleted" runat="server" Text="0"></asp:Literal>
            </div>
            <div class="stat-label">Modules completed</div>
        </div>
        <div class="stat-card">
            <div class="stat-value">
                <asp:Literal ID="litAvgQuizScore" runat="server" Text="0%"></asp:Literal>
            </div>
            <div class="stat-label">Average quiz score</div>
        </div>
    </div>

    <!-- Course progress + Recent quiz scores -->
    <div class="dash-row">

        <!-- Course progress panel -->
        <div class="panel">
            <h2>Course progress</h2>

            <asp:Repeater ID="rptCourseProgress" runat="server">
                <ItemTemplate>
                    <div class="course-row">
                        <div class="course-row-top">
                            <span class="course-title"><%# Eval("CourseTitle") %></span>
                            <span class="course-fraction">
                                <%# Eval("CompletedModules") %> of <%# Eval("TotalModules") %> modules
                            </span>
                        </div>
                        <div class="progress-bar">
                            <div class="progress-fill" style="width: <%# Eval("PercentComplete") %>%;"></div>
                        </div>
                        <div class="course-percent">
                            <%# Eval("PercentComplete") %>% complete
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <asp:Panel ID="pnlNoCourses" runat="server" Visible="false">
                <p class="empty-state">You are not enrolled in any course yet.</p>
            </asp:Panel>

            <br />
            <asp:Button ID="btnContinue" runat="server" Text="Continue learning"
                CssClass="btn btn-primary" OnClick="btnContinue_Click" />
        </div>

        <!-- Recent quiz scores panel -->
        <div class="panel">
            <h2>Recent quiz scores</h2>

            <asp:Repeater ID="rptRecentQuizzes" runat="server">
                <ItemTemplate>
                    <div class="quiz-row">
                        <span class="quiz-title"><%# Eval("QuizTitle") %></span>
                        <span class='<%# Convert.ToInt32(Eval("ScorePercent")) >= 60 ? "score-badge score-good" : "score-badge score-bad" %>'>
                            <%# Eval("ScorePercent") %>%
                        </span>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <asp:Panel ID="pnlNoQuizzes" runat="server" Visible="false">
                <p class="empty-state">No quiz attempts yet.</p>
            </asp:Panel>
        </div>
    </div>

    <!-- Recent activity panel -->
    <div class="panel">
        <h2>Recent activity</h2>

        <asp:Repeater ID="rptRecentActivity" runat="server">
            <ItemTemplate>
                <div class="activity-row">
                    <span><%# Eval("Description") %></span>
                    <span class="activity-time"><%# Eval("RelativeTime") %></span>
                </div>
            </ItemTemplate>
        </asp:Repeater>

        <asp:Panel ID="pnlNoActivity" runat="server" Visible="false">
            <p class="empty-state">No recent activity to show.</p>
        </asp:Panel>
    </div>

</asp:Content>
