clear all
close all
clc


savePath = fullfile(fileparts(mfilename('fullpath')),'Results');
saveName = 'misc_calibrations';
count = 0;

%% Time
count = count + 1;
cal(count).type = 'linear_k';
cal(count).data.k = 1;
cal(count).input_channels = {'time'};
cal(count).output_names = {'Time'};
cal(count).output_units = {'s'};

count = count + 1;
cal(count).type = 'linear_k';
cal(count).data.k = 2*pi/2.5;
cal(count).input_channels = {'Anno 1'};
cal(count).output_names = {'Tower_Windspeed_1'};
cal(count).output_units = {'m/s'};

count = count + 1;
cal(count).type = 'linear_k';
cal(count).data.k = 2*pi/2.5;
cal(count).input_channels = {'Anno 2'};
cal(count).output_names = {'Tower_Windspeed_2'};
cal(count).output_units = {'m/s'};

count = count + 1;
cal(count).type = 'rpm_voltage_signal';
cal(count).data.slope = 2*pi/90;
cal(count).data.offset = 0;
cal(count).data.threshold = 1; % Voltage threshold for detecting transitions
cal(count).data.windowSize = 2; % Size of the time window for averaging (in seconds)
cal(count).input_channels = {'RPM Sensor'}; % Names of load channels of intrest
cal(count).output_names = {'theta_sensor','omega_sensor','acc_sensor'}; % Names of physical loads of intrest which are applied during calibrations
cal(count).output_units = {'rad','rad/s','rad/s^2'}; % Units of load channels after calibration

count = count + 1;
cal(count).type = 'encoder';
cal(count).data.PPR = 2^14; % pulse per revolution of encoder
cal(count).data.windowSize = 0.01; % Size of the time window for averaging (in seconds)
cal(count).input_channels = {'Encoder'};
cal(count).output_names = {'theta_encoder','omega_encoder','acc_encoder'}; % Names of physical loads of intrest which are applied during calibrations
cal(count).output_units = {'rad','rad/s','rad/s^2'}; % Units of load channels after calibration


count = count + 1;
cal(count).type = 'linear_k';
cal(count).data.k = 3603;
cal(count).input_channels = {'Power Transducer'};
cal(count).output_names = {'electric_power'};
cal(count).output_units = {'W'}; %Electrical power at point of grid connection [W]


count = count + 1;
cal(count).type = 'linear_k';
cal(count).data.k = 3603;
cal(count).input_channels = {'Power Transducer Filt'};
cal(count).output_names = {'electric_power_filtered'};
cal(count).output_units = {'W'}; %Electrical power at point of grid connection [W]

count = count + 1;
cal(count).type = 'linear_k';
cal(count).data.k = 3.715170279;
cal(count).input_channels = {'Battery Voltage'};
cal(count).output_names = {'Hub_Battery_Voltage'};
cal(count).output_units = {'VDC'}; % Hub DAQ battery voltage

%% Save
save(fullfile(savePath,saveName),'cal')



