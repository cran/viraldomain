#' Create a Simple Domain Plot
#'
#' This function generates a domain plot for a simple model based on PCA
#' distances of the provided data.
#'
#' @import applicable
#' @import dplyr
#' @import earth
#' @import ggplot2
#' @import recipes
#' @import vdiffr
#' @importFrom stats as.formula
#' @importFrom stats rexp
#'
#' @param features A list of features according to their modeling roles. It should contain the following elements:
#'   - 'featured_col': Name of the featured column in the training data. When specifying the featured column, use "jitter_*" as a prefix to the featured variable of interest.
#'   - 'features_vl': Names of the columns containing viral load data (numeric values).
#'   - 'features_cd': Names of the columns containing CD4 data (numeric values).
#' @param train_data The training data used to fit the MARS model.
#' @param test_data The testing domain data used to calculate PCA distances.
#' @param treshold_value The threshold for domain applicability scoring.
#' @param impute_hyperparameters A list of parameters for imputation including 'indetect' (undetectable viral load level), 'tasa_exp' (exponential distribution rate of undetectable values), and 'semi' (set a seed for reproducibility).
#'
#' @return A domain plot showing PCA distances.
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
#' simple_domain_plot(features, train_data, test_data, treshold_value, impute_hyperparameters)
simple_domain_plot <- function(features, train_data, test_data, treshold_value, impute_hyperparameters) {
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
        )) |>
          step_normalize(recipes::all_numeric()),
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
      ),
    treshold_value
  ) |>
    applicable::autoplot.apd_pca() + ggplot2::labs(x = "simple domain")
}
