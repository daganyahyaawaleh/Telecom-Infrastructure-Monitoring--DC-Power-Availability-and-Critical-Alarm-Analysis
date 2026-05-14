#  Telecom Energy & Service Availability Analytics

### Operational insights into energy-driven service availability and power-related incidents

## 📊 Dashboard Overview

<img width="1421" height="805" alt="image" src="https://github.com/user-attachments/assets/d5ba0d80-286e-43d6-8643-1b487d614d45" />



## Project Overview
This project presents a Power BI dashboard designed to analyze telecom network reliability through energy and operational telemetry data.

The analysis focuses on how power instability impacts service availability by correlating:

AC power failures
DC voltage degradation
Service interruption events
Downtime duration
SLA performance

The dashboard transforms raw IoT telemetry into operational reliability insights to support infrastructure monitoring and incident analysis.

## Business Problem 

Telecom network continuity heavily depends on stable DC power systems. During grid failures, battery systems temporarily sustain operations until critical voltage thresholds are reached.

This project models how energy instability affects service continuity and network performance by simulating real-world telecom operational behavior, including:

AC power outages
Battery discharge behavior
Voltage instability
Service downtime events

The objective is to identify infrastructure vulnerabilities, measure operational resilience, and provide actionable reliability insights.

## Data Engineering & SQL Pipeline

| Stage                   | Objective                                          |
| ----------------------- | -------------------------------------------------- |
| Site Standardization    | Clean and normalize site metadata                  |
| Sensor Mapping          | Associate telemetry with site history (SCD Type 2) |
| Time-Series Structuring | Pivot raw telemetry into analytical format         |
| Event Detection         | Detect power failures and voltage anomalies        |
| Incident Construction   | Build service downtime intervals                   |
| KPI Layer               | Calculate SLA and reliability metrics              |


The data preparation, transformation, and analysis were handled via a structured SQL pipeline

- Dim Site and data cleaning: Standardizing site metadata and attributes.[here](SQL_Scripts/01_create_dim_site.sql)
- Sensor mapping : Linking raw sensor telemetry to specific site IDs.can be found [here](.SQL_Scripts/02_mapping_clean.sql)
- Time-series structuring and pivot logic can be found [here](.SQL_Scripts/03_sensor_data_final.sql)
- Event detection ( Power failures and DC Voltage drop) can be found [here](SQL_Scripts/04_event_detection.sql)
- Service incident construction : Consolidating raw events into meaningful Service Incidents (Downtime periods).  [here](.SQL_Scripts/05_service_incidents.sql)

```text
IoT Energy Sensors
        ↓
Raw Telemetry Collection
        ↓
SQL Data Engineering Pipeline
        ↓
Power Event Detection
        ↓
Service Incident Construction
        ↓
KPI & SLA Modeling
        ↓
Operational Power BI Dashboard
```
## key Metrics

- **Service Availability (North Star)** – The percentage of time services remain operational based on the DC voltage threshold. This is the primary indicator of network reliability.

- **Incident Analysis** – Monitoring the number of service incidents and their frequency to understand how often disruptions occur across sites.

- **Recovery Performance (MTTR)** – Evaluating how quickly the network recovers from outages by analyzing the average duration of service incidents.

- **Network Stability (MTBF)** – Measuring the time between failures to assess the overall stability and robustness of the infrastructure.

- **Downtime Impact** – Quantifying total downtime across various site types sites and site types to identify the most critical areas affecting service continuity
- **Site-Type Performance** – Comparing availability and downtime across different categories : : RAN (Radio Access Network), CO (Central Office), Data Centers, and Submarine Stations.

##  Operational Relevance

This project is inspired by real telecom monitoring operations involving more than 150 telecom sites equipped with IoT energy sensors.

Operational environments typically generate:

~1.5 million telemetry rows per month
20+ million historical records

Although the dataset used in this project is synthetic, it was designed to realistically reproduce operational telecom power behaviors and incident patterns.
---

## Dataset Description
A synthetic dataset was generated to simulate realistic telecom conditions across a diverse infrastructure:

Site Diversity: 5 specific site types (RAN, CO, Data Center, Submarine Cable Station).

Temporal Scope: 3-month period with a 5-minute sampling frequency.

Telemetry Points: AC Status (0/1): Binary indicator of grid power availability.

DC Voltage: Real-time system voltage levels.

Data Volume: Approximately ~388,800 time-series records, reflecting real behaviors such as AC failures, battery discharge curves, and service interruptions triggered by voltage drops.

This results in approximately **~388,800 time-series records**.

##  Technical Insight 

- **Low Voltage Disconnect (LVD)** → service considered down when DC voltage < 43V  
- **Floating Voltage** → normal system voltage ~53–54V  
---


  
## Dataset Structure and ERD (Entity Relationship Diagram) 
The project utilizes a Fact Constellation Schema (multi-fact). The core time-series data (sensor_data_final) is enriched with historical sensor-to-site mapping (SCD Type 2 logic) and transformed into specialized event and incident tables.

<img width="1040" height="755" alt="image" src="https://github.com/user-attachments/assets/0b96d077-6d86-43d6-88a9-2f7e4104a277" />



Images/Dataset structure and ERD.PNG

---


##  Executive Summary & Insights


The network maintains a high availability rate (~99.98%), indicating strong overall resilience. However, granular analysis reveals significant performance variations:

Critical Vulnerabilities (RAN): Radio Access Network (RAN) sites exhibit the lowest availability, particularly in February, showing a higher sensitivity to power-related disruptions.

High-Resilience Infrastructure: Data Center and Submarine Cable Stations maintain near-perfect uptime, reflecting their robust backup power design.

Despite high global averages, some specific site types (notably GSM/RAN) struggle to meet strict SLA targets.

Operational Trends: Central Office (CO) sites show stable performance with a positive improvement trend over the three-month period.

Conclusion: While the network is globally stable, the structural weaknesses in RAN infrastructure highlight the direct impact of local power conditions on service continuity.



<img width="1230" height="468" alt="image" src="https://github.com/user-attachments/assets/58e4a20d-bb72-44c8-9fe7-3d8f8d933ae7" />




---
## Deep Dive Analysis

### 1 Site-Level Performance & Resilience 

The analysis reveals significant disparities in resilience across different infrastructure categories.


<img width="955" height="351" alt="image" src="https://github.com/user-attachments/assets/e8f3e376-813b-4b81-be02-0df910a02a2b" />


**A. RAN Sites (Radio Access Network)**
Sites SITE_GSM_01 and SITE_GSM_02 account for the majority of network downtime (1.08h and 0.83h).

They exhibit the highest incident frequency (4 incidents each).

Insight: Differences in recovery times suggest that performance is driven not only by power stability but also by battery health and site load conditions.
This indicates that performance degradation is not only driven by failure frequency, but also by recovery efficiency.


**B. CO Sites (Central Office)**
Moderate downtime (0.42h) with high Resilience (~60%).

Insight: CO sites demonstrate a superior ability to "absorb" AC failures without impacting service, indicating robust backup power sizing compared to RAN sites.


**C. Critical Infrastructure (Data Center & Submarine)**

Near-perfect availability **(99.99% - 100%)**.

SLA Sensitivity: Despite minimal downtime (5min), these sites occasionally fall below SLA targets due to extremely strict availability thresholds.

<img width="890" height="231" alt="image" src="https://github.com/user-attachments/assets/a336b745-83e0-42ff-b84d-aa33fddf8283" />


This indicates that SLA breaches are not only driven by downtime volume, but also by strict SLA thresholds on critical sites

### 2. Downtime Distribution

- **GSM sites contribute the majority of downtime**.
- Other site types show minimal impact.
- This indicates uneven infrastructure resilience.
  
  <img width="623" height="251" alt="image" src="https://github.com/user-attachments/assets/fc5ba5e5-c5c5-44dc-a73d-859b8317cddc" />

---

### 3. Incident Frequency vs Downtime Impact

Incident count alone is an incomplete metric. This project combines Incident Count, MTTR (Mean Time to Repair), and Total Downtime

**13 service incidents** were detected in total.

Most incidents are short-lived, suggesting that failures are generally well-contained.

Resilience Gap: RAN sites show only ~43% resilience, making them highly vulnerable to grid instability compared to Core sites.


<img width="497" height="94" alt="image" src="https://github.com/user-attachments/assets/42ce480f-aab7-4e81-a56e-28f361dce056" />

---

- ## Key Takeaways

- The network shows high overall availability (99.98%), but performance is not uniform across site types  
- RAN sites are the most vulnerable, contributing the majority of downtime and showing lower resilience to power failures  
- Incident frequency alone does not explain performance, outage duration (MTTR) is a key driver of availability  
- A small number of sites drive most service impact, indicating performance concentration rather than widespread issues  
- Critical sites (Data Center, Submarine) are highly stable, with only short transient outages, reflecting strong infrastructure resilience  
- Not all SLA breaches are critical — some are caused by strict SLA thresholds rather than significant downtime
  
 ## Recommendations

- **Prioritize RAN sites** for performance improvement, as they represent the main source of downtime  
- Improve **battery performance and energy backup systems** to reduce service impact during AC failures  
- Focus on reducing **MTTR (incident duration)** rather than only incident frequency  
- Implement **targeted maintenance strategies** on underperforming sites instead of network-wide actions  
- Introduce **SLA severity classification** to distinguish between minor deviations and critical failures  
- Enhance monitoring of energy systems to better anticipate and prevent service outages
  
---


##  Data Transformation & Methodology



### 1. Data Cleaning

- Standardizing timestamps  
- Casting values to numeric  
- Handling missing values  
- Filtering irrelevant sensors  

### 2. Sensor-to-Site Mapping (SCD Type 2)

- Historical mapping with start/end dates  
- Handles sensor replacement over time  
- Ensures correct site attribution  

### 3. Data Structuring (Pivot)

Sensor data transformed into:


### 4. Event Detection

- MainsFail → AC status changes from 1 to 0
- MainsRestore → AC status changes from 0 to 1
- ServiceDown → DC voltage drops below 43V
- ServiceRestored → DC voltage returns above threshold

This step converts raw signals into meaningful operational events.

### 5. Incident Construction

Service incidents are built by grouping events:

- Each incident starts at ServiceDown
- Ends at ServiceRestored
- Duration is calculated in hours

This results in an incident-level table, which is used as the primary source for downtime calculations.

### 6. KPI Calculation

All business metrics are derived from the incident and time-series data:

- Availability (%) → based on downtime vs observed time
- MTTR → average incident duration
- MTBF → time between incidents
- Incident Count → number of outages


### Limitations

- Dataset: Synthetic data modeled on real-world telecom patterns.
- Constraints: Battery Capacity (Ah), State of Health (SOH), and Generator behavior is not modeled
- These limitations simplify the analysis but do not affect the overall insights.

### Tech Stack
| Layer               | Technologies                     |
| ------------------- | -------------------------------- |
| Database            | SQL Server (SSMS)                |
| Data Transformation | SQL                              |
| Data Modeling       | Star Schema / Fact Constellation |
| Visualization       | Power BI                         |
| Monitoring Context  | Telecom Energy & IoT Telemetry   |


---

### Future Improvements

- Integration of real-time IoT API feeds.
- Predictive Maintenance modeling using battery discharge slopes.
- Battery autonomy analysis  

---
**Author:** Data Analyst focused on operational analytics, telecom energy monitoring, and service reliability intelligence.

Specialized in transforming IoT telemetry and infrastructure data into actionable operational insights.













