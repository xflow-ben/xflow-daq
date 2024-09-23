clear all
close all
clc

%% Common inputs
verify.consts = XFlow_Spanish_Fork_testing_constants();
verify.func = @(x) x(1) + x(2);
verify.data.measurment_channels = {'Lower Yoke Fx','Upper Yoke Fx'};
verify.data.physical_loads = {'Lower_Yoke_Fx','Upper_Yoke_Fx'};
verify.data.absolute_cali_path = 'C:\Users\Ian\Documents\GitHub\xflow-daq\processing\implementations\10m_Spanish_Fork_testing\Calibrations\Results\';
verify.data.relative_cali_struct = {'lower_arm_cal_single_axis_struct.mat',...
    'upper_arm_cal_single_axis_struct.mat'};

%% Rotor segment on ground
verify.absolute_data_path = 'X:\Experiments and Data\20 kW Prototype\Loads_Data\load_calibrations\rotor_segment';
verify.tdms_filter = '*rotorStrain*.tdms';
verify.applied_load_var_name = 'Applied_Load';
verify.relative_data_folder = 'rotor_segment_center_Fx';
verify.applied_load_sign = 1;

[applied_load, measured_load] = calibration_verification(verify);

figure
plot(applied_load,measured_load,'o')
hold on

%% Raised rotor
verify.absolute_data_path = 'X:\Experiments and Data\20 kW Prototype\Loads_Data\load_calibrations\installed_rotor';
verify.tdms_filter = '*rotor_strain*.tdms';
verify.applied_load_var_name = 'appliedLoad';

data_folders = {'-X','+X'};
applied_load_sign = [1 -1];

for II = 1:length(data_folders)
    verify.relative_data_folder = data_folders{II};
    verify.applied_load_sign = applied_load_sign(II);

    [applied_load, measured_load] = calibration_verification(verify);

    plot(applied_load,measured_load,'o')
    hold on
end

%% Cleanup figure
x = [-600 800];
plot(x,x,'--k')
legend('Rotor Segment on Ground','Rotor Raised, -X', 'Rotor Raised, +X','Location','SouthEast')
xlabel('Applied Load')
ylabel('Measured Load')