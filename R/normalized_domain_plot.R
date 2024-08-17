#' Create a Normalized Domain Plot
#'
#' This function generates a domain plot for a normalized model based on PCA
#' distances of the provided data.
#'
#' @param featured_col The name of the featured column.
#' @param train_data A data frame containing the training data.
#' @param test_data A data frame containing the test data.
#' @param treshold_value The threshold value for the domain plot.
#' 
#' @return A domain plot visualizing the distances of imputed values.
#' @export
#'
#' @examples
#' set.seed(123)
#' library(dplyr)
#' # Specifying featured column
#' featured_col = "cd_2022"
#' train_data = viral |>
#'   dplyr::select("cd_2022", "vl_2022")
#' test_data = sero
#' treshold_value = 0.99
#' # Call the function
normalized_domain_plot <- function(featured_col, train_data, test_data, treshold_value) {
  applicable::apd_pca(
    x = recipes::recipe(
      stats::as.formula(
        paste(featured_col, "~.")
      ),
      data = train_data
    ) |>
      recipes::step_normalize(recipes::all_numeric()),
    data = test_data,
    treshold_value
  ) |>
    applicable::autoplot.apd_pca() + 
    ggplot2::labs(x = "normalized domain")
}