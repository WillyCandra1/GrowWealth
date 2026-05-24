<%@ Page Title="Manage Courses" Language="C#" MasterPageFile="~/Master/Admin.Master" AutoEventWireup="true" CodeBehind="ManageCourse.aspx.cs" Inherits="GrowWealth.Pages.Admin.ManageCourse" ValidateRequest="false" %>

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
        .page-head h1 { font-size: 2.2rem; margin-bottom: 0.3rem; }
        .page-head p { color: var(--gw-ink-muted); margin: 0; }

        .btn-primary {
            background-color: var(--gw-ink);
            color: var(--gw-paper);
            border: 1px solid var(--gw-ink);
            padding: 0.65rem 1.3rem;
            border-radius: 8px;
            font-family: var(--gw-sans);
            font-size: 0.9rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.18s;
        }
        .btn-primary:hover { background-color: var(--gw-accent-dark); border-color: var(--gw-accent-dark); }

        .btn-secondary {
            background-color: transparent;
            color: var(--gw-ink);
            border: 1px solid var(--gw-line);
            padding: 0.65rem 1.3rem;
            border-radius: 8px;
            font-family: var(--gw-sans);
            font-size: 0.9rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.18s;
        }
        .btn-secondary:hover { border-color: var(--gw-ink); }

        .alert {
            padding: 0.85rem 1.1rem;
            border-radius: 8px;
            margin-bottom: 1.25rem;
            font-size: 0.92rem;
            border: 1px solid;
        }
        .alert-success { background-color: var(--gw-accent-soft); color: var(--gw-accent-dark); border-color: #c0dccc; }
        .alert-danger { background-color: var(--gw-rose-soft); color: var(--gw-rose); border-color: #e8c4be; }

        .panel {
            background-color: var(--gw-surface);
            border: 1px solid var(--gw-line);
            border-radius: 14px;
            padding: 1.75rem 2rem;
            margin-bottom: 1.5rem;
        }
        .panel h2 { font-size: 1.25rem; margin-bottom: 0.3rem; }
        .panel .panel-subtitle { color: var(--gw-ink-muted); font-size: 0.9rem; margin-bottom: 1.5rem; }

        .data-table { width: 100%; border-collapse: collapse; }
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
            vertical-align: middle;
        }
        .data-table tr:last-child td { border-bottom: none; }
        .data-table tr:hover td { background-color: var(--gw-paper); }

        .pill {
            display: inline-block;
            padding: 0.22rem 0.7rem;
            border-radius: 999px;
            font-size: 0.72rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.06em;
        }
        .pill.beginner { background-color: var(--gw-accent-soft); color: var(--gw-accent); }
        .pill.intermediate { background-color: var(--gw-gold-soft); color: var(--gw-gold); }
        .pill.advanced { background-color: var(--gw-rose-soft); color: var(--gw-rose); }
        .pill.active { background-color: var(--gw-accent-soft); color: var(--gw-accent); }
        .pill.inactive { background-color: var(--gw-line-soft); color: var(--gw-ink-muted); }

        .row-actions { display: flex; gap: 0.4rem; justify-content: flex-end; }
        .btn-icon {
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
        .btn-icon:hover { background-color: var(--gw-ink); color: var(--gw-paper); border-color: var(--gw-ink); }
        .btn-icon.danger:hover { background-color: var(--gw-rose); border-color: var(--gw-rose); color: white; }

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
            box-sizing: border-box;
        }
        .form-input-block:focus { border-color: var(--gw-accent); box-shadow: 0 0 0 3px var(--gw-accent-soft); }
        textarea.form-input-block { min-height: 90px; resize: vertical; font-family: var(--gw-sans); }
        textarea.module-content { min-height: 200px; font-family: 'Courier New', monospace; font-size: 0.85rem; }

        .checkbox-row { display: flex; align-items: center; gap: 0.5rem; font-size: 0.92rem; }
        .checkbox-row input { width: 17px; height: 17px; accent-color: var(--gw-accent); }

        .actions-row {
            display: flex;
            gap: 0.6rem;
            margin-top: 1.5rem;
            padding-top: 1.5rem;
            border-top: 1px solid var(--gw-line-soft);
        }

        .text-danger { color: var(--gw-rose); font-size: 0.8rem; margin-top: 0.25rem; display: block; font-weight: 500; }

        .module-block {
            background-color: var(--gw-paper);
            border: 1px solid var(--gw-line-soft);
            border-radius: 10px;
            padding: 1rem 1.25rem;
            margin-bottom: 0.65rem;
            display: flex;
            align-items: center;
            gap: 1rem;
        }
        .module-block .module-num {
            width: 28px;
            height: 28px;
            background-color: var(--gw-ink);
            color: var(--gw-paper);
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-family: var(--gw-serif);
            font-weight: 700;
            font-size: 0.85rem;
            flex-shrink: 0;
        }
        .module-block .module-info { flex: 1; }
        .module-block .module-info strong { color: var(--gw-ink); }
        .module-block .module-meta { color: var(--gw-ink-muted); font-size: 0.82rem; }

        .empty-row td {
            text-align: center;
            color: var(--gw-ink-muted);
            font-style: italic;
            padding: 2rem 0;
        }

        @media (max-width: 720px) {
            .form-grid { grid-template-columns: 1fr; }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div class="page-head">
        <div>
            <h1>Manage courses</h1>
            <p>Create, edit, and organise courses and their modules.</p>
        </div>
        <asp:Button ID="btnNewCourse" runat="server" Text="+ New course"
            CssClass="btn-primary" OnClick="btnNewCourse_Click" CausesValidation="false" />
    </div>

    <asp:Panel ID="pnlSuccess" runat="server" Visible="false" CssClass="alert alert-success">
        <asp:Literal ID="litSuccess" runat="server"></asp:Literal>
    </asp:Panel>

    <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="alert alert-danger">
        <asp:Literal ID="litError" runat="server"></asp:Literal>
    </asp:Panel>

    <asp:Panel ID="pnlCourseForm" runat="server" Visible="false" CssClass="panel">
        <h2><asp:Literal ID="litCourseFormHeader" runat="server">New course</asp:Literal></h2>
        <p class="panel-subtitle">Provide the title, description, and difficulty for this course.</p>

        <div class="form-grid">
            <div class="form-group">
                <label class="form-label">Title</label>
                <asp:TextBox ID="txtTitle" runat="server" CssClass="form-input-block"></asp:TextBox>
                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtTitle"
                    ErrorMessage="Title is required" CssClass="text-danger" Display="Dynamic"
                    ValidationGroup="Course"></asp:RequiredFieldValidator>
            </div>

            <div class="form-group">
                <label class="form-label">Difficulty</label>
                <asp:DropDownList ID="ddlDifficulty" runat="server" CssClass="form-input-block">
                    <asp:ListItem Value="Beginner" Text="Beginner" Selected="True"></asp:ListItem>
                    <asp:ListItem Value="Intermediate" Text="Intermediate"></asp:ListItem>
                    <asp:ListItem Value="Advanced" Text="Advanced"></asp:ListItem>
                </asp:DropDownList>
            </div>
        </div>

        <div class="form-group">
            <label class="form-label">Description</label>
            <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine"
                CssClass="form-input-block"></asp:TextBox>
            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtDescription"
                ErrorMessage="Description is required" CssClass="text-danger" Display="Dynamic"
                ValidationGroup="Course"></asp:RequiredFieldValidator>
        </div>

        <div class="form-grid">
            <div class="form-group">
                <label class="form-label">Estimated total hours</label>
                <asp:TextBox ID="txtHours" runat="server" CssClass="form-input-block" Text="6"></asp:TextBox>
                <asp:RangeValidator runat="server" ControlToValidate="txtHours" Type="Integer"
                    MinimumValue="1" MaximumValue="200"
                    ErrorMessage="Enter a number between 1 and 200"
                    CssClass="text-danger" Display="Dynamic" ValidationGroup="Course"></asp:RangeValidator>
            </div>

            <div class="form-group">
                <label class="form-label">Status</label>
                <div class="checkbox-row" style="margin-top: 0.7rem;">
                    <asp:CheckBox ID="chkActive" runat="server" Checked="true"
                        Text="Course is published and visible to members" />
                </div>
            </div>
        </div>

        <div class="actions-row">
            <asp:Button ID="btnSaveCourse" runat="server" Text="Save course"
                CssClass="btn-primary" OnClick="btnSaveCourse_Click" ValidationGroup="Course" />
            <asp:Button ID="btnCancelCourse" runat="server" Text="Cancel"
                CssClass="btn-secondary" OnClick="btnCancelCourse_Click" CausesValidation="false" />
        </div>
    </asp:Panel>

    <asp:Panel ID="pnlModuleForm" runat="server" Visible="false" CssClass="panel">
        <h2><asp:Literal ID="litModuleFormHeader" runat="server">New module</asp:Literal></h2>
        <p class="panel-subtitle">Adding to <strong><asp:Literal ID="litModuleCourseName" runat="server"></asp:Literal></strong>.</p>

        <div class="form-grid">
            <div class="form-group">
                <label class="form-label">Module title</label>
                <asp:TextBox ID="txtModuleTitle" runat="server" CssClass="form-input-block"></asp:TextBox>
                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtModuleTitle"
                    ErrorMessage="Title is required" CssClass="text-danger" Display="Dynamic"
                    ValidationGroup="Module"></asp:RequiredFieldValidator>
            </div>

            <div class="form-group">
                <label class="form-label">Reading time (minutes)</label>
                <asp:TextBox ID="txtModuleMinutes" runat="server" CssClass="form-input-block" Text="15"></asp:TextBox>
                <asp:RangeValidator runat="server" ControlToValidate="txtModuleMinutes" Type="Integer"
                    MinimumValue="1" MaximumValue="180"
                    ErrorMessage="Enter a number between 1 and 180"
                    CssClass="text-danger" Display="Dynamic" ValidationGroup="Module"></asp:RangeValidator>
            </div>
        </div>

        <div class="form-group">
            <label class="form-label">Order index</label>
            <asp:TextBox ID="txtModuleOrder" runat="server" CssClass="form-input-block" Text="1"></asp:TextBox>
            <asp:RangeValidator runat="server" ControlToValidate="txtModuleOrder" Type="Integer"
                MinimumValue="1" MaximumValue="100"
                ErrorMessage="Enter a number between 1 and 100"
                CssClass="text-danger" Display="Dynamic" ValidationGroup="Module"></asp:RangeValidator>
        </div>

        <div class="form-group">
            <label class="form-label">Module content (HTML allowed)</label>
            <asp:TextBox ID="txtModuleContent" runat="server" TextMode="MultiLine"
                CssClass="form-input-block module-content"></asp:TextBox>
            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtModuleContent"
                ErrorMessage="Content is required" CssClass="text-danger" Display="Dynamic"
                ValidationGroup="Module"></asp:RequiredFieldValidator>
        </div>

        <div class="actions-row">
            <asp:Button ID="btnSaveModule" runat="server" Text="Save module"
                CssClass="btn-primary" OnClick="btnSaveModule_Click" ValidationGroup="Module" />
            <asp:Button ID="btnCancelModule" runat="server" Text="Cancel"
                CssClass="btn-secondary" OnClick="btnCancelModule_Click" CausesValidation="false" />
        </div>
    </asp:Panel>

    <div class="panel">
        <h2>All courses</h2>
        <p class="panel-subtitle">Click a course to expand its modules.</p>

        <table class="data-table">
            <thead>
                <tr>
                    <th>Title</th>
                    <th>Level</th>
                    <th>Modules</th>
                    <th>Enrolments</th>
                    <th>Status</th>
                    <th style="text-align:right;">Actions</th>
                </tr>
            </thead>
            <tbody>
                <asp:Repeater ID="rptCourses" runat="server" OnItemCommand="rptCourses_ItemCommand">
                    <ItemTemplate>
                        <tr>
                            <td><strong><%# Eval("Title") %></strong></td>
                            <td><span class='<%# "pill " + Eval("Difficulty").ToString().ToLower() %>'><%# Eval("Difficulty") %></span></td>
                            <td><%# Eval("ModuleCount") %></td>
                            <td><%# Eval("EnrolCount") %></td>
                            <td><span class='<%# "pill " + (Convert.ToBoolean(Eval("IsActive")) ? "active" : "inactive") %>'><%# Convert.ToBoolean(Eval("IsActive")) ? "Active" : "Inactive" %></span></td>
                            <td>
                                <div class="row-actions">
                                    <asp:LinkButton runat="server" CssClass="btn-icon"
                                        CommandName="ViewModules" CommandArgument='<%# Eval("CourseID") %>'>Modules</asp:LinkButton>
                                    <asp:LinkButton runat="server" CssClass="btn-icon"
                                        CommandName="EditCourse" CommandArgument='<%# Eval("CourseID") %>'>Edit</asp:LinkButton>
                                    <asp:LinkButton runat="server" CssClass="btn-icon danger"
                                        CommandName="DeleteCourse" CommandArgument='<%# Eval("CourseID") %>'
                                        OnClientClick="return confirm('Delete this course and all its modules, quizzes, and enrolments? This cannot be undone.');">Delete</asp:LinkButton>
                                </div>
                            </td>
                        </tr>
                    </ItemTemplate>
                </asp:Repeater>
            </tbody>
        </table>
    </div>

    <asp:Panel ID="pnlModuleList" runat="server" Visible="false" CssClass="panel">
        <div style="display:flex; justify-content:space-between; align-items:flex-end; margin-bottom: 0.3rem;">
            <h2>Modules in <asp:Literal ID="litExpandedCourse" runat="server"></asp:Literal></h2>
            <asp:Button ID="btnNewModule" runat="server" Text="+ Add module"
                CssClass="btn-primary" OnClick="btnNewModule_Click" CausesValidation="false" />
        </div>
        <p class="panel-subtitle">Modules are shown in their order index.</p>

        <asp:Repeater ID="rptModulesInCourse" runat="server" OnItemCommand="rptModulesInCourse_ItemCommand">
            <ItemTemplate>
                <div class="module-block">
                    <span class="module-num"><%# Eval("OrderIndex") %></span>
                    <div class="module-info">
                        <strong><%# Eval("Title") %></strong>
                        <div class="module-meta"><%# Eval("EstimatedMinutes") %> min read</div>
                    </div>
                    <div class="row-actions">
                        <asp:LinkButton runat="server" CssClass="btn-icon"
                            CommandName="EditModule" CommandArgument='<%# Eval("ModuleID") %>'>Edit</asp:LinkButton>
                        <asp:LinkButton runat="server" CssClass="btn-icon danger"
                            CommandName="DeleteModule" CommandArgument='<%# Eval("ModuleID") %>'
                            OnClientClick="return confirm('Delete this module, its quiz, and all related progress?');">Delete</asp:LinkButton>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </asp:Panel>

</asp:Content>
