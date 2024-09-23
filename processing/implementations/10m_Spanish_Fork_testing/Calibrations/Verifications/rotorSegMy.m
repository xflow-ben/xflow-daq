clear all
close all
clc

%% Common inputs
consts = XFlow_Spanish_Fork_testing_constants();
verify.func = @(x) x(1)*cosd(consts.lowerArm.angle) +...
    x(2)*sind(consts.lowerArm.angle) + ...
    x(3)*cosd(consts.upperArm.angle) + ...
    x(4)*sind(consts.upperArm.angle);
verify.data.measurment_channels = {'Lower Arm My','LowerArm Mz',...
    'Upper Arm My','Upper Arm Mz'};
verify.data.physical_loads = {'Lower_Arm_My','Lower_Arm_Mz',...
    'Upper_Arm_My','Upper_Arm_Mz'};
verify.data.absolute_cali_path = 'C:\Users\Ian\Documents\GitHub\xflow-daq\processing\implementations\10m_Spanish_Fork_testing\Calibrations\Results\';
verify.data.relative_cali_struct = {'lower_arm_cal_single_axis_struct.mat',...
    'lower_arm_cal_single_axis_struct.mat',...
    'upper_arm_cal_single_axis_struct.mat',...
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

%% Raised rotor
verify.absolute_data_path = 'X:\Experiments and Data\20 kW Prototype\Loads_Data\load_calibrations\installed_rotor';
verify.tdms_filter = '*rotor_strain*.tdms';
verify.applied_load_var_name = 'appliedLoad';
verify.data.measurment_channels = {'Lower Arm My','Lower Arm Mz',...
    'Upper Arm My','Upper Arm Mz'};
data_folders = {'-X','+X'};
applied_load_scaling = consts.units.lbf_to_N*[1 -1]*consts.upperArm.span*cosd(consts.upperArm.angle);

for II = 1:length(data_folders)
    verify.relative_data_folder = data_folders{II};
    verify.applied_load_scaling = applied_load_scaling(II);

    [applied_load, measured_load] = calibration_verification(verify);

    plot(applied_load,measured_load,'o')
    hold on
end

%% Cleanup figure
title('Rotor Segment My')
x = [-3000 4000];
plot(x,x,'--k')
legend('Rotor Segment on Ground','Rotor Raised, -X', 'Rotor Raised, +X','Location','SouthEast')
xlabel('Applied Load')
ylabel('Measured Load')