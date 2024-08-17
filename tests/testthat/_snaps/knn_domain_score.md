# `knn_domain_score()` works

    Code
      print(knn_domain_score(featured_col, train_data, knn_hyperparameters, test_data,
        threshold_value))
    Output
      # A tibble: 53 x 3
         .pred distance distance_pctl
         <dbl>    <dbl>         <dbl>
       1  591.    0.438         20.3 
       2  332.    1.35          70.7 
       3  330.    1.02          60.7 
       4  354.    0.332          3.60
       5  467.    1.38          74.9 
       6  350.    0.425          7.57
       7  528.    1.11          66.5 
       8  336.    0.346          3.98
       9  528.    0.568         24.5 
      10  332.    0.664         38.0 
      # i 43 more rows

