#' Create a Normalized Domain Plot
#'
#' This function generates a domain plot for a normalized model based on PCA
#' distances of the provided data.
#'
#' @import nnet
#'
#' @param features A list containing the following elements:
#'   - \code{featured_col}: The name of the featured column.
#'   - \code{features_vl}: A character vector of feature names related to viral load.
#'   - \code{features_cd}: A character vector of feature names related to cluster of differentiation.
#' @param train_data A data frame containing the training data.
#' @param test_data A data frame containing the test data.
#' @param treshold_value The threshold value for the domain plot.
#' @param impute_hyperparameters A list of hyperparameters for imputation, including:
#'   - \code{indetect}: The undetectable viral load level.
#'   - \code{tasa_exp}: The exponential distribution rate of undetectable values.
#'   - \code{semi}: The seed for random number generation (for reproducibility).
#'
#' @return A domain plot visualizing the distances of imputed values.
#' @export
#'
#' @examples
#' data(viral)
#' data(sero)
#'  # Adding "jitter_" prefix to original variable
#' features <- list(
#'   featured_col = "jittered_cd_2022",
#'   features_vl = "vl_2022",
#'   features_cd = "cd_2022"
#'   )
#' train_data = viral |>
#' dplyr::select("cd_2022", "vl_2022")
#' test_data = sero
#' treshold_value = 0.99
#' impute_hyperparameters = list(indetect = 40, tasa_exp = 1/13, semi = 123)
#' normalized_domain_plot(features, train_data, test_data, treshold_value, impute_hyperparameters)
normalized_domain_plot <- function(features, train_data, test_data, treshold_value, impute_hyperparameters) {
  set.seed(impute_hyperparameters$semi)
  applicable::apd_pca(
    x = recipes::recipe(
      stats::as.formula(paste(features$featured_col, "~.")),
      data = train_data |>
        dplyr::transmute(
          dplyr::across(
            dplyr::all_of(features$features_vl),
            ~ {
              imputed_values <- ifelse(. <= impute_hyperparameters$indetect,
                                       train_data |>
                                         dplyr::filter(. <= impute_hyperparameters$indetect) |>
                                         dplyr::count() |>
                                         dplyr::pull(n) |>
                                         stats::rexp(rate = impute_hyperparameters$tasa_exp),
                                       .)
              jittered_values <- jitter(log10(imputed_values))
              pmax(jittered_values, 0.01)  # Ensure values are at least 0.01
            },
            .names = "jittered_log10_imputed_{.col}"),
          dplyr::across(
            dplyr::all_of(features$features_cd),
            ~ jitter(.),
            .names = "jittered_{.col}"
          )
        ) |>
        scale() |>
        dplyr::as_tibble()) |>
      recipes::step_normalize(recipes::all_numeric()),
    data = test_data |>
      dplyr::transmute(
        dplyr::across(
          dplyr::all_of(features$features_vl),
          ~ {
            imputed_values <- ifelse(. <= impute_hyperparameters$indetect,
                                     test_data |>
                                       dplyr::filter(. <= impute_hyperparameters$indetect) |>
                                       dplyr::count() |>
                                       dplyr::pull(n) |>
                                       stats::rexp(rate = impute_hyperparameters$tasa_exp),
                                     .)
            jittered_values <- jitter(log10(imputed_values))
            pmax(jittered_values, 0.01)  # Ensure values are at least 0.01
          },
          .names = "jittered_log10_imputed_{.col}"
        ),
        dplyr::across(
          dplyr::all_of(features$features_cd),
          ~ jitter(.),
          .names = "jittered_{.col}"
        )
      ) |>
      scale() |>
      dplyr::as_tibble(),
    treshold_value
  ) |>
    applicable::autoplot.apd_pca() + ggplot2::labs(x = "normalized domain")
}
