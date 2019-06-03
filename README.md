# Independent Multiple Factor Association Analysis (ICA-MFA) for Multiblock Data in Imaging Genetics

## Abstract
Multivariate methods have the potential to better capture complex relationships that may exist between different biological levels.
Multiple Factor Analysis (MFA) is one of the most popular methods to obtain factor scores and measures of discrepancy between
data sets.However, singular value decomposition inMFAis based on PCA,which is adequate only if the data is normally distributed,
linear or stationary. In addition, including strongly correlated variables can overemphasize the contribution of the estimated components.
In this work, we introduced a novel method referred as Independent Multifactorial Analysis (ICA-MFA) to derive relevant
features from multiscale data. This method is an extended implementation of MFA, where the component value decomposition is
based on Independent Component Analysis. In addition, ICA-MFA incorporates a predictive step based on an Independent
Component Regression. We evaluated and compared the performance of ICA-MFA with both, the MFA method and traditional
univariate analyses, in a simulation study. We showed how ICA-MFA explained up to 10-fold more variance than MFA and
univariate methods. We applied the proposed algorithm in a study of 4057 individuals belonging to the population-based
Rotterdam Study with available genetic and neuroimaging data, as well as information about executive cognitive functioning.
Specifically, we used ICA-MFA to detect relevant genetic features related to structural brain regions, which in turn were involved,
in the mechanisms of executive cognitive function. The proposed strategy makes it possible to determine the degree to which the
whole set of genetic and/or neuroimaging markers contribute to the variability of the symptomatology jointly, rather than individually.
While univariate results and MFA combinations only explained a limited proportion of variance (less than 2%), our method
increased the explained variance (10%) and allowed the identification of significant components that maximize the variance
explained in the model. The potential application of the ICA-MFA algorithm constitutes an important aspect of integrating multivariate
multiscale data, specifically in the field of Neurogenetics.


**Reference:** Vilor-Tejedor N, Ikram MA, Roshchupkin GV, Cáceres A, Alemany S, Vernooij MW, Niessen WJ, van Duijn CM, Sunyer J, Adams HH, González JR. *Independent Multiple Factor Association Analysis for Multiblock Data in Imaging Genetics*. **Neuroinformatics. 2019 Mar 22.** doi: 10.1007/s12021-019-09416-z. [Epub ahead of print] PubMed PMID: 30903541.

---

Last Update: 2019-06-03

Author: N. Vilor-Tejedor <natalia.vilortejedor@crg.eu>
Code Maintainer: N. Vilor-Tejedor <natalia.vilortejedor@crg.eu>
