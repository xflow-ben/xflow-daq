function [tdout,taskRaw] = applyCalAndResample(taskRaw,tare,cal,opts)
% % Applies tare and calibrations, resamples a group of tasks sampled at the
% same time (one single shot, or one set of continuous acuqisition files)
% Use LoadTDMSFileGroup to read in TDMS files to taskRAW
%
%
% Options (opts)
%
%   Resampling options
% If opts.resample is not given, data will be resampled onto the first
% task's rate and start time in the daqInfo file
% if opts.resample.taskName (string) is given, data will be resampled to this tasks
% rate and start time
% if opts.resample.rate is given, resample will happen at this rate
% if opts.resample.startTime (datetime format) is given, resample will initiate at this time
%
%
% Calibration stages
%   - 'beforeResample' - this is pre resample, before any other calibs are applied
%   - 'afterResample' - this is post-resample. Good for cals that rely on
%   channels from multiple tasks
%   - 'final' - For cals that rely on outputs from the 'resampled' stage.
%   You can have cals in Final rely on eachother, they just need to
%   arranged after the ones they rely on


if nargin < 4 || isempty(opts)
    opts = struct;
end

%% Apply tares

% tare file format: n long struct
% tare(n).chanName - raw data name to which to apply tare
% tare(n).value - 1 x m vector of tare values to use (not timeseries, these
% are means or medians of tare points)
% tare(n).time - 1 x m vector, datetime, times at which tare points were
% taken

% taskRaw = applyTare(taskRaw,tare);
%% Add an israw field to the tasks, to be able to separate raw and calibrated tasks later
for i = 1:length(taskRaw)
    taskRaw(i).isRaw = ones(size(taskRaw(i).chanNames));
end
%% Apply pre-resample calibrations

taskRaw = applyAllCalForStage(taskRaw,cal,'beforeResample'); % adds a single field called rawCal

%% Resample
if ~isfield(opts,'resample')
    resampleOpts = [];
else
    resampleOpts = opts.resample;
end
td = resampleAndCombine(taskRaw,resampleOpts); % adds a task named "resampled" to the task list

%% Apply post-resample calibrations

td = applyAllCalForStage(td,cal,'afterResample'); % adds a single field called rawCal

%% Apply final calibrations
td = applyAllCalForStage(td,cal,'final'); % adds a single field called rawCal

%% remove the raw data from our struct (don't need it any more)

tdRMinds = [];
for i = 1:length(td)
    if all(td(i).isRaw == 1)
        tdRMinds = [tdRMinds, i];
    elseif any(td(i).isRaw == 1)
        % then a subset of chans needs to be removed
        chanRMinds = [];
        for j = 1:length(td(i).chanNames)
            if td(i).isRaw(j) == 1
            chanRMinds = [chanRMinds, j];
            end
        end
        td(i).data(:,chanRMinds) = [];
        td(i).chanNames(chanRMinds) = [];
        td(i).isRaw(chanRMinds) = [];
    end
end

td(tdRMinds) = [];

tdout.data = [];
tdout(1).chanNames = {};
k = 1;
% put together the remaining ones all into one structure. Chonk everything
% that is on the same timebase together
if length(td) > 1
    for i = 1:length(td)
        if i == 1 % this method doesn't work if the first one is the one with the oddball length
            tdLg = size(td(i).data,1);
            tdout(1).time = td(i).time;
        else
            if size(td(i).data,1) ~= tdLg
                error('We ended up with different lengths of data out of the calibrations? This error could be removed if this is on purpose but the code needs some fixes')
                k = k + 1;
                tdout(k) = td(i).data;
                tdout(k).chanNames = td(i).chanNames;
            else
                tdout(1).data = [tdout.data,td(i).data];
                tdout(1).chanNames = [tdout(1).chanNames, td(i).chanNames];
            end
        end
    end
end


    function taskRaw = applyAllCalForStage(taskRaw,cal,stage)
        for ii = 1:length(cal)
            % look for cals with the given stage
            if strcmp(cal(ii).stage,stage)
                % scan through and extract the appropriate data
                if checkForChannel(cal(ii).inputChannels,taskRaw)
                    taskRaw(end+1) = applyChannelCal(taskRaw,cal(ii));
                end
            end
        end
    end

    function out = checkForChannel(chanelNames,taskRaw)
        taskChannels = [taskRaw.chanNames];
        out = all(ismember(chanelNames,taskChannels));


    end


end




