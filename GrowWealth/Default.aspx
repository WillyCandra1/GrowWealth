<%@ Page Title="Grow Wealth &mdash; Financial literacy that compounds" Language="C#" MasterPageFile="~/Master/before_landing.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="GrowWealth._Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .hero {
            padding: 6rem 0 5rem;
            border-bottom: 1px solid var(--gw-line);
        }

        .hero-inner {
            max-width: 1240px;
            margin: 0 auto;
            padding: 0 2rem;
            display: grid;
            grid-template-columns: 1.3fr 1fr;
            gap: 4rem;
            align-items: center;
        }

        .hero-eyebrow {
            font-size: 0.78rem;
            text-transform: uppercase;
            letter-spacing: 0.18em;
            color: var(--gw-accent);
            font-weight: 600;
            margin-bottom: 1.25rem;
            font-family: var(--gw-sans);
        }

        .hero h1 {
            font-size: clamp(2.5rem, 5vw, 4.2rem);
            line-height: 1.05;
            letter-spacing: -0.02em;
            margin-bottom: 1.5rem;
        }

        .hero h1 em {
            font-style: italic;
            font-weight: 400;
            color: var(--gw-accent);
        }

        .hero-lead {
            font-size: 1.18rem;
            color: var(--gw-ink-soft);
            line-height: 1.6;
            margin-bottom: 2.25rem;
            max-width: 540px;
        }

        .hero-cta {
            display: flex;
            gap: 0.85rem;
            align-items: center;
            flex-wrap: wrap;
        }

        .btn-cta-primary {
            background-color: var(--gw-ink);
            color: var(--gw-paper);
            padding: 0.9rem 1.7rem;
            border: 1px solid var(--gw-ink);
            border-radius: 8px;
            font-family: var(--gw-sans);
            font-size: 0.98rem;
            font-weight: 500;
            text-decoration: none;
            transition: all 0.18s;
            display: inline-block;
        }

        .btn-cta-primary:hover {
            background-color: var(--gw-accent-dark);
            border-color: var(--gw-accent-dark);
            color: var(--gw-paper);
        }

        .btn-cta-secondary {
            color: var(--gw-ink-soft);
            padding: 0.9rem 0.5rem;
            font-family: var(--gw-sans);
            font-size: 0.98rem;
            font-weight: 500;
            text-decoration: none;
            transition: color 0.18s;
        }

        .btn-cta-secondary:hover { color: var(--gw-accent); }

        .hero-stats {
            display: flex;
            gap: 2.5rem;
            margin-top: 2.5rem;
            padding-top: 2rem;
            border-top: 1px solid var(--gw-line);
        }

        .hero-stat strong {
            font-family: var(--gw-serif);
            font-size: 2rem;
            font-weight: 600;
            color: var(--gw-ink);
            display: block;
            line-height: 1;
            margin-bottom: 0.35rem;
        }

        .hero-stat span {
            color: var(--gw-ink-muted);
            font-size: 0.82rem;
            text-transform: uppercase;
            letter-spacing: 0.08em;
        }

        .hero-visual {
            background: linear-gradient(135deg, var(--gw-paper-warm) 0%, #ece5d5 100%);
            border: 1px solid var(--gw-line);
            border-radius: 16px;
            padding: 2.5rem;
            position: relative;
            min-height: 420px;
        }

        .hero-visual::before {
            content: '';
            position: absolute;
            top: 2rem;
            left: 2rem;
            right: 2rem;
            height: 2px;
            background-color: var(--gw-accent);
        }

        .hero-card {
            background-color: var(--gw-surface);
            border-radius: 10px;
            padding: 1.25rem 1.5rem;
            margin-bottom: 1rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.04);
        }

        .hero-card .stat-label {
            font-size: 0.72rem;
            color: var(--gw-ink-muted);
            text-transform: uppercase;
            letter-spacing: 0.1em;
            font-weight: 600;
            margin-bottom: 0.3rem;
        }

        .hero-card .stat-val {
            font-family: var(--gw-serif);
            font-size: 1.7rem;
            font-weight: 600;
            color: var(--gw-ink);
            font-variant-numeric: tabular-nums;
        }

        .hero-card .stat-val.gold { color: var(--gw-gold); }
        .hero-card .stat-val.accent { color: var(--gw-accent); }

        .hero-card .stat-trend {
            color: var(--gw-accent);
            font-size: 0.82rem;
            font-weight: 600;
            margin-top: 0.25rem;
        }

        .section {
            padding: 5rem 0;
            border-bottom: 1px solid var(--gw-line);
        }

        .section-inner {
            max-width: 1240px;
            margin: 0 auto;
            padding: 0 2rem;
        }

        .section-eyebrow {
            font-size: 0.78rem;
            text-transform: uppercase;
            letter-spacing: 0.18em;
            color: var(--gw-accent);
            font-weight: 600;
            margin-bottom: 0.9rem;
            font-family: var(--gw-sans);
        }

        .section h2 {
            font-size: clamp(1.9rem, 3.5vw, 2.8rem);
            line-height: 1.1;
            margin-bottom: 1rem;
            letter-spacing: -0.02em;
            max-width: 720px;
        }

        .section-lead {
            font-size: 1.05rem;
            color: var(--gw-ink-soft);
            line-height: 1.65;
            max-width: 620px;
            margin-bottom: 3rem;
        }

        .featured-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 1.5rem;
        }

        .featured-grid > a {
            display: block;
            text-decoration: none;
            height: 100%;
        }

        .featured-card {
            background-color: var(--gw-surface);
            border: 1px solid var(--gw-line);
            border-radius: 14px;
            padding: 2rem;
            transition: all 0.22s;
            box-sizing: border-box;
            height: 100%;
            display: flex;
            flex-direction: column;
        }

        .featured-card:hover {
            border-color: var(--gw-accent);
            transform: translateY(-3px);
            box-shadow: 0 10px 30px rgba(11, 107, 58, 0.06);
        }

        .featured-card .level-tag {
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
            font-size: 0.72rem;
            font-weight: 600;
            color: var(--gw-ink-muted);
            text-transform: uppercase;
            letter-spacing: 0.08em;
            margin-bottom: 1.25rem;
            align-self: flex-start;
        }

        .featured-card .level-tag::before {
            content: '';
            display: block;
            width: 6px;
            height: 6px;
            border-radius: 50%;
        }

        .featured-card .level-tag.beginner::before { background-color: var(--gw-accent); }
        .featured-card .level-tag.intermediate::before { background-color: var(--gw-gold); }
        .featured-card .level-tag.advanced::before { background-color: var(--gw-rose); }

        .featured-card h3 {
            font-size: 1.35rem;
            margin-bottom: 0.6rem;
        }

        .featured-card p {
            color: var(--gw-ink-soft);
            font-size: 0.92rem;
            margin-bottom: auto; /* pushes meta to the bottom */
            min-height: 70px;
        }

        .featured-meta {
            display: flex;
            justify-content: space-between;
            padding-top: 1.2rem;
            border-top: 1px solid var(--gw-line-soft);
            font-size: 0.85rem;
            color: var(--gw-ink-muted);
        }

        .featured-meta strong {
            color: var(--gw-ink);
            font-family: var(--gw-serif);
        }

        .why-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 2.5rem;
        }

        .why-card .why-num {
            font-family: var(--gw-serif);
            font-size: 2.2rem;
            color: var(--gw-accent);
            font-weight: 600;
            display: block;
            margin-bottom: 0.85rem;
            line-height: 1;
        }

        .why-card h3 {
            font-size: 1.25rem;
            margin-bottom: 0.6rem;
        }

        .why-card p {
            color: var(--gw-ink-soft);
            font-size: 0.95rem;
            line-height: 1.65;
        }

        .cta-section {
            background-color: var(--gw-ink);
            color: var(--gw-paper);
            padding: 5rem 0;
        }

        .cta-inner {
            max-width: 920px;
            margin: 0 auto;
            padding: 0 2rem;
            text-align: center;
        }

        .cta-section h2 {
            color: var(--gw-paper);
            margin-bottom: 1.25rem;
        }

        .cta-section p {
            color: rgba(250, 248, 243, 0.75);
            font-size: 1.1rem;
            margin-bottom: 2rem;
            max-width: 540px;
            margin-left: auto;
            margin-right: auto;
        }

        .btn-cta-light {
            background-color: var(--gw-paper);
            color: var(--gw-ink);
            padding: 0.95rem 2rem;
            border: 1px solid var(--gw-paper);
            border-radius: 8px;
            font-family: var(--gw-sans);
            font-size: 1rem;
            font-weight: 500;
            text-decoration: none;
            transition: all 0.18s;
            display: inline-block;
        }

        .btn-cta-light:hover {
            background-color: transparent;
            color: var(--gw-paper);
        }

        .team-grid {
            display: grid;
            grid-template-columns: repeat(5, 1fr);
            gap: 2rem;
            margin-top: 3rem;
            text-align: center;
        }

        .team-card {
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .team-avatar {
            width: 210px;
            height: 210px;
            border-radius: 8px;
            border: 2px dashed var(--gw-line);
            padding: 4px;
            margin-bottom: 1.25rem;
            background-color: var(--gw-surface);
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
        }

        .team-avatar::before {
            content: 'PHOTO';
            font-size: 0.65rem;
            color: var(--gw-ink-muted);
            text-transform: uppercase;
            letter-spacing: 0.05em;
            position: absolute;
            z-index: 1;
        }

        .team-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 4px;
            position: relative;
            z-index: 2;
        }

        .team-name {
            font-family: var(--gw-serif);
            font-size: 1.1rem;
            color: var(--gw-ink);
            margin-bottom: 0.25rem;
        }

        .team-tp {
            font-size: 0.85rem;
            color: var(--gw-ink-muted);
            text-transform: uppercase;
            letter-spacing: 0.08em;
        }

        @media (max-width: 920px) {
            .hero-inner { grid-template-columns: 1fr; gap: 3rem; }
            .featured-grid, .why-grid { grid-template-columns: 1fr; }
            .hero-stats { flex-wrap: wrap; gap: 1.5rem 2.5rem; }
            .team-grid { grid-template-columns: repeat(3, 1fr); gap: 1.5rem; }
        }

        @media (max-width: 600px) {
            .team-grid { grid-template-columns: repeat(2, 1fr); }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <section class="hero">
        <div class="hero-inner">
            <div>
                <div class="hero-eyebrow">Financial literacy &middot; Made for Malaysia</div>
                <h1>Build financial knowledge<br/>that <em>compounds</em>.</h1>
                <p class="hero-lead">A focused, editorial-style platform that takes you from financial basics to confident investing &mdash; at your own pace, with interactive labs and quizzes.</p>
                <div class="hero-cta">
                    <a href="<%= ResolveUrl("~/Pages/Public/Register.aspx") %>" class="btn-cta-primary">Start learning free</a>
                    <a href="#courses" class="btn-cta-secondary">Browse courses &rarr;</a>
                </div>
                <div class="hero-stats">
                    <div class="hero-stat">
                        <strong>3</strong>
                        <span>Curated courses</span>
                    </div>
                    <div class="hero-stat">
                        <strong>15</strong>
                        <span>Bite-size modules</span>
                    </div>
                    <div class="hero-stat">
                        <strong>75+</strong>
                        <span>Quiz questions</span>
                    </div>
                </div>
            </div>

            <div class="hero-visual">
                <div class="hero-card">
                    <div class="stat-label">Portfolio value &middot; Year 10</div>
                    <div class="stat-val">RM 89,432</div>
                    <div class="stat-trend">&uarr; 78.9% ROI on RM 50,000 invested</div>
                </div>
                <div class="hero-card">
                    <div class="stat-label">Modules done this month</div>
                    <div class="stat-val accent">12 / 15</div>
                </div>
                <div class="hero-card">
                    <div class="stat-label">Average quiz score</div>
                    <div class="stat-val gold">84%</div>
                </div>
            </div>
        </div>
    </section>

    <section class="section" id="courses">
        <div class="section-inner">
            <div class="section-eyebrow">Course catalogue</div>
            <h2>Three paths. From your first ringgit to your first portfolio.</h2>
            <p class="section-lead">Each course breaks down complex finance topics into short reading modules followed by a quiz to lock the learning in.</p>

            <div class="featured-grid">
                <asp:Repeater ID="rptFeatured" runat="server">
                    <ItemTemplate>
                        <a href='<%# ResolveUrl("~/Pages/Public/Register.aspx") %>'>
                            <div class="featured-card">
                                <span class='<%# "level-tag " + Eval("Difficulty").ToString().ToLower() %>'><%# Eval("Difficulty") %></span>
                                <h3><%# Eval("Title") %></h3>
                                <p><%# Eval("Description") %></p>
                                <div class="featured-meta">
                                    <span><strong><%# Eval("ModuleCount") %></strong> modules</span>
                                    <span><strong><%# Eval("EstimatedHours") %></strong> hrs</span>
                                </div>
                            </div>
                        </a>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
    </section>

    <section class="section" id="why">
        <div class="section-inner">
            <div class="section-eyebrow">Why Grow Wealth</div>
            <h2>Built like a financial publication, not a learning app.</h2>
            <p class="section-lead">No gamification, no streaks, no fluff. Just considered content, structured progression, and a place to put it to use.</p>

            <div class="why-grid">
                <div class="why-card">
                    <span class="why-num">01</span>
                    <h3>Read, quiz, repeat</h3>
                    <p>Short modules grouped into courses. Each module ends with a quiz so the concept actually sticks before you move on.</p>
                </div>
                <div class="why-card">
                    <span class="why-num">02</span>
                    <h3>Practice in the lab</h3>
                    <p>Run compound-interest projections in the Virtual Lab. See how contributions, rate, and time shape your future portfolio.</p>
                </div>
                <div class="why-card">
                    <span class="why-num">03</span>
                    <h3>Free, forever</h3>
                    <p>No paywall. Built as an academic project, made for genuine learning. Register once, learn at your pace.</p>
                </div>
            </div>
        </div>
    </section>

    <section class="section" id="about">
        <div class="section-inner">
            <div class="section-eyebrow">The Team</div>
            <h2>Meet the people behind Grow Wealth.</h2>
            <p class="section-lead">We are a dedicated group of students building a better financial future for Malaysians.</p>

            <div class="team-grid">
                <div class="team-card">
                    <div class="team-avatar">
                        <img src="<%= ResolveUrl("~/Assets/images/team-member-1.jpg") %>" alt="LKC" />
                    </div>
                    <h4 class="team-name">Willy Candra</h4>
                    <span class="team-tp">TP079819</span>
                </div>
                <div class="team-card">
                    <div class="team-avatar">
                        <img src="<%= ResolveUrl("~/Assets/images/team-member-2.jpg") %>" alt="Team Member 2" />
                    </div>
                    <h4 class="team-name">Richmond Deanlim</h4>
                    <span class="team-tp">TP078141</span>
                </div>
                <div class="team-card">
                    <div class="team-avatar"></div>
                    <h4 class="team-name">Student Name 3</h4>
                    <span class="team-tp">TP000000</span>
                </div>
                <div class="team-card">
                    <div class="team-avatar"></div>
                    <h4 class="team-name">Student Name 4</h4>
                    <span class="team-tp">TP000000</span>
                </div>
                <div class="team-card">
                    <div class="team-avatar"></div>
                    <h4 class="team-name">Student Name 5</h4>
                    <span class="team-tp">TP000000</span>
                </div>
            </div>
        </div>
    </section>

    <section class="cta-section" id="cta">
        <div class="cta-inner">
            <h2>Take the first step.</h2>
            <p>Create your free Grow Wealth account in under a minute and start learning today.</p>
            <a href="<%= ResolveUrl("~/Pages/Public/Register.aspx") %>" class="btn-cta-light">Create your account &rarr;</a>
        </div>
    </section>

</asp:Content>
