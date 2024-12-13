close all
clear all
clc

%%
% load('X:\Experiments and Data\20 kW Prototype\Loads_Data\operating_uncompressed\processed\DEBUG_operating_results_1016172530.mat')
load('X:\Experiments and Data\20 kW Prototype\Loads_Data\operating_uncompressed\processed\operating_results_1016172530.mat')

data_theta_offset = 215; %deg
%%


for II = 6
ind = results.sd.td_index.start(II):results.sd.td_index.end(II);
theta_data = mod(results.td.theta_encoder(ind)*180/pi-data_theta_offset,360);

[~,edges,indTheta] = histcounts(theta_data,[0:5:360]);

figure(1)
hold on
plot(results.td.Time(ind)-results.td.Time(ind(1)),results.td.U(ind))


xlabel('Time [s]')
ylabel('U [m/s]')
box on
grid on

sumFx = results.td.Lower_Yoke_Fx(ind)+ results.td.Upper_Yoke_Fx(ind) + (results.td.Acc_Lower_Arm_X_Filt(ind)-mean(results.td.Acc_Lower_Arm_X_Filt(ind),'omitmissing'))*(1000/4.527)^2*120;
sumFxbinMeans = accumarray(indTheta(indTheta > 0), sumFx(indTheta > 0), [], @mean);

figure(2)
hold on
plot(theta_data,sumFx,'.')
plot(edges(1:end-1)+mean(diff(edges)),sumFxbinMeans,'-k','LineWidth',3)

set(gca,'XLim',[0 360])
ylabel('Sum of Yoke Fx [N]')
xlabel('Azimuthal Position [\theta]')
box on 
grid on


figure(3)
hold on
plot(theta_data,results.td.Lower_Yoke_Fz(ind),'.')
set(gca,'XLim',[0 360])
xlabel('Azimuthal Position [\theta]')
box on 
grid on

accX = results.td.Acc_Lower_Arm_X_Filt(ind)*(1000/4.527)^2;
accXbinMeans = accumarray(indTheta(indTheta > 0), accX(indTheta > 0), [], @mean);


figure(5)
hold on
plot(theta_data,results.td.Acc_Lower_Arm_X_Filt(ind)*(1000/4.527)^2,'.')
plot(edges(1:end-1)+mean(diff(edges)),accXbinMeans,'-k','LineWidth',3)

set(gca,'XLim',[0 360])
xlabel('Azimuthal Position [\theta]')
box on 
grid on


figure(6)
hold on
plot(theta_data,results.td.omega_encoder(ind),'.')
ylabel('\omega')
box on 
grid on
end

% %%
% 
% 
% qblade = processHAWC2Binary('X:\Simulation_File_Transfer\plr_verification1-1.sel', 'X:\Simulation_File_Transfer\plr_verification1-1.dat');
% 
% figure(2)
% plot(qblade.data.AzimuthalAngleBLD_1,qblade.data.TotalTangentialLoadBlade1,'k.')
% 
% figure(3)
% plot(a(:,1),a(:,2),'k.')
% 
% 
% figure(4)
% plot(qblade.data.AzimuthalAngleBLD_1,qblade.data.AngleOfAttac___Blade1PAN,'k.')
% set(gca,'XLim',[0 360])
% xlabel('Azimuthal Position, \theta [deg]')
% box on 
% grid on
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


%%
qblade = processHAWC2Binary('X:\Simulation_File_Transfer\Polar and Oye sweep - 12.2ms\plr_verification1-1-75_polars-oye8.sel', 'X:\Simulation_File_Transfer\Polar and Oye sweep - 12.2ms\plr_verification1-1-75_polars-oye8.dat');

figure(2)
plot(qblade.data.AzimuthalAngleBLD_1,qblade.data.TotalTangentialLoadBlade1,'r.')

% figure(3)
% plot(d(:,1),d(:,2),'r.')


figure(4)
plot(qblade.data.AzimuthalAngleBLD_1,qblade.data.AngleOfAttac___Blade1PAN,'r.')
set(gca,'XLim',[0 360])
xlabel('Azimuthal Position, \theta [deg]')
box on 
grid on

% %%
% qblade = processHAWC2Binary('X:\Simulation_File_Transfer\plr_verification1-1-75_polars-ATEflap-3-2.sel', 'X:\Simulation_File_Transfer\plr_verification1-1-75_polars-ATEflap-3-2.dat');
% 
% figure(2)
% plot(qblade.data.AzimuthalAngleBLD_1,qblade.data.TotalTangentialLoadBlade1,'g.')
% 
% % figure(3)
% % plot(d(:,1),d(:,2),'r.')
% 
