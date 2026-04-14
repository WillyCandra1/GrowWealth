<%@ Page Title="Register" Language="C#" MasterPageFile="~/before_landing.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="GrowWealth.Register" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="auth-box">
        <div class="auth-header">
            <h2>Create your account</h2>
            <p>Join thousands of learners building financial skills</p>
        </div>

        <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="alert-danger">
            <asp:Literal ID="litErrorMsg" runat="server"></asp:Literal>
        </asp:Panel>

        <div class="form-group">
            <label class="form-label">Full name</label>
            <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control" placeholder="e.g. Ahmad Zaki"></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfvFullName" runat="server" ControlToValidate="txtFullName" ErrorMessage="Full name is required" CssClass="text-danger" Display="Dynamic"></asp:RequiredFieldValidator>
        </div>

        <div class="form-group">
            <label class="form-label">Email address</label>
            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="e.g. ahmad@email.com"></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="Email is required" CssClass="text-danger" Display="Dynamic"></asp:RequiredFieldValidator>
            <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail" ValidationExpression="^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$" ErrorMessage="Invalid email format" CssClass="text-danger" Display="Dynamic"></asp:RegularExpressionValidator>
        </div>

        <div class="form-group">
            <label class="form-label">Password</label>
            <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Min. 8 characters"></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword" ErrorMessage="Password is required" CssClass="text-danger" Display="Dynamic"></asp:RequiredFieldValidator>
            <asp:RegularExpressionValidator ID="revPassword" runat="server" ControlToValidate="txtPassword" ValidationExpression="^.{8,}$" ErrorMessage="Password must be at least 8 characters" CssClass="text-danger" Display="Dynamic"></asp:RegularExpressionValidator>
        </div>

        <div class="form-group">
            <label class="form-label">Confirm password</label>
            <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Re-enter password"></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfvConfirmPassword" runat="server" ControlToValidate="txtConfirmPassword" ErrorMessage="Please confirm your password" CssClass="text-danger" Display="Dynamic"></asp:RequiredFieldValidator>
            <asp:CompareValidator ID="cvPassword" runat="server" ControlToValidate="txtConfirmPassword" ControlToCompare="txtPassword" ErrorMessage="Passwords do not match" CssClass="text-danger" Display="Dynamic"></asp:CompareValidator>
        </div>

        <div class="form-group">
            <label class="form-label">I am a...</label>
            <asp:DropDownList ID="ddlUserType" runat="server" CssClass="form-control">
                <asp:ListItem Text="Select an option" Value="" />
                <asp:ListItem Text="High school student" Value="HighSchool" />
                <asp:ListItem Text="University student" Value="University" />
                <asp:ListItem Text="Young professional" Value="Professional" />
                <asp:ListItem Text="Other" Value="Other" />
            </asp:DropDownList>
            <asp:RequiredFieldValidator ID="rfvUserType" runat="server" ControlToValidate="ddlUserType" InitialValue="" ErrorMessage="Please select what describes you best" CssClass="text-danger" Display="Dynamic"></asp:RequiredFieldValidator>
        </div>

        <div class="form-group" style="margin-bottom: 1.5rem;">
            <label style="display: flex; align-items: flex-start; gap: 0.5rem; font-size: 0.875rem; color: var(--text-secondary); cursor: pointer;">
                <asp:CheckBox ID="chkTerms" runat="server" />
                I agree to the Terms & Privacy Policy
            </label>
            <asp:CustomValidator ID="cvTerms" runat="server" ErrorMessage="You must agree to the terms" CssClass="text-danger" Display="Dynamic" OnServerValidate="cvTerms_ServerValidate"></asp:CustomValidator>
        </div>

        <asp:Button ID="btnRegister" runat="server" Text="Create account" CssClass="btn btn-primary btn-block" OnClick="btnRegister_Click" />

        <div style="text-align: center; margin-top: 1.5rem; font-size: 0.875rem; color: var(--text-secondary);">
            Already have an account? <a href="Login.aspx">Sign in here</a>
        </div>
    </div>
</asp:Content>
