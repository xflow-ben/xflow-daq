function resampleAndCombine(taskRaw,opts)


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
if isfield(opts,'taskName') && isfield(opts,'rate')
    if ~isempty(opts.taskName) && ~isempty(opts.rate)
        error('You cannot speficy both opts.taskName and opts.rate')
    end
end
if isfield(opts,'taskName') && isfield(opts,'startTime')
    if ~isempty(opts.taskName) && ~isempty(opts.startTime)
        error('You cannot speficy both opts.taskName and opts.startTime')
    end
end
if (isfield(opts,'rate') && ~isempty(opts.rate)) && (~isfield(opts,'startTime') || isempty(opts.startTime))
    error('You must specify opts.start time if opts.rate is specified')
end
if (isfield(opts,'startTime') && ~isempty(opts.startTime)) && (~isfield(opts,'rate') || isempty(opts.rate))
    error('You must specify opts.rate time if opts.startTime is specified')
end

if (isfield(opts,'startTime') && ~isempty(opts.startTime)) && (~isfield(opts,'endTime') || isempty(opts.endTime))
    error('You must specify opts.endTime time if opts.startTime is specified')
end

if ~isfield(opts,'rate') || isempty(opts.rate)
    if isfield(opts,'taskName') && ~isempty(opts.taskName)
        taskNames = {taskRaw.taskName};
        resampleTaskInd = find(strcmp(taskNames,opts.taskName));
        if isempty(resampleTaskInd)
            error('opts.taskName %s is not found in data',opts.taskName)
        end
    else
        resampleTaskInd = 1; % use the first task if no opts given
    end
    resampleTime = taskRaw(resampleTaskInd).time;
    startTime = taskRaw(resampleTaskInd).time(1);
    rate = 1/(seconds(taskRaw(resampleTaskInd).time(2)-taskRaw(resampleTaskInd).time(1)));
else
    resampleTaskInd = 0;
    startTime = opts.startTime;
    rate = 1/opts.rate;
    resampleTime = opts.startTime:seconds(1/opts.rate):opts.endTime;
end

out.taskName = 'resampled';
out.chanNames = {};
out.data = [];
out.isRaw = 0;
out.time = resampleTime;
for i = 1:length(taskRaw)
    out.chanNames = [out.chanNames, taskRaw(i).chanNames];
    if i == resampleTaskInd
        out.data = [out.data,taskRaw(i).data];
    else
        [y,ty] = resample(taskRaw(i).data,taskRaw(i).time,rate);
        out.data = [out.data,interp1(ty,y,resampleTime)];

    end
end

resampleTimeNumeric = seconds(resampleTime - startTime);

[t_new,y_resampled] = resample_w_time(Fs_old,Fs_new,t,y)




% Example datetime arrays and data
t_A = datetime(2024,1,1,0,0,0) + seconds(0:0.1:10);  % Original datetime vector for data A
A = sin(2 * pi * 0.5 * (0:0.1:10));                  % Example data

% Define the target datetime vector t_B for resampling
t_B = datetime(2024,1,1,0,0,0) + seconds(0:0.2:10);  % New datetime vector

% Step 1: Convert datetime arrays to numeric format (seconds since start)
t_A_numeric = seconds(t_A - t_A(1));
t_B_numeric = seconds(t_B - t_A(1));

% Step 2: Interpolate A onto t_B's time points
A_resampled = interp1(t_A_numeric, A, t_B_numeric, 'linear');  % Linear interpolation

% Step 3: Result: t_B (datetime) and A_resampled (interpolated data)
% Display the results
disp(t_B);
disp(A_resampled);