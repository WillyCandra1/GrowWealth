<%@ Page Title="Admin Dashboard" Language="C#" MasterPageFile="~/Master/Admin.Master" AutoEventWireup="true" CodeBehind="AdminDashboard.aspx.cs" Inherits="GrowWealth.Pages.Admin.AdminDashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .admin-header {
            margin-bottom: 2rem;
        }

        .admin-header h1 {
            font-size: 2.4rem;
            margin-bottom: 0.3rem;
        }

        .admin-header p {
            color: var(--gw-ink-muted);
            margin: 0;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 1.25rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background-color: var(--gw-surface);
            border: 1px solid var(--gw-line);
            border-radius: 14px;
            padding: 1.5rem 1.75rem;
        }

        .stat-card.accent {
            background: linear-gradient(135deg, var(--gw-accent) 0%, var(--gw-accent-dark) 100%);
            border-color: transparent;
            color: white;
        }

        .stat-card.accent .stat-label,
        .stat-card.accent .stat-value { color: white; }

        .stat-card.accent .stat-label { opacity: 0.85; }

        .stat-label {
            font-size: 0.72rem;
            font-weight: 600;
            color: var(--gw-ink-muted);
            text-transform: uppercase;
            letter-spacing: 0.1em;
            margin-bottom: 0.85rem;
        }

        .stat-value {
            font-family: var(--gw-serif);
            font-size: 2.4rem;
            font-weight: 600;
            color: var(--gw-ink);
            line-height: 1;
            font-variant-numeric: tabular-nums;
        }

        .stat-sub {
            font-size: 0.8rem;
            color: var(--gw-ink-muted);
            margin-top: 0.5rem;
        }

        .stat-card.accent .stat-sub { color: rgba(255,255,255,0.8); }

        .admin-row {
            display: grid;
            grid-template-columns: 1.4fr 1fr;
            gap: 1.5rem;
            margin-bottom: 1.5rem;
        }

        .admin-panel {
            background-color: var(--gw-surface);
            border: 1px solid var(--gw-line);
            border-radius: 14px;
            padding: 1.75rem;
        }

        .panel-head {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid var(--gw-line-soft);
        }

        .panel-head h2 {
            font-size: 1.2rem;
            margin: 0;
        }

        .panel-head a {
            font-size: 0.85rem;
            color: var(--gw-accent);
            font-weight: 500;
        }

        .data-table {
            width: 100%;
            border-collapse: collapse;
        }

        .data-table th {
            text-align: left;
            font-size: 0.7rem;
            text-transform: uppercase;
            letter-spacing: 0.1em;
            color: var(--gw-ink-muted);
            font-weight: 600;
            padding: 0.6rem 0.75rem;
            border-bottom: 1px solid var(--gw-line);
        }

        .data-table td {
            padding: 0.85rem 0.75rem;
            border-bottom: 1px solid var(--gw-line-soft);
            font-size: 0.9rem;
            color: var(--gw-ink);
        }

        .data-table tr:last-child td { border-bottom: none; }
        .data-table tr:hover td { background-color: var(--gw-paper); }

        .data-table .role-pill {
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
            font-size: 0.72rem;
            font-weight: 600;
            color: var(--gw-ink-muted);
            text-transform: uppercase;
            letter-spacing: 0.06em;
        }

        .data-table .role-pill::before {
            content: '';
            display: block;
            width: 6px;
            height: 6px;
            border-radius: 50%;
        }

        .role-pill.admin::before { background-color: var(--gw-gold); }
        .role-pill.member::before { background-color: var(--gw-accent); }

        .status-dot {
            display: inline-block;
            width: 7px;
            height: 7px;
            border-radius: 50%;
            background-color: var(--gw-accent);
            margin-right: 0.5rem;
        }

        .status-dot.suspended { background-color: var(--gw-rose); }

        .activity-feed-row {
            display: flex;
            align-items: center;
            padding: 0.85rem 0;
            border-bottom: 1px solid var(--gw-line-soft);
            font-size: 0.88rem;
        }

        .activity-feed-row:last-child { border-bottom: none; }

        .activity-feed-icon {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background-color: var(--gw-accent-soft);
            color: var(--gw-accent);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 0.82rem;
            font-weight: 700;
            font-family: var(--gw-serif);
            margin-right: 0.85rem;
            flex-shrink: 0;
        }

        .activity-feed-icon.gold { background-color: var(--gw-gold-soft); color: var(--gw-gold); }
        .activity-feed-icon.blue { background-color: #e3eaf4; color: #2d4a5c; }

        .activity-feed-text { flex: 1; color: var(--gw-ink); }

        .activity-feed-time {
            color: var(--gw-ink-muted);
            font-size: 0.78rem;
            margin-left: 0.75rem;
            white-space: nowrap;
            font-variant-numeric: tabular-nums;
        }

        @media (max-width: 1100px) {
            .stats-grid { grid-template-columns: repeat(2, 1fr); }
            .admin-row { grid-template-columns: 1fr; }
        }

        @media (max-width: 600px) {
            .stats-grid { grid-template-columns: 1fr; }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div class="admin-header">
        <h1>Admin overview</h1>
        <p>Monitor activity across the platform and keep content fresh.</p>
    </div>

    <div class="stats-grid">
        <div class="stat-card accent">
            <div class="stat-label">Registered users</div>
            <div class="stat-value"><asp:Literal ID="litTotalUsers" runat="server"></asp:Literal></div>
            <div class="stat-sub"><asp:Literal ID="litActiveUsers" runat="server"></asp:Literal> active</div>
        </div>
        <div class="stat-card">
            <div class="stat-label">Courses live</div>
            <div class="stat-value"><asp:Literal ID="litTotalCourses" runat="server"></asp:Literal></div>
            <div class="stat-sub">Across all skill levels</div>
        </div>
        <div class="stat-card">
            <div class="stat-label">Modules published</div>
            <div class="stat-value"><asp:Literal ID="litTotalModules" runat="server"></asp:Literal></div>
            <div class="stat-sub"><asp:Literal ID="litTotalQuizzes" runat="server"></asp:Literal> linked quizzes</div>
        </div>
        <div class="stat-card">
            <div class="stat-label">Quiz attempts</div>
            <div class="stat-value"><asp:Literal ID="litTotalAttempts" runat="server"></asp:Literal></div>
            <div class="stat-sub">Avg score <asp:Literal ID="litAvgScore" runat="server"></asp:Literal>%</div>
        </div>
    </div>

    <div class="admin-row">

        <div class="admin-panel">
            <div class="panel-head">
                <h2>Recent users</h2>
                <a href="ManageUser.aspx" runat="server">Manage all &rarr;</a>
            </div>
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Role</th>
                        <th>Status</th>
                        <th>Joined</th>
                    </tr>
                </thead>
                <tbody>
                    <asp:Repeater ID="rptRecentUsers" runat="server">
                        <ItemTemplate>
                            <tr>
                                <td><strong><%# Eval("FullName") %></strong></td>
                                <td><%# Eval("Email") %></td>
                                <td><span class='<%# "role-pill " + Eval("RoleClass") %>'><%# Eval("RoleName") %></span></td>
                                <td><span class='<%# "status-dot " + Eval("StatusClass") %>'></span><%# Eval("AccountStatus") %></td>
                                <td><%# Eval("CreatedAtFmt") %></td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </tbody>
            </table>
        </div>

        <div class="admin-panel">
            <div class="panel-head">
                <h2>Live activity</h2>
                <span style="font-size: 0.8rem; color: var(--gw-ink-muted);">Last 10</span>
            </div>

            <asp:Repeater ID="rptFeed" runat="server">
                <ItemTemplate>
                    <div class="activity-feed-row">
                        <span class='<%# "activity-feed-icon " + Eval("IconClass") %>'><%# Eval("IconText") %></span>
                        <span class="activity-feed-text"><%# Eval("Description") %></span>
                        <span class="activity-feed-time"><%# Eval("RelativeTime") %></span>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </div>

    <div class="admin-panel">
        <div class="panel-head">
            <h2>Course catalogue</h2>
            <a href="ManageCourse.aspx" runat="server">Edit courses &rarr;</a>
        </div>
        <table class="data-table">
            <thead>
                <tr>
                    <th>Course</th>
                    <th>Level</th>
                    <th>Modules</th>
                    <th>Enrolments</th>
                    <th>Avg quiz score</th>
                </tr>
            </thead>
            <tbody>
                <asp:Repeater ID="rptCoursesTable" runat="server">
                    <ItemTemplate>
                        <tr>
                            <td><strong><%# Eval("Title") %></strong></td>
                            <td><%# Eval("Difficulty") %></td>
                            <td><%# Eval("ModuleCount") %></td>
                            <td><%# Eval("EnrolCount") %></td>
                            <td><%# Eval("AvgScoreFmt") %>%</td>
                        </tr>
                    </ItemTemplate>
                </asp:Repeater>
            </tbody>
        </table>
    </div>

</asp:Content>
