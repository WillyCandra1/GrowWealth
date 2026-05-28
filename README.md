# Grow Wealth

Grow Wealth is a financial literacy e-learning web application built with ASP.NET Web Forms and SQL Server. The idea behind it is to make personal finance education more accessible — users can enrol in structured courses, work through modules at their own pace, test their knowledge with quizzes, and simulate investment decisions in a virtual lab, all while tracking their progress through a personal dashboard.

---

## Features

### Member Side
- Register and log in with secure Forms Authentication
- Personal dashboard showing enrolled courses, module completion progress, average quiz scores, and a recent activity feed
- Course catalogue with the ability to enrol and track progress per course
- Module viewer for reading course content and marking modules as complete
- End-of-module quizzes with instant scoring and pass/fail feedback
- Virtual investment simulator for practising financial decision making
- Profile page to update personal details, upload a profile picture, change password, and delete account

### Admin Side
- Admin dashboard with a site-wide overview of users, courses, and activity
- Manage Users — view, edit, suspend, or delete member accounts
- Manage Courses — create, edit, and toggle course visibility
- Manage Quiz — create and edit quiz questions per module

---

## Tech Stack

| Layer | Technology |
|-------|------------|
| Framework | ASP.NET Web Forms (.NET Framework 4.7.2) |
| Language | C# |
| Database | SQL Server LocalDB |
| Data Access | ADO.NET (SqlConnection, SqlCommand, SqlDataReader) |
| Authentication | ASP.NET Forms Authentication |
| Frontend | HTML5, CSS3, JavaScript |
| Fonts | Merriweather, Roboto (Google Fonts) |

---

## Project Structure

```
GrowWealth/
├── Assets/
│   ├── css/               # Global stylesheet
│   └── images/profiles/   # Uploaded profile pictures
├── Master/
│   ├── before_landing.Master   # Shell for public pages
│   ├── after_landing.Master    # Shell for member pages
│   └── Admin.Master            # Shell for admin pages
├── Pages/
│   ├── Public/            # Login, Register
│   ├── Member/            # Dashboard, Courses, Module Viewer, Quiz, Virtual Lab, Profile
│   └── Admin/             # Admin Dashboard, Manage Users, Manage Courses, Manage Quiz
├── Database/              # SQL scripts
└── Web.config
```

---

## Getting Started

### Requirements

- Visual Studio 2019 or later with the **ASP.NET and web development** workload installed
- SQL Server LocalDB — comes bundled with Visual Studio by default, no separate installation needed

### Setup

1. Clone the repo and open `GrowWealth.sln` in Visual Studio

2. Set up the database:
   - Go to **View → SQL Server Object Explorer**
   - Expand **SQL Server → (localdb)\MSSQLLocalDB**
   - Right-click and select **New Query**
   - Open `GrowWealthDB_Full.sql`, copy everything, paste it into the query window and click Execute

3. Press **F5** to build and run

---

## Test Accounts

| Role | Email | Password | Notes |
|------|-------|----------|-------|
| Admin | admin@growwealth.com | admin123 | Full admin panel access |
| Member | ahmad@email.com | password123 | Most progress — best for demos |
| Member | weiling@email.com | password123 | |
| Member | priya@email.com | password123 | |
| Member | cheekeong@email.com | password123 | |
| Member | siti@email.com | password123 | |
| Suspended | daniel@email.com | password123 | Account is suspended |
