Code for Dr. Bachi's K23 (https://labs.icahn.mssm.edu/bachilab/)

1. Download XNAT, then convert to BIDS using dcm2bids using [bids_conversion.sh](https://github.com/tientong98/xnat_download/blob/main/bids_conversion.sh)
2. Running MRIQC and fMRIPrep locally using [MRIQC_fMRIPrep.ipynb](https://github.com/tientong98/xnat_download/blob/main/MRIQC_fMRIPrep.ipynb)
3. Running MRIQC on Flywheel using [Flywheel.ipynb](https://github.com/tientong98/xnat_download/blob/main/Flywheel.ipynb) (for setting up Flywheel CLI); [flywheel_import_mriqc.sh]( https://github.com/tientong98/xnat_download/blob/main/flywheel_import_mriqc.sh) (for actually importing BIDS-formatted data then run MRIQC) 
