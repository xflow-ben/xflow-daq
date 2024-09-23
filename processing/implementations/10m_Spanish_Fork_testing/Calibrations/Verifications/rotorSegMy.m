clear all
close all
clc


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%NOT WORKING, WHY?%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Common inputs
consts = XFlow_Spanish_Fork_testing_constants();
verify.func = @(x) - x(1) + x(2);
verify.data.measurment_channels = {'Lower Arm My','Upper Arm My'};
verify.data.physical_loads = {'Lower_Arm_My','Upper_Arm_My'};
verify.data.absolute_cali_path = 'C:\Users\Ian\Documents\GitHub\xflow-daq\processing\implementations\10m_Spanish_Fork_testing\Calibrations\Results\';
verify.data.relative_cali_struct = {'lower_arm_cal_single_axis_struct.mat',...
    'upper_arm_cal_single_axis_struct.mat'};

%% Rotor segment on ground
verify.absolute_data_path = 'X:\Experiments and Data\20 kW Prototype\Loads_Data\load_calibrations\rotor_segment';
verify.tdms_filter = '*rotorStrain*.tdms';
verify.applied_load_var_name = 'Applied_Load';
verify.relative_data_folder = 'rotor_segment_center_Fx';
verify.applied_load_scaling = consts.units.lbf_to_N*consts.upperArm.span*cosd(consts.upperArm.angle);

[applied_load, measured_load] = calibration_verification(verify);

figure
plot(applied_load,measured_load,'o')
hold on