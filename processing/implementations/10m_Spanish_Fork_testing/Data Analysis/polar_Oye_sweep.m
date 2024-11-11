close all
clear all
clc


theta_step = 5;
theta_array = 0:theta_step:360;
theta_centers = theta_array(1:end-1) + theta_step/2;
%% Load experimental data
load('X:\Experiments and Data\20 kW Prototype\Loads_Data\operating_uncompressed\processed\DEBUG_operating_results_1016172530.mat')
% load('X:\Experiments and Data\20 kW Prototype\Loads_Data\operating_uncompressed\processed\operating_results_1016172530.mat')

data_theta_offset = 215; %deg


theta_data = mod(results.td.theta_encoder*180/pi-data_theta_offset,360);

[~,edges,indTheta] = histcounts(theta_data,theta_array);

figure(1)
hold on
plot(results.td.Time-results.td.Time(1),results.td.U)
xlabel('Time [s]')
ylabel('U [m/s]')
box on
grid on

sumFx = results.td.Lower_Yoke_Fx + results.td.Upper_Yoke_Fx + (results.td.Acc_Lower_Arm_X_Filt-mean(results.td.Acc_Lower_Arm_X_Filt,'omitmissing'))*(1000/4.527)^2*120;
sumFxbinMeans = accumarray(indTheta(indTheta > 0), sumFx(indTheta > 0), [], @(x) mean(x, 'omitnan'));

figure(2)
hold on
plot(theta_data,sumFx,'.')
plot(theta_centers,sumFxbinMeans,'-k','LineWidth',3)

set(gca,'XLim',[0 360])
ylabel('Sum of Yoke Fx [N]')
xlabel('Azimuthal Position [\theta]')
box on
grid on


Lower_Yoke_Fz_Means = accumarray(indTheta(indTheta > 0), results.td.Lower_Yoke_Fz(indTheta > 0), [], @(x) mean(x, 'omitnan'));

figure(3)
hold on
plot(theta_data,results.td.Lower_Yoke_Fz,'.')
plot(theta_centers,Lower_Yoke_Fz_Means,'-k','LineWidth',3)

set(gca,'XLim',[0 360])
xlabel('Azimuthal Position [\theta]')
box on
grid on


figure(5)
hold on
plot(theta_data,results.td.tau_gen,'.')
% plot(theta_centers,Lower_Yoke_Fz_Means,'-k','LineWidth',3)

set(gca,'XLim',[0 360])
xlabel('Azimuthal Position [\theta]')
box on
grid on


Lower_Arm_My_Means = accumarray(indTheta(indTheta > 0), results.td.Lower_Arm_My(indTheta > 0), [], @(x) mean(x, 'omitnan'));

figure(400)
hold on
plot(theta_data,results.td.Lower_Arm_My,'.')
plot(theta_centers,Lower_Arm_My_Means,'-k','LineWidth',3)

set(gca,'XLim',[0 360])
xlabel('Azimuthal Position [\theta]')
box on
grid on
%
% accX = results.td.Acc_Lower_Arm_X_Filt*(1000/4.527)^2;
% accXbinMeans = accumarray(indTheta(indTheta > 0), accX(indTheta > 0), [], @mean);
%
%
% figure(5)
% hold on
% plot(theta_data,results.td.Acc_Lower_Arm_X_Filt*(1000/4.527)^2,'.')
% plot(edges(1:end-1)+mean(diff(edges)),accXbinMeans,'-k','LineWidth',3)
%
% set(gca,'XLim',[0 360])
% xlabel('Azimuthal Position [\theta]')
% box on
% grid on
%
%
% figure(6)
% hold on
% plot(theta_data,results.td.omega_encoder,'.')
% ylabel('\omega')
% box on
% grid on


%% Get QBlade file names to sweep through
% Specify the directory (you can change this to your desired path)
directory = 'X:\Simulation_File_Transfer\Polar and Oye sweep - 12.2ms';  % Replace with your directory path


% Get a list of all .dat files in the directory
files = dir(fullfile(directory,'*.dat'));

% Extract the file names into a cell array
fileNames = {files.name};

% Remove the .dat extension from each file name
for i = 1:length(fileNames)
    [~, name, ~] = fileparts(fileNames{i});
    fileNames{i} = name;
end
%% Read QBlade data
%
% for II = 1:length(fileNames)
%     II/length(fileNames)
%
%     %% Read QBlade data
%
%     qblade = processHAWC2Binary(fullfile(directory,[fileNames{II},'.sel']), fullfile(directory,[fileNames{II},'.dat']));
%     Lower_Yoke_Fz_qblade = readQBladeTxt(fullfile(directory,[fileNames{II},'.txt']), 'Z_l_For._STR_1_1_-_BLD_1_z=15.0m_[N]');
%
%
%     [~,edges,indTheta] = histcounts(qblade.data.AzimuthalAngleBLD_1,theta_array);
%     sumFx = qblade.data.TotalTangentialLoadBlade1;
%     sumFxbinMeans_Qblade = accumarray(indTheta(indTheta > 0), sumFx(indTheta > 0), [], @(x) mean(x, 'omitnan'));
%
%     Lower_Yoke_Fz_Means_Qblade = accumarray(indTheta(indTheta > 0), Lower_Yoke_Fz_qblade(indTheta > 0), [], @(x) mean(x, 'omitnan'));
%
%     %%
%     L1_Fx(II) = sum(abs(sumFxbinMeans-sumFxbinMeans_Qblade));
%
%     L1_Fz(II) = sum(abs(Lower_Yoke_Fz_Means-Lower_Yoke_Fz_Means_Qblade));
%
% end
%
% figure
% plot(L1_Fx)
% hold on
% plot(L1_Fz)
%
% [~,indBest] = min(L1_Fz);
indBest = 204;
qblade = processHAWC2Binary(fullfile(directory,[fileNames{indBest},'.sel']), fullfile(directory,[fileNames{indBest},'.dat']));
Lower_Yoke_Fz_qblade = readQBladeTxt(fullfile(directory,[fileNames{indBest},'.txt']), 'Z_l_For._STR_1_1_-_BLD_1_z=15.0m_[N]');
[~,edges,indTheta] = histcounts(qblade.data.AzimuthalAngleBLD_1,theta_array);
sumFx = qblade.data.TotalTangentialLoadBlade1;
sumFxbinMeans_Qblade = accumarray(indTheta(indTheta > 0), sumFx(indTheta > 0), [], @(x) mean(x, 'omitnan'));

Lower_Yoke_Fz_Means_Qblade = accumarray(indTheta(indTheta > 0), Lower_Yoke_Fz_qblade(indTheta > 0), [], @(x) mean(x, 'omitnan'));

figure(2)
plot(theta_centers,sumFxbinMeans_Qblade,'r-')
hold on
pause(.1)


figure(3)
plot(theta_centers,Lower_Yoke_Fz_Means_Qblade,'r-')
hold on
pause(.1)
% figure(3)
% plot(a(:,1),a(:,2),'k.')
%
%
figure(4)
plot(qblade.data.AzimuthalAngleBLD_1,qblade.data.AngleOfAttac___Blade1PAN,'k.')
set(gca,'XLim',[0 360])
xlabel('Azimuthal Position, \theta [deg]')
box on
grid on


figure(400)
plot(qblade.data.AzimuthalAngleBLD_1,qblade.data.Y_lMom_STR_1_1_TRQZ_17_7m,'r.')
set(gca,'XLim',[0 360])
xlabel('Azimuthal Position, \theta [deg]')
box on
grid on
%
% %%
% qblade = processHAWC2Binary('X:\Simulation_File_Transfer\plr_verification1-1-old_polars.sel', 'X:\Simulation_File_Transfer\plr_verification1-1-old_polars.dat');
%
% figure(2)
% plot(qblade.data.AzimuthalAngleBLD_1,qblade.data.TotalTangentialLoadBlade1,'r.')
%
% figure(3)
% plot(b(:,1),b(:,2),'r.')
%
%
% figure(4)
% plot(qblade.data.AzimuthalAngleBLD_1,qblade.data.AngleOfAttac___Blade1PAN,'r.')
% set(gca,'XLim',[0 360])
% xlabel('Azimuthal Position, \theta [deg]')
% box on
% grid on
%
% %%
% qblade = processHAWC2Binary('X:\Simulation_File_Transfer\plr_verification1-1-old_polars-oye8.sel', 'X:\Simulation_File_Transfer\plr_verification1-1-old_polars-oye8.dat');
%
% figure(2)
% plot(qblade.data.AzimuthalAngleBLD_1,qblade.data.TotalTangentialLoadBlade1,'g.')
%
% figure(3)
% plot(b(:,1),b(:,2),'r.')
%
%
% figure(4)
% plot(qblade.data.AzimuthalAngleBLD_1,qblade.data.AngleOfAttac___Blade1PAN,'g.')
% set(gca,'XLim',[0 360])
% xlabel('Azimuthal Position, \theta [deg]')
% box on
% grid on
%
% %%
% qblade = processHAWC2Binary('X:\Simulation_File_Transfer\plr_verification1-1-blended_polars-oye8.sel', 'X:\Simulation_File_Transfer\plr_verification1-1-blended_polars-oye8.dat');
%
% figure(2)
% plot(qblade.data.AzimuthalAngleBLD_1,qblade.data.TotalTangentialLoadBlade1,'m.')
%
% figure(3)
% plot(c(:,1),c(:,2),'m.')
%
%
% figure(4)
% plot(qblade.data.AzimuthalAngleBLD_1,qblade.data.AngleOfAttac___Blade1PAN,'m.')
% set(gca,'XLim',[0 360])
% xlabel('Azimuthal Position, \theta [deg]')
% box on
% grid on


% %%
% qblade = processHAWC2Binary('X:\Simulation_File_Transfer\plr_verification1-1-75_polars-oye8.sel', 'X:\Simulation_File_Transfer\plr_verification1-1-75_polars-oye8.dat');
%
% figure(2)
% plot(qblade.data.AzimuthalAngleBLD_1,qblade.data.TotalTangentialLoadBlade1,'r.')
%
% % figure(3)
% % plot(d(:,1),d(:,2),'r.')
%
%
% figure(4)
% plot(qblade.data.AzimuthalAngleBLD_1,qblade.data.AngleOfAttac___Blade1PAN,'r.')
% set(gca,'XLim',[0 360])
% xlabel('Azimuthal Position, \theta [deg]')
% box on
% grid on

% %%
% qblade = processHAWC2Binary('X:\Simulation_File_Transfer\plr_verification1-1-75_polars-ATEflap-3-2.sel', 'X:\Simulation_File_Transfer\plr_verification1-1-75_polars-ATEflap-3-2.dat');
%
% figure(2)
% plot(qblade.data.AzimuthalAngleBLD_1,qblade.data.TotalTangentialLoadBlade1,'g.')
%
% % figure(3)
% % plot(d(:,1),d(:,2),'r.')
%
