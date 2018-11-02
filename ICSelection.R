
#################### ICs selection

# Compute log likelihood ratio representing the relative likelihood of a correlation between pairs of ICs

computeLogLAIC0 <- function(ICs1, ICs2) {
  m0 <- lm(ICs1 ~ 1)
  m1 <- lm(ICs1 ~ ICs2)
  return(c(AIC(m1)-AIC(m0)))
}

computeLogLAIC <- function(ICs1, ICs2, ICs3) {
  m0 <- lm(ICs1 ~ 1)
  m1 <- lm(ICs1 ~ ICs2)
  m2 <- lm(ICs1 ~ ICs3)
  return(AIC(m2)-AIC(m1))
}

selectAIC <- function(X,nc) {
  ICAX <- fastICA(X, nc, alg.typ = "parallel", fun = "logcosh", alpha = 1,
                  method = "R", row.norm = FALSE, maxit = 200,
                  tol = 0.0001, verbose = TRUE)
  ICs <- ICAX$S 
  aict <- computeLogLAIC0(ICs[,1], ICs[,2])
  for(i in 1:(nc-2)) {
    aict <- c(aict, computeLogLAIC(ICs[,i], ICs[,i+1], ICs[,i+2]))
  }
  return(mean(aict))
}

maci <- NULL
for(i in 3:25) maci[i-2] <- selectAIC(X,i)