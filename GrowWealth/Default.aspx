<%@ Page Title="Home" Language="C#" MasterPageFile="~/Master/before_landing.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="GrowWealth.Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <!-- Additional head content for Default.aspx if needed -->
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container">
        <asp:PlaceHolder ID="phAnonymous" runat="server">
            <!-- Hero Section -->
            <section class="hero">
                <h1>Grow your wealth,<br />one module at a time</h1>
                <p>Interactive courses on budgeting, investing, and risk management<br />for students and young professionals.</p>
                <div class="hero-actions">
                    <a href="Register.aspx" class="btn btn-primary">Get started free</a>
                    <a href="#" class="btn btn-outline">Browse courses</a>
                </div>
            </section>
        </asp:PlaceHolder>

        <asp:PlaceHolder ID="phDashboard" runat="server" Visible="false">
             <section style="margin-bottom: 2rem;">
                <h1>Welcome back, <asp:Literal ID="litUserName" runat="server" />!</h1>
                <p>Ready to continue your financial journey?</p>
            </section>
        </asp:PlaceHolder>

        <!-- Featured Courses Section -->
        <section>
            <h2>Featured courses</h2>
            <div class="grid-3">
                
                <!-- Course 1 -->
                <div class="card">
                    <div class="card-img">
                        [ Course thumbnail ]
                    </div>
                    <div class="card-body">
                        <span class="badge">Beginner</span>
                        <h3 class="card-title">Budgeting basics</h3>
                        <div class="card-meta">4 modules &middot; 1h 20m</div>
                    </div>
                </div>

                <!-- Course 2 -->
                <div class="card">
                    <div class="card-img">
                        [ Course thumbnail ]
                    </div>
                    <div class="card-body">
                        <span class="badge">Intermediate</span>
                        <h3 class="card-title">Investment 101</h3>
                        <div class="card-meta">5 modules &middot; 2h 00m</div>
                    </div>
                </div>

                <!-- Course 3 -->
                <div class="card">
                    <div class="card-img">
                        [ Course thumbnail ]
                    </div>
                    <div class="card-body">
                        <span class="badge">Advanced</span>
                        <h3 class="card-title">Portfolio strategy</h3>
                        <div class="card-meta">6 modules &middot; 2h 30m</div>
                    </div>
                </div>

            </div>
        </section>

        <!-- Why Grow Wealth Section -->
        <section style="margin-bottom: 4rem;">
            <h2 style="text-align: center; margin-bottom: 2rem;">Why Grow Wealth?</h2>
            <div class="grid-3" style="text-align: center;">
                <div>
                    <h3 style="color: var(--primary); font-size: 1.125rem; font-weight: 500;">Interactive quizzes</h3>
                    <div class="card-img" style="margin: 1rem auto; width: 120px; height: 80px; border-radius: 8px;">Logo</div>
                    <p class="card-meta">after every module</p>
                </div>
                <div>
                    <h3 style="color: var(--primary); font-size: 1.125rem; font-weight: 500;">Virtual investment simulator</h3>
                    <div class="card-img" style="margin: 1rem auto; width: 120px; height: 80px; border-radius: 8px;">Logo</div>
                    <p class="card-meta">practise risk-free</p>
                </div>
                <div>
                    <h3 style="color: var(--primary); font-size: 1.125rem; font-weight: 500;">Track your progress</h3>
                    <div class="card-img" style="margin: 1rem auto; width: 120px; height: 80px; border-radius: 8px;">Logo</div>
                    <p class="card-meta">anytime, any device</p>
                </div>
            </div>
        </section>
    </div>
</asp:Content>
