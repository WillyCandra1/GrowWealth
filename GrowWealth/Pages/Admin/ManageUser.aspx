<%@ Page Title="Manage Users" Language="C#" MasterPageFile="~/Master/Admin.Master" AutoEventWireup="true" CodeBehind="ManageUser.aspx.cs" Inherits="GrowWealth.Pages.Admin.ManageUser" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .page-head {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            margin-bottom: 1.75rem;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .page-head h1 {
            font-size: 2.2rem;
            margin-bottom: 0.3rem;
        }

        .page-head p {
            color: var(--gw-ink-muted);
            margin: 0;
        }

        .toolbar {
            background-color: var(--gw-surface);
            border: 1px solid var(--gw-line);
            border-radius: 14px;
            padding: 1.1rem 1.4rem;
            margin-bottom: 1.5rem;
            display: flex;
            gap: 0.85rem;
            flex-wrap: wrap;
            align-items: center;
        }

        .toolbar .form-input {
            padding: 0.6rem 0.9rem;
            border: 1px solid var(--gw-line);
            border-radius: 8px;
            font-size: 0.92rem;
            font-family: var(--gw-sans);
            color: var(--gw-ink);
            background-color: var(--gw-surface);
            outline: none;
        }

        .toolbar .form-input:focus {
            border-color: var(--gw-accent);
            box-shadow: 0 0 0 3px var(--gw-accent-soft);
        }

        .toolbar .search { flex: 1; min-width: 220px; }

        .btn-primary {
            background-color: var(--gw-ink);
            color: var(--gw-paper);
            border: 1px solid var(--gw-ink);
            padding: 0.6rem 1.2rem;
            border-radius: 8px;
            font-family: var(--gw-sans);
            font-size: 0.88rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.18s;
        }

        .btn-primary:hover {
            background-color: var(--gw-accent-dark);
            border-color: var(--gw-accent-dark);
        }

        .btn-secondary {
            background-color: transparent;
            color: var(--gw-ink);
            border: 1px solid var(--gw-line);
            padding: 0.6rem 1.2rem;
            border-radius: 8px;
            font-family: var(--gw-sans);
            font-size: 0.88rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.18s;
        }

        .btn-secondary:hover { border-color: var(--gw-ink); }

        .table-panel {
            background-color: var(--gw-surface);
            border: 1px solid var(--gw-line);
            border-radius: 14px;
            padding: 1.5rem 1.75rem;
            margin-bottom: 1.5rem;
        }

        .data-table {
            width: 100%;
            border-collapse: collapse;
        }

        .data-table th {
            text-align: left;
            font-size: 0.7rem;
            text-transform: uppercase;
            letter-spacing: 0.1em;
            color: var(--gw-ink-muted);
            font-weight: 600;
            padding: 0.7rem 0.85rem;
            border-bottom: 1px solid var(--gw-line);
        }

        .data-table td {
            padding: 0.95rem 0.85rem;
            border-bottom: 1px solid var(--gw-line-soft);
            font-size: 0.92rem;
            color: var(--gw-ink);
            vertical-align: middle;
        }

        .data-table tr:last-child td { border-bottom: none; }
        .data-table tr:hover td { background-color: var(--gw-paper); }

        .role-pill, .status-pill {
            display: inline-block;
            padding: 0.22rem 0.7rem;
            border-radius: 999px;
            font-size: 0.72rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.06em;
        }

        .role-pill.admin { background-color: var(--gw-gold-soft); color: var(--gw-gold); }
        .role-pill.member { background-color: var(--gw-accent-soft); color: var(--gw-accent); }

        .status-pill.active { background-color: var(--gw-accent-soft); color: var(--gw-accent); }
        .status-pill.suspended { background-color: var(--gw-rose-soft); color: var(--gw-rose); }

        .row-actions {
            display: flex;
            gap: 0.4rem;
            justify-content: flex-end;
        }

        .row-actions .btn-icon {
            background-color: transparent;
            border: 1px solid var(--gw-line);
            color: var(--gw-ink-soft);
            padding: 0.35rem 0.7rem;
            border-radius: 6px;
            font-family: var(--gw-sans);
            font-size: 0.78rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.18s;
        }

        .row-actions .btn-icon:hover {
            background-color: var(--gw-ink);
            color: var(--gw-paper);
            border-color: var(--gw-ink);
        }

        .row-actions .btn-icon.danger:hover {
            background-color: var(--gw-rose);
            border-color: var(--gw-rose);
            color: white;
        }

        .empty-row td {
            text-align: center;
            color: var(--gw-ink-muted);
            font-style: italic;
            padding: 2rem 0;
        }

        .alert {
            padding: 0.85rem 1.1rem;
            border-radius: 8px;
            margin-bottom: 1.25rem;
            font-size: 0.92rem;
            border: 1px solid;
        }

        .alert-success { background-color: var(--gw-accent-soft); color: var(--gw-accent-dark); border-color: #c0dccc; }
        .alert-danger { background-color: var(--gw-rose-soft); color: var(--gw-rose); border-color: #e8c4be; }

        .edit-card {
            background-color: var(--gw-surface);
            border: 1px solid var(--gw-line);
            border-radius: 14px;
            padding: 2rem 2.25rem;
            margin-bottom: 1.5rem;
        }

        .edit-card h2 {
            font-size: 1.3rem;
            margin-bottom: 0.4rem;
        }

        .edit-card .subtitle {
            color: var(--gw-ink-muted);
            font-size: 0.9rem;
            margin-bottom: 1.5rem;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1.25rem;
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

        .form-input-block {
            width: 100%;
            padding: 0.7rem 0.95rem;
            border: 1px solid var(--gw-line);
            border-radius: 8px;
            font-size: 0.92rem;
            font-family: var(--gw-sans);
            color: var(--gw-ink);
            background-color: var(--gw-surface);
            outline: none;
        }

        .form-input-block:focus {
            border-color: var(--gw-accent);
            box-shadow: 0 0 0 3px var(--gw-accent-soft);
        }

        .text-danger {
            color: var(--gw-rose);
            font-size: 0.8rem;
            margin-top: 0.25rem;
            display: block;
            font-weight: 500;
        }

        .edit-actions {
            display: flex;
            gap: 0.6rem;
            margin-top: 1.5rem;
            padding-top: 1.5rem;
            border-top: 1px solid var(--gw-line-soft);
        }

        .user-detail-strip {
            background-color: var(--gw-paper);
            border: 1px solid var(--gw-line-soft);
            border-radius: 10px;
            padding: 1rem 1.25rem;
            margin-bottom: 1.5rem;
            display: flex;
            gap: 2rem;
            flex-wrap: wrap;
            font-size: 0.88rem;
        }

        .user-detail-strip span strong {
            color: var(--gw-ink);
            font-family: var(--gw-serif);
            font-weight: 600;
            font-size: 1rem;
            display: block;
            margin-bottom: 0.1rem;
        }

        .user-detail-strip span {
            color: var(--gw-ink-muted);
        }

        @media (max-width: 720px) {
            .form-grid { grid-template-columns: 1fr; }
            .data-table th:nth-child(3), .data-table td:nth-child(3) { display: none; }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div class="page-head">
        <div>
            <h1>Manage users</h1>
            <p>View, edit, and manage user accounts on the platform.</p>
        </div>
    </div>

    <asp:Panel ID="pnlSuccess" runat="server" Visible="false" CssClass="alert alert-success">
        <asp:Literal ID="litSuccess" runat="server"></asp:Literal>
    </asp:Panel>

    <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="alert alert-danger">
        <asp:Literal ID="litError" runat="server"></asp:Literal>
    </asp:Panel>

    <asp:Panel ID="pnlEditForm" runat="server" Visible="false" CssClass="edit-card">
        <h2><asp:Literal ID="litEditHeader" runat="server">Edit user</asp:Literal></h2>
        <p class="subtitle">Update this user's details, role, or account status.</p>

        <div class="user-detail-strip">
            <span><strong><asp:Literal ID="litDetailEnrols" runat="server"></asp:Literal></strong>Courses enrolled</span>
            <span><strong><asp:Literal ID="litDetailModules" runat="server"></asp:Literal></strong>Modules completed</span>
            <span><strong><asp:Literal ID="litDetailAttempts" runat="server"></asp:Literal></strong>Quiz attempts</span>
            <span><strong><asp:Literal ID="litDetailAvg" runat="server"></asp:Literal>%</strong>Avg score</span>
            <span><strong><asp:Literal ID="litDetailLastLogin" runat="server"></asp:Literal></strong>Last login</span>
            <span><strong><asp:Literal ID="litDetailJoined" runat="server"></asp:Literal></strong>Joined</span>
        </div>

        <div class="form-grid">
            <div class="form-group">
                <label class="form-label">Full name</label>
                <asp:TextBox ID="txtFullName" runat="server" CssClass="form-input-block"></asp:TextBox>
                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtFullName"
                    ErrorMessage="Full name is required" CssClass="text-danger" Display="Dynamic"
                    ValidationGroup="EditUser"></asp:RequiredFieldValidator>
            </div>

            <div class="form-group">
                <label class="form-label">Email</label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-input-block" TextMode="Email"></asp:TextBox>
                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtEmail"
                    ErrorMessage="Email is required" CssClass="text-danger" Display="Dynamic"
                    ValidationGroup="EditUser"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator runat="server" ControlToValidate="txtEmail"
                    ValidationExpression="^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$"
                    ErrorMessage="Enter a valid email"
                    CssClass="text-danger" Display="Dynamic" ValidationGroup="EditUser"></asp:RegularExpressionValidator>
            </div>

            <div class="form-group">
                <label class="form-label">Role</label>
                <asp:DropDownList ID="ddlRole" runat="server" CssClass="form-input-block">
                    <asp:ListItem Value="1" Text="Admin"></asp:ListItem>
                    <asp:ListItem Value="2" Text="Member" Selected="True"></asp:ListItem>
                </asp:DropDownList>
            </div>

            <div class="form-group">
                <label class="form-label">Account status</label>
                <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-input-block">
                    <asp:ListItem Value="Active" Text="Active" Selected="True"></asp:ListItem>
                    <asp:ListItem Value="Suspended" Text="Suspended"></asp:ListItem>
                </asp:DropDownList>
            </div>
        </div>

        <div class="edit-actions">
            <asp:Button ID="btnSave" runat="server" Text="Save changes"
                CssClass="btn-primary" OnClick="btnSave_Click" ValidationGroup="EditUser" />
            <asp:Button ID="btnCancel" runat="server" Text="Cancel"
                CssClass="btn-secondary" OnClick="btnCancel_Click" CausesValidation="false" />
        </div>
    </asp:Panel>

    <div class="toolbar">
        <asp:TextBox ID="txtSearch" runat="server" CssClass="form-input search"
            placeholder="Search by name or email&#8230;"></asp:TextBox>
        <asp:DropDownList ID="ddlFilterRole" runat="server" CssClass="form-input">
            <asp:ListItem Value="" Text="All roles" Selected="True"></asp:ListItem>
            <asp:ListItem Value="1" Text="Admins"></asp:ListItem>
            <asp:ListItem Value="2" Text="Members"></asp:ListItem>
        </asp:DropDownList>
        <asp:DropDownList ID="ddlFilterStatus" runat="server" CssClass="form-input">
            <asp:ListItem Value="" Text="All statuses" Selected="True"></asp:ListItem>
            <asp:ListItem Value="Active" Text="Active"></asp:ListItem>
            <asp:ListItem Value="Suspended" Text="Suspended"></asp:ListItem>
        </asp:DropDownList>
        <asp:Button ID="btnFilter" runat="server" Text="Apply" CssClass="btn-primary"
            OnClick="btnFilter_Click" CausesValidation="false" />
        <asp:Button ID="btnReset" runat="server" Text="Reset" CssClass="btn-secondary"
            OnClick="btnReset_Click" CausesValidation="false" />
    </div>

    <div class="table-panel">
        <table class="data-table">
            <thead>
                <tr>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Role</th>
                    <th>Status</th>
                    <th>Joined</th>
                    <th style="text-align:right;">Actions</th>
                </tr>
            </thead>
            <tbody>
                <asp:Repeater ID="rptUsers" runat="server" OnItemCommand="rptUsers_ItemCommand">
                    <ItemTemplate>
                        <tr>
                            <td><strong><%# Eval("FullName") %></strong></td>
                            <td><%# Eval("Email") %></td>
                            <td><span class='<%# "role-pill " + Eval("RoleClass") %>'><%# Eval("RoleName") %></span></td>
                            <td><span class='<%# "status-pill " + Eval("StatusClass") %>'><%# Eval("AccountStatus") %></span></td>
                            <td><%# Eval("CreatedAtFmt") %></td>
                            <td>
                                <div class="row-actions">
                                    <asp:LinkButton runat="server" CssClass="btn-icon"
                                        CommandName="EditUser"
                                        CommandArgument='<%# Eval("UserID") %>'>Edit</asp:LinkButton>
                                    <asp:LinkButton runat="server" CssClass="btn-icon danger"
                                        CommandName="DeleteUser"
                                        CommandArgument='<%# Eval("UserID") %>'
                                        OnClientClick="return confirm('Delete this user and all their progress? This cannot be undone.');">Delete</asp:LinkButton>
                                </div>
                            </td>
                        </tr>
                    </ItemTemplate>
                </asp:Repeater>
                <asp:PlaceHolder ID="pnlEmpty" runat="server" Visible="false">
                    <tr class="empty-row"><td colspan="6">No users match your filter.</td></tr>
                </asp:PlaceHolder>
            </tbody>
        </table>
    </div>

</asp:Content>
