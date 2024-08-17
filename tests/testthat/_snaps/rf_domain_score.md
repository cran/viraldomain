# `rf_domain_score()` works

    Code
      print(rf_domain_score(featured_col, train_data, rf_hyperparameters, test_data,
        threshold_value))
    Condition
      Warning:
      2 columns were requested but there were 1 predictors in the data. 1 will be used.
    Output
      # A tibble: 53 x 3
         .pred distance distance_pctl
         <dbl>    <dbl>         <dbl>
       1  592.    0.438         20.3 
       2  299.    1.35          70.7 
       3  264.    1.02          60.7 
       4  414.    0.332          3.60
       5  537.    1.38          74.9 
       6  402.    0.425          7.57
       7  563.    1.11          66.5 
       8  300.    0.346          3.98
       9  563.    0.568         24.5 
      10  299.    0.664         38.0 
      # i 43 more rows

