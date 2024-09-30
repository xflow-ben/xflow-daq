function [loads,volts,channel_names] = process_calibration_folder(calib,crosstalk,parent_dir,tdmsPrefix)

if isstruct(tdmsPrefix)% The tower top calibration uses mutliple tdms files so it is handled differntly
    files = dir(fullfile(parent_dir,calib.folder,[tdmsPrefix.data_files{1},'*.tdms']));
    if isempty(files)
        error(sprintf('No files found in %s',fullfile(parent_dir,calib.folder)))
    end
    for i = 1:length(files)
        d(i) = process_calibration_point_tower_top(files(i).name,crosstalk.channel_names,fullfile(parent_dir,calib.folder),tdmsPrefix);
    end
else % All other calibration
    files = dir(fullfile(parent_dir,calib.folder,[tdmsPrefix,'*.tdms']));
    if isempty(files)
        error(sprintf('No files found in %s',fullfile(parent_dir,calib.folder)))
    end

    for i = 1:length(files)
        d(i) = process_calibration_point(fullfile(parent_dir,calib.folder,files(i).name),crosstalk.channel_names);
    end
end
%% Loop through data folders

% Correct mis-entered metadata (applied load only for now)
if isfield(calib,'corrections') && isfield(calib.corrections,'load') && ~isempty(calib.corrections.load)
    for II = 1:size(calib.corrections.load,1)
        d(calib.corrections.load(II,1)).load = calib.corrections.load(II,2);
    end
end


% Concatonate data
loads = [d.load];
volts = [d.median];
mid_time = [d.mid_time];

%%%%%%%%%%%%%%%%%%%% NEEDS TO BE UPDATED%%%%%%%%%%%%%%%
inds = find(abs(volts)>9.35);
if ~isempty(inds)
    warning('Removing %d points as the channel was saturated\n',length(inds))
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% loads(inds) = [];
% mid_time(inds) = [];
volts(inds) = NaN;

% Separate out the tare points
tare_inds = loads == 0;
tare_volts = volts(:,tare_inds);
tare_time = mid_time(tare_inds);

% delete tare points from non-tare data
volts(:,tare_inds) = [];
loads(tare_inds) = [];
mid_time(tare_inds) = [];

% Subtract off time-interpolated tare
volts = volts - interp1(tare_time',tare_volts',mid_time')';

channel_names = crosstalk.channel_names; % output these for checks



%% Save and plot
% save(calib.name,'-struct','data_combined');

% Plot to visualize calibration results
% [single_channel_calib,primary_slope] = plotSingleVaribleCalibration(data_combined,calib,crosstalk);




