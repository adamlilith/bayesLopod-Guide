library(ggplot2)
library(ggplot2)

##### ANDROPOGON

data("Andropogon_shape", package = "bayesLopod")

#Andropogon Input Data
androSEff = spplot(Andropogon_shape, zcol=c("sampEffort"), main = "Sampling Effort")
androDetect = spplot(Andropogon_shape, zcol=c("detections"), main = "Detections")
plot(androSEff, split=c(1,1,2,1), more = T)
plot(androDetect,  split=c(2,1,2,1), more = F)

#Andropogon Model
ld_Shape = shapeLopodData(Shapefile = Andropogon_shape, fieldN = "sampEffort", fieldY = "detections",  Adjacency = T, keepFields = F)
#mLopodShape = modelLopod(LopodData = ld_Shape, varP = T, q = NULL, pmin = 0, CAR = T, nChains = 3,warmup = 400,sampling = 100,nCores =3)
#save(mLopodShape, file = "c:/github/bayesLopod guide/Objects/AndropogonModel.rda")


#Andropogon Trace
lopodTrace(mLopodShape, inc_warmup = T)

#Andropogon Dens
lopodDens(mLopodShape, c("q", "pmin", "pmax"))

#Andropogon psi (0.05, 0.5, 0.95 quantiles)

AndroShape = mLopodShape@LopodData@geoDataObject

psiShape = lopodShape(mLopodShape, "psi_i", extrapolate = T,  quant = 0.05)
AndroShape@data[,"psi_05"] = psiShape@data[,"psi_i"]

psiShape = lopodShape(mLopodShape, "psi_i", extrapolate = T,  quant = 0.5)
AndroShape@data[,"psi_50"] = psiShape@data[,"psi_i"]

psiShape = lopodShape(mLopodShape, "psi_i", extrapolate = T,  quant = 0.95)
AndroShape@data[,"psi_95"] = psiShape@data[,"psi_i"]

spplot(AndroShape, zcol=c("psi_05", "psi_50", "psi_95"), names.attr	=c("Psi (5% quantile)", "Psi (median)", "Psi (95% quantile)"), main = "Occupancy (Psi)")

##### XY PLOTS

#XY Input
data("simSpRecords", package = "bayesLopod")
data("simSpSamplingEffort", package = "bayesLopod")
simSpRasters = xyToRaster(xyRecords = simSpRecords,xySamplingEffort = simSpSamplingEffort,basemap = NULL, nrows = 50, extentExpansion = 0)

spplot(simSpRasters, names.attr	=c("Species Detections","Sampling Effort"))

##XY Model
simSpRasters = xyToRaster(xyRecords = simSpRecords,xySamplingEffort = simSpSamplingEffort,basemap = NULL, nrows = 50, extentExpansion = 0)
ld_Raster_adMatrix = rasterLopodData(rasterN = simSpRasters[["samplingEffort"]], rasterY = simSpRasters[["spDetections"]], Adjacency = T )
#mLopodRaster = modelLopod(LopodData = ld_Raster_adMatrix, varP = F, q = NULL, pmin = 0, CAR = T,nChains = 4,warmup = 100,sampling = 50,nCores = 4)
#save(mLopodRaster, file = "c:/github/bayesLopod guide/Objects/XY_Model.rda")

#XYTrace
lopodTrace(mLopodRaster, inc_warmup = T)

#XYDens
lopodDens(mLopodRaster, c("q", "p"))

#XY Psi Rasters

ppRaster = lopodRaster(mLopodRaster, param = "pp", extrapolate = F, metric = "mean")
psiRaster = lopodRaster(mLopodRaster, param = "psi_i", extrapolate = T, metric = "mean")
spplot(raster::stack(psiRaster,ppRaster),  names.attr	=c("Occupancy (Psi)", "Probability of Presence"))

####### PRIOR DISTRIBUTIONS

#Psi_i
curve(dbeta(x,0.5,0.5), col = "slategray1", lwd = 3, type = "h", from = 0, to = 1, n = 500, ylab="", xlab = "Psi", yaxt="n" )
curve(dbeta(x,0.5,0.5), col = "black", lwd = 2, type = "l", from = 0, to = 1, add=T, n = 500)

#qRate
curve(dnorm(x,0,0.05), col = "slategray1", lwd = 3, type = "h", from = 0, to = 1, n = 500, ylab="", xlab = "qRate", yaxt="n")
curve(dnorm(x,0,0.05), col = "black", lwd = 2, type = "l", from = 0, to = 1, add=T, n = 500)

#pRange
curve(dnorm(x,0,0.1), col = "slategray1", lwd = 3, type = "h", from = 0, to = 1, n = 500, ylab="", xlab = "pRange", yaxt="n")
curve(dnorm(x,0,0.1), col = "black", lwd = 2, type = "l", from = 0, to = 1, add=T, n = 500)

#pmax
curve(dnorm(x,0.5,0.25), col = "slategray1", lwd = 3, type = "h", from = 0, to = 1, n = 500, ylab="", xlab = "pmax", yaxt="n")
curve(dnorm(x,0.5,0.25), col = "black", lwd = 2, type = "l", from = 0, to = 1, add=T, n = 500)

#pmin
curve(dnorm(x,0.5,0.25), col = "slategray1", lwd = 3, type = "h", from = 0, to = 1, n = 500, ylab="", xlab = "pmin", yaxt="n")
curve(dnorm(x,0.5,0.25), col = "black", lwd = 2, type = "l", from = 0, to = 1, add=T, n = 500)

#praw
curve(dnorm(x,1,0.25), col = "slategray1", lwd = 3, type = "h", from = 0, to = 1, n = 500, ylab="", xlab = "praw", yaxt="n")
curve(dnorm(x,1,0.25), col = "black", lwd = 2, type = "l", from = 0, to = 1, add=T, n = 500)


