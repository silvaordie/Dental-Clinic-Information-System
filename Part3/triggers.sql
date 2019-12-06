drop trigger update_age;
drop trigger check_nurse_insert;
drop trigger check_nurse_update;
drop trigger check_receptionist_insert;
drop trigger check_receptionist_update;
drop trigger check_doctor_insert;
drop trigger check_doctor_update;
drop trigger check_permanent_insert;
drop trigger check_permanent_update;
drop trigger check_trainee_insert;
drop trigger check_trainee_update;
drop trigger check_phone_insert;
drop trigger check_phone_update;
drop trigger check_phone_insert_client;
drop trigger check_phone_update_client;
drop function no_shows;
drop procedure salary_raise;

-- Trigger1: Done
delimiter $$
create trigger update_age after insert on appointment
for each row
begin
	update client
	set age = timestampdiff(year, birth_date, now())
	where VAT = new.VAT_client;
end $$
delimiter ;


-- Trigger2: Done
-- (a): Done
-- insert nurse
delimiter $$
create trigger check_nurse_insert before insert on nurse
for each row
begin
	if exists(select VAT
	from doctor where VAT = new.VAT) then
	signal sqlstate '45000' set MESSAGE_TEXT = 'There is already a doctor with the same VAT';
	end if;
end $$
delimiter ;
-- update nurse
delimiter $$
create trigger check_nurse_update before update on nurse
for each row
begin
	if exists(select VAT
	from doctor where VAT = new.VAT) then
	signal sqlstate '45000' set MESSAGE_TEXT = 'There is already a doctor with the same VAT';
	end if;
end $$
delimiter ;
-- insert receptionist
delimiter $$
create trigger check_receptionist_insert before insert on receptionist
for each row
begin
	if exists(select VAT
	from doctor where VAT = new.VAT) then
	signal sqlstate '45000' set MESSAGE_TEXT = 'There is already a doctor with the same VAT';
	end if;
end $$
delimiter ;
-- update receptionist
delimiter $$
create trigger check_receptionist_update before update on receptionist
for each row
begin
	if exists(select VAT
	from doctor where VAT = new.VAT) then
	signal sqlstate '45000' set MESSAGE_TEXT = 'There is already a doctor with the same VAT';
	end if;
end $$
delimiter ;
-- insert doctor
delimiter $$
create trigger check_doctor_insert before insert on doctor
for each row
begin
	if exists(select VAT
	from nurse where VAT = new.VAT) then
	signal sqlstate '45000' set MESSAGE_TEXT = 'There is already a nurse with the same VAT';
	end if;
	if exists(select VAT
	from receptionist where VAT = new.VAT) then
	signal sqlstate '45000' set MESSAGE_TEXT = 'There is already a receptionist with the same VAT';
	end if;
end $$
delimiter ;
-- update doctor
delimiter $$
create trigger check_doctor_update before update on doctor
for each row
begin
	if exists(select VAT
	from nurse where VAT = new.VAT) then
	signal sqlstate '45000' set MESSAGE_TEXT = 'There is already a nurse with the same VAT';
	end if;
	if exists(select VAT
	from receptionist where VAT = new.VAT) then
	signal sqlstate '45000' set MESSAGE_TEXT = 'There is already a receptionist with the same VAT';
	end if;
end $$
delimiter ;

-- (b): Done
-- insert permanent_doctor
delimiter $$
create trigger check_permanent_insert before insert on permanent_doctor
for each row
begin
	if exists(select VAT
	from trainee_doctor where VAT = new.VAT) then
	signal sqlstate '45000' set MESSAGE_TEXT = 'There is already a trainee with the same VAT';
	end if;
end $$
delimiter ;
-- update permanent_doctor
delimiter $$
create trigger check_permanent_update before update on permanent_doctor
for each row
begin
	if exists(select VAT
	from trainee_doctor where VAT = new.VAT) then
	signal sqlstate '45000' set MESSAGE_TEXT = 'There is already a trainee with the same VAT';
	end if;
end $$
delimiter ;
-- insert trainee_doctor
delimiter $$
create trigger check_trainee_insert before insert on trainee_doctor
for each row
begin
	if exists(select VAT
	from permanent_doctor where VAT = new.VAT) then
	signal sqlstate '45000' set MESSAGE_TEXT = 'There is already a permanent doctor with the same VAT';
	end if;
end $$
delimiter ;
-- update trainee_doctor
delimiter $$
create trigger check_trainee_update before update on trainee_doctor
for each row
begin
	if exists(select VAT
	from permanent_doctor where VAT = new.VAT) then
	signal sqlstate '45000' set MESSAGE_TEXT = 'There is already a permanent doctor with the same VAT';
	end if;
end $$
delimiter ;


-- Trigger 3: Done
-- on insert phone
delimiter $$
create trigger check_phone_insert before insert on phone_number_employee
for each row
begin
	if exists(select phone
	from phone_number_employee where phone = new.phone and VAT != new.VAT) then
	signal sqlstate '45000' set MESSAGE_TEXT = 'This phone number already exists, belongs to a employee';
	end if;
	if exists(select phone
	from phone_number_client where phone = new.phone and VAT != new.VAT) then
	signal sqlstate '45000' set MESSAGE_TEXT = 'This phone number already exists, belongs to a client';
	end if;
end $$
delimiter ;
-- on update phone
delimiter $$
create trigger check_phone_update before update on phone_number_employee
for each row
begin
	if exists(select phone
	from phone_number_employee where phone = new.phone and VAT != new.VAT) then
	signal sqlstate '45000' set MESSAGE_TEXT = 'This phone number already exists, belongs to a employee';
	end if;
	if exists(select phone
	from phone_number_client where phone = new.phone and VAT != new.VAT) then
	signal sqlstate '45000' set MESSAGE_TEXT = 'This phone number already exists, belongs to a client';
	end if;
end $$
delimiter ;
-- on insert phone
delimiter $$
create trigger check_phone_insert_client before insert on phone_number_client
for each row
begin
	if exists(select phone
	from phone_number_employee where phone = new.phone and VAT != new.VAT) then
	signal sqlstate '45000' set MESSAGE_TEXT = 'This phone number already exists, belongs to a employee';
	end if;
	if exists(select phone
	from phone_number_client where phone = new.phone and VAT != new.VAT) then
	signal sqlstate '45000' set MESSAGE_TEXT = 'This phone number already exists, belongs to a client';
	end if;
end $$
delimiter ;
-- on update phone
delimiter $$
create trigger check_phone_update_client before update on phone_number_client
for each row
begin
	if exists(select phone
	from phone_number_employee where phone = new.phone and VAT != new.VAT) then
	signal sqlstate '45000' set MESSAGE_TEXT = 'This phone number already exists, belongs to a employee';
	end if;
	if exists(select phone
	from phone_number_client where phone = new.phone and VAT != new.VAT) then
	signal sqlstate '45000' set MESSAGE_TEXT = 'This phone number already exists, belongs to a client';
	end if;
end $$
delimiter ;


-- Function 4: Done, check value
delimiter $$
create function no_shows(c_gender char(2), a_year varchar(4), max_age int, min_age int)
returns integer
begin
	declare ns_count integer;
	select count(*) into ns_count
	from appointment
	where VAT_client in (select VAT
	from client where 
	age between max_age and min_age
	and gender = c_gender)
	and (VAT_doctor, date_timestamp) not in
	(select VAT_doctor, date_timestamp from consultation)
	and extract(year from date_timestamp) = a_year;
	return ns_count;
end$$
delimiter ;


-- Procedure 5: Done, check 2nd case (more than 100 consultations)
delimiter $$
create procedure salary_raise(in x_years integer)
begin
	update employee
	set salary = salary + salary*0.05
	where VAT in (select VAT
	from permanent_doctor
	where years > x_years)
	and VAT not in (select VAT_doctor
	from consultation
	where extract(year from date_timestamp) = year(curdate())
	group by VAT_doctor
	having count(*) > 100);
	
	update employee
	set salary = salary + salary*0.1
	where VAT in (select VAT
	from permanent_doctor
	where years > x_years)
	and VAT in (select VAT_doctor
	from consultation
	where extract(year from date_timestamp) = year(curdate())
	group by VAT_doctor
	having count(*) > 100);
end$$
delimiter ;