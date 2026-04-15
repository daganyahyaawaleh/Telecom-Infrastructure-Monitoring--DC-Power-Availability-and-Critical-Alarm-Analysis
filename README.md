#  Telecom Network Availability & Incident Analysis

### Operational insights into energy-driven service availability and power-related incidents
---
This project presents a Power BI dashboard designed to monitor telecom site energy performance and service availability.



##  Project Background

This project focuses on analyzing telecom network availability from an energy perspective. Telecom sites rely on battery systems to maintain service during power failures, making it essential to understand the relationship between power events and service outages.

A synthetic dataset was generated to simulate realistic conditions, including AC failures, and service interruptions.

The dataset covers 5 sites over a 3-month period with a 5-minute frequency.

The objective is to evaluate service availability, detect incidents, and provide actionable insights into network performance.
Synthetic data was carefully designed to reflect real operational patterns such as AC failures and battery-driven service continuity.

The reliability of telecom networks heavily depends on the stability of their power systems. In many environments, telecom sites rely on a combination of **AC power (grid)** and **DC battery backup systems** to maintain service continuity.

In real-world operations, a site does not immediately go down during a power failure. Instead, battery systems sustain the service until a critical voltage threshold is reached.

This project analyzes how energy conditions impact **service availability, downtime, and network performance**.


The SQL queries used to prepare, transform, and analyze the data are organized as follows:

- Data cleaning and preparation queries can be found [here](./sql/01_data_cleaning.sql)
- Sensor-to-site mapping and SCD Type 2 logic can be found [here](./sql/02_mapping_enrichment.sql)
- Time-series structuring and pivot logic can be found [here](./sql/03_sensor_data_final.sql)
- Event detection (AC failures and service events) can be found [here](./sql/04_event_detection.sql)
- Service incident construction and downtime calculation can be found [here](./sql/05_service_incidents.sql)

These queries demonstrate the end-to-end transformation from raw IoT sensor data to actionable business insights.

---

##  Real-World Context

This project is inspired by real telecom monitoring operations.

In a real-world environment, I monitor over 150 telecom sites using SensDesk (HW group), analyzing voltage, temperature, and generator systems to ensure service continuity.



##  Dataset Description

To simulate realistic telecom conditions, a synthetic dataset was generated:

- 5 telecom sites (RAN , CO , Data Center, Submarine)  
- 3-month period  
- 5-minute frequency
- DC Voltage
- AC Status
## ⚡ Technical Insight (Energy Layer)

- **Low Voltage Disconnect (LVD)**: Service considered down when DC voltage < 43V  
- **Floating Voltage**: Normal battery voltage ~53–54V 
  
Generator backup systems were not explicitly modeled. Critical sites(e.g., Data Centers, Submarine) are assumed to have generator support.

This results in approximately:

---
## key Metrics

The primary metric of this project is **Service Availability (%)**.

- **Service Availability (North Star)** – Focus on the overall percentage of time telecom services remain operational, based on energy conditions (DC voltage threshold). This is the primary indicator of network reliability and user experience.

- **Incident Analysis** – Monitoring the number of service incidents and their frequency to understand how often disruptions occur across sites.

- **Recovery Performance (MTTR)** – Evaluating how quickly the network recovers from outages by analyzing the average duration of service incidents.

- **Network Stability (MTBF)** – Measuring the time between failures to assess the overall stability and robustness of the infrastructure.

- **Downtime Impact** – Analyzing total downtime duration across sites and site types to identify the most critical areas affecting service continuity.

- **Site-Type Performance** – Comparing availability and downtime across different telecom site types (RAN, CO, Data Center, Submarine) to identify structural performance differences.
  ---

  
## 📊 Dataset Structure and ERD (Entity Relationship Diagram) 

The project is based on a time-series dataset (`sensor_data_final`) capturing DC voltage and AC status at 5-minute intervals across telecom sites.

This dataset is enriched with historical sensor-to-site mapping (SCD Type 2) and transformed into event and incident tables to support availability analysis.

*Fact Constellation Schema (multi-fact)*






---


## 📊 Executive Summary

The analysis reveals that network availability is generally high (~99.8%), but service disruptions are concentrated in specific site types, particularly RAN sites.


The analysis shows that overall network availability remains consistently high across all site types, with most values close to or exceeding the SLA target (99.99%).

However, RAN sites exhibit slightly lower availability compared to other site types, particularly in February, indicating higher sensitivity to power-related disruptions.

Data Centers and Submarine sites demonstrate near-perfect availability, reflecting stronger resilience, likely due to more robust energy backup systems.

Overall, while the network performs well, performance is not uniform, and certain site types represent higher operational risk.

This analysis focuses on energy-driven availability, highlighting the impact of power conditions on service performance.


---


<img width="1129" height="452" alt="image" src="https://github.com/user-attachments/assets/4ec0d439-8d56-4b52-af88-4478c5388c45" />


---
Key insights:
- GSM sites contribute the most to service downtime.
- Voltage drops below the critical threshold (43V) directly correlate with service outages.
- Some site types do not meet their SLA targets despite high overall availability.




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
  - sensor_data_final : time-series voltage measurements 
  - service_incidents  

- Dimensions:
  - Dim_Site  
  - Dim_Date
    
All fact tables are connected through:
- Date (Calendar table)
- SiteID (Site mapping)
## Data Model

The data model follows a star schema:

- `voltage_data`: time-series voltage measurements
- `alarms_data`: power outage events
- `site_type_mapping`: site classification
- `calendar`: date dimension



![Data Model](./images/data_model.png)

* Fact Constellation Schema (multi-fact)

---

## Limitations

- Synthetic dataset
- No battery capacity or State of Health (SOH) data
- Generator behavior is not modeled

These limitations simplify the analysis but do not affect the overall insights.

## 🛠 Tools Used

- SQL Server (SSMS)  
- Power BI  
- DAX  

---

## Author

Data Analyst specialized in telecom energy monitoring and performance analysis.

Experienced in managing real-world telecom sites and analyzing voltage, temperature, and generator data using monitoring systems.

 

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





### Data Scale (Production)

- ~1.5 million rows per month  
- 20+ million rows historically  

Although this project uses synthetic data, it is designed to closely replicate real operational patterns.

## Real-World Experience & Data Engineering Context

In addition to this portfolio project, I currently work on real telecom infrastructure monitoring covering more than 150 active sites.

These sites are equipped with HWg sensors monitoring:
- DC voltage (-48V systems)
- Temperature
- Generator (GE) status



### Data Volume

The real dataset is significantly larger than the one used in this project:
- ~1.5 million rows per month
- Over 20 million rows accumulated to date

To handle this scale, I rely on SQL for data processing and transformation.

### Sensor Complexity

One of the main challenges is that:
- Sensors can be replaced over time
- A single site may use different sensors across periods
- Sensor IDs do not directly map to a site permanently

### Solution Implemented

To solve this, I designed a historical mapping model:

1. From the raw fact table, I built a **sensor history table** containing:
   - Sensor ID
   - Start date
   - End date

2. I maintain a **manual mapping table**:
   - Sensor ID → Site Name

3. By merging both tables, I am able to:
   - Track which sensor belongs to which site over time
   - Accurately attribute data to the correct site for any period

This approach ensures data consistency despite sensor changes and enables reliable time-based analysis.








