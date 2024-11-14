function td = applyCalAndResample(taskRaw,tare,cal,opts)
% % Applies tare and calibrations, resamples a group of tasks sampled at the
% same time. Use LoadTDMSFileGroup to read in TDMS files to taskRAW


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


