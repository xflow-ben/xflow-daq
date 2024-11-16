clear all
close all
clc


savePath = fullfile(fileparts(mfilename('fullpath')),'Results');
saveName = 'misc_calibrations';
count = 0;

%% Time
% count = count + 1;
% cal(count).type = 'linear_k';
% cal(count).data.k = 1;
% cal(count).inputChannels = {'time'};
% cal(count).outputNames = {'Time'};
% cal(count).outputUnits = {'s'};

% count = count + 1;
% cal(count).type = 'counter_voltage_signal';
% cal(count).data.slope = 2*pi/2.5;
% cal(count).data.offset = 0;
% cal(count).data.threshold = 1; % Voltage threshold for detecting transitions
% cal(count).data.windowSize = 1; % Size of the time window for averaging (in seconds)
% cal(count).inputChannels = {'Anno 1'};
% cal(count).outputNames = {'Tower_Windspeed_1'};
% cal(count).outputUnits = {'m/s'};
% cal(count).data.output_derivative_orders = 1;
% 
% count = count + 1;
% cal(count).type = 'counter_voltage_signal';
% cal(count).data.slope = 2*pi/2.5;
% cal(count).data.offset = 0;
% cal(count).data.threshold = 1; % Voltage threshold for detecting transitions
% cal(count).data.windowSize = 1; % Size of the time window for averaging (in seconds)
% cal(count).inputChannels = {'Anno 2'};
% cal(count).outputNames = {'Tower_Windspeed_2'};
% cal(count).outputUnits = {'m/s'};
% cal(count).data.output_derivative_orders = 1;

count = count + 1;
cal(count).type = 'rpm_voltage_signal';
cal(count).data.slope = 2*pi/90;
cal(count).data.offset = 0;
cal(count).data.threshold = 1; % Voltage threshold for detecting transitions
cal(count).data.windowSize = 0.5; % Size of the time window for averaging (in seconds)
cal(count).inputChannels = {'RPM Sensor'}; % Names of load channels of intrest
cal(count).outputNames = {'theta_NEEDS_RESET_sensor','omega_sensor','acc_sensor'}; % Names of physical loads of intrest which are applied during calibrations
cal(count).outputUnits = {'rad','rad/s','rad/s^2'}; % Units of load channels after calibration
cal(count).data.output_derivative_orders = [1 2 3];
cal(count).stage = 'beforeResample';

count = count + 1;
cal(count).type = 'encoder';
cal(count).data.PPR = 2^14; % pulse per revolution of encoder
cal(count).data.windowSize = 0.01; % Size of the time window for averaging (in seconds)
cal(count).inputChannels = {'Encoder'};
cal(count).outputNames = {'theta_encoder','omega_encoder','acc_encoder'}; % Names of physical loads of intrest which are applied during calibrations
cal(count).outputUnits = {'rad','rad/s','rad/s^2'}; % Units of load channels after calibration
cal(count).stage = 'beforeResample';

count = count + 1;
cal(count).type = 'linear_k';
cal(count).data.k = 3603;
cal(count).inputChannels = {'Power Transducer'};
cal(count).outputNames = {'electric_power'};
cal(count).outputUnits = {'W'}; %Electrical power at point of grid connection [W]
cal(count).stage = 'afterResample';

count = count + 1;
cal(count).type = 'linear_k';
cal(count).data.k = 3603;
cal(count).inputChannels = {'Power Transducer Filt'};
cal(count).outputNames = {'electric_power_filtered'};
cal(count).outputUnits = {'W'}; %Electrical power at point of grid connection [W]
cal(count).stage = 'afterResample';

count = count + 1;
cal(count).type = 'linear_k';
cal(count).data.k = 3.715170279;
cal(count).inputChannels = {'Battery Voltage'};
cal(count).outputNames = {'Hub_Battery_Voltage'};
cal(count).outputUnits = {'VDC'}; % Hub DAQ battery voltage
cal(count).stage = 'afterResample';

%% Save
save(fullfile(savePath,saveName),'cal')



