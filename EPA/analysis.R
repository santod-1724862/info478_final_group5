# All computations for our analysis on Traffic Injury related datasets
library(tidyr)
library(stringr)
library(ggplot2)
library(scales)


accidents_by_temp <- read_csv('../Data/accident_data_large.csv')

gbd_data <- read_csv('../Data/GBD_data.csv')

gbd_age <- read_csv('../Data/gbd_age.csv')


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
  group_by(`temp_range(F)`) %>%
  summarize(Accidents = n())

temps_grouped$`temp_range(F)` <- factor(temps_grouped$`temp_range(F)`, levels = temps_ordered)


temp_histogram <- accidents_by_temp %>%
  ggplot(aes(x = `Temperature(F)`)) +
  geom_histogram(binwidth = 3) +
  labs(title = "Distribution of Accidents by Temperature", x = "Temperature (°F)")

temp_col_chart <- temps_grouped %>%
  ggplot(aes(x = `temp_range(F)`, y = Accidents)) +
  geom_col() + labs(title = "Accidents per Temperature Range", x = 'Temperature Range (°F)', y = 'Total Accidents') +
  theme(axis.text.x = element_text(angle = 45, vjust = 0.5))

# age analysis
age_accidents <- gbd_age %>%
  filter(sex_name == "Both") %>%
  filter(age_name != "All Ages") %>%
  filter(metric_name == "Rate")

age_death_dalys <- age_accidents %>%
  select(!c(measure_id, upper, lower)) %>%
  pivot_wider(names_from = measure_name, values_from = val)

names(age_death_dalys)[names(age_death_dalys) == 'DALYs (Disability-Adjusted Life Years)'] <- 'DALYs'

age_scatter <- age_death_dalys %>%
  ggplot(aes(x = Deaths, y = DALYs, colour = age_name)) + geom_point() +
  labs(title = "Death and DALYs Rate (per 100,000) Caused by Road Traffic Accidents, by State and Age Group",
       x = "Death Rate", y = "DALYs Rate")
