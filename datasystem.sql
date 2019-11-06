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

create table phone_number_employee
   (phone char(10),
   VAT char(10),
   primary key(VAT, phone),
   foreign key(VAT)
    references employee(VAT));

create table receptionist
   (VAT char(10),
   primary key(VAT),
   foreign key(VAT)
    references employee(VAT) on delete cascade);

create table doctor
   (VAT char(10),
   specialization varchar(255),
   biography varchar(255),
   email varchar(255) unique,
   primary key(VAT),
   foreign key(VAT)
    references employee(VAT) on delete cascade);

create table nurse
   (VAT char(10),
   primary key(VAT),
   foreign key(VAT)
    references employee(VAT) on delete cascade);

create table client
   (VAT char(10),
   name varchar(255),
   birth_date DATE,
   street varchar(255),
   city varchar(255),
   zip char(9),
   gender char(2),
   age int,
   primary key (VAT));

create table phone_number_client
   (phone char(10),
   VAT char(10),
   primary key(VAT,phone),
   foreign key(VAT)
    references client(VAT));

create table permanent_doctor
   (VAT char(10),
   primary key(VAT),
   foreign key(VAT)
    references doctor(VAT) on delete cascade);

create table trainee_doctor
   (VAT char(10),
   supervisor char(10),
   foreign key(VAT)
    references doctor(VAT),
   foreign key(supervisor)
    references permanent_doctor(VAT),
   primary key (VAT) );

create table supervision_report
   (VAT char(10),
   date_timestamp DATE,
   description varchar(255),
   evaluation int CHECK (evaluation <=5 AND evaluation >= 5),
   foreign key(VAT)
    references trainee_doctor(VAT),
   primary key (VAT, date_timestamp)
   );

create table appointment
   (VAT_doctor char(10),
   date_timestamp DATE,
   description varchar(255),
   VAT_client char(10),
   foreign key(VAT_doctor)
    references doctor(VAT),
   foreign key(VAT_client)
    references client(VAT),
   primary key (VAT_doctor, date_timestamp));

create table consultation
   (VAT_doctor char(10),
   date_timestamp DATE,
   SOAP_S varchar(255),
   SOAP_O varchar(255),
   SOAP_A varchar(255),
   SOAP_P varchar(255),
   foreign key(VAT_doctor,date_timestamp)
    references appointment(VAT_doctor, date_timestamp),
   primary key (VAT_doctor, date_timestamp)
   );

create table consultation_assistant
   (VAT_doctor char(10),
   date_timestamp DATE,
   VAT_nurse char(10),
   foreign key(VAT_doctor,date_timestamp)
    references appointment(VAT_doctor, date_timestamp),
   foreign key (VAT_nurse)
    references nurse(VAT) on delete cascade,
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
    references diagnostic_code(ID),
   foreign key(ID2)
    references diagnostic_code(ID),
   primary key (ID1, ID2));

create table consultation_diagnostic
   (VAT_doctor char(10),
   date_timestamp DATE,
   ID varchar(255),
   foreign key (VAT_doctor, date_timestamp)
    references consultation(VAT_doctor, date_timestamp),
   foreign key (ID)
    references diagnostic_code(ID),
   primary key (VAT_doctor, date_timestamp, ID));

create table medication
   (name varchar(255),
   lab varchar(255),
   primary key(name, lab));

create table prescription
   (name varchar(255),
   lab varchar(255),
   VAT_doctor char(10),
   date_timestamp DATE,
   ID varchar(255),
   dosage varchar(255),
   description varchar(255),
   foreign key (VAT_doctor, date_timestamp,ID)
    references consultation_diagnostic(VAT_doctor, date_timestamp,ID),
   foreign key (name,lab)
    references medication(name,lab),
   primary key (name, VAT_doctor, date_timestamp, ID));

create table _procedure
   (name varchar(255),
   type varchar (255),
   primary key (name));

create table procedure_in_consultation
   (name varchar(255),
   VAT_doctor char(10),
   date_timestamp DATE,
   description varchar(255),
   foreign key (VAT_doctor,date_timestamp)
    references consultation(VAT_doctor, date_timestamp),
   foreign key (name)
    references _procedure(name),
   primary key (name, VAT_doctor, date_timestamp)
   );

create table procedure_radiology
   (name varchar(255),
   file varchar(255),
   VAT_doctor char(10),
   date_timestamp DATE,
   primary key (file, name, VAT_doctor, date_timestamp),
   foreign key (VAT_doctor,date_timestamp)
    references consultation_diagnostic(VAT_doctor,date_timestamp),
   foreign key (name)
    references _procedure(name));

create table teeth
   (quadrant char(2),
   number char(3),
   name varchar(255),
   primary key(quadrant, number));

create table procedure_charting
   (name varchar(255),
   VAT char(10),
   date_timestamp DATE,
   quadrant char(2),
   number char(3),
   foreign key(name, VAT, date_timestamp)
      references procedure_in_consultation(name, VAT_doctor, date_timestamp),
   foreign key (quadrant, number)
      references teeth(quadrant, number),
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
insert into permanent_doctor values ('123456789');

--		trainee_doctors 
insert into trainee_doctor values ('987654321','123456789');
insert into trainee_doctor values ('987656789', '123456789');

--		supervision_reports 
insert into supervision_report values ('987654321', '2018/12/17', 'Boa moça a Julia', 4);
insert into supervision_report values ('987656789', '2018/12/17', 'Mais piropos', 2);
insert into supervision_report values ('987656789', '2017/12/17', 'insufficient', 3);

--    appointments
insert into appointment values ('123456789', '2019/11/17', 'rotina', '999999999');
insert into appointment values ('123456789', '2019/12/17', 'follow-up', '999999999');
insert into appointment values ('987654321', '2019/11/17', 'rotina', '888888888');
insert into appointment values ('987654321', '2019/12/17', 'follow-up', '888888888');
insert into appointment values ('987656789', '2019/11/17', 'rotina', '777777777');
insert into appointment values ('987656789', '2019/12/17', 'follow-up', '777777777');
insert into appointment values ('987656789', '2019/10/17', 'follow-up', '666666666');

--    consultations
insert into consultation values ('123456789', '2019/11/17', 's', 'gingivitis', 'a', 'p' );
insert into consultation values ('123456789', '2019/12/17', 's', 'periodontitis', 'a', 'p' );
insert into consultation values ('987654321', '2019/12/17', 's', 'gingivitis', 'a', 'p' );
insert into consultation values ('987654321', '2019/11/17', 's', 'periodontitis', 'a', 'p' );
insert into consultation values ('987656789', '2019/11/17', 's', 'o', 'a', 'p' );
insert into consultation values ('987656789', '2019/12/17', 's', 'o', 'a', 'p' );

--    consultation_assistants
insert into consultation_assistant values ('123456789', '2019/11/17', '123746789' );
insert into consultation_assistant values ('123456789', '2019/12/17', '123746789' );
insert into consultation_assistant values ('987654321','2019/11/17', '123746789' );
insert into consultation_assistant values ('987654321', '2019/12/17', '123746789' );
insert into consultation_assistant values ('987656789', '2019/11/17', '123746789' );
insert into consultation_assistant values ('987656789', '2019/12/17', '123746789' );

-- diagnostic_code
insert into diagnostic_code values ('D105','constipacao dental');
insert into diagnostic_code values ('D106','dor no dente');
insert into diagnostic_code values ('D200','dentes tortos');
insert into diagnostic_code values ('D204','dentes muito tortos');
insert into diagnostic_code values ('D000','esta a fingir');
insert into diagnostic_code values ('D501','infectious  disease');
insert into diagnostic_code values ('D502','dental  cavities');


-- diagnostic_code_relation

insert into diagnostic_code_relation values ('D105','D106','dor aguda');
insert into diagnostic_code_relation values ('D200','D204','aparelho');

-- consultation_diagnostic

insert into consultation_diagnostic values ('123456789', '2019/11/17','D000');
insert into consultation_diagnostic values ('987654321', '2019/12/17','D204');
insert into consultation_diagnostic values ('987656789', '2019/11/17','D204');
insert into consultation_diagnostic values ('987654321','2019/11/17','D204');
insert into consultation_diagnostic values ('123456789', '2019/12/17','D501');
insert into consultation_diagnostic values ('987656789', '2019/12/17','D502');

-- medication

insert into medication values ('palmada','mae');
insert into medication values ('medication1','lab1');
insert into medication values ('medication2','lab1');

-- prescription

insert into prescription values ('palmada','mae','123456789', '2019/11/17','D000','qdo se porta mal','bem dado');
insert into prescription values ('medication1','lab1','987654321', '2019/12/17','D204','4 em 4 horas','nao esquecer');
insert into prescription values ('medication2','lab1','987656789', '2019/11/17','D204','2 em 2 horas','nao esquecer');
insert into prescription values ('medication2','lab1','987654321','2019/11/17','D204','2 em 2 horas','nao esquecer');
insert into prescription values ('medication2','lab1','123456789', '2019/12/17','D501','2 em 2 horas','nao esquecer');
insert into prescription values ('medication1','lab1','987656789', '2019/12/17','D502','2 em 2 horas','nao esquecer');






