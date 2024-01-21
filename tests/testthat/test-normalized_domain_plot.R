test_that("`normalized_domain_plot()` plots as expected", {
  local_edition(3)
  library(dplyr)
  library(vdiffr)
  data(viral)
  data(sero)
  # Adding "jitter_" prefix to original variable
  features <- list(
    featured_col = "jittered_cd_2022",
    features_vl = "vl_2022",
    features_cd = "cd_2022"
  )
  train_data = viral |>
    dplyr::select("cd_2022", "vl_2022")
  test_data = sero
  treshold_value = 0.99
  impute_hyperparameters = list(indetect = 40, tasa_exp = 1/13, semi = 123)
  vdiffr::expect_doppelganger(
    title = "normalized_domain_plot",
    fig = normalized_domain_plot(features, train_data, test_data, treshold_value, impute_hyperparameters),
  )
})
