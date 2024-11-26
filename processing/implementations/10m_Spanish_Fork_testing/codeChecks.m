% load in cal
repoDir = 'C:\Users\Ian\Documents\GitHub\';
calSubPat = 'xflow-daq\processing\implementations\10m_Spanish_Fork_testing\Calibrations\Results\cal_struct_25_11_24.mat';
calPath = fullfile(repoDir,calSubPat);
in = load(calPath);

cal = in.cal;
%% Check against some tares

% note, this does not check post-cal and resampling, as tho

% first check the main data folder
expDir = 'X:\Experiments and Data\20 kW Prototype\Loads_Data\operating_uncompressed';

in = load(fullfile(expDir,'tare.mat'));
tare = in.tare;

tareStr = makeTareFromFile(expDir);
opts.resample.taskName = 'rotor_strain';
opts.resample.rate = 512;
medianVals = [];
for i = 1:length(tare(1).filePaths)
    ftemp = dir(fullfile(expDir,tare(1).filePaths{i}));
    files = {ftemp.name};
    
    taskRaw = loadTDMSFileGroup(files,expDir);
    [td,rawOut] = applyCalAndResample(taskRaw,tareStr,cal,opts);
    medianVals(i,:) = median([rawOut.data],1,'omitnan');
end
meanOfTares = mean(medianVals,1,'omitnan');

meanOfTares(9) = []; % this channel is not tared, need to remove
if any(abs(meanOfTares)>10^(-15))
    error('Possible problem with tares or tare code')
end

clearvars('-except','cal')
% also check a calibration folder
expDir = 'X:\Experiments and Data\20 kW Prototype\Loads_Data\load_calibrations\rotor_segment\rotor_segment_lower_-Fy';
opts.resample.taskName = 'rotorStrain';
opts.tare.method = 'nearest';


in = load(fullfile(expDir,'tare.mat'));
tare = in.tare;

tareStr = makeTareFromFile(expDir);

medianVals = [];
for j = 1:length(tare)
    for i = 1:length(tare(j).filePaths)
        ftemp = dir(fullfile(expDir,tare(j).filePaths{i}));
        files = {ftemp.name};

        taskRaw = loadTDMSFileGroup(files,expDir);
        [td,rawOut] = applyCalAndResample(taskRaw,tareStr,cal,opts);
        medianVals(j,:) = median([rawOut.data],1,'omitnan');
    end
end
meanOfTares = mean(medianVals,1,'omitnan');

if any(abs(meanOfTares)>10^(-15)) % the threshold needs to be a bit higher due to the way the interp is working
    error('Possible problem with tares or tare code')
end
%% Check against arm canteleiver calibrations
clearvars('-except','cal')


expDir = 'X:\Experiments and Data\20 kW Prototype\Loads_Data\load_calibrations\lower_arm\Lower_arm_+Mx';

in = load(fullfile(expDir,'tare.mat'));
tare = in.tare;

tareStr = makeTareFromFile(expDir);

opts.resample.taskName = 'rotorStrain';
opts.resample.rate = 512;

filesToProc = dir(fullfile(expDir,'lower_arm_cal_rotorStrain*.tdms'));
fileNames = {filesToProc.name};

tareFileNames = [tare.filePaths];
indices = find(~ismember(fileNames, tareFileNames));
fileNames = fileNames(indices);

for i = 1:length(fileNames)
        taskRaw = loadTDMSFileGroup(fileNames(i),expDir);
        [td(i),rawOut] = applyCalAndResample(taskRaw,tareStr,cal,opts);
        medVals(i,:) = median(td(i).data);
end

medVals = medVals(:,1:3);
appliedLoad = cal(9).data.loadMat(:,1:6);
errors = abs((medVals -  appliedLoad'));
if any(errors(:,1)>15) || any(errors(:,2)>50) || any(errors(:,3)>10)
    error('Possible error in calibration')
end

%% Check against tower calibration

clearvars('-except','cal')



expDir = 'X:\Experiments and Data\20 kW Prototype\Loads_Data\load_calibrations\tower\V-B_H-B';


in = load(fullfile(expDir,'tare.mat'));
tare = in.tare;


tareStr = makeTareFromFile(expDir);

opts.resample.taskName = 'rotor_strain';
opts.resample.rate = 512;

tareFiles = [tare.filePaths];
tareFileNames = {};
for i = 1:length(tareFiles)
    f = dir(tareFiles{i});
    tareFileNames = [tareFileNames, {f.name}];
end

fileEndings = [8 9 11 12];


for j = 1:length(fileEndings)
    filesToProc = dir(fullfile(expDir,sprintf('*_strain_%04d.tdms',fileEndings(j))));
    fileNames = {filesToProc.name};
    taskRaw = loadTDMSFileGroup(fileNames,expDir);
    [td(j),rawOut] = applyCalAndResample(taskRaw,tareStr,cal,opts);
    medValsAll(j,:) = median(td(j).data,'omitnan');
end


appliedLoad = cal(24).data.loadMat(:,1:4);


medVals = medValsAll(:,23:24);

errors = abs((medVals -  appliedLoad'));
if any(errors(:)>40) 
    error('Possible error in tower top moment calibration')
end


appliedLoad = cal(25).data.loadMat(:,11:14);
medVals = medValsAll(:,25:26);
errors = abs((medVals -  appliedLoad'));
if any(errors(:)>15) 
    error('Possible error in tower top force calibration')
end

%% Rotor segment checks and nacelle moment checks
rotorSegMy(calPath);
rotorSegMx(calPath);
rotorSegFx(calPath);
%tower_Mx_My;

%% Tower top Mz My


clearvars('-except','cal')

expDir = 'X:\Experiments and Data\20 kW Prototype\Loads_Data\load_calibrations\installed_rotor\-Z_pos_1';


in = load(fullfile(expDir,'tare.mat'));
tare = in.tare;


tareStr = makeTareFromFile(expDir);

opts.resample.taskName = 'rotor_strain';
opts.resample.rate = 512;

tareFiles = [tare.filePaths];
tareFileNames = {};
for i = 1:length(tareFiles)
    f = dir(tareFiles{i});
    tareFileNames = [tareFileNames, {f.name}];
end


fileEndings = [1 2 3 5 6 7];


for j = 1:length(fileEndings)
    filesToProc = dir(fullfile(expDir,sprintf('*_strain_%04d.tdms',fileEndings(j))));
    fileNames = {filesToProc.name};
    taskRaw = loadTDMSFileGroup(fileNames,expDir);
    [td(j),rawOut] = applyCalAndResample(taskRaw,tareStr,cal,opts);
    medValsAll(j,:) = median(td(j).data,'omitnan');
end

chanInds = [];
chans = {'Tower_Top_Mx','Tower_Top_My'};
for i = 1:length(chans)
    chanInds(i) = find(strcmp(chans{i},td(1).chanNames));
end
appliedLoad = cal(25).data.loadMat(3:4,19:24)';


medVals = medValsAll(:,chanInds);

avErr = mean(abs(appliedLoad - medVals)./abs(appliedLoad));
plot