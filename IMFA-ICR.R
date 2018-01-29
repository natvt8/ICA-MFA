setwd("~/")

###################
# Libraries
library("FactoMineR")
library("fastICA")
require(GGally)
library(MASS)
library(ica)
library(data.table)

###################

## Data from PhenotypeSimulator

SNPs = fread("/.../simulated_genotypes_N=n_NSNPs=nSNPs_Nc=NcSNPs.txt")
idSNPs = SNPs[1,]
SNPs = data.frame(SNPs)
colnames(SNPs) = idSNPs
SNPs = SNPs[-1,]
SNPs = apply(SNPs, 2, as.numeric)

ROIs = fread("/.../simulated_brain-structures_N=n_NSNPs=nSNPs_Nc=NcSNPs.txt")
ROIs = data.frame(ROIs)
rownames(ROIs) = rownames(SNPs)

phenotype = fread("/.../simulated_phenotypeY_N=n_NSNPs=NSNPs_Nbrain=nRois.txt")
phenotype = data.frame(phenotype)
names(phenotype) = rownames(SNPs)


#########################
###   IMFA algorithm  ###
#########################

# Step 1

ICAROIs <- fastICA(ROIs, 2, alg.typ = "parallel", fun = "logcosh", alpha = 1,
             method = "R", row.norm = FALSE, maxit = 200,
             tol = 0.0001, verbose = TRUE)

ICAROIs <- icafast(ROIs, 2)

ICASNPs <- fastICA(SNPs, 2, alg.typ = "parallel", fun = "logcosh", alpha = 1,
                   method = "R", row.norm = FALSE, maxit = 200,
                   tol = 0.0001, verbose = TRUE)

ICASNPs <- icafast(SNPs, 2)

# step 2
Z1 <- ROIs/sqrt(abs(ICAROIs$S[1]))
Z2 <- SNPs/sqrt(abs(ICASNPs$S[1]))


# step 3
X <- cbind(Z1,Z2)

# Step 4
ICAX <- fastICA(X, 3, alg.typ = "parallel", fun = "logcosh", alpha = 1,
                   method = "R", row.norm = FALSE, maxit = 200,
                   tol = 0.0001, verbose = TRUE)

ICAX <- icafast(X,3)
ICAX$vafs


# Step 5

fit0 <- lm(phenotype ~ 1)
fit1 <- lm(phenotype ~ ICAX$S[,1])
fit2 <- lm(phenotype ~ ICAX$S[,1]+ICAX$S[,2])
fit3 <- lm(phenotype ~ ICAX$S[,1]+ICAX$S[,2]+ICAX$S[,3])
AIC(fit0)
AIC(fit1)
AIC(fit2)
AIC(fit3)
anova(fit0, fit1, fit2, fit3)

af <- anova(fit3)
afss <- af$"Sum Sq"
print(cbind(af,PctExp=afss/sum(afss)*100))


## MFA method

datos.mfa <- data.frame(ROIs[,-1], SNPs)
res <- MFA(datos.mfa, ncp=3, group=c(14,1000), graph = FALSE)

basicfitMFA <- lm(phenotype ~ 1)
fit1MFA <- lm(phenotype ~ res$ind$contrib[,1])
fit2MFA <- lm(phenotype ~ res$ind$contrib[,1]+res$ind$contrib[,2])
fit3MFA <- lm(phenotype ~ res$ind$contrib[,1]+res$ind$contrib[,2]+res$ind$contrib[,3])
AIC(basicfitMFA)
AIC(fit1MFA)
AIC(fit2MFA)
AIC(fit3MFA)


anova(fit0, fit1MFA, fit2MFA, fit3MFA)

afMFA <- anova(fit3MFA)
afssMFA <- afMFA$"Sum Sq"
print(cbind(afMFA,PctExp=afssMFA/sum(afssMFA)*100))


## GLM

fitglm <- lm(phenotype ~ SNPs[,1]+SNPs[,2]+SNPs[,3])

afu <- anova(fitglm)
afssu <- afu$"Sum Sq"
print(cbind(afu,PctExp=afssu/sum(afssu)*100))


### gof functions

aic_MFA <- c(AIC(fit0), AIC(fit1MFA), AIC(fit2MFA), AIC(fit3MFA))
aic_IMFA <- c(AIC(fit0), AIC(fit1), AIC(fit2), AIC(fit3))


############
## Plots 
############

library(gridExtra)
library(reshape2)
library(ggplot2)


a <- data.frame(aic_MFA, aic_IMFA)
a <- data.frame(Model=c("0c-Naive_Model", "1c-Model", "2c-Model","3c-Model"), a)
colnames(a) <- c("Model",  "MFA", "IMFA")

mdf2 <- melt(a, id.vars="Model", value.name="AIC", variable.name="Method", ordered=TRUE)

plotaic <- ggplot(data=mdf2, aes(x=Model, y=AIC, group =Method , colour = Method)) +
  geom_point(aes(shape=Method), size=4, stroke=3)+scale_shape_manual(values=c(1,6,5)) + ggtitle("Akaike information criterion (AIC)")


p1 <- plotaic+theme(axis.text=element_text(size=12),
        axis.title=element_text(size=20,face="bold"), legend.title = element_text(size=20), legend.text = element_text(size = 18), plot.title = element_text(size = rel(2)))

# Save Figure:
png("gofIMFAICR-N1000-NS1000-Nc10.png")
p1
dev.off()

# Save data:
write.table(data.frame(phenotype), "simulated_phenotypeY_N=1000_NSNP=1000_Nc=10.txt", quote=F, row.names=F)
write.table(ROIs, "simulated_brain-structures_N=1000_NSNPs=1000_Nc=10.txt", quote=F, row.names=F)
write.table(SNPs, "simulated_genotypes_N=1000_NSNPs=1000_Nc=10.txt.txt", quote=F, row.names=F)

