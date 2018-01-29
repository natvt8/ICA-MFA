source("https://bioconductor.org/biocLite.R")
biocLite("snpStats")
install.packages("PhenotypeSimulator")
library("PhenotypeSimulator")

# Set genetic and brain structure models
modelGenetic <-  "geneticFixed" # fixed genetic effects
modelStructures <- "noiseFixedAndBgAndCorrelated" # fixed effect of brain structures

# Set sample size and NrSNPs

n = 1000
NrSNP = 1000
NcSNP = 10
nPhenos = 1

## Simulate nrSNP bi-allelic SNP genotypes for N samples with randomly drawn 
# allele frequencies of 0.05, 0.1, 0.3 and 0.4.
 
genotypes <- simulateGenotypes(N = n, NrSNP = NrSNP, 
                               frequencies = c(0.05, 0.1, 0.3,0.4), 
                               verbose = FALSE)

# draw 10 causal SNPs from the genotype matrix (use non-standardised allele codes i.e. (0,1,2))
causalSNPs <- getCausalSNPs(NrCausalSNPs = NcSNP, genotypes = genotypes, 
                            standardise = FALSE)

# Create genetic fixed effects
fixedGenetic <- geneticFixedEffects(X_causal = causalSNPs, N = n, P = nPhenos, 
                                    pIndependentGenetic = 1, 
                                    pTraitIndependentGenetic = 1)

# Mean and sd values.
# Extracted from Front Neurosci. 2015; 9:379
# A comparison of FreeSurfer-generated data with and without manual intervention
# Christopher S. McCarthy et al., 

mConfounders = c(2.56,2.72,2.05,3.58,2.85, 2.65, 2.93, 2.47, 2.31, 2.67, 2.16, 2.56, 3.06, 2.73, 2.54)
sdConfounders = c(0.16, 0.11, 0.11, 0.32, 0.13, 0.12, 0.16, 0.14, 0.10, 0.11, 0.12, 0.10, 0.14, 0.26, 0.11)

# Simulate 14 fixed brain structure effects:
# Normally distributed 
StructuresFixed <- noiseFixedEffects(N = n, P = nPhenos, NrFixedEffects = length(mConfounders), 
                                pIndependentConfounders = 0.5,  
                                distConfounders = "norm",
					  mConfounders = mConfounders, sdConfounders = sdConfounders)


# simulate random brain structure effects
StructuresBg <- noiseBgEffects(N = n, P = nPhenos)

# simulate correlated brain structure effects with max correlation of 0.2
correlatedBrain <- correlatedBgEffects(N = n, P = nPhenos, pcorr = 0.2)


# total effect on phenotype
totalGeneticVar <- 0.4
totalSNPeffect <- 0.01
h2s <- totalSNPeffect/totalGeneticVar

# Combine components into final phenotype with genetic variance component explaining 40% of total variance

# Additional parameters: (following the vignette from PhenotypeSimulator):
# Proportion of fixed nbrain structure variance (delta): 0.3
delta = 0.3
# Proportion of variance of shared fixed noise effects (gamma): 1
gamma = 1
# Proportion of random noise variance (phi): 0.2
phi = 0.2
# Proportion of variance of shared fixed genetic effects (theta): 0
theta = 0

phenotype <- createPheno(N = n, P = nPhenos, noiseBg = StructuresBg, 
                         noiseFixed = StructuresFixed,  
                         genFixed = fixedGenetic, modelNoise = modelStructures, modelGenetic = modelGenetic, 
                         genVar = totalGeneticVar, correlatedBg = correlatedBrain, h2s = h2s, 
                         phi = phi, delta = delta, gamma = gamma, theta=theta, verbose = FALSE)


out <- savePheno(phenotype, directoryGeno="simulationIMFA/genotypes",  
                 directoryPheno="simulationIMFA/phenotypes", outstring="test_simulation",
                 saveAsTable=TRUE, saveAsPlink=TRUE, verbose=FALSE)
