1-

select join_client.VAT, join_client.name, join_client.phone 
from client natural join phone_number_client as join_client, consultation, employee, appointment
where employee.name = "Jane Sweettooth" and employee.VAT = appointment.VAT_doctor and appointment.date_timestamp = consultation.date_timestamp 
	and appointment.VAT_doctor=consultation.VAT_doctor and appointment.VAT_client = join_client.VAT
order by client.name
	
	
	nesta acho que tenho que fazer um join entre client e phone_number_client
	nao tenho a certeza se tenho que fazer appointment.VAT = consultation.VAT para garantir que estou a
falar de uma coonsultation e nao apenas de um appointment


2-

(select employee.name
from employee, supervision_report
where employee.VAT = supervision_report.VAT and supervision_report.evaluation < 3)
union
(select employee.name
from employee, supervision_report
where employee.VAT = supervision_report.VAT and supervision_report.description like '%insufficient%' )

3- 

select client.name, client.city, client.VAT
from client, appointment, consultation
where appointment.VAT_client = client.VAT and consultation.date_timestamp=appointment.date_timestamp 
	and consultation.date_timestamp >= all (
		select consultation.date_timestamp 
		from consultation, appointment
		where appointment.VAT_doctor = consultation.VAT_doctor and client.VAT = appointment.VAT_client and
		and (consultation.SOAP_O like '%gingivilis%' or consultation.SOAP_O like '%periodontilis%') )
		
		
nestes que tem duas keys eu tenho aulgumas duvidas se isto funciona assim tao bem....


4-

select client.name , client.VAT, client.street, client.city, client.zip
from client, appointment
where client.VAT = appointment.VAT_client and appointment.date_timestamp not in
	(select consultation.date_timestamp from consultation)
	
nestes que tem duas keys eu tenho aulgumas duvidas se isto funciona assim tao bem....


5- 

select diagnostic_code.ID, diagnostic_code.description, count( distinct prescription.name)
from diagnostic_code, consultation_diagnosis, prescription
where  prescription.ID = diagnostic_code.ID and consultation_diagnosis.VAT_doctor=prescription.VAT_doctor 
	and consultation_diagnosis.date_timestamp = prescription.date_timestamp and consultation_diagnosis.ID = prescription.ID
group by prescription.ID

6- 

select avg(count(consultation_assistant.VAT_nurse)), avg(count(procedure_in_consultation.name)), avg(count(consultation_diagnosis.ID)),
	avg(count(prescription.name))
from consultation_assistant, procedure_in_consultation, consultation_diagnosis, prescription, appointment, client
where consultation_assistant.date_timestamp between timestamp('2019-01-01') and timestamp('2019-12-31 24:59:59.99') and 
	procedure_in_consultation.date_timestamp between timestamp('2019-01-01') and timestamp('2019-12-31 24:59:59.99') and
	consultation_diagnosis.date_timestamp between timestamp('2019-01-01') and timestamp('2019-12-31 24:59:59.99') and
	prescription.date_timestamp between timestamp('2019-01-01') and timestamp('2019-12-31 24:59:59.99') and
	consultation_assistant.VAT_doctor = appointment.VAT_doctor and consultation_assistant.date_timestamp = appointment.date_timestamp and	
	procedure_in_consultation.VAT_doctor = appointment.VAT_doctor and procedure_in_consultation.date_timestamp = appointment.date_timestamp and	
	consultation_diagnosis.VAT_doctor = appointment.VAT_doctor and consultation_diagnosis.date_timestamp = appointment.date_timestamp and	
	prescription.VAT_doctor = appointment.VAT_doctor and prescription.date_timestamp = appointment.date_timestamp and	
	appointment.VAT_client  = client.VAT having client.age <=18
	
union

select avg(count(consultation_assistant.VAT_nurse)), avg(count(procedure_in_consultation.name)), avg(count(consultation_diagnosis.ID)),
	avg(count(prescription.name))
from consultation_assistant, procedure_in_consultation, consultation_diagnosis, prescription, appointment, client
where consultation_assistant.date_timestamp between timestamp('2019-01-01') and timestamp('2019-12-31 24:59:59.99') and 
	procedure_in_consultation.date_timestamp between timestamp('2019-01-01') and timestamp('2019-12-31 24:59:59.99') and
	consultation_diagnosis.date_timestamp between timestamp('2019-01-01') and timestamp('2019-12-31 24:59:59.99') and
	prescription.date_timestamp between timestamp('2019-01-01') and timestamp('2019-12-31 24:59:59.99') and
	consultation_assistant.VAT_doctor = appointment.VAT_doctor and consultation_assistant.date_timestamp = appointment.date_timestamp and	
	procedure_in_consultation.VAT_doctor = appointment.VAT_doctor and procedure_in_consultation.date_timestamp = appointment.date_timestamp and	
	consultation_diagnosis.VAT_doctor = appointment.VAT_doctor and consultation_diagnosis.date_timestamp = appointment.date_timestamp and	
	prescription.VAT_doctor = appointment.VAT_doctor and prescription.date_timestamp = appointment.date_timestamp and	
	appointment.VAT_client  = client.VAT having client.age >18

	



