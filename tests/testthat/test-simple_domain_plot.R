test_that("`simple_domain_plot()` plots as expected", {
  local_edition(3)
  set.seed(123)
  library(dplyr)
  library(vdiffr)
  featured_col = "cd_2022"
  train_data = viral |>
    dplyr::select("cd_2022", "vl_2022")
  test_data = sero
  treshold_value = 0.99
  vdiffr::expect_doppelganger(
    title = "simple_domain_plot",
    fig = simple_domain_plot(featured_col, train_data, test_data, treshold_value),
  )
})
