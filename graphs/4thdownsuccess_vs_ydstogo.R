library(ggplot2)
library(dplyr)

# Source main.R so that fourth_down_subset and success exist
source("/Users/misha/Desktop/4th downs/main.R")

# Check that 'success' exists after sourcing main.R
if (!"success" %in% colnames(fourth_down_subset)) {
  stop("ERROR: 'success' variable is missing from fourth_down_subset after sourcing main.R")
}

# Fit the logistic regression model using the dataset with 'success'
model <- glm(success ~ ydstogo + yardline_100 + score_differential + quarter_seconds_remaining,
             family = "binomial",
             data = fourth_down_subset)

# Prepare data for prediction
pred_data <- fourth_down_subset %>%
  summarize(
    yardline_100 = mean(yardline_100, na.rm = TRUE),
    score_differential = mean(score_differential, na.rm = TRUE),
    quarter_seconds_remaining = mean(quarter_seconds_remaining, na.rm = TRUE)
  ) %>%
  slice(rep(1, 20)) %>%
  mutate(ydstogo = seq(min(fourth_down_subset$ydstogo, na.rm = TRUE),
                       max(fourth_down_subset$ydstogo, na.rm = TRUE), length.out = 20))

pred_data$predicted_success_prob <- predict(model, newdata = pred_data, type = "response")

# Plotting
p1 <- ggplot(pred_data, aes(x = ydstogo, y = predicted_success_prob)) +
  geom_line(color = "blue", size = 1.2) +
  labs(
    title = "Predicted Prob of 4th Down Conversion vs Yds to Go",
    x = "Yards to Go",
    y = "Predicted Probability of Success"
  ) +
  theme_minimal(base_size = 15) +  # clean base theme with bigger text
  theme(
    panel.background = element_rect(fill = "white", color = NA),  # white background
    plot.background = element_rect(fill = "white", color = NA),
    panel.grid.major = element_line(color = "grey85"),  # light major grid lines
    panel.grid.minor = element_line(color = "grey90"),  # even lighter minor grid lines
    axis.text = element_text(color = "grey20"),
    axis.title = element_text(color = "grey20", face = "bold"),
    plot.title = element_text(face = "bold", hjust = 0.5)
  )

print(p1)

# Save plot
ggsave("/Users/misha/Desktop/4th downs/graphs/fourth_down_success_vs_ydstogo.png", plot = p1, width = 7, height = 5)
