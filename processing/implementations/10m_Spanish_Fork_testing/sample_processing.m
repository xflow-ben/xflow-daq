clear all
close all
clc

%% Assign data folder
dataDir = 'E:\loads_data\load_calibrations\lower_arm\Lower_arm_+Mx';%'E:\loads_data\load_calibrations\guy_wire_tension\Lower_GW_E';

%% Load calibration struct
load('C:\Users\XFlow Energy\Documents\GitHub\xflow-daq\processing\implementations\10m_Spanish_Fork_testing\Calibrations\Results\cal_struct_05_09_24.mat')

%% Load constants
consts = XFlow_Spanish_Fork_testing_constants();

%% Process data folder
name_conventions = {'lower_arm_cal_rotorStrain*.tdms'};

[td,sd,bd] = process_data_folder(dataDir,cal,consts,name_conventions);

%% Plot
% plot(sd.TSR,sd.cP,'.')
% grid on
% box on
% xlabel('TSR')
% ylabel('Cp')

for II = 1:length(td{1})

    plot(td{1}(II).Lower_Arm_Mx)
    hold on
end

