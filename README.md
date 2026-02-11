###  DC-Infrastructure-Monitoring-ETL
End-to-end BI solution: Transforming 20M+ IoT records into actionable maintenance insights using SQL Server, SSIS, and Power BI. DC Voltage Monitoring & Infrastructure Availability

## Project Context & Background
Infrastructure Monitoring is a critical function for modern telecommunications providers. This project focuses on DC Power Infrastructure, utilizing high-frequency sensor data collected via the SensDesk monitoring platform. 

The project was developed to provide an end-to-end analytical solution for managing a vast network of **134** monitoring **sites** categorized into four distinct types: **GSM**, **MSAN**, **Data Centers**, and **Submarine Cable** hubs. With data volumes exceeding **20 Million records**, the core challenge was to transform high-frequency IoT sensor logs into strategic maintenance insights.

The complete operational dataset spans from **October 2024** to **January 2026**. However, for the purpose of this portfolio a high-density strategic subset of **5 months (July 2025 – November 2025)** was extracted, representing approximately **7.2 Million logs**.

Reporting to the Maintenance Operations Manager, this comprehensive review evaluates infrastructure performance across several key areas:

## Northstar Metrics & Goals

**Operational Availability**: Maintaining a high uptime standard across all sectors, currently tracked at **99.52%**.
* **Risk Mitigation**: Utilizing a custom **DC Alarm Impact Score** to shift focus from raw alarm volume to infrastructure criticality.
* **Infrastructure Health**: Monitoring the **Alarm Rate (currently 0.48%)** to identify sectors needing hardware reinforcement, such as the **North sector (40.1% of alarms)**.
* **Asset Lifecycle**: Ensuring continuous data lineage during hardware replacements through robust **SCD Type 2 logic** in the database.
* **Data Integrity**: Maintaining a **99.99%** valid record rate after ETL cleaning.



## Monthly Performance & Recovery Analysis
1.** The Q3 Infrastructure Crisis (July - August)**

**Performance Dip**: July and August saw the lowest availability levels at 99.80% and 99.79% respectively.

**Correlation with Volume**: This period matches the massive surge in GSM (Violet) and MSAN (Vert) alarms, peaking at 3,000 incidents per category in August.

**Operational Insight**: The drop to 99.79% represents a critical stress test for the network, where high-intensity maintenance was required to prevent a total service blackout.

2.** The Q4 Resilience & "Clean Slate" (September - November)**

**V-Shaped Recovery**: A spectacular recovery began in September, with availability jumping to 99.95%.

**Peak Stability**: October reached the "Gold Standard" of 99.97% availability, coinciding with the near-total elimination of alarms (~0K logs) during that period.

**Efficiency Gains**: The maintenance actions taken post-August  resulted in a stabilized performance of 99.95% in November, but still we have a little down because oct was is 99.97.

3. **Weighted Impact & Site Priority**

<img width="597" height="273" alt="impact score" src="https://github.com/user-attachments/assets/0e4f17fa-0f85-4243-aca1-74e1d6389a7d" />


The SITE-040 Focus: Despite the high volume of MSAN noise, the recovery was driven by prioritizing high-impact sites.

Insight: SITE-040 (GSM), although 2nd in volume, carried a record 11.6K Impact Score, proving that stabilizing this specific node was key to restoring the overall 99.89% global average.



## Data Privacy & Granularity
**Confidentiality Measures**
Full Anonymization: All sensitive identifiers (Site Names, Sensor IDs, GPS) have been completely anonymized.

**Data Obfuscation**: Raw voltage readings include controlled noise to protect proprietary thresholds while preserving 100% of the analytical logic.

**Technical Granularity**
IoT Frequency: Sensors report status every 5 minutes per site.

High-Resolution Tracking: Each "alarm" corresponds to a specific 5-minute cycle where critical thresholds were breached, allowing for precise tracking of incident duration.
---

### Table Relationships & Cardinality:
- **Fact_Sensor_Alarm ↔ Dim_Site (N:1):** Links every alarm record to its specific site metadata (Sector, Priority, Type) via `SiteKey`.
- **Fact_Sensor_Alarm ↔ Calendrier (N:1):** Enables Time Intelligence (Q3/Q4 analysis) through a standard date link.
- **Fact_Sensor_Alarm ↔ Dim_Sensor_Lifecycle (N:1):** Connects raw readings to the hardware asset's service history, ensuring continuity even if a sensor is replaced.

---


1. Resilience & Recovery Cycles
Peak Crisis: July and August were the most volatile months, with availability dropping to a low of 99.79% due to high thermal stress on GSM and MSAN equipment.

Operational Turnaround: A robust "V-shaped" recovery saw availability climb to 99.97% by October, driven by effective maintenance interventions.

Asset Stability: Submarine Cables and Data Centers maintained superior resilience, consistently staying above the 99.94% SLA target.

2. Regional Performance Dynamics
Historical West Volatility: On a global scale, the West Sector dominated the incident logs, accounting for 51.7% of total project alarms.

West Success Model: By November, the West region achieved a total turnaround with only 50 alarms and a record 99.99% availability.

Emerging North Vulnerability: In November, the North Sector spiked to represent 82% of all network incidents, signaling a shift in regional focus.

3. Technical Site-Level Insights
Risk vs. Volume: While SITE-119 had the highest alarm count (2.2K), SITE-040 was the true priority with a record 11.6K Impact Score.

SITE-096 Criticality: Located in the North, this site became the top November outlier with 589 alarms and a high 2.9K Impact Score.

Early Warning Accuracy: 93.41% of November incidents were detected at the P2-High level, allowing for resolution before escalating to P1 failures.

4. Strategic Recommendations
Priority Audits: Immediately mobilize field teams for SITE-096 (North) and SITE-040 to address their high Impact Scores and prevent service outages.

Seasonal Prevention: Standardize cooling and power infrastructure audits every June to mitigate recurring August thermal surges.

Resource Reallocation: Shift maintenance resources from the now-stabilized West and South sectors toward the North to handle localized instability.

3. Quarterly Insights & Seasonal Trends
1. Resilience & Recovery Cycles:

Summer Vulnerability: Availability reached critical lows in July (99.80%) and August (99.79%) due to peak thermal stress on GSM and MSAN equipment.

V-Shaped Rebound: A sharp performance turnaround occurred in September (99.95%), peaking at 99.97% in October.

Asset Stability: Submarine Cables and Data Centers remained stable anchors, consistently staying above the 99.94% target line.

2. Regional Performance Dynamics:

Historical West Volatility: On a project scale, the West Sector was the primary source of instability, accounting for 51.7% of total global alarms.

West Success Model: By November, the West region achieved a complete turnaround with only 50 alarms and a record 99.99% availability.

Emerging North Vulnerability: In November, the North Sector spiked to represent 82% of all network incidents (597 logs), signaling a shift in regional focus.

3. Technical Site-Level Insights:

Risk vs. Volume: While SITE-119 generated the most noise (2.2K logs), SITE-040 was the true priority with a record 11.6K Impact Score.

SITE-096 Criticality: Located in the North Sector, this site became the top November outlier with 589 alarms and a high 2.9K Impact Score.

Early Warning Accuracy: 93.41% of November incidents were detected as P2 - High, allowing for resolution before escalating to P1 failures.

4. Key Takeaways & Recommendations:

Priority North Audit: Immediately deploy field teams to SITE-096 in the North to resolve the 589 persistent alarms detected in November.

Impact-Based Maintenance: Prioritize an immediate audit of SITE-040 due to its record 11.6K Impact Score to protect long-term global availability.

Seasonal Hardening: Standardize cooling and power audits every June to prevent the recurring 3,000-alarm surge observed during peak summer months.
### Project Overview
This project is an **End-to-End BI Solution** designed to monitor DC Voltage Sensors across a distributed network of telecommunication sites. It manages the complete data lifecycle, from raw IoT ingestion to high-level strategic visualization.

### Key Highlights:
- **Volume:** Processed **20 Million+ raw records**.
- **Stack:** SQL Server, SSIS (ETL), Power BI (DAX).
- **Engineering:** Automated ingestion with Foreach Loop containers and Site-Sensor lifecycle management (SCD Type 2 logic).

---

### Data Pipeline Architecture

1. **Extraction (SSIS):** Monthly CSV files are ingested via an automated **Foreach Loop Container**.
2. **Management:** Files are moved to an `/Archive` folder post-ingestion to ensure idempotency and prevent duplicates.
3. **Transformation (T-SQL):** Data is cleaned and filtered (July-Nov) at the SQL level for optimal performance.
4. **Modeling (Power BI):** A **Star Schema** connects sensor data to site metadata and a custom calendar table.

### 1. Extraction & Automation (SSIS)
The ingestion process is fully automated to handle high-volume CSV logs efficiently.

#### **Control Flow: Iteration & Archiving**
<img width="369" height="305" alt="image" src="https://github.com/user-attachments/assets/1df73182-58d1-4f21-a4c8-e5077dcf9a96" />

*Figure 1: Loop container for batch processing and automated file archiving.*

#### **Data Flow: Ingestion**
<img width="296" height="281" alt="image" src="https://github.com/user-attachments/assets/d04fb063-42b0-4bce-94a4-f7472de73ace" />

*Figure 2: Direct mapping from raw flat files to the SQL Staging environment.*
   


###  Data Quality Audit
To ensure the reliability of maintenance alerts, I performed a final audit of the processed data. The system achieves a **99.99% accuracy rate** by isolating outliers.

| DataStatus | RecordCount | Percentage |
| :--- | :--- | :--- |
| **VALID** | 7,911,008 | **99.99%** |
| OUTLIER: NEGATIVE | 1,114 | 0.01% |

> **Note:** Only "VALID" records are used for calculating the 99.52% Availability KPI in the dashboard.

---

Sensor Lifecycle & Site Continuity (SCD Logic)
To ensure **uninterrupted site availability tracking**, I implemented a Slowly Changing Dimension (SCD) logic within the `Dim_Sensor_Lifecycle` table.

- **Seamless Transition:** When a faulty sensor is replaced, the model links the new Hardware ID to the same `SiteKey`.
- **Availability Integrity:** This prevents gaps in the 99.52% availability metric, treating the site as a single continuous entity regardless of hardware swaps.
- **Historical Tracking:** Maintenance teams can audit exactly which sensor was active during a specific voltage drop event.

###  Business Logic & Data Engineering
- **Data Quality:** Implemented a `DataStatus` column to flag `VALID` readings vs `OUTLIERS` (nulls or negative values).
- **Alarm Logic:** `AlarmFlag` triggered at **< 43V**.
- **Impact Scoring:** A custom DAX measure weights alarms by site priority (P1, P2, P3), allowing maintenance teams to focus on critical infrastructure risk.

---

 ### Data Privacy
For confidentiality reasons, all sensitive data (Site Names, exact GPS locations, Sensor IDs) has been **anonymized**. The data structure and logic remain 100% authentic.

---



 Installation & Usage
1. Scripts for table creation and cleaning are located in `/SQL_Scripts`.
2. SSIS logic captures are in `/SSIS_Packages`.
3. The Power BI dashboard preview is available in `/Images`.
---

# 📊 DC Power Infrastructure: Operational Availability & Risk Report

## 📋 Executive Summary
This project provides a data-driven evaluation of infrastructure resilience across **134 critical sites**, leveraging a massive dataset of **1.4 million telemetry logs**. The primary objective was to transform raw alarm data into actionable maintenance strategies by correlating incident frequency with operational impact.

**Key Strategic Insights:**
* **SLA Performance**: The global network maintained a robust availability of **99.95%**, consistently trending near the **99.94% global average baseline** despite severe seasonal fluctuations.
* **Regional Shift**: Analysis reveals a transition in risk zones. While the **West Sector** historically accounted for **51.7%** of total alarms, recent trends show a critical surge in the **North Sector**, which represented **82% of incidents** in November.
* **Impact-Centric Prioritization**: By utilizing weighted **Impact Scores**, we identified that high-volume "noise" sites are often less critical than high-impact nodes like **SITE-040**, which carries a record **11.6K impact score**.

---




## 🔬 Insights Deep-Dive

### **Operational Availability Analysis by Asset Type**
<img width="584" height="286" alt="image" src="https://github.com/user-attachments/assets/5cbbf234-b7e8-43f7-86ad-508276d137ee" />

*(Insert: Operational Availability Tracking - Q3/Q4 Analysis Chart)*

**1. Critical Stability: Submarine Cable & Data Center**
* **Linear Performance**: These categories serve as the network's "stability anchors," maintaining consistent uptime near the **99.94% average baseline** throughout the period.
* **Environmental Resilience**: These assets showed no significant degradation during summer thermal peaks (July-August), confirming superior cooling redundancy.

**2. The "V-Shaped" Recovery: MSAN**
* **Summer Vulnerability**: MSAN sites experienced the most volatile trajectory, dropping below the average baseline in August due to thermal stress on outdoor equipment.
* **Performance Turnaround**: Following a sharp rebound in September, MSAN assets ended the period as the top-performing category in November.

**3. Strategic Alert: GSM Stability**
* **November Downtrend**: While other asset types stabilized, the GSM segment entered a **sharp decline in November**, falling below the dynamic average.
* **Alarm Volume Correlation**: This drop is validated by a massive spike of **728 alarms** in November, concentrated almost exclusively within the GSM category.
* **Localized Failure**: This trend was primarily driven by **SITE-096 (GSM)** in the North Sector, which alone accounted for over **80% of the month's total alarm volume**.

---

## 💡 Key Takeaways & Recommendations

* **Immediate Field Action**: Deploy priority technical teams to **SITE-096 (North)** to resolve the GSM stability issues identified in November.
* **Impact-Driven Maintenance**: Prioritize site audits based on **Impact Scores** (e.g., SITE-040) rather than raw alarm volume.
* **Seasonal Prevention**: Standardize infrastructure cooling audits every **June** to mitigate recurring thermal stress spikes observed in July and August.
