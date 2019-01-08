# clustering-caetgoricalData
This R code is used to cluster categorical data using Gower simmilarity and PAM (Partition around mediods)

Following are steps-
1. Simulate a categorical data
2. Calculate Gower distance for simmilarity measure- https://cran.r-project.org/web/packages/gower/vignettes/intro.html
3. Use silhouette width to find ideal number of clusters-   https://en.wikipedia.org/wiki/Silhouette_(clustering)
4. Plot sihouette width
5. Perform PAM clustering
6. Plot:  t-distributed stochastic neighborhood embedding
