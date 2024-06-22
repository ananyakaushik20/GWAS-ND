#check input data
head training_raw.fam 
head training_raw.bim

#check for missing samples
plink --bfile training_raw --missing --out call_rates
head call_rates.lmiss
plink --bfile training_raw --mind 0.05 --make-bed --out training_raw_call_rate

#remove unnecessary files
rm call_rates.lmiss
rm call_rates.log
rm call_rates.nosex
mv call_rates.imiss CALL_RATES_ALL_SAMPLES.txt

#check gender of samples
head gender_check.sexcheck
grep "PROBLEM" gender_check.sexcheck > GENDER_FAILURES.txt
cut -f 1,2 GENDER_FAILURES.txt > samples_to_remove.txt
head samples_to_remove.txt

plink --bfile training_chr23 --remove samples_to_remove.txt --make-bed --out training_after_gender
rm gender_check.hh
rm gender_check.log

#calculate relatedness of samples
gcta64 --bfile training_relatedness --make-grm --out GRM_matrix --autosome --maf 0.05 
gcta64 --grm-cutoff 0.125 --grm GRM_matrix --out GRM_matrix_0125 --make-grm
plink --bfile training_relatedness --keep GRM_matrix_0125.grm.id --make-bed --out training_relatedness_pihat_0125

#extract ids
cut -f 1,2 training_relatedness.fam > IDs_before_relatedness_filter.txt ## All samples (related + unrelated individuals)
cut -f 1,2 training_relatedness_pihat_0125.fam > IDs_after_relatedness_filter.txt ## Only unrelated individuals (removing indvs related at a first-cousin level)
head IDs_after_relatedness_filter.txt

#extract related samples at first degree level 
plink --bfile training_relatedness --remove IDs_after_relatedness_filter.txt --make-bed --out training_related_individuals ## remove the unrelated samples
cut -f 1,2 training_related_individuals.fam > IDs_related.txt
head IDs_related.txt # Only related samples

#which samples are second-degree relatives? 
plink --bfile training_related_individuals --genome --min 0.25 --out PIHAT_second_degree
head PIHAT_second_degree.genome

#check relatedness/duplicates

gcta64 --bfile training_relatedness --make-grm --out GRM_matrix --autosome --maf 0.05 
gcta64 --grm-cutoff 0.8 --grm GRM_matrix --out GRM_matrix_08 --make-grm
plink --bfile training_relatedness --keep GRM_matrix_08.grm.id --make-bed --out training_relatedness_pihat_08


