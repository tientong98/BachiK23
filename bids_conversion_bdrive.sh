#!/bin/bash

###############################################################################
####################### STEP 1: DOWNLOAD XNAT DICOM DATA ######################
###############################################################################

# CHANGE THE NEXT TWO LINES
range_subject="62" # "0-1" will download the first 2 subjects
num_subject=1 # CHANGE THIS

echo "Start downloading XNAT data for" $num_subject "participant(s)"

script_dir=/Users/TienTong/Documents/dcm2bids
$script_dir/xnat_download.py \
  --range_subject $range_subject \
  --username `sed -n 1p $script_dir/credentials.txt` \
  --password `sed -n 2p $script_dir/credentials.txt` \
  --download_dir /Volumes/BACHI-LAB/MRI_DATA/DICOM

###############################################################################
################### STEP 2: CONVERT TO NIFTY AND PUT IN BIDS ##################
###############################################################################
export DICOM="/Volumes/BACHI-LAB/MRI_DATA/DICOM"
export BIDS="/Volumes/BACHI-LAB/MRI_DATA/BIDS"
script_dir=/Users/TienTong/Documents/dcm2bids

new_download=($(ls -d "$DICOM"/*))
for i in ${!new_download[@]} ; do
    subject_id=`echo ${new_download[$i]} | awk -F "_" '{print $NF}'`
    mv ${new_download[$i]} "$DICOM"/${subject_id}
    rm -rf "$BIDS"/tmp_dcm2bids
    ################### STEP 2.1a: CONVERT TO NIFTY AND PUT IN BIDS ############
    echo "Start doing BIDS conversion for subject" ${subject_id}
    dcm2bids \
      -d "$DICOM"/${subject_id}/*/scans \
      -p ${subject_id} \
      -c /Users/TienTong/Documents/dcm2bids/dcm2bids_config.json \
      -o "$BIDS" \
      --clobber --forceDcm2niix

    # need to add task name to .json file. eg: "TaskName": "${task}"
    # need to add IntendedFor for fmap

    ######################## STEP 2.1b: RENAME FILES ###########################
    # run and echo were flipped using dcm2bids, have to switch them back
    subject_func="$BIDS"/sub-${subject_id}/func

    for task in rest whyhow ; do
      task_list=($(ls $subject_func/*${task}*bold.nii.gz))
      run_num=$((${#task_list[@]} / 3))
      if [ $run_num -gt 1 ] ; then
      for run in `seq -s " " -f "%02g" $run_num` ; do
        for echo in 01 02 03 ; do
          for type in bold sbref ; do
            for extension in json nii.gz ; do
              old=$subject_func/sub-${subject_id}_task-${task}_echo-${echo}_run-${run}_${type}.${extension}
              new=$subject_func/sub-${subject_id}_task-${task}_run-${run}_echo-${echo}_${type}.${extension}
              mv $old $new
            done
          done
        done
      done
      fi
    done

    echo "BIDS conversion completed for subject" ${subject_id}

    ################### STEP 2.2: RUN OPTIMAL COMBINATION #####################
    for task in rest whyhow ; do
      task_list=($(ls $subject_func/*${task}*bold.nii.gz))
      run_num=$((${#task_list[@]} / 3))
      echo "Start the tedana optimal combination for" $run_num "run(s) of the" ${task} "task of subject" ${subject_id}

      if [ $run_num -gt 1 ] ; then
        for run in `seq -s " " -f "%02g" $run_num` ; do
          input=(`ls $subject_func/*${task}*run-${run}*bold.nii.gz`)
          t2smap \
            -d ${input[@]} \
            -e 10.80 28.68 46.56 \
            --out-dir $subject_func
          rm $subject_func/*S0map* $subject_func/*T2starmap*
          mv $subject_func/desc-optcom_bold.nii.gz $subject_func/sub-${subject_id}_task-${task}_run-${run}_bold.nii.gz
          cp $subject_func/sub-${subject_id}_task-${task}_run-${run}*echo-01*_bold.json $subject_func/sub-${subject_id}_task-${task}_run-${run}_bold.json
        done
      else
        input=(`ls $subject_func/*${task}*bold.nii.gz`)
        t2smap \
          -d ${input[@]} \
          -e 10.80 28.68 46.56 \
          --out-dir $subject_func
        rm $subject_func/*S0map* $subject_func/*T2starmap*
        mv $subject_func/desc-optcom_bold.nii.gz $subject_func/sub-${subject_id}_task-${task}_bold.nii.gz
        cp $subject_func/sub-${subject_id}_task-${task}*echo-01*_bold.json $subject_func/sub-${subject_id}_task-${task}_bold.json

      fi
      # need to delete echo time of the optimally combined bold
    done

    ###############################################################################
    ############################ STEP 3: MODIFY JSON FILES ########################
    ###############################################################################

    # need to add task name to .json file. eg: "TaskName": "${task}"
    # need to add IntendedFor for fmap
    # need to delete echo time of the optimally combined bold

    $script_dir/modify_json.py \
      --subject ${subject_id} \
      --bids_path "$BIDS"

done
