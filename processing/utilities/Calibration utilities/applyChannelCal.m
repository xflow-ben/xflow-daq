function out = applyChannelCal(taskRaw,cal)
out.chanNames = cal.outputNames;

[data,time,samplePeriod,metaData] = extractChanData(taskRaw,cal.inputChannels,cal.outputNames);
out.time = time;
out.isRaw = zeros(size(cal.outputNames));
out.taskName = 'cal output';
out.samplePeriod = samplePeriod;
out.metaData = metaData;

switch cal.type
    case {'linear_k','multi_part_linear_k'}

        % multiply by k appropriately (should work for single avalue and square
        % and rectangular matricies)

        if strcmp(cal.type,'multi_part_linear_k')
            % k2 is used for all cal.data.split.input_channel values greater than cal.data.split.value
            % Otherwise use k1
            out.data = (cal.data.k1*data')';
            out.data_temp = (cal.data.k2*data')';
            ind = data(:,cal.data.split.input_channel)>cal.data.split.value;
            out.data(ind,:) = out.data_temp(ind,:);
        else
            out.data = (cal.data.k*data')';%raw*cal.data.k';
        end

    case 'slope_offset'
        % get the indicies of the dataColumns listed in cal.inputChannels
        % Grab out that data

        % do the conversion
        out.data = cal.data.slope*data + cal.data.offset;

    case 'counter_voltage_signal_basic'
        % get the indicies of the dataColumns listed in cal.inputChannels
        % Grab out that data
        timeStep = seconds(time(2) - time(1));

        % Inputs:
        %   voltageData - Array of voltage readings
        %   timeStep    - Time between samples (in seconds)
        %   windowSize  - Size of the time window for averaging (in seconds)
        %   threshold   - Voltage threshold for detecting transitions

        % Number of samples per window
        samplesPerWindow = floor(cal.data.windowSize / timeStep);

        % Half window size in samples
        halfWindowSamples = floor(samplesPerWindow / 2);

        % Initialize wind speed vector (same length as voltageData)
        out.data = zeros(length(data), 1);  % No NaNs, initialize with zeros

        % Loop through each data point in voltageData
        for i = 1:length(data)
            % Determine the window range for the current point
            startIdx = max(1, i - halfWindowSamples);  % Ensure within bounds
            endIdx = min(length(data), i + halfWindowSamples);  % Ensure within bounds

            % Check if the full window is available
            if startIdx == 1 || endIdx == length(data)
                % Use the first valid value for start edge or last valid for end edge
                continue;  % Skip processing for edges for now
            end

            % Extract the voltage data for the current window
            windowData = data(startIdx:endIdx);

            % Detect rising edges in the current window
            isAboveThreshold = windowData > cal.data.threshold;
            risingEdges = diff(isAboveThreshold) == 1;
            count = sum(risingEdges);

            % Calculate the frequency (counts per second)
            frequency = count / cal.data.windowSize;

            % Convert frequency to wind speed using the calibration factors
            out.data(i) = cal.data.slope * frequency + cal.data.offset;
        end

        % Fill edge cases
        % Use the first valid value for the start edge
        firstValidValue = out.data(halfWindowSamples + 1);
        out.data(1:halfWindowSamples) = firstValidValue;

        % Use the last valid value for the end edge
        lastValidValue = out.data(end - halfWindowSamples);
        out.data(end - halfWindowSamples + 1:end) = lastValidValue;


    case 'rpm_voltage_signal'
        t = seconds(time - time(1));
        rate = 1/seconds(time(2)-time(1));

        [y, dydt, ddyddt] = process_counter_voltage_signal(t, data, ceil(cal.data.windowSize*rate), cal.data.threshold, rate, cal.data.slope);

        % create out.(field_names), where filed names are from cal.output_names
        out.data = [y, dydt, ddyddt];
    case 'rpm_resets'

        % save reset times here
        out.time = findResetRPM(data,time);
        out.data = NaN(size(out.time));
        out.isRaw = 1; % we want this to get removed later

    case 'encoder'
        % get the indicies of the dataColumns listed in cal.inputChannels
        % Grab out that data


        rate = 1/seconds(time(2)-time(1));



        [y,dy,ddy] = process_sf_enc(data);
        out.data = [y * (2*pi/cal.data.PPR),dy * rate * (2*pi/cal.data.PPR),ddy * rate^2 * (2*pi/cal.data.PPR)];
        out.isRaw(1) = 1; % this way this will be deleted later, as resetted theta will replace it

    case 'reset_encoder_via_rpm_sensor'

        [~,tr] = extractChanData(taskRaw,'resetTimes',cal.outputNames);

        tenc = time;
        theta = data;
        if theta(end) == 0
            theta(end) = NaN;
        end
        r_ind = 1;
        for i = 1:length(tr)
            % Skip if tr(i) is outside the range of tenc
            if tr(i) < tenc(1) || tr(i) > tenc(end)
                continue;
            end

            % Move j forward until tenc(j) is greater than or equal to tr(i)
            while r_ind < length(tenc) && tenc(r_ind) < tr(i)
                r_ind = r_ind + 1;
            end

            if ~isnan(theta(r_ind)) && ~isnan(theta(r_ind-1))
                % Check if tr(i) exactly matches tenc(j)
                if tr(i) == tenc(r_ind)
                    % Perform special operation when tr(i) == tenc(j)
                    theta(r_ind:end) = theta(r_ind:end) - theta(r_ind);
                else
                    % Store indices on either side of tr(i)
                    idx1 = r_ind - 1;
                    idx2 = r_ind;
                    theta_interp = theta(idx1) + (tr(i) - tenc(idx1)) * (theta(idx2) - theta(idx1)) / (tenc(idx2) - tenc(idx1));
                    theta(r_ind:end) = theta(r_ind:end) - theta_interp;
                end
            end

        end

        out.data = theta;
    otherwise
        error('%s is not a programmed calibration type',cal.type)
end

    function [data,time,samplePeriod,metaData] = extractChanData(taskRaw,inputChannels,outputNames)

        for j = 1:length(inputChannels)
            datalg = [];
            data = [];
            time = [];
            chanFound = 0;
            for k = 1:length(taskRaw)
                if any(strcmp(taskRaw(k).chanNames,inputChannels(j)))
                    chanFound = 1;
                    if isempty(datalg) % check to make sure data is same length
                        datalg = size(taskRaw(k).data,1);
                        time = taskRaw(k).time;

                        samplePeriod = taskRaw(k).samplePeriod; % not sure if
                        metaData = taskRaw(k).metaData;
                        % needed
                    elseif datalg ~= size(taskRaw(k).data,1)
                        error('Cal with first output name %s is requesting data from tasks of differing lengths',outputNames{1})
                    end
                    data(:,j) = taskRaw(k).data(:,find(strcmp(taskRaw(k).chanNames,inputChannels{j})));
                end
            end
            if chanFound == 0
                warning('Channel %s not found in the data, though requested by calibration',inputChannels{j});
            end
        end
    end

end

