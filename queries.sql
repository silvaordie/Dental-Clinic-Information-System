1-   Pronta

 select distinct client.VAT, client.name, phone_number_client.phone  
 from client, consultation, employee, appointment , phone_number_client 
 where employee.name = "Jane Sweettooth" and employee.VAT = appointment.VAT_doctor
 and appointment.date_timestamp = consultation.date_timestamp  
 and appointment.VAT_doctor=consultation.VAT_doctor  and appointment.VAT_client = client.VAT 
 and client.VAT  = phone_number_client.VAT 
 order by client.name;

	
2- Pronta

(select emp_t.name as name_trainee, emp_t.VAT as VAT_trainee ,emp_d.name as name_doctor , emp_d.VAT as VAT_doctor, supervision_report.evaluation,supervision_report.description
from employee as emp_t, supervision_report, employee as emp_d, trainee_doctor
where emp_t.VAT = supervision_report.VAT and trainee_doctor.supervisor=emp_d.VAT
and supervision_report.evaluation < 3)
union
(select emp_t.name as name_trainee, emp_t.VAT as VAT_trainee ,emp_d.name as name_doctor , emp_d.VAT as VAT_doctor, supervision_report.evaluation,supervision_report.description
from employee as emp_t, supervision_report, employee as emp_d, trainee_doctor
where emp_t.VAT = supervision_report.VAT and trainee_doctor.supervisor=emp_d.VAT and supervision_report.description like '%insufficient%' );



3- Pronta

select distinct client.name, client.city, client.VAT, consultation.SOAP_O
from client, appointment, consultation
where appointment.VAT_client = client.VAT and consultation.date_timestamp=appointment.date_timestamp 
and appointment.VAT_doctor = consultation.VAT_doctor and (consultation.SOAP_O like '%gingivitis%' or consultation.SOAP_O like '%periodontitis%')
and consultation.date_timestamp >= all (
select consultation.date_timestamp 
from consultation, appointment
where appointment.VAT_doctor = consultation.VAT_doctor and consultation.date_timestamp=appointment.date_timestamp
and client.VAT = appointment.VAT_client );


4- Pronta

select client.name , client.VAT, client.street, client.city, client.zip
from client, appointment
where client.VAT = appointment.VAT_client and appointment.date_timestamp not in
(select consultation.date_timestamp from consultation);
	

5- Pronta

select diagnostic_code.ID, diagnostic_code.description, count( distinct prescription.name) as counter
from diagnostic_code, consultation_diagnostic, prescription
where  prescription.ID = diagnostic_code.ID and consultation_diagnostic.VAT_doctor=prescription.VAT_doctor 
	and consultation_diagnostic.date_timestamp = prescription.date_timestamp and consultation_diagnostic.ID = prescription.ID
	group by prescription.ID
order by counter asc



6- Pronta

(select avg(nurses), avg(procedures), avg(diagnosis), avg(prescriptions) from
(select count(nurse.n) as nurses from
(select consultation_assistant.VAT_nurse as n, consultation_assistant.VAT_doctor as d, consultation_assistant.date_timestamp as t
from consultation_assistant, appointment, client
where appointment.date_timestamp = consultation_assistant.date_timestamp
and appointment.VAT_doctor = consultation_assistant.VAT_doctor
and extract(year from consultation_assistant.date_timestamp) = '2019'
and client.VAT = appointment.VAT_client and client.age < 18) as nurse
group by nurse.d, nurse.t) as n1,
(select count(proc.n) as procedures from
(select procedure_in_consultation.name as n, procedure_in_consultation.VAT_doctor as d, procedure_in_consultation.date_timestamp as t
from procedure_in_consultation, appointment, client
where appointment.date_timestamp = procedure_in_consultation.date_timestamp
and appointment.VAT_doctor = procedure_in_consultation.VAT_doctor
and extract(year from procedure_in_consultation.date_timestamp) = '2019'
and client.VAT = appointment.VAT_client and client.age < 18) as proc
group by proc.d, proc.t) as n2,
(select count(diagnostic.ID) as diagnosis from
(select consultation_diagnostic.ID as ID,
consultation_diagnostic.VAT_doctor as d, consultation_diagnostic.date_timestamp as t
from consultation_diagnostic, appointment, client
where appointment.date_timestamp = consultation_diagnostic.date_timestamp
and appointment.VAT_doctor = consultation_diagnostic.VAT_doctor
and extract(year from consultation_diagnostic.date_timestamp) = '2019'
and client.VAT = appointment.VAT_client and client.age < 18) as diagnostic
group by diagnostic.d, diagnostic.t) as n3,
(select count(distinct concat(presc.n, presc.l)) as prescriptions from
(select prescription.name as n, prescription.lab as l,
prescription.VAT_doctor as d, prescription.date_timestamp as t
from prescription, appointment, client
where appointment.date_timestamp = prescription.date_timestamp
and appointment.VAT_doctor = prescription.VAT_doctor
and extract(year from prescription.date_timestamp) = '2019'
and client.VAT = appointment.VAT_client and client.age < 18) as presc
group by presc.d, presc.t) as n4)
union all
(select avg(nurses), avg(procedures), avg(diagnosis), avg(prescriptions) from
(select count(nurse.n) as nurses from
(select consultation_assistant.VAT_nurse as n, consultation_assistant.VAT_doctor as d, consultation_assistant.date_timestamp as t
from consultation_assistant, appointment, client
where appointment.date_timestamp = consultation_assistant.date_timestamp
and appointment.VAT_doctor = consultation_assistant.VAT_doctor
and extract(year from consultation_assistant.date_timestamp) = '2019'
and client.VAT = appointment.VAT_client and client.age >= 18) as nurse
group by nurse.d, nurse.t) as n1,
(select count(proc.n) as procedures from
(select procedure_in_consultation.name as n, procedure_in_consultation.VAT_doctor as d, procedure_in_consultation.date_timestamp as t
from procedure_in_consultation, appointment, client
where appointment.date_timestamp = procedure_in_consultation.date_timestamp
and appointment.VAT_doctor = procedure_in_consultation.VAT_doctor
and extract(year from procedure_in_consultation.date_timestamp) = '2019'
and client.VAT = appointment.VAT_client and client.age >= 18) as proc
group by proc.d, proc.t) as n2,
(select count(diagnostic.ID) as diagnosis from
(select consultation_diagnostic.ID as ID,
consultation_diagnostic.VAT_doctor as d, consultation_diagnostic.date_timestamp as t
from consultation_diagnostic, appointment, client
where appointment.date_timestamp = consultation_diagnostic.date_timestamp
and appointment.VAT_doctor = consultation_diagnostic.VAT_doctor
and extract(year from consultation_diagnostic.date_timestamp) = '2019'
and client.VAT = appointment.VAT_client and client.age >= 18) as diagnostic
group by diagnostic.d, diagnostic.t) as n3,
(select count(distinct concat(presc.n, presc.l)) as prescriptions from
(select prescription.name as n, prescription.lab as l,
prescription.VAT_doctor as d, prescription.date_timestamp as t
from prescription, appointment, client
where appointment.date_timestamp = prescription.date_timestamp
and appointment.VAT_doctor = prescription.VAT_doctor
and extract(year from prescription.date_timestamp) = '2019'
and client.VAT = appointment.VAT_client and client.age >= 18) as presc
group by presc.d, presc.t) as n4);

	

7- Pronta 

select p.ID, p.name, p.lab
from prescription as p
group by p.name
having count(p.name) >= all (
select count(p2.name)
from prescription as p2
where p2.ID = p.ID
group by p2.name )

	 
8- pronta

select prescription.name , prescription.lab
from prescription, diagnostic_code
where prescription.ID = diagnostic_code.ID and extract(year from prescription.date_timestamp)='2019'
and diagnostic_code.description like '%dental  cavities%' and (prescription.name,prescription.lab) not in 
(select prescription.name , prescription.lab
from prescription, diagnostic_code
where prescription.ID = diagnostic_code.ID and extract(year from prescription.date_timestamp)='2019'
and diagnostic_code.description like '%infectious  disease%')
group by prescription.name
order by prescription.name;


9- pronta


select distinct client.name , client.street, client.city, client.zip
from client, appointment
where client.VAT = appointment.VAT_client and extract(year from appointment.date_timestamp) = '2019'
and (client.name , client.street, client.city, client.zip) not in (
select client.name , client.street, client.city, client.zip
from client, appointment
where client.VAT = appointment.VAT_client and not exists (
	select 1 from appointment, consultation where appointment.VAT_doctor  =consultation.VAT_doctor 
	and appointment.date_timestamp=consultation.date_timestamp)	
)






