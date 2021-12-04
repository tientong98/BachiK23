#!/bin/bash
file=/Users/TienTong/Documents/dcm2bids/xnat_allsubjects.csv
subjects=(`awk -F "\"*,\"*" '{print $4}' $file | tr '\n' ' '`)
script_dir=/Users/TienTong/Documents/dcm2bids

# for i in {0..70} ; do
for i in 62 ; do
  ####################### STEP 1: IMPORT DATA TO FLYWHEEL ######################
  # fw import bids \
  #     --project K23 \
  #     --subject ${subjects[$i]} \
  #     /Volumes/BACHI-LAB/MRI_DATA/BIDS \
  #     bachilab
  ####################### STEP 2: RUN MRIQC ON FLYWHEEL #######################
  # $script_dir/flywheel_mriqc.py \
  #     --project_name K23 \
  #     --subject_id ${subjects[$i]} \
  #     --modality anat
  $script_dir/flywheel_mriqc.py \
      --project_name K23 \
      --subject_id ${subjects[$i]} \
      --modality func \
      --task rest
  # $script_dir/flywheel_mriqc.py \
  #     --project_name K23 \
  #     --subject_id ${subjects[$i]} \
  #     --modality func \
  #     --task whyhow
  # $script_dir/flywheel_mriqc.py \
  #     --project_name K23 \
  #     --subject_id ${subjects[$i]} \
  #     --modality func \
  #     --task socialnav
done
