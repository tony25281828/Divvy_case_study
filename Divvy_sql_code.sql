# Calculate the number of trip based on distance for casual and member
SELECT 
    t1.user_type,
    t1.trip_between_0_2000,
    t2.trip_between_2000_4000,
    t3.trip_between_4000_6000,
    t4.trip_between_6000_8000,
    t5.trip_more_8000,
    (t1.trip_between_0_2000 + t2.trip_between_2000_4000 + 
    t3.trip_between_4000_6000 + t4.trip_between_6000_8000 + 
    t5.trip_more_8000) AS total
FROM

(
# First result is trips under 2km
(SELECT
    user_type,
    COUNT(*) AS trip_between_0_2000
FROM `coursera-case-study20211109.Case_study1.bike_data`
WHERE 
    distance_km <= 2
GROUP BY 
    user_type) AS t1

INNER JOIN
# Second result is trips between 2km and 4km 
(SELECT
    user_type,
    COUNT(*) AS trip_between_2000_4000
FROM `coursera-case-study20211109.Case_study1.bike_data`
WHERE 
    distance_km > 2 AND distance_km <=4
GROUP BY 
    user_type) AS t2
ON t1.user_type = t2.user_type

INNER JOIN 
# Third result is trips between 4km and 6km
(SELECT
    user_type,
    COUNT(*) AS trip_between_4000_6000
FROM `coursera-case-study20211109.Case_study1.bike_data`
WHERE 
    distance_km > 4 AND distance_km <=6
GROUP BY 
    user_type) AS t3
ON t1.user_type = t3.user_type

INNER JOIN 
# Forth result is trips between 6km and 8km
(SELECT
    user_type,
    COUNT(*) AS trip_between_6000_8000
FROM `coursera-case-study20211109.Case_study1.bike_data`
WHERE 
    distance_km > 6 AND distance_km <=8
GROUP BY 
    user_type) AS t4
ON t1.user_type = t4.user_type

INNER JOIN 
# Forth result is trips above 8km
(SELECT
    user_type,
    COUNT(*) AS trip_more_8000
FROM `coursera-case-study20211109.Case_study1.bike_data`
WHERE 
    distance_km > 8
GROUP BY 
    user_type) AS t5
ON t1.user_type = t5.user_type
)

----------------------------------------------------------------
# Calculate the number of different period of duration group by user type and year
SELECT 
    t1.user_type,
    t1.trip_less_10,
    t2.trip_between_10_20,
    t3.trip_between_20_30,
    t4.trip_between_30_40,
    t5.trip_more_40,
    t1.trip_less_10 + t2.trip_between_10_20 + t3.trip_between_20_30 + t4.trip_between_30_40 + t5.trip_more_40 AS total
FROM

(
# First result is trips under 10 minuts
(SELECT
    user_type,
    COUNT(*) AS trip_less_10
FROM `coursera-case-study20211109.Case_study1.bike_data`
WHERE 
    trips_duration_minute <= 10
GROUP BY 
    user_type) AS t1

INNER JOIN
# Second result is trips between 10 and 20 minutes
(SELECT
    user_type,
    COUNT(*) AS trip_between_10_20
FROM `coursera-case-study20211109.Case_study1.bike_data`
WHERE 
    trips_duration_minute > 10 AND trips_duration_minute <=20
GROUP BY 
    user_type) AS t2
ON t1.user_type = t2.user_type

INNER JOIN 
# Third result is trips between 20 and 30 minutes
(SELECT
    user_type,
    COUNT(*) AS trip_between_20_30
FROM `coursera-case-study20211109.Case_study1.bike_data`
WHERE 
    trips_duration_minute > 20 AND trips_duration_minute <=30
GROUP BY 
    user_type) AS t3
ON t1.user_type = t3.user_type

INNER JOIN 
# Forth result is trips above 40 minute
(SELECT
    user_type,
    COUNT(*) AS trip_between_30_40
FROM `coursera-case-study20211109.Case_study1.bike_data`
WHERE 
    trips_duration_minute > 30 AND trips_duration_minute <=40
GROUP BY 
    user_type) AS t4
ON t1.user_type = t4.user_type

INNER JOIN 
# Fifth result is trips above 40 minute
(SELECT
    user_type,
    COUNT(*) AS trip_more_40
FROM `coursera-case-study20211109.Case_study1.bike_data`
WHERE 
    trips_duration_minute > 40
GROUP BY 
    user_type) AS t5
ON t1.user_type = t5.user_type

)

----------------------------------------------------------------
# Calculate mean distance and group by user type and year

SELECT 
    user_type,
    year,
    ROUND(AVG(distance_km), 2) AS mean_distance,

FROM `coursera-case-study20211109.Case_study1.bike_data`
GROUP BY 
    user_type, year

----------------------------------------------------------------
# Calcualte mean duration group by user type and year
SELECT 
    user_type,
    year,
    AVG(trips_duration_minute) AS mean_duration
FROM `coursera-case-study20211109.Case_study1.bike_data`
GROUP BY 
    user_type,
    year

----------------------------------------------------------------
# Calculate mean distance and mean duration and group by user type
SELECT
    member_casual,
    ROUND(AVG(trips_duration_minute), 2) AS mean_duration,
    ROUND(AVG(distance_km), 2) AS mean_distance
FROM `coursera-case-study20211109.Case_study1.new_divvy_trips_data`
GROUP BY 
    member_casual

----------------------------------------------------------------

# Show the relationship between ridable type and member type
SELECT
    rideable_type,
    member_casual,
    COUNT(*) AS number
FROM `coursera-case-study20211109.Case_study1.new_divvy_trips_data`
GROUP BY 
    rideable_type, member_casual
ORDER BY
    number DESC

----------------------------------------------------------------
# Calculate the number of rides group by user type and year
SELECT 
    user_type,
    year,
    COUNT(*),

FROM `coursera-case-study20211109.Case_study1.bike_data`
GROUP BY 
    user_type, year


----------------------------------------------------------------
# Calculate number of rides and group by weekday and usertype
SELECT
    user_type,
    day_of_week,
    COUNT(*) AS number_of_rides
FROM `coursera-case-study20211109.Case_study1.bike_data`
GROUP BY 
    day_of_week,
    user_type
ORDER BY 
    day_of_week






