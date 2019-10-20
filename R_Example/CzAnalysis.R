# Paul Garrett
# 16/10/2019
# Purpose.
# - Read in experimental files from Cheng Ta & Pei-Yi, Taiwan.
# - Subset and Clean Data by:
#   LanguageType (Chinese, English), 
#   WordType (Word, Pseudo, NonWord), & 
#   Stopping Rule (AND vs OR)
# - Using Houpt (2012) SFT package, calculate Capacity Coefficient Cz scores and summary stats
# - Plot Cz Values for easy comparison between conditions and languages using Colorblind colors

rm(list = ls())
library(sft)
library(ggplot2)
library(reshape2)
library(ggpubr)

# Load Data
setwd("C:\\Users\\c3130234\\Desktop\\Visual word_To Paul\\PaulAnalysis")
d <- read.table("Rcapacitydata.csv", header = TRUE, sep = ",")

# Subjects
S = length(unique(d$Subject))
# Trial Type Numbers
TType = rbind(c(1,5,6),c(4,7,8))
# Stopping rule
Rules = c('AND', 'OR')

# Preallocate
pArray  = array(NaN, c(S, 3, 2, 2))
CzArray = array(NaN, c(S, 3, 2, 2))


# Lang. 0 = Eng, 1 = Chn
for ( lang in 0:1 ) {
  # Word Type. 1 = word, 2 = pseudo, 3 = non-word
  for ( Wordtype in 1:3) {
    # Trial Type = 1 same all, 5 & 6 same part; 4 diff all, 7 & 8 diff part.
    for ( Tt in 1:2 ) {
      
      # Subset Data by Conditional Factors
      D = d[(d$TrialType == TType[Tt,1] | d$TrialType == TType[Tt,2] | d$TrialType == TType[Tt,3]) & 
              d$Chinese == lang & d$WordType == Wordtype & 
              d$Correct == 1 & d$RT > 150 & d$RT < 1500, ]
      
      # Cz analysis - no plots
      Results = capacityGroup(D, acc.cutoff=.8, ratio=TRUE,stopping.rule=Rules[Tt], plotCt=FALSE)
      
      for (sub in 1:S ) { 
        
        # Generate 4D Array of Cz Values and Associated Sig Values
        # Row = SubNumber; 
        # Col = WordType (Word, Pseudo, Nonword); 
        # 3Dim = TrialType (AND vs OR); 
        # 4Dim = LanguageType (English, Chinese)
        
        CzArray[sub,Wordtype,Tt,lang+1] = Results[["capacity"]][[sub]][["Ctest"]][["statistic"]][[1]]
        pArray[sub,Wordtype,Tt,lang+1]  = Results[["capacity"]][[sub]][["Ctest"]][["p.value"]][1]
        
      }
    }
  }
}

# Quick Summary Stats
CzMeans = melt(apply(CzArray, c(2,3,4), mean), varnames=c('WordType','StoppingRule','Language','CzM'))
CzStd   = melt(apply(CzArray, c(2,3,4), sd),   varnames=c('WordType','StoppingRule','Language','CzSD'))



# Organize Data for Plotting
CzTable = melt(CzArray, varnames=c('Subject','WordType','StoppingRule','Language'), value.name = 'Cz')
CzTable[1:4] <- lapply(CzTable[1:4], factor)



# Set Plot Specifications
MyTheme = theme(plot.title = element_text(face = "bold", hjust = 0.5, size = 16), 
            axis.title = element_text(face = 'bold', size = 14),
            axis.text  = element_text(face = 'bold', size=12), 
            legend.position = 'none')

# Set colors and limits
Alpha = .5
Ymax = 6
Ymin = -10

# Object to hold subplots
Plts = list()
Count = 0
Titles = list('English AND','English OR','Chinese AND','Chinese OR')

# Loop for Languages and Stopping Rules
for ( lang in 1:2 ){
  for ( SR in 1:2 ) {
    
    # Iterate for each subplot in object
    Count = Count + 1
    
    # Save each subplot to Plots object with modified theme
    Plts[[Count]] = ggplot(CzTable[CzTable$Language==lang & CzTable$StoppingRule==SR, c(1,2,5)],
      aes(x=WordType,y=Cz, fill=WordType, alpha=Alpha)) +
      # Violin Plot
      geom_violin(trim=FALSE, color = NA) +
      # Set theme
      theme_classic() +
      MyTheme +
      # Set titles
      labs(title = Titles[[Count]], x = "Word Type", y = "Cz") +
      # Set limits
      ylim(Ymin, Ymax) +
      # Set Labels
      scale_x_discrete(breaks=c("1","2","3"), labels=c("Word","Pseudo","NonWord")) +
      # Make color blind scheme
      scale_fill_manual(values=c("#1E88E5", "#FFC107", "#D81B60"))
  }
}

# Display in new window
windows(); ggarrange(Plts[[1]], Plts[[2]], Plts[[3]], Plts[[4]],
           labels = c("A",'B',"C", "D"),
           ncol = 2, nrow = 2)




