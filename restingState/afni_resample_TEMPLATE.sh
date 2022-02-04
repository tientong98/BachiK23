#!/bin/bash

template=/Users/TienTong/abin/MNI_caez_N27.nii.gz
meica_dir=/Volumes/BACHI-LAB/Team_Workspace/Tien/rest_meica

meica_dir_sub=${meica_dir}/SUBJECT
# func_oldname=${meica_dir_sub}/SUBJECT_task-rest_space-MNI1522009_desc-T1cmedn_bold.nii
func_newname=${meica_dir_sub}/SUBJECT_task-rest_space-MNIN27_desc-T1cmedn_bold.nii
func_resample_111=${meica_dir_sub}/SUBJECT_task-rest_space-MNIN27111_desc-T1cmedn_bold.nii
func_resample_333=${meica_dir_sub}/SUBJECT_task-rest_space-MNIN27333_desc-T1cmedn_bold.nii

if [ -f ${func_oldname} ] ; then
  # mv ${func_oldname} ${func_newname}

  3dresample                     \
    -master ${template}          \
    -prefix ${func_resample_111} \
    -input ${func_newname}

  3dresample                     \
    -master ${template}          \
    -prefix ${func_resample_333} \
    -input ${func_newname}       \
    -dxyz 3.0 3.0 3.0
fi
