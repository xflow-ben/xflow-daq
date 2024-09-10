function [calib,crosstalk] = calibration_matrix_inputs__low_arm_root_My(consts)

moment_distance = 5.61304498; % Distance from hub face to lower arm-blade hinge, along 0.3 chord spanwise arm line [m]

%% Crosstalk grouping high level info
crosstalk.loads_names = {'Lower_Arm_My'}; % Names of physical loads of intrest which are applied during calibrations
crosstalk.channel_names = {'Lower Arm My'}; % Names of load channels of intrest
calibNum = 0; % Initiate counting varible


%% Calibration of Lower Arm Root +My Info
calibNum = calibNum + 1;
calib(calibNum).folder = 'Lower_arm_+My';
calib(calibNum).applied_load_scaling = consts.lbf_to_N*moment_distance;
calib(calibNum).output_units = 'N-m'; 

%% Calibration of Lower Arm Root +My Info
calibNum = calibNum + 1;
calib(calibNum).folder = 'Lower_arm_-My';
calib(calibNum).applied_load_scaling = -consts.lbf_to_N*moment_distance;
calib(calibNum).output_units = 'N-m'; 

