## ---- library_call ----
library(tidyverse)

## ---- read_data ----
d <- read_csv(file = 'tidied_periodization.csv')

## ---- fit_model ----
m <- lm(post ~ pre, data = d)

## ---- save_fit ----
saveRDS(m, file = 'saved_model.rds')

## ---- plot_model ----
d %>%
  mutate(pred = predict(m, newdata = .)) %>%
  ggplot(aes(x = pre)) +
  geom_point(aes(y = post)) +
  geom_line(aes(y = pred)) + 
  xlim(0, 420) + ylim(0, 500)
  
  