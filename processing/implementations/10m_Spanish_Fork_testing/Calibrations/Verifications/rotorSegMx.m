clear all
close all
clc

%% Common inputs
consts = XFlow_Spanish_Fork_testing_constants();
verify.func = @(x) -x(1)/(consts.lowerArm.span)*cosd(consts.lowerArm.angle)...
    -x(2)/(consts.upperArm.span)*cosd(consts.upperArm.angle)...
    +x(3)*sind(consts.lowerArm.angle)...
    +x(4)*sind(consts.upperArm.angle);
verify.data.measurment_channels = {'Lower Arm Mx','Upper Arm Mx','Lower Yoke Fz','Upper Yoke Fz'};
verify.data.physical_loads = {'Lower_Arm_Mx','Upper_Arm_Mx','Lower_Yoke_Fz','Upper_Yoke_Fz'};
verify.data.absolute_cali_path = 'C:\Users\Ian\Documents\GitHub\xflow-daq\processing\implementations\10m_Spanish_Fork_testing\Calibrations\Results\';
verify.data.relative_cali_struct = {'lower_arm_cal_multi_axis_struct.mat',...
    'upper_arm_cal_multi_axis_struct.mat',...
    'lower_arm_cal_multi_axis_struct.mat',...
    'upper_arm_cal_multi_axis_struct.mat'};

%% Rotor segment on ground
verify.absolute_data_path = 'X:\Experiments and Data\20 kW Prototype\Loads_Data\load_calibrations\rotor_segment';
verify.tdms_filter = '*rotorStrain*.tdms';
verify.applied_load_var_name = 'Applied_Load';

data_folders = {'rotor_segment_lower_-Fz','rotor_segment_upper_+Fz'};
applied_load_scaling = consts.units.lbf_to_N*[1 1];

for II = 1:length(data_folders)
    verify.relative_data_folder = data_folders{II};
    verify.applied_load_scaling = applied_load_scaling(II);

    [applied_load, measured_load] = calibration_verification(verify);

    plot(applied_load,measured_load,'o')
    hold on
end

%% Raised rotor
verify.absolute_data_path = 'X:\Experiments and Data\20 kW Prototype\Loads_Data\load_calibrations\installed_rotor';
verify.tdms_filter = '*rotor_strain*.tdms';
verify.applied_load_var_name = 'appliedLoad';

data_folders = {'-Z_pos_1','-Z_pos_2'};
applied_load_scaling = consts.units.lbf_to_N*[-1 -1];

for II = 1:length(data_folders)
    verify.relative_data_folder = data_folders{II};
    verify.applied_load_scaling = applied_load_scaling(II);

    [applied_load, measured_load] = calibration_verification(verify);

    plot(applied_load,measured_load,'o')
    hold on
end

%% Cleanup figure
title('Rotor Segment Mx')
x = [-400 400];
plot(x,x,'--k')
legend('Rotor Segment on Ground, rotor_segment_lower_-Fz','Rotor Segment on Ground, rotor_segment_upper_+Fz','Rotor Raised, -Z_pos_1', 'Rotor Raised, -Z_pos_2','Location','SouthEast','interpreter','none')
xlabel('Applied Load')
ylabel('Measured Load')