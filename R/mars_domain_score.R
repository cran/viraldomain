#' Calculate the MARS model domain applicability score
#'
#' This function fits a MARS (Multivariate Adaptive Regression Splines) model to
#' the provided data and computes a domain applicability score based on PCA distances.
#'
#' @param featured_col The name of the featured column.
#' @param train_data A data frame containing the training data.
#' @param mars_hyperparameters A list of hyperparameters for the MARS model, including:
#'   - \code{num_terms}: The number of terms to include in the MARS model.
#'   - \code{prod_degree}: The degree of interaction terms to include.
#'   - \code{prune_method}: The method used for pruning the MARS model.
#' @param test_data A data frame containing the test data.
#' @param threshold_value The threshold value for the domain score.
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
#' mars_hyperparameters <- list(num_terms = 3, prod_degree = 1, prune_method = "none")
#' test_data <- imp_sero
#' threshold_value <- 0.99
#'
#' # Call the function
#' mars_domain_score(featured_col, train_data, mars_hyperparameters, test_data, threshold_value)
mars_domain_score <- function(featured_col, train_data, mars_hyperparameters, test_data, threshold_value) {
  workflows::workflow() |>
    workflows::add_recipe(recipes::recipe(stats::as.formula(paste(featured_col, "~ .")), data = train_data)) |>
    workflows::add_model(parsnip::mars(num_terms = mars_hyperparameters$num_terms,
                                       prod_degree = mars_hyperparameters$prod_degree,
                                       prune_method = mars_hyperparameters$prune_method) |>
                           parsnip::set_engine("earth") |>
                           parsnip::set_mode("regression")) |>
    parsnip::fit(data = train_data) |>
    stats::predict(test_data) |>
    dplyr::bind_cols(
      applicable::apd_pca(~ ., data = train_data, threshold = threshold_value) |>
        applicable::score(test_data) |> dplyr::select(starts_with("distance"))
    )
}
