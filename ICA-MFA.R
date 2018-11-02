#########################
### ICA-MFA algorithm  ##
#########################

###################
# Libraries
###################
library("FactoMineR")
library("fastICA")
require(GGally)
library(MASS)
library(ica)
library(data.table)
library(caret)
library(mlbench)
###################

# Load data
source("DataFromPhenotypeSimulator.R")


# Step 1
ICAROIs <- fastICA(ROIs, 1, alg.typ = "parallel", fun = "logcosh", alpha = 1,
                   method = "R", row.norm = FALSE, maxit = 200,
                   tol = 0.0001, verbose = TRUE)

ICASNPs <- fastICA(SNPs, 1, alg.typ = "parallel", fun = "logcosh", alpha = 1,
                   method = "R", row.norm = FALSE, maxit = 200,
                   tol = 0.0001, verbose = TRUE)


# Step 2
Z1 <- ROIs/sqrt(abs(ICAROIs$S[1]))
Z2 <- SNPs/sqrt(abs(ICASNPs$S[1]))


# Step 3
X <- cbind(Z1,Z2)

# Step 4
ICAX <- fastICA(X, 25, alg.typ = "parallel", fun = "logcosh", alpha = 1,
                method = "R", row.norm = FALSE, maxit = 200,
                tol = 0.0001, verbose = TRUE)


# Step 5: Hold-test ICR
dataICR <- data.frame(phenotype=phenotype[,1], ICAX$S)

set.seed(123456789)
in_train <- createDataPartition(dataICR$phenotype, p = 4/5, list = FALSE)
training <- dataICR[ in_train,]
testing  <- dataICR[-in_train,]
ica_fit <- train(phenotype ~ ., data = training, method = "icr")



#### PCA-MFA based components
datos.mfa <- data.frame(ROIs, SNPs)
res.mfa <- MFA(datos.mfa, ncp=25, group=c(15,NSNPs))

dataMFA <- data.frame(phenotype=phenotype[,1], res.mfa$ind$contrib)
set.seed(123456789)
in_train <- createDataPartition(dataMFA$phenotype, p = 4/5, list = FALSE)
training <- dataMFA[ in_train,]
testing  <- dataMFA[-in_train,]
mfa_fit <- train(phenotype~., data=training, method="lm")


# Results:
ica_fit
mfa_fit