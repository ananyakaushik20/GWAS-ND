
###GRS versus disease status

Rscript - <<EOF

# Download the necessary packages 
if (!require(tidyverse)) install.packages('tidyr')
if (!require(data.table)) install.packages('data.table')
if (!require(dplyr)) install.packages('dplyr')
if (!require(plyr)) install.packages('plyr')
if (!require(ggplot2)) install.packages('ggplot2')
if (!require(caret)) install.packages('caret')
if (!require(plotROC)) install.packages('plotROC')


# Load the necessary packages 
library(tidyr)
library(data.table)
library(dplyr)
library(plyr)
library(ggplot2)
library(plotROC)
library(caret)

EOF


### Calculate Score in cases versus controls ## toPRS_training_Alzheimer* contain Parkinson disease inviduals for which I have extracted AD related variants
plink --bfile toPRS_training_Parkinson --score SCORE_PD.txt --out GRS_PD_test

head SCORE_PD.txt
head test_covs.txt

### Normalize Score to Z-Score 

Rscript - <<EOF
temp_data <- read.table("GRS_PD_test.profile", header = T) 
temp_covs <- read.table("test_covs.txt", header = T)
data <- merge(temp_data, temp_covs, by = "FID")
data$CASE <- data$PHENO.x - 1
meanControls <- mean(data$SCORE[data$CASE == 0])
sdControls <- sd(data$SCORE[data$CASE == 0])
data$zSCORE <- (data$SCORE - meanControls)/sdControls
grsTests <- glm(CASE ~ zSCORE + SEX + PC1 + PC2 + PC3 + PC4 + PC5 + PC6 + PC7 + PC8 + PC9 + PC10 + AAO, family="binomial", data = data)
summary(grsTests)

 # log(OR) = beta value

OR <- exp(0.5167042)
OR


## 3. GRS versus age at onset
#explore if genetic markers are associated with an earlier age an onset in Parkinson's disease

### Extract cases and normalize scores


temp_data <- read.table("GRS_PD_test.profile", header = T)
temp_covs <- read.table("test_covs.txt", header = T)
data <- merge(temp_data, temp_covs, by = "FID")
data$CASE <- data$PHENO.x - 1 
cases <- subset(data, PHENO.x == 1)
meanPop <- mean(cases$SCORE)
sdPop <- sd(cases$SCORE)
cases$zSCORE <- (cases$SCORE - meanPop)/sdPop
grsTests <- lm(AAO ~ zSCORE + SEX + PC1 + PC2 + PC3 + PC4 + PC5 + PC6 + PC7 + PC8 + PC9 + PC10, data = cases)
summary(grsTests)
EOF

## 4. Genetic correlations between Parkinson and Alzheimer's disease.


### Calculate AD genetic risk in PD cases versus controls - ## toPRS_training_Alzheimer* contain Parkinson disease inviduals for which I have extracted Alzheimer's disease related variants
plink --bfile toPRS_training_Alzheimer --score SCORE_AD.txt --out GRS_AD_test

head GRS_AD_test.profile

### Normalize Score to Z-Score 

Rscript - <<EOF

temp_data <- read.table("GRS_AD_test.profile", header = T) 
temp_covs <- read.table("test_covs.txt", header = T)
data <- merge(temp_data, temp_covs, by = "FID")
data$CASE <- data$PHENO.x - 1
meanControls <- mean(data$SCORE[data$CASE == 0])
sdControls <- sd(data$SCORE[data$CASE == 0])
data$zSCORE <- (data$SCORE - meanControls)/sdControls
grsTests <- glm(CASE ~ zSCORE + SEX + PC1 + PC2 + PC3 + PC4 + PC5 + PC6 + PC7 + PC8 + PC9 + PC10 + AAO, family="binomial", data = data)
summary(grsTests)

OR <- exp(8.756e-02)
OR

## Create Violin Plot

##make a violin plot assigning my variables case-control


temp_data <- read.table("GRS_PD_test.profile", header = T)
temp_covs <- read.table("test_covs.txt", header = T)
data <- merge(temp_data, temp_covs, by = "FID")
data$PHENO.x <- data$PHENO.x - 1
head(data)
meanControls <- mean(data$SCORE[data$PHENO.x == 0])
sdControls <- sd(data$SCORE[data$PHENO.x == 0])
data$zSCORE <- (data$SCORE - meanControls)/sdControls

data$PHENO.x[data$PHENO.x ==0] <- "Controls"
data$PHENO.x[data$PHENO.x ==1] <- "PD"
p <- ggplot(data, aes(x= reorder(as.factor(PHENO.x), zSCORE), y=zSCORE, fill=as.factor(PHENO.x))) +
  geom_violin(trim=FALSE)
p2 <- p+geom_boxplot(width=0.4, fill="white" ) + theme_minimal()
p2 + scale_fill_manual(values=c("lightblue", "orange")) + theme_bw() + ylab("PD GRS (Z-transformed)") +xlab("") + theme(legend.position = "none")
ggsave("PD_GRS.jpeg", dpi = 600, units = "in", height = 6, width = 6)

## Create quantile plots

## Make quantiles

temp_data <- read.table("GRS_PD_test.profile", header = T)
temp_covs <- read.table("test_covs.txt", header = T)
data <- merge(temp_data, temp_covs, by = "FID")
data$CASE <- data$PHENO.x - 1
meanControls <- mean(data$SCORE[data$CASE == 0])
sdControls <- sd(data$SCORE[data$CASE == 0])
data$zSCORE <- (data$SCORE - meanControls)/sdControls

data$quantile1 <- ifelse(data$zSCORE <= quantile(data$zSCORE)[2], 1, 0)
data$quantile2 <- ifelse(data$zSCORE > quantile(data$zSCORE)[2] & data$zSCORE <= quantile(data$zSCORE)[3], 1, 0)
data$quantile3 <- ifelse(data$zSCORE > quantile(data$zSCORE)[3] & data$zSCORE <= quantile(data$zSCORE)[4], 1, 0)
data$quantile4 <- ifelse(data$zSCORE > quantile(data$zSCORE)[4], 1, 0)
data$quantiles <- 1
data$quantiles[data$quantile2 == 1] <- 2
data$quantiles[data$quantile3 == 1] <- 3
data$quantiles[data$quantile4 == 1] <- 4
quintileTests <- glm(CASE ~ as.factor(data$quantiles) + AAO + SEX + PC1 + PC2 + PC3 + PC4 + PC5 + PC6 + PC7 + PC8 + PC9 + PC10, family="binomial", data = data)

## Summarize the regression and export a table

summary(quintileTests)
summary_stats <- data.frame(summary(quintileTests)$coef[2:4,1:2])
names(summary_stats) <- c("BETA","SE")
summary_stats$QUANTILE <- c("2nd","3rd","4th")
summary_stats[4,] <- c(0,0,"1st")
summary_stats_sorted <- summary_stats[order(summary_stats$QUANTILE),]
write.table(summary_stats_sorted, "quantile_table.csv", quote = F, row.names = F, sep = ",")

## Make a quantile plot

data$CASE <- data$PHENO.x - 1
to_plot <- read.table("quantile_table.csv", header = T, sep = ",")
to_plot$low <- to_plot$BETA - (1.96*to_plot$SE)
to_plot$high <- to_plot$BETA + (1.96*to_plot$SE)
plotted <- ggplot(to_plot, aes(QUANTILE, BETA)) + geom_pointrange(aes(ymin = low, ymax = high))
ggsave(plot = plotted, filename = "plotQuantile.png", width = 4, height = 4, units = "in", dpi = 300)

## ROC calculation and Data Visualization: ROC plots

## run a regression model


library(plotROC)
library(ggplot2)
install.packages("e1071")
library(e1071)

temp_data <- read.table("GRS_PD_test.profile", header = T)
temp_covs <- read.table("test_covs.txt", header = T)
data <- merge(temp_data, temp_covs, by = "FID")
data$CASE <- data$PHENO.x - 1
meanControls <- mean(data$SCORE[data$CASE == 0])
sdControls <- sd(data$SCORE[data$CASE == 0])
data$zSCORE <- (data$SCORE - meanControls)/sdControls

## build model

Model <- glm(CASE ~ SCORE, data = data, family = 'binomial')

## make predictions

data$probDisease <- predict(Model, data, type = c("response"))
data$predicted <- ifelse(data$probDisease > 0.5, "DISEASE", "CONTROL")
data$reported <- ifelse(data$CASE == 1, "DISEASE","CONTROL")

##make an ROC plot

overlayedRocs <- ggplot(data, aes(d = CASE, m = probDisease)) + geom_roc(labels = FALSE) + geom_rocci() + style_roc(theme = theme_gray) + theme_bw() + scale_fill_brewer(palette="Spectral")
ggsave(plot = overlayedRocs, filename = "plotRoc.png", width = 8, height = 5, units = "in", dpi = 300)

## Display confusion matrix
confMat <- confusionMatrix(data = as.factor(data$predicted), reference = as.factor(data$reported), positive = "DISEASE")
confMat



## Density Plot
## make a KDE plot to observe how well our model can cluster Parkinson disease cases versus controls



temp_data <- read.table("GRS_PD_test.profile", header = T)
temp_covs <- read.table("test_covs.txt", header = T)
data <- merge(temp_data, temp_covs, by = "FID")
data$CASE <- data$PHENO.x - 1
meanControls <- mean(data$SCORE[data$CASE == 0])
sdControls <- sd(data$SCORE[data$CASE == 0])
data$zSCORE <- (data$SCORE - meanControls)/sdControls

## build model

Model <- glm(CASE ~ SCORE, data = data, family = 'binomial')

## make predictions

data$probDisease <- predict(Model, data, type = c("response"))
data$predicted <- ifelse(data$probDisease > 0.5, "DISEASE", "CONTROL")
data$reported <- ifelse(data$CASE == 1, "DISEASE","CONTROL")

densPlot <- ggplot(data, aes(probDisease, fill = reported, color = reported)) + geom_density(alpha = 0.5) + theme_bw()
ggsave(plot = densPlot, filename = "plotDensity.png", width = 8, height = 5, units = "in", dpi = 300)

EOF
