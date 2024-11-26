function taskRaw = applyTare(taskRaw,tare,opts)
% 
% tare file format: n long struct
% tare(n).chanName - raw data name to which to apply tare
% tare(n).value - 1 x m vector of tare values to use (not timeseries, these
% are means or medians of tare points)
% tare(n).time - 1 x m vector, datetime, times at which tare points were
% taken
% 
% Note, multiple tares indicate you want interpolation. Preprocess tares
% into single values if you do not want this. 
% Note 2, interpolation currently occurs over the entire data timeperiod.
% We could add an option (or change it) to interpolate using only the middle time of the
% data, to avoid introducing slope to the data. 

if nargin < 3 || isempty(opts)
    opts.method = 'linear';
end

tareChans = {tare.chanName};
tareApplied = zeros([1,length(tareChans)]); % keep track of if all tares are used so we can throw an error if not

for i = 1:length(taskRaw)
    taskRaw(i).tareApplied = zeros([1,length(taskRaw(i).chanNames)]); % record down which channels have had a tare applied
    for j = 1:length(taskRaw(i).chanNames)
        if any(strcmp(tareChans,taskRaw(i).chanNames(j)))
            ind = find(strcmp(tareChans,taskRaw(i).chanNames(j)));
            tareApplied(ind) = 1; % Record that given tare has been used
            taskRaw(i).tareApplied(j) = 1; % Record that channel has been tared
            taskRaw(i).data(:,j) = interpTare(taskRaw(i).data(:,j),taskRaw(i).time,tare(ind),opts);
        end
    end
end

if any(tareApplied == 0) % this could be removed if it becomes annoying
    unusedInds = find(tareApplied == 0);
    error('At least one given tare, channel %s, was unused. Make sure it matches the data channel name',tare(unusedInds(1)).chanName);
end

    function data = interpTare(data,dataTime,tareStruct,opts)
        if isscalar(tareStruct.value)
            data = data - tareStruct.value;
        else
            % check that the number of values and the number of times match
            if numel(tareStruct.time) ~= numel(tareStruct.value)
                error('Tare for channel ''%s'' has a different lengths for value and time vectors',tareStruct.chanName)
            end
            % check that the data falls between the tares
            if max(dataTime) > max(tareStruct.time) || min(dataTime) < min(tareStruct.time)
                warning('Multiple tare values given for channel ''%s'', but the data falls before or after the tare times',tareStruct.chanName)
            end
            t_capped = min(max(dataTime, tareStruct.time(1)), tareStruct.time(end));  % Cap xq to [x(1), x(end)]
            data = data - interp1(tareStruct.time(:),tareStruct.value(:),t_capped,opts.method, 'extrap');
        end

    end

end