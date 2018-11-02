# Calculating contributions from ICA-MFA
library(mixOmics)
ICAX <- ipca(X, 3)

W = ICAX$unmixing
vals = apply(abs(W),1,sum)
vect = ICAX$loadings$X
contrib = data.frame(abs(100*vals*vect))
contrib= data.frame(names=rownames(contrib), contrib)
contrib$group = c(rep("Neuroimaging", 38), rep("Genetics",9))
theo_contrib <- 100/length(contrib$IPC1)

# Plots

contrib1 = contrib[order(contrib$IPC1, decreasing=TRUE),]
contrib1 = contrib1[1:15,]
colors = c("gold2", "dodgerblue2")
p1 <- ggpubr::ggbarplot(contrib1, x = "names", y = "IPC1", fill = "group", 
                       color = "white", sort.val = "desc", top = Inf, main = "", 
                       xlab = FALSE, ylab = "Contributions (%)", xtickslab.rt = 65, 
                       ggtheme = theme_minimal(), sort.by.groups = FALSE) + scale_fill_manual(values=colors) + geom_hline(yintercept = 100/length(contrib$IPC1), 
                                                                                                                          linetype = 2, color = "red")



contrib2 = contrib[order(contrib$IPC2, decreasing=TRUE),]
contrib2 = contrib2[1:15,]
colors = c("dodgerblue2","gold2")
p2 <- ggpubr::ggbarplot(contrib2, x = "names", y = "IPC2", fill = "group", color="white",
                        sort.val = "desc", top = Inf, main = "", 
                        xlab = FALSE, ylab = "Contributions (%)", xtickslab.rt = 65, 
                        ggtheme = theme_minimal(), sort.by.groups = FALSE) + scale_fill_manual(values=colors) + geom_hline(yintercept = 100/length(contrib$IPC2), 
                                                                                                                           linetype = 2, color = "red")

contrib3 = contrib[order(contrib$IPC3, decreasing=TRUE),]
contrib3 = contrib3[1:15,]
colors = c("dodgerblue2", "gold2")
p3 <- ggpubr::ggbarplot(contrib3, x = "names", y = "IPC3", fill = "group", 
                        color = "white", sort.val = "desc", top = Inf, main = "", 
                        xlab = FALSE, ylab = "Contributions (%)", xtickslab.rt = 65, 
                        ggtheme = theme_minimal(), sort.by.groups = FALSE) + scale_fill_manual(values=colors) + geom_hline(yintercept = 100/length(contrib$IPC3), 
                                                                                                                           linetype = 2, color = "red")

pdf("poc_contr_Dim1-IMFA.pdf")
p1
dev.off()

pdf("poc_contr_Dim2-IMFA.pdf")
p2
dev.off()

pdf("poc_contr_Dim3-IMFA.pdf")
p3
dev.off()
