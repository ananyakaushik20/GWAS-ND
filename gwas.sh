
## Code outline
#1.Running a GWAS in PLINK & Generating Summary Statistics
#2.Data Visualization: Manhattan Plot
#3.FUMA


#File inputs: 
#QC’d PLINK Binary Files containing cases and controls (.fam, .bim, .bed files), 
#QC’d Imputed PLINK Binary Files containing cases and controls (.fam, .bim, .bed files), 
#Covariates File containing the covariates you would like to correct by (more on this in section 1). This file at a minimum includes sample information (such as ID, SEX, PHENO) and principal components



## Running a GWAS in PLINK & Generating Summary Statistics

plink --bfile training \
--logistic hide-covar --ci 0.95 \
--covar training_covs.txt \
--covar-name AGE,GENDER,PC1,PC2,PC3,PC4,PC5,PC6,PC7,PC8,PC9,PC10 \
--out training.test

#The "hide-covar" option removes each individual test versus each covariate from the output

#check output
head training.test.assoc.logistic
"""CHR: Chromosome, SNP: single nucleotide polymorphism, BP: Base-pair, 
A1: effect allele that refers to the OR, 
TEST: type of test (by default is ADD -> additive which you do not assume any dominant or recessive effect), 
NMISS: Nonmissing genotype, 
OR: Odds ratio (magnitude of effect)"""


##generate some general summary statistics
plink --bfile training \
--assoc --out training_summarystats # Will generate a file with *.assoc suffix

# Let's head the output file!
head training_summarystats.assoc

"""CHR: Chromosome, SNP: single nucleotide polymorphism, BP: Base-pair, 
A1: effect allele that refers to the OR, 
F_A: Frequency of the effect allele in affected individuals, 
F_U: Frequency of the effect allele in unaffected individuals, 
CHISQ: Chi square, P: P value, OR: Odds ratio (magnitude of effect)."""

## 3. Data Visualization: Manhattan Plot
##Manhattan plot using bioinfokit abstracted from https://reneshbedre.github.io/

pip install bioinfokit ## pip = package management system in python
pip install bioinfokit --upgrade

## run python script to visualise the data
python3 script.py



