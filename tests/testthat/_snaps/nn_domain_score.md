# `nn_domain_score()` works

    Code
      print(nn_domain_score(featured_col, train_data, nn_hyperparameters, test_data,
        threshold_value))
    Output
      # A tibble: 53 x 3
           .pred distance distance_pctl
           <dbl>    <dbl>         <dbl>
       1  0.216     1.74           72.7
       2 -0.0268    1.21           57.0
       3  0.200     1.61           70.5
       4  0.190     1.39           64.7
       5  0.171     1.68           71.7
       6 -0.193     1.30           58.5
       7  0.115     0.920          50.3
       8  0.109     0.732          38.4
       9  0.109     0.659          32.0
      10 -0.0418    0.733          38.4
      # i 43 more rows

