function results = convectionCorrection(results)%,mettowerdist)
mettowerdist = 50.3;
results.td.dirRelative = results.td.Dir;

%% Make sure wind dirs are wrapped properly
results.td.dirRelative (results.td.dirRelative > 360) = results.td.dirRelative (results.td.dirRelative > 360) - 360;
results.td.dirRelative (results.td.dirRelative < 0) = results.td.dirRelative (results.td.dirRelative < 0) + 360;

%% Correct wind data time for convection
timeDelay = abs(mettowerdist*cosd(results.td.dirRelative))./results.td.U;
results.td_cc.time_corrected =  results.td.Time + timeDelay;
results.td_cc.U =  results.td.U;
results.td_cc.W =  results.td.W;
results.td_cc.Dir =  results.td.Dir;
results.td_cc.shear =  results.td.shear;

max_time = cummax(results.td_cc.time_corrected); % Cumulative maximum of time_corrected
ind = (max_time(1:end-1) > results.td_cc.time_corrected(2:end)); % Logical index where time_corrected is greater
results.td_cc.time_corrected([false; ind]) = NaN; % Set values to NaN for the appropriate indices
results.td_cc.U([false; ind]) = NaN; % Apply the same NaN assignment for U
results.td_cc.W([false; ind]) = NaN; % Apply the same NaN assignment for W
results.td_cc.Dir([false; ind]) = NaN; % Apply the same NaN assignment for Dir
results.td_cc.shear([false; ind]) = NaN; % Apply the same NaN assignment for shear


% Remove the NaN values
nan_idx = isnan(results.td_cc.time_corrected);  % Find indices of NaNs
results.td_cc.time_corrected(nan_idx) = [];  % Remove NaNs from time_corrected
results.td_cc.U(nan_idx) = [];  % Remove corresponding NaNs from U
results.td_cc.W(nan_idx) = [];  % Remove corresponding NaNs from W
results.td_cc.Dir(nan_idx) = [];  % Remove corresponding NaNs from Dir
results.td_cc.shear(nan_idx) = [];  % Remove corresponding NaNs from shear

% Sort the time_corrected and U arrays based on time_corrected
[results.td_cc.time_corrected, sortIdx] = sort(results.td_cc.time_corrected);
results.td_cc.U = results.td_cc.U(sortIdx);  % Apply the same sorting to U
results.td_cc.W = results.td_cc.W(sortIdx);  % Apply the same sorting to W
results.td_cc.Dir = results.td_cc.Dir(sortIdx);  % Apply the same sorting to Dir
results.td_cc.shear = results.td_cc.shear(sortIdx);  % Apply the same sorting to shear

% Find the unique time values and the corresponding indices
[results.td_cc.time_corrected, uniqueIdx] = unique(results.td_cc.time_corrected, 'stable');

% Use the unique indices to keep the corresponding U, W, Dir, and shear values
results.td_cc.U = results.td_cc.U(uniqueIdx);
results.td_cc.W = results.td_cc.W(uniqueIdx);
results.td_cc.Dir = results.td_cc.Dir(uniqueIdx);
results.td_cc.shear = results.td_cc.shear(uniqueIdx);

% Resample results.td_cc.U to match the time points in results.td.Time
results.td.U_cc = interp1(results.td_cc.time_corrected, results.td_cc.U, results.td.Time, 'linear', 'extrap');
results.td.W_cc = interp1(results.td_cc.time_corrected, results.td_cc.W, results.td.Time, 'linear', 'extrap');
results.td.Dir_cc = interp1(results.td_cc.time_corrected, results.td_cc.Dir, results.td.Time, 'linear', 'extrap');
results.td.shear_cc = interp1(results.td_cc.time_corrected, results.td_cc.shear, results.td.Time, 'linear', 'extrap');

