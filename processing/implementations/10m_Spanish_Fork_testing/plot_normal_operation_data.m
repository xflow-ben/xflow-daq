clear all
close all
clc

%% Assign data folder
data_dir = 'X:\Experiments and Data\20 kW Prototype\Loads_Data\operating_uncompressed\processed';

fileList = dir(fullfile(data_dir,'operating_results_1*'));

sd_all = struct();
for II = 1:length(fileList)

    load(fullfile(data_dir,fileList(II).name));

    if II == 1
        sd_all = results.sd;
    else
        if ~isempty(fieldnames(results.sd))
            sd_all = combine_nested_structs(sd_all,results.sd);
        end
    end
end
%%%%%%

%% Plot normal operation capture matrix
% Define wind speed and TI bins (adjust bin sizes as needed)
U_bin_edges = 3:1:18; % Bins from 3 m/s to 25 m/s with 1 m/s intervals
TI_bin_edges = 1:2:31; % Top bins limit will be overidden to 100%

plot_normal_operation_capture_matrix(sd_all.U.mean,sd_all.U.std./sd_all.U.mean*100,U_bin_edges,TI_bin_edges)

%% Plot met timeseries
figure
plot(sd_all.U.mean,sd_all.U.std./sd_all.U.mean*100,'.')

figure(4)
hold on
plot(sd_all.TSR.mean,-sd_all.Cp_aero.mean,'.')


figure(3)
hold on
plot(sd_all.U.mean,-sd_all.Cp_aero.mean,'.')


figure(6)
hold on
plot(sd_all.U.mean,sd_all.omega_sensor.mean,'.')

figure(10)
hold on
plot(sd_all.U.mean,-sd_all.power_gen.mean,'.')
plot(sd_all.U.mean,-sd_all.power_gen.min,'.')
plot(sd_all.U.mean,-sd_all.power_gen.max,'.')


figure(100)
plot(sd_all.omega_sensor.mean,sd_all.Lower_Arm_My.mean,'.')
