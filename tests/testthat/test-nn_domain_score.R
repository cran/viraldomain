test_that("`nn_domain_score()` works", {
  local_edition(3)
  set.seed(123)
  library(dplyr)
  featured_col <- "cd_2022"
  train_data <- viral |>
    dplyr::select(cd_2022, vl_2022)
  test_data <- sero 
  nn_hyperparameters <- list(hidden_units = 1, penalty = 0.3746312,  epochs =  480)
  threshold_value <- 0.99
  expect_snapshot(print(nn_domain_score(featured_col, train_data, nn_hyperparameters, test_data, threshold_value)))
})
