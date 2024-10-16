function in = average_tare(in,tare)


% Tare is average of all the tare files

data_time_ind = find(strcmp(in.chanNames,'time'));

for data_ind = 1:length(in.chanNames)
    if data_ind == data_time_ind
        in.tare_applied(data_ind) = 0;
    else
        tare_ind = find(strcmp(in.chanNames{data_ind},tare.chanNames));
        if isempty(tare_ind)
            in.tare_applied(data_ind) = 0;
        else
            in.tare_applied(data_ind) = 1;
            in.data(:,data_ind) = in.data(:,data_ind) - mean(tare.data(:,tare_ind));
        end
    end
end