function out = TDMS2XFlow(fileName,filePath,channelName)

if nargin < 3
    d = readTDMS(fileName,filePath);
else
    d = readTDMS(fileName,filePath,channelName);
end
if length(d.group) > 1
    error('This code is intended for TDMS files with only  group/task. This task has %d',length(d.group))
end
out.taskName = d.group.name;
chan1Props = {d.group.channel(1).property.name};
out.startTime = d.group.channel(1).property(strcmp(chan1Props,'wf_start_time')).value;
out.samplePeriod = d.group.channel(1).property(strcmp(chan1Props,'wf_increment')).value;


out.chanNames = {d.group.channel.name};
out.data = [d.group.channel.data];
out.nSamples = size(out.data,1);

% Get the user-added meta data from the TDMS file
propNames = {d.property.name};
% check for these in the file properties
out.metaData = struct;
defaultProps = {'name','description','title','author','datetime'}; 


% Find indices in A that are in B
isInDefaults = ismember(propNames, defaultProps);

% Get indices of elements in A that are NOT in B
indicesNotDefaults = find(~isInDefaults);

for i = 1:length(indicesNotDefaults)
    % Find indices where any of the substrings are found
    fieldName = makeValidFieldName(propNames{indicesNotDefaults(i)});
    if (ischar(d.property(indicesNotDefaults(i)).value) || isstring(d.property(indicesNotDefaults(i)).value)) && ~isnan(str2double(d.property(indicesNotDefaults(i)).value))
        out.metaData.(fieldName) = str2double(d.property(indicesNotDefaults(i)).value);
    else
        out.metaData.(fieldName) = d.property(indicesNotDefaults(i)).value;
    end
end


    function validFieldName = makeValidFieldName(inputString)
        % Replace any non-alphanumeric character with an underscore
        validFieldName = regexprep(inputString, '[^a-zA-Z0-9]', '_');

        % If the first character is not a letter, prepend 'md_'
        if ~isletter(validFieldName(1))
            validFieldName = ['md_' validFieldName];
        end
    end


end
