clear all


% Get path where the calibration struct should be saved
fullFileName = mfilename('fullpath');
[currentPath, ~, ~] = fileparts(fullFileName);
path = fullfile(currentPath,'Results');

% Cal structs to combine
cal_names = {'guy_wire_cal_struct',...
    'lower_arm_cal_multi_axis_struct',...
    'upper_arm_cal_multi_axis_struct',...
    'upper_arm_cal_split_multi_axis_struct',...
    'blade_bending_cal_single_axis_struct',...
    'met_tower_cal_struct'};

% Make the calibration struct which will be used for data processing
make_cal_struct(path,cal_names)