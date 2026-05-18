<%@ Page Title="ManageQuiz" Language="C#" MasterPageFile="~/Master/after_landing.Master" AutoEventWireup="true" 
    CodeBehind="ManageQuiz.aspx.cs" Inherits="GrowWealth.Pages.Admin.ManageQuiz" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="manage-quiz">
        <h1 class="page-title">Manage Quiz</h1>
        <p class="page-subtitle">Select A Course and Module to Manage Quiz Questions!</p>

        <div class="select-card">
            <h3>Step 1 - Select A Course and Module</h3>
            <div class="select-row">

                <asp:DropDownList ID="CourseList" runat="server" AutoPostBack="true"
                    OnSelectedIndexChanged="Course_SelectedIndexChanged">
                    <asp:ListItem Value="">Select A Course: </asp:ListItem>
                    <asp:ListItem Value="1">Budgeting Basics</asp:ListItem>
                    <asp:ListItem Value="2">Investment 101</asp:ListItem>
                    <asp:ListItem Value="3">Portofolio Strategy</asp:ListItem>
                </asp:DropDownList>

                <asp:DropDownList ID="ModuleList" runat="server">
                    <asp:ListItem Value="">Select A Module: </asp:ListItem>
                </asp:DropDownList>

                <asp:Button ID="loadButton" runat="server" Text="Load Quiz"
                    CssClass="colored-button" OnClick="loadButtonClick"/>

            </div>
        </div>
        <asp:Panel ID="QuizHeader" runat="server" Visible="false">
            <div class="quiz-header">
                <div>
                    <asp:Label ID="quizTitle" runat="server" Text="">
                    </asp:Label>

                    <asp:Label ID="quizData" runat="server" Text="">
                    </asp:Label>
                </div>
                <div>
                    <asp:Button ID="addQuestion" runat="server" Text="Add Question"
                        CssClass="colored-button" OnClick="addQuestionClick"/>
                    <asp:Button ID="editPassingMark" runat="server" Text="Edit Passing Mark"
                        CssClass="edit-button" OnClick="editPassingMarksClick"/> 
                </div>
            </div>
        </asp:Panel>
        <asp:Panel ID="EditPassMarks" runat="server" Visible="false">
            <div class="edit-passmarks">
                <h3>Edit Passing Marks</h3>

                <label>Passing Marks(%): </label>
                <asp:TextBox ID="passMarks" runat="server"
                    CssClass="question-box" />
                
                <div style="margin-top: 1rem; display: flex; gap:10px; ">
                    <asp:Button ID="SavePassMarks" runat="server"
                        Text="Save" OnClick="savePassingMarksClick" CssClass="save-button" />
                    <asp:Button ID="CancelPassMarks" runat="server"
                        Text="Cancel" OnClick="cancelPassingMarksClick" CssClass="cancel-button" />
                </div>
            </div>
        </asp:Panel>
        <asp:Repeater ID="QuestionList" runat="server" OnItemCommand="QuestionList_ItemCommand">
            <ItemTemplate>

                <div class="question-card">
                    <div class="question-header">
                        <span class="question-label">
                            Question <%# Container.ItemIndex + 1 %>
                        </span>

                        <div class="question-actions">

                            <asp:LinkButton runat="server"
                                CommandName="Edit"
                                CommandArgument='<%# Eval("QuestionID") %>'
                                CssClass="edit-button">
                                Edit
                            </asp:LinkButton>

                            <asp:LinkButton runat="server"
                                CommandName="Delete"
                                CommandArgument='<%# Eval("QuestionID") %>'
                                CssClass="delete-button"
                                OnClientClick="return confirm('Are you sure?');">
                                Delete
                            </asp:LinkButton>
                        </div>
                    </div>
                    <p class="question-text">
                        <%# Eval("QuestionText") %>
                    </p>
                    <div class="question-options">
                        <span class="<%# Eval("CorrectAnswer").ToString() == "A" ? "option correct" : "option" %>">
                            A: <%# Eval("OptionA") %>
                        </span>

                        <span class="<%# Eval("CorrectAnswer").ToString() == "B" ? "option correct" : "option" %>">
                            B: <%# Eval("OptionB") %>
                        </span>

                        <span class="<%# Eval("CorrectAnswer").ToString() == "C" ? "option correct" : "option" %>">
                            C: <%# Eval("OptionC") %>
                        </span>

                        <span class="<%# Eval("CorrectAnswer").ToString() == "D" ? "option correct" : "option" %>">
                            D: <%# Eval("OptionD") %>
                        </span>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
        <asp:Panel ID="AddQuestions" runat="server" Visible="false">
            <div class="add-question">

                <h3>
                    <asp:Label ID="questionTitle" runat="server" Text="Add New Question" />
                </h3>

                <label>Question Text</label>
                <asp:TextBox ID="questionText" runat="server"
                    CssClass="question-box"
                    placeholder="Enter Question: " />

                <label>Option A</label>
                <asp:TextBox ID="TextOptionA" runat="server"
                    CssClass="question-box"
                    placeholder="Option A" />

                <label>Option B</label>
                <asp:TextBox ID="TextOptionB" runat="server"
                    CssClass="question-box"
                    placeholder="Option B" />

                <label>Option C</label>
                <asp:TextBox ID="TextOptionC" runat="server"
                    CssClass="question-box"
                    placeholder="Option C" />

                <label>Option D</label>
                <asp:TextBox ID="TextOptionD" runat="server"
                    CssClass="question-box"
                    placeholder="Option D" />

                <label>Correct Answer</label>
                <asp:DropDownList ID="CorrectAnswerList" runat="server"
                    CssClass="question-box">
                    <asp:ListItem Value="A">A</asp:ListItem>
                    <asp:ListItem Value="B">B</asp:ListItem>
                    <asp:ListItem Value="C">C</asp:ListItem>
                    <asp:ListItem Value="D">D</asp:ListItem>
                </asp:DropDownList>

                <div style="margin-top: 1rem; display: flex; gap: 10px;">
                    <asp:Button ID="saveQuestion" runat="server"
                        Text="Save Changes"
                        CssClass="save-button"
                        OnClick="saveButtonClick" />

                    <asp:Button ID="cancelQuestion" runat="server"
                        Text="Cancel"
                        CssClass="cancel-button"
                        OnClick="cancelButtonClick" />
                </div>

            </div>
        </asp:Panel>
    </div>
</asp:Content>
