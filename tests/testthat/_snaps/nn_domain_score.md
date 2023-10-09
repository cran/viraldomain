# `nn_domain_score()` works

    Code
      print(nn_domain_score(featured_col, train_data, nn_hyperparameters, test_data,
        threshold_value))
    Output
      # A tibble: 53 x 3
           .pred distance distance_pctl
           <dbl>    <dbl>         <dbl>
       1  0.178     1.74           76.0
       2 -0.0311    1.21           50.4
       3  0.160     1.61           71.7
       4  0.149     1.39           54.6
       5  0.130     1.68           73.9
       6 -0.134     1.30           51.9
       7  0.0778    0.920          37.0
       8  0.0724    0.732          24.7
       9  0.0720    0.659          21.4
      10 -0.0413    0.733          24.9
      # i 43 more rows

