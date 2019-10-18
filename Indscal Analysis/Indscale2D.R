rm(list=ls())
setwd("C:\\Users\\c3130234\\Desktop\\MDS Analysis Paper\\Analysis\\Indscal Analysis")

library(R.matlab)
library(multiway)

ENG = R.matlab::readMat("UnbiasMDS_ENG.mat")$Cmatrix
DOT = R.matlab::readMat("UnbiasMDS_DOT.mat")$Cmatrix
CHN = R.matlab::readMat("UnbiasMDS_CHN.mat")$Cmatrix
THI = R.matlab::readMat("UnbiasMDS_THI.mat")$Cmatrix

# Generate Unconstrained MDS (model B)
ENGmds = multiway::indscal(ENG, 2)$B
DOTmds = multiway::indscal(DOT, 2)$B
CHNmds = multiway::indscal(CHN, 2)$B
THImds = multiway::indscal(THI, 2)$B

#write.csv(ENGmds, file = "Rdata_ENGindscal.csv")
#write.csv(DOTmds, file = "Rdata_DOTindscal.csv")
#write.csv(CHNmds, file = "Rdata_CHNindscal.csv")
#write.csv(THImds, file = "Rdata_THIindscal.csv")

ENGmdsALL = multiway::indscal(ENG, 2)
DOTmdsALL = multiway::indscal(DOT, 2)
CHNmdsALL = multiway::indscal(CHN, 2)
THImdsALL = multiway::indscal(THI, 2)