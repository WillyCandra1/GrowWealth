<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ModuleViewer.aspx.cs" Inherits="GrowWealth.Pages.Member.ModuleViewer" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Module Viewer - Grow Wealth</title>
    <link href="../../Assets/css/style.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">

        <nav class="navbar">
            <div class="container">
                <a class="navbar-brand" href="../../Default.aspx">Grow Wealth</a>

                <div class="navbar-links">
                    <a href="CoursePage.aspx">Courses</a>
                    <a href="VirtualLab.aspx">Virtual Lab</a>
                </div>

                <div class="navbar-actions">
                    <span class="muted">Ahmad Zaki</span>
                    <a href="../Public/Login.aspx" class="btn btn-outline">Logout</a>
                </div>
            </div>
        </nav>

        <div class="app-layout">

            <aside class="side-menu">
                <a href="CoursePage.aspx" class="active">Courses</a>
                <a href="VirtualLab.aspx">Virtual Lab</a>
            </aside>

            <main class="page-area">

                <asp:Label ID="lblMessage" runat="server" CssClass="text-danger"></asp:Label>

                <section class="card">
                    <div class="card-body">
                        <p class="muted">
                            <asp:Label ID="lblCourseTitle" runat="server"></asp:Label>
                        </p>

                        <h1>
                            <asp:Label ID="lblModuleTitle" runat="server"></asp:Label>
                        </h1>

                        <p class="muted">
                            Estimated reading time:
                            <asp:Label ID="lblEstimatedMinutes" runat="server"></asp:Label>
                            minutes
                        </p>

                        <div class="module-content-box">
                            <asp:Literal ID="litContent" runat="server"></asp:Literal>
                        </div>

                        <br />

                        <a href="CoursePage.aspx" class="btn btn-outline">Back to course</a>
                        <a href="#" class="btn btn-primary">Take quiz</a>
                    </div>
                </section>

            </main>
        </div>

    </form>
</body>
</html>