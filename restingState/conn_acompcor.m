function conn_acompcor(top_dir, sub_id)

% Follow instruction here -- https://www.nitrc.org/forum/message.php?msg_id=31395
% That will create a new covariate file named dp_*.txt containing those 10 aCompCor components. 
subjectDir = append(top_dir, sub_id);
conn_module('preprocessing',...
  'functionals', {glob(char(append(subjectDir, '/', '*space-native_desc-T1cmedn_bold.nii')))}, ...
  'masks', struct(...
      'White', {{glob(char(append(subjectDir, '/', '*c2*_T1w.nii')))}}, ...
      'CSF', {{glob(char(append(subjectDir, '/', '*c3*_T1w.nii')))}}), ...
  'steps', {'functional_regression'}, ...
  'reg_names', {'White Matter','CSF'}, ...
  'reg_dimensions',[5, 5], ...
  'reg_skip', true); 
  % Setup.preprocessing.reg_skip: (functional_regression) 1: does not create output functional files, only creates session-specific dp_*.txt files with covariate timeseries to be included later in an arbitrary first-level model [0]
end