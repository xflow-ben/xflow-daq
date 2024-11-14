function applyTare(taskRaw,tare)

% tare file format: n long struct
% tare(n).chanName - raw data name to which to apply tare
% tare(n).value - 1 x m vector of tare values to use (not timeseries, these
% are means or medians of tare points)
% tare(n).time - 1 x m vector, datetime, times at which tare points were
% taken

for i = 1:length(taskRaw)
    


end