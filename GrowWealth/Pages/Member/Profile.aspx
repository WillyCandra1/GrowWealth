<%@ Page Title="Profile" Language="C#" MasterPageFile="~/Master/after_landing.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="GrowWealth.Pages.Member.Profile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        /* Profile-specific styles */
        .profile-card,
        .edit-card {
            background-color: var(--surface);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 1.75rem;
            margin-bottom: 1.5rem;
        }

        .profile-header {
            display: flex;
            align-items: center;
            gap: 1.5rem;
        }

        .avatar {
            width: 88px;
            height: 88px;
            border-radius: 50%;
            background-color: #ede9fe;
            color: var(--primary);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.75rem;
            font-weight: 700;
            flex-shrink: 0;
        }

        .profile-info { flex: 1; }
        .profile-info h1 { font-size: 1.5rem; margin-bottom: 0.25rem; }
        .profile-info p { color: var(--text-secondary); font-size: 0.9rem; margin-bottom: 0.5rem; }

        .status-badge {
            display: inline-block;
            padding: 0.2rem 0.7rem;
            background-color: var(--success);
            color: var(--success-text);
            border-radius: 999px;
            font-size: 0.8rem;
            font-weight: 600;
        }
        .status-badge.suspended {
            background-color: var(--error);
            color: var(--error-text);
        }

        .edit-card h2 {
            font-size: 1.125rem;
            margin-bottom: 1.25rem;
        }

        .section-divider {
            border-top: 1px solid var(--border);
            margin: 1.5rem 0 1.25rem;
            padding-top: 1.25rem;
        }

        .btn-danger {
            background-color: transparent;
            color: var(--error-text);
            border: 1px solid #fecaca;
        }
        .btn-danger:hover {
            background-color: var(--error);
        }

        .button-row {
            display: flex;
            gap: 0.75rem;
            margin-top: 1.5rem;
        }

        .alert-success {
            background-color: var(--success);
            color: var(--success-text);
            padding: 0.85rem 1rem;
            border-radius: 6px;
            margin-bottom: 1.25rem;
            border: 1px solid #bbf7d0;
            font-size: 0.9rem;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h1 style="margin-bottom: 1.5rem;">My profile</h1>

    <!-- Top profile card (avatar + name) -->
    <div class="profile-card">
        <div class="profile-header">
            <div class="avatar">
                <asp:Literal ID="litInitials" runat="server"></asp:Literal>
            </div>
            <div class="profile-info">
                <h1><asp:Literal ID="litFullName" runat="server"></asp:Literal></h1>
                <p>
                    <asp:Literal ID="litEmailDisplay" runat="server"></asp:Literal>
                    &middot; Member since <asp:Literal ID="litMemberSince" runat="server"></asp:Literal>
                </p>
                <span class="status-badge" id="badgeStatus" runat="server">
                    <asp:Literal ID="litStatus" runat="server" Text="Active"></asp:Literal>
                </span>
            </div>
        </div>
    </div>

    <!-- Edit profile card -->
    <div class="edit-card">
        <h2>Edit profile</h2>

        <asp:Panel ID="pnlSuccess" runat="server" Visible="false" CssClass="alert-success">
            <asp:Literal ID="litSuccessMsg" runat="server"></asp:Literal>
        </asp:Panel>

        <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="alert-danger">
            <asp:Literal ID="litErrorMsg" runat="server"></asp:Literal>
        </asp:Panel>

        <div class="form-group">
            <label class="form-label">Full name</label>
            <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control"></asp:TextBox>
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
            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email"></asp:TextBox>
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
                ErrorMessage="Invalid email format"
                CssClass="text-danger"
                Display="Dynamic"
                ValidationGroup="SaveProfile">
            </asp:RegularExpressionValidator>
        </div>

        <!-- Change password section -->
        <div class="section-divider">
            <h2>Change password</h2>
        </div>

        <div class="form-group">
            <label class="form-label">Current password</label>
            <asp:TextBox ID="txtCurrentPassword" runat="server" CssClass="form-control"
                TextMode="Password" placeholder="Required only if changing password"></asp:TextBox>
        </div>

        <div class="form-group">
            <label class="form-label">New password</label>
            <asp:TextBox ID="txtNewPassword" runat="server" CssClass="form-control"
                TextMode="Password" placeholder="Leave blank to keep current"></asp:TextBox>
            <asp:RegularExpressionValidator ID="revNewPassword" runat="server"
                ControlToValidate="txtNewPassword"
                ValidationExpression="^.{8,}$"
                ErrorMessage="New password must be at least 8 characters"
                CssClass="text-danger"
                Display="Dynamic"
                ValidationGroup="SaveProfile">
            </asp:RegularExpressionValidator>
        </div>

        <div class="form-group">
            <label class="form-label">Confirm new password</label>
            <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-control"
                TextMode="Password" placeholder="Re-enter new password"></asp:TextBox>
            <asp:CompareValidator ID="cvPassword" runat="server"
                ControlToValidate="txtConfirmPassword"
                ControlToCompare="txtNewPassword"
                ErrorMessage="Passwords do not match"
                CssClass="text-danger"
                Display="Dynamic"
                ValidationGroup="SaveProfile">
            </asp:CompareValidator>
        </div>

        <div class="button-row">
            <asp:Button ID="btnSave" runat="server" Text="Save changes"
                CssClass="btn btn-primary"
                OnClick="btnSave_Click"
                ValidationGroup="SaveProfile" />

            <asp:Button ID="btnDelete" runat="server" Text="Delete account"
                CssClass="btn btn-danger"
                OnClick="btnDelete_Click"
                CausesValidation="false"
                OnClientClick="return confirm('Are you sure you want to delete your account? This action cannot be undone.');" />
        </div>
    </div>

</asp:Content>
