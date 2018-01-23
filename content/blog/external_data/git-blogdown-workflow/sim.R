## ---- simulate_function ----
library(tidyverse)
library(magrittr)

monty_hall_sim <- function (door, switch) {
  doors <- c('a', 'b', 'c')
  prize <- sample(doors, size = 1)
  open_door <- sample(setdiff(doors, c(prize, door)), size = 1)
  if (switch) {
    door <- setdiff(doors, c(door, open_door))
  }
  return(door == prize)
}

## ---- run_simulation ----
d <- tibble(
  door = sample(c('a', 'b', 'c'), size = 1000, replace = TRUE),
  switch = sample(c(TRUE, FALSE), size = 1000, replace = TRUE)
)
d %<>%
  mutate(prize = mapply(monty_hall_sim, door, switch))

## ---- plot_results ----
d %>%
  group_by(switch) %>%
  mutate(attempt = row_number()) %>%
  mutate(success_ratio = cumsum(prize)/attempt) %>%
  ungroup() %>%
  ggplot() +
  geom_line(aes(x = attempt, y = success_ratio, color = switch))





