<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdminDashboard.aspx.cs" Inherits="GrowWealth.Pages.Admin.AdminDashboard" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Admin Dashboard - Grow Wealth</title>
    <link href="../../Assets/css/style.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">

        <nav class="navbar">
            <div class="container">
                <a class="navbar-brand" href="../../Default.aspx">Grow Wealth</a>

                <div class="navbar-actions">
                    <span class="muted">Admin</span>
                    <a href="../Public/Login.aspx" class="btn btn-outline">Logout</a>
                </div>
            </div>
        </nav>

        <div class="app-layout">

            <aside class="side-menu">
                <a href="AdminDashboard.aspx" class="active">Dashboard</a>
                <a href="ManageCourse.aspx">Manage courses</a>
                <a href="ManageUser.aspx">Manage users</a>
                <a href="ManageQuiz.aspx">Manage quiz</a>
            </aside>

            <main class="page-area">

                <div class="page-header">
                    <h1>Admin dashboard</h1>
                    <p>Quick overview of users, courses, modules and quiz activity.</p>
                </div>

                <asp:Label ID="lblMessage" runat="server" CssClass="text-danger"></asp:Label>

                <div class="admin-stats">
                    <div class="card">
                        <div class="card-body stat-box">
                            <h2><asp:Label ID="lblUsers" runat="server" Text="0"></asp:Label></h2>
                            <p>Registered users</p>
                        </div>
                    </div>

                    <div class="card">
                        <div class="card-body stat-box">
                            <h2><asp:Label ID="lblCourses" runat="server" Text="0"></asp:Label></h2>
                            <p>Active courses</p>
                        </div>
                    </div>

                    <div class="card">
                        <div class="card-body stat-box">
                            <h2><asp:Label ID="lblModules" runat="server" Text="0"></asp:Label></h2>
                            <p>Published modules</p>
                        </div>
                    </div>

                    <div class="card">
                        <div class="card-body stat-box">
                            <h2><asp:Label ID="lblQuizAttempts" runat="server" Text="0"></asp:Label></h2>
                            <p>Total quiz attempts</p>
                        </div>
                    </div>
                </div>

                <br />

                <div class="two-column">

                    <section class="card">
                        <div class="card-body">
                            <h2>Recent users</h2>

                            <asp:GridView ID="gvUsers" runat="server" AutoGenerateColumns="False" CssClass="simple-table" GridLines="None">
                                <Columns>
                                    <asp:BoundField DataField="FullName" HeaderText="Name" />
                                    <asp:BoundField DataField="Email" HeaderText="Email" />
                                    <asp:BoundField DataField="Role" HeaderText="Role" />
                                    <asp:BoundField DataField="CreatedAt" HeaderText="Joined" DataFormatString="{0:dd MMM yyyy}" />
                                </Columns>
                            </asp:GridView>
                        </div>
                    </section>

                    <section class="card">
                        <div class="card-body">
                            <h2>Course summary</h2>

                            <asp:GridView ID="gvCourses" runat="server" AutoGenerateColumns="False" CssClass="simple-table" GridLines="None">
                                <Columns>
                                    <asp:BoundField DataField="Title" HeaderText="Course title" />
                                    <asp:BoundField DataField="DifficultyLevel" HeaderText="Level" />
                                    <asp:BoundField DataField="Status" HeaderText="Status" />
                                </Columns>
                            </asp:GridView>
                        </div>
                    </section>

                </div>

                <br />

                <section class="card">
                    <div class="card-body">
                        <h2>Admin shortcuts</h2>

                        <a href="ManageCourse.aspx" class="btn btn-primary">Manage courses</a>
                        <a href="ManageUser.aspx" class="btn btn-outline">Manage users</a>
                    </div>
                </section>

            </main>
        </div>

    </form>
</body>
</html>