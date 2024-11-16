clear all
close all
clc

%% Initialize
count_single = 0;
count_multi = 0;
consts = XFlow_Spanish_Fork_testing_constants();

%% Constants
data_path = 'X:\Experiments and Data\20 kW Prototype\Loads_Data\load_calibrations\';
data_folder = 'rotor_segment';
makePlots = 1;
savePath = fullfile(fileparts(mfilename('fullpath')),'Results');
saveName_single = 'blade_bending_cal_single_axis_struct';
saveName_multi = 'blade_bending_cal_multi_axis_struct';
tdmsPrefix = 'full_hub_test_rotorStrain';

%% Blade bending
% Upper
count_single = count_single + 1;
[calib,crosstalk] = calibration_matrix_inputs__blade_upper_Mx(consts);
cal_single(count_single) = build_crosstalk_matrix(crosstalk,calib,data_path,data_folder,tdmsPrefix,makePlots,savePath);

% Center 
count_single = count_single + 1;
[calib,crosstalk] = calibration_matrix_inputs__blade_center_Mx(consts);
cal_single(count_single) = build_crosstalk_matrix(crosstalk,calib,data_path,data_folder,tdmsPrefix,makePlots,savePath);

% Lower
count_single = count_single + 1;
[calib,crosstalk] = calibration_matrix_inputs__blade_lower_Mx(consts);
cal_single(count_single) = build_crosstalk_matrix(crosstalk,calib,data_path,data_folder,tdmsPrefix,makePlots,savePath);

% Blade bending all
count_multi = count_multi + 1;
[calib,crosstalk] = calibration_matrix_inputs__blade_bending(consts);
cal_multi(count_multi) = build_crosstalk_matrix(crosstalk,calib,data_path,data_folder,tdmsPrefix,makePlots,savePath);
disp('Blade bending Crosstalk Matrix = ')
fprintf('%.2f   \t%.2f   \t%.2f\n',cal_multi(count_multi).data.k)
fprintf('Diagonals, computed individualy =\n')
fprintf('%.2f   \t%.2f   \t%.2f\n',[cal_single(count_single-2).data.k,0,0;...
    0,cal_single(count_single-1).data.k,0;...
    0,0,cal_single(count_single).data.k])
fprintf('\n\n')

for i = 1:length(cal_single)
    cal_single(i).stage = 'afterResample';
end

for i = 1:length(cal_multi)
    cal_multi(i).stage = 'afterResample';
end
%% Save
save(fullfile(savePath,saveName_single),'cal_single')
save(fullfile(savePath,saveName_multi),'cal_multi')

