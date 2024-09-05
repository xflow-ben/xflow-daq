function out = apply_calibration(data,dataColumns,cal)

% find an example cal struct in csat_factory_cal.m
if strcmp(cal.type,'linear_k')
    % get the indicies of the dataColumns listed in cal.input_channels
    % Grab out that data
    for i = 1:length(cal.input_channels)
        raw(:,i) = data(:,strcmp(dataColumns,cal.input_channels(i)));
    end
    % multiply by k appropriately (should work for single avalue and square
    % and rectangular matricies)
%     if size(cal.data.k,1) == 1
%         result = raw.*cal.data.k;
%     else
%         error('Need to confirm sure the code will work for a k matrix')
        result = raw*cal.data.k;
%     end
    % create out.(field_names), where filed names are from cal.output_names
    for i = 1:length(cal.output_names)
        out.(cal.output_names{i}) = result(:,i);
    end
end

% add other cal.type s here as we need them (examples: slope-offset form,
% nonlinear function, etc.)