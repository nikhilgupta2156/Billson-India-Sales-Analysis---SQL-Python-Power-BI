<h1> Billson India Sales Analysis: End-to-End Data Stack Project</h1>

<h2> Project Goal</h2>
<p>
To transform raw sales data into actionable business intelligence by analyzing sales performance, identifying key product drivers, 
and uncovering customer behavior patterns to optimize inventory and marketing strategies for Billson India.
</p>
<p>
This project demonstrates a full data analysis lifecycle, utilizing <b>Excel</b> for data cleaning, 
<b>SQL (MySQL)</b> for storage and query optimization, 
<b>Python</b> for in-depth statistical analysis, 
and <b>Power BI</b> for dynamic executive-level reporting.
</p>

<h2> Tools & Technologies Used</h2>
<table>
  <thead>
    <tr>
      <th>Category</th>
      <th>Tool/Language</th>
      <th>Purpose</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Data Cleaning</td>
      <td>Microsoft Excel</td>
      <td>Initial data inspection, cleanup, and type conversion.</td>
    </tr>
    <tr>
      <td>Database</td>
      <td>MySQL Workbench</td>
      <td>Storing, managing, and querying optimized tables.</td>
    </tr>
    <tr>
      <td>Analysis/Scripting</td>
      <td>Python (Pandas, Matplotlib, Seaborn)</td>
      <td>Feature engineering, statistical analysis, and advanced visualizations.</td>
    </tr>
    <tr>
      <td>Business Intelligence (BI)</td>
      <td>Power BI</td>
      <td>Creating an interactive, executive dashboard for real-time monitoring.</td>
    </tr>
    <tr>
      <td>Time Intelligence</td>
      <td>DAX</td>
      <td>Implementing Year-over-Year (YoY) and Month-over-Month (MoM) growth metrics.</td>
    </tr>
  </tbody>
</table>

<h2> Analysis Workflow & Methodology</h2>
<p>The project followed a detailed four-stage analytical pipeline starting from raw data extraction to final BI dashboard delivery:</p>

<ol>
  <li>
    <b>Data Gathering & Initial Cleaning (Excel)</b><br>
    <i>Action:</i> Data was sourced directly from the business's billing software, organized into three primary Excel files: Bill data, Customer data, and Item sales data. 
    Performed initial checks on column structure, data types, and applied minor cleaning to ensure data consistency and structured formatting.<br>
    <i>Result:</i> Three standardized Excel files were prepared for efficient database ingestion.
  </li>
  <br>
  <li>
    <b>Data Storage, Modeling & Querying (SQL - MySQL)</b><br>
    <i>Action:</i> The three cleaned Excel files were loaded into MySQL Workbench. Tables were joined where necessary to build a relational data model. 
    Performed minor SQL-based cleaning and wrote complex queries to extract aggregated, insightful data from the combined dataset, which contains over 12,000+ rows and 8,000+ invoices.<br>
    <i>Optimization:</i> Focused on writing efficient queries to pre-calculate key metrics and ensure fast retrieval of the analytical dataset.<br>
    <i>Result:</i> A robust, queryable data warehouse foundation for further analysis.
  </li>
  <br>
  <li>
    <b>Deep Analysis & Hypothesis Testing (Python - Google Colab)</b><br>
    <i>Action:</i> The joined and extracted data from SQL was used in Python (Google Colab). 
    This phase involved further data cleaning, feature engineering, detailed data visualization, comprehensive statistical analysis, and hypothesis testing to validate business assumptions.<br>
    <i>Result:</i> Final business insights were derived, and concrete, data-driven recommendations were formulated based on statistical evidence.
  </li>
  <br>
  <li>
    <b>Interactive Reporting & BI Development (Power BI)</b><br>
    <i>Action:</i> The final, processed data and supporting dimension files were used to build a 3-page interactive dashboard. 
    The process included Data Modeling, Power Query for last-mile transformations, implementation of advanced DAX Functions and Measures (including YoY/MoM growth), 
    and creation of interactive visuals to showcase sales trends.<br>
    <i>Technical Highlights:</i> Implemented dynamic measure switching (Sales/Orders) and utilized cross-filtering for granular analysis.<br>
    <i>Result:</i> A user-friendly BI tool for continuous performance tracking and decision-making.
  </li>
</ol>

<h2> Key Insights</h2>
<ul>
  <li><b>Customer Type Share:</b> Agents (33.92%), Loyal Customers (22.81%), Casual Customers (43.28%).</li>
  <li><b>State-wise Customer Distribution (Casual + Loyal):</b> Punjab (47.47%), Chandigarh (15.66%), Haryana (12.46%), Himachal Pradesh (8.46%), others make up the rest.</li>
  <li><b>Total Customers:</b> Around 1,400 customers contributing to over 4,500+ total orders.</li>
  <li><b>YoY Growth:</b> Sales grew by 114% from 2022 to 2023.</li>
  <li><b>Payment Mode:</b> Cash Transactions – 3.29%, Online Payments – 96.71%.</li>
  <li><b>Sales Volume:</b> 2024 sales reached approx. ₹35 Million. In 2025 (Jan–Jul), sales already reached ₹23.6 Million (over half of 2024’s total) and are expected to surpass it by year-end.</li>
  <li><b>Quarterly Trend:</b> April, May, June consistently recorded the highest quarterly sales across years, likely driven by new financial year openings and fresh system purchases.</li>
  <li><b>Monthly Anomaly:</b> May had the lowest order count but the 3rd highest overall sales, indicating significantly higher Average Order Values (AOV).</li>
  <li><b>AOV Growth:</b> Average order value increased drastically by 127% from 2022 to 2023.</li>
  <li><b>Product Performance:</b> ECR, POS Terminals, and Thermal Printers dominate sales. A sharp increase in POS Terminal sales post-2022 can be attributed to extensive marketing efforts.</li>
</ul>

<h2>Recommendations</h2>
<ul>
  <li>Increase <b>promotional activities during winter months</b>, as sales typically drop after the festive season (Sept–Nov).</li>
  <li>Boost <b>festive season sales</b> by providing offers and discounts to attract higher order volumes.</li>
  <li>Encourage <b>spare parts orders</b> by offering special deals to Agent customers.</li>
  <li>Develop <b>upsell strategies</b> for accessories and services with hardware purchases to capture recurring revenue opportunities.</li>
  <li>Continue optimizing <b>digital payment infrastructure</b> to strengthen efficiency and reduce reliance on cash systems.</li>
  <li>Introduce a <b>tiered loyalty program</b> to retain high-value customers, increase casual buyer frequency, and strengthen partnerships with Agents.</li>
</ul>

<h2>Repository Contents</h2>
<ul>
  <li><code>sql/billson_queries.sql</code> / <code>sql/billson_queries.txt</code>: All necessary MySQL commands for database setup, table creation, and analytical queries.</li>
  <li><code>python/billson_analysis.pdf</code>: The complete Google Colab notebook exported as a PDF, showing the code, output, and advanced visualizations used for EDA.</li>
  <li><code>powerbi/Billson_Sales_Dashboard.pbix</code>: The final Power BI file containing the complete data model, DAX measures, and the 3-page interactive dashboard.</li>
</ul>

<h2>See how the Dashboard looks like: </h2>
![Homepage](https://github.com/nikhilgupta2156/Billson-India-Sales-Analysis---SQL-Python-Power-BI/blob/main/Home%20Page%20-%20Power%20BI.png).

![Sales Overview](https://github.com/nikhilgupta2156/Billson-India-Sales-Analysis---SQL-Python-Power-BI/blob/main/Sales%20Overview%20-%20Power%20BI.png).

![Item Sales](https://github.com/nikhilgupta2156/Billson-India-Sales-Analysis---SQL-Python-Power-BI/blob/main/Item%20Sales%20-%20Power%20BI.png).

![Customer Sales](https://github.com/nikhilgupta2156/Billson-India-Sales-Analysis---SQL-Python-Power-BI/blob/main/Customer%20Sales%20-%20Power%20BI.png).

