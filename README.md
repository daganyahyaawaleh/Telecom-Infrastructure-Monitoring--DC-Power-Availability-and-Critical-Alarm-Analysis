#  Telecom Network Availability & Incident Analysis

### Operational insights into energy-driven service availability and power-related incidents

---

## 📌 Project Background

The reliability of telecom networks heavily depends on the stability of their power systems. In many environments, telecom sites rely on a combination of **AC power (grid)** and **DC battery backup systems** to maintain service continuity.

In real-world operations, a site does not immediately go down during a power failure. Instead, battery systems sustain the service until a critical voltage threshold is reached.

This project analyzes how energy conditions impact **service availability, downtime, and network performance**.

---

## 🌍 Real-World Context

This project is inspired by real telecom monitoring operations.

In my current role, I manage energy and monitoring data from over 150 telecom sites equipped with IoT sensors (HWg via SensDesk).

These sensors measure:
- DC Voltage (-48V systems)
- Temperature
- Generator status

Data is collected via SensDesk and exported as monthly CSV files.

### Data Scale (Production)

- ~1.5 million rows per month  
- 20+ million rows historically  

Although this project uses synthetic data, it is designed to closely replicate real operational patterns.

---

## 📊 Dataset Description

To simulate realistic telecom conditions, a synthetic dataset was generated:

- 5 telecom sites (GSM, MSAN, Data Center, Submarine)  
- 3-month period  
- 5-minute frequency
- DC Voltage
- AC Status
  
Generator backup systems were not explicitly modeled. Critical sites(e.g., Data Centers, Submarine) are assumed to have generator support.

This results in approximately:



---

## 🌟 North Star Metrics

- **Service Availability (North Star)** – The primary indicator of network performance, representing the proportion of time services remain operational.

- **Incident Analysis** – Monitoring the number and frequency of service disruptions.

- **Recovery Performance (MTTR)** – Measuring how quickly the network recovers from outages.

- **Network Stability (MTBF)** – Evaluating time between failures.

- **Downtime Impact** – Analyzing total service interruption duration.

- **Site-Type Performance** – Comparing performance across GSM, MSAN, Data Center, and Submarine sites.

---

## 📊 Executive Summary




<img width="1129" height="452" alt="image" src="https://github.com/user-attachments/assets/4ec0d439-8d56-4b52-af88-4478c5388c45" />





The analysis shows that overall network availability remains consistently high across all site types, with most values close to or exceeding the SLA target (99.99%).

However, GSM sites exhibit slightly lower availability compared to other site types, particularly in February, indicating higher sensitivity to power-related disruptions.

Data Centers and Submarine sites demonstrate near-perfect availability, reflecting stronger resilience, likely due to more robust energy backup systems.

Overall, while the network performs well, performance is not uniform, and certain site types represent higher operational risk.

This analysis focuses on energy-driven availability, highlighting the impact of power conditions on service performance.



- Overall Availability remains close to SLA targets.

---

### 2. Incident Impact

- A total of **13 service incidents** were detected.
- Most incidents are **short in duration**, limiting their impact.
- Failures are generally well contained and quickly resolved.

---

### 3. Downtime Distribution

- **GSM sites contribute the majority of downtime**.
- Other site types show minimal impact.
- This indicates uneven infrastructure resilience.

---

### 4. SLA Performance

- Not all sites meet their SLA targets.
- A small number of sites drive SLA breaches.
- Targeted improvements could significantly enhance performance.

---

### 5. Key Takeaways

- The network is globally stable but not uniformly reliable.
- Energy systems play a critical role in service continuity.
- Improving a few critical sites can significantly improve SLA compliance.

---

## ⚙️ Data Transformation & Methodology

### 1. Data Cleaning

- Standardizing timestamps  
- Casting values to numeric  
- Handling missing values  
- Filtering irrelevant sensors  

---

### 2. Sensor-to-Site Mapping (SCD Type 2)

- Historical mapping with start/end dates  
- Handles sensor replacement over time  
- Ensures correct site attribution  

---

### 3. Data Structuring (Pivot)

Sensor data transformed into:



---

### 4. Event Detection

Using SQL window functions:

- MainsFail  
- MainsRestore  
- ServiceDown (DC < 43V)  
- ServiceRestored  

---

### 5. Incident Construction

- Grouping ServiceDown → ServiceRestored  
- Calculating duration  
- Creating `service_incidents` table  

---

### 6. KPI Calculation

- Availability (%)  
- MTTR  
- MTBF  
- Incident Count  

---

### 7. Data Model

Star schema:

- Fact Tables:
  - sensor_data_final  
  - service_incidents  

- Dimensions:
  - Dim_Site  
  - Dim_Date  

---

## 🛠 Tools Used

- SQL Server (SSMS)  
- Power BI  
- DAX  

---

## 📸 Dashboard Preview

![Dashboard](images/dashboard_overview.png)

---

## 📁 Project Structure

- `data/raw/` → raw sensor data  
- `data/curated/` → transformed datasets  
- `sql/` → SQL transformation scripts  
- `powerbi/` → dashboard file  
- `images/` → screenshots  
- `docs/` → methodology  

---

## 🚀 Future Improvements

- Integration of real telecom datasets  
- Advanced KPIs (Resilience, SLA Compliance)  
- Battery autonomy analysis  

---














## Project Background

This project focuses on analyzing telecom network availability from an energy perspective. Telecom sites rely on battery systems to maintain service during power failures, making it essential to understand the relationship between power events and service outages.

Due to the lack of accessible real-world telecom datasets, a synthetic dataset was generated to simulate realistic conditions, including AC failures, battery discharge, and service interruptions.

The dataset covers 5 sites over a 3-month period with a 5-minute frequency, resulting in approximately 130,000 records.

The objective is to evaluate service availability, detect incidents, and provide actionable insights into network performance.
Synthetic data was carefully designed to reflect real operational patterns such as AC failures and battery-driven service continuity.

## North Star Metric

The primary metric of this project is **Service Availability (%)**.

- **Service Availability** – Focus on the overall percentage of time telecom services remain operational, based on energy conditions (DC voltage threshold). This is the primary indicator of network reliability and user experience.


Supporting metrics were developed to explain and contextualize availability:


- **Incident Analysis** – Monitoring the number of service incidents and their frequency to understand how often disruptions occur across sites.

- **Recovery Performance (MTTR)** – Evaluating how quickly the network recovers from outages by analyzing the average duration of service incidents.

- **Network Stability (MTBF)** – Measuring the time between failures to assess the overall stability and robustness of the infrastructure.

- **Downtime Impact** – Analyzing total downtime duration across sites and site types to identify the most critical areas affecting service continuity.

- **Site-Type Performance** – Comparing availability and downtime across different telecom site types (GSM, MSAN, Data Center, Submarine) to identify structural performance differences.


## Real-World Context

This project is inspired by real-world telecom monitoring operations.

In my current role, I manage energy and monitoring data from over 150 telecom sites equipped with IoT sensors (HWg via SensDesk).

These sensors track key operational parameters such as:
- DC Voltage (-48V systems)
- Temperature
- Generator status

Data is collected through SensDesk and exported as monthly CSV files for analysis.

## Data Scale

In production environments, the data volume is significant:

- ~1.5 million rows per month
- 20+ million rows historically

This requires efficient data processing and modeling techniques, primarily using SQL.

## Handling Sensor Changes (SCD Type 2)

A key challenge in telecom monitoring is that sensors can be replaced over time while the site remains the same.

To ensure data consistency, a Slowly Changing Dimension (SCD Type 2) approach was implemented:

- A historical sensor table was created with start and end dates
- A mapping table (Sensor ID → Site) was maintained
- Time-based joins were used to associate each measurement with the correct site

This approach ensures that each data point is accurately linked to the correct site, even when sensors change over time.













* Fact Constellation Schema (multi-fact)


