function out = resampleAndCombine(taskRaw,opts)
% takes all the tasks in taskRaw, and resamples them according to opts (or
% onto the first task time, if no opts given)

% Options (opts)
%
%   Resampling options
% If opts is not given, data will be resampled onto the first
% task's rate and start time in the daqInfo file
% if opts.taskName (string) is given, data will be resampled to this tasks
% rate and start time
% if opts.rate is given, resample will happen at this rate
% if opts.startTime (datetime format) is given, resample will initiate at
% this time and end at opts.endTime


if nargin < 1
    opts = struct;
end

% check the opts for validity

if isfield(opts,'taskName') && isfield(opts,'startTime')
    if ~isempty(opts.taskName) && ~isempty(opts.startTime)
        error('You cannot speficy both opts.taskName and opts.startTime')
    end
end

if (isfield(opts,'startTime') && ~isempty(opts.startTime)) && (~isfield(opts,'rate') || isempty(opts.rate))
    error('You must specify opts.rate time if opts.startTime is specified')
end

if (isfield(opts,'startTime') && ~isempty(opts.startTime)) && (~isfield(opts,'endTime') || isempty(opts.endTime))
    error('You must specify opts.endTime time if opts.startTime is specified')
end

if isfield(opts,'taskName') && ~isempty(opts.taskName)
    taskNames = {taskRaw.taskName};
    resampleTaskInd = find(strcmp(taskNames,opts.taskName));
    if isempty(resampleTaskInd)
        error('Could not find the task specified in opts.resample.taskName')
    end
else
    resampleTaskInd = 1;
end

if isfield(opts,'rate') && ~isempty(opts.rate)
    rate = opts.rate;
else
     rate = 1/(seconds(taskRaw(resampleTaskInd).time(2)-taskRaw(resampleTaskInd).time(1)));
end

if isfield(opts,'startTime') && ~isempty(opts.startTime)
    startTime = opts.startTime;
    endTime = opts.endTime;
else
    startTime = taskRaw(resampleTaskInd).time(1);
    endTime = taskRaw(resampleTaskInd).time(end);
end

resampleTime = (startTime:seconds(1/rate):endTime)';

% resample all the channe;s
out.taskName = 'resampled';
out.samplePeriod = seconds(resampleTime(2)-resampleTime(1));
out.chanNames = {};
out.data = [];
out.isRaw = 0;
out.time = resampleTime;
out.metaData = [];
out.isRaw = [];
out.tareApplied = [];
for i = 1:length(taskRaw)
    % if all the data is NaN, skip it, as the resampler won't work
    if ~all(isnan(taskRaw(i).data))
        out.chanNames = [out.chanNames, taskRaw(i).chanNames];
        out.isRaw = [out.isRaw, taskRaw(i).isRaw];
        if i == resampleTaskInd && (~isfield(opts,'rate') || isempty(opts.rate))
            out.data = [out.data,taskRaw(i).data];
        else
            try
                out.data = [out.data,resampleXFlow(taskRaw(i).data,taskRaw(i).time,resampleTime)];
            catch
                1+1
            end

        end
    end
end
