function in = time_interped_tare(in,tare)


%% Time interp tare
% tare are applied such that:
% 1) If the data is before or after all tares just apply the closest tare
% in time
% 2) If the data is between tares, linearly intrpolate

data_time_ind = find(strcmp(in.chanNames,'time'));
tare_time_ind = find(strcmp(tare.chanNames,'time'));

for data_ind = 1:length(in.chanNames)
    if data_ind == data_time_ind
        in.tare_applied(data_ind) = 0;
    else
        tare_ind = find(strcmp(in.chanNames{data_ind},tare.chanNames));
        if isempty(tare_ind)
            in.tare_applied(data_ind) = 0;
        else
            in.tare_applied(data_ind) = 1;
            if size(tare.data,1) == 1
                in.data(:,data_ind) = in.data(:,data_ind) - tare.data(tare_ind);
            else
                in.data(:,data_ind) = in.data(:,data_ind) - ...
                    interp1_with_closest_extrap(tare.data(:,tare_time_ind), tare.data(:,tare_ind), in.data(:,data_time_ind));
            end
        end
    end
end