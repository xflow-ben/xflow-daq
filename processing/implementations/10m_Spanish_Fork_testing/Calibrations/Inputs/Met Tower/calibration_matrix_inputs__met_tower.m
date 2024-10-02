function cal = calibration_matrix_inputs__met_tower()

count = 0;

count = count + 1;
cal(count).input_channels = {'Primary'}; % Names of load channels of intrest
cal(count).output_names = {'U_primary'}; % Names of physical loads of intrest which are applied during calibrations
cal(count).output_units = {'m/s'}; % Units of load channels after calibration
cal(count).type = 'counter_voltage_signal';
cal(count).data.slope = 0.04632;
cal(count).data.offset = 0.21886;
cal(count).data.SN = '7101909'; % Instrument SN. Slope and offset are from the calibration of this instrument
cal(count).data.threshold = 5; % Voltage threshold for detecting transitions
cal(count).data.windowSize = 1; % Size of the time window for averaging (in seconds)

count = count + 1;
cal(count).input_channels = {'Secondary'}; % Names of load channels of intrest
cal(count).output_names = {'U_secondary'}; % Names of physical loads of intrest which are applied during calibrations
cal(count).output_units = {'m/s'}; % Units of load channels after calibration
cal(count).type = 'counter_voltage_signal';
cal(count).data.slope = 0.04638;
cal(count).data.offset = 0.21212;
cal(count).data.threshold = 5; % Voltage threshold for detecting transitions
cal(count).data.windowSize = 1; % Size of the time window for averaging (in seconds)

cal(count).data.SN = '7101906'; % Instrument SN. Slope and offset are from the calibration of this instrument

count = count + 1;
cal(count).input_channels = {'TowerBot'}; % Names of load channels of intrest
cal(count).output_names = {'U_TowerBot'}; % Names of physical loads of intrest which are applied during calibrations
cal(count).output_units = {'m/s'}; % Units of load channels after calibration
cal(count).type = 'slope_offset';
cal(count).data.slope = 0.0464;
cal(count).data.offset = 0.20932;
cal(count).data.SN = '7101907'; % Instrument SN. Slope and offset are from the calibration of this instrument

count = count + 1;
cal(count).input_channels = {'TowerAnno'}; % Names of load channels of intrest
cal(count).output_names = {'U_TowerAnno'}; % Names of physical loads of intrest which are applied during calibrations
cal(count).output_units = {'m/s'}; % Units of load channels after calibration
cal(count).type = 'slope_offset';
cal(count).data.slope = 0.04645;
cal(count).data.offset = 0.21033;
cal(count).data.SN = '2132408'; % Instrument SN. Slope and offset are from the calibration of this instrument

count = count + 1;
cal(count).input_channels = {'Vertical'}; % Names of load channels of intrest
cal(count).output_names = {'W'}; % Names of physical loads of intrest which are applied during calibrations
cal(count).output_units = {'m/s'}; % Units of load channels after calibration
cal(count).type = 'slope_offset';
cal(count).data.slope = 18;
cal(count).data.offset = 0;

count = count + 1;
cal(count).input_channels = {'WDir'}; % Names of load channels of intrest
cal(count).output_names = {'Dir'}; % Names of physical loads of intrest which are applied during calibrations
cal(count).output_units = {'deg'}; % Units of load channels after calibration
cal(count).type = 'slope_offset';
cal(count).data.slope = 72;
cal(count).data.offset = 0;
cal(count).data.SN = 'X26015'; % Instrument SN. Slope and offset are from the calibration of this instrument

count = count + 1;
cal(count).input_channels = {'Pressure'}; % Names of load channels of intrest
cal(count).output_names = {'press'}; % Names of physical loads of intrest which are applied during calibrations
cal(count).output_units = {'kPa'}; % Units of load channels after calibration
cal(count).type = 'slope_offset';
cal(count).data.slope = 23.996;
cal(count).data.offset = 50.015;
cal(count).data.SN = 'L5020067'; % Instrument SN. Slope and offset are from the calibration of this instrument

count = count + 1;
cal(count).input_channels = {'Temperature'}; % Names of load channels of intrest
cal(count).output_names = {'temp'}; % Names of physical loads of intrest which are applied during calibrations
cal(count).output_units = {'°C'}; % Units of load channels after calibration
cal(count).type = 'slope_offset';
cal(count).data.slope = 1;
cal(count).data.offset = -2.98;
cal(count).data.SN = '1028-9'; % Instrument SN. Slope and offset are from the calibration of this instrument