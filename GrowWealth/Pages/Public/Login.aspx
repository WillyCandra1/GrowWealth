<%@ Page Title="Log in — Grow Wealth" Language="C#" MasterPageFile="~/Master/before_landing.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="GrowWealth.Pages.Public.Login" %>

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
            max-width: 420px;
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

        .form-group { margin-bottom: 1.25rem; }

        .form-label {
            display: block;
            margin-bottom: 0.5rem;
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

        .remember-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.75rem;
            font-size: 0.88rem;
        }

        .remember-row label {
            color: var(--gw-ink-soft);
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            cursor: pointer;
        }

        .remember-row input[type="checkbox"] {
            width: 16px;
            height: 16px;
            accent-color: var(--gw-accent);
        }

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
            justify-content: space-between;
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

        .auth-art-quote {
            font-family: var(--gw-serif);
            font-size: 2rem;
            line-height: 1.3;
            color: var(--gw-ink);
            font-weight: 500;
            max-width: 440px;
            margin-top: 4rem;
            letter-spacing: -0.01em;
        }

        .auth-art-quote em {
            font-style: italic;
            color: var(--gw-accent);
        }

        .auth-art-attribution {
            color: var(--gw-ink-muted);
            font-size: 0.92rem;
            margin-top: 2rem;
        }

        .auth-art-attribution strong {
            color: var(--gw-ink);
            display: block;
            font-family: var(--gw-serif);
            font-size: 1.05rem;
            margin-bottom: 0.2rem;
        }

        .auth-art-pricing {
            background-color: var(--gw-surface);
            border-radius: 12px;
            padding: 1.75rem;
            border: 1px solid var(--gw-line);
        }

        .auth-art-pricing strong {
            font-family: var(--gw-serif);
            font-size: 1.3rem;
            color: var(--gw-ink);
            display: block;
            margin-bottom: 0.3rem;
        }

        .auth-art-pricing p {
            color: var(--gw-ink-muted);
            font-size: 0.88rem;
            margin: 0;
        }

        @media (max-width: 960px) {
            .auth-shell { grid-template-columns: 1fr; }
            .auth-form-side { padding: 3rem 2rem; }
            .auth-art-side { display: none; }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div class="auth-shell">

        <div class="auth-form-side">
            <div class="auth-form-box">
                <div class="auth-eyebrow">Welcome back</div>
                <h1>Log in to your account.</h1>
                <p class="auth-lead">Continue your journey from where you left off.</p>

                <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="auth-error">
                    <asp:Literal ID="litError" runat="server"></asp:Literal>
                </asp:Panel>

                <div class="form-group">
                    <label class="form-label">Email address</label>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-input"
                        TextMode="Email" placeholder="you@email.com"></asp:TextBox>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtEmail"
                        ErrorMessage="Email is required" CssClass="text-danger" Display="Dynamic"
                        ValidationGroup="LoginV"></asp:RequiredFieldValidator>
                </div>

                <div class="form-group">
                    <label class="form-label">Password</label>
                    <asp:TextBox ID="txtPassword" runat="server" CssClass="form-input"
                        TextMode="Password" placeholder="&#8226;&#8226;&#8226;&#8226;&#8226;&#8226;&#8226;&#8226;"></asp:TextBox>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtPassword"
                        ErrorMessage="Password is required" CssClass="text-danger" Display="Dynamic"
                        ValidationGroup="LoginV"></asp:RequiredFieldValidator>
                </div>

                <div class="remember-row">
                    <label>
                        <asp:CheckBox ID="chkRemember" runat="server" />
                        Remember me on this device
                    </label>
                </div>

                <asp:Button ID="btnLogin" runat="server" Text="Log in"
                    CssClass="btn-submit" OnClick="btnLogin_Click" ValidationGroup="LoginV" />

                <div class="auth-alt">
                    Don't have an account? <a href="<%= ResolveUrl("~/Pages/Public/Register.aspx") %>">Get started</a>
                </div>
            </div>
        </div>

        <div class="auth-art-side">
            <div></div>
            <div>
                <p class="auth-art-quote">"Knowing where your money goes is the first form of <em>wealth</em>."</p>
                <p class="auth-art-attribution">
                    <strong>Editorial team</strong>
                    Grow Wealth, Course foreword
                </p>
            </div>
            <div class="auth-art-pricing">
                <strong>Free forever</strong>
                <p>No tier, no paywall. Built as an academic project, made for genuine learning.</p>
            </div>
        </div>

    </div>

</asp:Content>
