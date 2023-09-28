#' Calculate the Neural Network model domain applicability score
#'
#' This function fits a Neural Network model to the provided data and computes a
#' domain applicability score based on PCA distances.
#'
#' @import applicable
#' @import dplyr
#' @import nnet
#' @import parsnip
#' @import recipes
#' @import workflows
#' @importFrom stats as.formula
#' @importFrom stats predict
#'
#' @param featured_col The name of the featured column in the training data.
#' @param train_data The training data used to fit the Neural Network model.
#' @param nn_hyperparameters A list of Neural Network hyperparameters, including hidden_units, penalty, and epochs.
#' @param test_data The testing domain data used to calculate the domain applicability score.
#' @param threshold_value The threshold value for domain applicability scoring.
#'
#' @return A tibble with the domain applicability scores.
#' @export
#'
#' @examples
#' library(viraldomain)
#' library(dplyr)
#'
#' # Set the seed for reproducibility
#' set.seed(1234)
#'
#' # Create a tibble with the training data
#' data(viral)
#'
#' # Number of imputations needed
#' num_imputations <- sum(viral$vl_2022 <= 40)  # Count values below 40 cpm
#'
#' # Impute unique values
#' imputed_values <- unique(rexp(num_imputations, rate = 1/13))
#'
#' # Create a new tibble with mutated/imputed viral load
#' imputed_viral <- viral |>
#'   mutate(imputed_vl_2022 = ifelse(vl_2022 <= 40, imputed_values, vl_2022),
#'          log10_imputed_vl_2022 = log10(ifelse(vl_2022 <= 40, imputed_values, vl_2022)),
#'          jittered_log10_imputed_vl_2022 = jitter(log10_imputed_vl_2022))
#'
#' # Create a new tibble with mutated/imputed cd4 counts
#' imputed_viral <- imputed_viral |>
#'   mutate(
#'     jittered_cd_2022 = ifelse(
#'     duplicated(cd_2022),
#'     cd_2022 + sample(1:100, length(cd_2022), replace = TRUE),
#'     cd_2022
#'     )
#'   )
#'
#' # New data frame with mutated/imputed columns
#' imp_viral <- imputed_viral |>
#' select(jittered_cd_2022, jittered_log10_imputed_vl_2022) |>
#' scale() |>
#' as.data.frame()
#'
#' # Set the seed for reproducibility
#' set.seed(1234)
#'
#' # Create a tibble with the testing data
#' data(sero)
#'
#' # Number of imputations needed
#' num_imputations <- sum(sero$vl_2022 <= 40)  # Count values below 40 cpm
#'
#' # Impute unique values
#' imputed_values <- unique(rexp(num_imputations, rate = 1/13))
#'
#' # Create a new tibble with mutated/imputed viral load
#' imputed_sero <- sero |>
#'   mutate(imputed_vl_2022 = ifelse(vl_2022 <= 40, imputed_values, vl_2022),
#'          log10_imputed_vl_2022 = log10(ifelse(vl_2022 <= 40, imputed_values, vl_2022)),
#'          jittered_log10_imputed_vl_2022 = jitter(log10_imputed_vl_2022))
#'
#' # Create a new tibble with mutated/imputed cd
#' imputed_sero <- imputed_sero |>
#'   mutate(
#'     jittered_cd_2022 = ifelse(
#'     duplicated(cd_2022),
#'     cd_2022 + sample(1:100, length(cd_2022), replace = TRUE),
#'     cd_2022
#'     )
#'   )
#'
#' # New data frame with mutated/imputed columns
#' imp_sero <- imputed_sero |>
#' select(jittered_cd_2022, jittered_log10_imputed_vl_2022) |>
#' scale() |>
#' as.data.frame()
#'
#' # Specify your function parameters
#' featured_col <- "jittered_cd_2022"
#' train_data <- imp_viral
#' nn_hyperparameters <- list(hidden_units = 1, penalty = 0.3746312,  epochs =  480)
#' test_data <- imp_sero
#' threshold_value <- 0.99
#'
#' # Call the function
#' nn_domain_score(featured_col, train_data, nn_hyperparameters, test_data, threshold_value)
nn_domain_score <- function(featured_col, train_data, nn_hyperparameters, test_data, threshold_value) {
  workflows::workflow() |>
    workflows::add_recipe(recipes::recipe(stats::as.formula(paste(featured_col, "~ .")), data = train_data)) |>
    workflows::add_model(parsnip::mlp(hidden_units = nn_hyperparameters$hidden_units,
                                      penalty = nn_hyperparameters$penalty,
                                      epochs = nn_hyperparameters$epochs) |>
                           parsnip::set_engine("nnet") |>
                           parsnip::set_mode("regression")) |>
    parsnip::fit(data = train_data) |>
    stats::predict(test_data) |>
    dplyr::bind_cols(
      applicable::apd_pca(~ ., data = train_data, threshold = threshold_value) |>
        applicable::score(test_data) |> dplyr::select(starts_with("distance"))
    )
}
