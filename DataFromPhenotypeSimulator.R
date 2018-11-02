###############################################################
## Data from PhenotypeSimulator

tablevar = fread("/simulationsIMFA/phenotypes/test_simulation/varComponents_test_simulation.csv")
tablevar = data.frame(t(tablevar))
colnames(tablevar) = "varExpl"

SNPs = fread("/simulationsIMFA/genotypes/test_simulation/genotypes_test_simulation.csv")
SNPs = t(SNPs)
idSNPs = SNPs[1,]
SNPs = data.frame(SNPs)
colnames(SNPs) = idSNPs
SNPs = SNPs[-1,]
SNPs = apply(SNPs, 2, as.numeric)

ROIs = fread("/simulationsIMFA/phenotypes/test_simulation/Ysim_test_simulation.csv")
ROIs = data.frame(ROIs)
ROIs = ROIs[,-1]
ROIs = ROIs
rownames(ROIs) = rownames(SNPs)


phenotype = fread("/simulationsIMFA/phenotypes/test_simulation/Ysim_test_simulation.csv")
phenotype=phenotype[,-1]
phenotype = data.frame(phenotype)[,1]
names(phenotype) = rownames(SNPs)

###############################################################