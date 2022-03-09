# All computations for our analysis on Traffic Injury related datasets
library(tidyr)
library(stringr)
library(ggplot2)
library(scales)
library(tidyverse)


accidents_by_temp <- read_csv('Data/accidents_by_temp_category.csv')

gbd_data <- read_csv('Data/GBD_data.csv')

gbd_age <- read_csv('Data/gbd_age.csv')


# DATA CLEANING

# Motor_Vehicle_Occupant_Death_Rate__by_Age_and_Gender__2012___2014__All_States
# Get motor vehicle data
motor_vehicle_death <-
  read.csv("Data/motor_vehicle_death.csv") %>% na_if("") %>%
  setNames(tolower(gsub("\\.+", "_", names(.)))) %>% drop_na(state) %>%
  pivot_longer(
    cols = all_ages_2012:female_2014,
    names_to = c("type", "year"),
    names_pattern = "(.+)_(2014|2012)"
  )

motor_vehicle_death_gender <- motor_vehicle_death %>%
  filter(type == "male" | type == "female")
motor_vehicle_death_age <- motor_vehicle_death %>%
  filter(str_detect(type, "age_")) %>%
  mutate(type = gsub("age_", "", type)) %>%
  separate(type, c("age_min", "age_max"), sep = "_")
motor_vehicle_death_all <- motor_vehicle_death %>%
  filter(type == "all_ages") %>% select(-type)


# Get impaired driving data
impaired_driving_death <-
  read.csv("Data/impaired_driving_death.csv") %>%
  setNames(tolower(gsub("\\.+", "_", names(.)))) %>%
  pivot_longer(
    cols = all_ages_2012:female_2014,
    names_to = c("type", "year"),
    names_pattern = "(.+)_(2014|2012)"
  )

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


# statistical testing

gbd <- gbd_data %>%
  select(!c(measure_id, metric_id, upper, lower)) %>%
  pivot_wider(names_from = measure_name, values_from = val)

names(gbd)[names(gbd) == 'DALYs (Disability-Adjusted Life Years)'] <- 'DALYs'

gbd <- gbd %>%
  pivot_wider(names_from = metric_name, values_from = c(Deaths, DALYs))

gbd <- gbd %>%
  summarize(Total_Deaths = sum(Deaths_Number),
            Average_Death_Rate = mean(Deaths_Rate),
            Total_DALYs = sum(DALYs_Number),
            Average_DALYs_Rate = mean(DALYs_Rate))


# temperature analysis
temps_ordered <- c('Freezing (Below 32)', 'Cold (between 32 and 49)', 'Mild (between 50 and 69)',
                   'Warm (between 70 and 89)', 'Hot (above 90)')

temps_grouped <- accidents_by_temp %>%
  group_by(temp_cat) %>%
  summarize(Accidents = n())

temps_grouped$temp_cat <- factor(temps_grouped$temp_cat, levels = temps_ordered)


temp_histogram <- accidents_by_temp %>%
  ggplot(aes(x = `Temperature(F)`)) +
  geom_histogram(binwidth = 3) +
  labs(title = "Distribution of Accidents by Temperature", x = "Temperature (°F)")

temp_col_chart <- temps_grouped %>%
  ggplot(aes(x = temp_cat, y = Accidents)) +
  geom_col() + labs(title = "Accidents per Temperature Range", x = 'Temperature Range (°F)', y = 'Total Accidents') +
  theme(axis.text.x = element_text(angle = 45, vjust = 0.5))

# age analysis
age_accidents <- gbd_age %>%
  filter(sex_name == "Both") %>%
  filter(age_name != "All Ages")

age_death_dalys <- age_accidents %>%
  select(!c(measure_id, upper, lower)) %>%
  pivot_wider(names_from = measure_name, values_from = val)

names(age_death_dalys)[names(age_death_dalys) == 'DALYs (Disability-Adjusted Life Years)'] <- 'DALYs'

age_scatter <- age_death_dalys %>%
  ggplot(aes(x = Deaths, y = DALYs, colour = age_name)) + geom_point() +
  labs(title = "Death and DALYs Rate (per 100,000) Caused by Road Traffic Accidents, by State and Age Group",
       x = "Death Rate", y = "DALYs Rate")

# Creating a dataset for finding OR/RR for Humidity and Temp
severity_temp_OR_RR <- accidents_by_temp %>%
  select(Severity, temp_cat, `Temperature(F)`, `Humidity(%)` , Weather_Timestamp, State)

for(i in 1:nrow(severity_temp_OR_RR)) {
  if(severity_temp_OR_RR$Severity[i] == 4) {
    severity_temp_OR_RR$Severity[i] <- 1
  }
  if(severity_temp_OR_RR$Severity[i] == 3) {
    severity_temp_OR_RR$Severity[i] <- 0
  }
}

temp_check <- function(dt, temp, index) {
  if (dt$`Temperature(F)`[index] < temp) {
    dt$large_temp[index] = 0
  } else {
    dt$large_temp[index] = 1
  }
  return(dt)
}

for (i in 1:nrow(severity_temp_OR_RR)) {
  severity_temp_OR_RR <- temp_check(severity_temp_OR_RR, 67.0, i)
}

# Writing code to calculate RR and OR
check_OR <- function(dt, col_name) {
  high_temp_true <- sum(dt$Severity == 1 & dt[col_name] == 1)
  high_temp_false <- sum(dt$Severity == 1 & dt[col_name] == 0)
  low_temp_true <- sum(dt$Severity == 0 & dt[col_name] == 1)
  low_temp_false <- sum(dt$Severity == 0 & dt[col_name] == 0)
  return((high_temp_true / high_temp_false) / (low_temp_true / low_temp_false))
}

check_RR <- function(dt, col_name) {
  high_temp_true <- sum(dt$Severity == 1 & dt[col_name] == 1)
  high_temp_false <- sum(dt$Severity == 1 & dt[col_name] == 0)
  low_temp_true <- sum(dt$Severity == 0 & dt[col_name] == 1)
  low_temp_false <- sum(dt$Severity == 0 & dt[col_name] == 0)
  return((high_temp_true / (high_temp_true + high_temp_false)) / (low_temp_true / (low_temp_true + low_temp_false)))
}
check_OR(severity_temp_OR_RR, "large_temp")
check_RR(severity_temp_OR_RR, "large_temp")


state_agg <- severity_temp_OR_RR %>%
  group_by(State, Severity, large_temp)

# Create new data set of aggregate 
high_temp_true <- sum(severity_temp_OR_RR$Severity == 0 & severity_temp_OR_RR$large_temp == 0
                      & severity_temp_OR_RR$State == "AR")

state_OR_RR <- state_agg %>%
  summarise(count = n())
>>>>>>> 440f6fef97b2e32ac53a74816c684d19a3e0c949
