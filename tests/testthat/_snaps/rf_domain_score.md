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
       1  483.    0.424          9.08
       2  360.    1.32          69.9 
       3  669.    1.01          60.7 
       4  615.    0.356          4.37
       5  603.    1.33          70.2 
       6  405.    0.452         18.7 
       7  574.    1.11          66.1 
       8  439.    0.321          3.49
       9  248.    0.573         25.3 
      10  360.    0.660         38.6 
      # i 43 more rows

