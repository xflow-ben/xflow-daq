compressedDir = 'E:\loads_data\operating';
saveDir = 'D:\loads_data\operating_uncompressed'; 
uploadDir = 'X:\Experiments and Data\20 kW Prototype\Loads_Data\operating';


rawTDMSfiles = dir(fullfile(saveDir,'*.tdms'));
rawCSVfiles = dir(fullfile(saveDir,'*.csv'));

rawTDMSfileNames = {rawTDMSfiles.name};
rawTDMSfileDates = {rawTDMSfiles.date};
rawTDMSfileDates = cellfun(@(x) datetime(x),rawTDMSfileDates,'UniformOutput',true);
rawCSVfileNames = {rawCSVfiles.name};
rawCSVfileDates = {rawCSVfiles.date};
rawCSVfileDates = cellfun(@(x) datetime(x),rawCSVfileDates,'UniformOutput',true);

rawTDMSfileNamesTrunc = cellfun(@(x) x(1:end-5),rawTDMSfileNames,'UniformOutput',false);
rawCSVfileNamesTrunc = cellfun(@(x) x(1:end-4),rawCSVfileNames,'UniformOutput',false);

rawFileNamesTrunc = [rawTDMSfileNamesTrunc,rawCSVfileNamesTrunc];
rawFileDates = [rawTDMSfileDates,rawCSVfileDates];

compFiles = dir(fullfile(compressedDir,'*.7z'));
compFileNames = {compFiles.name};
compFileNamesTrunc = cellfun(@(x) x(1:end-3),compFileNames,'UniformOutput',false);


[processList,ind] = setdiff(rawFileNamesTrunc,compFileNamesTrunc);
processDates = rawFileDates(ind);
[~,ind] = sort(processDates,'ascend');
processList = processList(ind);

nfiles = length(processList);
for i = 1:nfiles
    sourceFile = dir(fullfile(saveDir,[processList{i},'.*']));
    delInd = [];
    for j = 1:length(sourceFile) % don't copy the tdms_index files
        if strcmp(sourceFile(j).name(end-4:end),'index')
            delInd = [delInd, j];
        end
    end
    sourceFile(delInd) = [];
    if length(sourceFile) ~= 1
        error('Error finding source file, too many files found')
    end
    sourceFilePath = fullfile(sourceFile.folder,sourceFile.name);
    compFilePath = fullfile(compressedDir,[processList{i},'.7z']);
    uploadFilePath = fullfile(uploadDir,[processList{i},'.7z']);

    % Create the PowerShell command with double quotes around paths (for spaces)
    powershellScriptPath =  'C:\Users\XFlow Energy\Documents\GitHub\xflow-daq\acquisition\implementations\10m_Spanish_Fork_testing\compress_and_limit.ps1';  % Update to actual path of the script
    powershellCommand = sprintf('powershell -ExecutionPolicy Bypass -File "%s" -sourceFilePath "%s" -destinationFilePath "%s" >nul', ...
        powershellScriptPath, sourceFilePath, compFilePath);
    fprintf('Compressing file %d of %d\n',i,nfiles)
    system(powershellCommand);

    pause(2)


    powershellScriptPath =  'C:\Users\XFlow Energy\Documents\GitHub\xflow-daq\acquisition\implementations\10m_Spanish_Fork_testing\upload_limited.ps1';  % Update to actual path of the script
    powershellCommand = sprintf('powershell -ExecutionPolicy Bypass -File "%s" -sourceFilePath "%s" -destinationFilePath "%s" >nul', ...
        powershellScriptPath, compFilePath, uploadFilePath);
    fprintf('Backing up to server file %d of %d\n',i,nfiles)
    system(powershellCommand);

end
