
allsubjects = readtable('/Users/TienTong/Documents/dcm2bids/xnat_allsubjects.csv');
allsubjects(ismember(allsubjects.Var4,'sub-duplicate'),:)=[];
allsubjects(ismember(allsubjects.Var4,'sub-P19035'),:)=[];

for i = 1:68    
% conn_segmentation('/Volumes/BACHI-LAB/Team_Workspace/Tien/rest_meica/', string(allsubjects.Var4(i)))
conn_acompcor('/Volumes/BACHI-LAB/Team_Workspace/Tien/rest_meica/', string(allsubjects.Var4(i)))
end


function conn_segmentation(top_dir, sub_id)
% Use spm segmentation to get WM and CSF masks, in preparation to run conn's acompcor
clear BATCH;
% BATCH.parallel.N = 4;
BATCH.Setup.nsubjects = 1;
BATCH.Setup.RT = 1.5;
BATCH.Setup.overwrite = 0;
subjectDir = append(top_dir, sub_id);
BATCH.Setup.functionals{1} = glob(char(append(subjectDir, '/', '*T1cmedn_bold.nii')));
BATCH.Setup.structurals{1} = glob(char(append(subjectDir, '/', '*T1w.nii')));
BATCH.Setup.preprocessing.steps={'structural_segment'};
BATCH.Setup.done=0;
conn_batch(BATCH);
end

function conn_acompcor(top_dir, sub_id)

% Follow instruction here -- https://www.nitrc.org/forum/message.php?msg_id=31395
% That will create a new covariate file named dp_*.txt containing those 10 aCompCor components. 
subjectDir = append(top_dir, sub_id);
conn_module('preprocessing',...
  'functionals', {glob(char(append(subjectDir, '/', '*T1cmedn_bold.nii')))}, ...
  'masks', struct(...
      'White', {{glob(char(append(subjectDir, '/', '*c2*_T1w.nii')))}}, ...
      'CSF', {{glob(char(append(subjectDir, '/', '*c3*_T1w.nii')))}}), ...
  'steps', {'functional_regression'}, ...
  'reg_names', {'White Matter','CSF'}, ...
  'reg_dimensions',[5, 5], ...
  'reg_skip', true); 
  % Setup.preprocessing.reg_skip: (functional_regression) 1: does not create output functional files, only creates session-specific dp_*.txt files with covariate timeseries to be included later in an arbitrary first-level model [0]
end


