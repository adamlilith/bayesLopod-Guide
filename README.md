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
install.packages("bayesLopod", dependencies = T)

library(bayesLopod)
packageVersion("bayesLopod")
```
Make sure the version installed is > 1.0.1, the most recent version of bayesLopod can be installed from github usung the `devtools` package:
``` R
devtools::install_github( repo = "bayesLopod",
                          username = "camilosanin")

library(bayesLopod)
packageVersion("bayesLopod")
```

``` R
data("Andropogon_shape", package = "bayesLopod")
androSEff = spplot(Andropogon_shape, zcol=c("sampEffort"), main = "Sampling Effort")
androDetect = spplot(Andropogon_shape, zcol=c("detections"), main = "Detections")
plot(androSEff, split=c(1,1,2,1), more = T)
plot(androDetect,  split=c(2,1,2,1), more = F)
```

![Andropogon-input](/gif/Andropogon_input.gif)

``` R
ld_Shape = shapeLopodData( Shapefile = Andropogon_shape,
                           fieldN = "sampEffort",
                           fieldY = "detections",  
                           Adjacency = T,
                           keepFields = F)

```

``` R
mLopodShape = modelLopod( LopodData = ld_Shape,
                          varP = T,
                          q = NULL,
                          pmin = 0,
                          CAR = T,
                          nChains = 3,
                          warmup = 400,
                          sampling = 100,
                          nCores =3)
```
``` R
lopodTrace( mLopodShape, inc_warmup = T)
```
![Andropogon-trace](/gif/Andropogon_trace.gif)

``` R
lopodDens(mLopodShape, c("q", "pmin", "pmax"))
```
![Andropogon-dens](/gif/Andropogon_dens.gif)

``` R
AndroShape = mLopodShape@LopodData@geoDataObject

psiShape = lopodShape(mLopodShape, "psi_i", extrapolate = T,  quant = 0.05)
AndroShape@data[,"psi_05"] = psiShape@data[,"psi_i"]

psiShape = lopodShape(mLopodShape, "psi_i", extrapolate = T,  quant = 0.5)
AndroShape@data[,"psi_50"] = psiShape@data[,"psi_i"]

psiShape = lopodShape(mLopodShape, "psi_i", extrapolate = T,  quant = 0.95)
AndroShape@data[,"psi_95"] = psiShape@data[,"psi_i"]

spplot( AndroShape,
        zcol = c("psi_05", "psi_50", "psi_95"),
        names.attr = c("Psi (5% quantile)", "Psi (median)", "Psi (95% quantile)"), main = "Occupancy (Psi)")
        )
```
![Andropogon-psi-spplot](/gif/Andropogon_psi_spplot.gif)

### Case Study: Simulated Species (Coordinates and Raster)

![XY-input](/gif/XY_Input.gif)
![XY-trace](/gif/XYTrace.gif)
![XY-dens](/gif/XYDens.gif)
![Probability of presence](/gif/prPres_eq.gif)
![XY-psi-spplot](/gif/XY_raster.gif)
