%% Check against arm canteleiver calibrations

repoDir = 'C:\Users\Ian\Documents\GitHub\';

in = load(fullfile(repoDir,'xflow-daq\processing\implementations\10m_Spanish_Fork_testing\Calibrations\Results\cal_struct_15_11_24.mat'));

cal = in.cal;

% load in the tare file
% make sure to exclude the files in the tare file from the analysis
% load in the files, apply tares and cals
% compare to the appropriate loadMat vlaues in the cal struct


X:\Experiments and Data\20 kW Prototype\Loads_Data\load_calibrations\lower_arm\Lower_arm_+Mx