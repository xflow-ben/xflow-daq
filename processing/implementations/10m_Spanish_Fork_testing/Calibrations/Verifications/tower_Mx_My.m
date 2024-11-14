clear all
close all
clc

%% Common inputs
verify.consts = XFlow_Spanish_Fork_testing_constants();

% verify.data.physical_loads = {'Tower_Top_Fx','Tower_Top_Fy','Tower_Top_Mx','Tower_Top_My'};
verify.data.absolute_cali_path = 'C:\Users\Ian\Documents\GitHub\xflow-daq\processing\implementations\10m_Spanish_Fork_testing\Calibrations\Results\cal_struct_11_10_24.mat';


%% 
verify.absolute_data_path = 'X:\Experiments and Data\20 kW Prototype\Loads_Data\load_calibrations\installed_rotor';
verify.tdms_filter = '*rotor_strain*.tdms';
verify.applied_load_var_name = 'appliedLoad';
verify.relative_data_folder = '-Z_pos_1';

%%%%%%%%%%%%%%%%%%
files = dir(fullfile(verify.absolute_data_path,verify.relative_data_folder,verify.tdms_filter));

if isempty(files)
    error(sprintf('No files with the format %s found in %s',verify.tdms_filter,fullfile(verify.absolute_data_path,verify.relative_data_folder)))
end

%% Extract applied load
% This is done first so we can generate the tare list when using
% process_data_folder
for II =1:length(files)
    TDMS = readTDMS(files(II).name,fullfile(verify.absolute_data_path,verify.relative_data_folder));
    d = convertTDMStoXFlowFormat(TDMS);

    applied_load_ind = find(strcmp({TDMS.property.name},verify.applied_load_var_name));
    applied_load(II) = str2double(TDMS.property(applied_load_ind).value);
end

%% Create tareList in the data directory
tareList = {files(applied_load == 0).name};
save(fullfile(verify.absolute_data_path,verify.relative_data_folder,'tareList.mat'),'tareList')

%% Process data folder
files = struct;
files.absolute_data_dir = '';
files.relative_experiment_dir =  fullfile(verify.absolute_data_path,verify.relative_data_folder); % This is relative to files.absolute_data_dir
files.relative_tare_dir = files.relative_experiment_dir; % This is relative to files.absolute_data_dir

load(verify.data.absolute_cali_path)
results = process_data_folder(files,cal,verify.consts);
results.td = calculate_XFlow_Spanish_Fork_quantities(results.td,verify.consts);
results = calculate_sd(results,verify.consts);

%% Cleanup figure
figure(fh1)
title('Rotor Segment My')
x = [-3000 4000];
plot(x,x,'--k')
legend('Rotor Segment on Ground','Rotor Raised, -X', 'Rotor Raised, +X','Location','SouthEast')
xlabel('Applied Load')
ylabel('Measured Load')
grid on
box on
