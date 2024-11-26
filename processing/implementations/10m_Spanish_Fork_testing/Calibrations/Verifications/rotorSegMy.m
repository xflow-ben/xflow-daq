function rotorSegMy(calPath)

opts.resample.taskName = 'rotorStrain';
opts.resample.rate = 512;
opts.fileConvention = 'trailingNumber';
%% Common inputs
verify.consts = XFlow_Spanish_Fork_testing_constants();
verify.func = @(x) x(1)*cosd(verify.consts.lowerArm.angle) +...
    x(2)*sind(verify.consts.lowerArm.angle) + ...
    x(3)*cosd(verify.consts.upperArm.angle) + ...
    x(4)*sind(verify.consts.upperArm.angle);
verify.data.physical_loads = {'Lower_Arm_My','Lower_Arm_Mz',...
    'Upper_Arm_My','Upper_Arm_Mz'};
verify.data.absolute_cali_path = 'X:\Experiments and Data\20 kW Prototype\Loads_Data\load_calibrations\rotor_segment\cal_with_LowerArm_Mz.mat';

%% Rotor segment on ground
verify.absolute_data_path = 'X:\Experiments and Data\20 kW Prototype\Loads_Data\load_calibrations\rotor_segment';
verify.tdms_filter = '*rotorStrain*.tdms';
verify.applied_load_var_name = 'Applied_Load';
verify.relative_data_folder = 'rotor_segment_center_Fx';
verify.applied_load_scaling = verify.consts.units.lbf_to_N*verify.consts.upperArm.span*cosd(verify.consts.upperArm.angle);

[applied_load, measured_load] = calibration_verification(verify,opts);
applied_load(1) = -applied_load(1);
fh1 = figure;
plot(applied_load,measured_load,'o')
hold on

fh2 = figure;
plot(applied_load,(measured_load./applied_load-1)*100,'o')
hold on

if any(abs(applied_load,(measured_load./applied_load-1)*100)>5)
    error('Rotor segment on ground check has error greater than 5%')
end

pause(0.01)

%% Raised rotor
opts.resample.taskName = 'rotor_strain';
verify.absolute_data_path = 'X:\Experiments and Data\20 kW Prototype\Loads_Data\load_calibrations\installed_rotor';
verify.tdms_filter = '*rotor_strain*.tdms';
verify.applied_load_var_name = 'appliedLoad';
verify.data.absolute_cali_path = calPath;%'C:\Users\Ian\Documents\GitHub\xflow-daq\processing\implementations\10m_Spanish_Fork_testing\Calibrations\Results\cal_struct_19_11_24.mat';

data_folders = {'-X','+X'};
applied_load_scaling = verify.consts.units.lbf_to_N*[1 -1]*verify.consts.upperArm.span*cosd(verify.consts.upperArm.angle);

for II = 1:length(data_folders)
    verify.relative_data_folder = data_folders{II};
    verify.applied_load_scaling = applied_load_scaling(II);

    [applied_load, measured_load] = calibration_verification(verify,opts);

    figure(fh1)
    plot(applied_load,measured_load,'o')
    hold on

    figure(fh2)
    plot(applied_load,(measured_load./applied_load-1)*100,'o')
    hold on
    if any(abs(applied_load,(measured_load./applied_load-1)*100)>5)
    error('Rotor segment raised check has error greater than 5%')
    end
end

%% Cleanup figure
figure(fh1)
title('Rotor Segment My')
x = [-3000 4000];
plot(x,x,'--k')
legend('Rotor Segment on Ground','Rotor Raised, -X', 'Rotor Raised, +X','Location','SouthEast')
xlabel('Applied Load')
ylabel('Measured Load')
grid on
box on

figure(fh2)
title('Rotor Segment My')
axis([x -10 10])
xlabel('Applied Load')
ylabel('Percent Error')
legend('Rotor Segment on Ground','Rotor Raised, -X', 'Rotor Raised, +X','Location','SouthEast')
plot(x,[0 0],'--k')
grid on
box on