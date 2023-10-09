# `mars_domain_score()` works

    Code
      print(mars_domain_score(featured_col, train_data, mars_hyperparameters,
        test_data, threshold_value))
    Message <packageStartupMessage>
      Loading required package: Formula
      Loading required package: plotmo
      Loading required package: plotrix
      Loading required package: TeachingDemos
    Output
      # A tibble: 53 x 3
            .pred distance distance_pctl
            <dbl>    <dbl>         <dbl>
       1 -0.124      1.74           76.0
       2 -0.00400    1.21           50.4
       3 -0.0709     1.61           71.7
       4 -0.0402     1.39           54.6
       5  0.00957    1.68           73.9
       6 -0.198      1.30           51.9
       7  0.129      0.920          37.0
       8  0.141      0.732          24.7
       9  0.142      0.659          21.4
      10 -0.0217     0.733          24.9
      # i 43 more rows

