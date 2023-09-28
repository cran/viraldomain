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
       1 -0.771     1.74           72.7
       2  0.130     1.21           57.0
       3 -0.535     1.61           70.5
       4 -0.399     1.39           64.7
       5 -0.178     1.68           71.7
       6 -0.428     1.30           58.5
       7  0.353     0.920          50.3
       8  0.405     0.732          38.4
       9  0.409     0.659          32.0
      10  0.0793    0.733          38.4
      # i 43 more rows

