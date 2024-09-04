clear all
close all
clc

rotorSegFXPath = 'C:\Users\Ben Strom\Documents\Loads_Data\load_calibrations\rotor_segment\rotor_segment_center_Fx';

files = dir(fullfile(rotorSegFXPath,'*rotorStrain*.tdms'));

consts.lbf_to_N = 4.44822;

upperArmSpan = 5.49192071; %Distance from hub face to arm-blade hinge, along 0.3 chord spanwise arm line [m]
upperArmAngle = 25.9; %deg
momentDistance = upperArmSpan*cosd(upperArmAngle)

lowerArmSpan = 5.61304498; %Distance from hub face to arm-blade hinge, along 0.3 chord spanwise arm line [m]
lowerArmAngle = -28.34; %deg


for II =1:length(files)
    TDMS = readTDMS(files(II).name,rotorSegFXPath);
    d = convertTDMStoXFlowFormat(TDMS);

    ind1 = find(strcmp(d.chanNames,'Lower Arm My'));
    ind2 = find(strcmp(d.chanNames,'Upper Arm My'));

    load('C:\Users\Ben Strom\Documents\Coding\xfedaq\xflow-daq\processing\implementations\10m_Spanish_Fork_testing\Calibrations\Results\lower_arm_cal_single_axis_struct.mat')
    k_ind1 = find(strcmp([cal_single.output_names],'Lower_Arm_My'));

    load('C:\Users\Ben Strom\Documents\Coding\xfedaq\xflow-daq\processing\implementations\10m_Spanish_Fork_testing\Calibrations\Results\upper_arm_cal_single_axis_struct.mat')
    k_ind2 = find(strcmp([cal_single.output_names],'Upper_Arm_My'));

    lowerV(II) = median(d.data(:,ind1));
    lower(II) = cal_single(k_ind1).data.k*lowerV(II)*cosd(lowerArmAngle);

    upperV(II) = median(d.data(:,ind2));
    upper(II) = cal_single(k_ind2).data.k*upperV(II)*cosd(upperArmAngle);

    measured(II) = - lower(II) + upper(II);

    applied_load_ind = find(strcmp({TDMS.property.name},'Applied_Load'));
    TDMS.property(applied_load_ind).value
    applied_load(II) = consts.lbf_to_N*str2double(TDMS.property(applied_load_ind).value)*momentDistance;

end
tare = median(measured(applied_load==0));
%%
plot(applied_load,measured-tare,'o')
hold on
x = [min(applied_load),max(applied_load)];
plot(x,x,'--k')