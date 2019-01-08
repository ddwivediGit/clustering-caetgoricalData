

rm(list = ls())

library(dplyr) # for data cleaning
#library(ISLR) # for college dataset
library(cluster) # for gower similarity and pam
library(Rtsne) # for t-SNE plot
library(ggplot2) # for visualization

#Simulate data

#relationship_status
rel_sta <- sample( c("Prospect","Reseller","Distributer","Customer"), 1000, replace=TRUE, prob=c(0.2, 0.3, 0.3, 0.2))
#Decision maker type
des_mak_type <- sample( c("Business","Technical"), 1000, replace=TRUE, prob=c(0.3, 0.7))
#Job title class
job_class <- sample( c("E-Commerce","Logistics","Operations","Finance","Manufacturing","Sales"), 1000, replace=TRUE, prob=c(0.2, 0.2, 0.2,0.1, 0.2,0.1))
#Job detail
job_detail <- sample( c("CFO","CIO","CEO","Director","Ind Con"), 1000, replace=TRUE, prob=c(0.1, 0.1, 0.1, 0.1,0.6))
#Marketing regions
mar_region <- sample( c("Emerging","USA/Canada","Asia-Pacific","Europian","Japan"), 1000, replace=TRUE, prob=c(0.2, 0.2, 0.3, 0.15,0.15))
#Company Size
company_size <- sample( c("Small","Mid", "Large"), 1000, replace=TRUE, prob=c(0.3, 0.5, 0.2))
#Import Export Indicator
imp_exp_ind <- sample( c("Import","Export", "Both"), 1000, replace=TRUE, prob=c(0.3, 0.5, 0.2))


profile_data <- data.frame(rel_sta, des_mak_type, job_class, job_detail, mar_region, company_size, imp_exp_ind)
glimpse(profile_data)

#Calculate Gower distance
gower_dist <- daisy(profile_data,
                    metric = "gower")

summary(gower_dist)

# Calculate silhouette width for many k using PAM

sil_width <- c(NA)

for(i in 2:10){
  
  pam_fit <- pam(gower_dist,
                 diss = TRUE,
                 k = i)
  
  sil_width[i] <- pam_fit$silinfo$avg.width
  
}

# Plot sihouette width (higher is better)

plot(1:10, sil_width,
     xlab = "Number of clusters",
     ylab = "Silhouette Width")
lines(1:10, sil_width)


#Clustering
pam_fit <- pam(gower_dist, diss = TRUE, k = 4)

pam_results <- profile_data %>%
  mutate(cluster = pam_fit$clustering) %>%
  group_by(cluster) %>%
  do(the_summary = summary(.))

pam_results$the_summary


profile_data[pam_fit$medoids,]

#Plot:  t-distributed stochastic neighborhood embedding
tsne_obj <- Rtsne(gower_dist, is_distance = TRUE)

tsne_data <- tsne_obj$Y %>%
  data.frame() %>%
  setNames(c("X", "Y")) %>%
  mutate(cluster = factor(pam_fit$clustering))

ggplot(aes(x = X, y = Y), data = tsne_data) +
  geom_point(aes(color = cluster))
