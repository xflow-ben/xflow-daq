function resampleAndCombine(taskRaw,opts)


% Options (opts)
%
%   Resampling options
% If opts is not given, data will be resampled onto the first
% task's rate and start time in the daqInfo file
% if opts.taskName (string) is given, data will be resampled to this tasks
% rate and start time
% if opts.rate is given, resample will happen at this rate
% if opts.startTime (datetime format) is given, resample will initiate at this time



 [t_new,y_resampled] = resample_w_time(Fs_old,Fs_new,t,y)