
<!-- README.md is generated from README.Rmd. Please edit that file -->

# viraldomain

<!-- badges: start -->
<!-- badges: end -->

The goal of viraldomain is to provide methods for assessing the
applicability domain of models that predict viral load and CD4 (Cluster
of Differentiation 4) lymphocyte counts. These methods help determine
the extent of extrapolation when making predictions.

## Installation

You can install the development version of viraldomain from GitHub with:

``` r
# install.packages("devtools")
devtools::install_github("juanv66x/viraldomain")
#> data.table (1.16.0 -> 1.16.2) [CRAN]
#> modelenv   (0.1.1  -> 0.2.0 ) [CRAN]
#> ── R CMD build ─────────────────────────────────────────────────────────────────
#>      checking for file ‘/tmp/Rtmp7ZZw7N/remotesa05859be188e/juanv66x-viraldomain-eae2c27/DESCRIPTION’ ...  ✔  checking for file ‘/tmp/Rtmp7ZZw7N/remotesa05859be188e/juanv66x-viraldomain-eae2c27/DESCRIPTION’ (511ms)
#>   ─  preparing ‘viraldomain’:
#>      checking DESCRIPTION meta-information ...  ✔  checking DESCRIPTION meta-information
#>   ─  checking for LF line-endings in source and make files and shell scripts (598ms)
#>   ─  checking for empty or unneeded directories
#> ─  building ‘viraldomain_0.0.6.tar.gz’
#>      
#> 
```

## Data

### Predictive Modeling Data for Viral Load and CD4 Lymphocyte Counts

This data set serves as input for predictive modeling tasks related to
HIV research. It contains numeric measurements of CD4 lymphocyte counts
(cd) and viral load (vl) at three different time points: 2019, 2021, and
2022. These measurements are crucial indicators of HIV disease
progression.

``` r
library(viraldomain)

data(viral)
print(head(viral))
#>    cd_2019     vl_2019  cd_2021   vl_2021  cd_2022      vl_2022
#> 1 819.7516    39.55592 996.2036   82.1747 694.6232     6.795355
#> 2 174.7661 11393.16919 265.0125 1688.2138 121.7820     1.353418
#> 3 340.1795 38955.32816 330.5063 5105.9419 118.5338 53254.165806
#> 4 430.6603    36.36362 448.4024   79.7060 541.9145     1.182425
#> 5 449.8093    69.63252 476.5963  285.0246 551.6427    41.886864
#> 6 497.9111  4087.85600 555.2554 3054.2144 553.9491  1900.625796
```

### Seropositive Data for Applicability Domain Testing

This data set is designed for testing the applicability domain of
methods related to HIV research. It provides a tibble with 53 rows and 2
columns containing numeric measurements of CD4 lymphocyte counts
(cd_2022) and viral load (vl_2022) for seropositive individuals in 2022.

``` r
data(sero)
print(head(sero))
#>    cd_2022     vl_2022
#> 1 544.7516   18.437985
#> 2 165.7661   89.218960
#> 3 692.1795    1.458075
#> 4 523.6603    1.308280
#> 5 161.8093    5.066157
#> 6 373.9111 3114.900907
```

## Function

### knn_domain_score

This function fits a K-Nearest Neighbor (KNN) model to the provided data
and computes a domain applicability score based on PCA distances.

``` r
# Example usage of knn_domain_score
domain_scores <- knn_domain_score(
  featured = "cd_2022",
  train_data = viral |> dplyr::select(cd_2022, vl_2022),
  knn_hyperparameters = list(neighbors = 5, weight_func = "optimal", dist_power = 0.33),
  test_data = sero,
  threshold_value = 0.99
)
print(domain_scores)
#> # A tibble: 53 × 3
#>    .pred distance distance_pctl
#>    <dbl>    <dbl>         <dbl>
#>  1  528.    0.424          9.08
#>  2  405.    1.32          69.9 
#>  3  545.    1.01          60.7 
#>  4  599.    0.356          4.37
#>  5  585.    1.33          70.2 
#>  6  371.    0.452         18.7 
#>  7  483.    1.11          66.1 
#>  8  405.    0.321          3.49
#>  9  291.    0.573         25.3 
#> 10  405.    0.660         38.6 
#> # ℹ 43 more rows
```

### simple_domain_plot

This function generates a domain plot for a simple model based on PCA
distances of the provided data.

``` r
# Example usage of simple_domain_plot
simple_domain_plot(
  featured_col = "cd_2022",
  train_data = viral |> dplyr::select(cd_2022, vl_2022),
  test_data = sero,
  treshold_value = 0.99
)
```

<img src="man/figures/README-simp-1.png" width="100%" />
