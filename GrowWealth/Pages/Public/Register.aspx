<%@ Page Title="Get started &middot; Grow Wealth" Language="C#" MasterPageFile="~/Master/before_landing.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="GrowWealth.Pages.Public.Register" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .auth-shell {
            min-height: calc(100vh - 200px);
            display: grid;
            grid-template-columns: 1fr 1fr;
        }

        .auth-form-side {
            display: flex;
            flex-direction: column;
            justify-content: center;
            padding: 4rem 5rem;
            background-color: var(--gw-paper);
        }

        .auth-form-box {
            max-width: 460px;
            width: 100%;
            margin: 0 auto;
        }

        .auth-eyebrow {
            font-size: 0.78rem;
            text-transform: uppercase;
            letter-spacing: 0.18em;
            color: var(--gw-accent);
            font-weight: 600;
            margin-bottom: 1rem;
        }

        .auth-form-box h1 {
            font-size: 2.4rem;
            margin-bottom: 0.6rem;
            letter-spacing: -0.02em;
        }

        .auth-form-box .auth-lead {
            color: var(--gw-ink-soft);
            font-size: 1rem;
            margin-bottom: 2.25rem;
        }

        .form-group { margin-bottom: 1.1rem; }

        .form-label {
            display: block;
            margin-bottom: 0.45rem;
            font-size: 0.72rem;
            font-weight: 600;
            color: var(--gw-ink-soft);
            text-transform: uppercase;
            letter-spacing: 0.08em;
        }

        .form-input {
            width: 100%;
            padding: 0.85rem 1rem;
            border: 1px solid var(--gw-line);
            border-radius: 8px;
            font-size: 0.95rem;
            font-family: var(--gw-sans);
            color: var(--gw-ink);
            background-color: var(--gw-surface);
            outline: none;
            transition: all 0.18s;
            box-sizing: border-box;
        }

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

        .password-hint {
            color: var(--gw-ink-muted);
            font-size: 0.78rem;
            margin-top: 0.3rem;
        }

        .terms-row {
            display: flex;
            align-items: flex-start;
            gap: 0.6rem;
            margin: 1.5rem 0;
            font-size: 0.88rem;
            color: var(--gw-ink-soft);
        }

        .terms-row input[type="checkbox"] {
            width: 16px;
            height: 16px;
            margin-top: 3px;
            accent-color: var(--gw-accent);
            flex-shrink: 0;
        }

        .terms-row a { color: var(--gw-accent); }

        .btn-submit {
            width: 100%;
            background-color: var(--gw-ink);
            color: var(--gw-paper);
            padding: 0.95rem;
            border: 1px solid var(--gw-ink);
            border-radius: 8px;
            font-family: var(--gw-sans);
            font-size: 0.97rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.18s;
        }

        .btn-submit:hover {
            background-color: var(--gw-accent-dark);
            border-color: var(--gw-accent-dark);
        }

        .auth-error {
            background-color: var(--gw-rose-soft);
            color: var(--gw-rose);
            border: 1px solid #e8c4be;
            padding: 0.85rem 1.1rem;
            border-radius: 8px;
            font-size: 0.88rem;
            margin-bottom: 1.5rem;
        }

        .auth-alt {
            text-align: center;
            margin-top: 1.75rem;
            color: var(--gw-ink-muted);
            font-size: 0.92rem;
        }

        .auth-alt a { color: var(--gw-accent); font-weight: 500; }

        .auth-art-side {
            background: linear-gradient(135deg, var(--gw-paper-warm) 0%, #ece5d5 100%);
            padding: 5rem 4rem;
            display: flex;
            flex-direction: column;
            justify-content: center;
            position: relative;
            overflow: hidden;
        }

        .auth-art-side::before {
            content: '';
            position: absolute;
            top: 4rem;
            left: 4rem;
            right: 4rem;
            height: 2px;
            background-color: var(--gw-accent);
        }

        .feature-list {
            list-style: none;
            padding: 0;
            margin: 3rem 0 0;
        }

        .feature-list li {
            display: flex;
            align-items: flex-start;
            gap: 1rem;
            margin-bottom: 1.75rem;
        }

        .feature-list .feature-mark {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background-color: var(--gw-accent);
            color: var(--gw-paper);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-family: var(--gw-serif);
            font-weight: 700;
            flex-shrink: 0;
        }

        .feature-list h4 {
            font-size: 1.1rem;
            margin-bottom: 0.25rem;
        }

        .feature-list p {
            color: var(--gw-ink-muted);
            font-size: 0.9rem;
            margin: 0;
            line-height: 1.55;
        }

        @media (max-width: 960px) {
            .auth-shell { grid-template-columns: 1fr; }
            .auth-form-side { padding: 3rem 2rem; }
            .auth-art-side { display: none; }
        }
    </style>

    <script type="text/javascript">
        function validateTerms(source, args) {
            args.IsValid = document.getElementById('<%= chkTerms.ClientID %>').checked;
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div class="auth-shell">

        <div class="auth-form-side">
            <div class="auth-form-box">
                <div class="auth-eyebrow">Get started</div>
                <h1>Create your account.</h1>
                <p class="auth-lead">Set up your free Grow Wealth profile in under a minute.</p>

                <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="auth-error">
                    <asp:Literal ID="litError" runat="server"></asp:Literal>
                </asp:Panel>

                <div class="form-group">
                    <label class="form-label">Full name</label>
                    <asp:TextBox ID="txtFullName" runat="server" CssClass="form-input"
                        placeholder="Your full name"></asp:TextBox>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtFullName"
                        ErrorMessage="Full name is required" CssClass="text-danger" Display="Dynamic"
                        ValidationGroup="RegV"></asp:RequiredFieldValidator>
                </div>

                <div class="form-group">
                    <label class="form-label">Email address</label>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-input"
                        TextMode="Email" placeholder="you@email.com"></asp:TextBox>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtEmail"
                        ErrorMessage="Email is required" CssClass="text-danger" Display="Dynamic"
                        ValidationGroup="RegV"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator runat="server" ControlToValidate="txtEmail"
                        ValidationExpression="^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$"
                        ErrorMessage="Enter a valid email address"
                        CssClass="text-danger" Display="Dynamic" ValidationGroup="RegV"></asp:RegularExpressionValidator>
                </div>

                <div class="form-group">
                    <label class="form-label">Password</label>
                    <asp:TextBox ID="txtPassword" runat="server" CssClass="form-input"
                        TextMode="Password" placeholder="At least 8 characters"></asp:TextBox>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtPassword"
                        ErrorMessage="Password is required" CssClass="text-danger" Display="Dynamic"
                        ValidationGroup="RegV"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator runat="server" ControlToValidate="txtPassword"
                        ValidationExpression="^.{8,}$"
                        ErrorMessage="Password must be at least 8 characters"
                        CssClass="text-danger" Display="Dynamic" ValidationGroup="RegV"></asp:RegularExpressionValidator>
                    <div class="password-hint">Use at least 8 characters. Mix letters and numbers for a stronger password.</div>
                </div>

                <div class="form-group">
                    <label class="form-label">Confirm password</label>
                    <asp:TextBox ID="txtConfirm" runat="server" CssClass="form-input"
                        TextMode="Password" placeholder="Re-enter password"></asp:TextBox>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtConfirm"
                        ErrorMessage="Please confirm your password" CssClass="text-danger" Display="Dynamic"
                        ValidationGroup="RegV"></asp:RequiredFieldValidator>
                    <asp:CompareValidator runat="server" ControlToValidate="txtConfirm"
                        ControlToCompare="txtPassword"
                        ErrorMessage="Passwords do not match"
                        CssClass="text-danger" Display="Dynamic" ValidationGroup="RegV"></asp:CompareValidator>
                </div>

                <div class="form-group">
                    <label class="form-label">I am a</label>
                    <asp:DropDownList ID="ddlUserType" runat="server" CssClass="form-input">
                        <asp:ListItem Value="student" Text="Student" Selected="True"></asp:ListItem>
                        <asp:ListItem Value="working" Text="Working professional"></asp:ListItem>
                        <asp:ListItem Value="parent" Text="Parent learning for my family"></asp:ListItem>
                        <asp:ListItem Value="curious" Text="Curious learner"></asp:ListItem>
                    </asp:DropDownList>
                </div>

                <div class="terms-row">
                    <asp:CheckBox ID="chkTerms" runat="server" />
                    <label for="<%= chkTerms.ClientID %>">
                        I agree to the <a href="#">Terms of Service</a> and <a href="#">Privacy Policy</a>.
                    </label>
                </div>
                <asp:CustomValidator runat="server" ID="cvTerms"
                    ClientValidationFunction="validateTerms"
                    OnServerValidate="cvTerms_ServerValidate"
                    ErrorMessage="You must agree to the terms to continue"
                    CssClass="text-danger" Display="Dynamic" ValidationGroup="RegV"></asp:CustomValidator>

                <asp:Button ID="btnRegister" runat="server" Text="Create my account"
                    CssClass="btn-submit" OnClick="btnRegister_Click" ValidationGroup="RegV" />

                <div class="auth-alt">
                    Already have an account? <a href="<%= ResolveUrl("~/Pages/Public/Login.aspx") %>">Log in</a>
                </div>
            </div>
        </div>

        <div class="auth-art-side">
            <div>
                <h2 style="font-size: 2.2rem; margin-bottom: 1rem; line-height: 1.15;">Three reasons to start today.</h2>
                <p style="color: var(--gw-ink-soft); font-size: 1rem; max-width: 420px;">A no-noise, editorial approach to learning about money &mdash; built for the way you actually read and learn.</p>

                <ul class="feature-list">
                    <li>
                        <span class="feature-mark">1</span>
                        <div>
                            <h4>Structured progression</h4>
                            <p>Bite-sized modules grouped into focused courses. Track your own progress, on your schedule.</p>
                        </div>
                    </li>
                    <li>
                        <span class="feature-mark">2</span>
                        <div>
                            <h4>Quizzes that test for real</h4>
                            <p>Four-option questions at the end of each module. See exactly which concepts have stuck.</p>
                        </div>
                    </li>
                    <li>
                        <span class="feature-mark">3</span>
                        <div>
                            <h4>Practice in the Virtual Lab</h4>
                            <p>Run compound-interest projections to see how time and contributions actually shape wealth.</p>
                        </div>
                    </li>
                </ul>
            </div>
        </div>

    </div>

</asp:Content>
