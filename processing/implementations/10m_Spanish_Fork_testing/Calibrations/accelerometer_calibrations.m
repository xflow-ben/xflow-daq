clear all
close all
clc


savePath = fullfile(fileparts(mfilename('fullpath')),'Results');
saveName = 'acc_calibrations';
count = 0;

%%%%%%%%%%%%NOTE%%%%%%%%%%%%%
% Some spec sheets didn't give an offset value, so we decided to set all
% offsets to 0.


%% Nacelle 
count = count + 1;
cal(count).type = 'linear_k';
cal(count).input_channels = {'Acc Nacelle X Filt'};
cal(count).output_names = {'Acc_Nacelle_X_Filt'};
cal(count).output_units = {'m/s^2'}; 
cal(count).type = 'slope_offset';
cal(count).data.slope = 13.60/1000;
cal(count).data.offset = 0;%10.5/1000;
cal(count).data.SN = 'LW13625'; % Instrument SN. Slope and offset are from the calibration of this instrument

count = count + 1;
cal(count).type = 'linear_k';
cal(count).input_channels = {'Acc Nacelle X'};
cal(count).output_names = {'Acc_Nacelle_X'};
cal(count).output_units = {'m/s^2'}; 
cal(count).type = 'slope_offset';
cal(count).data.slope = 13.60/1000;
cal(count).data.offset = 0;%10.5/1000;
cal(count).data.SN = 'LW13625'; % Instrument SN. Slope and offset are from the calibration of this instrument

count = count + 1;
cal(count).type = 'linear_k';
cal(count).input_channels = {'Acc Nacelle Y Filt'};
cal(count).output_names = {'Acc_Nacelle_Y_Filt'};
cal(count).output_units = {'m/s^2'}; 
cal(count).type = 'slope_offset';
cal(count).data.slope = 13.53/1000;
cal(count).data.offset = 0;%8.3/1000;
cal(count).data.SN = 'LW13625'; % Instrument SN. Slope and offset are from the calibration of this instrument

count = count + 1;
cal(count).type = 'linear_k';
cal(count).input_channels = {'Acc Nacelle Y'};
cal(count).output_names = {'Acc_Nacelle_Y'};
cal(count).output_units = {'m/s^2'}; 
cal(count).type = 'slope_offset';
cal(count).data.slope = 13.53/1000;
cal(count).data.offset = 0;%8.3/1000;
cal(count).data.SN = 'LW13625'; % Instrument SN. Slope and offset are from the calibration of this instrument

count = count + 1;
cal(count).type = 'linear_k';
cal(count).input_channels = {'Acc Nacelle Z Filt'};
cal(count).output_names = {'Acc_Nacelle_Z_Filt'};
cal(count).output_units = {'m/s^2'}; 
cal(count).type = 'slope_offset';
cal(count).data.slope = 13.5/1000;
cal(count).data.offset = 0;%12.3/1000;
cal(count).data.SN = 'LW13625'; % Instrument SN. Slope and offset are from the calibration of this instrument

count = count + 1;
cal(count).type = 'linear_k';
cal(count).input_channels = {'Acc Nacelle Z'};
cal(count).output_names = {'Acc_Nacelle_Z'};
cal(count).output_units = {'m/s^2'}; 
cal(count).type = 'slope_offset';
cal(count).data.slope = 13.5/1000;
cal(count).data.offset = 0;%12.3/1000;
cal(count).data.SN = 'LW13625'; % Instrument SN. Slope and offset are from the calibration of this instrument

%% Upper Arm
count = count + 1;
cal(count).type = 'linear_k';
cal(count).input_channels = {'Acc Upper Arm X Filt'};
cal(count).output_names = {'Acc_Upper_Arm_X_Filt'};
cal(count).output_units = {'m/s^2'}; 
cal(count).type = 'slope_offset';
cal(count).data.slope = 4.527/1000;
cal(count).data.offset = 0;
cal(count).data.SN = 'LW12618 '; % Instrument SN. Slope and offset are from the calibration of this instrument

count = count + 1;
cal(count).type = 'linear_k';
cal(count).input_channels = {'Acc Upper Arm X'};
cal(count).output_names = {'Acc_Upper_Arm_X'};
cal(count).output_units = {'m/s^2'}; 
cal(count).type = 'slope_offset';
cal(count).data.slope = 4.527/1000;
cal(count).data.offset = 0;
cal(count).data.SN = 'LW12618 '; % Instrument SN. Slope and offset are from the calibration of this instrument

count = count + 1;
cal(count).type = 'linear_k';
cal(count).input_channels = {'Acc Upper Arm Y Filt'};
cal(count).output_names = {'Acc_Upper_Arm_Y_Filt'};
cal(count).output_units = {'m/s^2'}; 
cal(count).type = 'slope_offset';
cal(count).data.slope = 4.510/1000;
cal(count).data.offset = 0;
cal(count).data.SN = 'LW12618 '; % Instrument SN. Slope and offset are from the calibration of this instrument

count = count + 1;
cal(count).type = 'linear_k';
cal(count).input_channels = {'Acc Upper Arm Y'};
cal(count).output_names = {'Acc_Upper_Arm_Y'};
cal(count).output_units = {'m/s^2'}; 
cal(count).type = 'slope_offset';
cal(count).data.slope = 4.510/1000;
cal(count).data.offset = 0;
cal(count).data.SN = 'LW12618 '; % Instrument SN. Slope and offset are from the calibration of this instrument

count = count + 1;
cal(count).type = 'linear_k';
cal(count).input_channels = {'Acc Upper Arm Z Filt'};
cal(count).output_names = {'Acc_Upper_Arm_Z_Filt'};
cal(count).output_units = {'m/s^2'}; 
cal(count).type = 'slope_offset';
cal(count).data.slope = 4.519/1000;
cal(count).data.offset = 0;
cal(count).data.SN = 'LW12618 '; % Instrument SN. Slope and offset are from the calibration of this instrument

count = count + 1;
cal(count).type = 'linear_k';
cal(count).input_channels = {'Acc Upper Arm Z'};
cal(count).output_names = {'Acc_Upper_Arm_Z'};
cal(count).output_units = {'m/s^2'}; 
cal(count).type = 'slope_offset';
cal(count).data.slope = 4.519/1000;
cal(count).data.offset = 0;
cal(count).data.SN = 'LW12618 '; % Instrument SN. Slope and offset are from the calibration of this instrument

%% Lower Arm
count = count + 1;
cal(count).type = 'linear_k';
cal(count).input_channels = {'Acc Lower Arm X Filt'};
cal(count).output_names = {'Acc_Lower_Arm_X_Filt'};
cal(count).output_units = {'m/s^2'}; 
cal(count).type = 'slope_offset';
cal(count).data.slope = 4.526/1000;
cal(count).data.offset = 0;
cal(count).data.SN = 'LW12717 '; % Instrument SN. Slope and offset are from the calibration of this instrument

count = count + 1;
cal(count).type = 'linear_k';
cal(count).input_channels = {'Acc Lower Arm X'};
cal(count).output_names = {'Acc_Lower_Arm_X'};
cal(count).output_units = {'m/s^2'}; 
cal(count).type = 'slope_offset';
cal(count).data.slope = 4.526/1000;
cal(count).data.offset = 0;
cal(count).data.SN = 'LW12717 '; % Instrument SN. Slope and offset are from the calibration of this instrument

count = count + 1;
cal(count).type = 'linear_k';
cal(count).input_channels = {'Acc Lower Arm Y Filt'};
cal(count).output_names = {'Acc_Lower_Arm_Y_Filt'};
cal(count).output_units = {'m/s^2'}; 
cal(count).type = 'slope_offset';
cal(count).data.slope = 4.509/1000;
cal(count).data.offset = 0;
cal(count).data.SN = 'LW12717 '; % Instrument SN. Slope and offset are from the calibration of this instrument

count = count + 1;
cal(count).type = 'linear_k';
cal(count).input_channels = {'Acc Lower Arm Y'};
cal(count).output_names = {'Acc_Lower_Arm_Y'};
cal(count).output_units = {'m/s^2'}; 
cal(count).type = 'slope_offset';
cal(count).data.slope = 4.509/1000;
cal(count).data.offset = 0;
cal(count).data.SN = 'LW12717 '; % Instrument SN. Slope and offset are from the calibration of this instrument

count = count + 1;
cal(count).type = 'linear_k';
cal(count).input_channels = {'Acc Lower Arm Z Filt'};
cal(count).output_names = {'Acc_Lower_Arm_Z_Filt'};
cal(count).output_units = {'m/s^2'}; 
cal(count).type = 'slope_offset';
cal(count).data.slope = 4.515/1000;
cal(count).data.offset = 0;
cal(count).data.SN = 'LW12717 '; % Instrument SN. Slope and offset are from the calibration of this instrument

count = count + 1;
cal(count).type = 'linear_k';
cal(count).input_channels = {'Acc Lower Arm Z'};
cal(count).output_names = {'Acc_Lower_Arm_Z'};
cal(count).output_units = {'m/s^2'}; 
cal(count).type = 'slope_offset';
cal(count).data.slope = 4.515/1000;
cal(count).data.offset = 0;
cal(count).data.SN = 'LW12717 '; % Instrument SN. Slope and offset are from the calibration of this instrument


%% Upper Winglet 
count = count + 1;
cal(count).type = 'linear_k';
cal(count).input_channels = {'Acc Winglet X Filt'};
cal(count).output_names = {'Acc_Winglet_X_Filt'};
cal(count).output_units = {'m/s^2'}; 
cal(count).type = 'slope_offset';
cal(count).data.slope = 2.72/1000;
cal(count).data.offset = 0;%8/1000;
cal(count).data.SN = 'LW13646'; % Instrument SN. Slope and offset are from the calibration of this instrument

count = count + 1;
cal(count).type = 'linear_k';
cal(count).input_channels = {'Acc Winglet X'};
cal(count).output_names = {'Acc_Winglet_X'};
cal(count).output_units = {'m/s^2'}; 
cal(count).type = 'slope_offset';
cal(count).data.slope = 2.72/1000;
cal(count).data.offset = 0;%8/1000;
cal(count).data.SN = 'LW13646'; % Instrument SN. Slope and offset are from the calibration of this instrument

count = count + 1;
cal(count).type = 'linear_k';
cal(count).input_channels = {'Acc Winglet Y Filt'};
cal(count).output_names = {'Acc_Winglet_Y_Filt'};
cal(count).output_units = {'m/s^2'}; 
cal(count).type = 'slope_offset';
cal(count).data.slope = 2.71/1000;
cal(count).data.offset = 0;%6.3/1000;
cal(count).data.SN = 'LW13646'; % Instrument SN. Slope and offset are from the calibration of this instrument

count = count + 1;
cal(count).type = 'linear_k';
cal(count).input_channels = {'Acc Winglet Y'};
cal(count).output_names = {'Acc_Winglet_Y'};
cal(count).output_units = {'m/s^2'}; 
cal(count).type = 'slope_offset';
cal(count).data.slope = 2.71/1000;
cal(count).data.offset = 0;%6.3/1000;
cal(count).data.SN = 'LW13646'; % Instrument SN. Slope and offset are from the calibration of this instrument

count = count + 1;
cal(count).type = 'linear_k';
cal(count).input_channels = {'Acc Winglet Z Filt'};
cal(count).output_names = {'Acc_Winglet_Z_Filt'};
cal(count).output_units = {'m/s^2'}; 
cal(count).type = 'slope_offset';
cal(count).data.slope = 2.71/1000;
cal(count).data.offset = 0;%10.4/1000;
cal(count).data.SN = 'LW13646'; % Instrument SN. Slope and offset are from the calibration of this instrument

count = count + 1;
cal(count).type = 'linear_k';
cal(count).input_channels = {'Acc Winglet Z'};
cal(count).output_names = {'Acc_Winglet_Z'};
cal(count).output_units = {'m/s^2'}; 
cal(count).type = 'slope_offset';
cal(count).data.slope = 2.71/1000;
cal(count).data.offset = 0;%10.4/1000;
cal(count).data.SN = 'LW13646'; % Instrument SN. Slope and offset are from the calibration of this instrument

%% Save
save(fullfile(savePath,saveName),'cal')



