<%@ Page Title="Manage Quizzes" Language="C#" MasterPageFile="~/Master/Admin.Master" AutoEventWireup="true" CodeBehind="ManageQuiz.aspx.cs" Inherits="GrowWealth.Pages.Admin.ManageQuiz" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .page-head { margin-bottom: 1.75rem; }
        .page-head h1 { font-size: 2.2rem; margin-bottom: 0.3rem; }
        .page-head p { color: var(--gw-ink-muted); margin: 0; }

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
        .panel-subtitle { color: var(--gw-ink-muted); font-size: 0.9rem; margin-bottom: 1.5rem; }

        .selector-row {
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
        textarea.form-input-block { min-height: 80px; resize: vertical; font-family: var(--gw-sans); }

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

        .quiz-meta-row {
            display: flex;
            gap: 2rem;
            padding: 1.1rem 1.4rem;
            background-color: var(--gw-paper);
            border-radius: 10px;
            margin-bottom: 1.5rem;
            font-size: 0.9rem;
        }
        .quiz-meta-row strong {
            font-family: var(--gw-serif);
            color: var(--gw-ink);
            display: block;
            font-size: 1.05rem;
        }
        .quiz-meta-row span { color: var(--gw-ink-muted); }

        .pass-mark-input { width: 120px !important; }

        .question-card {
            background-color: var(--gw-paper);
            border: 1px solid var(--gw-line-soft);
            border-radius: 12px;
            padding: 1.5rem 1.75rem;
            margin-bottom: 1rem;
        }

        .question-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 1rem;
        }

        .question-num {
            font-family: var(--gw-serif);
            font-size: 1.05rem;
            font-weight: 600;
            color: var(--gw-ink);
        }

        .option-row {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            margin-bottom: 0.65rem;
        }

        .option-row input[type="radio"] {
            width: 17px;
            height: 17px;
            accent-color: var(--gw-accent);
            flex-shrink: 0;
        }

        .option-letter {
            font-family: var(--gw-serif);
            font-weight: 700;
            color: var(--gw-accent);
            min-width: 22px;
        }

        .option-input {
            flex: 1;
            padding: 0.55rem 0.85rem;
            border: 1px solid var(--gw-line);
            border-radius: 6px;
            font-size: 0.9rem;
            font-family: var(--gw-sans);
            color: var(--gw-ink);
            background-color: var(--gw-surface);
            outline: none;
        }
        .option-input:focus { border-color: var(--gw-accent); }

        .correct-label {
            font-size: 0.78rem;
            color: var(--gw-ink-muted);
            display: flex;
            align-items: center;
            gap: 0.4rem;
            margin-top: 0.75rem;
        }

        .empty-state {
            text-align: center;
            color: var(--gw-ink-muted);
            padding: 3rem 1rem;
            background-color: var(--gw-paper);
            border-radius: 10px;
            font-style: italic;
        }

        .text-danger { color: var(--gw-rose); font-size: 0.8rem; margin-top: 0.25rem; display: block; font-weight: 500; }

        .actions-row {
            display: flex;
            gap: 0.6rem;
            margin-top: 1.5rem;
            padding-top: 1.5rem;
            border-top: 1px solid var(--gw-line-soft);
            flex-wrap: wrap;
        }

        @media (max-width: 720px) {
            .selector-row { grid-template-columns: 1fr; }
            .quiz-meta-row { flex-direction: column; gap: 0.75rem; }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div class="page-head">
        <h1>Manage quizzes</h1>
        <p>Select a course and module to edit its quiz and questions.</p>
    </div>

    <asp:Panel ID="pnlSuccess" runat="server" Visible="false" CssClass="alert alert-success">
        <asp:Literal ID="litSuccess" runat="server"></asp:Literal>
    </asp:Panel>

    <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="alert alert-danger">
        <asp:Literal ID="litError" runat="server"></asp:Literal>
    </asp:Panel>

    <div class="panel">
        <h2>Choose quiz</h2>
        <p class="panel-subtitle">Pick a course then a module. The quiz loads automatically.</p>

        <div class="selector-row">
            <div class="form-group">
                <label class="form-label">Course</label>
                <asp:DropDownList ID="ddlCourse" runat="server" CssClass="form-input-block"
                    AutoPostBack="true" OnSelectedIndexChanged="ddlCourse_SelectedIndexChanged">
                </asp:DropDownList>
            </div>

            <div class="form-group">
                <label class="form-label">Module</label>
                <asp:DropDownList ID="ddlModule" runat="server" CssClass="form-input-block"
                    AutoPostBack="true" OnSelectedIndexChanged="ddlModule_SelectedIndexChanged">
                </asp:DropDownList>
            </div>
        </div>
    </div>

    <asp:Panel ID="pnlQuiz" runat="server" Visible="false">

        <div class="panel">
            <h2><asp:Literal ID="litQuizTitle" runat="server"></asp:Literal></h2>
            <p class="panel-subtitle">Edit the quiz settings and its questions below.</p>

            <div class="quiz-meta-row">
                <span>
                    <strong><asp:Literal ID="litQuestionCount" runat="server"></asp:Literal></strong>
                    Questions
                </span>
                <span>
                    <strong><asp:Literal ID="litAttemptCount" runat="server"></asp:Literal></strong>
                    Attempts so far
                </span>
                <div style="margin-left: auto; display: flex; gap: 0.6rem; align-items: end;">
                    <div>
                        <label class="form-label">Pass mark</label>
                        <asp:TextBox ID="txtPassMark" runat="server" CssClass="form-input-block pass-mark-input" Text="60"></asp:TextBox>
                        <asp:RangeValidator runat="server" ControlToValidate="txtPassMark" Type="Integer"
                            MinimumValue="1" MaximumValue="100"
                            ErrorMessage="Enter a value between 1 and 100"
                            CssClass="text-danger" Display="Dynamic" ValidationGroup="QuizMeta"></asp:RangeValidator>
                    </div>
                    <asp:Button ID="btnSavePassMark" runat="server" Text="Update pass mark"
                        CssClass="btn-primary" OnClick="btnSavePassMark_Click" ValidationGroup="QuizMeta" />
                </div>
            </div>

            <asp:Panel ID="pnlQuestions" runat="server">
                <asp:Repeater ID="rptQuestions" runat="server" OnItemCommand="rptQuestions_ItemCommand">
                    <ItemTemplate>
                        <div class="question-card">
                            <div class="question-header">
                                <div class="question-num">Question <%# Container.ItemIndex + 1 %></div>
                                <asp:LinkButton runat="server" CssClass="btn-icon danger"
                                    CommandName="DeleteQuestion"
                                    CommandArgument='<%# Eval("QuestionID") %>'
                                    OnClientClick="return confirm('Delete this question? This cannot be undone.');">Delete</asp:LinkButton>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Question</label>
                                <asp:TextBox runat="server" ID="qtText"
                                    CssClass="form-input-block"
                                    Text='<%# Eval("QuestionText") %>'
                                    data-qid='<%# Eval("QuestionID") %>' TextMode="MultiLine"></asp:TextBox>
                            </div>

                            <div class="option-row">
                                <asp:RadioButton runat="server" ID="rbOptA" GroupName='<%# "correct_" + Eval("QuestionID") %>'
                                    Checked='<%# Eval("CorrectOption").ToString() == "A" %>' />
                                <span class="option-letter">A.</span>
                                <asp:TextBox runat="server" ID="qtA" CssClass="option-input"
                                    Text='<%# Eval("OptionA") %>'></asp:TextBox>
                            </div>
                            <div class="option-row">
                                <asp:RadioButton runat="server" ID="rbOptB" GroupName='<%# "correct_" + Eval("QuestionID") %>'
                                    Checked='<%# Eval("CorrectOption").ToString() == "B" %>' />
                                <span class="option-letter">B.</span>
                                <asp:TextBox runat="server" ID="qtB" CssClass="option-input"
                                    Text='<%# Eval("OptionB") %>'></asp:TextBox>
                            </div>
                            <div class="option-row">
                                <asp:RadioButton runat="server" ID="rbOptC" GroupName='<%# "correct_" + Eval("QuestionID") %>'
                                    Checked='<%# Eval("CorrectOption").ToString() == "C" %>' />
                                <span class="option-letter">C.</span>
                                <asp:TextBox runat="server" ID="qtC" CssClass="option-input"
                                    Text='<%# Eval("OptionC") %>'></asp:TextBox>
                            </div>
                            <div class="option-row">
                                <asp:RadioButton runat="server" ID="rbOptD" GroupName='<%# "correct_" + Eval("QuestionID") %>'
                                    Checked='<%# Eval("CorrectOption").ToString() == "D" %>' />
                                <span class="option-letter">D.</span>
                                <asp:TextBox runat="server" ID="qtD" CssClass="option-input"
                                    Text='<%# Eval("OptionD") %>'></asp:TextBox>
                            </div>

                            <div class="correct-label">
                                Select the radio button next to the correct answer.
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </asp:Panel>

            <asp:Panel ID="pnlEmpty" runat="server" Visible="false">
                <div class="empty-state">No questions yet. Click <strong>Add question</strong> below to get started.</div>
            </asp:Panel>

            <div class="actions-row">
                <asp:Button ID="btnSaveAll" runat="server" Text="Save all changes"
                    CssClass="btn-primary" OnClick="btnSaveAll_Click" CausesValidation="false" />
                <asp:Button ID="btnAddQuestion" runat="server" Text="+ Add question"
                    CssClass="btn-secondary" OnClick="btnAddQuestion_Click" CausesValidation="false" />
            </div>
        </div>

    </asp:Panel>

</asp:Content>
