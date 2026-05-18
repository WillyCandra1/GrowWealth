<%@ Page Title="Manage Courses" Language="C#" MasterPageFile="~/Master/Admin.Master" AutoEventWireup="true" CodeBehind="ManageCourse.aspx.cs" Inherits="GrowWealth.Pages.Admin.ManageCourse" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
<style>
    .page-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 1.5rem; }
    .page-header h1 { font-size: 1.5rem; margin: 0; }

    .stat-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(140px, 1fr)); gap: 1rem; margin-bottom: 1.5rem; }
    .stat-card { background: var(--surface); border: 1px solid var(--border); border-radius: 8px; padding: 1rem 1.25rem; }
    .stat-card .s-label { font-size: 0.75rem; color: var(--text-secondary); margin-bottom: 0.4rem; }
    .stat-card .s-value { font-size: 1.75rem; font-weight: 600; color: var(--primary); }

    .toolbar { display: flex; gap: 0.75rem; margin-bottom: 1rem; flex-wrap: wrap; }
    .toolbar .form-control { flex: 1; min-width: 160px; margin: 0; }

    .table-wrap { background: var(--surface); border: 1px solid var(--border); border-radius: 8px; overflow: hidden; }
    .admin-table { width: 100%; border-collapse: collapse; font-size: 0.875rem; }
    .admin-table thead { background: var(--bg); }
    .admin-table th { text-align: left; padding: 0.75rem 1rem; font-size: 0.75rem; font-weight: 600; color: var(--text-secondary); border-bottom: 1px solid var(--border); }
    .admin-table td { padding: 0.75rem 1rem; border-bottom: 1px solid var(--border); vertical-align: middle; }
    .admin-table tr:last-child td { border-bottom: none; }
    .admin-table tr:hover td { background: var(--bg); }

    .sbadge { display: inline-block; padding: 0.2rem 0.6rem; border-radius: 4px; font-size: 0.75rem; font-weight: 500; }
    .sbadge-published { background: #dcfce7; color: #15803d; }
    .sbadge-draft     { background: #fef9c3; color: #854d0e; }
    .sbadge-archived  { background: #f1f1f1; color: #555; }

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
        <h1 id="lbl_ManageCourses">Manage Courses</h1>
        <button type="button" class="btn btn-primary" onclick="openModal('addModal')" id="btn_AddCourse">+ Add Course</button>
    </div>

    <asp:Label ID="lbl_Message" runat="server" Visible="false" />

    <div class="stat-grid">
        <div class="stat-card">
            <div class="s-label">Total</div>
            <div class="s-value"><asp:Label ID="lbl_TotalCount" runat="server" Text="0" /></div>
        </div>
        <div class="stat-card">
            <div class="s-label">Published</div>
            <div class="s-value"><asp:Label ID="lbl_PublishedCount" runat="server" Text="0" /></div>
        </div>
        <div class="stat-card">
            <div class="s-label">Draft</div>
            <div class="s-value"><asp:Label ID="lbl_DraftCount" runat="server" Text="0" /></div>
        </div>
        <div class="stat-card">
            <div class="s-label">Archived</div>
            <div class="s-value"><asp:Label ID="lbl_ArchivedCount" runat="server" Text="0" /></div>
        </div>
    </div>

    <div class="toolbar">
        <asp:TextBox ID="txt_Search" runat="server" CssClass="form-control" placeholder="Search courses..." />
        <asp:DropDownList ID="ddl_StatusFilter" runat="server" CssClass="form-control" style="flex:0 0 auto;width:auto;">
            <asp:ListItem Text="All Status" Value="" />
            <asp:ListItem Text="Published"  Value="Published" />
            <asp:ListItem Text="Draft"      Value="Draft" />
            <asp:ListItem Text="Archived"   Value="Archived" />
        </asp:DropDownList>
        <asp:Button ID="btn_Search" runat="server" Text="Search" CssClass="btn btn-outline" OnClick="btn_Search_Click" />
    </div>

    <div class="table-wrap">
        <asp:GridView ID="gv_Courses" runat="server" AutoGenerateColumns="false"
            DataKeyNames="CourseID" OnRowCommand="gv_Courses_RowCommand"
            CssClass="admin-table" GridLines="None" Width="100%">
            <Columns>
                <asp:BoundField DataField="CourseID"        HeaderText="ID" />
                <asp:BoundField DataField="Title"           HeaderText="Course Title" />
                <asp:BoundField DataField="DifficultyLevel" HeaderText="Difficulty" />
                <asp:BoundField DataField="EnrollCount"     HeaderText="Enrolled" />
                <asp:TemplateField HeaderText="Status">
                    <ItemTemplate>
                        <span class="sbadge sbadge-<%# Eval("Status").ToString().ToLower() %>"><%# Eval("Status") %></span>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="CreatedAt" HeaderText="Created" DataFormatString="{0:dd MMM yyyy}" />
                <asp:TemplateField HeaderText="Actions">
                    <ItemTemplate>
                        <div class="action-cell">
                            <asp:LinkButton runat="server" CommandName="EditCourse"
                                CommandArgument='<%# Eval("CourseID") %>'
                                CssClass="btn-sm">Edit</asp:LinkButton>
                            <asp:LinkButton runat="server" CommandName="DeleteCourse"
                                CommandArgument='<%# Eval("CourseID") %>'
                                CssClass="btn-sm btn-sm-danger"
                                OnClientClick="return confirm('Delete this course?');">Delete</asp:LinkButton>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <EmptyDataTemplate><div class="empty-row">No courses found.</div></EmptyDataTemplate>
        </asp:GridView>
    </div>

    <%-- Add Course Modal --%>
    <div class="modal-overlay" id="addModal">
        <div class="modal-panel">
            <h2>Add New Course</h2>
            <div class="form-group">
                <label class="form-label">Title *</label>
                <asp:TextBox ID="txt_Title" runat="server" CssClass="form-control" placeholder="e.g. Introduction to Investing" />
            </div>
            <div class="form-group">
                <label class="form-label">Description</label>
                <asp:TextBox ID="txt_Description" runat="server" TextMode="MultiLine" CssClass="form-control" style="min-height:80px;resize:vertical;" />
            </div>
            <div class="form-group">
                <label class="form-label">Difficulty Level</label>
                <asp:DropDownList ID="ddl_Difficulty" runat="server" CssClass="form-control">
                    <asp:ListItem Text="Beginner"     Value="Beginner" />
                    <asp:ListItem Text="Intermediate" Value="Intermediate" />
                    <asp:ListItem Text="Advanced"     Value="Advanced" />
                </asp:DropDownList>
            </div>
            <div class="form-group">
                <label class="form-label">Thumbnail URL</label>
                <asp:TextBox ID="txt_Thumbnail" runat="server" CssClass="form-control" placeholder="https://..." />
            </div>
            <div class="form-group">
                <label class="form-label">Status</label>
                <asp:DropDownList ID="ddl_Status" runat="server" CssClass="form-control">
                    <asp:ListItem Text="Draft"     Value="Draft" />
                    <asp:ListItem Text="Published" Value="Published" />
                    <asp:ListItem Text="Archived"  Value="Archived" />
                </asp:DropDownList>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline" onclick="closeModal('addModal')">Cancel</button>
                <asp:Button ID="btn_AddCourseSubmit" runat="server" Text="Save Course" CssClass="btn btn-primary" OnClick="btn_AddCourse_Click" />
            </div>
        </div>
    </div>

    <%-- Edit Course Modal --%>
    <div class="modal-overlay" id="editModal">
        <div class="modal-panel">
            <h2>Edit Course</h2>
            <asp:HiddenField ID="hf_EditCourseID" runat="server" />
            <div class="form-group">
                <label class="form-label">Title *</label>
                <asp:TextBox ID="txt_EditTitle" runat="server" CssClass="form-control" />
            </div>
            <div class="form-group">
                <label class="form-label">Description</label>
                <asp:TextBox ID="txt_EditDescription" runat="server" TextMode="MultiLine" CssClass="form-control" style="min-height:80px;resize:vertical;" />
            </div>
            <div class="form-group">
                <label class="form-label">Difficulty Level</label>
                <asp:DropDownList ID="ddl_EditDifficulty" runat="server" CssClass="form-control">
                    <asp:ListItem Text="Beginner"     Value="Beginner" />
                    <asp:ListItem Text="Intermediate" Value="Intermediate" />
                    <asp:ListItem Text="Advanced"     Value="Advanced" />
                </asp:DropDownList>
            </div>
            <div class="form-group">
                <label class="form-label">Thumbnail URL</label>
                <asp:TextBox ID="txt_EditThumbnail" runat="server" CssClass="form-control" />
            </div>
            <div class="form-group">
                <label class="form-label">Status</label>
                <asp:DropDownList ID="ddl_EditStatus" runat="server" CssClass="form-control">
                    <asp:ListItem Text="Draft"     Value="Draft" />
                    <asp:ListItem Text="Published" Value="Published" />
                    <asp:ListItem Text="Archived"  Value="Archived" />
                </asp:DropDownList>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline" onclick="closeModal('editModal')">Cancel</button>
                <asp:Button ID="btn_UpdateCourse" runat="server" Text="Update Course" CssClass="btn btn-primary" OnClick="btn_UpdateCourse_Click" />
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
