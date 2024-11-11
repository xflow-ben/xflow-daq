function results = calibrate_data(cal,in)
% cal is an array of calibration structs

%% Apply calibrations
% loop through the cal structs here. This should take care of the majority
% of the data conversion
results.tare_applied = in.tare_applied;
results.cal_applied = zeros(size(in.chanNames)); % initialize
results.chanNames = in.chanNames;
results.rate = in.rate;

for II = 1:length(cal)
    % Check is data is avalible for ALL relevant input channels
    flag = 1;
    data_ind = [];
    for JJ = 1:length(cal(II).input_channels)
        temp = find(strcmp(cal(II).input_channels{JJ},in.chanNames));
        if isempty(temp)
            flag = 0;
        elseif length(temp) > 1
            error(sprintf('Input channel %s is found twice in data',strcmp(cal(II).input_channels{JJ})))
        else
            data_ind(JJ) = temp;
        end
    end

    % Apply calibration if data is avalible for ALL relevant input channels
    % (flag = 1)
    if flag
        temp = apply_calibration(in.data,in.chanNames,cal(II));
        fields = fieldnames(temp);
        for JJ = 1:length(fields) % make sure this works properly
            td.(fields{JJ}) = temp.(fields{JJ});
        end
        results.cal_applied(data_ind) = ones(size(data_ind));
    end
end

% % Copy uncalibrated data to the results array
% uncalibrated_ind = find(results.cal_applied == 0);
% for II = 1:length(uncalibrated_ind)
%     td.not_calibrated.(strrep(results.chanNames{uncalibrated_ind(II)},' ','_')) = in.data(:,uncalibrated_ind(II));
% end

%% Put td in export struct 
results.td = td;
end