test_that("`mars_domain_score()` works", {
  local_edition(3)
  set.seed(123)
  library(dplyr)
  featured_col <- "cd_2022"
  train_data = viral |>
    dplyr::select(cd_2022, vl_2022)
  test_data = sero 
  mars_hyperparameters <- list(num_terms = 3, prod_degree = 1, prune_method = "none")
  threshold_value <- 0.99
  expect_snapshot(print(mars_domain_score(featured_col, train_data, mars_hyperparameters, test_data, threshold_value)))
})
