<%@ Page Title="Login" Language="C#" MasterPageFile="~/Master/before_landing.Master" AutoEventWireup="true"
    CodeBehind="Login.aspx.cs" Inherits="GrowWealth.Login" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    </asp:Content>

    <asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
        <div class="auth-box">
            <div class="auth-header">
                <h2>Welcome back</h2>
                <p>Sign in to continue learning</p>
            </div>

            <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="alert-danger">
                <asp:Literal ID="litErrorMsg" runat="server"></asp:Literal>
            </asp:Panel>

            <div class="form-group">
                <label class="form-label">Email address</label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="your@email.com"
                    OnTextChanged="txtEmail_TextChanged"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail"
                    ErrorMessage="Email is required" CssClass="text-danger" Display="Dynamic">
                </asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail"
                    ValidationExpression="^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$" ErrorMessage="Invalid email format"
                    CssClass="text-danger" Display="Dynamic"></asp:RegularExpressionValidator>
            </div>

            <div class="form-group">
                <label class="form-label">Password</label>
                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password"
                    placeholder="&bull;&bull;&bull;&bull;&bull;&bull;&bull;&bull;"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword"
                    ErrorMessage="Password is required" CssClass="text-danger" Display="Dynamic">
                </asp:RequiredFieldValidator>
            </div>

            <div class="form-group"
                style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem;">
                <label
                    style="display: flex; align-items: center; gap: 0.5rem; font-size: 0.875rem; color: var(--text-secondary); cursor: pointer;">
                    <asp:CheckBox ID="chkRememberMe" runat="server" OnCheckedChanged="chkRememberMe_CheckedChanged" />
                    Remember me
                </label>
                <a href="#" style="font-size: 0.875rem;">Forgot password?</a>
            </div>

            <asp:Button ID="btnLogin" runat="server" Text="Sign in" CssClass="btn btn-primary btn-block"
                OnClick="btnLogin_Click" />

            <div style="text-align: center; margin-top: 1.5rem; font-size: 0.875rem; color: var(--text-secondary);">
                No account? <a href="Register.aspx">Register here</a>
            </div>
        </div>
    </asp:Content>