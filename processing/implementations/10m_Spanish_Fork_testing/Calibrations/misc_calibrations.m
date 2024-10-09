clear all
close all
clc


savePath = fullfile(fileparts(mfilename('fullpath')),'Results');
saveName = 'misc_calibrations';
count = 0;

%% Time
count = count + 1;
cal(count).type = 'linear_k';
cal(count).data.k = 1;
cal(count).input_channels = {'time'};
cal(count).output_names = {'Time'};
cal(count).output_units = {'s'};

%% Save
save(fullfile(savePath,saveName),'cal')



