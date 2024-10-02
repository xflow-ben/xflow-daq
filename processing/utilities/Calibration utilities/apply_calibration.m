function out = apply_calibration(data,dataColumns,cal)

if strcmp(cal.type,'linear_k') || strcmp(cal.type,'multi_part_linear_k')

    % get the indicies of the dataColumns listed in cal.input_channels
    % Grab out that data
    for i = 1:length(cal.input_channels)
        ind = flexibleStrCmp(dataColumns,cal.input_channels(i));
        if sum(ind) == 0
            error('The desired input channels are not in the data provided.')
        end
        raw(:,i) = data(:,ind);
    end
    % multiply by k appropriately (should work for single avalue and square
    % and rectangular matricies)

    if strcmp(cal.type,'multi_part_linear_k')
        % k2 is used for all cal.data.split.input_channel values greater than cal.data.split.value
        % Otherwise use k1
        result = (cal.data.k1*raw')';
        result_temp = (cal.data.k2*raw')';
        ind = raw(:,cal.data.split.input_channel)>cal.data.split.value;
        result(ind,:) = result_temp(ind,:);
    else
        result = (cal.data.k*raw')';%raw*cal.data.k';
    end
    % create out.(field_names), where filed names are from cal.output_names
    for i = 1:length(cal.output_names)
        out.(cal.output_names{i}) = result(:,i);
    end
elseif strcmp(cal.type,'slope_offset')
    % get the indicies of the dataColumns listed in cal.input_channels
    % Grab out that data
    if length(cal.input_channels) ~= 1 || length(cal.output_names) ~= 1
        error('Slope-offset calibration only works with a single input and output channel')
    end
    ind = flexibleStrCmp(dataColumns,cal.input_channels);

    % do the conversion
    result = cal.data.slope*data(:,ind) + cal.data.offset;

    % create out.(field_names), where filed names are from cal.output_names
    out.(cal.output_names{1}) = result;

elseif strcmp(cal.type,'counter_voltage_signal')
    % get the indicies of the dataColumns listed in cal.input_channels
    % Grab out that data
    if length(cal.input_channels) ~= 1 || length(cal.output_names) ~= 1
        error('counter voltage signal calibration only works with a single input and output channel')
    end
    ind = flexibleStrCmp(dataColumns,cal.input_channels);
    ind_time = flexibleStrCmp(dataColumns,'time');

    voltageData = data(:,ind);
    timeStep = mean(diff(data(:,ind_time)));

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
    result = nan(length(voltageData), 1);

    % Loop through each data point in voltageData
    for i = 1:length(voltageData)
        % Determine the window range for the current point
        startIdx = i - halfWindowSamples;
        endIdx = i + halfWindowSamples;

        % If the window is within bounds, process it
        if startIdx > 0 && endIdx <= length(voltageData)
            % Extract the voltage data for the current window
            windowData = voltageData(startIdx:endIdx);

            % Detect rising edges in the current window
            isAboveThreshold = windowData > cal.data.threshold;
            risingEdges = diff(isAboveThreshold) == 1;
            count = sum(risingEdges);

            % Calculate the frequency (counts per second)
            frequency = count / cal.data.windowSize;

            % Convert frequency to wind speed using the calibration factors
            result(i) = cal.data.slope * frequency + cal.data.offset;
        end
    end

     % create out.(field_names), where filed names are from cal.output_names
    out.(cal.output_names{1}) = result;
else
    error(sprintf('%s is not a programmed calibration type',cal.type))
end

% add other cal.type's here as we need them (examples: slope-offset form,
% nonlinear function, etc.)