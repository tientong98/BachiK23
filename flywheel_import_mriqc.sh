#!/bin/bash
file=/Users/TienTong/Documents/dcm2bids/xnat_allsubjects.csv
subjects=(`awk -F "\"*,\"*" '{print $4}' $file | tr '\n' ' '`)

###############################################################################
####################### STEP 1: IMPORT DATA TO FLYWHEEL #######################
###############################################################################

# for i in {10..19} ; do
for i in 62 ; do
  fw import bids \
    --project K23 \
    --subject ${subjects[$i]} \
    /Users/TienTong/Documents/dcm2bids/BIDS/ \
    bachilab
done

###############################################################################
######################## STEP 2: RUN MRIQC ON FLYWHEEL ########################
###############################################################################
script_dir=/Users/TienTong/Documents/dcm2bids
# for i in {10..19} ; do
for i in 62 ; do
  $script_dir/flywheel_mriqc.py \
    --project_name K23 \
    --subject_id ${subjects[$i]} \
    --task rest
done
/Volumes/BACHI-LAB/MRI_DATA/FreeSurfer6_HAs_key
