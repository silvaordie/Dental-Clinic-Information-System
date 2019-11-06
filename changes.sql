1- done

update employee
set street = 'rua rovisco pais',city='lisboa',zip='0987'
where name = 'Jane Sweettooth';

2- done

update employee
set salary = salary*1.05
where VAT in (
select VAT_doctor
from appointment
where extract(year from appointment.date_timestamp)='2019'
having count(VAT_doctor) >= 100  
)


3 - 


delete from employee
where name = 'Jane Sweettooth'
