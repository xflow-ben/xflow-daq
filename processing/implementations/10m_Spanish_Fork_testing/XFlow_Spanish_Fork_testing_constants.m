function consts = XFlow_Spanish_Fork_testing_constants()

%% Unit conversions
consts.units.lbf_to_N = 4.44822;
consts.units.inch_to_m = 0.0254;

%% ata files
consts.data.data_file_name_conventions = {'guy_wire_cal_towerBaseStrain*.tdms',...
    'full_hub_test_rotorStrain*.tdms',...
    'lower_arm_cal_rotorStrain*.tdms',...
    'upper_arm_cal_rotorStrain*.tdms'};

%% Calibration
consts.cali.arm_moment_distance = 32*consts.units.inch_to_m;
consts.cali.jig_thickness = (1.375+1/32)*consts.units.inch_to_m; % Thickness of load application jig used for rotor segment calibrations [m]

%% Gage locations
consts.guages.blade_center_to_guage_distance = 0.635; % distance from blade center to guage location in the direction of the upper joint [m]

%% Rotor geometry
consts.blade.span = 10.540; % Blade span [m]
consts.blade.span_minus_wignlets = 9.540; % Blade span minus the winglets [m]
consts.blade.pitch_25 = 2.27; %Blade angle pitch angle at 0.25 chord [deg]
consts.blade.pitch_30 = 2; %Blade angle pitch angle at 0.3 chord [deg]

consts.upperArm.span = 5.49192071; %Distance from hub face to arm-blade hinge, along 0.3 chord spanwise arm line [m]
consts.upperArm.angle = 25.9; % Arm angle, from horizontal plane [deg]

consts.lowerArm.span = 5.61304498; % Distance from hub face to arm-blade hinge, along 0.3 chord spanwise arm line [m]
consts.lowerArm.angle = -28.34; % Arm angle, from horizontal plane [deg]

consts.rotor.chord = 0.5; % Blade and arm chord [m]
consts.rotor.radius = 5.27050000; % Radius from center axis to 0.3c span line of blade [m]
consts.rotor.outer_radius = 5.3159532; % Radius from center axis to outermost part of blade [m]
consts.rotor.arm_seperation = 0.29178352; % istance between intersections of arm 0.3 chord span lines and center axis [m] 

% Calculated values
consts.blade.hinge_to_hinge_distance = consts.rotor.arm_seperation ...
    + consts.rotor.radius*(tand(consts.upperArm.angle)+tand(-consts.lowerArm.angle)); % Blade span between the hinges [m]
consts.blade.overhang = (consts.blade.span - consts.blade.hinge_to_hinge_distance)/2; % Blade span from hinge to the end of the winglet [m]
consts.blade.overhang_without_winglets = (consts.blade.span_minus_wignlets - consts.blade.hinge_to_hinge_distance)/2; % Blade span from the hinge to the end of the pultrusion [m]

consts.turb.A = consts.rotor.outer_radius * consts.blade.span; % Rotor frontal area [m^2]
end

