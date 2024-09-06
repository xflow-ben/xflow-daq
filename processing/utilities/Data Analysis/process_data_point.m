function results = process_data_point(files,cal,consts,tare)
% cal is an array of calibration structs
% tare is an array of tare structs

%% Load data
tdms = readTDMS(files.dataFile,fullfile(files.absolute_data_dir,files.relative_experiment_dir));
in = convertTDMStoXFlowFormat(tdms);

%% Apply the tare(s)
% subtract off the tares from the raw data (for channels with tares)
% tare are applied such that:
% 1) If the data is before or after all tares just apply the closest tare
% in time
% 2) If the data is between tares, linearly intrpolate

data_time_ind = find(strcmp(in.chanNames,'time'));
tare_time_ind = find(strcmp(tare.chanNames,'time'));

for data_ind = 1:length(in.chanNames)
    if data_ind == data_time_ind
        results.tare_applied(data_ind) = 0;
    else
        tare_ind = find(strcmp(in.chanNames{data_ind},tare.chanNames));
        if isempty(tare_ind)
            results.tare_applied(data_ind) = 0;
        else
            results.tare_applied(data_ind) = 1;
            if size(tare.data,1) == 1
                in.data(:,data_ind) = in.data(:,data_ind) - tare.data(tare_ind);
            else
                in.data(:,data_ind) = in.data(:,data_ind) - ...
                    interp1_with_closest_extrap(tare.data(:,tare_time_ind), tare.data(:,tare_ind), in.data(:,data_time_ind));
            end
        end
    end
end
% might want a catch so that channels that need tares but don't have them,
% don't get processed


%% Add chanNames to results for comparison with tare_applied
results.chanNames = in.chanNames;

%% Extract time
td.time = in.data(:,strcmp(in.chanNames,'time'));

%% Apply calibrations
% loop through the cal structs here. This should take care of the majority
% of the data conversion, with the exception of the encoder

for II = 1:length(cal)
    % Check is data is avalible for ALL relevant input channels
    flag = 1;
    for JJ = 1:length(cal(II).input_channels)
        pass = sum(strcmp(cal(II).input_channels{JJ},in.chanNames));
        if pass ~= 1
            flag = 0;
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
    end
end


% %% Process encoder
% % compute theta, omega, and omegadot using multi_poly_diff
% PPR = 512; % encoder pulses per revolution
% x = in.data(:,strcmp(in.metaData.dataColumns,'Encoder'));
%
% % Take care of possibility that the DAQ counter wrapped over
% counterNBits = 32;
% signedThreshold = 2^(counterNBits-1);
% x(x > signedThreshold) = x(x > signedThreshold) - 2^counterNBits;
%
% td.theta = x*2*pi/PPR;
% [dy,ddy] = multipolydiff(td.theta,100,2);
% td.omega = dy*in.metaData.filt_rate;
% td.acc = ddy*in.metaData.filt_rate^2;

% placeholder for future: Use once-per-rev (RPM) sensor to zero/wrap the
% encoder signal

% compute time-resolved versions of quantities of interest:
% TSR, CP, torque coeff, Reynolds number, thrust coeff, lift coeff, etc.
% use info passed in via turb for constants

% %% Calculated values
% td.U = sqrt(td.Uc_x.^2+td.Uc_y.^2);
% td.torque = td.gen_torque + td.slip_torque;
% td.power = td.torque.*td.omega;
% td.cP =  td.power./(0.5*turb.rho*turb.A*td.U.^3);
% td.TSR = td.omega.*turb.r./td.U;
% %td.ReC = td.U*(1+td.TSR)*turb.chord/turb.nu;
results.td = td;
end