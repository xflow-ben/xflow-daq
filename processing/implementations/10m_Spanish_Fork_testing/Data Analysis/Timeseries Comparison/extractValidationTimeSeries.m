clear all
close all
clc

%%
load('operating_results_td_1014212844.mat')
% Specify the date and time as a string
dateString1 = '14-Oct-2024 21:00:00';
dateString2 = '14-Oct-2024 21:01:00';

% Convert to datenum using the appropriate format
n(1) = datenum(dateString1, 'dd-mmm-yyyy HH:MM:SS');
n(2) = datenum(dateString2, 'dd-mmm-yyyy HH:MM:SS');
%%

results.td.datenum = results.td.Time/(24*60*60);
ind = results.td.datenum > n(1) & results.td.datenum < n(2);

U = results.td.U(ind);
shear = results.td.shear(ind);
Dir = results.td.Dir(ind);
tau_aero = results.td.tau_aero(ind);
tau_gen = results.td.tau_gen(ind);
omega = results.td.omega_sensor(ind);
time = results.td.Time(ind);
time = time-time(1);
%%



% results = convectionCorrection(results);
wake_buildup_time = 10; % buffer time before starting the replicate the field conditions for the wake to build up [s]
%  savename = sprintf('utah_data_U_mean=%0.2f_omega_mean=%0.2f_datenum_start_%s.txt',mean(U),mean(omega),dateString1);
%  generate_QBlade_hub_height_file_from_data(['all_cc_hub_height_',savename],results,n(1),n(2),wake_buildup_time)
%  generate_QBlade_simulation_input_file_from_data(['sim_input_',savename],results,n(1),n(2),wake_buildup_time)



%%

qblade = processHAWC2Binary('output_cc_all.sel', 'output_cc_all.dat');
%%
time_w_buildup = time + wake_buildup_time;
figure
subplot(6,1,1)
hold on
plot(time_w_buildup,U)
hold on
plot(qblade.data.Time,qblade.data.AbsMeasuredWindVel_AtHub)
ylabel('Wind Speed [m/s]')


subplot(6,1,2)
hold on
plot(time_w_buildup,Dir,'.')
hold on
plot(qblade.data.Time,qblade.data.HorizontalInflowAngle)
ylabel('Wind Direction [deg]')

subplot(6,1,3)
plot(time_w_buildup,omega)
hold on
plot(qblade.data.Time,qblade.data.RotationalSpeed*2*pi/60)
ylabel('Rotation Rate [rad/s]')

subplot(6,1,4)
plot(time_w_buildup,-tau_gen)
hold on
 % plot(time_w_buildup,-tau_gen+26000*results.td.acc_sensor(ind))
plot(qblade.data.Time,qblade.data.AerodynamicTorque)
ylabel('Torque [N-m]')

subplot(6,1,5)

plot(time_w_buildup,results.td.Center_Blade_Mx(ind))
hold on
plot(qblade.data.Time,-2.5*qblade.data.Y_lMom_BLD_1Pos0_500)
ylabel('Blade Center Moment [N-m]')



%%
Fs = 512;
[pxx, f] = pwelch(results.td.Acc_Nacelle_X(ind), [], [], [], Fs);

figure;
loglog(f, pxx);
hold on
for II = 1:6
    plot(II*4.2/(2*pi)* [1 1],[10^-15 10^14], '-k')

end
xlabel('Frequency (Hz)');
ylabel('Power/Frequency (x^2/Hz)');
title('Combined Power Spectral Density (PSD)');

