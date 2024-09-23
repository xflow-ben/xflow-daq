clear all
close all
clc

rotorSegFXPath = 'X:\Experiments and Data\20 kW Prototype\Loads_Data\load_calibrations\rotor_segment\rotor_segment_upper_+Fz';

files = dir(fullfile(rotorSegFXPath,'*rotorStrain*.tdms'));

consts.lbf_to_N = 4.44822;

upperArmSpan = 5.49192071; %Distance from hub face to arm-blade hinge, along 0.3 chord spanwise arm line [m]
upperArmAngle = 25.9; %deg
momentDistance = upperArmSpan*cosd(upperArmAngle);

lowerArmSpan = 5.61304498; %Distance from hub face to arm-blade hinge, along 0.3 chord spanwise arm line [m]
lowerArmAngle = -28.34; %deg


for II =1:length(files)
    TDMS = readTDMS(files(II).name,rotorSegFXPath);
    d = convertTDMStoXFlowFormat(TDMS);

    ind1 = find(strcmp(d.chanNames,'Lower Yoke Fz'));
    load('C:\Users\Ian\Documents\GitHub\xflow-daq\processing\implementations\10m_Spanish_Fork_testing\Calibrations\Results\lower_arm_cal_single_axis_struct.mat')
    k_ind1 = find(strcmp([cal_single.output_names],'Lower_Yoke_Fz'));
    lowerYokeFz_preTare(II) = cal_single(k_ind1).data.k*median(d.data(:,ind1))

    ind2 = find(strcmp(d.chanNames,'Upper Yoke Fz'));
    load('C:\Users\Ian\Documents\GitHub\xflow-daq\processing\implementations\10m_Spanish_Fork_testing\Calibrations\Results\upper_arm_cal_single_axis_struct.mat')
    k_ind2 = find(strcmp([cal_single.output_names],'Upper_Yoke_Fz'));
    upperYokeFz_preTare(II) = cal_single(k_ind2).data.k*median(d.data(:,ind2));

    ind3 = find(strcmp(d.chanNames,'Lower Arm Mx'));
    load('C:\Users\Ian\Documents\GitHub\xflow-daq\processing\implementations\10m_Spanish_Fork_testing\Calibrations\Results\lower_arm_cal_single_axis_struct.mat')
    k_ind3 = find(strcmp([cal_single.output_names],'Lower_Arm_Mx'));
    lowerArmMx_preTare(II) = cal_single(k_ind3).data.k*median(d.data(:,ind3));

    ind4 = find(strcmp(d.chanNames,'Upper Arm Mx'));
    load('C:\Users\Ian\Documents\GitHub\xflow-daq\processing\implementations\10m_Spanish_Fork_testing\Calibrations\Results\upper_arm_cal_single_axis_struct.mat')
    k_ind4 = find(strcmp([cal_single.output_names],'Upper_Arm_Mx'));
    upperArmMx_preTare(II) = cal_single(k_ind4).data.k*median(d.data(:,ind4));

    applied_load_ind = find(strcmp({TDMS.property.name},'Applied_Load'));
    TDMS.property(applied_load_ind).value
    applied_load(II) = consts.lbf_to_N*str2double(TDMS.property(applied_load_ind).value);
end

%% Remove tares
ind_tare = applied_load==0;
lowerYokeFz = lowerYokeFz_preTare - median(lowerYokeFz_preTare(ind_tare));
upperYokeFz = upperYokeFz_preTare - median(upperYokeFz_preTare(ind_tare));
lowerArmMx = lowerArmMx_preTare - median(lowerArmMx_preTare(ind_tare));
upperArmMx = upperArmMx_preTare - median(upperArmMx_preTare(ind_tare));


%% Calc
measured =  -upperArmMx/(upperArmSpan)*cosd(upperArmAngle)-lowerArmMx/(lowerArmSpan)*cosd(lowerArmAngle)...
    +upperYokeFz*sind(upperArmAngle)+lowerYokeFz*sind(lowerArmAngle);


%% Plot
plot(applied_load,measured,'o')
hold on
x = [min(applied_load),max(applied_load)];
plot(x,x,'--k')