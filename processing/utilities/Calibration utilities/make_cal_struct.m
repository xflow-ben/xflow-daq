function make_cal_struct(path,cal_names)
% Combine calibration structs from different instruments

for II = 1:length(cal_names)
    temp = load(fullfile(path,[cal_names{II},'.mat']));
    field = fieldnames(temp);
    if II == 1
        % Initialize the cal struct with the first loaded calibration
        cal = temp.(field{1});
        % Merge aditional calibrations in the first loaded file
        for JJ = 2:length(field)
            cal = [cal temp.(field{JJ})];
        end
    else
        % Merge aditional calibrations
        for JJ = 1:length(field)
            cal = [cal temp.(field{JJ})];
        end
    end
end

save(fullfile(path,['cal_struct_',datestr(datetime('now'), 'dd_mm_yy')]),'cal')
% We  programatically put today's date into the cal file name so that it
% does not overwrite making old ones are available for use with older data


