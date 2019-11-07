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


3 - done
delete from employee
where name = 'Jane Sweettooth'



4 - 
update consultation_diagnostic
set ID = 'D13'
where ID = 'D12' and VAT_doctor in (
select pc.VAT
from  procedure_charting as pc
where pc.name='d4 charting'
group by pc.name
having avg(pc.measure)>4
) and date_timestamp in (
select pc.date_timestamp
from  procedure_charting as pc
where pc.name='d4 charting'
group by pc.date_timestamp
having avg(pc.measure)>4   
)
