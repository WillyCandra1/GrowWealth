<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="VirtualLab.aspx.cs" Inherits="GrowWealth.Pages.Member.VirtualLab" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Virtual Lab - Grow Wealth</title>
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
                <a href="CoursePage.aspx">Courses</a>
                <a href="VirtualLab.aspx" class="active">Virtual Lab</a>
            </aside>

            <main class="page-area">

                <div class="page-header">
                    <h1>Investment calculator</h1>
                    <p>Simulate how your investment can grow over time.</p>
                </div>

                <asp:Label ID="lblMessage" runat="server" CssClass="text-danger"></asp:Label>

                <div class="two-column">

                    <section class="card">
                        <div class="card-body">
                            <h2>Simulation inputs</h2>

                            <div class="form-group">
                                <label>Initial amount (RM)</label>
                                <asp:TextBox ID="txtInitialAmount" runat="server" CssClass="form-control" Text="5000"></asp:TextBox>
                            </div>

                            <div class="form-group">
                                <label>Monthly contribution (RM)</label>
                                <asp:TextBox ID="txtMonthlyContribution" runat="server" CssClass="form-control" Text="200"></asp:TextBox>
                            </div>

                            <div class="form-group">
                                <label>Annual return rate (%)</label>
                                <asp:TextBox ID="txtAnnualRate" runat="server" CssClass="form-control" Text="7"></asp:TextBox>
                            </div>

                            <div class="form-group">
                                <label>Duration (years)</label>
                                <asp:TextBox ID="txtYears" runat="server" CssClass="form-control" Text="10"></asp:TextBox>
                            </div>

                            <asp:Button ID="btnCalculate" runat="server" Text="Calculate" CssClass="btn btn-primary" OnClick="btnCalculate_Click" />
                        </div>
                    </section>

                    <section class="card">
                        <div class="card-body">
                            <h2>Results</h2>

                            <table class="simple-table">
                                <tr>
                                    <td>Total projected value</td>
                                    <td><strong><asp:Label ID="lblProjectedValue" runat="server" Text="RM 0"></asp:Label></strong></td>
                                </tr>
                                <tr>
                                    <td>Total invested</td>
                                    <td><strong><asp:Label ID="lblTotalInvested" runat="server" Text="RM 0"></asp:Label></strong></td>
                                </tr>
                                <tr>
                                    <td>Interest earned</td>
                                    <td><strong><asp:Label ID="lblInterestEarned" runat="server" Text="RM 0"></asp:Label></strong></td>
                                </tr>
                                <tr>
                                    <td>Return on investment</td>
                                    <td><strong><asp:Label ID="lblRoi" runat="server" Text="0%"></asp:Label></strong></td>
                                </tr>
                            </table>
                        </div>
                    </section>

                </div>

                <br />

                <section class="card">
                    <div class="card-body">
                        <h2>Chart visual</h2>
                        <div class="lab-chart">
                            Projected growth chart placeholder
                        </div>
                    </div>
                </section>

                <br />

                <section class="card">
                    <div class="card-body">
                        <h2>Reminder</h2>
                        <p class="muted">
                            This calculator is only a simulation. Real investment has risk.
                            Higher return usually comes with higher risk.
                        </p>
                    </div>
                </section>

                <br />

                <section class="card">
                    <div class="card-body">
                        <h2>My simulation history</h2>

                        <asp:GridView ID="gvHistory" runat="server" AutoGenerateColumns="False" CssClass="simple-table" GridLines="None">
                            <Columns>
                                <asp:BoundField DataField="InitialAmount" HeaderText="Initial (RM)" DataFormatString="{0:N2}" />
                                <asp:BoundField DataField="MonthlyContribution" HeaderText="Monthly (RM)" DataFormatString="{0:N2}" />
                                <asp:BoundField DataField="AnnualRate" HeaderText="Rate (%)" DataFormatString="{0:N2}" />
                                <asp:BoundField DataField="DurationYears" HeaderText="Years" />
                                <asp:BoundField DataField="ProjectedValue" HeaderText="Projected (RM)" DataFormatString="{0:N2}" />
                                <asp:BoundField DataField="ROI" HeaderText="ROI (%)" DataFormatString="{0:N2}" />
                                <asp:BoundField DataField="CreatedAt" HeaderText="Saved At" DataFormatString="{0:dd MMM yyyy HH:mm}" />
                            </Columns>
                        </asp:GridView>
                    </div>
                </section>

            </main>
        </div>

    </form>
</body>
</html>