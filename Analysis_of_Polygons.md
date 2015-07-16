---
title: "Analysis_of_Polygons"
author: "Koshlan"
date: "July 15, 2015"
output: html_document
---


This particular document was created as notes following a tutorial from Brunsdon and Comber's 
(2015) An Introduction to R for Spatial Analysis, chapter 7.

Foremost, I read the chapter because they had a very nice vizualization of 
polygon adjacency networks (see below).

This particular document was created as note following a tutorial from Brunsdon and Comber's 
(2015) An Introduction to R for Spatial Analysis. 

Foremost, I read the chapter because they had a very nice vizualization of 
polygon adjacency networks.
>>>>>>> 9ea931e3aa81f0688d863963076b9288caaa88a5

### Packages
Here are the preliminaries:

```r
require(GISTools)
require(SpatialEpi)
require(rgdal)
require(spdep)
```

The dataset is loaded, coordinates transformed, and a descriptive variable extracted.
From which it is straightforward to plot spatial distribution of smoking in Pennsylvania:

```r
data(pennLC)
#str(pennLC)
penn.state.latlong <- pennLC$spatial.polygon
penn.state.utm <- spTransform(penn.state.latlong, 
                              CRS("+init=epsg:3724 +units=km +ellps=WGS84"))
smk<-pennLC$smoking$smoking *100
```

<img src="figure/unnamed-chunk-3-1.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="350px" />

### Polygons Network
Here is the code for the graphic I really liked in the tutorial.

```r
penn.state.nb <- poly2nb(penn.state.utm)
# The object class "nb" stores a list of neighboring polygons
plot(penn.state.utm, border = "lightgrey")
plot(penn.state.nb, coordinates(penn.state.utm), add = T, col = "#0000FF50", lwd = 2)
```

<img src="figure/unnamed-chunk-4-1.png" title="plot of chunk unnamed-chunk-4" alt="plot of chunk unnamed-chunk-4" width="350px" />

### Lagged Means
The authors suggest a first order exploratory approach:
analysis of lagged means, appropriate when a feature of continuous data is associated with each polgon.

The lagged mean: the value of polygon vs. the unweighted mean of its neighbors. 
A comparison of the polygon value to that of its lagged mean shows anomolies 
that differ from surroundings, as well as points on the 45 degree line that 
share a value similar to their local neighborhood. 

Moreover, an enrichment of points in 1st and 3rd quadrants 
manifests a degree of spatial auto correlation.


```r
# This object holds the (i) neighbors of each polygon and (ii) their weights

penn.state.lw <- nb2listw(penn.state.nb)
smk.lagged.means <- lag.listw(penn.state.lw, smk)
par(mar =c(5,5,5,5))
plot(smk, smk.lagged.means, asp=1, xlim = range(smk), ylim = range(smk))
abline(0,1)
abline(v=mean(smk), lty=2)
abline(h =mean(smk.lagged.means), lty =2)
```

![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-5-1.png) 

### Moran's I
Moran's I is a measure of spatial autocorrelation amoung polygons in a spatial domain.

The starting point is a matrix (W) that relates the degree of dependence between
the ith and jth polygon, and the statistic follows:

 $\begin{equation}
I = \frac{n}{\displaystyle\sum_{i=1}^n \sum_{j=1}^n w_{ij}}
\frac{\displaystyle\sum_{i=1}^n \sum_{j=1}^n w_{ij}(x_i - \bar{x})(x_j -
  \bar{x})}{\displaystyle\sum_{i=1}^n (x_i - \bar{x})^2},\label{eq:morani}
\end{equation}$

The moran test can be run from spdep no the listw object

```r
require(spdep)
moran.test(smk,penn.state.lw)
```

```
## 
## 	Moran's I test under randomisation
## 
## data:  smk  
## weights: penn.state.lw  
## 
## Moran I statistic standard deviate = 5.527, p-value = 1.629e-08
## alternative hypothesis: greater
## sample estimates:
## Moran I statistic       Expectation          Variance 
##       0.404309335      -0.015151515       0.005759843
```

Brunsdon and Comber's make two noteworthy observations. First, 
when the W matrix is standardized so the rows equal one, then the weights are 
exactly those used in the lagged mean test. (e.g Say a polygon as 3 neighbors then each has weight 1/3) 

Second, the Moran's I coefficient is dimensionless number that varies with valuses of W matrix. 
Further it depends on the homogeneity of the polygon values and number of polygons, so
it's interpretation should involve a test against a null hypothesis: namely that there was 
no spatial correlation beyond what could be achieved by random chance.

Three approaches are offered.

1. Parametric assume the value are drawn from a gaussian, with a test statistic (see page 233)
2. Premuation test, with convergens to a normal. That is, premute all the values randomly amoung polygons (see page 233).
3. Monte Carlo, with random premutatation.


```r
require(spdep)
moran.test(smk,penn.state.lw, randomisation = TRUE)
```

```
## 
## 	Moran's I test under randomisation
## 
## data:  smk  
## weights: penn.state.lw  
## 
## Moran I statistic standard deviate = 5.527, p-value = 1.629e-08
## alternative hypothesis: greater
## sample estimates:
## Moran I statistic       Expectation          Variance 
##       0.404309335      -0.015151515       0.005759843
```

```r
moran.test(smk,penn.state.lw, randomisation = FALSE)
```

```
## 
## 	Moran's I test under normality
## 
## data:  smk  
## weights: penn.state.lw  
## 
## Moran I statistic standard deviate = 5.5593, p-value = 1.355e-08
## alternative hypothesis: greater
## sample estimates:
## Moran I statistic       Expectation          Variance 
##        0.40430934       -0.01515152        0.00569310
```

```r
moran.mc(smk,penn.state.lw, 1000)
```

```
## 
## 	Monte-Carlo simulation of Moran's I
## 
## data:  smk 
## weights: penn.state.lw  
## number of simulations + 1: 1001 
## 
## statistic = 0.4043, observed rank = 1001, p-value = 0.000999
## alternative hypothesis: greater
```


### Spatial Autocorrelation

####SAR MODEL

Weights are often based on polygons adjacency. Recall that in Kriging, a similar variance- 
covariance matrix is modeled based physical distance.

### Summary. 

So what are the take aways? spdep is a package 
with some tools that glue to analyze adjacent polgons.

A crucial set of objects for encapsilating information about polygon adjacency are nb and listw.

A function for determining nieghbors

spdep::poly2nb()

A function for creating an object to hold neighbors and weights 

spdep::nb2listw()

Some things left to discover:

What about nearby polygons that do not share edges?

What about weights based on centroid distance or edge distance?

What about neighbors of neighbors?

How scalable are these objects and functions to larger datasets?

Identifying spatial correlation is easy? How can it be used to improve prediction.
