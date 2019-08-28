
CREATE DATABASE mexico ;

\c mexico 

## user postgres par defaut à l'install 
## PASSWORD mexicoigast

CREATE USER m2igast WITH ENCRYPTED PASSWORD 'm2igast';
GRANT SELECT ON ALL TABLES IN SCHEMA public TO m2igast;


############### dans un SHELL à l'endroit du fichier geo2_mx1960_2015.shp
shp2pgsql -s 4326 geo2_mx1960_2015 public.mexico_lvl2 > mexico_lvl2.sql

## puis 


sudo -u postgres  psql -d mexico  -U postgres -f /tmp/mexico_lvl2.sql


## de nouveau dans le shel psql : 

ALTER TABLE mexico_lvl2 DROP COLUMN cntry_code ;
ALTER TABLE mexico_lvl2 DROP COLUMN cntry_name ;
ALTER TABLE mexico_lvl2 ALTER COLUMN parent TYPE integer ;


## pour référencer depuis le dataset
ALTER TABLE mexico_lvl2 ADD CONSTRAINT unique_geolevel2 UNIQUE ; 
UPDATE mexico_lvl2 SET parent = 484000 + parent ;



CREATE TABLE dataset_2015 (
SAMPLE	integer,	
SERIAL     varchar,
HHWT      integer,
GEO1_MX   integer,
GEO2_MX   varchar REFERENCES mexico_lvl2(geolevel2),
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




COPY dataset_2015 FROM '/tmp/mexico2015_NA_insteadof_NIU.csv'  WITH (FORMAT CSV, DELIMITER ',', NULL 'NA', HEADER); 

## 11344365 lignes avec mon fichier 
SELECT count(*) from dataset_2015 ;
SELECT admin_name, geolevel2 FROM  mexico_lvl2 LIMIT 10 ;



## table des états

CREATE TABLE states2015 (GEO1_MX integer, state varchar ) ; 
COPY states2015 FROM '/tmp/geo1_2015.csv'  WITH (FORMAT CSV, DELIMITER ',', NULL 'NA', HEADER); 
ALTER TABLE states2015 ADD CONSTRAINT unique_geolevel1 UNIQUE (GEO1_MX) ; 





# clé étrangère du dataset sur table states
#le code GEO1_MX de la table dataset est donné par la concaténation de code pays (484) + code state 

UPDATE states2015 SET GEO1_MX = 484000 + GEO1_MX ;

# idem pour la clé parent de  mexico_lvl2 qui reference states2015
ALTER TABLE mexico_lvl2 
ADD CONSTRAINT state2015_fkey FOREIGN KEY (parent) REFERENCES states2015 (GEO1_MX);


# ELECTRIC

CREATE TABLE electric (electric integer, value varchar);

INSERT INTO electric VALUES 
(1,'Yes'),
(2,'No'),
(9,'Unknown') ;

CREATE TABLE water (water integer, value varchar);

INSERT INTO water VALUES
(10,'Yes, piped water'),
(11,'Piped inside dwelling'),
(12,'Piped, exclusively to this household'),
(13,'Piped, shared with other households'),
(14,'Piped outside the dwelling'),
(15,'Piped outside dwelling, in building'),
(16,'Piped within the building or plot of land'),
(17,'Piped outside the building or lot'),
(18,'Have access to public piped water'),
(20,'No piped water'),
(99,'Unknown');

CREATE TABLE sewage (sewage integer, value varchar);

INSERT INTO sewage VALUES
(10,'Connected to sewage system or septic tank'),
(11,'Sewage system (public sewage disposal)'),
(12,'Septic tank (private sewage disposal)'),
(20,'Not connected to sewage disposal system'),
(99,'Unknown');


CREATE TABLE rooms (rooms integer, value varchar);

INSERT INTO rooms VALUES
(00,'Part of a room; no rooms'),
(01,'1'),
(02,'2'),
(03,'3'),
(04,'4'),
(05,'5'),
(06,'6'),
(07,'7'),
(08,'8'),
(09,'9'),
(10,'10'),
(11,'11'),
(12,'12'),
(13,'13'),
(14,'14'),
(15,'15'),
(16,'16'),
(17,'17'),
(18,'18'),
(19,'19'),
(20,'20'),
(21,'21'),
(22,'22'),
(23,'23'),
(24,'24'),
(25,'25'),
(26,'26'),
(27,'27'),
(28,'28'),
(29,'29'),
(30,'30+'),
(98,'Unknown');

CREATE TABLE bedrooms (bedrooms integer, value varchar);

INSERT INTO bedrooms VALUES
(00,'No bedrooms'),
(01,'1'),
(02,'2'),
(03,'3'),
(04,'4'),
(05,'5'),
(06,'6'),
(07,'7'),
(08,'8'),
(09,'9'),
(10,'10'),
(11,'11'),
(12,'12'),
(13,'13'),
(14,'14'),
(15,'15'),
(16,'16'),
(17,'17'),
(18,'18'),
(19,'19'),
(20,'20+'),
(98,'Unknown');

CREATE TABLE toilet (toilet integer, value varchar);

INSERT INTO toilet VALUES
(10,'No toilet'),
(11,'No flush toilet'),
(20,'Have toilet, type not specified'),
(21,'Flush toilet'),
(22,'Non-flush, latrine'),
(23,'Non-flush, other and unspecified'),
(99,'Unknown');


CREATE TABLE floor (floor integer, value varchar);

INSERT INTO floor VALUES
(100,'None/unfinished (earth)'),
(110,'Sand'),
(120,'Dung'),
(200,'Finished'),
(201,'Cement, tile, or brick'),
(202,'Cement'),
(203,'Concrete'),
(204,'Cement screed'),
(205,'Ceramic tile'),
(206,'Paving stone, cement tile'),
(207,'Stone'),
(208,'Brick'),
(209,'Brick or stone'),
(210,'Brick or cement'),
(211,'Block'),
(212,'Terrazzo'),
(213,'Wood'),
(214,'Palm, bamboo'),
(215,'Parquet'),
(216,'Parquet, tile, vinyl'),
(217,'Parquet, tile, marble'),
(218,'Ceramic, marble, granite'),
(219,'Ceramic, marble, tile, or vinyl'),
(220,'Marble'),
(221,'Mosaic'),
(222,'Tile'),
(223,'Tile, linoleum, ceramic, etc'),
(224,'Tile, cement'),
(225,'Tile, stone'),
(226,'Tile, stone, brick'),
(227,'Tile, stone, vinyl, brick'),
(228,'Tile, vinyl, brick'),
(229,'Tile, vinyl'),
(230,'Vinyl, linoleum, etc'),
(231,'Asphalt sheet, vinyl, etc'),
(232,'Synthetic, plastic'),
(233,'Cane'),
(234,'Carpet'),
(235,'Scrap material'),
(236,'Other finished, n.e.c.'),
(999,'Unknown/missing');



# relationship to houshold head (simple version) 
CREATE TABLE relate (relate integer, value varchar);

INSERT INTO relate VALUES
(1,'Head'),
(2,'Spouse/partner'),
(3,'Child'),
(4,'Other relative'),
(5,'Non-relative'),
(6,'Other relative or non-relative'),
(9,'Unknown');


# Relationship to household head [detailed version]
CREATE TABLE relate_detailed (relate_detailed integer, value varchar);
INSERT INTO relate_detailed VALUES 
(1000,'Head'),
(2000,'Spouse/partner'),
(2100,'Spouse'),
(2200,'Unmarried partner'),
(2300,'Same-sex spouse/partner'),
(3000,'Child'),
(3100,'Biological child'),
(3200,'Adopted child'),
(3300,'Stepchild'),
(3400,'Child/child-in-law'),
(3500,'Child/child-in-law/grandchild'),
(3600,'Child of unmarried partner'),
(4000,'Other relative'),
(4100,'Grandchild'),
(4110,'Grandchild or great grandchild'),
(4120,'Great grandchild'),
(4130,'Great-great grandchild'),
(4200,'Parent/parent-in-law'),
(4210,'Parent'),
(4211,'Stepparent'),
(4220,'Parent-in-law'),
(4300,'Child-in-law'),
(4301,'Daughter-in-law'),
(4302,'Spouse/partner of child'),
(4310,'Unmarried partner of child'),
(4400,'Sibling/sibling-in-law'),
(4410,'Sibling'),
(4420,'Stepsibling'),
(4430,'Sibling-in-law'),
(4431,'Sibling of spouse/partner'),
(4432,'Spouse/partner of sibling'),
(4500,'Grandparent'),
(4510,'Great grandparent'),
(4600,'Parent/grandparent/ascendant'),
(4700,'Aunt/uncle'),
(4800,'Other specified relative'),
(4810,'Nephew/niece'),
(4820,'Cousin'),
(4830,'Sibling of sibling-in-law'),
(4900,'Other relative, not elsewhere classified'),
(4910,'Other relative with same family name'),
(4920,'Other relative with different family name'),
(4930,'Other relative, not specified (secondary family)'),
(5000,'Non-relative'),
(5100,'Friend/guest/visitor/partner'),
(5110,'Partner/friend'),
(5111,'Friend'),
(5112,'Partner/roommate'),
(5113,'Housemate/roommate'),
(5120,'Visitor'),
(5130,'Ex-spouse'),
(5140,'Godparent'),
(5150,'Godchild'),
(5200,'Employee'),
(5210,'Domestic employee'),
(5220,'Relative of employee, n.s.'),
(5221,'Spouse of servant'),
(5222,'Child of servant'),
(5223,'Other relative of servant'),
(5300,'Roomer/boarder/lodger/foster child'),
(5310,'Boarder'),
(5311,'Boarder or guest'),
(5320,'Lodger'),
(5330,'Foster child'),
(5340,'Tutored/foster child'),
(5350,'Tutored child'),
(5400,'Employee, boarder or guest'),
(5500,'Other specified non-relative'),
(5510,'Agregado'),
(5520,'Temporary resident, guest'),
(5600,'Group quarters'),
(5610,'Group quarters, non-inmates'),
(5620,'Institutional inmates'),
(5900,'Non-relative, n.e.c.'),
(6000,'Other relative or non-relative'),
(9999,'Unknown');


CREATE TABLE age (age integer, value varchar);

INSERT INTO age VALUES
(000,'Less than 1 year'),
(001,'1 year'),
(002,'2 years'),
(003,'3'),
(004,'4'),
(005,'5'),
(006,'6'),
(007,'7'),
(008,'8'),
(009,'9'),
(010,'10'),
(011,'11'),
(012,'12'),
(013,'13'),
(014,'14'),
(015,'15'),
(016,'16'),
(017,'17'),
(018,'18'),
(019,'19'),
(020,'20'),
(021,'21'),
(022,'22'),
(023,'23'),
(024,'24'),
(025,'25'),
(026,'26'),
(027,'27'),
(028,'28'),
(029,'29'),
(030,'30'),
(031,'31'),
(032,'32'),
(033,'33'),
(034,'34'),
(035,'35'),
(036,'36'),
(037,'37'),
(038,'38'),
(039,'39'),
(040,'40'),
(041,'41'),
(042,'42'),
(043,'43'),
(044,'44'),
(045,'45'),
(046,'46'),
(047,'47'),
(048,'48'),
(049,'49'),
(050,'50'),
(051,'51'),
(052,'52'),
(053,'53'),
(054,'54'),
(055,'55'),
(056,'56'),
(057,'57'),
(058,'58'),
(059,'59'),
(060,'60'),
(061,'61'),
(062,'62'),
(063,'63'),
(064,'64'),
(065,'65'),
(066,'66'),
(067,'67'),
(068,'68'),
(069,'69'),
(070,'70'),
(071,'71'),
(072,'72'),
(073,'73'),
(074,'74'),
(075,'75'),
(076,'76'),
(077,'77'),
(078,'78'),
(079,'79'),
(080,'80'),
(081,'81'),
(082,'82'),
(083,'83'),
(084,'84'),
(085,'85'),
(086,'86'),
(087,'87'),
(088,'88'),
(089,'89'),
(090,'90'),
(091,'91'),
(092,'92'),
(093,'93'),
(094,'94'),
(095,'95'),
(096,'96'),
(097,'97'),
(098,'98'),
(099,'99'),
(100,'100+'),
(999,'Not reported/missing');


CREATE TABLE age_interval (age_interval integer, value varchar);
INSERT INTO  age_interval VALUES
(01,'0 to 4'),
(02,'5 to 9'),
(03,'10 to 14'),
(04,'15 to 19'),
(05,'15 to 17'),
(06,'18 to 19'),
(07,'18 to 24'),
(08,'20 to 24'),
(09,'25 to 29'),
(10,'30 to 34'),
(11,'35 to 39'),
(12,'40 to 44'),
(13,'45 to 49'),
(14,'50 to 54'),
(15,'55 to 59'),
(16,'60 to 64'),
(17,'65 to 69'),
(18,'70 to 74'),
(19,'75 to 79'),
(20,'80+'),
(98,'Unknown');


CREATE TABLE sex (sex integer, value varchar);
INSERT INTO  sex VALUES
(1,'Male'),
(2,'Female'),
(9,'Unknown');


CREATE TABLE school (school integer, value varchar);
INSERT INTO  school VALUES
(1,'Yes'),
(2,'No, not specified'),
(3,'No, attended in the past'),
(4,'No, never attended'),
(9,'Unknown/missing');


CREATE TABLE literacy (literacy integer, value varchar);
INSERT INTO  literacy VALUES
(0,'NIU (not in universe)'),
(1,'No, illiterate'),
(2,'Yes, literate'),
(9,'Unknown/missing');

##education level attained (simple)
CREATE TABLE edattain (edattain integer, value varchar);
INSERT INTO  edattain VALUES
(1,'Less than primary completed'),
(2,'Primary completed'),
(3,'Secondary completed'),
(4,'University completed'),
(9,'Unknown');


## Educational attainment, international recode [detailed version]
CREATE TABLE edattain_detailed (edattain_detailed integer, value varchar);
INSERT INTO  edattain_detailed VALUES
(100,'Less than primary completed (n.s.)'),
(110,'No schooling'),
(120,'Some primary completed'),
(130,'Primary (4 yrs) completed'),
(211,'Primary (5 yrs) completed'),
(212,'Primary (6 yrs) completed'),
(221,'Lower secondary general completed'),
(222,'Lower secondary technical completed'),
(311,'Secondary, general track completed'),
(312,'Some college completed'),
(320,'Secondary or post-secondary technical completed'),
(321,'Secondary, technical track completed'),
(322,'Post-secondary technical education'),
(400,'University completed'),
(999,'Unknown/missing');

CREATE TABLE years_school (years_school integer, value varchar);
INSERT INTO  years_school VALUES
(00,'None or pre-school'),
(01,'1 year'),
(02,'2 years'),
(03,'3 years'),
(04,'4 years'),
(05,'5 years'),
(06,'6 years'),
(07,'7 years'),
(08,'8 years'),
(09,'9 years'),
(10,'10 years'),
(11,'11 years'),
(12,'12 years'),
(13,'13 years'),
(14,'14 years'),
(15,'15 years'),
(16,'16 years'),
(17,'17 years'),
(18,'18 years or more'),
(90,'Not specified'),
(91,'Some primary'),
(92,'Some technical after primary'),
(93,'Some secondary'),
(94,'Some tertiary'),
(95,'Adult literacy'),
(96,'Special education'),
(98,'Unknown/missing');


CREATE TABLE educ_attained (educ_attained integer, value varchar);
INSERT INTO  educ_attained VALUES
(000,'Less than primary'),
(010,'None, or never attended school'),
(020,'Preschool or kindergarten'),
(021,'Preschool, 1 year'),
(022,'Preschool, 2 years'),
(023,'Preschool, 3 years'),
(029,'Preschool, unspecified years'),
(100,'Primary'),
(101,'Primary, 1 year'),
(102,'Primary, 2 years'),
(103,'Primary, 3 years'),
(104,'Primary, 4 years'),
(105,'Primary, 5 years'),
(106,'Primary, 6 years'),
(109,'Primary, years unspecified'),
(200,'Lower secondary (middle or junior high school)'),
(210,'Lower secondary, tech/commercial'),
(211,'Lower secondary, tech/commercial, 1 year'),
(212,'Lower secondary, tech/commercial, 2 years'),
(213,'Lower secondary, tech/commercial, 3 years'),
(214,'Lower secondary, tech/commercial, 4 years'),
(219,'Lower secondary, tech/commercial, years unspec'),
(220,'Lower secondary, general track'),
(221,'Lower secondary, general track, 1 year'),
(222,'Lower secondary, general track, 2 years'),
(223,'Lower secondary, general track, 3 years'),
(229,'Lower secondary, general track, years unspec.'),
(300,'Secondary (high school)'),
(310,'Secondary tech/commercial'),
(311,'Secondary tech/commercial, 1 year'),
(312,'Secondary tech/commercial, 2 years'),
(313,'Secondary tech/commercial, 3 years'),
(314,'Secondary tech/commercial, 4 years'),
(315,'Secondary tech/commercial, 5 years'),
(319,'Secondary tech/commercial, years unspec'),
(320,'Secondary, general track'),
(321,'Secondary, general track, 1 year'),
(322,'Secondary, general track, 2 years'),
(323,'Secondary, general track, 3 years'),
(329,'Secondary, general track, years unspec'),
(330,'Technological track'),
(331,'Secondary, technological track, year 1'),
(332,'Secondary, technological track, years 2'),
(333,'Secondary, technological track, years 3'),
(339,'Secondary, technological track, year unspecified'),
(400,'Normal school (teacher-training)'),
(401,'Normal, 1 year'),
(402,'Normal, 2 years'),
(403,'Normal, 3 years'),
(404,'Normal, 4 years'),
(409,'Normal, years unspec'),
(500,'Post-secondary technical'),
(501,'Post-secondary technical, 1 year'),
(502,'Post-secondary technical, 2 years'),
(503,'Post-secondary technical, 3 years'),
(504,'Post-secondary technical, 4 years'),
(505,'Post-secondary technical, 5 years'),
(509,'Post-secondary technical, years unspec'),
(600,'University'),
(610,'University undergraduate'),
(611,'University undergraduate, 1 year'),
(612,'University undergraduate, 2 years'),
(613,'University undergraduate, 3 years'),
(614,'University undergraduate, 4 years'),
(615,'University undergraduate, 5 years'),
(616,'University undergraduate, 6 years'),
(617,'University undergraduate, 7 years'),
(618,'University undergraduate, 8+ years'),
(619,'University undergraduate, years unspec'),
(620,'University graduate'),
(621,'University graduate, 1 year'),
(622,'University graduate, 2 years'),
(623,'University graduate, 3 years'),
(624,'University graduate, 4 years'),
(625,'University graduate, 5 years'),
(626,'University graduate, 6 years'),
(627,'University graduate, 7 years'),
(628,'University graduate, 8+ years'),
(629,'University graduate, years unspec'),
(630,'Masters degree (2005-2010)'),
(631,'Masters, 1 year'),
(632,'Masters, 2 years'),
(633,'Masters, 3 years'),
(639,'Masters, year unspecified'),
(640,'Doctoral degree (2005-2010)'),
(641,'Doctoral, 1 year'),
(642,'Doctoral, 2 years'),
(643,'Doctoral, 3 years'),
(644,'Doctoral, 4 years'),
(645,'Doctoral, 5 years'),
(646,'Doctoral, 6 years'),
(649,'Doctoral, years unspecified'),
(650,'Specialty degree'),
(651,'Specialty, 1 year'),
(652,'Specialty, 2 years'),
(659,'Specialty, years unspecified'),
(700,'Unspecified post-secondary'),
(701,'Unspecified post-secondary, 1 year'),
(702,'Unspecified post-secondary, 2 years'),
(703,'Unspecified post-secondary, 3 years'),
(704,'Unspecified post-secondary, 4 years'),
(705,'Unspecified post-secondary, 5 years'),
(706,'Unspecified post-secondary, 6 years'),
(707,'Unspecified post-secondary, 7 years'),
(708,'Unspecified post-secondary, 8+ years'),
(800,'Unknown/missing');

CREATE TABLE state_5yearsago (state_5yearsago integer, value varchar);
INSERT INTO  state_5yearsago VALUES
(01,'Aguascalientes'),
(02,'Baja California'),
(03,'Baja California Sur'),
(04,'Campeche'),
(05,'Coahuila'),
(06,'Colima'),
(07,'Chiapas'),
(08,'Chihuahua'),
(09,'Distrito Federal'),
(10,'Durango'),
(11,'Guanajuato'),
(12,'Guerrero'),
(13,'Hidalgo'),
(14,'Jalisco'),
(15,'México'),
(16,'Michoacán'),
(17,'Morelos'),
(18,'Nayarit'),
(19,'Nuevo León'),
(20,'Oaxaca'),
(21,'Puebla'),
(22,'Querétaro'),
(23,'Quintana Roo'),
(24,'San Luis Potosí'),
(25,'Sinaloa'),
(26,'Sonora'),
(27,'Tabasco'),
(28,'Tamaulipas'),
(29,'Tlaxcala'),
(30,'Veracruz'),
(31,'Yucatán'),
(32,'Zacatecas'),
(98,'Abroad'),
(99,'Unknown');



# clés étrangères


ALTER TABLE dataset_2015 
ADD CONSTRAINT geo1_fkey FOREIGN KEY (GEO1_MX) REFERENCES states2015 (GEO1_MX);


ALTER TABLE  water ADD CONSTRAINT  unique_water UNIQUE (water) ; 
ALTER TABLE dataset_2015 
ADD CONSTRAINT water_fkey FOREIGN KEY (WATSUP) REFERENCES water (water);


ALTER TABLE sewage ADD CONSTRAINT unique_sewage	 UNIQUE (sewage) ; 
ALTER TABLE dataset_2015 
ADD CONSTRAINT sewage_fkey FOREIGN KEY (sewage) REFERENCES sewage (sewage);



ALTER TABLE rooms ADD CONSTRAINT unique_rooms	 UNIQUE (rooms) ; 
ALTER TABLE dataset_2015 
ADD CONSTRAINT rooms_fkey FOREIGN KEY (rooms) REFERENCES rooms (rooms);


ALTER TABLE bedrooms ADD CONSTRAINT unique_bedrooms	 UNIQUE (bedrooms) ; 
ALTER TABLE dataset_2015 
ADD CONSTRAINT bedrooms_fkey FOREIGN KEY (bedrooms) REFERENCES bedrooms (bedrooms);


ALTER TABLE toilet ADD CONSTRAINT unique_toilet	 UNIQUE (toilet) ; 
ALTER TABLE dataset_2015 
ADD CONSTRAINT toilet_fkey FOREIGN KEY (toilet) REFERENCES toilet (toilet);

ALTER TABLE floor ADD CONSTRAINT unique_floor	 UNIQUE (floor) ; 
ALTER TABLE dataset_2015 
ADD CONSTRAINT floor_fkey FOREIGN KEY (floor) REFERENCES floor (floor);


ALTER TABLE relate ADD CONSTRAINT relate_unique UNIQUE (relate) ; 
ALTER TABLE dataset_2015 
ADD CONSTRAINT relate_fkey FOREIGN KEY (relate) REFERENCES relate (relate);


ALTER TABLE relate_detailed ADD CONSTRAINT relate_detailed_unique UNIQUE (relate_detailed) ; 
ALTER TABLE dataset_2015 
ADD CONSTRAINT related_fkey FOREIGN KEY (related) REFERENCES relate_detailed (relate_detailed);




ALTER TABLE age ADD CONSTRAINT unique_age	 UNIQUE (age) ; 
ALTER TABLE dataset_2015 
ADD CONSTRAINT sage_fkey FOREIGN KEY (age) REFERENCES age (age);

ALTER TABLE age_interval ADD CONSTRAINT unique_age_inter UNIQUE (age_interval) ; 
ALTER TABLE dataset_2015 
ADD CONSTRAINT age_inter_fkey FOREIGN KEY (age2) REFERENCES age_interval (age_interval);

ALTER TABLE sex ADD CONSTRAINT sex_unique UNIQUE (sex) ; 
ALTER TABLE dataset_2015 
ADD CONSTRAINT sex_fkey FOREIGN KEY (sex) REFERENCES sex (sex);

ALTER TABLE school ADD CONSTRAINT school_unique UNIQUE (school) ; 
ALTER TABLE dataset_2015 
ADD CONSTRAINT school_fkey FOREIGN KEY (school) REFERENCES school (school);




ALTER TABLE literacy ADD CONSTRAINT unique_literacy	 UNIQUE (literacy) ; 
ALTER TABLE dataset_2015 
ADD CONSTRAINT lit_fkey FOREIGN KEY (lit) REFERENCES literacy (literacy);


ALTER TABLE  edattain ADD CONSTRAINT  unique_edattain UNIQUE (edattain) ; 
ALTER TABLE dataset_2015 
ADD CONSTRAINT edattain_fkey FOREIGN KEY (edattain) REFERENCES edattain (edattain);


ALTER TABLE  edattain_detailed ADD CONSTRAINT  unique_edattain_detailed UNIQUE (edattain_detailed) ; 
ALTER TABLE dataset_2015 
ADD CONSTRAINT edattain_detailed_fkey FOREIGN KEY (edattaind) REFERENCES edattain_detailed (edattain_detailed);

ALTER TABLE  years_school ADD CONSTRAINT  unique_years_school	 UNIQUE (years_school) ; 
ALTER TABLE dataset_2015 
ADD CONSTRAINT yrschool_fkey FOREIGN KEY (YRSCHOOL) REFERENCES years_school (years_school);



ALTER TABLE  educ_attained ADD CONSTRAINT  unique_educ_attained UNIQUE (educ_attained) ; 
ALTER TABLE dataset_2015 
ADD CONSTRAINT educ_attained_fkey FOREIGN KEY (EDUCMX) REFERENCES educ_attained (educ_attained);


ALTER TABLE state_5yearsago ADD CONSTRAINT state_5yearsago_unique UNIQUE (state_5yearsago) ; 
ALTER TABLE dataset_2015 
ADD CONSTRAINT migmx2_fkey FOREIGN KEY (MIGMX2) REFERENCES state_5yearsago (state_5yearsago);



GRANT SELECT ON ALL TABLES IN SCHEMA public TO m2igast;