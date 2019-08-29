BEGIN;

CREATE TABLE dataset_2015 (
SAMPLE	integer,	
SERIAL     varchar,
HHWT      integer,
GEO1_MX   integer,
GEO2_MX   varchar ,
ELECTRIC  integer,
WATSUP    integer,
SEWAGE    integer,
ROOMS     integer,
BEDROOMS  integer,
TOILET    integer,
FLOOR     integer,
PERNUM    integer,
PERWT     integer,
RELATE    integer,
RELATED   integer,
AGE       integer,
AGE2      integer,
SEX       integer,
SCHOOL    integer,
LIT       integer,
EDATTAIN  integer,
EDATTAIND integer,
YRSCHOOL  integer,
EDUCMX    integer,
MIGMX2    integer);



CREATE TABLE states2015 (GEO1_MX integer, state varchar );
CREATE TABLE electric (electric integer, value varchar);
CREATE TABLE water (water integer, value varchar);
CREATE TABLE sewage (sewage integer, value varchar);
CREATE TABLE relate (relate integer, value varchar);
CREATE TABLE relate_detailed (relate_detailed integer, value varchar);
CREATE TABLE age (age integer, value varchar);
CREATE TABLE age_interval (age_interval integer, value varchar);
CREATE TABLE sex (sex integer, value varchar);
CREATE TABLE school (school integer, value varchar);
CREATE TABLE literacy (literacy integer, value varchar);
CREATE TABLE edattain (edattain integer, value varchar);
CREATE TABLE edattain_detailed (edattain_detailed integer, value varchar);
CREATE TABLE years_school (years_school integer, value varchar);
CREATE TABLE educ_attained (educ_attained integer, value varchar);
CREATE TABLE state_5yearsago (state_5yearsago integer, value varchar);
CREATE TABLE rooms (rooms integer, value varchar);
CREATE TABLE bedrooms (bedrooms integer, value varchar);
CREATE TABLE toilet (toilet integer, value varchar);
CREATE TABLE floor (floor integer, value varchar);


COMMIT;

