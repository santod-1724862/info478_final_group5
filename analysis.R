# All computations for our analysis on Traffic Injury related datasets
library(tidyr)
library(stringr)
library(ggplot2)
library(scales)

# DATA CLEANING

# Motor_Vehicle_Occupant_Death_Rate__by_Age_and_Gender__2012___2014__All_States
motor_vehicle_death <-
  read.csv("Data/motor_vehicle_death.csv") %>% na_if("") %>%
  setNames(tolower(gsub("\\.+", "_", names(.)))) %>% drop_na(state) %>%
  pivot_longer(
    cols = all_ages_2012:female_2014,
    names_to = c("type", "year"),
    names_pattern = "(.+)_(2014|2012)"
  ) %>% mutate(state = tolower(state))

motor_vehicle_death_gender <- motor_vehicle_death %>%
  filter(type == "male" | type == "female")
motor_vehicle_death_age <- motor_vehicle_death %>%
  filter(str_detect(type, "age_")) %>%
  mutate(type = gsub("age_", "", type)) %>%
  separate(type, c("age_min", "age_max"), sep = "_")
motor_vehicle_death_all <- motor_vehicle_death %>%
  filter(type == "all_ages") %>% select(-type)



# Impaired_Driving_Death_Rate__by_Age_and_Gender__2012___2014__All_States
impaired_driving_death <-
  read.csv("Data/impaired_driving_death.csv") %>%
  setNames(tolower(gsub("\\.+", "_", names(.)))) %>%
  pivot_longer(
    cols = all_ages_2012:female_2014,
    names_to = c("type", "year"),
    names_pattern = "(.+)_(2014|2012)"
  ) %>% mutate(state = tolower(state))

impaired_driving_death_gender <- impaired_driving_death %>%
  filter(type == "male" | type == "female")
impaired_driving_death_age <- impaired_driving_death %>%
  filter(str_detect(type, "ages_")) %>%
  mutate(type = gsub("ages_", "", type)) %>%
  separate(type, c("age_min", "age_max"), sep = "_")
impaired_driving_death_all <- impaired_driving_death %>%
  filter(type == "all_ages") %>% select(-type)

# DATA VISUALIZATIONS
states_map_data <- map_data("state") %>% rename(state = region)
death_ratio_map <-
  left_join(states_map_data,
            impaired_driving_death_all %>%
              rename(impaired_death = value),
            by = "state")
death_ratio_map_data <- death_ratio_map %>%
  left_join(motor_vehicle_death_all %>%
              rename(vehicle_death = value) ,  by =
              "state") %>%
  mutate(ratio = impaired_death / vehicle_death)

death_ratio_heatmap <- ggplot(death_ratio_map_data, aes(long, lat, group = group)) +
  geom_polygon(aes(fill = ratio), color = "white") +
  scale_fill_viridis_c(option = "C") + theme_void() + labs(title="Heatmap of Impaired Driving Deaths to Overall Driving Deaths")
