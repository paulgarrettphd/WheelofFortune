Analysis Scipt Read Me
Paul Garrett
05-03-2019

Note: All scripts will call functions, located in \\WheelofFortune\\Functions\

Scripts for the English Cohort's Analysis of the Symbolic Wheel Task. 
Data Loading, Cleaning and Sorting are handled by:
 - s_LoadDataScript.m (rapid loading of data into multi-D matrices)
 - s_VariableDataLoad.m (rapid cleaning and variable loading for analyses)
 - s_DataOrganization.m (organise data into structures and multi-D matrices)
 - s_Dots2Mat.m (convert images to mat files)

Scipts for Plotting Results
 - s_AccFigures (Accuracy and staircase analysis)
 - s_IndscalPlots (Take R output of group MDS inscal analyses; plot as MDS and heatmaps)
 - s_JASPcsvFiles (CSV file generator for honors baysian analysis)

Resulting figures are located in WheelofFortune\\English\\Figures\