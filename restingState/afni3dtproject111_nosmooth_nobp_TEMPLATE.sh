#!/bin/bash

meica_dir=/Volumes/BACHI-LAB/Team_Workspace/Tien/rest_meica
outdir=/Volumes/BACHI-LAB/Team_Workspace/Tien/rest_1stlevel/afni3dtproject111_nosmooth_nobp

meica_dir_sub=${meica_dir}/SUBJECT
outdir_sub=${outdir}/SUBJECT
func_resample_111=${meica_dir_sub}/SUBJECT_task-rest_space-MNIN27111_desc-T1cmedn_bold.nii
confound=${meica_dir_sub}/dp_SUBJECT_acompcor.txt

if [ -f ${func_resample_111} ] ; then
  [ ! -d ${outdir_sub} ] && mkdir -p ${outdir_sub}
  ###### Regression and temporal filtering ###########################
  3dTstat -mean -prefix ${outdir_sub}/orig_mean.nii.gz ${func_resample_111}
  # 3dAutomask -prefix ${outdir_sub}/mask.nii.gz ${outdir_sub}/orig_mean.nii.gz
  fslmaths ${outdir_sub}/orig_mean.nii.gz -bin  ${outdir_sub}/mask.nii.gz

  echo `date`": Start regression and temporal filter for SUBJECT"
  3dTproject                                  \
     -input ${func_resample_111}              \
     -prefix ${outdir_sub}/temp_reg_bp.nii.gz \
     -mask ${outdir_sub}/mask.nii.gz          \
     -ort ${confound}                         \
     -verb -dt 1.5
  # add -blur 6 to smooth

  # add mean back in more details in the links below
  # https://github.com/HBClab/RestingState/issues/111
  # https://afni.nimh.nih.gov/afni/community/board/read.php?1,84353,84356
  3dcalc                                         \
     -a ${outdir_sub}/temp_reg_bp.nii.gz         \
     -b ${outdir_sub}/orig_mean.nii.gz           \
     -expr "a+b"                                 \
     -prefix ${outdir_sub}/final_reg_bp.nii.gz

  ###### Post-regression normalization and scaling ###########################
  fslmaths ${outdir_sub}/mask.nii.gz -mul 1000 ${outdir_sub}/mask1000.nii.gz -odt float

  # normalize
  echo `date`": Start normalizing and scaling for SUBJECT"
  input_to_norm=${outdir_sub}/final_reg_bp.nii.gz

  fslmaths ${input_to_norm} -Tmean ${outdir_sub}/res4d_tmean
  fslmaths ${input_to_norm} -Tstd ${outdir_sub}/res4d_std
  fslmaths ${input_to_norm} -sub ${outdir_sub}/res4d_tmean ${outdir_sub}/res4d_dmean
  fslmaths ${outdir_sub}/res4d_dmean -div ${outdir_sub}/res4d_std ${outdir_sub}/res4d_normed
  fslmaths \
     ${outdir_sub}/res4d_normed \
     -add ${outdir_sub}/mask1000.nii.gz \
     ${outdir_sub}/res4d_normed_scaled \
     -odt float

   echo `date`": Finish denoising for SUBJECT"

  # 44 social brain regions created from ~/Documents/rest/code/social_3dundump
  3dNetCorr                                                                             \
    -inset ${outdir_sub}/res4d_normed_scaled.nii.gz                                    \
    -in_rois ~/Documents/rest/code/socialbrain/socialbrain_separatemidline_111.nii.gz   \
    -fish_z                                                                             \
    -prefix ${outdir_sub}/SUBJECT_social
fi
