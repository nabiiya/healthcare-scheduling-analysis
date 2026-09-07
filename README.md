# Healthcare Appointment Scheduling Analysis

Healthcare appointment scheduling analysis using Python, PostgreSQL, SQL, and Tableau to evaluate no-shows, wait times, late starts, and slot utilization.

## Dashboard
<img width="1228" height="1090" alt="Dashboard" src="https://github.com/user-attachments/assets/2b62ec6c-1768-48f3-9cc2-127a5386ece9" />


[View the Interactive Dashboard on Tableau Public (https://public.tableau.com/app/profile/caitlin.g4506/viz/Healthcare_appt_efficiency_dashboard/Dashboard?publish=yes)

## Business Problem

How can a medical office improve appointment scheduling efficiency, reduce patient wait times, minimize no-shows and cancellations, and better utilize available appointment slots?

## Tools

- **Python (Pandas)** – Data cleaning and feature engineering
- **PostgreSQL / SQL** – Data analysis
- **Tableau** – Data visualization and dashboard development

## Dataset

This project uses a synthetic medical appointment scheduling dataset informed by published healthcare research. The dataset includes appointment scheduling, attendance, wait times, slot availability, and patient demographic information.

[View Dataset on Kaggle](https://www.kaggle.com/datasets/carogonzalezgaltier/medical-appointment-scheduling-system)

## Key Findings

- **Wait times increased throughout the day**, from 27.18 minutes in the morning to 65.96 minutes in the evening.
- **81.03% of attended appointments started late.**
- **89.34% of appointment slots were occupied**, while 82.44% resulted in completed appointments.
- **Scheduling lead time had little relationship with no-shows**, with rates remaining around 7% across booking intervals.
- **Age was not a major differentiator** in attendance or wait-time patterns.

## Project Files

- `python/appointment_analysis.ipynb` – Data cleaning and preparation
- `sql/healthcare_analysis.sql` – SQL queries used for analysis
- `dashboard/healthcare_dashboard.twbx` – Tableau dashboard
