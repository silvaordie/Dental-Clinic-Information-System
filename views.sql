drop view dim_date;
drop view dim_client;
drop view dim_location_client;
drop view facts_consults;


create view dim_date as
select distinct date_timestamp "date", extract(day from date_timestamp) "day",
extract(month from date_timestamp) "month", extract(year from date_timestamp) "year"
from consultation;
	
create view dim_client as
select VAT, gender, age
from client;
	
create view dim_location_client as
select distinct zip, city
from client;
	
create view facts_consults as
select dc.VAT, dd.date_timestamp, dlc.zip,
count(distinct procedure_in_consultation.name), count(distinct prescription.name),
count(distinct consultation_diagnostic.ID)
from dim_client dc, dim_date dd, dim_location_client dlc,
procedure_in_consultation, prescription, consultation_diagnostic,
appointment, client
where dc.VAT = appointment.VAT_client
and dc.VAT = client.VAT
and dlc.zip = client.zip
and dd.date_timestamp = appointment.date_timestamp
and dd.date_timestamp = procedure_in_consultation.date_timestamp
and dd.date_timestamp = prescription.date_timestamp
and dd.date_timestamp = consultation_diagnostic.date_timestamp
and appointment.VAT_doctor = procedure_in_consultation.VAT_doctor
and appointment.VAT_doctor = prescription.VAT_doctor
and appointment.VAT_doctor = consultation_diagnostic.VAT_doctor
and prescription.ID = consultation_diagnostic.ID
group by dc.VAT, dd.date_timestamp;