BEGIN;

-- Unicity Constraint
ALTER TABLE states2015
  ADD CONSTRAINT unique_geolevel1
  UNIQUE (GEO1_MX);

ALTER TABLE water
  ADD CONSTRAINT  unique_water
  UNIQUE (water);

ALTER TABLE sewage
  ADD CONSTRAINT unique_sewage
  UNIQUE (sewage);

ALTER TABLE rooms
  ADD CONSTRAINT unique_rooms
  UNIQUE (rooms);

ALTER TABLE bedrooms
  ADD CONSTRAINT unique_bedrooms
  UNIQUE (bedrooms);

ALTER TABLE toilet
  ADD CONSTRAINT unique_toilet
  UNIQUE (toilet);

ALTER TABLE floor
  ADD CONSTRAINT unique_floor
  UNIQUE (floor);

ALTER TABLE relate
  ADD CONSTRAINT relate_unique
  UNIQUE (relate);

ALTER TABLE relate_detailed
  ADD CONSTRAINT relate_detailed_unique
  UNIQUE (relate_detailed);

ALTER TABLE age
  ADD CONSTRAINT unique_age
  UNIQUE (age);

ALTER TABLE age_interval
  ADD CONSTRAINT unique_age_inter
  UNIQUE (age_interval);

ALTER TABLE sex
  ADD CONSTRAINT sex_unique
  UNIQUE (sex);

ALTER TABLE school
ADD CONSTRAINT school_unique
UNIQUE (school);

ALTER TABLE literacy
ADD CONSTRAINT unique_literacy
UNIQUE (literacy);

ALTER TABLE edattain
ADD CONSTRAINT  unique_edattain
UNIQUE (edattain);

ALTER TABLE edattain_detailed
ADD CONSTRAINT  unique_edattain_detailed
UNIQUE (edattain_detailed);

ALTER TABLE years_school
ADD CONSTRAINT  unique_years_school
UNIQUE (years_school);

ALTER TABLE educ_attained
ADD CONSTRAINT  unique_educ_attained
UNIQUE (educ_attained);

ALTER TABLE state_5yearsago
ADD CONSTRAINT state_5yearsago_unique
UNIQUE (state_5yearsago); 



-- Forgein Key

-- ALTER TABLE mexico_lvl2 
--   ADD CONSTRAINT state2015_fkey
--   FOREIGN KEY (parent)
--   REFERENCES states2015 (GEO1_MX);

-- ALTER TABLE dataset_2015
--   ADD CONSTRAINT GEO2_MX_fkey
--   FOREIGN KEY (GEO2_MX) 
--   REFERENCES mexico_lvl2 (geolevel2);

ALTER TABLE dataset_2015 
  ADD CONSTRAINT geo1_fkey
  FOREIGN KEY (GEO1_MX)
  REFERENCES states2015 (GEO1_MX);

ALTER TABLE dataset_2015 
  ADD CONSTRAINT water_fkey
  FOREIGN KEY (WATSUP)
  REFERENCES water (water);

ALTER TABLE dataset_2015 
  ADD CONSTRAINT sewage_fkey
  FOREIGN KEY (sewage)
  REFERENCES sewage (sewage);

ALTER TABLE dataset_2015 
  ADD CONSTRAINT rooms_fkey
  FOREIGN KEY (rooms)
  REFERENCES rooms (rooms);

ALTER TABLE dataset_2015 
  ADD CONSTRAINT bedrooms_fkey
  FOREIGN KEY (bedrooms)
  REFERENCES bedrooms (bedrooms);

ALTER TABLE dataset_2015 
  ADD CONSTRAINT toilet_fkey
  FOREIGN KEY (toilet)
  REFERENCES toilet (toilet);

ALTER TABLE dataset_2015 
  ADD CONSTRAINT floor_fkey
  FOREIGN KEY (floor)
  REFERENCES floor (floor);

ALTER TABLE dataset_2015 
  ADD CONSTRAINT relate_fkey
  FOREIGN KEY (relate)
  REFERENCES relate (relate);

ALTER TABLE dataset_2015 
  ADD CONSTRAINT related_fkey
  FOREIGN KEY (related)
  REFERENCES relate_detailed (relate_detailed);

ALTER TABLE dataset_2015 
  ADD CONSTRAINT sage_fkey
  FOREIGN KEY (age)
  REFERENCES age (age);

ALTER TABLE dataset_2015 
  ADD CONSTRAINT age_inter_fkey
  FOREIGN KEY (age2)
  REFERENCES age_interval (age_interval);

ALTER TABLE dataset_2015 
  ADD CONSTRAINT sex_fkey
  FOREIGN KEY (sex)
  REFERENCES sex (sex);

ALTER TABLE dataset_2015 
  ADD CONSTRAINT school_fkey
  FOREIGN KEY (school)
  REFERENCES school (school);

ALTER TABLE dataset_2015 
  ADD CONSTRAINT lit_fkey
  FOREIGN KEY (lit)
  REFERENCES literacy (literacy);

ALTER TABLE dataset_2015 
  ADD CONSTRAINT edattain_fkey
  FOREIGN KEY (edattain)
  REFERENCES edattain (edattain);

ALTER TABLE dataset_2015 
  ADD CONSTRAINT edattain_detailed_fkey
  FOREIGN KEY (edattaind)
  REFERENCES edattain_detailed (edattain_detailed);

ALTER TABLE dataset_2015 
  ADD CONSTRAINT yrschool_fkey
  FOREIGN KEY (YRSCHOOL)
  REFERENCES years_school (years_school);

ALTER TABLE dataset_2015 
  ADD CONSTRAINT educ_attained_fkey
  FOREIGN KEY (EDUCMX)
  REFERENCES educ_attained (educ_attained);

ALTER TABLE dataset_2015 
  ADD CONSTRAINT migmx2_fkey
  FOREIGN KEY (MIGMX2)
  REFERENCES state_5yearsago (state_5yearsago);

COMMIT;
