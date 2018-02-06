library(tidyverse)
library(randomForest)

system.time(
  songs <- read_csv("YearPredictionMSD.txt", col_names = FALSE)
)

songs <- songs %>%
  mutate(id = rep(1:ceiling(nrow(.) / 6), rep(6, ceiling(nrow(.) / 6)))[1:nrow(.)])


system.time(
  songs %>%
    group_by(id) %>%
    summarise_all(funs(median)) %>%
    select(-id)
)


system.time(
  songs %>%
    group_by(id) %>%
    summarise_all(funs(sum(. > 0))) %>%
    select(-id)
)


system.time(
  songs <- songs %>%
    group_by(id) %>%
    summarise_all(funs(mean)) %>%
    select(-id)
)

X <- songs %>%
  select(-1)

y <- songs %>%
  pull(1)

system.time(
  fit <- randomForest(X, y, ntree=10)
)

