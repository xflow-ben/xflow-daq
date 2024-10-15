% NOTE: there can only be 2 saveDir currently
compressedDir = 'E:\loads_data\operating';
saveDir = 'D:\loads_data\operating_uncompressed'; 
uploadDir = 'X:\Experiments and Data\20 kW Prototype\Loads_Data\operating';

duration = 60*10; % 10 min file duratation
tareDuration = 60;
windThreshStart = 3.8; % start data collection when wind reaches this level
windThreshStop = 2;

loopTime = 5; % how often this function runs, seconds
%% Check if the DAQs are all online

%%
t = timer; % main look timer
t.UserData.compressedDir = compressedDir;
t.UserData.saveDir = saveDir;
t.UserData.uploadDir = uploadDir;
t.UserData.state = 'lowWind';
t.UserData.tareRequest = false;
t.UserData.windThresh = windThreshStart;
t.UserData.windThreshStop = windThreshStop;
t.UserData.fileDurationSeconds = duration;
t.UserData.tareLengthSeconds = tareDuration;
t.UserData.nSampsAcqVec = [];

t.UserData.compressProcess = [];
t.UserData.uploadProcess = [];



%% Check that the save dir exisits, and that the max file number for all the file types is the same
% if isempty(dir(fullfile(saveDir,'*.tdms')))
%     error('No files in saveDir?')
% end

% tdmsFiles = dir(fullfile(saveDir,'*.tdms'));
% csvFiles =  dir(fullfile(saveDir,'*.csv'));
% 
% tdmsFileNames = {tdmsFiles.name};
% for i = 1:length(tdmsFileNames)
%     tdmsFileNames{i} = [tdmsFileNames{i}(1:end-9),'*.tdms'];
% end
% tdmsFileTypes = unique(tdmsFileNames);
% 
% maxNum = ones([1,length(tdmsFileTypes) + 1]).*-1;
% for i = 1:length(tdmsFileTypes)
%     typeFiles = dir(fullfile(saveDir,tdmsFileTypes{i}));
%     fileStrings = {typeFiles.name};
%     fileStrings = cellfun(@(x) x(end-8:end-5), fileStrings, 'UniformOutput', false);
%     fileNums = cellfun(@str2double, fileStrings);
%     maxNum(i) = max(fileNums);
% end
% 
% i = i + 1;
% 
% fileStrings = {csvFiles.name};
% fileStrings = cellfun(@(x) x(end-7:end-4), fileStrings, 'UniformOutput', false);
% fileNums = cellfun(@str2double, fileStrings);
% maxNum(i) = max(fileNums);
% 
% if ~all(maxNum(1) == maxNum)
%     error('Max file number for at least one file type in saveDir differs from the rest')
% end

%% Check the compressed dir and compare to the save dir. Generate the queue of data to be backed up
% compQueue = {};
% k = 0;
% tdmsFileNames = {tdmsFiles.name};
% csvFileNames = {csvFiles.name};
% for i = 1:length(tdmsFiles)
%     file_t = tdmsFiles(i).date;
%     dateFolderName = sprintf('%02d_%02d_%d',month(file_t),day(file_t),year(file_t));
%     compFiles = dir(fullfile(compressedDir,dateFolderName,'data*.7z'));
%     compFileNames = {compFiles.name};
%     compFileNames = cellfun(@(x) x(1:end-1), compFileNames, 'UniformOutput', false);
%     if ~any(ismember(compFileNames,tdmsFiles(i).name(1:end-3)))
%         k = k + 1;
%         compQueue{k} = tdmsFiles(i).name;
%     end
% end
% 
% for i = 1:length(csvFiles)
%     file_t = csvFiles(i).date;
%     dateFolderName = sprintf('%02d_%02d_%d',month(file_t),day(file_t),year(file_t));
%     compFiles = dir(fullfile(compressedDir,dateFolderName,'data*.7z'));
%     compFileNames = {compFiles.name};
%     compFileNames = cellfun(@(x) x(1:end-1), compFileNames, 'UniformOutput', false);
%     if ~any(ismember(compFileNames,csvFiles(i).name(1:end-2)))
%         k = k + 1;
%         compQueue{k} = csvFiles(i).name;
%     end
% end
% t.UserData.compQueue = compQueue;
% t.UserData.oldTdmsFiles = tdmsFileNames;
% t.UserData.oldCsvFiles = csvFileNames;
% %% Check the status of uploading. make queue of stuff that has not been
% 
% t.UserData.serverOnline = 1;
% t.UserData.uploadQueue = {};
% if isempty(dir(t.UserData.uploadDir))
%     t.UserData.serverOnline = 0;
%     warning('XFlow NAS not online, no uploading');
% else
%     t.UserData.uploadQueue = compareDirectories(t.UserData.compressedDir, t.UserData.uploadDir);
% end

%%


% setup the NI DAQ system
t.UserData.d = setupDAQs(duration,saveDir);


% set up the controller data stream
t.UserData.BBB = streamBBBdata(saveDir,duration);


t.StartDelay = loopTime;              % Set the delay before execution
t.TimerFcn = @(src,event)collectionStateMachine(src,event);        % Set the function to be executed
t.ExecutionMode = 'singleShot'; % Execute the function only once

start(t);


