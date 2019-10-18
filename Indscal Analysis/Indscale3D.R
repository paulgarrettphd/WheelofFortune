rm(list=ls())
setwd("C:\\Users\\c3130234\\Desktop\\MDS Analysis Paper\\Analysis\\Indscal Analysis")

library(R.matlab)
library(multiway)

ENG = R.matlab::readMat("UnbiasMDS_3D_ENG.mat")$Cmatrix
CHN = R.matlab::readMat("UnbiasMDS_3D_CHN.mat")$Cmatrix
THI = R.matlab::readMat("UnbiasMDS_3D_THI.mat")$Cmatrix

# Generate Unconstrained MDS (model B)
ENGmds = multiway::indscal(ENG, 3)$B
CHNmds = multiway::indscal(CHN, 3)$B
THImds = multiway::indscal(THI, 3)$B

write.csv(ENGmds, file = "Rdata_3D_ENGindscal.csv")
#write.csv(DOTmds, file = "Rdata_3D_DOTindscal.csv")
write.csv(CHNmds, file = "Rdata_3D_CHNindscal.csv")
write.csv(THImds, file = "Rdata_3D_THIindscal.csv")

#ENGmdsALL = multiway::indscal(ENG, 2)
#CHNmdsALL = multiway::indscal(CHN, 2)
#THImdsALL = multiway::indscal(THI, 2)