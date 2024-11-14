clear all
% close all
clc

%% Common inputs
verify.consts = XFlow_Spanish_Fork_testing_constants();
verify.func = @(x) x(1) + x(2);
verify.data.physical_loads = {'Lower_Yoke_Fx','Upper_Yoke_Fx'};
verify.data.absolute_cali_path = 'C:\Users\Ian\Documents\GitHub\xflow-daq\processing\implementations\10m_Spanish_Fork_testing\Calibrations\Results\cal_struct_27_09_24.mat';

%% Rotor segment on ground
verify.absolute_data_path = 'X:\Experiments and Data\20 kW Prototype\Loads_Data\load_calibrations\rotor_segment';
verify.tdms_filter = '*rotorStrain*.tdms';
verify.applied_load_var_name = 'Applied_Load';
verify.relative_data_folder = 'rotor_segment_center_Fx';
verify.applied_load_scaling = verify.consts.units.lbf_to_N;

[applied_load, measured_load] = calibration_verification(verify);

fh1 = figure;
plot(applied_load,measured_load,'o')
hold on

fh2 = figure;
plot(applied_load,(measured_load./applied_load-1)*100,'o')
hold on

pause(0.01)
%% Raised rotor
verify.absolute_data_path = 'X:\Experiments and Data\20 kW Prototype\Loads_Data\load_calibrations\installed_rotor';
verify.tdms_filter = '*rotor_strain*.tdms';
verify.applied_load_var_name = 'appliedLoad';

data_folders = {'-X','+X'};
applied_load_scaling = verify.consts.units.lbf_to_N*[1 -1];


for II = 1:length(data_folders)
    verify.relative_data_folder = data_folders{II};
    verify.applied_load_scaling = applied_load_scaling(II);

    [applied_load, measured_load] = calibration_verification(verify);

    figure(fh1)
    plot(applied_load,measured_load,'o')
    hold on

    figure(fh2)
    plot(applied_load,(measured_load./applied_load-1)*100,'o')
    hold on
end

%% Cleanup figure
figure(fh1)
title('Rotor Segment Fx')
x = [-600 800];
plot(x,x,'--k')
legend('Rotor Segment on Ground','Rotor Raised, -X', 'Rotor Raised, +X','Location','SouthEast')
xlabel('Applied Load')
ylabel('Measured Load')
grid on
box on

figure(fh2)
title('Rotor Segment Fx')
axis([x -10 10])
xlabel('Applied Load')
ylabel('Percent Error')
legend('Rotor Segment on Ground','Rotor Raised, -X', 'Rotor Raised, +X','Location','Best')
plot(x,[0 0],'--k')
grid on
box on