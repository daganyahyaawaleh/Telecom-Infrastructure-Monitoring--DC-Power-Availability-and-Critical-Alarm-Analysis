#  Telecom Network Availability & Incident Analysis

### Operational insights into energy-driven service availability and power-related incidents

This project presents a Power BI dashboard designed to monitor telecom site energy performance and service availability.



##  Project Background

The reliability of telecom networks heavily depends on the stability of their power systems. In many environments, telecom sites rely on rectifiers to convert AC grid power into stable DC output, ensuring service continuity making it essential to understand the relationship between power events and service outages.

In real-world operations, a site does not immediately go down during a power failure. Instead, battery systems sustain the service until a critical voltage threshold is reached. Generator backup systems were not explicitly modeled. Critical sites(e.g., Data Centers, Submarine) are assumed to have generator support.

This project analyzes how energy conditions impact **service availability, downtime, and network performance**.
The objective is to evaluate service availability, detect incidents, and provide actionable insights into network performance.

The SQL queries used to prepare, transform, and analyze the data are organized as follows:

- Data cleaning and preparation queries can be found [here](SQL_Scripts/01_create_dim_site.sql)
- Sensor-to-site mapping  can be found [here](.SQL_Scripts/02_mapping_clean.sql)
- Time-series structuring and pivot logic can be found [here](.SQL_Scripts/03_sensor_data_final.sql)
- Event detection (AC failures and service events) can be found [here](SQL_Scripts/04_event_detection.sql)
- Service incident construction  [here](.SQL_Scripts/05_service_incidents.sql)


## key Metrics

- **Service Availability (North Star)** – Focus on the overall percentage of time telecom services remain operational, based on energy conditions (DC voltage threshold). This is the primary indicator of network reliability and user experience.

- **Incident Analysis** – Monitoring the number of service incidents and their frequency to understand how often disruptions occur across sites.

- **Recovery Performance (MTTR)** – Evaluating how quickly the network recovers from outages by analyzing the average duration of service incidents.

- **Network Stability (MTBF)** – Measuring the time between failures to assess the overall stability and robustness of the infrastructure.

- **Downtime Impact** – Analyzing total downtime duration across sites and site types to identify the most critical areas affecting service continuity
- **Site-Type Performance** – Comparing availability and downtime across different telecom site types (RAN, CO, Data Center, Submarine) to identify structural performance differences.

---

##  Real-World Context

This project is inspired by real telecom monitoring operations.In my current role, I manage energy and monitoring data from over 150 telecom sites equipped with IoT sensors (HWg via SensDesk).
- ~1.5 million rows per month ans still growing
- 20+ million rows historically  

Although this project uses synthetic data, it is designed to closely replicate real operational patterns.

---

## Dataset Description

A synthetic dataset was created to simulate realistic telecom conditions:

- 5 telecom sites (**RAN, CO, Data Center, Submarine**)  
- 3-month period  
- 5-minute frequency  
- **AC Status (0/1)** → indicates grid power availability  
- **DC Voltage** 

The dataset reflects real operational patterns such as:
- AC failures  
- battery-supported service continuity  
- service interruptions triggered by voltage drops  

This results in approximately **~388,800 time-series records**.

##  Technical Insight (Energy Layer)

- **Low Voltage Disconnect (LVD)** → service considered down when DC voltage < 43V  
- **Floating Voltage** → normal system voltage ~53–54V  
---


  
## Dataset Structure and ERD (Entity Relationship Diagram) 

The project is based on a time-series dataset (`sensor_data_final`) capturing DC voltage and AC status at 5-minute intervals across telecom sites.

This dataset is enriched with historical sensor-to-site mapping (SCD Type 2) and transformed into event and incident tables to support availability analysis.

*Fact Constellation Schema (multi-fact)*
<img width="1040" height="755" alt="image" src="https://github.com/user-attachments/assets/0b96d077-6d86-43d6-88a9-2f7e4104a277" />



Images/Dataset structure and ERD.PNG

---


##  Executive Summary


The network maintains a **high level of availability (~99.98%)** across all site types, indicating strong overall performance.

However, performance is not uniform:

- **RAN sites show the lowest availability**, particularly in February, highlighting higher sensitivity to power-related disruptions  
- **Data Center and Submarine sites maintain near-perfect availability**, reflecting stronger resilience  
- **CO sites show stable performance**, with slight improvement over time

While the network is globally stable, **availability differences across site types reveal structural weaknesses**, with RAN infrastructure being the most impacted.
This analysis focuses on energy-driven availability, highlighting the impact of power conditions on service performance.

---


<img width="1099" height="409" alt="image" src="https://github.com/user-attachments/assets/335b1d6e-348f-4dae-8bcb-ee01dc054808" />





GSM sites contribute the most to service downtime.
Voltage drops below the critical threshold (43V) directly correlate with service outages.
Some site types do not meet their SLA targets despite high overall availability.
Overall Availability remains close to SLA targets.

---
## Deep Dive Analysis

### 1 Site-Level Performance & Resilience Analysis
The analysis highlights significant differences in performance and resilience across site types.

<img width="901" height="331" alt="image" src="https://github.com/user-attachments/assets/2f85d4f6-690e-4d88-ab14-39e19416e40c" />

**MainsFail** → AC power interruptions (grid failure events)  

**Incident** → service outages occurring when DC voltage drops below the operational threshold (43V)

 1. RAN Sites

RAN sites (SITE_GSM_01 and SITE_GSM_02) contribute the **majority of downtime** (1.08h and 0.83h)
They also have the **highest number of incidents (4 each)**
Although both RAN sites have the same number of incidents, one site experiences longer outage durations.

This suggests differences in incident recovery conditions, which may be related to:
- energy system performance (battery behavior)
- site load conditions
- operational response time

 This indicates that performance degradation is not only driven by failure frequency, but also by recovery efficiency.


 2. CO Sites: 

CO sites show **moderate downtime (0.42h)** and fewer incidents (2)
**Resilience is higher (~60%)**, indicating better ability to absorb AC failures without impacting service

This suggests stronger energy backup performance compared to RAN sites.

 3. Critical Infrastructure: High Stability but Strict SLA Sensitivity

Data Center and Submarine sites show **very low downtime (0.08h – 0.17h)**
Availability is close to or at **100%**
Despite strong performance, these sites  still fall below SLA due to **very strict availability requirements**

<img width="874" height="174" alt="image" src="https://github.com/user-attachments/assets/8824d091-4ea7-49a0-af75-c4240d99aa9d" />

This indicates that SLA breaches are not only driven by downtime volume, but also by strict SLA thresholds on critical sites

### 2. Downtime Distribution

- **GSM sites contribute the majority of downtime**.
- Other site types show minimal impact.
- This indicates uneven infrastructure resilience.
  
  <img width="623" height="251" alt="image" src="https://github.com/user-attachments/assets/fc5ba5e5-c5c5-44dc-a73d-859b8317cddc" />

---

### 3. Incident Frequency vs Downtime Impact

Incident count alone does not fully explain service performance. Some sites are affected by a higher number of incidents, while others experience fewer but more impactful outages.
Combining Incident Count, MTTR, and Downtime provides a more complete view of operational risk.

- A total of **13 service incidents** were detected.
- Most incidents are **short in duration**, limiting their impact.
- Failures are generally well contained and quickly resolved.

The analysis shows that resilience to power failures varies significantly across site types.

- RAN sites (radio access) show lower resilience (~43%), meaning a large proportion of AC failures result in service outages  
- Core/CO sites show higher resilience (~60%), indicating better ability to absorb power disruptions
- This suggests that radio sites are more dependent on battery performance and are more vulnerable to energy-related service interruptions.
  
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

-MainsFail → AC status changes from 1 to 0
-MainsRestore → AC status changes from 0 to 1
-ServiceDown → DC voltage drops below 43V
-ServiceRestored → DC voltage returns above threshold

This step converts raw signals into meaningful operational events.

### 5. Incident Construction

Service incidents are built by grouping events:

-Each incident starts at ServiceDown
-Ends at ServiceRestored
-Duration is calculated in hours

This results in an incident-level table, which is used as the primary source for downtime calculations.

### 6. KPI Calculation

All business metrics are derived from the incident and time-series data:

Availability (%) → based on downtime vs observed time
MTTR → average incident duration
MTBF → time between incidents
Incident Count → number of outages

This ensures accurate and reliable performance measuremen  



### Limitations

- Synthetic dataset
- No battery capacity or State of Health (SOH) data
- Generator behavior is not modeled

These limitations simplify the analysis but do not affect the overall insights.

### Tools Used

- SQL Server (SSMS)  
- Power BI  
- DAX  

---

### Author

Data Analyst specialized in telecom energy monitoring and performance analysis.


### Future Improvements

- Integration of real telecom datasets  
- Battery autonomy analysis  















