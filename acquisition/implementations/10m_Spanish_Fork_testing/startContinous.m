% NOTE: there can only be 2 saveDir currently
saveDir{1} = "E:\loads_data\operating";
saveDir{2} = "D:\loads_data\operating"; 

duration = 60*10; % 10 min file duratation

tempSaveDir = "C:\Users\XFlow Energy\Documents\GitHub\xflow-daq\tempData";

if isempty(dir(fullfile(tempSaveDir,'*.tdms')))
    error("The most recent data needs to still be in the tempdir for the file numering to increment correctly")
end

tdmsFiles = dir(fullfile(tempSaveDir,'*.tdms'));
csvFiles =  dir(fullFile(tempSaveDir,'*.csv'));

tdmsFileNames = {tdmsFiles.name};
for i = 1:length(tdmsFileNames)
    tdmsFileNames{i} = [tdmsFileNames{i}(1:end-9),'*.tdms'];
end
if length(tdmsFileNames) > unique(tdmsFileNames)
    error('There are multiple sets of TDMS files already in the tempSaveDir: %s', tempSaveDir)
end

if length(csvFiles) > 1
    error("there are multiple controller .csv files already in the tempSaveDir: %", tempSaveDir)
end
csvFileName = [csvFiles.name(1:end-8),'*.csv'];

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
