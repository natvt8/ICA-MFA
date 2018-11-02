## Plots :

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


tt <- data.frame(bic_MFA, bic_IMFA)
tt <- data.frame(Model=c("0c-Naive_Model", "1c-Model", "2c-Model","3c-Model"), tt)
colnames(tt) <- c("Model",  "MFA", "IMFA")

mdf3 <- melt(tt, id.vars="Model", value.name="BIC", variable.name="Method", ordered=TRUE)

plotbic <- ggplot(data=mdf3, aes(x=Model, y=BIC, group =Method , colour = Method)) +
  geom_point(aes(shape=Method), size=4, stroke=3)+scale_shape_manual(values=c(1,6,5)) + ggtitle("Bayesian information criterion (BIC)")

p2<-plotbic +theme(axis.text=element_text(size=12),
                   axis.title=element_text(size=20,face="bold"), legend.title = element_text(size=18), legend.text = element_text(size = 18), plot.title = element_text(size = rel(2)))



png("gofIMFAICR-N1000-NS1000-Nc10.png")
grid.arrange(p1,p2, nrow=2)
dev.off()
