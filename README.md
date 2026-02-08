###  DC-Infrastructure-Monitoring-ETL
End-to-end BI solution: Transforming 20M+ IoT records into actionable maintenance insights using SQL Server, SSIS, and Power BI. DC Voltage Monitoring & Infrastructure Availability

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
