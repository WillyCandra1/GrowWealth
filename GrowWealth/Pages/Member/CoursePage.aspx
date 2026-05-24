<%@ Page Title="Courses" Language="C#" MasterPageFile="~/Master/after_landing.Master" AutoEventWireup="true" CodeBehind="CoursePage.aspx.cs" Inherits="GrowWealth.Pages.Member.CoursePage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .courses-header {
            margin-bottom: 2rem;
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .courses-header h1 {
            font-size: 2.4rem;
            margin-bottom: 0.3rem;
        }

        .courses-header p {
            color: var(--gw-ink-muted);
            margin: 0;
            font-size: 1rem;
        }

        .catalogue-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(310px, 1fr));
            gap: 1.5rem;
        }

        .course-card {
            background-color: var(--gw-surface);
            border: 1px solid var(--gw-line);
            border-radius: 16px;
            padding: 1.75rem;
            display: flex;
            flex-direction: column;
            min-height: 280px;
            transition: all 0.22s ease;
        }

        .course-card:hover {
            border-color: var(--gw-accent);
            transform: translateY(-2px);
            box-shadow: 0 8px 24px rgba(11, 107, 58, 0.08);
        }

        .course-tag {
            display: inline-block;
            background-color: var(--gw-gold-soft);
            color: var(--gw-gold);
            padding: 0.25rem 0.7rem;
            border-radius: 999px;
            font-size: 0.72rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            align-self: flex-start;
            margin-bottom: 1.1rem;
        }

        .course-tag.beginner { background-color: var(--gw-accent-soft); color: var(--gw-accent); }
        .course-tag.intermediate { background-color: var(--gw-gold-soft); color: var(--gw-gold); }
        .course-tag.advanced { background-color: var(--gw-rose-soft); color: var(--gw-rose); }

        .course-card h3 {
            font-size: 1.3rem;
            margin-bottom: 0.5rem;
            color: var(--gw-ink);
        }

        .course-desc {
            color: var(--gw-ink-soft);
            font-size: 0.92rem;
            flex: 1;
            margin-bottom: 1.25rem;
        }

        .course-stats {
            display: flex;
            gap: 1.25rem;
            margin-bottom: 1.25rem;
            color: var(--gw-ink-muted);
            font-size: 0.85rem;
        }

        .course-stats span strong {
            color: var(--gw-ink);
            font-family: var(--gw-serif);
            font-weight: 600;
        }

        .course-actions {
            display: flex;
            gap: 0.6rem;
        }

        a.btn-primary {
            background-color: var(--gw-ink);
            color: #ffffff;
            border: 1px solid var(--gw-ink);
            padding: 0.65rem 1.2rem;
            border-radius: 6px;
            font-family: var(--gw-sans);
            font-size: 0.88rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.18s;
            text-decoration: none;
            display: inline-block;
        }

        a.btn-primary:hover {
            background-color: var(--gw-accent-dark);
            border-color: var(--gw-accent-dark);
            color: #ffffff;
        }

        .btn-secondary {
            background-color: transparent;
            color: var(--gw-ink);
            border: 1px solid var(--gw-line);
            padding: 0.65rem 1.2rem;
            border-radius: 6px;
            font-family: var(--gw-sans);
            font-size: 0.88rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.18s;
            text-decoration: none;
            display: inline-block;
        }

        .btn-secondary:hover {
            border-color: var(--gw-ink);
            background-color: var(--gw-paper-warm);
            color: var(--gw-ink);
        }

        .enrolled-badge {
            color: var(--gw-accent);
            font-size: 0.78rem;
            font-weight: 600;
            margin-left: auto;
            display: flex;
            align-items: center;
            gap: 0.3rem;
        }

        .course-mini-progress {
            margin-bottom: 1.25rem;
        }

        .mini-track {
            height: 4px;
            background-color: var(--gw-line-soft);
            border-radius: 999px;
            overflow: hidden;
            margin-bottom: 0.4rem;
        }

        .mini-fill {
            height: 100%;
            background-color: var(--gw-accent);
            border-radius: 999px;
        }

        .mini-label {
            font-size: 0.78rem;
            color: var(--gw-ink-muted);
            font-variant-numeric: tabular-nums;
        }

        .detail-back {
            color: var(--gw-ink-muted);
            font-size: 0.85rem;
            margin-bottom: 1.5rem;
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
        }

        .detail-back:hover { color: var(--gw-accent); }

        .detail-hero {
            background-color: var(--gw-surface);
            border: 1px solid var(--gw-line);
            border-radius: 16px;
            padding: 2.5rem;
            margin-bottom: 2rem;
        }

        .detail-hero h1 {
            font-size: 2.5rem;
            margin-bottom: 0.6rem;
        }

        .detail-hero-desc {
            color: var(--gw-ink-soft);
            font-size: 1.05rem;
            line-height: 1.7;
            max-width: 720px;
            margin-bottom: 1.5rem;
        }

        .detail-hero-meta {
            display: flex;
            gap: 1.5rem;
            color: var(--gw-ink-muted);
            font-size: 0.9rem;
            padding-top: 1.25rem;
            border-top: 1px solid var(--gw-line-soft);
        }

        .detail-hero-meta strong {
            color: var(--gw-ink);
            font-family: var(--gw-serif);
            font-weight: 600;
        }

        .detail-body {
            display: grid;
            grid-template-columns: 1fr 320px;
            gap: 1.5rem;
        }

        .module-list-panel {
            background-color: var(--gw-surface);
            border: 1px solid var(--gw-line);
            border-radius: 16px;
            padding: 2rem;
        }

        .module-list-panel h2 {
            font-size: 1.4rem;
            margin-bottom: 1.5rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid var(--gw-line-soft);
        }

        .module-item {
            display: flex;
            align-items: center;
            padding: 1rem 0;
            border-bottom: 1px solid var(--gw-line-soft);
            transition: padding 0.18s;
        }

        .module-item:last-child { border-bottom: none; }
        .module-item:hover { padding-left: 0.4rem; }

        .module-status {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 0.85rem;
            font-weight: 700;
            font-family: var(--gw-serif);
            margin-right: 1rem;
            flex-shrink: 0;
        }

        .module-status.done { background-color: var(--gw-accent); color: white; }
        .module-status.active { background-color: var(--gw-gold); color: white; }
        .module-status.locked { background-color: var(--gw-line); color: var(--gw-ink-muted); }

        .module-text {
            flex: 1;
        }

        .module-title {
            color: var(--gw-ink);
            font-weight: 500;
            font-size: 0.98rem;
            margin-bottom: 0.15rem;
        }

        .module-meta {
            color: var(--gw-ink-muted);
            font-size: 0.82rem;
        }

        .module-action a {
            font-size: 0.85rem;
            color: var(--gw-accent);
            font-weight: 500;
        }

        .sidebar-panel {
            background-color: var(--gw-surface);
            border: 1px solid var(--gw-line);
            border-radius: 16px;
            padding: 1.75rem;
            height: fit-content;
            position: sticky;
            top: 90px;
        }

        .sidebar-panel h3 {
            font-size: 1rem;
            margin-bottom: 1.25rem;
            padding-bottom: 0.75rem;
            border-bottom: 1px solid var(--gw-line-soft);
        }

        .sidebar-stat {
            display: flex;
            justify-content: space-between;
            padding: 0.55rem 0;
            font-size: 0.9rem;
        }

        .sidebar-stat span:first-child { color: var(--gw-ink-muted); }
        .sidebar-stat span:last-child {
            color: var(--gw-ink);
            font-weight: 600;
            font-variant-numeric: tabular-nums;
        }

        .sidebar-progress {
            margin-top: 1.25rem;
            padding-top: 1.25rem;
            border-top: 1px solid var(--gw-line-soft);
        }

        .sidebar-progress-label {
            display: flex;
            justify-content: space-between;
            margin-bottom: 0.5rem;
            font-size: 0.85rem;
        }

        .sidebar-progress-label span:first-child { color: var(--gw-ink-muted); }
        .sidebar-progress-label span:last-child { color: var(--gw-ink); font-weight: 600; }

        .sidebar-track {
            height: 8px;
            background-color: var(--gw-line-soft);
            border-radius: 999px;
            overflow: hidden;
        }

        .sidebar-fill {
            height: 100%;
            background: linear-gradient(90deg, var(--gw-accent) 0%, #0d8048 100%);
            border-radius: 999px;
        }

        .btn-block-primary {
            width: 100%;
            margin-top: 1.5rem;
            padding: 0.85rem;
            background-color: var(--gw-ink);
            color: var(--gw-paper);
            border: 1px solid var(--gw-ink);
            border-radius: 6px;
            font-family: var(--gw-sans);
            font-size: 0.92rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.18s;
        }

        .btn-block-primary:hover {
            background-color: var(--gw-accent-dark);
            border-color: var(--gw-accent-dark);
        }

        @media (max-width: 920px) {
            .detail-body { grid-template-columns: 1fr; }
            .sidebar-panel { position: static; }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <asp:Panel ID="pnlCatalogue" runat="server">
        <div class="courses-header">
            <div>
                <h1>Course catalogue</h1>
                <p>Build the financial knowledge you need, one course at a time.</p>
            </div>
        </div>

        <div class="catalogue-grid">
            <asp:Repeater ID="rptCourses" runat="server" OnItemCommand="rptCourses_ItemCommand">
                <ItemTemplate>
                    <div class="course-card">
                        <span class='<%# "course-tag " + Eval("Difficulty").ToString().ToLower() %>'><%# Eval("Difficulty") %></span>
                        <h3><%# Eval("Title") %></h3>
                        <p class="course-desc"><%# Eval("Description") %></p>

                        <div class="course-stats">
                            <span><strong><%# Eval("ModuleCount") %></strong> modules</span>
                            <span><strong><%# Eval("EstimatedHours") %></strong> hrs</span>
                        </div>

                        <asp:Panel runat="server" Visible='<%# Convert.ToBoolean(Eval("IsEnrolled")) %>' CssClass="course-mini-progress">
                            <div class="mini-track">
                                <div class="mini-fill" style="width: <%# Eval("PercentComplete") %>%;"></div>
                            </div>
                            <div class="mini-label"><%# Eval("PercentComplete") %>% complete &middot; <%# Eval("CompletedModules") %> / <%# Eval("ModuleCount") %> modules</div>
                        </asp:Panel>

                        <div class="course-actions">
                            <asp:LinkButton runat="server" CssClass="btn-primary"
                                CommandName="ViewCourse"
                                CommandArgument='<%# Eval("CourseID") %>'>
                                <%# Convert.ToBoolean(Eval("IsEnrolled")) ? "Continue" : "View course" %>
                            </asp:LinkButton>
                            <asp:LinkButton runat="server" CssClass="btn-secondary"
                                CommandName="EnrolCourse"
                                CommandArgument='<%# Eval("CourseID") %>'
                                Visible='<%# !Convert.ToBoolean(Eval("IsEnrolled")) %>'>
                                Enrol
                            </asp:LinkButton>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </asp:Panel>

    <asp:Panel ID="pnlDetail" runat="server" Visible="false">
        <asp:LinkButton ID="lnkBack" runat="server" OnClick="lnkBack_Click" CssClass="detail-back" CausesValidation="false">
            &larr; Back to all courses
        </asp:LinkButton>

        <div class="detail-hero">
            <span runat="server" id="tagDifficulty" class="course-tag"><asp:Literal ID="litDifficulty" runat="server"></asp:Literal></span>
            <h1><asp:Literal ID="litCourseTitle" runat="server"></asp:Literal></h1>
            <p class="detail-hero-desc"><asp:Literal ID="litCourseDesc" runat="server"></asp:Literal></p>
            <div class="detail-hero-meta">
                <span><strong><asp:Literal ID="litMetaModules" runat="server"></asp:Literal></strong> modules</span>
                <span><strong><asp:Literal ID="litMetaHours" runat="server"></asp:Literal></strong> total hours</span>
                <span><strong><asp:Literal ID="litMetaLevel" runat="server"></asp:Literal></strong> level</span>
            </div>
        </div>

        <div class="detail-body">
            <div class="module-list-panel">
                <h2>Modules in this course</h2>
                <asp:Repeater ID="rptModules" runat="server">
                    <ItemTemplate>
                        <div class="module-item">
                            <span class='<%# "module-status " + Eval("StatusClass") %>'><%# Eval("StatusIcon") %></span>
                            <div class="module-text">
                                <div class="module-title"><%# Eval("OrderIndex") %>. <%# Eval("Title") %></div>
                                <div class="module-meta"><%# Eval("EstimatedMinutes") %> min read</div>
                            </div>
                            <div class="module-action">
                                <a href='<%# "~/Pages/Member/ModuleViewer.aspx?moduleId=" + Eval("ModuleID") %>' runat="server">
                                    <%# Eval("ActionLabel") %>
                                </a>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>

            <div class="sidebar-panel">
                <h3>Your progress</h3>
                <div class="sidebar-stat">
                    <span>Modules done</span>
                    <span><asp:Literal ID="litDoneCount" runat="server"></asp:Literal> / <asp:Literal ID="litTotalCount" runat="server"></asp:Literal></span>
                </div>
                <div class="sidebar-stat">
                    <span>Time invested</span>
                    <span><asp:Literal ID="litTimeInvested" runat="server"></asp:Literal> min</span>
                </div>
                <div class="sidebar-stat">
                    <span>Quizzes passed</span>
                    <span><asp:Literal ID="litQuizzesPassed" runat="server"></asp:Literal></span>
                </div>

                <div class="sidebar-progress">
                    <div class="sidebar-progress-label">
                        <span>Course progress</span>
                        <span><asp:Literal ID="litPctSidebar" runat="server"></asp:Literal>%</span>
                    </div>
                    <div class="sidebar-track">
                        <div class="sidebar-fill" id="sidebarFill" runat="server"></div>
                    </div>
                </div>

                <asp:Button ID="btnStartOrContinue" runat="server" Text="Continue learning"
                    CssClass="btn-block-primary" OnClick="btnStartOrContinue_Click" />
            </div>
        </div>
    </asp:Panel>

</asp:Content>
