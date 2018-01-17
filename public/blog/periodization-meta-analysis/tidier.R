
## ---- spatial ----
library(tidyverse)
library(magrittr)
d <- readxl::read_excel('Periodization Stuff.xlsx')

for (i in 1:nrow(d)) {
  if (is.na(d[i,1])) {
    d[i, c(1, 2, 3, 4, 5)] = d[i - 1, c(1, 2, 3, 4, 5)]
  }
}

## ---- remove_url ----
d$`Other 1 pre` <- as.numeric(d$`Other 1 pre`)

## ---- declutter ----
# d %<>%
#   select(
#     -`Measurements at 3+ time points?`, -Author, -`Study Title`,
#     -`Participants (training status)`, -Age, -Sex, -`Length (weeks)`,
#     -`Intensity Closest to 1RM test`, -`Volume Equated?`, -Issues)

## ---- gather_variables ----
d %<>%
  gather(type, outcome, `LBM Pre`:`ES 1 vs. 3__4`)

## ---- split_columns ----
d %<>%
  mutate(type = str_to_lower(type)) %>%
  filter(
    (str_detect(type, ' pre') |
    str_detect(type, ' post') |
    str_detect(type, ' sd')) &
    not(str_detect(type, "/"))) %>%
    separate(
      type, c('outcome_type', 'outcome_measurements'), 
      ' (?=(pre$|post$|sd$))')

## ---- remove_na -----
d <- d[complete.cases(d$outcome),]
d$outcome <- as.numeric(d$outcome)

## ---- fix_data -----
d <- d[-c(114, 115, 120, 121, 122, 123, 90, 91, 96, 97, 98, 99, 102, 103, 108, 109, 110, 111),]

## ---- group_by -----
d %<>% 
  mutate_if(is.character, funs(factor(.))) %>%
  group_by(
    outcome_type, outcome_measurements, Number, `Program Label`, `Program Details`) %>%
  spread(outcome_measurements, outcome) %>%
  ungroup()

## ---- save_file ----

