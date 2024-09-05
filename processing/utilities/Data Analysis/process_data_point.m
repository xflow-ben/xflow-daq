function td = process_data_point(file_path,cal,consts)
% cal is an array of calibration structs
% tare is an array of tare structs

%% Load data
tdms = readTDMS(file_path,'');
in = convertTDMStoXFlowFormat(tdms);

%% Apply the tare(s)
% for now just use the mean of all the tares provided
% subtract off the tares from the raw data (for channels with tares)
in.data = in.data;% - tare.median;

% might want a catch so that channels that need tares but don't have them,
% don't get processed

% make function - check for tares

%% Extract time
td.time = in.data(:,strcmp(in.chanNames,'time'));

%% Apply calibrations
% loop through the cal structs here. This should take care of the majority
% of the data conversion, with the exception of the encoder

for II = 1:length(cal)
    % Apply calibration if data is avalible for all relevant channels
    flag = 1;
    for JJ = 1:length(cal(II).input_channels)
        pass = sum(strcmp(cal(II).input_channels{JJ},in.chanNames));
        if pass ~= 1
            flag = 0;
        end
    end

    
    if flag
        temp = apply_calibration(in.data,in.chanNames,cal(II));
        fields = fieldnames(temp);
        for JJ = 1:length(fields) % make sure this works properly
            td.(fields{JJ}) = temp.(fields{JJ});
        end
    end
end

% add back in bearing losses here

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
end