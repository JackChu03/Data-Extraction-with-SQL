# Data Management
#
# Class 1 Start Script

# Clear out the environment
rm(list = ls())

# Load relevant libraries, installing them if you haven't already done so
if (!require(tidyverse))
{
  install.packages("tidyverse")
} 

library(tidyverse)


# Read the college dataset.  
college <- read_csv("https://s3.amazonaws.com/itao-datasets/college.csv")

# Perform some data conversion. We'll discuss what this means later
college <- college %>%
  mutate(state=as.factor(state),
         region=as.factor(region),
         highest_degree=as.factor(highest_degree),
         control=as.factor(control),
         gender=as.factor(gender),
         loan_default_rate=as.numeric(loan_default_rate))

# Examing colleges by institutional control
filter(college, control == "Private")

private_schools  <- filter(college, control == "Private")
#private_schools  <- filter(college, control == "private")
summary(private_schools)
summary(college)

# Private schools in Indiana
filter(college, control == "Private" &
                state == "IN")

# Private schools in Indiana with more than 5000 undergrads.
filter(college, control == "Private" &
                state == "IN" &
                undergrads > 5000)

# What if we wanted to include Illinois?
filter(college, control == "Private" &
                (state == "IN" | state == "IL") & # Or and parenthesis!
                undergrads > 5000)

# Private schools where the tuition is more than half the annual salary
# of the average faculty member
pe <- filter(college,
       control == "Private" &
         tuition > 6 * faculty_salary_avg)

# Private schools in Indiana or private schools that have an average SAT score over 1500
po15 <- filter(college,
       state == "IN" |
         sat_avg > 1500 &
         control == "Private")

college %>%
  filter(state == "IN")

# Let's look at arrange
college %>%
  filter(
    state == "IN" |
      sat_avg > 1500 &
      control == "Private") %>%
  arrange(name)

# Reverse alpha by name
college %>%
  filter(
    state == "IN" |
      sat_avg > 1500 &
      control == "Private") %>%
  arrange(desc(name))

# A list of private schools with average SAT over 1400
# Show only the school name and SAT scare, listing highest
# score first
# SELECT name, sat_avg
# FROM table
# WHERE sat_avg > 1400
# ORDER BY sat_avg DESC
college %>%
  filter(control == "Private") %>%
  filter(sat_avg > 1400) %>%
  select(name, sat_avg) %>%
  arrange(desc(sat_avg))

# What if we tried writing R with our SQL brains?
college %>%
  select(name, sat_avg) %>%
  filter(control == "Private")# %>% ## EEK! the control column is gone!
  # Order of operations matters!!!
  filter(sat_avg > 1400) %>%
  arrange(desc(sat_avg))

elite_privates <- college %>%
  filter(control == "Private") %>%
  filter(sat_avg > 1400) %>%
  select(name, sat_avg) %>%
  arrange(desc(sat_avg))

glimpse(elite_privates)
summary(elite_privates)

# only name
college %>%
  select(name)

# everything but name
college %>%
  select(-name)

# Add a column to the elite_privates showing tuition as a percent
# of average faculty salary
ep <- college %>%
  filter(control == "Private") %>%
  filter(sat_avg > 1400) %>%
  mutate(tuition_as_percent_salary = tuition/(6*faculty_salary_avg)) %>%
  select(name, sat_avg, tuition_as_percent_salary) %>%
  arrange(desc(sat_avg))

summary(ep)

ep <- ep %>%
  rename(school_name = name)

summary(ep)

# Add in admission rates
college %>%
  filter(control == "Private") %>%
  filter(sat_avg > 1400) %>%
  mutate(tuition_as_percent_salary = tuition/(6*faculty_salary_avg)) %>%
  summarise(min = min(admission_rate),
            max = max(admission_rate),
            mean = mean(admission_rate))# %>%
  # Remember, summarizations create single-row output!!!!!
  #select(name, sat_avg, tuition_as_percent_salary) %>%
  #select(name, sat_avg, tuition_as_percent_salary, min, max, mean) %>%
  #arrange(desc(sat_avg))

# Average admission rate for each degree type
# SELECT degree_type, avg(admission_rate)
# FROM table
# GROUP BY degree_type
admissions_data <- college %>%
  group_by(highest_degree) %>% # have to create those groups first!
  summarise(admin = mean(admission_rate))

# Quick viz
ggplot(data = admissions_data) +
  geom_col(mapping = aes(x=highest_degree, y=admin))

myplot <- admissions_data %>%
  ggplot() +
  geom_col(mapping = aes(x=highest_degree, y=admin))

myplot

admissions_data <- college %>%
  group_by(highest_degree) %>% # have to create those groups first!
  summarise(admin = mean(admission_rate)) %>%
  ggplot() +
  geom_col(mapping = aes(x=highest_degree, y=admin))

groups(college)
gc <- college %>%
  group_by(highest_degree)
groups(gc)
ungrouped <- ungroup(gc)
groups(ungrouped)

# joins in 3 minutes!
band_members
band_instruments

inner_join(band_members, band_instruments)
inner_join(band_members, band_instruments, by = c('name' = 'name'))
band_instruments2
inner_join(band_members, band_instruments2, by = c('name' = 'artist'))

left_join(band_members, band_instruments2, by = c('name' = 'artist'))
right_join(band_members, band_instruments2, by = c('name' = 'artist'))

ad <- admissions_data
ad

# And to get unique values
college %>%
  distinct(control)
