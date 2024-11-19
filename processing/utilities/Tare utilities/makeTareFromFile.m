function tare = makeTareFromFile(directory)

% tare file format: n long struct
% tare(n).chanName - raw data name to which to apply tare
% tare(n).value - 1 x m vector of tare values to use (not timeseries, these
% are means or medians of tare points)
% tare(n).time - 1 x m vector, datetime, times at which tare points were
% taken

tareFile = dir(fullfile(directory,'tare.mat'));
if isempty(tareFile)
    error('No tare.mat file found in %s',directory)
end

in = load(fullfile(directory,'tare.mat'));
tareIn = in.tare;
tare = [];

for i = 1:length(tareIn)
    % load in all tare files
    if strcmp(tareIn(i).channelNames(1),'all')
        if length(tareIn(i).channelNames) > 1
            error('Only one input for channelNames allowed for option ''all''')
        end
        mode = 'useAll';
        exceptList = {};
    elseif strcmp(tareIn(i).channelNames(1),'-except')
        mode = 'allExcept';
        exceptList = tareIn(i).channelNames(2:end);
    else
        mode = 'specify';
        exceptList = {};
    end

    % tdmsIn = struct;
    fInd = 0;
    values = [];
    times = [];
    chanNames = {};
    for j = 1:length(tareIn(i).filePaths)
        subFiles = dir(fullfile(directory,tareIn(i).filePaths{j}));
        for k = 1:length(subFiles)
            fInd = fInd + 1;
            tdmsIn = TDMS2XFlow(subFiles(k).name,directory);
            values = [values,median(tdmsIn.data,1)];
            chanNames = [chanNames, tdmsIn.chanNames];
            times = [times, repmat(tdmsIn.startTime + seconds(tdmsIn.nSamples.*tdmsIn.samplePeriod/2),[1,length(tdmsIn.chanNames)])];

        end

    end
    [uniqueChanNames,uAinds,uBinds] = unique(chanNames);
    for j = 1:length(uniqueChanNames)
        if ~isempty(tare)
            existingChanNames = {tare.chanName};
            if ~any(strcmp(existingChanNames,uniqueChanNames{j}))
                tareOutInd = length(tare) + 1;
                nTares = 0;
            else
                tareOutInd = find(strcmp(existingChanNames,uniqueChanNames{j}));
                nTares = length(tare(tareOutInd).value);
            end
        else
            tareOutInd = 1;
            nTares = 0;
        end

        tare(tareOutInd).value(nTares+1) = mean(values(uBinds == uAinds(j)));
        tare(tareOutInd).chanName = uniqueChanNames{j};
        tare(tareOutInd).time(nTares+1) = mean(times(uBinds == uAinds(j)));
    end

end

end