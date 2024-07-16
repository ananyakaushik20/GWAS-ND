# GWAS For Neurodegenerative Disease

This directory contains demo data from the GenoML project at the Center for Alzheimer’s and Related Dementias (CARD) and Data Tecnica International LLC (DTI). This data is simulated data for Parkinson's disease case and control clinical-demographic datasets and Alzheimer’s disease publicly available summary statistics. 

### Packages used:
- PLINK
- GCTA

### The available input data includes: 

- Raw individual-level data including 342 Parkinson's disease cases + 158 controls:
training_raw.bed, training_raw.fam, training_raw.bim,
training_relatedness.bed, training_relatedness.fam, training_relatedness.bim,
training_chr23.bed, training_chr23.fam, training_chr23.bim

- Clean and imputed individual-level data including 348 Parkinson's disease cases + 158 controls to perform GWAS analyses:
training.bed, training.fam, training.bim

- Covariate file: training_covs.txt

- Clean and pruned individual-level data including 1000 Parkinson's disease cases + 1000 controls to perform PRS analyses. This data only includes the 90 risk loci associated with Parkinson's disease:
toPRS_training_Parkinson.bim, toPRS_training_Parkinson.fam, toPRS_training_Parkinson.bed

- Clean and pruned individual-level data including 1000 putative Alzheimer’s disease cases + 1000 putative controls to perform PRS analyses. This data only includes the 32 risk
loci associated with Alzheimer’s disease. These data will be used to explore a potential genetic correlation between both diseases AD and PD:
toPRS_training_Alzheimer.bim, toPRS_training_Alzheimer.fam, toPRS_training_Alzheimer.bed

- Score file for Parkinson's disease - SCORE_PD.txt
- Score file for Alzheimer’s disease- SCORE_AD.txt

### Inventory of scripts:

- Genotyping_QC.sh - Genotyping QC
- gwas.sh - GWAS analyses
- PRS.sh - PRS analyses
