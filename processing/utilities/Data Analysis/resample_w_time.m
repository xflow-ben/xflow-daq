function [t_new,y_resampled] = resample_w_time(Fs_old,Fs_new,t,y)

% Fs_old: Original sample rate
% Fs_new:  Desired new sample rate

% Resample the data
[p, q] = rat(Fs_new / Fs_old);  % Find integer resampling factors
y_resampled = resample(y, p, q);  % Resample the data

% Calculate new timestamps
t_new = t(1):1/Fs_new:(length(y_resampled)-1)/Fs_new + t(1);  % New timestamps, evenly spaced at 1/Fs_new

% % Adjust t_new length if necessary
% if length(t_new) > length(y_resampled)
%     t_new = t_new(1:length(y_resampled));  % Trim to match resampled data length
% end