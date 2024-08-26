function data = process_all_chan_calib(d,calib,crosstalk)
% Extract data
for i = 1:length(crosstalk.loads_names)
    data.load.(crosstalk.loads_names{i}) = [d.([crosstalk.loads_names{i},'_load'])];
end

% Determine tare indices and remove force = 0 vales
tare_inds = find(data.load.(crosstalk.loads_names{calib.loads.being_calibrated==1}) == 0);
for i = 1:length(crosstalk.loads_names)
    data.load.(crosstalk.loads_names{i})(tare_inds) = [];
end

% loop through strain guage measurments channels
for chan_ind = 1:length(d(1).ch_names)

    % extract the straign guage voltage and time for each measurment
    for i = 1:length(d)
        volts(i) = d(i).median(chan_ind);
        time(i) = d(i).mid_time;
    end

    % extract the voltage and time values at each tare
    tare_volts = volts(tare_inds);
    tare_time = time(tare_inds);

    % remove tare values from the voltage and time array
    volts(tare_inds) = [];
    time(tare_inds) = [];

    % calculate the voltage and deflection with the tare removed
    str = [d(1).ch_names{chan_ind}];
    output_name = replace(str, ' ', '_');
    data.volts.(output_name) = volts - interp1(tare_time,tare_volts,time);

end
end