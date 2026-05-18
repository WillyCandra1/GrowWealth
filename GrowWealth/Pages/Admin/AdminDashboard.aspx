<%@ Page Title="Admin Dashboard" Language="C#" MasterPageFile="~/Master/Admin.Master" AutoEventWireup="true" CodeBehind="AdminDashboard.aspx.cs" Inherits="GrowWealth.Pages.Admin.AdminDashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        .gw-admin-dashboard {
            display: block !important;
            width: 100% !important;
            max-width: 1200px;
            margin: 0 auto;
            padding: 35px 35px 60px 35px;
            box-sizing: border-box;
        }

        .gw-dashboard-header {
            display: block !important;
            margin-bottom: 28px;
        }

        .gw-dashboard-header h1 {
            font-size: 38px;
            font-weight: 700;
            margin: 0 0 8px 0;
            color: #111827;
            line-height: 1.2;
        }

        .gw-dashboard-header p {
            font-size: 16px;
            color: #6b7280;
            margin: 0;
        }

        .gw-dashboard-message {
            display: block;
            color: #dc2626;
            margin-bottom: 18px;
            font-size: 14px;
        }

        .gw-stats-grid {
            display: grid !important;
            grid-template-columns: repeat(4, 1fr);
            gap: 18px;
            margin-bottom: 30px;
            width: 100%;
        }

        .gw-stat-card {
            display: block !important;
            background: #ffffff;
            border: 1px solid #e5e7eb;
            border-radius: 16px;
            padding: 24px;
            min-height: 120px;
            box-shadow: 0 8px 22px rgba(15, 23, 42, 0.06);
            box-sizing: border-box;
        }

        .gw-stat-card h2 {
            font-size: 36px;
            font-weight: 700;
            margin: 0 0 10px 0;
            color: #111827;
            line-height: 1;
        }

        .gw-stat-card p {
            font-size: 15px;
            color: #6b7280;
            margin: 0;
            line-height: 1.4;
        }

        .gw-content-grid {
            display: grid !important;
            grid-template-columns: 1.2fr 1fr;
            gap: 22px;
            width: 100%;
            margin-bottom: 24px;
        }

        .gw-panel {
            display: block !important;
            background: #ffffff;
            border: 1px solid #e5e7eb;
            border-radius: 16px;
            padding: 24px;
            box-shadow: 0 8px 22px rgba(15, 23, 42, 0.06);
            box-sizing: border-box;
            overflow-x: auto;
        }

        .gw-panel h2 {
            font-size: 22px;
            font-weight: 700;
            color: #111827;
            margin: 0 0 18px 0;
        }

        .gw-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 14px;
        }

        .gw-table th {
            background: #f9fafb;
            color: #374151;
            font-weight: 700;
            padding: 13px 12px;
            border-bottom: 1px solid #e5e7eb;
            text-align: left;
            white-space: nowrap;
        }

        .gw-table td {
            padding: 13px 12px;
            border-bottom: 1px solid #e5e7eb;
            color: #374151;
            vertical-align: middle;
        }

        .gw-table tr:hover td {
            background: #f9fafb;
        }

        .gw-shortcuts {
            display: flex !important;
            flex-wrap: wrap;
            gap: 12px;
        }

        .gw-btn {
            display: inline-block !important;
            padding: 12px 18px;
            background: #111827;
            color: #ffffff !important;
            text-decoration: none !important;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 600;
        }

        .gw-btn:hover {
            background: #374151;
        }

        @media (max-width: 1100px) {
            .gw-stats-grid {
                grid-template-columns: repeat(2, 1fr);
            }

            .gw-content-grid {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 650px) {
            .gw-admin-dashboard {
                padding: 25px 18px 50px 18px;
            }

            .gw-stats-grid {
                grid-template-columns: 1fr;
            }

            .gw-dashboard-header h1 {
                font-size: 30px;
            }
        }
    </style>

    <div class="gw-admin-dashboard">

        <div class="gw-dashboard-header">
            <h1>Admin Dashboard</h1>
            <p>Overview of users, roles, and investment simulation activity.</p>
        </div>

        <asp:Label ID="lblMessage" runat="server" CssClass="gw-dashboard-message"></asp:Label>

        <div class="gw-stats-grid">

            <div class="gw-stat-card">
                <h2>
                    <asp:Label ID="lblUsers" runat="server" Text="0"></asp:Label>
                </h2>
                <p>Registered Users</p>
            </div>

            <div class="gw-stat-card">
                <h2>
                    <asp:Label ID="lblRoles" runat="server" Text="0"></asp:Label>
                </h2>
                <p>User Roles</p>
            </div>

            <div class="gw-stat-card">
                <h2>
                    <asp:Label ID="lblSimulations" runat="server" Text="0"></asp:Label>
                </h2>
                <p>Investment Simulations</p>
            </div>

            <div class="gw-stat-card">
                <h2>
                    <asp:Label ID="lblAdmins" runat="server" Text="0"></asp:Label>
                </h2>
                <p>Admin Accounts</p>
            </div>

        </div>

        <div class="gw-content-grid">

            <div class="gw-panel">
                <h2>Recent Users</h2>

                <asp:GridView 
                    ID="gvUsers" 
                    runat="server" 
                    AutoGenerateColumns="true" 
                    CssClass="gw-table"
                    GridLines="None"
                    EmptyDataText="No users found.">
                </asp:GridView>
            </div>

            <div class="gw-panel">
                <h2>Recent Investment Simulations</h2>

                <asp:GridView 
                    ID="gvSimulations" 
                    runat="server" 
                    AutoGenerateColumns="true" 
                    CssClass="gw-table"
                    GridLines="None"
                    EmptyDataText="No investment simulations found.">
                </asp:GridView>
            </div>

        </div>

        <div class="gw-panel">
            <h2>Admin Shortcuts</h2>

            <div class="gw-shortcuts">
                <a href="ManageUser.aspx" class="gw-btn">Manage Users</a>
                <a href="ManageQuiz.aspx" class="gw-btn">Manage Quiz</a>
                <a href="ManageCourse.aspx" class="gw-btn">Manage Courses</a>
            </div>
        </div>

    </div>

</asp:Content>