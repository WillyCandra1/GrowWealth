<%@ Page Title="Module" Language="C#" MasterPageFile="~/Master/after_landing.Master" AutoEventWireup="true" CodeBehind="ModuleViewer.aspx.cs" Inherits="GrowWealth.Pages.Member.ModuleViewer" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .mv-back {
            color: var(--gw-ink-muted);
            font-size: 0.85rem;
            margin-bottom: 1.25rem;
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
        }

        .mv-back:hover { color: var(--gw-accent); }

        .mv-layout {
            display: grid;
            grid-template-columns: 260px 1fr 260px;
            gap: 1.5rem;
        }

        .mv-side-panel {
            background-color: var(--gw-surface);
            border: 1px solid var(--gw-line);
            border-radius: 14px;
            padding: 1.5rem 1.25rem;
            height: fit-content;
        }

        .mv-side-panel h3 {
            font-size: 0.78rem;
            color: var(--gw-ink-muted);
            text-transform: uppercase;
            letter-spacing: 0.12em;
            font-weight: 600;
            margin-bottom: 1rem;
            font-family: var(--gw-sans);
        }

        .mv-mod-link {
            display: flex;
            align-items: center;
            gap: 0.7rem;
            padding: 0.65rem 0.75rem;
            border-radius: 6px;
            font-size: 0.88rem;
            color: var(--gw-ink-soft);
            margin-bottom: 0.25rem;
            transition: all 0.15s;
        }

        .mv-mod-link:hover {
            background-color: var(--gw-paper-warm);
            color: var(--gw-ink);
        }

        .mv-mod-link.current {
            background-color: var(--gw-ink);
            color: var(--gw-paper);
            font-weight: 500;
        }

        .mv-mod-link.current:hover {
            background-color: var(--gw-ink);
            color: var(--gw-paper);
        }

        .mv-mod-num {
            width: 22px;
            height: 22px;
            border-radius: 50%;
            background-color: var(--gw-line-soft);
            color: var(--gw-ink-muted);
            font-size: 0.72rem;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            font-family: var(--gw-serif);
        }

        .mv-mod-link.current .mv-mod-num {
            background-color: var(--gw-paper);
            color: var(--gw-ink);
        }

        .mv-mod-link.done .mv-mod-num {
            background-color: var(--gw-accent);
            color: white;
        }

        .mv-main {
            background-color: var(--gw-surface);
            border: 1px solid var(--gw-line);
            border-radius: 14px;
            padding: 2.5rem 2.75rem 3rem;
        }

        .mv-bread {
            font-size: 0.82rem;
            color: var(--gw-ink-muted);
            margin-bottom: 1rem;
        }

        .mv-bread a { color: var(--gw-ink-muted); }
        .mv-bread a:hover { color: var(--gw-accent); }

        .mv-title {
            font-size: 2.2rem;
            margin-bottom: 0.75rem;
            line-height: 1.15;
        }

        .mv-meta-bar {
            display: flex;
            gap: 1.5rem;
            padding: 0.9rem 0;
            margin-bottom: 1.75rem;
            border-top: 1px solid var(--gw-line-soft);
            border-bottom: 1px solid var(--gw-line-soft);
            color: var(--gw-ink-muted);
            font-size: 0.85rem;
        }

        .mv-meta-bar strong { color: var(--gw-ink); font-weight: 600; font-family: var(--gw-serif); }

        .mv-content {
            color: var(--gw-ink);
            font-size: 1.02rem;
            line-height: 1.8;
        }

        .mv-content h2, .mv-content h3 {
            margin-top: 2rem;
            margin-bottom: 0.75rem;
        }

        .mv-content h2 { font-size: 1.55rem; }
        .mv-content h3 { font-size: 1.2rem; }

        .mv-content p { margin-bottom: 1.1rem; }

        .mv-content ul, .mv-content ol {
            margin-bottom: 1.1rem;
            padding-left: 1.5rem;
        }

        .mv-content li { margin-bottom: 0.45rem; }

        .mv-content blockquote {
            border-left: 3px solid var(--gw-accent);
            padding: 0.6rem 1.2rem;
            margin: 1.5rem 0;
            background-color: var(--gw-accent-soft);
            color: var(--gw-ink);
            border-radius: 0 8px 8px 0;
            font-style: italic;
        }

        .mv-content strong { color: var(--gw-ink); font-weight: 600; }

        .mv-nav {
            display: flex;
            justify-content: space-between;
            margin-top: 2.5rem;
            padding-top: 1.75rem;
            border-top: 1px solid var(--gw-line-soft);
            gap: 0.75rem;
            flex-wrap: wrap;
        }

        .mv-btn {
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
            text-decoration: none;
            display: inline-block;
        }

        .mv-btn:hover { border-color: var(--gw-ink); color: var(--gw-ink); }
        .mv-btn:disabled { opacity: 0.4; cursor: not-allowed; }

        .mv-btn-primary {
            background-color: var(--gw-ink);
            color: var(--gw-paper);
            border-color: var(--gw-ink);
        }

        .mv-btn-primary:hover {
            background-color: var(--gw-accent-dark);
            border-color: var(--gw-accent-dark);
            color: var(--gw-paper);
        }

        .mv-info-card {
            background-color: var(--gw-surface);
            border: 1px solid var(--gw-line);
            border-radius: 14px;
            padding: 1.5rem;
            height: fit-content;
            position: sticky;
            top: 90px;
        }

        .mv-info-card h4 {
            font-size: 0.78rem;
            text-transform: uppercase;
            letter-spacing: 0.12em;
            color: var(--gw-ink-muted);
            font-family: var(--gw-sans);
            font-weight: 600;
            margin-bottom: 0.85rem;
        }

        .mv-info-row {
            display: flex;
            justify-content: space-between;
            padding: 0.5rem 0;
            font-size: 0.88rem;
        }

        .mv-info-row span:first-child { color: var(--gw-ink-muted); }
        .mv-info-row span:last-child {
            color: var(--gw-ink);
            font-weight: 600;
            font-family: var(--gw-serif);
            font-variant-numeric: tabular-nums;
        }

        .mv-completed-banner {
            background-color: var(--gw-accent-soft);
            color: var(--gw-accent-dark);
            border: 1px solid #c0dccc;
            padding: 0.85rem 1.1rem;
            border-radius: 8px;
            font-size: 0.9rem;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.6rem;
        }

        .mv-completed-banner strong { color: var(--gw-accent-dark); }

        @media (max-width: 1100px) {
            .mv-layout { grid-template-columns: 220px 1fr; }
            .mv-info-card { display: none; }
        }

        @media (max-width: 760px) {
            .mv-layout { grid-template-columns: 1fr; }
            .mv-side-panel { display: none; }
            .mv-main { padding: 1.75rem 1.5rem 2rem; }
            .mv-title { font-size: 1.75rem; }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <asp:HyperLink ID="lnkBackCourse" runat="server" CssClass="mv-back">
        &larr; Back to course
    </asp:HyperLink>

    <div class="mv-layout">

        <aside class="mv-side-panel">
            <h3>Modules</h3>
            <asp:Repeater ID="rptSideModules" runat="server">
                <ItemTemplate>
                    <a href='<%# "~/Pages/Member/ModuleViewer.aspx?moduleId=" + Eval("ModuleID") %>'
                       runat="server"
                       class='<%# Eval("LinkClass") %>'>
                        <span class="mv-mod-num"><%# Eval("OrderIndex") %></span>
                        <span><%# Eval("Title") %></span>
                    </a>
                </ItemTemplate>
            </asp:Repeater>
        </aside>

        <article class="mv-main">
            <div class="mv-bread">
                <asp:HyperLink ID="lnkCrumbCourse" runat="server"><asp:Literal ID="litCrumbCourse" runat="server"></asp:Literal></asp:HyperLink>
                &nbsp;&rsaquo;&nbsp; Module <asp:Literal ID="litCrumbOrder" runat="server"></asp:Literal>
            </div>

            <h1 class="mv-title"><asp:Literal ID="litModuleTitle" runat="server"></asp:Literal></h1>

            <div class="mv-meta-bar">
                <span><strong><asp:Literal ID="litReadingTime" runat="server"></asp:Literal></strong> min read</span>
                <span>Quiz at the end &middot; <strong><asp:Literal ID="litQuizQCount" runat="server"></asp:Literal></strong> questions</span>
            </div>

            <asp:Panel ID="pnlAlreadyDone" runat="server" Visible="false" CssClass="mv-completed-banner">
                <strong>&#10003; Completed</strong> &middot; You finished this module on <asp:Literal ID="litCompletedDate" runat="server"></asp:Literal>.
            </asp:Panel>

            <div class="mv-content">
                <asp:Literal ID="litModuleContent" runat="server"></asp:Literal>
            </div>

            <div class="mv-nav">
                <asp:Button ID="btnPrev" runat="server" Text="&larr; Previous module"
                    CssClass="mv-btn" OnClick="btnPrev_Click" CausesValidation="false" />

                <asp:Button ID="btnMarkComplete" runat="server" Text="Mark complete &amp; take quiz &rarr;"
                    CssClass="mv-btn mv-btn-primary" OnClick="btnMarkComplete_Click" />
            </div>
        </article>

        <aside class="mv-info-card">
            <h4>This module</h4>
            <div class="mv-info-row"><span>Order</span><span><asp:Literal ID="litInfoOrder" runat="server"></asp:Literal></span></div>
            <div class="mv-info-row"><span>Reading time</span><span><asp:Literal ID="litInfoTime" runat="server"></asp:Literal> min</span></div>
            <div class="mv-info-row"><span>Quiz questions</span><span><asp:Literal ID="litInfoQuiz" runat="server"></asp:Literal></span></div>
            <div class="mv-info-row"><span>Status</span><span><asp:Literal ID="litInfoStatus" runat="server"></asp:Literal></span></div>
        </aside>

    </div>

</asp:Content>
