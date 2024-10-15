function consts = XFlow_Spanish_Fork_testing_constants()

%% DAQ
consts.DAQ.downsampled_rate = 512; % Rate to downsample data to [Hz]
%% Unit conversions
consts.units.lbf_to_N = 4.44822;
consts.units.inch_to_m = 0.0254;

%% Data files
consts.data.file_name_conventions = {...
    '*rotor_strain*.tdms',...
    '*rotorStrain*.tdms',...
    '*rotor_RTD*.tdms',...
    '*BladeRTDs*.tdms',...
    '*rotor_acc*.tdms',...
    '*gw_strain*.tdms',...
    '*nacelle_strain*.tdms',...
    '*nacelle_voltage*.tdms',...
    '*anno_1*.tdms',...
    '*anno_2*.tdms',...
    '*encoder*.tdms',...
    '*rpm_sensor*.tdms',...
    '*met_tower*.tdms'};

consts.data.default_rates = [...
    12.8e6/(256*31),...
    NaN,...
    4,...
    NaN,...
    20e6/round(20e6/4096),...
    12.8e6/(256*31),...
    12.8e6/(256*31),...
    20e6/round(20e6/4096),...
    20e6/round(20e6/4096),...
    20e6/round(20e6/4096),...
    20e6/round(20e6/4096),...
    NaN,...
    2000]; %NaNs are for file name conventions which should have their rates in ther tdms files

consts.data.save_types = {'td','sd'};
consts.data.N = 120; % sd averaging time [s], if is NaN, the entire file will be averaged

%% Tare function
consts.tare_func = @time_interped_tare;

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

consts.turb.A = 2* consts.rotor.outer_radius * consts.blade.span; % Rotor frontal area [m^2]
consts.turb.J = 1.7692e+04; % Rotor moment of inertia [kg-m] % calculated from inertia_7_28_2023_plain_extensions
% consts.turb.J = 1.5939e+04; % Rotor moment of inertia [kg-m] % calculated from low_wind_inertia_5_17_23

%% Guy wire foundations
% In nacelle-tower interfance coordiante system [m]
consts.foundation.E_GW__SW_bolt = [-16,-291.9]*consts.units.inch_to_m;  % x-y coordinates of east guy wire foundation, SW bolt point [m]
consts.foundation.S_GW__NE_bolt = [-294.4,-4]*consts.units.inch_to_m;  % x-y coordinates of south guy wire foundation, NE bolt point [m]
consts.foundation.S_GW__NW_bolt = [-294.4,4]*consts.units.inch_to_m;  % x-y coordinates of south guy wire foundation, NW bolt point [m]
consts.foundation.W_GW__SE_bolt = [-20.7,286.7]*consts.units.inch_to_m;  % x-y coordinates of west guy wire foundation, SE bolt point [m]
consts.foundation.N_GW__SW_bolt = [290.5,10.5]*consts.units.inch_to_m;  % x-y coordinates of north guy wire foundation, SW bolt point [m]
consts.foundation.N_GW__SE_bolt = [290.5,-10.5]*consts.units.inch_to_m;  % x-y coordinates of north guy wire foundation, SE bolt point [m]

%% Heights
consts.heights.tower_top = 618*consts.units.inch_to_m; 
consts.hub_height = 707.25*consts.units.inch_to_m;

%% Met tower
consts.met.primary_anemometer_height = 17.81; % Hub height anemomerter height [m]
consts.met.secondary_aneometer_height = 12.54; % Lower anemomerter height [m]
consts.met.mettowerdist = 50.3; % Met tower distance from rotor [m]
consts.met.metTowerDir = 155; % Met tower-wind turbine vector compass direction [deg]
consts.met.R = 287.05; % specific gas constant for dry air [J/kg-K]

end

