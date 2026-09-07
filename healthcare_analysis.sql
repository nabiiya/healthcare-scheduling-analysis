/*
Healthcare Appointment Scheduling Efficiency Analysis

Purpose: 
	Analyze appointment scheduling performance, no-shows, cancellations, 
	patient wait times, slot utilization, late starts, and age-group patterns.

*/

-- Table set up 

CREATE TABLE appointments (
    appointment_id BIGINT,
    slot_id BIGINT,
    scheduling_date DATE,
    appointment_date DATE,
    appointment_time TIME,
    scheduling_interval INTEGER,
    status VARCHAR(30),
    check_in_time TIME,
    appointment_duration NUMERIC,
    start_time TIME,
    end_time TIME,
    waiting_time NUMERIC,
    patient_id BIGINT,
    sex VARCHAR(20),
    age INTEGER,
    age_group VARCHAR(30),
    appointment_day VARCHAR(20),
    appointment_hour INTEGER,
    time_period VARCHAR(20)
);

CREATE TABLE slots (
    slot_id BIGINT,
    appointment_date DATE,
    appointment_time TIME,
    is_available BOOLEAN
);

-- Calculates the no-show rate among appointments with a known attendance outcome.

SELECT
    COUNT(*) FILTER (WHERE status = 'did not attend') AS no_shows,
    COUNT(*) AS attendance_outcomes,
    ROUND(
        COUNT(*) FILTER (WHERE status = 'did not attend') * 100.0
        / COUNT(*),
        2
    ) AS no_show_rate
FROM appointments
WHERE status IN ('attended', 'did not attend');

-------------------------------------------------------------------------------------------

-- QUESTION 1: Which appointment times have the highest no-show and cancellation rates?

-- No-show rate by time of day.

SELECT
    time_period,
    COUNT(*) AS total_appointments,
    COUNT(*) FILTER (
        WHERE status = 'did not attend'
    ) AS no_shows,
    ROUND(
        COUNT(*) FILTER (WHERE status = 'did not attend') * 100.0
        / COUNT(*),
        2
    ) AS no_show_rate
FROM appointments
WHERE status IN ('attended', 'did not attend')
GROUP BY time_period
ORDER BY no_show_rate DESC;

-- Cancellation rate by time of day.

SELECT
    time_period,
    COUNT(*) AS total_appointments,
    
    COUNT(*) FILTER (
        WHERE status = 'cancelled'
    ) AS cancellations,
    
    ROUND(
        COUNT(*) FILTER (WHERE status = 'cancelled') * 100.0
        / COUNT(*),
        2
    ) AS cancellation_rate

FROM appointments

WHERE status IN ('attended', 'did not attend', 'cancelled')

GROUP BY time_period

ORDER BY cancellation_rate DESC;

-------------------------------------------------------------------------------------------

-- QUESTION 2: Does booking farther ahead affect no-shows?

SELECT
    CASE
        WHEN scheduling_interval BETWEEN 1 AND 3 THEN '1-3 days'
        WHEN scheduling_interval BETWEEN 4 AND 7 THEN '4-7 days'
        WHEN scheduling_interval BETWEEN 8 AND 14 THEN '8-14 days'
        WHEN scheduling_interval BETWEEN 15 AND 30 THEN '15-30 days'
    END AS scheduling_group,

    COUNT(*) AS total_appointments,

    COUNT(*) FILTER (
        WHERE status = 'did not attend'
    ) AS no_shows,

    ROUND(
        COUNT(*) FILTER (WHERE status = 'did not attend') * 100.0
        / COUNT(*),
        2
    ) AS no_show_rate

FROM appointments

WHERE status IN ('attended', 'did not attend')

GROUP BY scheduling_group

ORDER BY MIN(scheduling_interval);

-------------------------------------------------------------------------------------------

-- QUESTION 3: Which days and times have the longest patient wait times? 

-- Average waiting time by day of week. 

SELECT
    appointment_day,
    COUNT(*) AS attended_appointments,
    ROUND(AVG(waiting_time), 2) AS avg_waiting_time
FROM appointments
WHERE status = 'attended'
GROUP BY appointment_day
ORDER BY avg_waiting_time DESC;

-- Average waiting time by time of day (morning, afternoon, evening).

SELECT
    time_period,
    COUNT(*) AS attended_appointments,
    ROUND(AVG(waiting_time), 2) AS avg_waiting_time
FROM appointments
WHERE status = 'attended'
GROUP BY time_period
ORDER BY avg_waiting_time DESC;

-------------------------------------------------------------------------------------------

-- Question 4: What percentage of appointment slots are utilized?

-- Slot occupancy rate: percentage of scheduling slots marked as unavailable/booked.

SELECT
    COUNT(*) AS total_slots,

    COUNT(*) FILTER (
        WHERE is_available = FALSE
    ) AS occupied_slots,

    COUNT(*) FILTER (
        WHERE is_available = TRUE
    ) AS available_slots,

    ROUND(
        COUNT(*) FILTER (WHERE is_available = FALSE) * 100.0
        / COUNT(*),
        2
    ) AS slot_occupancy_rate

FROM slots;

-- Completed utilization rate. 
-- Percentage of total slots that resulted in an attended appointment.

SELECT
    COUNT(DISTINCT s.slot_id) AS total_slots,

    COUNT(DISTINCT a.slot_id) FILTER (
        WHERE a.status = 'attended'
    ) AS attended_slots,

    ROUND(
        COUNT(DISTINCT a.slot_id) FILTER (
            WHERE a.status = 'attended'
        ) * 100.0
        / COUNT(DISTINCT s.slot_id),
        2
    ) AS completed_utilization_rate

FROM slots s

LEFT JOIN appointments a
    ON s.slot_id = a.slot_id;

-------------------------------------------------------------------------------------------

-- QUESTION 5: How frequently do appointments start later than scheduled?

SELECT
    COUNT(*) AS attended_appointments,

    COUNT(*) FILTER (
        WHERE start_time > appointment_time
    ) AS late_appointments,

    ROUND(
        COUNT(*) FILTER (WHERE start_time > appointment_time) * 100.0
        / COUNT(*),
        2
    ) AS late_start_rate

FROM appointments
WHERE status = 'attended';

-------------------------------------------------------------------------------------------

-- QUESTION 6: Do wait times or attendance patterns differ across patient age groups?

SELECT
    age_group,

    COUNT(*) FILTER (
        WHERE status IN ('attended', 'did not attend')
    ) AS attendance_outcomes,

    ROUND(
        COUNT(*) FILTER (WHERE status = 'did not attend') * 100.0
        / NULLIF(
            COUNT(*) FILTER (
                WHERE status IN ('attended', 'did not attend')
            ), 0
        ),
        2
    ) AS no_show_rate,

    ROUND(
        AVG(waiting_time) FILTER (WHERE status = 'attended'),
        2
    ) AS avg_waiting_time

FROM appointments

GROUP BY age_group

ORDER BY age_group;





