function td = processDataFolder2(directory,cal,opts)
% by default, this expects the files to be of the form data_XXXXXXX_*.tdms,
% where every unique XXXXX corresponds to a set of files collected in a
% continuous acquisition. Giving opts.fileConvention = 'trailingNumber'
% instead treats every set of files with *_XXXX.tdms with the same XXXX as
% an individual set of files


if nargin < 3 || isempty(opts)
    opts = struct;
end

tareF = dir(fullfile(directory,'tare.mat'));
if isempty(tareF)
    error('Directory %s  does not have a tare.mat file in it',directory)
end

in = load(fullfile(directory,'tare.mat'));
tare = in.tare;
tareFiles = [tare.filePaths];
tareFileNames = {};
for i = 1:length(tareFiles)
    f = dir(tareFiles{i});
    tareFileNames = [tareFileNames, {f.name}];
end

tareStr = makeTareFromFile(directory);

tareFiles = [tare.filePaths];
tareFileNames = {};
for i = 1:length(tareFiles)
    f = dir(fullfile(directory,tareFiles{i}));
    if isempty(f)
        error('Could not find the tare file &s in directory %s',tareFiles{i},directory)
    end
    tareFileNames = [tareFileNames, {f.name}];
end

if isfield(opts,'fileConvention')
    if strcmp(opts.fileConvention,'trailingNumber')
        convention = 'trailingNumber';
    elseif strcmp(opts.fileConvention,'data_datenum')
        convention = 'data_datenum';
    else
        error('unknown option for opts.fileConvetion')
    end
else
    convention = 'data_datenum';
end

tdmsFiles = dir(fullfile(directory,'*.tdms'));
if isempty(tdmsFiles)
    error('No tdms files found in directory')
end
tdmsFileNames = {tdmsFiles.name};

% remove the tare files from the list
tdmsFileNames = tdmsFileNames(~ismember(tdmsFileNames, tareFileNames));

switch convention
    case 'data_datenum'
        % get the dateNum numbers
        fileNums = cellfun(@(x) str2double(regexp(x, '(?<=data_)\d+', 'match', 'once')), tdmsFileNames);
        tareFileNums = cellfun(@(x) str2double(regexp(x, '(?<=data_)\d+', 'match', 'once')), tareFileNames);

    case 'trailingNumber'
        % get the trailing numbers
        fileNums = cellfun(@(x) str2double(regexp(x, '(?<=_)\d+(?=\.tdms)', 'match', 'once')), tdmsFileNames);
        tareFileNums = cellfun(@(x) str2double(regexp(x, '(?<=_)\d+(?=\.tdms)', 'match', 'once')), tareFileNames);
    otherwise
        error('We problem with parsing opts.fileConvention, should not be here')
end
if isempty(fileNums) || all(isnan(fileNums))
    error('No files matching pattern found. Check opts.fileConvention')
elseif any(isnan(fileNums))
    error('At least one file doesn''t match the pattern')
end

% remove any remaining tare files from the list
indices = find(ismember(fileNums, tareFileNums));
tdmsFileNames(indices) = [];
fileNums(indices) = [];

 % sort files into unique groups based on extracted number

groupInds = arrayfun(@(x) find(fileNums == x), unique(fileNums), 'UniformOutput', false);
         
for i = 1:length(groupInds)
    fprintf('Processing file group %d of %d\n', i, length(groupInds))
    taskRaw = loadTDMSFileGroup(tdmsFileNames(groupInds{i}),directory);
    [tdtemp,~] = applyCalAndResample(taskRaw,tareStr,cal,opts);
    for j = 1:length(tdtemp.chanNames) % I don't like this but I will do it to use Ian's existing codes.
        td(i).(tdtemp.chanNames{j}) = tdtemp.data(:,j);
    end
    td(i).Time = tdtemp.time;
end
