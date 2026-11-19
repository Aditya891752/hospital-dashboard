# Hospital Management & Healthcare Analytics Database

An end-to-end relational database system and business intelligence SQL project designed for a multi-specialty hospital in Delhi NCR. Built with SQLite / DB Browser for SQLite, featuring a normalized relational schema, sample operational records, and 15 analytical queries covering clinical operations and hospital revenue.

---

## Project Overview
* **Domain:** Healthcare Management & Hospital Operations
* **Database Engine:** SQLite (compatible with DB Browser for SQLite, DBeaver, PostgreSQL, MySQL)
* **Key Focus Areas:** Patient flow, doctor workloads, ward bed occupancy rates, revenue by department, medication trends, insurance settlement ratios, and length of stay (LOS).

---

## Database Architecture (Schema)

The database consists of **6 normalized relational tables** enforcing primary and foreign key constraints:

```
 wards (ward_id PK)
   ├── doctors (doctor_id PK, ward_id FK)
   └── patients (patient_id PK, ward_id FK, doctor_id FK)
         ├── appointments (appointment_id PK, patient_id FK, doctor_id FK)
         ├── medications (med_id PK, patient_id FK, doctor_id FK)
         └── billing (bill_id PK, patient_id FK)
```

### Table Breakdown:
1. **`wards`**: Department details, bed capacity (`total_beds`, `occupied_beds`), floor assignments, and head nurse contacts.
2. **`doctors`**: Physician profiles, specializations, qualifications, experience years, and ward mappings.
3. **`patients`**: Inpatient/outpatient records, demographics (age, gender, blood group), diagnoses, admission/discharge dates, and emergency indicators.
4. **`appointments`**: Consultation schedules, appointment status (Completed, Scheduled, Cancelled, No-Show), and consultation fees.
5. **`medications`**: Prescriptions, dosages, frequency, duration, and medicine costs.
6. **`billing`**: Financial transactions, itemized charges (room, doctor, lab, pharmacy), insurance coverage, copay amounts, and payment statuses (Paid, Partial, Pending).

---

## Analytical Queries Included

The SQL file contains 15 business and clinical analytical queries:

| Query | Business Question / Objective | SQL Concepts Used |
|---|---|---|
| **Query 1** | Identify currently admitted inpatients with length of stay | `JULIANDAY()`, Date calculations, `WHERE` filter |
| **Query 2** | Doctor workload & consultation revenue across departments | `COUNT()`, `SUM()`, `JOIN`, `GROUP BY`, `ORDER BY` |
| **Query 3** | Revenue breakdown & average billing by hospital ward | Multi-table `JOIN`, Aggregations, Currency rounding |
| **Query 4** | Top 10 most frequently prescribed medications | `COUNT()`, `SUM()`, `ORDER BY DESC LIMIT` |
| **Query 5** | Patient age distribution & demographic segmentation | `CASE WHEN` bucketing, Demographics grouping |
| **Query 6** | Real-time ward bed occupancy rate (%) | `CAST` to REAL, Percentage formulas, Capacity alerts |
| **Query 7** | Billing payment status summary (Paid vs Pending vs Partial) | Financial reconciliation, Multi-status aggregation |
| **Query 8** | Monthly admissions volume & seasonal trends | `STRFTIME()` date parsing, Trend analysis |
| **Query 9** | High-cost emergency cases (> ₹50,000) | Filtering high-value incidents, Priority tracking |
| **Query 10** | Patients with multiple diagnoses or repeat visits | `HAVING COUNT() > 1`, Readmission identification |
| **Query 11** | Doctor revenue contribution (consultations + patient billing) | `LEFT JOIN`, Correlated aggregation |
| **Query 12** | Blood group distribution for blood bank readiness | Group frequency analysis |
| **Query 13** | Insurance provider claim settlement & coverage efficiency | Insurance vs Out-of-pocket ratio analysis |
| **Query 14** | Average Length of Stay (ALOS) across departments | Inpatient efficiency benchmarking |
| **Query 15** | Geographic footprint of patients across NCR cities | Regional catchment area analytics |

---

## Key Clinical & Operational Insights

* **Top Revenue Drivers:** Cardiology (₹4.77L) and Orthopedics (₹4.69L) generate the highest cumulative revenue, followed by ICU (₹3.94L).
* **Bed Capacity Pressure:** General Medicine (80.0%), ICU (75.0%), and Cardiology (75.0%) operate near peak occupancy.
* **Emergency Cases:** Emergency admissions exhibit longer lengths of stay and significantly higher itemized pharmacy and laboratory costs.

---

## How to Run & Explore

### Option 1: DB Browser for SQLite (GUI)
1. Download and open [DB Browser for SQLite](https://sqlitebrowser.org/).
2. Click **Open Database** and select `hospital_management.db`.
3. Switch to the **Execute SQL** tab to run any query from `hospital_management.sql`.

### Option 2: SQLite Command Line
```bash
sqlite3 hospital_management.db < hospital_management.sql
```

### Option 3: Python
```python
import sqlite3

con = sqlite3.connect("hospital_management.db")
cursor = con.cursor()

# Run any query, for example:
cursor.execute("SELECT ward_name, occupied_beds, total_beds FROM wards;")
for row in cursor.fetchall():
    print(row)
```
