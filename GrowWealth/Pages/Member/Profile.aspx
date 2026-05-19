<%@ Page Title="Profile" Language="C#" MasterPageFile="~/Master/after_landing.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="GrowWealth.Pages.Member.Profile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .profile-header {
            margin-bottom: 2rem;
        }

        .profile-header h1 {
            font-size: 2.25rem;
            margin-bottom: 0.3rem;
        }

        .profile-header p {
            color: var(--gw-ink-muted);
            margin: 0;
        }

        .profile-card {
            background-color: var(--gw-surface);
            border: 1px solid var(--gw-line);
            border-radius: 16px;
            padding: 2rem 2.25rem;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 2rem;
        }

        .profile-avatar-wrap {
            position: relative;
            flex-shrink: 0;
        }

        .profile-avatar {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--gw-accent) 0%, var(--gw-accent-dark) 100%);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.2rem;
            font-weight: 600;
            font-family: var(--gw-serif);
            overflow: hidden;
        }

        .profile-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .profile-info { flex: 1; }
        .profile-info h2 {
            font-size: 1.75rem;
            margin-bottom: 0.35rem;
            color: var(--gw-ink);
        }

        .profile-meta {
            color: var(--gw-ink-muted);
            font-size: 0.9rem;
            margin-bottom: 0.65rem;
        }

        .status-pill {
            display: inline-block;
            padding: 0.25rem 0.75rem;
            background-color: var(--gw-accent-soft);
            color: var(--gw-accent);
            border-radius: 999px;
            font-size: 0.78rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.06em;
        }

        .status-pill.suspended {
            background-color: var(--gw-rose-soft);
            color: var(--gw-rose);
        }

        .stat-strip {
            display: flex;
            gap: 2rem;
            margin-top: 1rem;
            padding-top: 1rem;
            border-top: 1px solid var(--gw-line-soft);
            color: var(--gw-ink-muted);
            font-size: 0.85rem;
        }

        .stat-strip strong {
            color: var(--gw-ink);
            font-family: var(--gw-serif);
            font-size: 1.1rem;
            font-weight: 600;
            display: block;
            margin-bottom: 0.1rem;
        }

        .edit-card {
            background-color: var(--gw-surface);
            border: 1px solid var(--gw-line);
            border-radius: 16px;
            padding: 2rem 2.25rem;
            margin-bottom: 1.5rem;
        }

        .edit-card h2 {
            font-size: 1.3rem;
            margin-bottom: 0.3rem;
        }

        .edit-card .edit-subtitle {
            color: var(--gw-ink-muted);
            font-size: 0.9rem;
            margin-bottom: 1.5rem;
        }

        .section-divider {
            margin: 2rem 0 1.5rem;
            padding-top: 1.5rem;
            border-top: 1px solid var(--gw-line-soft);
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1.25rem;
        }

        .form-group {
            margin-bottom: 1.25rem;
        }

        .form-label {
            display: block;
            margin-bottom: 0.45rem;
            font-size: 0.75rem;
            font-weight: 600;
            color: var(--gw-ink-soft);
            text-transform: uppercase;
            letter-spacing: 0.08em;
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
            transition: border-color 0.2s, box-shadow 0.2s;
            outline: none;
        }

        .form-input:focus {
            border-color: var(--gw-accent);
            box-shadow: 0 0 0 3px var(--gw-accent-soft);
        }

        .file-row {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .file-row .file-input {
            flex: 1;
            padding: 0.55rem;
            border: 1px dashed var(--gw-line);
            border-radius: 8px;
            background-color: var(--gw-paper);
            font-size: 0.88rem;
        }

        .field-hint {
            font-size: 0.8rem;
            color: var(--gw-ink-muted);
            margin-top: 0.3rem;
        }

        .text-danger {
            color: var(--gw-rose);
            font-size: 0.82rem;
            margin-top: 0.3rem;
            display: block;
            font-weight: 500;
        }

        .alert {
            padding: 0.85rem 1.1rem;
            border-radius: 8px;
            margin-bottom: 1.25rem;
            font-size: 0.92rem;
            border: 1px solid;
        }

        .alert-success {
            background-color: var(--gw-accent-soft);
            color: var(--gw-accent-dark);
            border-color: #c0dccc;
        }

        .alert-danger {
            background-color: var(--gw-rose-soft);
            color: var(--gw-rose);
            border-color: #e8c4be;
        }

        .button-row {
            display: flex;
            gap: 0.75rem;
            justify-content: space-between;
            margin-top: 2rem;
            padding-top: 1.5rem;
            border-top: 1px solid var(--gw-line-soft);
            flex-wrap: wrap;
        }

        .btn-save {
            background-color: var(--gw-ink);
            color: var(--gw-paper);
            border: 1px solid var(--gw-ink);
            padding: 0.75rem 1.5rem;
            border-radius: 6px;
            font-family: var(--gw-sans);
            font-size: 0.92rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.18s;
        }

        .btn-save:hover {
            background-color: var(--gw-accent-dark);
            border-color: var(--gw-accent-dark);
        }

        .btn-danger-outline {
            background-color: transparent;
            color: var(--gw-rose);
            border: 1px solid var(--gw-rose-soft);
            padding: 0.75rem 1.4rem;
            border-radius: 6px;
            font-family: var(--gw-sans);
            font-size: 0.92rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.18s;
        }

        .btn-danger-outline:hover {
            background-color: var(--gw-rose-soft);
            border-color: var(--gw-rose);
        }

        @media (max-width: 720px) {
            .profile-card { flex-direction: column; text-align: center; }
            .stat-strip { justify-content: center; flex-wrap: wrap; }
            .form-row { grid-template-columns: 1fr; }
            .button-row { flex-direction: column-reverse; }
            .button-row .btn-save,
            .button-row .btn-danger-outline { width: 100%; }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div class="profile-header">
        <h1>Your profile</h1>
        <p>Manage your account details, security, and avatar.</p>
    </div>

    <div class="profile-card">
        <div class="profile-avatar-wrap">
            <div class="profile-avatar">
                <asp:Image ID="imgProfile" runat="server" Visible="false" />
                <asp:Literal ID="litInitials" runat="server"></asp:Literal>
            </div>
        </div>

        <div class="profile-info">
            <h2><asp:Literal ID="litFullNameDisplay" runat="server"></asp:Literal></h2>
            <div class="profile-meta">
                <asp:Literal ID="litEmailDisplay" runat="server"></asp:Literal>
                &middot; Member since <asp:Literal ID="litMemberSince" runat="server"></asp:Literal>
            </div>
            <span runat="server" id="badgeStatus" class="status-pill">
                <asp:Literal ID="litStatus" runat="server"></asp:Literal>
            </span>

            <div class="stat-strip">
                <div>
                    <strong><asp:Literal ID="litStatCourses" runat="server" Text="0"></asp:Literal></strong>
                    Courses enrolled
                </div>
                <div>
                    <strong><asp:Literal ID="litStatModules" runat="server" Text="0"></asp:Literal></strong>
                    Modules done
                </div>
                <div>
                    <strong><asp:Literal ID="litStatScore" runat="server" Text="0"></asp:Literal>%</strong>
                    Average score
                </div>
            </div>
        </div>
    </div>

    <div class="edit-card">
        <h2>Account details</h2>
        <p class="edit-subtitle">Update your name, email, or profile picture.</p>

        <asp:Panel ID="pnlSuccess" runat="server" Visible="false" CssClass="alert alert-success">
            <asp:Literal ID="litSuccessMsg" runat="server"></asp:Literal>
        </asp:Panel>

        <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="alert alert-danger">
            <asp:Literal ID="litErrorMsg" runat="server"></asp:Literal>
        </asp:Panel>

        <div class="form-row">
            <div class="form-group">
                <label class="form-label">Full name</label>
                <asp:TextBox ID="txtFullName" runat="server" CssClass="form-input"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvFullName" runat="server"
                    ControlToValidate="txtFullName"
                    ErrorMessage="Full name is required"
                    CssClass="text-danger"
                    Display="Dynamic"
                    ValidationGroup="SaveProfile">
                </asp:RequiredFieldValidator>
            </div>

            <div class="form-group">
                <label class="form-label">Email address</label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-input" TextMode="Email"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvEmail" runat="server"
                    ControlToValidate="txtEmail"
                    ErrorMessage="Email is required"
                    CssClass="text-danger"
                    Display="Dynamic"
                    ValidationGroup="SaveProfile">
                </asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="revEmail" runat="server"
                    ControlToValidate="txtEmail"
                    ValidationExpression="^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$"
                    ErrorMessage="Enter a valid email address"
                    CssClass="text-danger"
                    Display="Dynamic"
                    ValidationGroup="SaveProfile">
                </asp:RegularExpressionValidator>
            </div>
        </div>

        <div class="form-group">
            <label class="form-label">Profile picture</label>
            <div class="file-row">
                <asp:FileUpload ID="fuProfilePic" runat="server" CssClass="file-input" />
            </div>
            <span class="field-hint">JPG or PNG, up to 2 MB. Leave empty to keep your current picture.</span>
        </div>

        <div class="section-divider">
            <h2>Change password</h2>
            <p class="edit-subtitle">Fill in all three fields below to update your password. Leave blank to keep it unchanged.</p>
        </div>

        <div class="form-group">
            <label class="form-label">Current password</label>
            <asp:TextBox ID="txtCurrentPassword" runat="server" CssClass="form-input" TextMode="Password"></asp:TextBox>
        </div>

        <div class="form-row">
            <div class="form-group">
                <label class="form-label">New password</label>
                <asp:TextBox ID="txtNewPassword" runat="server" CssClass="form-input" TextMode="Password"></asp:TextBox>
                <asp:RegularExpressionValidator ID="revNewPassword" runat="server"
                    ControlToValidate="txtNewPassword"
                    ValidationExpression="^.{8,}$"
                    ErrorMessage="At least 8 characters"
                    CssClass="text-danger"
                    Display="Dynamic"
                    ValidationGroup="SaveProfile">
                </asp:RegularExpressionValidator>
            </div>

            <div class="form-group">
                <label class="form-label">Confirm new password</label>
                <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-input" TextMode="Password"></asp:TextBox>
                <asp:CompareValidator ID="cvPassword" runat="server"
                    ControlToValidate="txtConfirmPassword"
                    ControlToCompare="txtNewPassword"
                    ErrorMessage="Passwords don't match"
                    CssClass="text-danger"
                    Display="Dynamic"
                    ValidationGroup="SaveProfile">
                </asp:CompareValidator>
            </div>
        </div>

        <div class="button-row">
            <asp:Button ID="btnDelete" runat="server" Text="Delete account"
                CssClass="btn-danger-outline"
                OnClick="btnDelete_Click"
                CausesValidation="false"
                OnClientClick="return confirm('This will permanently delete your account and all your progress. Continue?');" />

            <asp:Button ID="btnSave" runat="server" Text="Save changes"
                CssClass="btn-save"
                OnClick="btnSave_Click"
                ValidationGroup="SaveProfile" />
        </div>
    </div>

</asp:Content>
