1-

select client.VAT, client.name, phone_number_client.phone 
from client , phone_number_client, consultation, employee, appointment
where employee.name = "Jane Sweettooth" and employee.VAT = appointment.VAT_doctor and appointment.date_timestamp = consultation.date_timestamp 
and appointment.VAT_doctor=consultation.VAT_doctor and appointment.VAT_client = client.VAT and client.VAT = phone_number_client.VAT
order by client.name;
	
2-

(select employee.name
from employee, supervision_report
where employee.VAT = supervision_report.VAT and supervision_report.evaluation < 3)
union
(select employee.name
from employee, supervision_report
where employee.VAT = supervision_report.VAT and supervision_report.description like '%insufficient%' );

3- 

select client.name, client.city, client.VAT
from client, appointment, consultation
where appointment.VAT_client = client.VAT and consultation.date_timestamp=appointment.date_timestamp 
and consultation.date_timestamp >= all (
select consultation.date_timestamp 
from consultation, appointment
where appointment.VAT_doctor = consultation.VAT_doctor and client.VAT = appointment.VAT_client
and (consultation.SOAP_O like '%gingivilis%' or consultation.SOAP_O like '%periodontilis%') );
		
		


4-

select client.name , client.VAT, client.street, client.city, client.zip
from client, appointment
where client.VAT = appointment.VAT_client and appointment.date_timestamp not in
(select consultation.date_timestamp from consultation)
	

5- 

select diagnostic_code.ID, diagnostic_code.description, count( distinct prescription.name)
from diagnostic_code, consultation_diagnostic, prescription
where  prescription.ID = diagnostic_code.ID and consultation_diagnostic.VAT_doctor=prescription.VAT_doctor 
	and consultation_diagnostic.date_timestamp = prescription.date_timestamp and consultation_diagnostic.ID = prescription.ID
group by prescription.ID

6- group function da erro

(select avg(count(consultation_assistant.VAT_nurse)), avg(count(procedure_in_consultation.name)), avg(count(consultation_diagnostic.ID)),
avg(count(prescription.name))
from consultation_assistant, procedure_in_consultation, consultation_diagnostic, prescription, appointment, client
where extract(year from consultation_assistant.date_timestamp)='2019' and 
extract(year from procedure_in_consultation.date_timestamp)='2019' and
extract(year from consultation_diagnostic.date_timestamp)='2019' and
extract(year from prescription.date_timestamp)='2019' and
consultation_assistant.VAT_doctor = appointment.VAT_doctor and consultation_assistant.date_timestamp = appointment.date_timestamp and	
procedure_in_consultation.VAT_doctor = appointment.VAT_doctor and procedure_in_consultation.date_timestamp = appointment.date_timestamp and	
consultation_diagnostic.VAT_doctor = appointment.VAT_doctor and consultation_diagnostic.date_timestamp = appointment.date_timestamp and	
prescription.VAT_doctor = appointment.VAT_doctor and prescription.date_timestamp = appointment.date_timestamp and	
appointment.VAT_client  = client.VAT having client.age <=18)
	
union all

(select avg(count(consultation_assistant.VAT_nurse)), avg(count(procedure_in_consultation.name)), avg(count(consultation_diagnostic.ID)),
avg(count(prescription.name))
from consultation_assistant, procedure_in_consultation, consultation_diagnostic, prescription, appointment, client
where extract(year from consultation_assistant.date_timestamp)='2019' and 
extract(year from procedure_in_consultation.date_timestamp)='2019' and
extract(year from consultation_diagnostic.date_timestamp)='2019' and
extract(year from prescription.date_timestamp)='2019' and
consultation_assistant.VAT_doctor = appointment.VAT_doctor and consultation_assistant.date_timestamp = appointment.date_timestamp and	
procedure_in_consultation.VAT_doctor = appointment.VAT_doctor and procedure_in_consultation.date_timestamp = appointment.date_timestamp and	
consultation_diagnostic.VAT_doctor = appointment.VAT_doctor and consultation_diagnostic.date_timestamp = appointment.date_timestamp and	
prescription.VAT_doctor = appointment.VAT_doctor and prescription.date_timestamp = appointment.date_timestamp and	
appointment.VAT_client  = client.VAT having client.age >18)

	

7- 

select ID, name, lab
from prescription
group by ID

having count(name) >= all (
select count(name )
from prescription
group by ID )

	 
8- problema nos excepts

select prescription.name , prescription.lab
from prescription, diagnostic_code
where prescription.ID = diagnostic_code.ID and extract(year from prescription.date_timestamp)='2019'
and diagnostic_code.description like "%dental cavities%"
group by (prescription.name, prescription.lab)
order by prescription.name
	
except

select prescription.name , prescription.lab
from prescription, diagnostic_code
where prescription.ID = diagnostic_code.ID and extract(year from prescription.date_timestamp)='2019'
and diagnostic_code.description like "%infectious deseases%" 


9- problema nos excepts


select client.name , client.street, client.city, client.zip
from client, appointment
where client.VAT = appointment.VAT_client and extract(year from appointment.date_timestamp) = '2019'

except

select client.name , client.street, client.city, client.zip
from client, appointment
where client.VAT = appointment.VAT_client and not exists (
	select 1 from appointment, consultation where appointment.VAT_doctor  =consultation.VAT_doctor 
	and appointment.date_timestamp=consultation.date_timestamp)
)








