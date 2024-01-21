# `knn_domain_score()` works

    Code
      print(knn_domain_score(featured, train_data, knn_hyperparameters, test_data,
        threshold_value))
    Output
      # A tibble: 53 x 3
         .pred distance distance_pctl
         <dbl>    <dbl>         <dbl>
       1  356.    0.438         20.3 
       2  379.    1.35          70.7 
       3  356.    1.02          60.6 
       4  442.    0.331          3.68
       5  400.    1.38          75.2 
       6  370.    0.425          7.62
       7  395.    1.11          66.6 
       8  367.    0.347          4.10
       9  356.    0.568         24.6 
      10  372.    0.665         38.7 
      # i 43 more rows

