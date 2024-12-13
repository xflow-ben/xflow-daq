clear all
close all
clc


savePath = fullfile(fileparts(mfilename('fullpath')),'Results');
saveName = 'misc_calibrations';
count = 0;
consts = XFlow_Spanish_Fork_testing_constants();

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

count = count + 1;
cal(count).type = 'reset_encoder_via_rpm_sensor';
cal(count).data.PPR = 2^14; % pulse per revolution of encoder
cal(count).data.windowSize = 0.01; % Size of the time window for averaging (in seconds)
cal(count).inputChannels = {'theta_encoder'};
cal(count).outputNames = {'theta_encoder_reset'}; % Names of physical loads of intrest which are applied during calibrations
cal(count).outputUnits = {'rad'}; % Units of load channels after calibration
cal(count).stage = 'beforeResample';

count = count + 1;
cal(count).type = 'arb_fcn';
cal(count).data.fcn = @(x,consts)log(x(:,1)./x(:,2))/log(consts.met.secondary_aneometer_height/consts.met.primary_anemometer_height);
cal(count).data.consts = consts;
cal(count).inputChannels = {'U_secondary','U',};
cal(count).outputNames = {'shear'}; % Names of physical loads of intrest which are applied during calibrations
cal(count).outputUnits = {''}; % Units of load channels after calibration
cal(count).stage = 'final';

count = count + 1;
cal(count).type = 'arb_fcn';
cal(count).data.fcn = @(x,consts)x(:,1)./(consts.met.R*x(:,2));
cal(count).data.consts = consts;
cal(count).data.filterCutoffHz = 0.5;
cal(count).inputChannels = {'pressure','temp'};
cal(count).outputNames = {'rho'}; % Names of physical loads of intrest which are applied during calibrations
cal(count).outputUnits = {''}; % Units of load channels after calibration
cal(count).stage = 'final';

count = count + 1;
cal(count).type = 'arb_fcn';
cal(count).data.fcn = @(x,consts)(1.458*10^(-6)*x.^(3/2))./(x+110.4);
cal(count).data.consts = consts;
cal(count).data.filterCutoffHz = 0.5;
cal(count).inputChannels = {'temp'};
cal(count).outputNames = {'mew'}; % Names of physical loads of intrest which are applied during calibrations
cal(count).outputUnits = {''}; % Units of load channels after calibration
cal(count).stage = 'final';

count = count + 1;
cal(count).type = 'arb_fcn';
cal(count).data.fcn = @(x,consts)td.tau_gen - td.acc_encoder.*consts.turb.J;
cal(count).data.consts = consts;
cal(count).inputChannels = {'tau_gen','acc_encoder'};
cal(count).outputNames = {'tau_aero'}; % Names of physical loads of intrest which are applied during calibrations
cal(count).outputUnits = {'N*m'}; % Units of load channels after calibration
cal(count).stage = 'final';

count = count + 1;
cal(count).type = 'arb_fcn';
cal(count).data.fcn = @(x,consts) -(x(:,1)*cosd(consts.upperArm.angle) + x(:,2)*cosd(consts.lowerArm.angle)...
    + x(:,3)*sind(consts.upperArm.angle) - x(:,4)*sind(consts.lowerArm.angle));
cal(count).data.consts = consts;
cal(count).inputChannels = {'Upper_Arm_My','Lower_Arm_My','Upper_Arm_Mz','Lower_Arm_Mz'};
cal(count).outputNames = {'tau_aero_single_segment'}; % Names of physical loads of intrest which are applied during calibrations
cal(count).outputUnits = {'N*m'}; % Units of load channels after calibration
cal(count).stage = 'final';

count = count + 1;
cal(count).type = 'arb_fcn';
cal(count).data.fcn = @(x,consts)x(:,1).*x(:,2);
cal(count).data.consts = consts;
cal(count).inputChannels = {'omega_encoder','tau_gen'};
cal(count).outputNames = {'power_gen'}; % Names of physical loads of intrest which are applied during calibrations
cal(count).outputUnits = {'W'}; % Units of load channels after calibration
cal(count).stage = 'final';

count = count + 1;
cal(count).type = 'arb_fcn';
cal(count).data.fcn = @(x,consts)x(:,1).*x(:,2);
cal(count).data.consts = consts;
cal(count).inputChannels = {'omega_encoder','tau_aero'};
cal(count).outputNames = {'power_aero'}; % Names of physical loads of intrest which are applied during calibrations
cal(count).outputUnits = {'W'}; % Units of load channels after calibration
cal(count).stage = 'final';


count = count + 1;
cal(count).type = 'arb_fcn';
cal(count).data.fcn = @(x,consts)x(:,1)*consts.rotor.radius./x(:,2);
cal(count).data.consts = consts;
cal(count).inputChannels = {'omega_encoder','U'};
cal(count).outputNames = {'TSR'}; % Names of physical loads of intrest which are applied during calibrations
cal(count).outputUnits = {''}; % Units of load channels after calibration
cal(count).stage = 'final';

count = count + 1;
cal(count).type = 'arb_fcn';
cal(count).data.fcn = @(x,consts)x(:,1)./(0.5*x(:,2)*consts.turb.A.*x(:,3).^3);
cal(count).data.consts = consts;
cal(count).inputChannels = {'power_gen','rho','U'};
cal(count).outputNames = {'Cp_gen'}; % Names of physical loads of intrest which are applied during calibrations
cal(count).outputUnits = {''}; % Units of load channels after calibration
cal(count).stage = 'final';

count = count + 1;
cal(count).type = 'arb_fcn';
cal(count).data.fcn = @(x,consts)x(:,1)./(0.5*x(:,2)*consts.turb.A.*x(:,3).^3);
cal(count).data.consts = consts;
cal(count).inputChannels = {'power_aero','rho','U'};
cal(count).outputNames = {'Cp_aero'}; % Names of physical loads of intrest which are applied during calibrations
cal(count).outputUnits = {''}; % Units of load channels after calibration
cal(count).stage = 'final';


count = count + 1;
cal(count).type = 'arb_fcn';
cal(count).data.fcn = @(x,consts)x(:,1)./(0.5*x(:,2)*consts.turb.A.*x(:,3).^2*consts.rotor.radius);
cal(count).data.consts = consts;
cal(count).inputChannels = {'tau_gen','rho','U'};
cal(count).outputNames = {'Cq_gen'}; % Names of physical loads of intrest which are applied during calibrations
cal(count).outputUnits = {''}; % Units of load channels after calibration
cal(count).stage = 'final';

count = count + 1;
cal(count).type = 'arb_fcn';
cal(count).data.fcn = @(x,consts)x(:,1)./(0.5*x(:,2)*consts.turb.A.*x(:,3).^2*consts.rotor.radius);
cal(count).data.consts = consts;
cal(count).inputChannels = {'tau_aero','rho','U'};
cal(count).outputNames = {'Cq_aero'}; % Names of physical loads of intrest which are applied during calibrations
cal(count).outputUnits = {''}; % Units of load channels after calibration
cal(count).stage = 'final';
%% Save
save(fullfile(savePath,saveName),'cal')



