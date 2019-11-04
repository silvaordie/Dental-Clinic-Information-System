--Perguntar o always assigned to
--Candidate keys
--"Are either receptionists, nurses or doctors"
--on delete cascade
-- numeric
-- como usar "procedure", "name", "file"
-- Derived from DATE
-- /0

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
   IBAN char(26) unique,
   salary float CHECK (slary > 0),
   primary key (VAT));

create table phone_number_employee
   (phone char(10),
   VAT char(10),
   primary key(VAT, phone),
   foreign key(VAT)
    references employee(VAT));

create table receptionist
   (VAT char(10),
   primary key(VAT)
   foreign key(VAT)
    references (employee(VAT)));

create table doctor
   (VAT char(10),
   specialization varchar(255),
   biography varchar(255),
   e-mail varchar(255) unique,
   primary key(VAT),
   foreign key(VAT)
    references (employee(VAT)));

create table nurse
   (VAT char(10),
   primary key(VAT)
   foreign key(VAT)
    references (employee(VAT)));

create table client
   (VAT char(10),
   name varchar(255),
   birth_date DATE,
   street varchar(255),
   city varchar(255),
   zip char(9),
   gender char(2),
   salary float,
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
    references (doctor(VAT)));

create table trainee_doctor
   (VAT char(10),
   years int,
   foreign key(VAT)
    references(doctor(VAT)),
   foreign key(supervisor)
    references (permanent_doctor(supervisor)),
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
    references (doctor(VAT)),
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
    references (nurse(VAT)),
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




