function [td,taskRaw] = applyCalAndResample(taskRaw,tare,cal,opts)
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

taskRaw = applyTare(taskRaw,tare);
%% Add an israw field to the tasks, to be able to separate raw and calibrated tasks later
for i = 1:lenght(taskRaw)
    taskRaw(i).isRaw = 1;
end
%% Apply pre-resample calibrations

taskRaw = applyAllCalForStage(taskRaw,cal,'beforeResample'); % adds a single field called rawCal

%% Resample
if ~isfield(opts,'resample')
    resampleOpts = [];
else
    resampleOpts = opts.resample;
end
taskRaw = resampleAndCombine(taskRaw,resampleOpts);

%% Apply post-resample calibrations

taskRaw = applyAllCalForStage(taskRaw,cal,'afterResample'); % adds a single field called rawCal

%% Apply final calibrations
taskRaw = applyAllCalForStage(taskRaw,cal,'final'); % adds a single field called rawCal

%% remove the raw data (don't need it any more)
isRawVec = [taskRaw.isRaw];
td = taskRaw(~isRawVec);
if nargout > 1
    % remove
    taskRaw = rmfield(taskRaw,'calibrated');
end


    function taskRaw = applyAllCalForStage(taskRaw,cal,stage)
        for ii = 1:length(cal)
            % look for cals with the given stage
            if strcmp(cal(ii).stage,stage)
                % scan through and extract the appropriate data
                taskRaw(end+1) = applyChannelCal(taskRaw,cal(ii));
            end
        end
    end


end




