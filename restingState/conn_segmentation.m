function conn_segmentation(top_dir, sub_id)
% Use spm segmentation to get WM and CSF masks, in preparation to run conn's acompcor
clear BATCH;
% BATCH.parallel.N = 4;
BATCH.Setup.nsubjects = 1;
BATCH.Setup.RT = 1.5;
BATCH.Setup.overwrite = 0;
subjectDir = append(top_dir, sub_id);
BATCH.Setup.functionals{1} = glob(char(append(subjectDir, '/', '*space-native_desc-T1cmedn_bold.nii')));
BATCH.Setup.structurals{1} = glob(char(append(subjectDir, '/', '*T1w.nii')));
BATCH.Setup.preprocessing.steps={'structural_segment'};
BATCH.Setup.done=0;
conn_batch(BATCH);
end
