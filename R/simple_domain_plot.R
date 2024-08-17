#' Create a Simple Domain Plot
#'
#' This function generates a domain plot for a simple model based on PCA
#' distances of the provided data.
#'
#' @param featured_col Name of the featured column in the training data. 
#' @param train_data The training data used to fit the model.
#' @param test_data The testing domain data used to calculate PCA distances.
#' @param treshold_value The threshold for domain applicability scoring.
#'
#' @return A simple damain plot
#' 
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
simple_domain_plot <- function(featured_col, train_data, test_data, treshold_value) {
  applicable::apd_pca(
    x = recipes::recipe(
      stats::as.formula(
        paste(featured_col, "~.")
      ),
      data = train_data
    ),
    data = test_data,
    treshold_value
  ) |>
    applicable::autoplot.apd_pca() + 
    ggplot2::labs(x = "simple domain")
}