### Google Case Study 1

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# This R script shows charts about the difference between Casual and Member 
# type. 
# 
# * DATA VISUALIZATION 1: Year vs Type
# * DATA VISUALIZATION 2: Numbers of rides based on different duration 
# * DATA VISUALIZATION 3: Weekday vs User Type
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #


#==========================
# STEP 1: SET ENVIRONMENT
#==========================

# Set working directory
setwd(" --- your working directory --- ")

# Load required library
library(tidyverse)
library(readr)
library(ggplot2)
library(dplyr)
library(lubridate)



#===========================================================
# STEP 2: LOAD DATA
# NOTE: ALL DATA IS CLEAN AND ORGANIZED BY USING BIGQUERY
#===========================================================

# Load data from three different year datasets
bike_data_2019 = read.csv('data/divvy_trips_2019.csv') # From Jan to Dec
bike_data_2020 = read.csv('data/divvy_trips_2020.csv') # From Jan to Dec
bike_data_2021 = read.csv('data/divvy_trips_2021.csv') # From Jan to Oct

# View structure of each dataset
str(bike_data_2019)
str(bike_data_2020)
str(bike_data_2021)

# Change some columns datatype to match bike_data_2020 and 2021
bike_data_2019 <- mutate(bike_data_2019, ride_id = as.character(ride_id))

# Combine all datasets
bike_data_all <- bind_rows(bike_data_2019, bike_data_2020, bike_data_2021)
bike_data_all <- mutate(bike_data_all, year = as.character(year))

#write.csv(bike_data_all, '~/Desktop/bike_data.csv', row.names = TRUE)

#=====================================
# STEP 3: SHOW SOME DATA AND SUMMARY
#=====================================

# View data structure
colnames(bike_data_all)
nrow(bike_data_all)
dim(bike_data_all)
head(bike_data_all)
str(bike_data_all)

# View stats about duration
mean(bike_data_all$trips_duration_minute)
max(bike_data_all$trips_duration_minute)
min(bike_data_all$trips_duration_minute)
median(bike_data_all$trips_duration_minute)
summary(bike_data_all$trips_duration_minute)

# View total number of each value in a column
table(bike_data_all$rideable_type)
table(bike_data_all$day_of_week)
table(bike_data_all$user_type)
table(bike_data_all$year)

# Compare user types
# (1) aggregate(x ~ y , FUN = ...), x is the variable of the function and group by y
# 
# RESULT DATA VISUALIZATION 1: Year vs Type
V1_result <- aggregate(bike_data_all$trips_duration_minute ~ bike_data_all$user_type + bike_data_all$year, FUN = length)
# RESULT DATA VISUALIZATION 3: Mean duration vs User Type by year
V3_result <- aggregate(bike_data_all$trips_duration_minute ~ bike_data_all$user_type + bike_data_all$year, FUN = mean)
# DATA VISUALIZATION 4: Weekday vs User Type
V4_result <- aggregate(bike_data_all$trips_duration_minute ~ bike_data_all$user_type + bike_data_all$day_of_week, FUN = length)
# DATA VISUALIZATION 5: Distance vs User Type




#=======================================================================
# STEP 4: EXTRACT DURATION DATA FROM DATASET FOR VISUALIZATION 2 AND 6
#=======================================================================

# Separate casual and member based on duration and distance
# (1) Separate duration in to 5 parts: 0-10, 10-20, 20-30, 30-40 and 40 above for casual type
# (2) Separate duration in to 5 parts: 0-10, 10-20, 20-30, 30-40 and 40 above for member type
# (3) Separate distance in to 5 parts: 0-2, 2-4, 4-6, 6-8 and 8 above for casual type
# (4) Separate distance in to 5 parts: 0-2, 2-4, 4-6, 6-8 and 8 above for member type

# (1)
casual_num_10 <- filter(bike_data_all, user_type=='casual',
                        trips_duration_minute <= 10)
casual_num_20 <- filter(bike_data_all, user_type=='casual',
                        trips_duration_minute <= 20, trips_duration_minute > 10)
casual_num_30 <- filter(bike_data_all, user_type=='casual',
                        trips_duration_minute <= 30, trips_duration_minute > 20)
casual_num_40 <- filter(bike_data_all, user_type=='casual',
                        trips_duration_minute <= 40, trips_duration_minute > 30)
casual_num_50 <- filter(bike_data_all, user_type=='casual',
                        trips_duration_minute > 40)

# (2)
member_num_10 <- filter(bike_data_all, user_type=='member',
                        trips_duration_minute <= 10)
member_num_20 <- filter(bike_data_all, user_type=='member',
                        trips_duration_minute <= 20, trips_duration_minute > 10)
member_num_30 <- filter(bike_data_all, user_type=='member',
                        trips_duration_minute <= 30, trips_duration_minute > 20)
member_num_40 <- filter(bike_data_all, user_type=='member',
                        trips_duration_minute <= 40, trips_duration_minute > 30)
member_num_50 <- filter(bike_data_all, user_type=='member',
                        trips_duration_minute > 40)

# (3)
casual_num_2 <- filter(bike_data_all, user_type=='casual',
                       distance_km <= 2)
casual_num_4 <- filter(bike_data_all, user_type=='casual',
                       distance_km <= 4, distance_km > 2)
casual_num_6 <- filter(bike_data_all, user_type=='casual',
                       distance_km <= 6, distance_km > 4)
casual_num_8 <- filter(bike_data_all, user_type=='casual',
                       distance_km <= 8, distance_km > 6)
casual_num_10 <- filter(bike_data_all, user_type=='casual',
                        distance_km > 8)

# (4)
member_num_2 <- filter(bike_data_all, user_type=='member',
                       distance_km <= 2)
member_num_4 <- filter(bike_data_all, user_type=='member',
                       distance_km <= 4, distance_km > 2)
member_num_6 <- filter(bike_data_all, user_type=='member',
                       distance_km <= 6, distance_km > 4)
member_num_8 <- filter(bike_data_all, user_type=='member',
                       distance_km <= 8, distance_km > 6)
member_num_10 <- filter(bike_data_all, user_type=='member',
                        distance_km > 8)



#==========================================================
# STEP 5: CREATE NEW DATA FRAME FOR DURATION AND DISTANCE
#==========================================================
# Create new dataframe for duration
y_casual_duration = c(nrow(casual_num_10), nrow(casual_num_20), nrow(casual_num_30), 
             nrow(casual_num_40), nrow(casual_num_50))
y_member_duration = c(nrow(member_num_10), nrow(member_num_20), nrow(member_num_30), 
             nrow(member_num_40), nrow(member_num_50))
y_axis_duration = c(y_casual_duration, y_member_duration)
type = c('casual', 'casual', 'casual', 'casual', 'casual',
         'member', 'member', 'member', 'member', 'member')
x_axis_duration = c('0 - 10','10 - 20','20 - 30','30 - 40','40 more', 
                    '0 - 10','10 - 20','20 - 30','30 - 40','40 more')
df_duration <- data.frame(type, x_axis_duration, y_axis_duration)


# Create new dataframe for distance
y_casual_distance = c(nrow(casual_num_2), nrow(casual_num_4), nrow(casual_num_6), 
                      nrow(casual_num_8), nrow(casual_num_10))
y_member_distance = c(nrow(member_num_2), nrow(member_num_4), nrow(member_num_6), 
                      nrow(member_num_8), nrow(member_num_10))
y_axis_distance = c(y_casual_distance, y_member_distance)
type = c('casual', 'casual', 'casual', 'casual', 'casual',
         'member', 'member', 'member', 'member', 'member')
x_axis_distance = c('0 - 2', '2 - 4', '4 - 6', '6 - 8', '8 more',
                    '0 - 2', '2 - 4', '4 - 6', '6 - 8', '8 more')
df_distance <- data.frame(type, x_axis_distance, y_axis_distance)



#=====================================
# STEP 5: CREATE DATA VISUALIZATION
#=====================================

# DATA VISUALIZATION 1: Year vs Type
ggplot(data = bike_data_all) +
  geom_bar(aes(x = year, fill = user_type), position = 'dodge', alpha=0.8, width = 0.7) +
  scale_fill_discrete(name='Type', labels=c('Casual', 'Manual')) +
  labs(x= 'Year', y= 'Number of rides', 
       title = 'Number of Ride vs Year',
       subtitle = 'Compare number of rides on 2019, 2020 and 2021(Jan - Oct) for member type and casual type',
       caption = expression(underline('2021-11-11 by Tony'))) +
  theme(axis.title.x = element_text(color='brown', margin = margin(10,0,0,0)),
        axis.title.y = element_text(color='brown', margin = margin(0,10,0,10)),
        plot.title = element_text(color='brown', size = 22, face = 'bold', margin = margin(10,0,0,0)),
        plot.caption = element_text(color='blue', margin = margin(0,0,10,0)),
        plot.subtitle = element_text(margin = margin(5,0,5,0))) +
  # Disable scientific mode, and not showing exponential
  scale_y_continuous(labels = scales::comma)





# DATA VISUALIZATION 2: Numbers of rides based on different duration
ggplot(data = df_duration) +
  # Put columns into the chart
  geom_col(aes(x=x_axis_duration, y=y_axis_duration, fill=type), position='dodge', alpha=0.8, width = 0.7) + 
  # Add labels and title
  labs(x= 'Duration of trip', y= 'Number of rides', 
       title = 'Duration Of Trip For Member and Casual',
       subtitle = 'Compare number of rides based on duration for member type and casual type 2019 ~ 2021(Oct)',
       caption = expression(underline('2021-11-10 by Tony'))) +
  scale_fill_discrete(name = 'User Type', labels = c('Casual', 'Member')) + 
  # Customize title, labels and caption
  theme(axis.title.x = element_text(color='brown', margin = margin(10,0,0,0)),
        axis.title.y = element_text(color='brown', margin = margin(0,10,0,10)),
        plot.title = element_text(color='brown', size = 22, face = 'bold', margin = margin(10,0,0,0)),
        plot.caption = element_text(color='blue', margin = margin(0,0,10,0)),
        plot.subtitle = element_text(margin = margin(5,0,5,0))) +
  # Disable scientific mode, and not showing exponential
  scale_y_continuous(labels = scales::comma)




# DATA VISUALIZATION 3: Mean duration vs User Type by year
bike_data_all %>% 
  group_by(user_type, year) %>% 
  summarise(mean_duration = mean(trips_duration_minute)) %>% 
  ggplot() + 
  geom_col(aes(x = year, y = mean_duration, fill = user_type), position = 'dodge', alpha = 0.8, width = 0.7) +
  scale_fill_discrete(name = 'Type', labels = c('Casual', 'Member')) + 
  labs(x = 'Year', y = 'Mean Duration',
       title = 'Mean Duration vs Year',
       subtitle = 'Compare mean duration based on each year for member type and casual type',
       caption = expression(underline('2021-11-12 by Tony'))) +
  theme(axis.title.x = element_text(color = 'brown', margin = margin(10, 0, 0, 0)),
        axis.title.y = element_text(color = 'brown', margin = margin(0, 10, 0, 10)),
        plot.title = element_text(color = 'brown', margin = margin(10, 0, 0, 0), size = 22, face = 'bold'),
        plot.caption = element_text(color = 'blue', margin = margin(0, 0, 10, 0)),
        plot.subtitle = element_text(margin = margin(5, 0, 5, 0)))





# DATA VISUALIZATION 4: Weekday vs User Type
ggplot(data = bike_data_all) + 
  geom_bar(aes(x=day_of_week, fill=user_type), alpha=0.8) +
  # Manually change color of fill, legend name and labels
  scale_fill_discrete(name="Type", labels=c('Casual', 'Member')) +
  # Separate Casual and Member and rename labels for each grids
  facet_wrap(~user_type, labeller = labeller(user_type=c('casual'='Casual','member'='Member'))) +
  # Add labels and title
  labs(x= 'Weekday', y= 'Number of rides', 
       title = 'Number of Ride vs Weekday',
       subtitle = 'Compare number of rides based on weekday for member type and casual type 2019 ~ 2021(Oct)',
       caption = expression(underline('2021-11-11 by Tony'))) +
  # Customize title, labels and caption
  theme(axis.title.x = element_text(color='brown', margin = margin(10,0,0,0)),
        axis.title.y = element_text(color='brown', margin = margin(0,10,0,10)),
        plot.title = element_text(color='brown', size = 22, face = 'bold', margin = margin(10,0,0,0)),
        plot.caption = element_text(color='blue', margin = margin(0,0,10,0)),
        plot.subtitle = element_text(margin = margin(5,0,5,0)),
        # Add space between two grids
        panel.spacing = unit(2, 'lines')) + 
  # Label x axis scales
  scale_x_discrete(limit=c('Mon','Tue','Wed','Thur','Fri','Sat','Sun')) +
  # Disable scientific mode, and not showing exponential
  scale_y_continuous(labels = scales::comma)



# DATA VISUALIZATION 5: Mean distance vs User Type by year
bike_data_all %>% 
  group_by(user_type, year) %>% 
  summarise(mean_distance = mean(distance_km)) %>% 
  ggplot() +
  geom_col(aes(x = year, y = mean_distance, fill = user_type), position = 'dodge', alpha = 0.8, width = 0.7) +
  scale_fill_discrete(name = 'Type', labels = c('Casual', 'Member')) + 
  labs(x = 'Year', y = 'Mean Distance',
       title = 'Mean Distance vs Year',
       subtitle = 'Compare mean distance based on each year for member type and casual type',
       caption = expression(underline('2021-11-12 by Tony'))) +
  theme(axis.title.x = element_text(color = 'brown', margin = margin(10, 0, 0, 0)),
        axis.title.y = element_text(color = 'brown', margin = margin(0, 10, 0, 10)),
        plot.title = element_text(color = 'brown', margin = margin(10, 0, 0, 0), size = 22, face = 'bold'),
        plot.caption = element_text(color = 'blue', margin = margin(0, 0, 10, 0)),
        plot.subtitle = element_text(margin = margin(5, 0, 5, 0)))



# DATA VISUALIZATION 6: Numbers of rides based on different distance
ggplot(data = df_distance) +
  # Put columns into the chart
  geom_col(aes(x=x_axis_distance, y=y_axis_distance, fill=type), position='dodge', alpha=0.8, width = 0.7) + 
  # Add labels and title
  labs(x= 'Distance of trip', y= 'Number of rides', 
       title = 'Distance Of Trip For Member and Casual',
       subtitle = 'Compare number of rides based on distance for member type and casual type',
       caption = expression(underline('2021-11-10 by Tony'))) +
  # Customize legend
  scale_fill_discrete(name = 'Type', labels = c('Casual', 'Member')) + 
  # Customize title, labels and caption
  theme(axis.title.x = element_text(color='brown', margin = margin(10,0,0,0)),
        axis.title.y = element_text(color='brown', margin = margin(0,10,0,10)),
        plot.title = element_text(color='brown', size = 22, face = 'bold', margin = margin(10,0,0,0)),
        plot.caption = element_text(color='blue', margin = margin(0,0,10,0)),
        plot.subtitle = element_text(margin = margin(5,0,5,0))) +
  # Disable scientific mode, and not showing exponential
  scale_y_continuous(labels = scales::comma)



# DATA VISULAZATION 7: Numbers of ride less than 30 min vs Type by Year
short_duration_trip <- bike_data_all %>% 
  filter(bike_data_all$trips_duration_minute <= 30)

short_duration_trip %>% 
  ggplot() +
  geom_bar(aes(x = year, fill = user_type), position = 'dodge', alpha = 0.8, width = 0.7) + 
  # Add labels and title
  labs(x= 'Year', y= 'Number of rides', 
       title = 'Short Duration For Member and Casual By Year',
       subtitle = 'Compare number of rides based on short duration (less than 30 min) for member type and casual type',
       caption = expression(underline('2021-11-13 by Tony'))) +
  # Customize legend
  scale_fill_discrete(name = 'Type', labels = c('Casual', 'Member')) + 
  # Customize title, labels and caption
  theme(axis.title.x = element_text(color='brown', margin = margin(10,0,0,0)),
        axis.title.y = element_text(color='brown', margin = margin(0,10,0,10)),
        plot.title = element_text(color='brown', size = 22, face = 'bold', margin = margin(10,0,0,0)),
        plot.caption = element_text(color='blue', margin = margin(0,0,10,0)),
        plot.subtitle = element_text(margin = margin(5,0,5,0))) +
  # Disable scientific mode, and not showing exponential
  scale_y_continuous(labels = scales::comma)



# DATA VISULIZATION 8: Numbers of ride vs Year
bike_data_all %>% 
  ggplot() + 
  geom_bar(aes(x = year, fill = user_type), alpha = 0.8, width = 0.7)+ 
  # Add labels and title
  labs(x= 'Year', y= 'Number of rides', 
       title = 'Number of rides By Year',
       subtitle = 'Compare number of rides on 2019, 2020 and 2021 (Jan to Oct)',
       caption = expression(underline('2021-11-13 by Tony'))) +
  # Customize legend
  scale_fill_discrete(name = 'Type', labels = c('Casual', 'Member')) + 
  # Customize title, labels and caption
  theme(axis.title.x = element_text(color='brown', margin = margin(10,0,0,0)),
        axis.title.y = element_text(color='brown', margin = margin(0,10,0,10)),
        plot.title = element_text(color='brown', size = 22, face = 'bold', margin = margin(10,0,0,0)),
        plot.caption = element_text(color='blue', margin = margin(0,0,10,0)),
        plot.subtitle = element_text(margin = margin(5,0,5,0))) +
  # Disable scientific mode, and not showing exponential
  scale_y_continuous(labels = scales::comma)

  
  

  
  


  



