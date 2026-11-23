USE Hospital_Management; 
SHOW TABLES; 
SELECT COUNT(*) FROM patients; 
SELECT COUNT(*) FROM appointments; 

SELECT * FROM patients;
SELECT * FROM departments;
SELECT * FROM doctors;
SELECT * FROM patients;
SELECT * FROM rooms;
SELECT * FROM admissions;
SELECT * FROM prescriptions;
SELECT * FROM billing;
SELECT * FROM appointments;

-- Find the top 5 departments by total billing revenue.

select
    d.department_name,
    sum(b.total_amount) as total_revenue
from billing b
left join appointments a
    on b.appointment_id = a.appointment_id
left join admissions ad
    on b.admission_id = ad.admission_id
join doctors doc
    on doc.doctor_id = coalesce(a.doctor_id, ad.doctor_id)
join departments d
    on doc.department_id = d.department_id
group by d.department_id, d.department_name
order by total_revenue desc
limit 5;

-- Calculate Cancellation and No-Show Rates for Each Department 

select
    d.department_name,
    count(a.appointment_id) as total_appointments,
    sum(case when a.status = 'Cancelled' then 1 else 0 end)
    as cancelled_appointments,
    sum(case when a.status = 'No-Show' then 1 else 0 end)
    as no_show_appointments,
    round(sum(case when a.status = 'Cancelled' then 1 else 0 end)
        / count(a.appointment_id) * 100, 2)
        as cancellation_rate,
    round(sum(case when a.status = 'No-Show' then 1 else 0 end)
        / count(a.appointment_id) * 100, 2)
        as no_show_rate
from departments d
join doctors doc
    on d.department_id = doc.department_id
join appointments a
    on doc.doctor_id = a.doctor_id
group by d.department_name;

-- Find Rooms That Have Never Been Used for an Admission 
 
 select
    r.room_id, r.room_number, r.room_type
from rooms r
left join admissions a
    on r.room_id = a.room_id
where a.room_id is null;

 






















    