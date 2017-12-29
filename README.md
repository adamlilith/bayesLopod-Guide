### Model

![Binomial Expanded](/gif/Binomial_exp_eq.gif)
``` R
library(bayesLopod)
x = "bla"
```

``` Stan
real <lower = 0, upper = 1> bla;
target += normal_lpdf(bla | 0,1)
```


![Double Binomial](/gif/binomialpq_eq.gif)
![psi Prior](/gif/psi_prior.gif)
![qRate Prior](/gif/qRate_prior.gif)
![Double Binomial pi](/gif/binomialpiq_eq.gif)
![pRange Prior](/gif/pRange_prior.gif)
![Praw Prior](/gif/Praw_prior.gif)

## Examples
### Case Study: _Andropogon gerardii_ (Shape File)

![Andropogon-input](/gif/Andropogon_input.gif)
![Andropogon-trace](/gif/Andropogon_trace.gif)
![Andropogon-dens](/gif/Andropogon_dens.gif)
![Andropogon-psi-spplot](/gif/Andropogon_psi_spplot.gif)

### Case Study: Simulated Species (Coordinates and Raster)

![XY-input](/gif/XY_Input.gif)
![XY-trace](/gif/XYtrace.gif)
![XY-dens](/gif/XYdens.gif)
![Probability of presence](/gif/PrPres_eq.gif)
![XY-psi-spplot](/gif/XY_raster.gif)
