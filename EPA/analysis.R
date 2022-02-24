library(tidyr)
library(stringr)

# All computations for our analysis on Traffic Injury related datasets

gbd_data <- read.csv("Data/GBD_data.csv")

# Motor_Vehicle_Occupant_Death_Rate__by_Age_and_Gender__2012___2014__All_States
motor_vehicle_death <- read.csv("Data/motor_vehicle_death.csv") %>% na_if("") %>%
  setNames(tolower(gsub("\\.+","_",names(.)))) %>% drop_na(state) %>%
  pivot_longer(cols = all_ages_2012:female_2014,
               names_to = c("type","year"),
               names_pattern="(.+)_(2014|2012)")

motor_vehicle_death_gender <- motor_vehicle_death %>% 
  filter(type == "male" | type =="female")
motor_vehicle_death_age <- motor_vehicle_death %>% 
  filter(str_detect(type, "age_")) %>% 
  mutate(type = gsub("age_", "", type)) %>% 
  separate(type, c("age_min", "age_max"), sep="_")
motor_vehicle_death_age_all <- motor_vehicle_death %>% 
  filter(type == "all_ages") %>% select(-type)



# Impaired_Driving_Death_Rate__by_Age_and_Gender__2012___2014__All_States
impaired_driving_death <- read.csv("Data/impaired_driving_death.csv") %>% 
  setNames(tolower(gsub("\\.+","_",names(.)))) %>% 
  pivot_longer(cols = all_ages_2012:female_2014,
               names_to = c("type","year"),
               names_pattern="(.+)_(2014|2012)")

impaired_driving_death_gender <- impaired_driving_death %>% 
  filter(type == "male" | type =="female")
impaired_driving_death_age <- impaired_driving_death %>% 
  filter(str_detect(type, "ages_")) %>% 
  mutate(type = gsub("ages_", "", type)) %>% 
  separate(type, c("age_min", "age_max"), sep="_")
impaired_driving_death_age_all <- impaired_driving_death %>% 
  filter(type == "all_ages") %>% select(-type)


