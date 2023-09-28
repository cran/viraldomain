test_that("`nn_domain_score()` works", {
  local_edition(3)
  library(viraldomain)
  library(dplyr)

  # Set the seed for reproducibility
  set.seed(1234)

  # Create a tibble with the training data
  data(viral)

  # Number of imputations needed
  num_imputations <- sum(viral$vl_2022 <= 40)  # Count values below 40 cpm

  # Impute unique values
  imputed_values <- sort(unique(rexp(num_imputations, rate = 1/13)))

  # Create a new tibble with mutated/imputed viral load
  imputed_viral <- viral |>
    mutate(imputed_vl_2022 = ifelse(vl_2022 <= 40, imputed_values, vl_2022),
           log10_imputed_vl_2022 = log10(ifelse(vl_2022 <= 40, imputed_values, vl_2022)),
           jittered_log10_imputed_vl_2022 = jitter(log10_imputed_vl_2022))

  # Create a new tibble with mutated/imputed cd4 counts
  imputed_viral <- imputed_viral |>
    mutate(
      jittered_cd_2022 = ifelse(
        duplicated(cd_2022),
        cd_2022 + sample(1:100, length(cd_2022), replace = TRUE),
        cd_2022
      )
    )

  # New data frame with mutated/imputed columns
  imp_viral <- imputed_viral |>
    select(jittered_cd_2022, jittered_log10_imputed_vl_2022) |>
    scale() |>
    as.data.frame()

  # Set the seed for reproducibility
  set.seed(1234)

  # Create a tibble with the testing data
  data(sero)

  # Number of imputations needed
  num_imputations <- sum(sero$vl_2022 <= 40)  # Count values below 40 cpm

  # Impute unique values
  imputed_values <- sort(unique(rexp(num_imputations, rate = 1/13)))

  # Create a new tibble with mutated/imputed viral load
  imputed_sero <- sero |>
    mutate(imputed_vl_2022 = ifelse(vl_2022 <= 40, imputed_values, vl_2022),
           log10_imputed_vl_2022 = log10(ifelse(vl_2022 <= 40, imputed_values, vl_2022)),
           jittered_log10_imputed_vl_2022 = jitter(log10_imputed_vl_2022))

  # Create a new tibble with mutated/imputed cd
  imputed_sero <- imputed_sero |>
    mutate(
      jittered_cd_2022 = ifelse(
        duplicated(cd_2022),
        cd_2022 + sample(1:100, length(cd_2022), replace = TRUE),
        cd_2022
      )
    )

  # New data frame with mutated/imputed columns
  imp_sero <- imputed_sero |>
    select(jittered_cd_2022, jittered_log10_imputed_vl_2022) |>
    scale() |>
    as.data.frame()

  # Specify your function parameters
  featured_col <- "jittered_cd_2022"
  train_data <- imp_viral
  nn_hyperparameters <- list(hidden_units = 1, penalty = 0.3746312,  epochs =  480)
  test_data <- imp_sero
  threshold_value <- 0.99
  expect_snapshot(print(nn_domain_score(featured_col, train_data, nn_hyperparameters, test_data, threshold_value)))
})
