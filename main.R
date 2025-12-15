library(tidyverse)
library(nflfastR)
library(data.table)

# Load all play-by-play csv files into one data.table
file_paths <- list.files(path = "data", pattern = "pbp_.*\\.csv", full.names = TRUE)
pbp_data <- rbindlist(lapply(file_paths, fread), fill = TRUE)

# Quick data inspection
colnames(pbp_data)
head(pbp_data)

# Filter 4th down plays
fourth_down_plays <- pbp_data %>% filter(down == 4)

# Add go_for_it indicator
fourth_down_plays <- fourth_down_plays %>%
  mutate(go_for_it = if_else(play_type %in% c("run", "pass", "qb_kneel", "no_play"), TRUE, FALSE))

# Select relevant columns
relevant_cols_4th_down <- c(
  "game_id", "play_id", "season_type", "week", "home_team", "away_team",
  "posteam", "defteam", "down", "yardline_100", "ydstogo", "goal_to_go",
  "score_differential", "quarter_seconds_remaining", "game_half",
  "play_type", "yards_gained", "shotgun", "no_huddle", "pass_length",
  "pass_location", "air_yards", "yards_after_catch", "field_goal_result",
  "kick_distance", "extra_point_result", "two_point_conv_result",
  "touchdown", "interception", "fumble", "epa", "wp", "wpa", 
  "passer_player_name", "receiver_player_name", "rusher_player_name"
)

fourth_down_subset <- fourth_down_plays %>%
  select(all_of(relevant_cols_4th_down))

# Filter only run or pass plays and create success variable
fourth_down_subset <- fourth_down_subset %>%
  filter(play_type %in% c("run", "pass")) %>%
  mutate(success = yards_gained >= ydstogo)

# Fit logistic regression model
model <- glm(success ~ ydstogo + yardline_100 + score_differential + quarter_seconds_remaining,
             data = fourth_down_subset, family = "binomial")

# Output model summary
summary(model)

# EPA by ydstogo for run/pass plays
epa_by_ydstogo <- fourth_down_subset %>%
  group_by(ydstogo) %>%
  summarize(avg_epa = mean(epa, na.rm = TRUE), attempts = n()) %>%
  arrange(ydstogo)

print(epa_by_ydstogo)

# Example of likelihood of successful conversion (just shows model again)
conversion_model <- glm(success ~ ydstogo + yardline_100 + score_differential + quarter_seconds_remaining,
                        data = fourth_down_subset, family = "binomial")
summary(conversion_model)
