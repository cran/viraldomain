test_that("`knn_domain_score()` works", {
  local_edition(3)
  set.seed(123)
  library(dplyr)
  featured <- "cd_2022"
  train_data = viral |>
    transmute(cd_2022 = jitter(cd_2022), vl_2022 = jitter(vl_2022))
  test_data = sero |>
    transmute(cd_2022 = jitter(cd_2022), vl_2022 = jitter(vl_2022))
  knn_hyperparameters <- list(neighbors = 5, weight_func = "optimal", dist_power = 0.3304783)
  threshold_value <- 0.99
  expect_snapshot(print(knn_domain_score(featured, train_data, knn_hyperparameters, test_data, threshold_value)))
})
