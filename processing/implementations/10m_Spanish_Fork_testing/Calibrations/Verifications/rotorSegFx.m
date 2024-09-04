clear all
close all
clc

rotorSegFXPath = 'C:\Users\Ben Strom\Documents\Loads_Data\load_calibrations\rotor_segment\rotor_segment_center_Fx';

files = dir(fullfile(rotorSegFXPath,'*rotorStrain*.tdms'));

consts.lbf_to_N = 4.44822;


for II =1:length(files)
    TDMS = readTDMS(files(II).name,rotorSegFXPath);
    d = convertTDMStoXFlowFormat(TDMS);

    ind1 = find(strcmp(d.chanNames,'Lower Yoke Fx'));
    load('C:\Users\Ben Strom\Documents\Coding\xfedaq\xflow-daq\processing\implementations\10m_Spanish_Fork_testing\Calibrations\Results\lower_arm_cal_single_axis_struct.mat')
    k_ind1 = find(strcmp([cal_single.output_names],'Lower_Yoke_Fx'));
    lowerYokeFx = cal_single(k_ind1).data.k*median(d.data(:,ind1));

    ind2 = find(strcmp(d.chanNames,'Upper Yoke Fx'));
    load('C:\Users\Ben Strom\Documents\Coding\xfedaq\xflow-daq\processing\implementations\10m_Spanish_Fork_testing\Calibrations\Results\upper_arm_cal_single_axis_struct.mat')
    k_ind2 = find(strcmp([cal_single.output_names],'Upper_Yoke_Fx'));
    upperYokeFx = cal_single(k_ind2).data.k*median(d.data(:,ind2));

    measuredFX(II) = lowerYokeFx + upperYokeFx;

    applied_load_ind = find(strcmp({TDMS.property.name},'Applied_Load'));
    applied_load(II) = consts.lbf_to_N*str2double(TDMS.property(applied_load_ind).value);

end
tare = median(measuredFX(applied_load==0));
%%
plot(applied_load,measuredFX-tare,'o')
hold on
x = [min(applied_load),max(applied_load)];
plot(x,x,'--k')