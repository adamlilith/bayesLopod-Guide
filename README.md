### Model

![Binomial Expanded](/gif/binomial_exp_eq.gif)

``` Stan
binomial_lpmf(y[cell] | N[cell],p[cell]);
```

![Double Binomial](/gif/binomialpq_eq.gif)

``` Stan
  target  += log_mix( psi_Sampled[cell],
                      binomial_lpmf(y[cell] | N[cell] , p),
                      binomial_lpmf(y[cell] | N[cell] , q)
                      );
```

| ![psi Prior](/gif/psi_prior.gif) | ![qRate Prior](/gif/qRate_prior.gif) |
|---|---|

``` Stan
  target += beta_lpdf(psi_i | 0.5, 0.5);
  target += normal_lpdf(qRate | 0,0.05);
```
![Double Binomial pi](/gif/binomialpiq_eq.gif)


``` Stan
  pRange = pmax - pmin;
  p = (p_raw * pRange) + pmin ;
```

``` Stan
  target  += log_mix( psi_Sampled[cell],
                      binomial_lpmf(y[cell] | N[cell] , p[cell]),
                      binomial_lpmf(y[cell] | N[cell] , q)
                      );
```

| ![pRange Prior](/gif/pRange_prior.gif) | ![Praw Prior](/gif/praw_prior.gif) |
|---|---|

``` Stan
  target += normal_lpdf(pRange | 0, 0.1);
  target += normal_lpdf(p_raw  | 1, 0.25);
```

| ![pRange Prior](/gif/pmin_prior.gif) | ![Praw Prior](/gif/pmax_prior.gif) |
|---|---|

``` Stan
  target += normal_lpdf(pmin | 0.5, 0.25);
  target += normal_lpdf(pmax | 0.5, 0.25);
```

``` Stan
  target += sparse_car_lpdf(psi_i | tau, alpha, W_sparse, D_sparse, lambda, n, W_n);
  target += gamma_lpdf(tau | 2, 2);
  // prior for alpha does not add to target, thus it is an uniform distribution between 0 and 1
```

## Examples
### Case Study: _Andropogon gerardii_ (Shape File)

``` R
library(bayesLopod)
x = "bla"
```

![Andropogon-input](/gif/Andropogon_input.gif)
![Andropogon-trace](/gif/Andropogon_trace.gif)
![Andropogon-dens](/gif/Andropogon_dens.gif)
![Andropogon-psi-spplot](/gif/Andropogon_psi_spplot.gif)

### Case Study: Simulated Species (Coordinates and Raster)

![XY-input](/gif/XY_Input.gif)
![XY-trace](/gif/XYTrace.gif)
![XY-dens](/gif/XYDens.gif)
![Probability of presence](/gif/prPres_eq.gif)
![XY-psi-spplot](/gif/XY_raster.gif)
