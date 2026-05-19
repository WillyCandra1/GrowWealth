<%@ Page Title="Quiz" Language="C#" MasterPageFile="~/Master/after_landing.Master" AutoEventWireup="true" CodeBehind="Quiz.aspx.cs" Inherits="GrowWealth.Pages.Member.Quiz" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .quiz-shell {
            max-width: 760px;
            margin: 0 auto;
        }

        .quiz-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .quiz-header h1 {
            font-size: 2rem;
            margin-bottom: 0.3rem;
        }

        .quiz-header p {
            color: var(--gw-ink-muted);
            margin: 0;
        }

        .quiz-progress {
            background-color: var(--gw-surface);
            border: 1px solid var(--gw-line);
            border-radius: 14px;
            padding: 1rem 1.5rem;
            margin-bottom: 1.5rem;
        }

        .quiz-progress-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 0.5rem;
            font-size: 0.85rem;
            color: var(--gw-ink-muted);
        }

        .quiz-progress-row strong {
            color: var(--gw-ink);
            font-family: var(--gw-serif);
        }

        .quiz-progress-track {
            height: 6px;
            background-color: var(--gw-line-soft);
            border-radius: 999px;
            overflow: hidden;
        }

        .quiz-progress-fill {
            height: 100%;
            background: linear-gradient(90deg, var(--gw-accent) 0%, #0d8048 100%);
            border-radius: 999px;
            transition: width 0.5s ease;
        }

        .quiz-card {
            background-color: var(--gw-surface);
            border: 1px solid var(--gw-line);
            border-radius: 14px;
            padding: 2.5rem;
        }

        .question-label {
            font-size: 0.78rem;
            color: var(--gw-ink-muted);
            text-transform: uppercase;
            letter-spacing: 0.12em;
            font-weight: 600;
            margin-bottom: 0.85rem;
        }

        .question-text {
            font-family: var(--gw-serif);
            font-size: 1.5rem;
            font-weight: 600;
            color: var(--gw-ink);
            line-height: 1.35;
            margin-bottom: 2rem;
        }

        .quiz-options { list-style: none; padding: 0; margin: 0; }

        .quiz-options li { margin-bottom: 0.8rem; }

        .quiz-options label {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 1rem 1.25rem;
            border: 1px solid var(--gw-line);
            border-radius: 10px;
            cursor: pointer;
            transition: all 0.18s;
            background-color: var(--gw-surface);
            font-size: 0.97rem;
            color: var(--gw-ink);
            line-height: 1.45;
        }

        .quiz-options label:hover {
            border-color: var(--gw-accent);
            background-color: var(--gw-accent-soft);
        }

        .quiz-options input[type="radio"] {
            width: 18px;
            height: 18px;
            accent-color: var(--gw-accent);
            flex-shrink: 0;
        }

        .quiz-nav {
            display: flex;
            justify-content: space-between;
            margin-top: 2.25rem;
            padding-top: 1.5rem;
            border-top: 1px solid var(--gw-line-soft);
            gap: 0.75rem;
            flex-wrap: wrap;
        }

        .quiz-btn {
            padding: 0.75rem 1.5rem;
            border-radius: 6px;
            font-family: var(--gw-sans);
            font-size: 0.92rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.18s;
            border: 1px solid var(--gw-line);
            background-color: var(--gw-surface);
            color: var(--gw-ink);
        }

        .quiz-btn:hover:not(:disabled) { border-color: var(--gw-ink); }
        .quiz-btn:disabled { opacity: 0.4; cursor: not-allowed; }

        .quiz-btn-primary {
            background-color: var(--gw-ink);
            color: var(--gw-paper);
            border-color: var(--gw-ink);
        }

        .quiz-btn-primary:hover:not(:disabled) {
            background-color: var(--gw-accent-dark);
            border-color: var(--gw-accent-dark);
        }

        .quiz-alert {
            background-color: var(--gw-rose-soft);
            color: var(--gw-rose);
            border: 1px solid #e8c4be;
            padding: 0.85rem 1.1rem;
            border-radius: 8px;
            font-size: 0.9rem;
            margin-bottom: 1.5rem;
        }

        .result-card {
            background-color: var(--gw-surface);
            border: 1px solid var(--gw-line);
            border-radius: 16px;
            padding: 3rem 2.5rem;
            text-align: center;
        }

        .result-icon {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 1.5rem;
            font-family: var(--gw-serif);
        }

        .result-icon.pass {
            background-color: var(--gw-accent-soft);
            color: var(--gw-accent);
        }

        .result-icon.fail {
            background-color: var(--gw-rose-soft);
            color: var(--gw-rose);
        }

        .result-score {
            font-family: var(--gw-serif);
            font-size: 5rem;
            font-weight: 600;
            color: var(--gw-ink);
            line-height: 1;
            margin-bottom: 0.4rem;
            font-variant-numeric: tabular-nums;
        }

        .result-score .result-pct {
            font-size: 2rem;
            color: var(--gw-ink-muted);
            margin-left: 0.2rem;
        }

        .result-title {
            font-size: 1.6rem;
            margin-bottom: 0.65rem;
        }

        .result-detail {
            color: var(--gw-ink-muted);
            font-size: 1rem;
            margin-bottom: 2rem;
        }

        .result-stats {
            display: flex;
            justify-content: center;
            gap: 2.5rem;
            margin: 2rem 0;
            padding: 1.5rem 0;
            border-top: 1px solid var(--gw-line-soft);
            border-bottom: 1px solid var(--gw-line-soft);
        }

        .result-stat-block {
            text-align: center;
        }

        .result-stat-block strong {
            display: block;
            font-family: var(--gw-serif);
            font-size: 1.8rem;
            font-weight: 600;
            color: var(--gw-ink);
            margin-bottom: 0.15rem;
        }

        .result-stat-block span {
            color: var(--gw-ink-muted);
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.08em;
        }

        .result-actions {
            display: flex;
            justify-content: center;
            gap: 0.75rem;
            flex-wrap: wrap;
        }

        @media (max-width: 600px) {
            .quiz-card, .result-card { padding: 1.75rem 1.5rem; }
            .question-text { font-size: 1.2rem; }
            .result-score { font-size: 3.8rem; }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div class="quiz-shell">

        <asp:Panel ID="pnlQuestion" runat="server">
            <div class="quiz-header">
                <h1><asp:Literal ID="litQuizTitle" runat="server"></asp:Literal></h1>
                <p>Answer all questions then submit to see your score.</p>
            </div>

            <div class="quiz-progress">
                <div class="quiz-progress-row">
                    <span>Question <strong><asp:Literal ID="litCurrentNum" runat="server"></asp:Literal></strong> of <strong><asp:Literal ID="litTotalNum" runat="server"></asp:Literal></strong></span>
                    <span><asp:Literal ID="litAnsweredCount" runat="server"></asp:Literal> answered</span>
                </div>
                <div class="quiz-progress-track">
                    <div class="quiz-progress-fill" id="progressFill" runat="server"></div>
                </div>
            </div>

            <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="quiz-alert">
                <asp:Literal ID="litAlertMsg" runat="server"></asp:Literal>
            </asp:Panel>

            <div class="quiz-card">
                <div class="question-label">Question <asp:Literal ID="litQNumLabel" runat="server"></asp:Literal></div>
                <div class="question-text"><asp:Literal ID="litQuestionText" runat="server"></asp:Literal></div>

                <asp:RadioButtonList ID="rblOptions" runat="server" CssClass="quiz-options"
                    RepeatLayout="UnorderedList" RepeatDirection="Vertical">
                </asp:RadioButtonList>

                <div class="quiz-nav">
                    <asp:Button ID="btnPrev" runat="server" Text="&larr; Previous"
                        CssClass="quiz-btn" OnClick="btnPrev_Click" CausesValidation="false" />

                    <asp:Button ID="btnNext" runat="server" Text="Next &rarr;"
                        CssClass="quiz-btn quiz-btn-primary" OnClick="btnNext_Click" />

                    <asp:Button ID="btnSubmit" runat="server" Text="Submit quiz"
                        CssClass="quiz-btn quiz-btn-primary" OnClick="btnSubmit_Click" Visible="false" />
                </div>
            </div>
        </asp:Panel>

        <asp:Panel ID="pnlResult" runat="server" Visible="false">
            <div class="result-card">
                <div runat="server" id="resultIconWrap" class="result-icon">
                    <asp:Literal ID="litResultIcon" runat="server"></asp:Literal>
                </div>

                <div class="result-score">
                    <asp:Literal ID="litResultPct" runat="server"></asp:Literal>
                    <span class="result-pct">%</span>
                </div>

                <h2 class="result-title"><asp:Literal ID="litResultTitle" runat="server"></asp:Literal></h2>
                <p class="result-detail"><asp:Literal ID="litResultDetail" runat="server"></asp:Literal></p>

                <div class="result-stats">
                    <div class="result-stat-block">
                        <strong><asp:Literal ID="litResultCorrect" runat="server"></asp:Literal></strong>
                        <span>Correct</span>
                    </div>
                    <div class="result-stat-block">
                        <strong><asp:Literal ID="litResultTotal" runat="server"></asp:Literal></strong>
                        <span>Total</span>
                    </div>
                    <div class="result-stat-block">
                        <strong><asp:Literal ID="litResultPassMark" runat="server"></asp:Literal>%</strong>
                        <span>Pass mark</span>
                    </div>
                </div>

                <div class="result-actions">
                    <asp:Button ID="btnRetry" runat="server" Text="Try again"
                        CssClass="quiz-btn" OnClick="btnRetry_Click" />
                    <asp:Button ID="btnBackToCourse" runat="server" Text="Back to course &rarr;"
                        CssClass="quiz-btn quiz-btn-primary" OnClick="btnBackToCourse_Click" />
                </div>
            </div>
        </asp:Panel>

    </div>

</asp:Content>
