## ---- open_model ----
m <- readRDS('saved_model.rds')

## ---- plot_model ----
d %>%
  mutate(pred = predict(m, newdata = .)) %>%
  ggplot(aes(x = pre)) +
  geom_point(aes(y = post)) +
  geom_line(aes(y = pred)) + 
  xlim(0, 420) + ylim(0, 500)