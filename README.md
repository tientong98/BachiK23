Code for Dr. Bachi's K23 (https://labs.icahn.mssm.edu/bachilab/)

1. Download XNAT, then convert to BIDS using dcm2bids detailing in [bids_conversion.sh](https://github.com/tientong98/xnat_download/blob/main/bids_conversion.sh)
2. Running MRIQC and fMRIPrep locally using docker, steps detailed in [MRIQC_fMRIPrep.ipynb](https://github.com/tientong98/xnat_download/blob/main/MRIQC_fMRIPrep.ipynb)
3. Running MRIQC on Flywheel
    * Setting up Flywheel CLI: [Flywheel.ipynb](https://github.com/tientong98/xnat_download/blob/main/Flywheel.ipynb) 
    * Importing BIDS-formatted data to Flywheel, then run the MRIQC gear [flywheel_import_mriqc.sh]( https://github.com/tientong98/xnat_download/blob/main/flywheel_import_mriqc.sh)
