function taskRaw = loadTDMSFileGroup(fileList,fileDirectory,opts)
% Reads in a group of files. Organizes them by task and concatonates
% contiguous tasks (from continuous acquisitions). Generates timestamps
% Files must be from a single single-shot acquisition OR be contiguous from a
% continuous acquisition
%
% Options (opts)
%
%   Rate options
% if opts.rate is not given, uses the wf_increment field of tdms file for
% the rate
% if opts.rate is given, for each task named opts.rate(i).taskName, uses
% rate opts.rate(i).rate
% An error will be thrown if opts.rate is specified, but there are more
% than one files with the specified channel. This is because the
% wf_start_times could be wrong in subsequent files

if isempty(fileList)
    error('You gave an empty file list')
end

if ~iscell(fileList) || (~ischar(fileList{1}) && ~istring(fileList{1}))
    error('FileList must be a cell array of file name strings or chars')
end

if ~isstring(fileDirectory) && ~ischar(fileDirectory)
    error('fileDirectory must be a char or string')
end

if nargin < 5 || isempty(opts)
    opts = struct;
end


for i = 1:length(fileList)
    % check if the file is there
    d(i) = TDMS2XFlow(fileList{i},fileDirectory);
end

%% check for file consistency
if length(fileList) > 1 % only bother if processing more than one file
    taskListAll = {d.taskName};
    [taskListUnique,~,uinds] = unique(taskListAll); % list of unique tasks
    nTasks = length(taskListUnique);
    % check that they all have the same number of files, and that within file
    % types, the channels are consistent, and the wf_increment
    nFiles = zeros([1,nTasks]); % number of files of each type
    for i = 1:nTasks
        nFiles(i) = sum(strcmp(taskListUnique(i),taskListAll));
        thisTaskFileInds = find(uinds == i);
        if length(thisTaskFileInds) > 1
            for j = 2:length(thisTaskFileInds)
                if ~isequal(d(thisTaskFileInds(1)).chanNames,d(thisTaskFileInds(j)).chanNames)
                    error('At least one file with task %s has different channels than the others',d(inds(1)).taskName)
                end
                if ~isequal(d(thisTaskFileInds(1)).samplePeriod,d(thisTaskFileInds(j)).samplePeriod)
                    error('At least one file with task %s has a different samplePeriod (wf_increment) than the others',d(inds(1)).taskName)
                end
            end
        end
    end
    % if length(unique(nFiles)) > 1
        % NOTE: Ian commented out this check. Some data has different
        % numbers of files per task since some daqs tasks ended without
        % stopping the others from continuing the collect data.
        %error('The number of tdms files in fileList of different types must be the same')
    % else
        nFilesPerTask = unique(nFiles);
    % end

else
    taskListUnique = {d.taskName};
    uinds = 1;
    nTasks = 1;
    nFilesPerTask = 1;
end


%% Determin task rates (1/samplePeriod)
% get rates and start times from files
samplePeriod = zeros([1,nTasks]);
for i = 1:nTasks
    thisTaskFileInds = find(uinds == i);
    samplePeriod(i) = d(thisTaskFileInds(1)).samplePeriod;
    startTimes{i} = [d(thisTaskFileInds).startTime];
    taskData{i} = d(thisTaskFileInds);
end
clear d;


% deal with overwriting the rate, if it is given in opts
if isfield(opts,'rate')
    if any(nFiles > 1)
        % this could be fixed if needed, but I'd rather be able to rely on
        % wf_start_time in the files as we use that the ensure no gaps in
        % files in fileList
        error('Currently, you can only specify the rate for single-shot acquisitions, not for continuous (multi-file) acquisitions')
    end

    rateTaskNames = {opts.rate.taskNames};
    for i = 1:length(opts.rate)
        inputRateInd = find(trfind(rateTaskNames(i),taskListUnique));
        if isempty(inputRateInd)
            error('Task opts.rate(i).taskName = %s is not found in the files',rateTaskNames{i})
        end
        samplePeriod(inputRateInd) = 1/opts.rate(i).rate;
    end
end

%% Concatonate tasks and create timestamps
% Ensure that the timestamps are contiguous with no gaps
taskRaw = struct;
timeTol = 1e-6; % tolerance for checking if files are contiguous
for i = 1:nTasks  
    [taskStartTimes,startInds] = sort(startTimes{i},'ascend');

    % checking for file continuity (no gaps between files, based on rate and wf_start_time)
    if nFilesPerTask > 1 
        for j = 2:nFilesPerTask
            expectedDT = taskData{i}(j-1).nSamples.*samplePeriod(i);
            fileDT = seconds(taskStartTimes(startInds(j)) - taskStartTimes(startInds(j-1)));
            if abs(expectedDT - fileDT) > timeTol
                error('Dected a time gap between end-to-start of files of %e sec. Files in fileList should be contiguous',fileDT - expectedDT)
            end
        end
    end
    taskRaw(i).taskName = taskListUnique{i};
    nSamplesTotal = sum([taskData{i}.nSamples]);
    taskRaw(i).time = taskStartTimes(1) + seconds((0:(nSamplesTotal - 1))'.*samplePeriod(i));
    taskRaw(i).data = vertcat(taskData{i}(startInds).data);
    taskRaw(i).chanNames = taskData{i}(1).chanNames;
    taskRaw(i).metaData = taskData{i}(1).metaData;
    taskRaw(i).samplePeriod = samplePeriod(i);
   
end







