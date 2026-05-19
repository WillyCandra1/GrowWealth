using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web.UI;

namespace GrowWealth.Pages.Member
{
    public partial class VirtualLab : Page
    {
        private readonly string connStr =
            ConfigurationManager.ConnectionStrings["GrowWealthDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Request.IsAuthenticated)
            {
                Response.Redirect("~/Pages/Public/Login.aspx");
                return;
            }
        }

        private int GetCurrentUserId()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(
                    "SELECT UserID FROM [User] WHERE FullName = @Name", conn);
                cmd.Parameters.AddWithValue("@Name", Context.User.Identity.Name);
                conn.Open();
                object result = cmd.ExecuteScalar();
                return (result == null || result == DBNull.Value) ? 0 : Convert.ToInt32(result);
            }
        }

        protected void btnCalc_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            decimal initial = decimal.Parse(txtInitial.Text, CultureInfo.InvariantCulture);
            decimal monthly = decimal.Parse(txtMonthly.Text, CultureInfo.InvariantCulture);
            decimal annualRate = decimal.Parse(txtRate.Text, CultureInfo.InvariantCulture) / 100m;
            int years = int.Parse(txtYears.Text);
            int compoundN = int.Parse(ddlCompounding.SelectedValue);

            decimal balance = initial;
            decimal totalContributed = initial;
            decimal periodicRate = annualRate / compoundN;
            int periodsPerYear = compoundN;

            DataTable yearly = new DataTable();
            yearly.Columns.Add("Year", typeof(int));
            yearly.Columns.Add("ContributedFmt", typeof(string));
            yearly.Columns.Add("InterestFmt", typeof(string));
            yearly.Columns.Add("BalanceFmt", typeof(string));

            decimal cumulativeContribOnly = 0m;

            for (int y = 1; y <= years; y++)
            {
                decimal startBalance = balance;
                decimal yearContrib = 0m;

                for (int p = 0; p < periodsPerYear; p++)
                {
                    decimal periodMonthly = (12m / periodsPerYear) * monthly;
                    balance += periodMonthly;
                    totalContributed += periodMonthly;
                    yearContrib += periodMonthly;

                    balance = balance * (1 + periodicRate);
                }

                decimal yearInterest = balance - startBalance - yearContrib;
                cumulativeContribOnly += yearContrib;

                DataRow row = yearly.NewRow();
                row["Year"] = y;
                row["ContributedFmt"] = FormatMoney(yearContrib);
                row["InterestFmt"] = FormatMoney(yearInterest);
                row["BalanceFmt"] = FormatMoney(balance);
                yearly.Rows.Add(row);
            }

            decimal interestEarned = balance - totalContributed;
            decimal roi = (totalContributed == 0) ? 0m : (interestEarned / totalContributed * 100m);

            litFinalValue.Text = FormatMoney(balance);
            litTotalInvested.Text = FormatMoney(totalContributed);
            litInterest.Text = FormatMoney(interestEarned);
            litROI.Text = roi.ToString("0.0");

            rptYearly.DataSource = yearly;
            rptYearly.DataBind();

            pnlEmpty.Visible = false;
            pnlResults.Visible = true;

            SaveSimulation(initial, monthly, annualRate * 100m, years, compoundN, balance, interestEarned);
        }

        private string FormatMoney(decimal value)
        {
            return value.ToString("N2", CultureInfo.InvariantCulture);
        }

        private void SaveSimulation(decimal initial, decimal monthly, decimal ratePct,
                                    int years, int compoundN, decimal finalVal, decimal interest)
        {
            int userId = GetCurrentUserId();
            if (userId == 0) return;

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand(
                        @"INSERT INTO InvestmentSimulation
                          (UserID, InitialAmount, MonthlyContribution, AnnualRate, DurationYears, CompoundingPerYear, FinalValue, InterestEarned, RunAt)
                          VALUES (@UserID, @Initial, @Monthly, @Rate, @Years, @Compound, @Final, @Interest, GETDATE())", conn);
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    cmd.Parameters.AddWithValue("@Initial", initial);
                    cmd.Parameters.AddWithValue("@Monthly", monthly);
                    cmd.Parameters.AddWithValue("@Rate", ratePct);
                    cmd.Parameters.AddWithValue("@Years", years);
                    cmd.Parameters.AddWithValue("@Compound", compoundN);
                    cmd.Parameters.AddWithValue("@Final", finalVal);
                    cmd.Parameters.AddWithValue("@Interest", interest);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            catch { }
        }
    }
}
