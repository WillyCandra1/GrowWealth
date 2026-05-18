using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace GrowWealth.Pages.Member
{
    public partial class VirtualLab : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["GrowWealthDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CreateSimulationTableIfMissing();
                LoadSimulationHistory();
            }
        }

        protected void btnCalculate_Click(object sender, EventArgs e)
        {
            decimal initialAmount;
            decimal monthlyContribution;
            decimal annualRate;
            int years;

            bool initialOk = decimal.TryParse(txtInitialAmount.Text, out initialAmount);
            bool monthlyOk = decimal.TryParse(txtMonthlyContribution.Text, out monthlyContribution);
            bool rateOk = decimal.TryParse(txtAnnualRate.Text, out annualRate);
            bool yearsOk = int.TryParse(txtYears.Text, out years);

            if (!initialOk || !monthlyOk || !rateOk || !yearsOk)
            {
                lblMessage.Text = "Please enter numbers only.";
                return;
            }

            if (initialAmount < 0 || monthlyContribution < 0 || annualRate < 0 || years <= 0)
            {
                lblMessage.Text = "Please enter valid positive values.";
                return;
            }

            decimal monthlyRate = annualRate / 100 / 12;
            int totalMonths = years * 12;

            decimal futureValue = initialAmount;

            for (int month = 1; month <= totalMonths; month++)
            {
                futureValue += monthlyContribution;
                futureValue *= (1 + monthlyRate);
            }

            decimal totalInvested = initialAmount + (monthlyContribution * totalMonths);
            decimal interestEarned = futureValue - totalInvested;
            decimal roi = 0;

            if (totalInvested > 0)
            {
                roi = (interestEarned / totalInvested) * 100;
            }

            lblProjectedValue.Text = "RM " + futureValue.ToString("N0");
            lblTotalInvested.Text = "RM " + totalInvested.ToString("N0");
            lblInterestEarned.Text = "RM " + interestEarned.ToString("N0");
            lblRoi.Text = roi.ToString("N1") + "%";

            SaveSimulation(initialAmount, monthlyContribution, annualRate, years, totalInvested, futureValue, interestEarned, roi);

            lblMessage.Text = "Calculation completed and saved.";
            LoadSimulationHistory();
        }

        private void CreateSimulationTableIfMissing()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
                    IF OBJECT_ID('InvestmentSimulation', 'U') IS NULL
                    BEGIN
                        CREATE TABLE InvestmentSimulation (
                            SimulationID INT IDENTITY(1,1) PRIMARY KEY,
                            UserID INT NULL,
                            InitialAmount DECIMAL(18,2) NOT NULL,
                            MonthlyContribution DECIMAL(18,2) NOT NULL,
                            AnnualRate DECIMAL(5,2) NOT NULL,
                            DurationYears INT NOT NULL,
                            TotalInvested DECIMAL(18,2) NOT NULL,
                            ProjectedValue DECIMAL(18,2) NOT NULL,
                            InterestEarned DECIMAL(18,2) NOT NULL,
                            ROI DECIMAL(10,2) NOT NULL,
                            CreatedAt DATETIME2 DEFAULT GETDATE()
                        )
                    END";

                SqlCommand cmd = new SqlCommand(sql, conn);
                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }

        private void SaveSimulation(decimal initialAmount, decimal monthlyContribution, decimal annualRate, int years,
            decimal totalInvested, decimal projectedValue, decimal interestEarned, decimal roi)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "INSERT INTO InvestmentSimulation " +
                             "(UserID, InitialAmount, MonthlyContribution, AnnualRate, DurationYears, TotalInvested, ProjectedValue, InterestEarned, ROI) " +
                             "VALUES (@UserID, @InitialAmount, @MonthlyContribution, @AnnualRate, @DurationYears, @TotalInvested, @ProjectedValue, @InterestEarned, @ROI)";

                SqlCommand cmd = new SqlCommand(sql, conn);

                cmd.Parameters.AddWithValue("@UserID", 2);
                cmd.Parameters.AddWithValue("@InitialAmount", initialAmount);
                cmd.Parameters.AddWithValue("@MonthlyContribution", monthlyContribution);
                cmd.Parameters.AddWithValue("@AnnualRate", annualRate);
                cmd.Parameters.AddWithValue("@DurationYears", years);
                cmd.Parameters.AddWithValue("@TotalInvested", totalInvested);
                cmd.Parameters.AddWithValue("@ProjectedValue", projectedValue);
                cmd.Parameters.AddWithValue("@InterestEarned", interestEarned);
                cmd.Parameters.AddWithValue("@ROI", roi);

                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }

        private void LoadSimulationHistory()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT TOP 10 InitialAmount, MonthlyContribution, AnnualRate, DurationYears, " +
                             "ProjectedValue, ROI, CreatedAt " +
                             "FROM InvestmentSimulation " +
                             "WHERE UserID = @UserID " +
                             "ORDER BY CreatedAt DESC";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@UserID", 2);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvHistory.DataSource = dt;
                gvHistory.DataBind();
            }
        }
    }
}