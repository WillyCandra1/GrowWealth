<%@ Page Title="Virtual Lab" Language="C#" MasterPageFile="~/Master/after_landing.Master" AutoEventWireup="true" CodeBehind="VirtualLab.aspx.cs" Inherits="GrowWealth.Pages.Member.VirtualLab" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .lab-header {
            margin-bottom: 2rem;
        }

        .lab-header h1 {
            font-size: 2.4rem;
            margin-bottom: 0.3rem;
        }

        .lab-header p {
            color: var(--gw-ink-muted);
            margin: 0;
            font-size: 1rem;
            max-width: 720px;
        }

        .lab-layout {
            display: grid;
            grid-template-columns: 1fr 1.25fr;
            gap: 1.5rem;
        }

        .lab-panel {
            background-color: var(--gw-surface);
            border: 1px solid var(--gw-line);
            border-radius: 16px;
            padding: 2rem 2.25rem;
        }

        .lab-panel h2 {
            font-size: 1.3rem;
            margin-bottom: 0.3rem;
        }

        .lab-panel .lab-subtitle {
            color: var(--gw-ink-muted);
            font-size: 0.9rem;
            margin-bottom: 1.75rem;
        }

        .form-group { margin-bottom: 1.25rem; }

        .form-label {
            display: block;
            margin-bottom: 0.45rem;
            font-size: 0.75rem;
            font-weight: 600;
            color: var(--gw-ink-soft);
            text-transform: uppercase;
            letter-spacing: 0.08em;
        }

        .input-wrap { position: relative; }

        .input-prefix {
            position: absolute;
            left: 0.95rem;
            top: 50%;
            transform: translateY(-50%);
            color: var(--gw-ink-muted);
            font-weight: 500;
            pointer-events: none;
            font-family: var(--gw-serif);
        }

        .input-suffix {
            position: absolute;
            right: 0.95rem;
            top: 50%;
            transform: translateY(-50%);
            color: var(--gw-ink-muted);
            font-weight: 500;
            pointer-events: none;
        }

        .form-input {
            width: 100%;
            padding: 0.75rem 0.95rem;
            border: 1px solid var(--gw-line);
            border-radius: 8px;
            font-size: 0.95rem;
            font-family: var(--gw-sans);
            color: var(--gw-ink);
            background-color: var(--gw-surface);
            outline: none;
            transition: all 0.18s;
            font-variant-numeric: tabular-nums;
        }

        .form-input.has-prefix { padding-left: 2.4rem; }
        .form-input.has-suffix { padding-right: 2.5rem; }

        .form-input:focus {
            border-color: var(--gw-accent);
            box-shadow: 0 0 0 3px var(--gw-accent-soft);
        }

        .text-danger {
            color: var(--gw-rose);
            font-size: 0.82rem;
            margin-top: 0.3rem;
            display: block;
            font-weight: 500;
        }

        .btn-calc {
            width: 100%;
            margin-top: 1rem;
            background-color: var(--gw-ink);
            color: var(--gw-paper);
            border: 1px solid var(--gw-ink);
            padding: 0.9rem;
            border-radius: 8px;
            font-family: var(--gw-sans);
            font-size: 0.95rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.18s;
        }

        .btn-calc:hover {
            background-color: var(--gw-accent-dark);
            border-color: var(--gw-accent-dark);
        }

        .result-headline {
            background: linear-gradient(135deg, var(--gw-accent) 0%, var(--gw-accent-dark) 100%);
            border-radius: 12px;
            padding: 2rem;
            color: white;
            margin-bottom: 1.5rem;
            text-align: center;
        }

        .result-headline-label {
            font-size: 0.78rem;
            text-transform: uppercase;
            letter-spacing: 0.12em;
            font-weight: 600;
            opacity: 0.85;
            margin-bottom: 0.6rem;
        }

        .result-headline-value {
            font-family: var(--gw-serif);
            font-size: 3.5rem;
            font-weight: 600;
            line-height: 1.05;
            letter-spacing: -0.02em;
            font-variant-numeric: tabular-nums;
        }

        .result-headline-value .currency-prefix {
            font-size: 1.5rem;
            margin-right: 0.25rem;
            opacity: 0.85;
        }

        .result-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 0.85rem;
            margin-bottom: 1.5rem;
        }

        .result-small {
            background-color: var(--gw-paper);
            border: 1px solid var(--gw-line-soft);
            border-radius: 10px;
            padding: 1rem 1.1rem;
        }

        .result-small-label {
            font-size: 0.72rem;
            text-transform: uppercase;
            letter-spacing: 0.1em;
            color: var(--gw-ink-muted);
            font-weight: 600;
            margin-bottom: 0.5rem;
        }

        .result-small-value {
            font-family: var(--gw-serif);
            font-size: 1.45rem;
            font-weight: 600;
            color: var(--gw-ink);
            line-height: 1;
            font-variant-numeric: tabular-nums;
        }

        .result-small-value.gold { color: var(--gw-gold); }
        .result-small-value.accent { color: var(--gw-accent); }

        .yearly-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 1.5rem;
        }

        .yearly-table th, .yearly-table td {
            text-align: right;
            padding: 0.7rem 0.85rem;
            border-bottom: 1px solid var(--gw-line-soft);
            font-size: 0.88rem;
            font-variant-numeric: tabular-nums;
        }

        .yearly-table th {
            background-color: var(--gw-paper);
            font-size: 0.72rem;
            text-transform: uppercase;
            letter-spacing: 0.1em;
            color: var(--gw-ink-muted);
            font-weight: 600;
            font-family: var(--gw-sans);
        }

        .yearly-table th:first-child, .yearly-table td:first-child {
            text-align: left;
        }

        .yearly-table tbody tr:hover { background-color: var(--gw-paper); }

        .empty-result {
            color: var(--gw-ink-muted);
            text-align: center;
            padding: 3.5rem 1rem;
            font-style: italic;
        }

        .empty-result-icon {
            font-size: 2.5rem;
            font-family: var(--gw-serif);
            color: var(--gw-line);
            margin-bottom: 0.85rem;
        }

        @media (max-width: 980px) {
            .lab-layout { grid-template-columns: 1fr; }
            .result-headline-value { font-size: 2.6rem; }
            .result-grid { grid-template-columns: 1fr; }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div class="lab-header">
        <h1>Virtual Investment Lab</h1>
        <p>Model how your money could grow over time. Adjust the inputs to explore the effect of contributions, rate, and time horizon on compound growth.</p>
    </div>

    <div class="lab-layout">

        <div class="lab-panel">
            <h2>Investment inputs</h2>
            <p class="lab-subtitle">All values are illustrative. Past performance does not guarantee future returns.</p>

            <div class="form-group">
                <label class="form-label">Initial investment</label>
                <div class="input-wrap">
                    <span class="input-prefix">RM</span>
                    <asp:TextBox ID="txtInitial" runat="server" CssClass="form-input has-prefix" Text="5000"></asp:TextBox>
                </div>
                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtInitial"
                    ErrorMessage="Initial amount is required" CssClass="text-danger" Display="Dynamic"
                    ValidationGroup="Calc"></asp:RequiredFieldValidator>
                <asp:RangeValidator runat="server" ControlToValidate="txtInitial" Type="Double"
                    MinimumValue="0" MaximumValue="100000000"
                    ErrorMessage="Enter a number between 0 and 100,000,000"
                    CssClass="text-danger" Display="Dynamic" ValidationGroup="Calc"></asp:RangeValidator>
            </div>

            <div class="form-group">
                <label class="form-label">Monthly contribution</label>
                <div class="input-wrap">
                    <span class="input-prefix">RM</span>
                    <asp:TextBox ID="txtMonthly" runat="server" CssClass="form-input has-prefix" Text="300"></asp:TextBox>
                </div>
                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtMonthly"
                    ErrorMessage="Monthly contribution is required" CssClass="text-danger" Display="Dynamic"
                    ValidationGroup="Calc"></asp:RequiredFieldValidator>
                <asp:RangeValidator runat="server" ControlToValidate="txtMonthly" Type="Double"
                    MinimumValue="0" MaximumValue="1000000"
                    ErrorMessage="Enter a number between 0 and 1,000,000"
                    CssClass="text-danger" Display="Dynamic" ValidationGroup="Calc"></asp:RangeValidator>
            </div>

            <div class="form-group">
                <label class="form-label">Annual interest rate</label>
                <div class="input-wrap">
                    <asp:TextBox ID="txtRate" runat="server" CssClass="form-input has-suffix" Text="6.5"></asp:TextBox>
                    <span class="input-suffix">%</span>
                </div>
                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtRate"
                    ErrorMessage="Annual rate is required" CssClass="text-danger" Display="Dynamic"
                    ValidationGroup="Calc"></asp:RequiredFieldValidator>
                <asp:RangeValidator runat="server" ControlToValidate="txtRate" Type="Double"
                    MinimumValue="0" MaximumValue="100"
                    ErrorMessage="Enter a rate between 0 and 100"
                    CssClass="text-danger" Display="Dynamic" ValidationGroup="Calc"></asp:RangeValidator>
            </div>

            <div class="form-group">
                <label class="form-label">Investment duration</label>
                <div class="input-wrap">
                    <asp:TextBox ID="txtYears" runat="server" CssClass="form-input has-suffix" Text="10"></asp:TextBox>
                    <span class="input-suffix">years</span>
                </div>
                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtYears"
                    ErrorMessage="Duration is required" CssClass="text-danger" Display="Dynamic"
                    ValidationGroup="Calc"></asp:RequiredFieldValidator>
                <asp:RangeValidator runat="server" ControlToValidate="txtYears" Type="Integer"
                    MinimumValue="1" MaximumValue="60"
                    ErrorMessage="Enter a whole number of years between 1 and 60"
                    CssClass="text-danger" Display="Dynamic" ValidationGroup="Calc"></asp:RangeValidator>
            </div>

            <div class="form-group">
                <label class="form-label">Compounding frequency</label>
                <asp:DropDownList ID="ddlCompounding" runat="server" CssClass="form-input">
                    <asp:ListItem Value="12" Text="Monthly" Selected="True"></asp:ListItem>
                    <asp:ListItem Value="4" Text="Quarterly"></asp:ListItem>
                    <asp:ListItem Value="1" Text="Yearly"></asp:ListItem>
                </asp:DropDownList>
            </div>

            <asp:Button ID="btnCalc" runat="server" Text="Calculate projection"
                CssClass="btn-calc" OnClick="btnCalc_Click" ValidationGroup="Calc" />
        </div>

        <div class="lab-panel">
            <h2>Projection</h2>
            <p class="lab-subtitle">Your projected portfolio value at the end of the term.</p>

            <asp:Panel ID="pnlEmpty" runat="server" Visible="true">
                <div class="empty-result">
                    <div class="empty-result-icon">~</div>
                    Enter your inputs on the left and press <strong>Calculate projection</strong> to see how compound growth could shape your wealth.
                </div>
            </asp:Panel>

            <asp:Panel ID="pnlResults" runat="server" Visible="false">
                <div class="result-headline">
                    <div class="result-headline-label">Projected portfolio value</div>
                    <div class="result-headline-value">
                        <span class="currency-prefix">RM</span><asp:Literal ID="litFinalValue" runat="server"></asp:Literal>
                    </div>
                </div>

                <div class="result-grid">
                    <div class="result-small">
                        <div class="result-small-label">Total invested</div>
                        <div class="result-small-value">RM <asp:Literal ID="litTotalInvested" runat="server"></asp:Literal></div>
                    </div>
                    <div class="result-small">
                        <div class="result-small-label">Interest earned</div>
                        <div class="result-small-value gold">RM <asp:Literal ID="litInterest" runat="server"></asp:Literal></div>
                    </div>
                    <div class="result-small">
                        <div class="result-small-label">Return on investment</div>
                        <div class="result-small-value accent"><asp:Literal ID="litROI" runat="server"></asp:Literal>%</div>
                    </div>
                </div>

                <table class="yearly-table">
                    <thead>
                        <tr>
                            <th>Year</th>
                            <th>Contributed</th>
                            <th>Interest</th>
                            <th>Balance</th>
                        </tr>
                    </thead>
                    <tbody>
                        <asp:Repeater ID="rptYearly" runat="server">
                            <ItemTemplate>
                                <tr>
                                    <td><%# Eval("Year") %></td>
                                    <td>RM <%# Eval("ContributedFmt") %></td>
                                    <td>RM <%# Eval("InterestFmt") %></td>
                                    <td><strong>RM <%# Eval("BalanceFmt") %></strong></td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
            </asp:Panel>
        </div>

    </div>

</asp:Content>
