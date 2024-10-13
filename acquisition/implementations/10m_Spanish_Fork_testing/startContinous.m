% NOTE: there can only be 2 saveDir currently
compressedDir = "E:\loads_data\operating";
saveDir = "D:\loads_data\operating"; 
uploadDir = "X:\Experiments and Data\20 kW Prototype\Loads_Data\operating";

duration = 60*10; % 10 min file duratation
tareDuration = 60;

%% Check that the save dir exisits, and that the max file number for all the file types is the same
if isempty(dir(fullfile(saveDir,'*.tdms')))
    error("No files in saveDir?")
end

tdmsFiles = dir(fullfile(saveDir,'*.tdms'));
csvFiles =  dir(fullFile(saveDir,'*.csv'));

tdmsFileNames = {tdmsFiles.name};
for i = 1:length(tdmsFileNames)
    tdmsFileNames{i} = [tdmsFileNames{i}(1:end-9),'*.tdms'];
end
tdmsFileTypes = unique(tdmsFileNames);

maxNum = ones([1,length(tdmsFileTypes) + 1]).*-1;
for i = 1:length(tdmsFileTypes)
    typeFiles = dir(fullfile(saveDir,tdmsFileTypes{i}));
    fileStrings = {typeFiles.name};
    fileStrings = cellfun(@(x) x(end-8:end-5), fileStrings, 'UniformOutput', false);
    fileNums = cellfun(@str2double, fileStrings);
    maxNum(i) = max(fileNums);
end

i = i + 1;
typeFiles = {csvFiles.name};
fileStrings = {typeFiles.name};
fileStrings = cellfun(@(x) x(end-7:end-4), fileStrings, 'UniformOutput', false);
fileNums = cellfun(@str2double, fileStrings);
maxNum(i) = max(fileNums);

if ~all(maxNum(1) == maxNum)
    error('Max file number for at least one file type in saveDir differs from the rest')
end

%% Check the compressed dir and compare to the save dir. Generate the queue of data to be backed up
compQueue = {};
k = 0;
tdmsFileNames = {tdmsFiles.name};
csvFileNames = {csvFiles.name};
for i = 1:length(tdmsFiles)
    file_t = tdmsFiles(i).date;
    dateFolderName = sprintf("%02d_%02d_%d",month(file_t),day(file_t),year(file_t));
    compFiles = dir(fullfile(compressedDir,dateFolderName,"data*.7z"));
    compFileNames = {compFiles.name};
    compFileNames = cellfun(@(x) x(1:end-1), compFileNames, 'UniformOutput', false);
    if ~any(ismember(compFileNames,tdmsFiles(i).name(1:end-3)))
        k = k + 1;
        compQueue{k} = tdmsFiles(i).name;
    end
end

for i = 1:length(csvFiles)
    file_t = csvFiles(i).date;
    dateFolderName = sprintf("%02d_%02d_%d",month(file_t),day(file_t),year(file_t));
    compFiles = dir(fullfile(compressedDir,dateFolderName,"data*.7z"));
    compFileNames = {compFiles.name};
    compFileNames = cellfun(@(x) x(1:end-1), compFileNames, 'UniformOutput', false);
    if ~any(ismember(compFileNames,csvFiles(i).name(1:end-2)))
        k = k + 1;
        compQueue{k} = csvFiles(i).name;
    end
end

%% Check the status of uploading. make queue of stuff that has not been



%%

% % check for / create data folders in the data directories
% t_now = datetime("now");
% dateFolderName = sprintf("%02d_%02d_%d",month(t_now),day(t_now),year(t_now));
% for i = 1:length(saveDir)
%     if isempty(dir(fullfile(saveDir{i},dateFolderName)))
%         mkdir(fullfile(saveDir{i},dateFolderName));
%     end
% end

% stop / remove the existing data acquisition object, if there is one
if exist("d","var")
    d.stop;
    d.delete;
    clear d
end

% setup the NI DAQ system
d = setupDAQs(duration,tempSaveDir);

if exist("BBBt","var")
    try
        BBBt.stop;
        clear BBBt
    catch
    end
end
% set up the controller data stream
BBBt = streamBBBdata(tempSaveDir,duration);


function checkForNewFiles(tempSaveDir,oldFileList,fileQueue)
    currentTDMSFiles = dir(fullfile(tempSaveDir,'*.tdms'));
    currentCSVFiles = dir(fullfile(tempSaveDir,'*.csv'));
    
    fileNames = {currentTDMSFiles.name};
    if ~isempty(currentCSVFiles.name)
        fileNames = [fileNames,{currentCSVFiles.name}];
    end
end

% keep track of lists of file prefix types. When new one is created, take
% the second to last and

% In shell script
% - compress it using 7zip. Save compress file to a temporary location
% - move the file to the save paths
% - delete the origional file
% - upload to server?

% in MATLAB regular timer callback func
% Check for new (second set) of files. Once second set detected, add first
% set to compress and move queue. Move to folder based on date created
% flag. If first run (use first run flag) OK if files already exist (can
% skip) otherwise error if already exist

% deal with queue: check for 7z file in destination folder(s). Once it is
% there, shell script on next file

% stop function
% stop d
% stop / delete BBBt
% move / compress the files in tempData - should only be one set?
