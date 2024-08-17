# `nn_domain_score()` works

    Code
      print(nn_domain_score(featured_col, train_data, nn_hyperparameters, test_data,
        threshold_value))
    Output
      # A tibble: 53 x 3
         .pred distance distance_pctl
         <dbl>    <dbl>         <dbl>
       1  504.    0.438         20.3 
       2  368.    1.35          70.7 
       3  504.    1.02          60.7 
       4  504.    0.332          3.60
       5  504.    1.38          74.9 
       6  368.    0.425          7.57
       7  504.    1.11          66.5 
       8  368.    0.346          3.98
       9  504.    0.568         24.5 
      10  368.    0.664         38.0 
      # i 43 more rows

