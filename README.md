<img width="1283" height="724" alt="image" src="https://github.com/user-attachments/assets/84e548c9-5445-4dac-835e-393c927eb018" />#  Telecom Energy & Service Availability Analytics

### Operational insights into energy-driven service availability and power-related incidents

## 📊 Dashboard Overview
This dashboard monitors telecom site availability using IoT sensor data. It correlates power failures, DC voltage drops to identify root causes of downtime.

<img width="1283" height="724" alt="image" src="https://github.com/user-attachments/assets/743c749e-3107-4bda-b0bb-60ead66b78a5" />



## Project Overview
This project presents a Power BI dashboard designed to analyze telecom network reliability through energy and operational telemetry data.

The analysis focuses on how power instability impacts service availability by correlating:

- AC power failures
- DC voltage degradation
- Service interruption events
- Downtime duration
- SLA performance

The dashboard transforms raw IoT telemetry into operational reliability insights to support infrastructure monitoring and incident analysis.

## Business Problem 

Telecom network continuity heavily depends on stable DC power systems. During grid failures, battery systems temporarily sustain operations until critical voltage thresholds are reached.

This project models how energy instability affects service continuity and network performance by simulating real-world telecom operational behavior, including:

- AC power outages
- Battery discharge behavior
- Voltage instability
- Service downtime events

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

### Key Operational Insights

RAN infrastructure contributes the majority of service downtime exposure
Critical infrastructure maintains near-perfect availability due to stronger redundancy
Incident frequency alone is not a sufficient reliability indicator — outage duration (MTTR) significantly impacts availability
SLA breaches on critical sites may result from stricter availability thresholds rather than severe outages
Network resilience varies significantly across infrastructure categories


---
## Deep Dive Analysis

### 1. Infrastructure Performance & Resilience

The analysis reveals significant differences in resilience across telecom infrastructure categories, highlighting how power stability directly impacts service continuity.


### RAN Sites (Radio Access Network)
RAN Vulnerability (Radio Access Network)

RAN infrastructure represents the primary source of service degradation across the network.

### Key Findings
- SITE_RAN_01 and SITE_RAN_02 generate the majority of downtime exposure.
- RAN sites show the highest incident frequency across all infrastructure categories.
- Recovery times vary significantly between sites, despite similar power failure patterns.

### Operational Insight

This indicates that network performance degradation is influenced not only by power failures, but also by:

- Battery health conditions
- Site energy autonomy
- Load distribution
- Recovery efficiency (MTTR)

RAN sites demonstrate lower resilience to grid instability compared to core infrastructure.


### Central Office (CO) Stability

Central Office sites maintain moderate downtime levels while demonstrating stronger operational resilience.Moderate downtime (0.42h) with high Resilience (~60%).

### Key Findings
- Lower downtime impact compared to RAN sites
- More stable recovery performance
- Improved service continuity during AC failures

### Operational Insight

CO infrastructure appears better equipped to absorb temporary power instability without triggering service interruption events, suggesting:

- Better backup power sizing
- Improved energy redundancy
- More stable operational environments





### Critical Infrastructure Resilience (Data Center & Submarine)**

Critical infrastructure maintains near-perfect availability across the observed period.

### Key Findings
- Availability remains between 99.99% and 100%
- Downtime events are extremely short-lived
- SLA breaches occasionally occur despite minimal downtime

### Operational Insight

This demonstrates that SLA violations are not always driven by major outages. In highly critical environments, extremely strict SLA thresholds can generate breaches from even minor transient interruptions.

The strong resilience of these sites reflects:

- Higher infrastructure redundancy
- Enhanced backup power strategies
- More robust operational protection mechanisms


This indicates that SLA breaches are not only driven by downtime volume, but also by strict SLA thresholds on critical sites

### 2. Downtime Analysis

Downtime exposure is unevenly distributed across the infrastructure landscape.

### Key Findings
- GSM/RAN infrastructure contributes the majority of total downtime
- Critical infrastructure contributes minimal operational impact
- Service degradation is concentrated within a small subset of sites

### Operational Insight

This concentration effect indicates that network reliability improvements should prioritize targeted infrastructure optimization rather than broad network-wide interventions.

A limited number of underperforming sites drive a disproportionate share of operational impact.
  


### 3.Incident Frequency vs Operational Impact

Incident frequency alone is not sufficient to evaluate infrastructure reliability.

This analysis combines:

- Incident Count
- MTTR (Mean Time To Repair)
- Total Downtime
- Availability Impact

### Key Findings
- 13 service incidents detected during the observed period
- Most incidents remain short-lived
- RAN sites demonstrate significantly lower resilience compared to core infrastructure

### Operational Insight

Availability degradation is strongly influenced by outage duration rather than only failure occurrence.

This highlights the importance of:

- Faster recovery processes
- Energy system optimization
- Battery autonomy improvements
- Operational response efficiency

Reducing MTTR has a direct and measurable impact on SLA performance and service continuity.

### Business Value

This project demonstrates how operational telemetry and infrastructure monitoring data can be transformed into actionable reliability intelligence.

The analytical framework supports:

- Identification of high-risk infrastructure segments
- SLA compliance monitoring and optimization
- Downtime reduction strategies
- Infrastructure investment prioritization
- Early detection of operational vulnerabilities
- Energy resilience assessment
- Data-driven maintenance planning

By correlating power events, voltage behavior, and service interruptions, this solution enables a proactive operational approach instead of reactive incident management.

The project also illustrates how IoT telemetry can be leveraged to support operational decision-making in telecom environments through scalable SQL engineering and business-oriented analytics.Business Value



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













