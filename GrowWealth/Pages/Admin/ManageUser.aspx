<%@ Page Title="Manage Users" Language="C#" MasterPageFile="~/Master/Admin.Master" AutoEventWireup="true" CodeBehind="ManageUser.aspx.cs" Inherits="GrowWealth.Pages.Admin.ManageUser" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
<style>
    .page-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 1.5rem; }
    .page-header h1 { font-size: 1.5rem; margin: 0; }

    .stat-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(140px, 1fr)); gap: 1rem; margin-bottom: 1.5rem; }
    .stat-card { background: var(--surface); border: 1px solid var(--border); border-radius: 8px; padding: 1rem 1.25rem; }
    .stat-card .s-label { font-size: 0.75rem; color: var(--text-secondary); margin-bottom: 0.4rem; }
    .stat-card .s-value { font-size: 1.75rem; font-weight: 600; color: var(--primary); }

    .toolbar { display: flex; gap: 0.75rem; margin-bottom: 1rem; flex-wrap: wrap; }
    .toolbar .form-control { flex: 1; min-width: 140px; margin: 0; }

    .table-wrap { background: var(--surface); border: 1px solid var(--border); border-radius: 8px; overflow: hidden; }
    .admin-table { width: 100%; border-collapse: collapse; font-size: 0.875rem; }
    .admin-table thead { background: var(--bg); }
    .admin-table th { text-align: left; padding: 0.75rem 1rem; font-size: 0.75rem; font-weight: 600; color: var(--text-secondary); border-bottom: 1px solid var(--border); }
    .admin-table td { padding: 0.75rem 1rem; border-bottom: 1px solid var(--border); vertical-align: middle; }
    .admin-table tr:last-child td { border-bottom: none; }
    .admin-table tr:hover td { background: var(--bg); }

    .avatar { width: 32px; height: 32px; border-radius: 50%; background: #ede9fe; color: var(--primary); display: inline-flex; align-items: center; justify-content: center; font-size: 0.7rem; font-weight: 600; margin-right: 0.5rem; flex-shrink: 0; vertical-align: middle; }
    .name-cell { display: flex; align-items: center; }

    .sbadge { display: inline-block; padding: 0.2rem 0.6rem; border-radius: 4px; font-size: 0.75rem; font-weight: 500; }
    .sbadge-admin    { background: #fce7f3; color: #9d174d; }
    .sbadge-member   { background: #ede9fe; color: var(--primary); }
    .sbadge-active   { background: #dcfce7; color: #15803d; }
    .sbadge-inactive { background: #f1f1f1; color: #555; }

    .action-cell { display: flex; gap: 0.5rem; }
    .btn-sm { padding: 0.3rem 0.75rem; font-size: 0.8rem; border-radius: 6px; border: 1px solid var(--border); background: var(--surface); color: var(--text-primary); cursor: pointer; font-family: inherit; text-decoration: none; display: inline-flex; align-items: center; }
    .btn-sm:hover { background: var(--bg); }
    .btn-sm-danger { color: #b91c1c; border-color: #fecaca; }
    .btn-sm-danger:hover { background: #fee2e2; }

    .alert-success { background: var(--success); color: var(--success-text); border: 1px solid #bbf7d0; padding: 0.75rem 1rem; border-radius: 6px; font-size: 0.875rem; margin-bottom: 1rem; display: block; }
    .alert-error   { background: var(--error); color: var(--error-text); border: 1px solid #fecaca; padding: 0.75rem 1rem; border-radius: 6px; font-size: 0.875rem; margin-bottom: 1rem; display: block; }

    .modal-overlay { display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.4); z-index: 1000; align-items: center; justify-content: center; }
    .modal-overlay.open { display: flex; }
    .modal-panel { background: var(--surface); border-radius: 12px; padding: 2rem; width: 480px; max-width: 95vw; box-shadow: 0 20px 40px rgba(0,0,0,0.12); }
    .modal-panel h2 { font-size: 1.125rem; margin-bottom: 1.25rem; }
    .modal-footer { display: flex; justify-content: flex-end; gap: 0.75rem; margin-top: 1.25rem; }
    .empty-row { text-align: center; padding: 2rem; color: var(--text-secondary); font-size: 0.875rem; }
</style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div class="page-header">
        <h1 id="lbl_ManageUsers">Manage Users</h1>
        <button type="button" class="btn btn-primary" onclick="openModal('addModal')" id="btn_AddUser">+ Add User</button>
    </div>

    <asp:Label ID="lbl_Message" runat="server" Visible="false" />

    <div class="stat-grid">
        <div class="stat-card">
            <div class="s-label" id="lbl_User">Users</div>
            <div class="s-value" id="value_User"><asp:Label ID="lbl_UserCount" runat="server" Text="0" /></div>
        </div>
        <div class="stat-card">
            <div class="s-label" id="lbl_Admins">Admins</div>
            <div class="s-value" id="value_Admins"><asp:Label ID="lbl_AdminCount" runat="server" Text="0" /></div>
        </div>
        <div class="stat-card">
            <div class="s-label" id="lbl_Members">Members</div>
            <div class="s-value" id="value_Members"><asp:Label ID="lbl_MemberCount" runat="server" Text="0" /></div>
        </div>
        <div class="stat-card">
            <div class="s-label" id="lbl_Active">Active</div>
            <div class="s-value" id="value_Active"><asp:Label ID="lbl_ActiveCount" runat="server" Text="0" /></div>
        </div>
    </div>

    <div class="toolbar">
        <asp:TextBox ID="txt_Search" runat="server" CssClass="form-control" placeholder="Search by name or email..." />
        <asp:DropDownList ID="ddl_RoleFilter" runat="server" CssClass="form-control" style="flex:0 0 auto;width:auto;">
            <asp:ListItem Text="All Roles" Value="" />
            <asp:ListItem Text="Admin"     Value="1" />
            <asp:ListItem Text="Member"    Value="2" />
        </asp:DropDownList>
        <asp:DropDownList ID="ddl_StatusFilter" runat="server" CssClass="form-control" style="flex:0 0 auto;width:auto;">
            <asp:ListItem Text="All Status" Value="" />
            <asp:ListItem Text="Active"     Value="Active" />
            <asp:ListItem Text="Inactive"   Value="Inactive" />
        </asp:DropDownList>
        <asp:Button ID="btn_Search" runat="server" Text="Search" CssClass="btn btn-outline" OnClick="btn_Search_Click" />
    </div>

    <div class="table-wrap">
        <asp:GridView ID="gv_Users" runat="server" AutoGenerateColumns="false"
            DataKeyNames="UserID" OnRowCommand="gv_Users_RowCommand"
            CssClass="admin-table" GridLines="None" Width="100%">
            <Columns>
                <asp:BoundField DataField="UserID" HeaderText="ID" />
                <asp:TemplateField HeaderText="Name">
                    <ItemTemplate>
                        <div class="name-cell">
                            <div class="avatar"><%# GetInitials(Eval("FullName").ToString()) %></div>
                            <%# Eval("FullName") %>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="Email"          HeaderText="Email" />
                <asp:TemplateField HeaderText="Role">
                    <ItemTemplate>
                        <span class="sbadge sbadge-<%# Eval("RoleName").ToString().ToLower() %>"><%# Eval("RoleName") %></span>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="UserProfession" HeaderText="Profession" />
                <asp:TemplateField HeaderText="Status">
                    <ItemTemplate>
                        <span class="sbadge sbadge-<%# Eval("AccountStatus").ToString().ToLower() %>"><%# Eval("AccountStatus") %></span>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="CreatedAt" HeaderText="Joined" DataFormatString="{0:dd MMM yyyy}" />
                <asp:TemplateField HeaderText="Actions">
                    <ItemTemplate>
                        <div class="action-cell">
                            <asp:LinkButton runat="server" CommandName="EditUser"
                                CommandArgument='<%# Eval("UserID") %>'
                                CssClass="btn-sm">Edit</asp:LinkButton>
                            <asp:LinkButton runat="server" CommandName="DeleteUser"
                                CommandArgument='<%# Eval("UserID") %>'
                                CssClass="btn-sm btn-sm-danger"
                                OnClientClick="return confirm('Delete this user?');">Delete</asp:LinkButton>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <EmptyDataTemplate><div class="empty-row">No users found.</div></EmptyDataTemplate>
        </asp:GridView>
    </div>

    <%-- Add User Modal --%>
    <div class="modal-overlay" id="addModal">
        <div class="modal-panel">
            <h2>Add New User</h2>
            <div class="form-group"><label class="form-label">Full Name *</label><asp:TextBox ID="txt_FullName"   runat="server" CssClass="form-control" placeholder="e.g. Ahmad bin Ali" /></div>
            <div class="form-group"><label class="form-label">Email *</label>    <asp:TextBox ID="txt_Email"      runat="server" TextMode="Email" CssClass="form-control" placeholder="user@email.com" /></div>
            <div class="form-group"><label class="form-label">Password *</label> <asp:TextBox ID="txt_Password"   runat="server" TextMode="Password" CssClass="form-control" /></div>
            <div class="form-group"><label class="form-label">Profession</label>  <asp:TextBox ID="txt_Profession" runat="server" CssClass="form-control" placeholder="e.g. University Student" /></div>
            <div class="form-group">
                <label class="form-label">Role</label>
                <asp:DropDownList ID="ddl_Role" runat="server" CssClass="form-control">
                    <asp:ListItem Text="Member" Value="2" />
                    <asp:ListItem Text="Admin"  Value="1" />
                </asp:DropDownList>
            </div>
            <div class="form-group">
                <label class="form-label">Account Status</label>
                <asp:DropDownList ID="ddl_AccountStatus" runat="server" CssClass="form-control">
                    <asp:ListItem Text="Active"   Value="Active" />
                    <asp:ListItem Text="Inactive" Value="Inactive" />
                </asp:DropDownList>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline" onclick="closeModal('addModal')">Cancel</button>
                <asp:Button ID="btn_AddUserSubmit" runat="server" Text="Save User" CssClass="btn btn-primary" OnClick="btn_AddUser_Click" />
            </div>
        </div>
    </div>

    <%-- Edit User Modal --%>
    <div class="modal-overlay" id="editModal">
        <div class="modal-panel">
            <h2>Edit User</h2>
            <asp:HiddenField ID="hf_EditUserID" runat="server" />
            <div class="form-group"><label class="form-label">Full Name *</label><asp:TextBox ID="txt_EditFullName"   runat="server" CssClass="form-control" /></div>
            <div class="form-group"><label class="form-label">Email *</label>    <asp:TextBox ID="txt_EditEmail"      runat="server" TextMode="Email" CssClass="form-control" /></div>
            <div class="form-group"><label class="form-label">Profession</label>  <asp:TextBox ID="txt_EditProfession" runat="server" CssClass="form-control" /></div>
            <div class="form-group">
                <label class="form-label">Role</label>
                <asp:DropDownList ID="ddl_EditRole" runat="server" CssClass="form-control">
                    <asp:ListItem Text="Member" Value="2" />
                    <asp:ListItem Text="Admin"  Value="1" />
                </asp:DropDownList>
            </div>
            <div class="form-group">
                <label class="form-label">Account Status</label>
                <asp:DropDownList ID="ddl_EditStatus" runat="server" CssClass="form-control">
                    <asp:ListItem Text="Active"   Value="Active" />
                    <asp:ListItem Text="Inactive" Value="Inactive" />
                </asp:DropDownList>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline" onclick="closeModal('editModal')">Cancel</button>
                <asp:Button ID="btn_UpdateUser" runat="server" Text="Update User" CssClass="btn btn-primary" OnClick="btn_UpdateUser_Click" />
            </div>
        </div>
    </div>

    <asp:HiddenField ID="hf_ShowEdit" runat="server" Value="0" />

<script>
    function openModal(id)  { document.getElementById(id).classList.add('open'); }
    function closeModal(id) { document.getElementById(id).classList.remove('open'); }
    window.onload = function () {
        if (document.getElementById('<%= hf_ShowEdit.ClientID %>').value === '1')
            openModal('editModal');
        document.querySelectorAll('.modal-overlay').forEach(function (m) {
            m.addEventListener('click', function (e) { if (e.target === m) m.classList.remove('open'); });
        });
    };
</script>
</asp:Content>
