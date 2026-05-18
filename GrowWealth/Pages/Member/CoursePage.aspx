<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CoursePage.aspx.cs" Inherits="GrowWealth.Pages.Member.CoursePage" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Course Page - Grow Wealth</title>
    <link href="../../Assets/css/style.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">

        <nav class="navbar">
            <div class="container">
                <a class="navbar-brand" href="../../Default.aspx">Grow Wealth</a>

                <div class="navbar-links">
                    <a href="Dashboard.aspx">Dashboard</a>
                    <a href="CoursePage.aspx">Courses</a>
                    <a href="VirtualLab.aspx">Virtual Lab</a>
                    <a href="Profile.aspx">Profile</a>
                </div>

                <div class="navbar-actions">
                    <span class="muted">Ahmad Zaki</span>
                    <a href="../Public/Login.aspx" class="btn btn-outline">Logout</a>
                </div>
            </div>
        </nav>

        <div class="app-layout">

            <aside class="side-menu">
                <a href="Dashboard.aspx">Dashboard</a>
                <a href="CoursePage.aspx" class="active">Courses</a>
                <a href="VirtualLab.aspx">Virtual Lab</a>
                <a href="Profile.aspx">Profile</a>
            </aside>

            <main class="page-area">

                <asp:Label ID="lblMessage" runat="server" CssClass="text-danger"></asp:Label>

                <section class="card">
                    <div class="card-body">
                        <div class="course-top">
                            <div class="course-thumb">
                                <asp:Label ID="lblThumb" runat="server" Text="Thumb"></asp:Label>
                            </div>

                            <div>
                                <asp:Label ID="lblDifficulty" runat="server" CssClass="badge"></asp:Label>
                                <h1>
                                    <asp:Label ID="lblCourseTitle" runat="server"></asp:Label>
                                </h1>

                                <p class="muted">
                                    <asp:Label ID="lblCourseDescription" runat="server"></asp:Label>
                                </p>

                                <p class="muted">
                                    <asp:Label ID="lblCourseMeta" runat="server"></asp:Label>
                                </p>
                            </div>
                        </div>
                    </div>
                </section>

                <br />

                <div class="two-column">

                    <section class="card">
                        <div class="card-body">
                            <h2>Modules</h2>

                            <div class="module-list">

                                <asp:Repeater ID="rptModules" runat="server">
                                    <ItemTemplate>
                                        <div class="module-item">
                                            <div class="module-no">
                                                <%# Eval("OrderIndex") %>
                                            </div>

                                            <div>
                                                <strong><%# Eval("Title") %></strong>
                                                <p class="muted">
                                                    <%# Eval("ShortContent") %>
                                                </p>
                                            </div>

                                            <a class="btn btn-primary" href='ModuleViewer.aspx?moduleId=<%# Eval("ModuleID") %>'>
                                                Start
                                            </a>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>

                            </div>
                        </div>
                    </section>

                    <section class="card">
                        <div class="card-body">
                            <h2>Your stats</h2>

                            <table class="simple-table">
                                <tr>
                                    <td>Total modules</td>
                                    <td><strong><asp:Label ID="lblTotalModules" runat="server" Text="0"></asp:Label></strong></td>
                                </tr>
                                <tr>
                                    <td>Estimated time</td>
                                    <td><strong><asp:Label ID="lblTotalMinutes" runat="server" Text="0 min"></asp:Label></strong></td>
                                </tr>
                                <tr>
                                    <td>Course status</td>
                                    <td><strong><asp:Label ID="lblCourseStatus" runat="server"></asp:Label></strong></td>
                                </tr>
                            </table>

                            <br />

                            <p class="muted">
                                This course page is now connected to the local GrowWealth database.
                            </p>
                        </div>
                    </section>

                </div>

            </main>
        </div>

    </form>
</body>
</html>