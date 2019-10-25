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
drop table if exists procedure;
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
   salary float,
   primary key (VAT));

create table phone_number_employee
   (phone char(10),
   VAT char(10),
   primary key(phone),
   foreign key(VAT))
    references(employee));

create table receptionist
   (VAT char(10),
   primary key(VAT)
   foreign key(VAT)
    references employee);

create table doctor
   (VAT char(10),
   specialization varchar(255),
   biography varchar(255),
   e-mail varchar(255) unique,
   primary key(VAT)
   foreign key(VAT)
    references employee);

create table nurse
   (VAT char(10),
   primary key(VAT)
   foreign key(VAT)
    references employee);

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
   primary key(phone),
   foreign key(VAT))
    references(client));

create table permanent_doctor
   (VAT char(10),
   primary key(VAT)
   foreign key(VAT)
    references doctor);

create table trainee_doctor
   (VAT char(10),
   years int,
   primary key(VAT)
   foreign key(VAT)
    references employee);

create table supervision_report
   ();

create table appointment
   ();

create table consultation
   ();

create table consultation_assitant
   ();

create table diagnostic_code
   ();

create table diagnostic_code_relation
   ();

create table consultation_diagnostic
   ();

create table medication
   ();

create table prescription
   ();

create table procedure
   ();

create table procedure_in_cosultation
   ();

create table procedure_radiology
   ();

create table teeth
   ();

create table procedure_charting
   ();




