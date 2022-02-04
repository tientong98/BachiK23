#!/bin/bash

bachi=/Volumes/BACHI-LAB
indir=${bachi}/MRI_DATA/BIDS
outdir_raw=${bachi}/Team_Workspace/Tien/rest_raw_motion

input_arr=($(ls ${indir}/SUBJECT/func/SUBJECT_task-rest*bold.nii.gz | grep -v 'echo'))
for i in ${!input_arr[@]} ; do
    nvols=`fslnvols ${input_arr[$i]}`
    [[ "$nvols" -eq 400 ]] && input=${input_arr[$i]}
done

outliers=${outdir_raw}/SUBJECT_raw_outliers.txt
fd=${outdir_raw}/SUBJECT_raw_fd.txt
sixmp=${outdir_raw}/SUBJECT_raw_sixmp.txt

# roll pitch yaw dS  dL  dP
fsl_motion_outliers \
  -i ${input} \
  -o ${outliers} \
  -s ${fd} \
  --fd

3dvolreg -prefix NULL -1Dfile ${sixmp} ${input}
