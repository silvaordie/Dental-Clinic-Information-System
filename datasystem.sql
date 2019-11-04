drop table if exists employee;
drop table if exists phone_number_employee;
drop table if exists receptionist;
drop table if exists doctor;
drop table if exists nurse;
drop table if exists client;
drop table if exists phone_number_client;
drop table if exists permanent_doctor;
drop table if exists trainee_doctor;
drop table if exists supervision_report;
drop table if exists appointment;
drop table if exists consultation;
drop table if exists consultation_assitant;
drop table if exists diagnostic_code;
drop table if exists diagnostic_code_relation;
drop table if exists consultation_diagnostic;
drop table if exists medication;
drop table if exists prescription;
drop table if exists _procedure;
drop table if exists procedure_in_cosultation;
drop table if exists procedure_radiology;
drop table if exists teeth;
drop table if exists procedure_charting;


create table employee
   (VAT char(10),
   name varchar(255),
   birth_date DATE,
   street varchar(255),
   city varchar(255),
   zip char(9),
   IBAN char(26) unique not null,
   salary numeric(20,2) CHECK (salary > 0),
   primary key (VAT));

create table phone_number_employee
   (phone char(10),
   VAT char(10),
   primary key(VAT, phone),
   foreign key(VAT)
    references(employee(VAT)));

create table receptionist
   (VAT char(10),
   primary key(VAT)
   foreign key(VAT)
    references (employee(VAT)) on delete cascade);

create table doctor
   (VAT char(10),
   specialization varchar(255),
   biography varchar(255),
   e-mail varchar(255) unique,
   primary key(VAT),
   foreign key(VAT)
    references (employee(VAT)) on delete cascade);

create table nurse
   (VAT char(10),
   primary key(VAT)
   foreign key(VAT)
    references (employee(VAT)) on delete cascade);

create table client
   (VAT char(10),
   name varchar(255),
   birth_date DATE,
   street varchar(255),
   city varchar(255),
   zip char(9),
   gender char(2),
   age int, --age = (current_date - birthdate).years
   primary key (VAT));

create table phone_number_client
   (phone char(10),
   VAT char(10),
   primary key(VAT,phone),
   foreign key(VAT)
    references(client(VAT)));

create table permanent_doctor
   (VAT char(10),
   primary key(VAT),
   foreign key(VAT)
    references (doctor(VAT)) on delete cascade);

create table trainee_doctor
   (VAT char(10),
   years int,
   supervisor char(10),
   foreign key(VAT)
    references(doctor(VAT)),
   foreign key(supervisor)
    references (permanent_doctor(supervisor)) on delete cascade,
   primary key (VAT));

create table supervision_report
   (VAT char(10),
   date_timestamp DATE,
   description varchar(255),
   evaluation int constraint CHECK(evaluation <=5) AND (evaluation >= 5),
   foreign key(VAT)
    references (trainee_doctor(VAT)),
   primary key (VAT, date_timestamp)
   );

create table appointment
   (VAT_doctor char(10),
   date_timestamp DATE,
   description varchar(255),
   VAT_client char(10),
   primary key(date_timestamp),
   foreign key(VAT_doctor)
    references (doctor(VAT)) on delete cascade,
   foreign key(VAT_client)
    references (client(VAT)),
   primary key (VAT_doctor, date_timestamp));

create table consultation
   (VAT_doctor char(10),
   date_timestamp DATE,
   SOAP_S varchar(255),
   SOAP_O varchar(255),
   SOAP_A varchar(255),
   SOAP_P varchar(255),
   foreign key(VAT_doctor)
    references (appointment(VAT_doctor)),
   foreign key(date_timestamp)
    references (appointment(VAT_doctor)),
   primary key (VAT_doctor, date_timestamp)
   );

create table consultation_assitant
   (VAT_doctor char(10),
   date_timestamp DATE,
   VAT_nurse char(10),
   foreign key (VAT_doctor)
    references (appointment(VAT_doctor)),
   foreign key (date_timestamp)
    references (appointment(date_timestamp)),
   foreign key (VAT_nurse)
    references (nurse(VAT)) on delete cascade,
   primary key (VAT_doctor, date_timestamp));

create table diagnostic_code
   (ID varchar(255),
   description varchar(255),
   primary key(ID),
   );

create table diagnostic_code_relation
   (ID1 varchar(255),
   ID2 varchar(255),
   type varchar(255),
   foreign key(ID1)
    references (diagnostic_code(ID)),
   foreign key(ID2)
    references (diagnostic_code(ID)),
   primary key (ID1, ID2));

create table consultation_diagnostic
   (VAT_doctor char(10),
   date_timestamp DATE,
   ID varchar(255),
   foreign key (VAT_doctor)
    references (consultation(VAT_doctor)),
   foreign key (date_timestamp)
    references (consultation(date_timestamp)),
   foreign key (ID)
    references (diagnostic_code(ID)),
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
   foreign key (VAT_doctor),
    references (consultation_diagnostic(VAT_doctor)),
   foreign key (date_timestamp)
    references (consultation_diagnostic(VAT_doctor)),
   foreign key (ID)
    references (consultation_diagnostic(ID)),
   foreign key (name)
    references (medication(name)),
   foreign key (lab)
    references (medication(lab)),
   primary key (name, VAT_doctor, date_timestamp, ID));

create table _procedure
   (name varchar(255),
   type varchar (255)
   primary key (name));

create table procedure_in_cosultation
   (name varchar(255),
   VAT_doctor char(10),
   date_timestamp DATE,
   description varchar(255),
   foreign key (VAT_doctor),
    references (consultation(VAT_doctor)),
   foreign key (date_timestamp)
    references (consultation(date_timestamp)),
   foreign key (name)
    references (_procedure(name)),
   primary key (name, VAT_doctor, date_timestamp)
   );

create table procedure_radiology
   (name varchar(255),
   file varchar(255),
   VAT_doctor char(10),
   date_timestamp DATE,
   primary key (file, name, VAT_doctor, date_timestamp)
   foreign key (VAT_doctor),
    references (consultation_diagnostic),
   foreign key (date_timestamp)
    references (consultation_diagnostic),
   foreign key (name)
    references (_procedure));

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
   foreign key(name),
      references (procedure_in_cosultation(name)),
   foreign key(VAT),
      references (procedure_in_cosultation(VAT_doctor)),
   foreign key(date_timestamp)
      references(procedure_in_cosultation(date_timestamp)),
   foreign key (quadrant)
      references(teeth(quadrant)),
   foreign key (number)
      references (teeth(number)),
   primary key (name, VAT, date_timestamp, quadrant, number)
   );

--		employees
insert into employee values ('123456789', 'Jane Sweettooth', TO_DATE('17/12/1990', 'DD/MM/YYYY'), 'rua', 'cidade', '2780-255', 'PT50567891234567891234567', 900);
insert into employee values ('987654321', 'Julia Sweettooth', TO_DATE('17/12/1990', 'DD/MM/YYYY'), 'rua2', 'cidade2', '2780-260', 'PT50567891231234891234567', 600);
insert into employee values ('123746789', 'Jane Dentedoce', TO_DATE('17/12/1980', 'DD/MM/YYYY'), 'rua2', 'cidade3', '2770-255', 'PT50567896734567891234567', 1000);
insert into employee values ('987656789', 'Julio Isidro', TO_DATE('17/12/1200', 'DD/MM/YYYY'), 'rua', 'cidade2', '2780-485', 'PT50123491234567891234666', 666.80);
insert into employee values ('123458889', 'João Baião', TO_DATE('17/12/1805', 'DD/MM/YYYY'), 'rua7', 'cidade3', '2780-777', 'PT50567891234567895432167', 9600);

--		doctors
insert into doctor values ('123456789', 'Expert em caries', 'Boa aluna, mas pessima a tirar sisos','Jane@bluetooth.com');
insert into doctor values ('987654321', 'Expert em sisos', '3 meses na clinica e ja se fartou','Julia@bluetooth.com');
insert into doctor values ('987656789', 'Expert em piropos', 'Trabalha pouco fala muito','Julio@bluetooth.com');

--    nurses
insert into nurse values ('123746789');

--		permanent_doctors 
insert into permanent_doctors values ('123456789');

--		trainee_doctors 
insert into trainee_doctors values ('987654321', 0, '123456789');
insert into trainee_doctors values ('987656789', 1, '123456789');

--		supervision_reports 
insert into supervision_reports values ('987654321', TO_DATE('17/12/2018', 'DD/MM/YYYY'), 'Boa moça a Julia', 4);
insert into supervision_reports values ('987656789', TO_DATE('17/12/2018', 'DD/MM/YYYY'), 'Mais piropos', 1);
insert into supervision_reports values ('987656789', TO_DATE('17/12/2017', 'DD/MM/YYYY'), 'insufficient', 3);

--		clients 
insert into clients values ('999999999', 'José Bebé', TO_DATE('17/12/1990', 'DD/MM/YYYY'), 'rua3', 'cidade1', '2780-255', 'M' , 26);
insert into clients values ('888888888', 'Hugo Burro', TO_DATE('17/12/1890', 'DD/MM/YYYY'), 'rua1', 'cidade5', '2780-255', 'M' , 26);
insert into clients values ('777777777', 'Pedro Cebo', TO_DATE('17/12/1890', 'DD/MM/YYYY'), 'rua1', 'cidade5', '2780-255', 'M' , 26);
insert into clients values ('666666666', 'Filipe Bibe', TO_DATE('17/12/1890', 'DD/MM/YYYY'), 'rua1', 'cidade5', '2780-255', 'M' , 26);

--    appointments
insert into consultation values ('123456789', TO_DATE('17/11/2019', 'DD/MM/YYYY'), 'rotina', '999999999');
insert into consultation values ('123456789', TO_DATE('17/12/2019', 'DD/MM/YYYY'), 'follow-up', '999999999');
insert into consultation values ('987654321', TO_DATE('17/11/2019', 'DD/MM/YYYY'), 'rotina'), '888888888';
insert into consultation values ('987654321', TO_DATE('17/12/2019', 'DD/MM/YYYY'), 'follow-up', '888888888');
insert into consultation values ('987656789', TO_DATE('17/11/2019', 'DD/MM/YYYY'), 'rotina', '777777777');
insert into consultation values ('987656789', TO_DATE('17/12/2019', 'DD/MM/YYYY'), 'follow-up', '777777777');
insert into consultation values ('987656789', TO_DATE('17/11/2017', 'DD/MM/YYYY'), 'rotina', '666666666');
insert into consultation values ('987656789', TO_DATE('17/12/2017', 'DD/MM/YYYY'), 'follow-up', '666666666');
--    consultations
insert into consultation values ('123456789', TO_DATE('17/11/2019', 'DD/MM/YYYY'), 's', 'gingivitis', 'a', 'p' );
insert into consultation values ('123456789', TO_DATE('17/12/2019', 'DD/MM/YYYY'), 's', 'periodontitis', 'a', 'p' );
insert into consultation values ('987654321', TO_DATE('17/11/2019', 'DD/MM/YYYY'), 's', 'gingivitis', 'a', 'p' );
insert into consultation values ('987654321', TO_DATE('17/12/2019', 'DD/MM/YYYY'), 's', 'periodontitis', 'a', 'p' );
insert into consultation values ('987656789', TO_DATE('17/11/2019', 'DD/MM/YYYY'), 's', 'o', 'a', 'p' );
insert into consultation values ('987656789', TO_DATE('17/12/2019', 'DD/MM/YYYY'), 's', 'o', 'a', 'p' );

--    consultation_assistants
insert into consultation_assistants values ('123456789', TO_DATE('17/11/2019', 'DD/MM/YYYY'), '123746789' );
insert into consultation_assistants values ('123456789', TO_DATE('17/12/2019', 'DD/MM/YYYY'), '123746789' );
insert into consultation_assistants values ('987654321', TO_DATE('17/11/2019', 'DD/MM/YYYY'), '123746789' );
insert into consultation_assistants values ('987654321', TO_DATE('17/12/2019', 'DD/MM/YYYY'), '123746789' );
insert into consultation_assistants values ('987656789', TO_DATE('17/11/2019', 'DD/MM/YYYY'), '123746789' );
insert into consultation_assistants values ('987656789', TO_DATE('17/12/2019', 'DD/MM/YYYY'), '123746789' );