drop table if exists procedure_charting;
drop table if exists teeth;
drop table if exists procedure_radiology;
drop table if exists procedure_in_consultation;
drop table if exists _procedure;
drop table if exists prescription;
drop table if exists medication;
drop table if exists consultation_diagnostic;
drop table if exists diagnostic_code_relation;
drop table if exists diagnostic_code;
drop table if exists consultation_assistant;
drop table if exists consultation;
drop table if exists appointment;
drop table if exists supervision_report;
drop table if exists trainee_doctor;
drop table if exists permanent_doctor;
drop table if exists phone_number_client;
drop table if exists client;
drop table if exists receptionist;
drop table if exists doctor;
drop table if exists nurse;
drop table if exists phone_number_employee;
drop table if exists employee;

create table employee
   (VAT char(10),
   name varchar(255),
   birth_date DATE,
   street varchar(255),
   city varchar(255),
   zip char(9),
   IBAN char(26) unique not null,
   salary  numeric(20,2) CHECK (salary > 0),
   primary key (VAT));
-- all employees are either receptionists, nurses or doctors

create table phone_number_employee
   (phone char(10),
   VAT char(10),
   primary key(VAT, phone),
   foreign key(VAT)
    references employee(VAT) on update cascade on delete cascade);

create table receptionist
   (VAT char(10),
   primary key(VAT),
   foreign key(VAT)
    references employee(VAT) on update cascade on delete cascade);

create table doctor
   (VAT char(10),
   specialization varchar(255),
   biography varchar(255),
   email varchar(255) unique not null,
   primary key(VAT),
   foreign key(VAT)
    references employee(VAT) on update cascade on delete cascade);

create table nurse
   (VAT char(10),
   primary key(VAT),
   foreign key(VAT)
    references employee(VAT) on update cascade on delete cascade);

create table client
   (VAT char(10),
   name varchar(255),
   birth_date DATE,
   street varchar(255),
   city varchar(255),
   zip char(9),
   gender char(2),
   age int CHECK (age>0),
   primary key (VAT));
   --age = (current_date - birth_date).years
   
create table phone_number_client
   (phone char(10),
   VAT char(10),
   primary key(VAT,phone),
   foreign key(VAT)
    references client(VAT) on update cascade on delete cascade);

create table permanent_doctor
   (VAT char(10),
   years int,
   primary key(VAT),
   foreign key(VAT)
    references doctor(VAT) on update cascade on delete cascade);

create table trainee_doctor
   (VAT char(10),
   supervisor char(10),
   foreign key(VAT)
    references doctor(VAT) on update cascade on delete cascade,
   foreign key(supervisor)
    references permanent_doctor(VAT) on update cascade on delete cascade,
   primary key (VAT) );

create table supervision_report
   (VAT char(10),
   date_timestamp timestamp,
   description varchar(255),
   evaluation int CHECK (evaluation <=5 AND evaluation >= 5),
   foreign key(VAT)
    references trainee_doctor(VAT) on update no action  on delete no action,
   primary key (VAT, date_timestamp)
   )ENGINE=MyISAM;

create table appointment
   (VAT_doctor char(10),
   date_timestamp timestamp,
   description varchar(255),
   VAT_client char(10),
   foreign key(VAT_doctor)
    references doctor(VAT) on update cascade on delete cascade,
   foreign key(VAT_client)
    references client(VAT) on update cascade on delete cascade,
   primary key (VAT_doctor, date_timestamp));

create table consultation
   (VAT_doctor char(10),
   date_timestamp timestamp,
   SOAP_S varchar(255),
   SOAP_O varchar(255),
   SOAP_A varchar(255),
   SOAP_P varchar(255),
   foreign key(VAT_doctor,date_timestamp)
    references appointment(VAT_doctor, date_timestamp) on update cascade on delete no action,
   primary key (VAT_doctor, date_timestamp)
   );

create table consultation_assistant
   (VAT_doctor char(10),
   date_timestamp timestamp,
   VAT_nurse char(10),
   foreign key(VAT_doctor,date_timestamp)
    references appointment(VAT_doctor, date_timestamp) on update cascade on delete no action,
   foreign key (VAT_nurse)
    references nurse(VAT) on update cascade on delete no action,
   primary key (VAT_doctor, date_timestamp));

create table diagnostic_code
   (ID varchar(255),
   description varchar(255),
   primary key(ID)
   );

create table diagnostic_code_relation
   (ID1 varchar(255),
   ID2 varchar(255),
   type varchar(255),
   foreign key(ID1)
    references diagnostic_code(ID) on update cascade on delete cascade ,
   foreign key(ID2)
    references diagnostic_code(ID) on update cascade on delete cascade,
   primary key (ID1, ID2));

create table consultation_diagnostic
   (VAT_doctor char(10),
   date_timestamp timestamp,
   ID varchar(255),
   foreign key (VAT_doctor, date_timestamp)
    references consultation(VAT_doctor, date_timestamp) on update cascade on delete cascade,
   foreign key (ID)
    references diagnostic_code(ID) on update cascade on delete cascade,
   primary key (VAT_doctor, date_timestamp, ID));

create table medication
   (name varchar(255),
   lab varchar(255),
   primary key(name, lab));

create table prescription
   (name varchar(255),
   lab varchar(255),
   VAT_doctor char(10),
   date_timestamp timestamp,
   ID varchar(255),
   dosage varchar(255),
   description varchar(255),
   foreign key (VAT_doctor, date_timestamp,ID) 
    references consultation_diagnostic(VAT_doctor, date_timestamp,ID) on update cascade on delete cascade,
   foreign key (name,lab)
    references medication(name,lab) on update cascade on delete cascade,
   primary key (name, VAT_doctor, date_timestamp, ID));

create table _procedure
   (name varchar(255),
   type varchar (255),
   primary key (name));

create table procedure_in_consultation
   (name varchar(255),
   VAT_doctor char(10),
   date_timestamp timestamp,
   description varchar(255),
   foreign key (VAT_doctor,date_timestamp)
    references consultation(VAT_doctor, date_timestamp) on update cascade on delete cascade,
   foreign key (name)
    references _procedure(name) on update cascade on delete cascade,
   primary key (name, VAT_doctor, date_timestamp)
   );

create table procedure_radiology
   (name varchar(255),
   file varchar(255),
   VAT_doctor char(10),
   date_timestamp timestamp,
   primary key (file, name, VAT_doctor, date_timestamp),
   foreign key (VAT_doctor,date_timestamp)
    references consultation_diagnostic(VAT_doctor,date_timestamp) on update cascade on delete cascade,
   foreign key (name)
    references _procedure(name) on update cascade on delete cascade );

create table teeth
   (quadrant char(2),
   number char(3),
   name varchar(255),
   primary key(quadrant, number));

create table procedure_charting
   (name varchar(255),
   VAT char(10),
   date_timestamp timestamp,
   quadrant char(2),
   number char(3),
   description varchar(255),
   measure char(5),
   foreign key(name, VAT, date_timestamp)
      references procedure_in_consultation(name, VAT_doctor, date_timestamp) on update cascade on delete cascade,
   foreign key (quadrant, number)
      references teeth(quadrant, number) on update cascade on delete cascade,
   primary key (name, VAT, date_timestamp, quadrant, number)
   );
   
   
   
   --		employees
insert into employee values ('123456789', 'Jane Sweettooth', '1990/12/17', 'rua', 'cidade', '2780-255', 'PT50567891234567891234567', 900);
insert into employee values ('987654321', 'Julia Sweettooth', '1990/12/17', 'rua2', 'cidade2', '2780-260', 'PT50567891231234891234567', 600);
insert into employee values ('123746789', 'Jane Dentedoce', '1980/12/17', 'rua2', 'cidade3', '2770-255', 'PT50567896734567891234567', 1000);
insert into employee values ('987656789', 'Julio Isidro', '1200/12/17', 'rua', 'cidade2', '2780-485', 'PT50123491234567891234666', 666.80);
insert into employee values ('123458889', 'João Baião', '1805/12/17', 'rua7', 'cidade3', '2780-777', 'PT50567891234567895432167', 9600);
insert into employee values ('123457469', 'Sara Rececao', '1254/12/17', 'rua6', 'cidade74', '2740-777', 'PT50566891274567805432167', 100);

    --	phone_number_employee
insert into phone_number_employee values ('912345678','123456789');
insert into phone_number_employee values ('962345678','987654321');
insert into phone_number_employee values ('962354678','123746789');
insert into phone_number_employee values ('953414378','987656789');
insert into phone_number_employee values ('998878574','123458889');


--		receptionist
insert into receptionist values ('123457469');


--		doctors
insert into doctor values ('123456789', 'Expert em caries', 'Boa aluna, mas pessima a tirar sisos','Jane@bluetooth.com');
insert into doctor values ('987654321', 'Expert em sisos', '3 meses na clinica e ja se fartou','Julia@bluetooth.com');
insert into doctor values ('987656789', 'Expert em piropos', 'Trabalha pouco fala muito','Julio@bluetooth.com');

--    nurses
insert into nurse values ('123746789');

--		clients 
insert into client values ('999999999', 'José Bebé', '1990/12/17', 'rua3', 'cidade1', '2780-255', 'M' , 26);
insert into client values ('888888888', 'Hugo Burro', '1980/12/17', 'rua1', 'cidade5', '2780-255', 'M' , 26);
insert into client values ('777777777', 'Pedro Cebo', '1890/12/17', 'rua1', 'cidade5', '2780-255', 'M' , 26);
insert into client values ('666666666', 'Filipe Bibe', '1890/12/17', 'rua1', 'cidade5', '2780-255', 'M' , 26);

   --	phone_number_client
insert into phone_number_client values ('912345878','999999999');
insert into phone_number_client values ('962345978','999999999');

--		permanent_doctors 
insert into permanent_doctor values ('123456789', 11);

--		trainee_doctors 
insert into trainee_doctor values ('987654321','123456789');
insert into trainee_doctor values ('987656789', '123456789');

--		supervision_reports 
insert into supervision_report values ('987654321', '2018/12/17', 'Boa moça a Julia', 4);
insert into supervision_report values ('987656789', '2018/12/17', 'Mais piropos', 2);
insert into supervision_report values ('987656789', '2017/12/17', 'insufficient', 3);

--    appointments
insert into appointment values ('123456789', '2019/11/17 17:00:00', 'rotina', '999999999');
insert into appointment values ('123456789', '2019/12/17 17:00:00', 'follow-up', '999999999');
insert into appointment values ('987654321', '2019/11/17 17:00:00', 'rotina', '888888888');
insert into appointment values ('987654321', '2019/12/17 17:00:00', 'follow-up', '888888888');
insert into appointment values ('987656789', '2019/11/17 17:00:00', 'rotina', '777777777');
insert into appointment values ('987656789', '2019/12/17 17:00:00', 'follow-up', '777777777');
insert into appointment values ('987656789', '2019/10/17 17:00:00', 'follow-up', '666666666');
insert into appointment values ('123456789', '2019-7-13 16:38:00', 'follow-up', '777777777');
insert into appointment values ('123456789', '2019-12-25 13:58:00', 'rotina', '999999999');
insert into appointment values ('123456789', '2019-3-30 13:54:00', 'rotina', '888888888');
insert into appointment values ('123456789', '2019-1-13 14:46:00', 'rotina', '888888888');
insert into appointment values ('123456789', '2019-5-1 14:51:00', 'tratamento', '666666666');
insert into appointment values ('123456789', '2019-8-30 13:27:00', 'tratamento', '999999999');
insert into appointment values ('123456789', '2019-9-19 17:29:00', 'rotina', '777777777');
insert into appointment values ('123456789', '2019-9-26 13:42:00', 'rotina', '777777777');
insert into appointment values ('123456789', '2019-6-29 14:3:00', 'tratamento', '888888888');
insert into appointment values ('123456789', '2019-7-17 10:35:00', 'tratamento', '888888888');
insert into appointment values ('123456789', '2019-7-12 10:7:00', 'tratamento', '999999999');
insert into appointment values ('123456789', '2019-9-20 11:54:00', 'tratamento', '777777777');
insert into appointment values ('123456789', '2019-2-26 10:24:00', 'follow-up', '888888888');
insert into appointment values ('123456789', '2019-6-19 11:13:00', 'tratamento', '888888888');
insert into appointment values ('123456789', '2019-10-28 18:17:00', 'tratamento', '888888888');
insert into appointment values ('123456789', '2019-10-20 16:10:00', 'tratamento', '999999999');
insert into appointment values ('123456789', '2019-7-22 13:31:00', 'follow-up', '888888888');
insert into appointment values ('123456789', '2019-6-17 17:52:00', 'follow-up', '888888888');
insert into appointment values ('123456789', '2019-1-2 12:27:00', 'tratamento', '999999999');
insert into appointment values ('123456789', '2019-6-1 13:47:00', 'follow-up', '999999999');
insert into appointment values ('123456789', '2019-11-26 17:13:00', 'tratamento', '888888888');
insert into appointment values ('123456789', '2019-2-9 15:15:00', 'tratamento', '777777777');
insert into appointment values ('123456789', '2019-3-30 15:43:00', 'rotina', '999999999');
insert into appointment values ('123456789', '2019-5-17 11:15:00', 'rotina', '777777777');
insert into appointment values ('123456789', '2019-2-12 12:2:00', 'rotina', '666666666');
insert into appointment values ('123456789', '2019-8-10 18:9:00', 'tratamento', '999999999');
insert into appointment values ('123456789', '2019-11-13 11:29:00', 'tratamento', '666666666');
insert into appointment values ('123456789', '2019-6-27 17:35:00', 'follow-up', '999999999');
insert into appointment values ('123456789', '2019-5-20 17:17:00', 'rotina', '777777777');
insert into appointment values ('123456789', '2019-9-4 12:42:00', 'follow-up', '777777777');
insert into appointment values ('123456789', '2019-3-21 10:54:00', 'rotina', '777777777');
insert into appointment values ('123456789', '2019-11-12 16:17:00', 'tratamento', '666666666');
insert into appointment values ('123456789', '2019-8-28 14:40:00', 'follow-up', '999999999');
insert into appointment values ('123456789', '2019-2-9 15:16:00', 'rotina', '666666666');
insert into appointment values ('123456789', '2019-8-4 15:42:00', 'follow-up', '666666666');
insert into appointment values ('123456789', '2019-7-4 16:12:00', 'rotina', '777777777');
insert into appointment values ('123456789', '2019-10-16 17:6:00', 'tratamento', '666666666');
insert into appointment values ('123456789', '2019-2-27 16:48:00', 'follow-up', '666666666');
insert into appointment values ('123456789', '2019-5-6 14:1:00', 'follow-up', '888888888');
insert into appointment values ('123456789', '2019-5-1 18:24:00', 'tratamento', '666666666');
insert into appointment values ('123456789', '2019-10-16 10:37:00', 'rotina', '888888888');
insert into appointment values ('123456789', '2019-12-17 11:15:00', 'follow-up', '666666666');
insert into appointment values ('123456789', '2019-4-30 18:55:00', 'follow-up', '777777777');
insert into appointment values ('123456789', '2019-9-13 11:35:00', 'rotina', '666666666');
insert into appointment values ('123456789', '2019-9-30 10:3:00', 'follow-up', '777777777');
insert into appointment values ('123456789', '2019-6-6 14:35:00', 'rotina', '777777777');
insert into appointment values ('123456789', '2019-9-21 18:4:00', 'tratamento', '777777777');
insert into appointment values ('123456789', '2019-9-1 13:47:00', 'tratamento', '777777777');
insert into appointment values ('123456789', '2019-3-26 12:49:00', 'rotina', '999999999');
insert into appointment values ('123456789', '2019-12-7 14:29:00', 'tratamento', '888888888');
insert into appointment values ('123456789', '2019-2-15 12:34:00', 'tratamento', '888888888');
insert into appointment values ('123456789', '2019-4-18 14:11:00', 'rotina', '666666666');
insert into appointment values ('123456789', '2019-1-10 17:41:00', 'tratamento', '888888888');
insert into appointment values ('123456789', '2019-10-23 15:36:00', 'rotina', '888888888');
insert into appointment values ('123456789', '2019-7-26 10:42:00', 'rotina', '999999999');
insert into appointment values ('123456789', '2019-4-22 17:53:00', 'rotina', '999999999');
insert into appointment values ('123456789', '2019-9-17 14:51:00', 'tratamento', '666666666');
insert into appointment values ('123456789', '2019-3-2 13:53:00', 'follow-up', '666666666');
insert into appointment values ('123456789', '2019-3-8 18:19:00', 'tratamento', '999999999');
insert into appointment values ('123456789', '2019-12-16 14:13:00', 'rotina', '888888888');
insert into appointment values ('123456789', '2019-5-27 15:17:00', 'follow-up', '666666666');
insert into appointment values ('123456789', '2019-5-13 14:53:00', 'tratamento', '666666666');
insert into appointment values ('123456789', '2019-11-7 18:4:00', 'rotina', '999999999');
insert into appointment values ('123456789', '2019-1-19 17:55:00', 'tratamento', '666666666');
insert into appointment values ('123456789', '2019-5-29 10:0:00', 'rotina', '666666666');
insert into appointment values ('123456789', '2019-8-24 18:40:00', 'follow-up', '999999999');
insert into appointment values ('123456789', '2019-1-8 15:25:00', 'follow-up', '777777777');
insert into appointment values ('123456789', '2019-10-10 14:38:00', 'follow-up', '666666666');
insert into appointment values ('123456789', '2019-5-22 15:18:00', 'rotina', '888888888');
insert into appointment values ('123456789', '2019-7-20 14:22:00', 'follow-up', '888888888');
insert into appointment values ('123456789', '2019-8-7 12:0:00', 'rotina', '999999999');
insert into appointment values ('123456789', '2019-10-29 18:12:00', 'tratamento', '666666666');
insert into appointment values ('123456789', '2019-11-14 17:23:00', 'follow-up', '777777777');
insert into appointment values ('123456789', '2019-7-28 13:27:00', 'rotina', '888888888');
insert into appointment values ('123456789', '2019-3-29 10:14:00', 'follow-up', '999999999');
insert into appointment values ('123456789', '2019-1-9 12:1:00', 'follow-up', '777777777');
insert into appointment values ('123456789', '2019-4-23 15:10:00', 'tratamento', '999999999');
insert into appointment values ('123456789', '2019-12-9 16:26:00', 'follow-up', '777777777');
insert into appointment values ('123456789', '2019-3-24 13:5:00', 'tratamento', '666666666');
insert into appointment values ('123456789', '2019-5-21 18:9:00', 'tratamento', '999999999');
insert into appointment values ('123456789', '2019-5-27 17:0:00', 'follow-up', '777777777');
insert into appointment values ('123456789', '2019-4-2 13:27:00', 'rotina', '999999999');
insert into appointment values ('123456789', '2019-4-4 17:12:00', 'follow-up', '999999999');
insert into appointment values ('123456789', '2019-10-1 13:34:00', 'rotina', '666666666');
insert into appointment values ('123456789', '2019-5-22 14:3:00', 'follow-up', '999999999');
insert into appointment values ('123456789', '2019-10-9 17:0:00', 'rotina', '888888888');
insert into appointment values ('123456789', '2019-6-22 15:7:00', 'follow-up', '888888888');
insert into appointment values ('123456789', '2019-10-6 17:46:00', 'tratamento', '777777777');
insert into appointment values ('123456789', '2019-11-12 16:28:00', 'rotina', '888888888');
insert into appointment values ('123456789', '2019-2-21 14:18:00', 'tratamento', '999999999');
insert into appointment values ('123456789', '2019-9-21 16:35:00', 'tratamento', '999999999');
insert into appointment values ('123456789', '2019-2-7 17:19:00', 'rotina', '777777777');
insert into appointment values ('123456789', '2019-6-26 18:42:00', 'follow-up', '888888888');
insert into appointment values ('123456789', '2019-3-5 12:52:00', 'follow-up', '777777777');
insert into appointment values ('123456789', '2019-3-14 14:24:00', 'follow-up', '666666666');
insert into appointment values ('123456789', '2019-9-29 16:5:00', 'rotina', '666666666');
insert into appointment values ('123456789', '2019-1-17 18:13:00', 'tratamento', '777777777');
insert into appointment values ('123456789', '2019-9-13 17:32:00', 'rotina', '999999999');
insert into appointment values ('123456789', '2019-4-15 11:55:00', 'follow-up', '666666666');
insert into appointment values ('123456789', '2019-4-28 15:57:00', 'tratamento', '999999999');
insert into appointment values ('123456789', '2019-12-26 13:45:00', 'rotina', '999999999');
insert into appointment values ('123456789', '2019-10-10 13:12:00', 'follow-up', '777777777');
insert into appointment values ('123456789', '2019-3-4 13:32:00', 'tratamento', '666666666');
insert into appointment values ('123456789', '2019-4-13 11:58:00', 'follow-up', '888888888');
insert into appointment values ('123456789', '2019-12-15 16:38:00', 'tratamento', '666666666');
insert into appointment values ('123456789', '2019-9-20 16:15:00', 'tratamento', '777777777');
insert into appointment values ('123456789', '2019-2-16 11:48:00', 'rotina', '999999999');
insert into appointment values ('123456789', '2019-7-12 15:19:00', 'tratamento', '666666666');
insert into appointment values ('123456789', '2019-6-13 12:51:00', 'rotina', '777777777');
insert into appointment values ('123456789', '2019-2-13 11:54:00', 'tratamento', '777777777');

--    consultations
insert into consultation values ('123456789', '2019/11/17 17:00:00', 's', 'gingivitis', 'a', 'p' );
insert into consultation values ('123456789', '2019/12/17 17:00:00', 's', 'periodontitis', 'a', 'p' );
insert into consultation values ('987654321', '2019/12/17 17:00:00', 's', 'gingivitis', 'a', 'p' );
insert into consultation values ('987654321', '2019/11/17 17:00:00', 's', 'periodontitis', 'a', 'p' );
insert into consultation values ('987656789', '2019/11/17 17:00:00', 's', 'o', 'a', 'p' );
insert into consultation values ('987656789', '2019/12/17 17:00:00', 's', 'o', 'a', 'p' );

--    consultation_assistants
insert into consultation_assistant values ('123456789', '2019/11/17 17:00:00', '123746789' );
insert into consultation_assistant values ('123456789', '2019/12/17 17:00:00', '123746789' );
insert into consultation_assistant values ('987654321', '2019/11/17 17:00:00', '123746789' );
insert into consultation_assistant values ('987654321', '2019/12/17 17:00:00', '123746789' );
insert into consultation_assistant values ('987656789', '2019/11/17 17:00:00', '123746789' );
insert into consultation_assistant values ('987656789', '2019/12/17 17:00:00', '123746789' );

-- diagnostic_code
insert into diagnostic_code values ('D105','constipacao dental');
insert into diagnostic_code values ('D106','dor no dente');
insert into diagnostic_code values ('D200','dentes tortos');
insert into diagnostic_code values ('D204','dentes muito tortos');
insert into diagnostic_code values ('D000','esta a fingir');
insert into diagnostic_code values ('D501','infectious disease');
insert into diagnostic_code values ('D502','dental cavities');
insert into diagnostic_code values ('D12','gingivitis');


-- diagnostic_code_relation

insert into diagnostic_code_relation values ('D105','D106','dor aguda');
insert into diagnostic_code_relation values ('D200','D204','aparelho');

-- consultation_diagnostic

insert into consultation_diagnostic values ('123456789', '2019/11/17 17:00:00','D12');
insert into consultation_diagnostic values ('987654321', '2019/12/17 17:00:00','D12');
insert into consultation_diagnostic values ('987656789', '2019/11/17 17:00:00','D204');
insert into consultation_diagnostic values ('987654321', '2019/11/17 17:00:00','D12');
insert into consultation_diagnostic values ('123456789', '2019/12/17 17:00:00','D12');
insert into consultation_diagnostic values ('987656789', '2019/12/17 17:00:00','D502');

-- medication

insert into medication values ('palmada','mae');
insert into medication values ('medication1','lab1');
insert into medication values ('medication2','lab1');

-- prescription

insert into prescription values ('palmada','mae','123456789', '2019/11/17 17:00:00','D12','qdo se porta mal','bem dado');
insert into prescription values ('medication1','lab1','987654321', '2019/12/17 17:00:00','D12','4 em 4 horas','nao esquecer');
insert into prescription values ('medication2','lab1','987656789', '2019/11/17 17:00:00','D204','2 em 2 horas','nao esquecer');
insert into prescription values ('medication2','lab1','987654321','2019/11/17 17:00:00','D12','2 em 2 horas','nao esquecer');
insert into prescription values ('medication2','lab1','123456789', '2019/12/17 17:00:00','D12','2 em 2 horas','nao esquecer');
insert into prescription values ('medication1','lab1','987656789', '2019/12/17 17:00:00','D502','2 em 2 horas','nao esquecer');

-- procedure

insert into _procedure values ('d4 charting', 'dental charting');
insert into _procedure values ('leg radiography', 'x-ray');
insert into _procedure values ('arm radiography', 'x-ray');

-- procedure_in_consultation

insert into procedure_in_consultation values ('d4 charting', '123456789', '2019/11/17 17:00:00', 'arrancar');
insert into procedure_in_consultation values ('d4 charting', '123456789', '2019/12/17 17:00:00', 'arrancar');
insert into procedure_in_consultation values ('leg radiography', '987656789', '2019/11/17 17:00:00', 'fotografar');
insert into procedure_in_consultation values ('leg radiography', '123456789', '2019/11/17 17:00:00', 'correu mal');
insert into procedure_in_consultation values ('leg radiography', '123456789', '2019/12/17 17:00:00', 'partido');
insert into procedure_in_consultation values ('arm radiography', '123456789', '2019/11/17 17:00:00', 'fraturado');

-- procedure radiology

insert into procedure_radiology values ('leg radiography','file1', '987656789', '2019/11/17 17:00:00');
insert into procedure_radiology values ('leg radiography','file 2', '123456789', '2019/11/17 17:00:00');
insert into procedure_radiology values ('leg radiography','file 3', '123456789', '2019/11/17 17:00:00');
insert into procedure_radiology values ('arm radiography','file4', '123456789', '2019/11/17 17:00:00');


-- teeth
insert into teeth values ('1','1','dente1');
insert into teeth values ('1','2','dente2');
insert into teeth values ('1','3','dente3');
insert into teeth values ('2','1','dente1');
insert into teeth values ('2','2','dente2');
insert into teeth values ('2','3','dente3');


-- procedure charting
insert into procedure_charting values ('d4 charting', '123456789', '2019/11/17 17:00:00','1','1','jabcw','2');
insert into procedure_charting values ('d4 charting', '123456789', '2019/11/17 17:00:00','1','2','ajc','5');
insert into procedure_charting values ('d4 charting', '123456789', '2019/11/17 17:00:00','1','3','ajc','10');
insert into procedure_charting values ('d4 charting', '123456789', '2019/12/17 17:00:00','2','3','ajc','3');
insert into procedure_charting values ('d4 charting', '123456789', '2019/12/17 17:00:00','1','1','ajc','3');
insert into procedure_charting values ('d4 charting', '123456789', '2019/12/17 17:00:00','2','2','ajc','2');
