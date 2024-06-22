# script.py
from bioinfokit import analys, visuz

# Get the default data 'mhat' from the module analys and make a dataframe
df = analys.get_data('mhat').data

# Display the first few rows of the dataframe
print(df.head())
# Note, an internal function maps the SNP ID to chromsome and base pair positions. 

visuz.marker.mhat(df=df, chr='chr',pv='pvalue', show=True) # plot chr on the X axis and -log10(p-value)on the Y axis that gets calculated automatically
visuz.marker.mhat(df=df, chr='chr',pv='pvalue', color=("#d7d1c9", "#696464"), gwas_sign_line=True, gwasp=5E-08, 
    markernames=True, markeridcol='SNP', gstyle=2, show=True)