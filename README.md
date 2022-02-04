Code for Dr. Bachi's K23 (https://labs.icahn.mssm.edu/bachilab/)

1. Weekly recruiment stats [weekly_report.py](https://github.com/tientong98/BachiK23/blob/main/weekly_report.py)
2. Download XNAT, then convert to BIDS using dcm2bids detailing in [bids_conversion.sh](https://github.com/tientong98/xnat_download/blob/main/bids_conversion.sh). This bash script also calls 2 python scripts:
   * [xnat_download.py](https://github.com/tientong98/BachiK23/blob/main/xnat_download.py): Download DICOM from XNAT
   * [modify_json.py](https://github.com/tientong98/BachiK23/blob/main/modify_json.py): Edit JSON file according to BIDS conventions
3. Running MRIQC and fMRIPrep locally using docker, steps detailed in [MRIQC_fMRIPrep.ipynb](https://github.com/tientong98/xnat_download/blob/main/MRIQC_fMRIPrep.ipynb)
4. Running MRIQC on Flywheel
    * Setting up Flywheel CLI: [Flywheel.ipynb](https://github.com/tientong98/xnat_download/blob/main/Flywheel.ipynb) 
    * Importing BIDS-formatted data to Flywheel, then run the MRIQC gear [flywheel_import_mriqc.sh]( https://github.com/tientong98/xnat_download/blob/main/flywheel_import_mriqc.sh)
5. [Exploratory test](https://github.com/tientong98/BachiK23/blob/main/r01_ml_GM-Git.ipynb) if brain volumes (Freesurfer T1w) and immune markers can be used to predict drug use and childhood trauma. 
6. [Resting State: Work in progress](https://github.com/tientong98/BachiK23/blob/main/restingState/rest_git.ipynb)
