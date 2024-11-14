function collectionStateMachine(src,~)

% states

% turbDown - coms to controller are down, or turbine is in an error state
% lowWind - wind to low to run/collect, waiting
% running - wind high enough to collect data
% takingTare - taking tare, only possible in low wind


% Timer object user data
% state - string describing state for state maching
% tareRequest - bool, user is requesting system take a tare
% tareStartTime - time at which tare was initialized
% d - the xfedaq data acquisition object
% BBB - the controller data collection timer object
% windThresh - start collecting data when average is this level
% fileDurationSeconds - length of continuous files
% tareLengthSeconds - length of tare files
stop(src);
fprintf("Current state: %s\n",src.UserData.state);
try
    state = src.UserData.state;

    % EVERY LOOP
    comsDown = src.UserData.BBB.UserData.comsDown; % check for coms and if down try to reconnect (set comsDown = true/false)
    if ~comsDown
        stnum = src.UserData.BBB.UserData.turbState;
        if stnum < 100
            stnum = floor(stnum/10);
        else
            stnum = floor(stnum/100);
        end
        if stnum < 5
            turbineFault = false;
        else
            turbineFault = true;
        end
    else
        turbineFault = false;
    end
    
    if ~comsDown
        allOnline = checkDaqsOnline();
        if ~allOnline
            pause(10);
            allOnline = checkDaqsOnline();
        end
        if ~allOnline
            stopContinuous;
            error('Lost communication with one of the DAQs')
        end
    end

    if src.UserData.tareRequest && ~strcmp(state,"lowWind")
        warning("Turbine state must be ""lowWind"" for a tare request to be executed\n")
        src.UserData.tareRequest = false;
    end


    src = backUpData(src); % we allways keep on top of backing up the data to the other drive

    switch state
        case "turbDown"
            if ~comsDown && ~turbineFault
                state = "lowWind";
            else
                src = uploadData(src);
            end
        case "lowWind"
            if comsDown || turbineFault
                state = "turbDown";
                src = uploadData(src);
            else
                if src.UserData.BBB.UserData.windAv > src.UserData.windThresh
                    windGood = true;
                else
                    windGood = false;
                end
                if windGood
                    src = startDataCollection(src);
                    state = "running";
                    disp("WIND IS GOOD, STARTING DATA COLLECTION")
                elseif src.UserData.tareRequest
                    state = "takingTare";

                    src = startTare(src, tareTime);
                else
                    src = uploadData(src);
                end
            end

        case "running"
            if comsDown || turbineFault
                state = "turbDown";
                src = stopDataCollection(src);
            else
                windGood = true;
                if src.UserData.BBB.UserData.windAv < src.UserData.windThreshStop
                    windGood = false;
                end
                if ~windGood
                    src = stopDataCollection(src);
                    state = "lowWind";
                else
                    nSampsTemp = src.UserData.d.getNSampsAcq;
                    if all(nSampsTemp == src.UserData.nSampsAcqVec)
                        warning('One of the DAQ tasks has stopped. Restarting the acquisition')
                        src = stopDataCollection(src);
                        pause(15);
                        src = startDataCollection(src);
                    else
                        src.UserData.nSampsAcqVec = nSampsTemp;
                    end
                end
            end

        case "takingTare"
            timeNow = datetime("now");
            if seconds(timeNow - src.UserData.tareStartTime) + 2 > tareTime
                state = "lowWind";
                src = stopTare(src);
            end
    end

    src.UserData.state = state;
catch ME
    fprintf("\nError in collection loop: %s \n",ME.message)
        % Display the line number where the error occurred
    % Display the entire stack trace
    disp('Error Stack:');
    for k = 1:length(ME.stack)
        fprintf('In %s (line %d) in file %s\n', ME.stack(k).name, ME.stack(k).line, ME.stack(k).file);
    end

end
start(src);

    function src = startDataCollection(src)
        src.UserData.BBB.UserData.mode = 'continuous';
        src.UserData.BBB.UserData.fileDurationSeconds = src.UserData.fileDurationSeconds;


        reconfigDaq = false;
        if ~strcmp(src.UserData.d.acquisitionType,"continuous")
            src.UserData.d.acquisitionType = "continuous";
            reconfigDaq = true;
        end

        if src.UserData.d.durationSeconds ~= src.UserData.fileDurationSeconds
            src.UserData.d.durationSeconds = src.UserData.fileDurationSeconds;
            reconfigDaq = true;
        end

        if reconfigDaq
            src.UserData.d.applyConfigs;
        end

        
        t_now = datetime("now");
        src.UserData.BBB.UserData.startStop = "start";
        src.UserData.d.logging.fileNamePrefix = sprintf('data_%02d%02d%02d%02d%02d',month(t_now),day(t_now),hour(t_now),minute(t_now),round(second(t_now)));
        src.UserData.d.applyConfigs;
        src.UserData.d.start;
        pause(1)
        src.UserData.nSampsAcqVec = src.UserData.d.getNSampsAcq;


    end


    function src = stopDataCollection(src)
        src.UserData.BBB.UserData.startStop = "stop";
        src.UserData.d.stop;
        pause(0.5);
        src = getUploadQueue(src);
    end

    function src = getUploadQueue(src)
        src.UserData.serverOnline = 1;
        src.UserData.uploadQueue = {};
        if isempty(dir(src.UserData.uploadDir))
            src.UserData.serverOnline = 0;
            warning("XFlow NAS not online, no uploading");
        else
            src.UserData.uploadQueue = compareDirectories(src.UserData.compressedDir, src.UserData.uploadDir);
        end
    end

    function src = backUpData(src)
%         disp("entered backup data func")
%         % don't try to move/compress data that is still being written to
%         if strcmp(src.UserData.state,"running") || strcmp(src.UserData.state,"takingTare")
%             getNewest = false;
%         else
%             getNewest = true;
%         end
% 
%         % update the queue
%         tdmsFiles = dir(fullfile(src.UserData.saveDir,'*.tdms'));
%         csvFiles = dir(fullfile(src.UserData.saveDir,'*.csv'));
%         tdmsFileNames = {tdmsFiles.name};
%         csvFileNames = {csvFiles.name};
% 
%         newTDMSFiles = setdiff(tdmsFileNames, src.UserData.oldTdmsFiles);  % Detect new files
%         newCSVFiles = setdiff(csvFileNames, src.UserData.oldCsvFiles);  % Detect new files
% 
%         if ~isempty(newTDMSFiles) || ~isempty(newCSVFiles)
% 
% 
%             if getNewest
%                 src.UserData.compQueue = [src.UserData.compQueue, newTDMSFiles, newCSVFiles];
%                 src.UserData.oldTdmsFiles = [src.UserData.oldTdmsFiles, newTDMSFiles];
%                 src.UserData.oldCsvFiles = [src.UserData.oldCsvFiles, newCSVFiles];
%             else
%                 t_now = datetime("now");
%                 if ~isempty(newTDMSFiles)
%                     for i = 1:length(newTDMSFiles)
%                         file = dir(fullfile(src.UserData.saveDir,newTDMSFiles{i}));
%                         if seconds(t_now - datetime(file.date)) >  src.UserData.fileDurationSeconds + 5
%                             src.UserData.compQueue = [src.UserData.compQueue, newTDMSFiles(i)];
%                             src.UserData.oldTdmsFiles = [src.UserData.oldTdmsFiles,  newTDMSFiles(i)];
%                         end
%                     end
% 
% 
%                     %                     tdmsFileTypes = unique(cellfun(@(x) x(1:end-9),newTDMSFiles,'UniformOutput',false));
%                     %                     for i = 1:length(tdmsFileTypes)
%                     %                         inds = find(cellfun(@(x) contains(x, tdmsFileTypes{i}), newTDMSFiles));
%                     %                         fileNums = cellfun(@(x) str2double(x(end-8:end-5)),newTDMSFiles(inds),'UniformOutput',true);
%                     %                         if length(isnan(fileNums)) == 1
%                     %                             fileNums(isnan(fileNums)) = -1;
%                     %                         elseif length(isnan(fileNums)) > 1
%                     %                             error("More than one file num with no trailing number")
%                     %                         end
%                     %                         if lengthFileNums > 1
%                     %                             inds2 = find(fileNums ~= max(fileNums));
%                     %                             src.UserData.oldTdmsFiles = [src.UserData.oldTdmsFiles, newTDMSFiles(inds(inds2))];
%                     %                             src.UserData.compQueue = [src.UserData.compQueue, newTDMSFiles(inds(inds2))];
%                     %                         end
%                     %                     end
%                 end
% 
%                 if ~isempty(newCSVFiles)
%                     %                     fileNums = cellfun(@(x) str2double(x(end-7:end-4)),newVSCFiles,'UniformOutput',true);
%                     %                     inds = find(fileNums ~= max(fileNums));
%                     %                     src.UserData.oldCsvFiles = [src.UserData.oldCsvFiles, newVSCFiles(inds)];
%                     %                     src.UserData.compQueue = [src.UserData.compQueue, newVSCFiles(inds)];
% 
%                     for i = 1:length(newCSVFiles)
%                         file = dir(fullfile(src.UserData.saveDir,newCSVFiles{i}));
%                         if seconds(t_now - datetime(file.date)) >  src.UserData.fileDurationSeconds + 5
%                             src.UserData.compQueue = [src.UserData.compQueue, newCSVFiles(i)];
%                             src.UserData.oldCsvFiles = [src.UserData.oldCsvFiles, newCSVFiles(i)];
%                         end
%                     end
%                 end
%             end
% 
%         end
%         % now need to do the transferring
% 
% 
% 
%         % If there's an ongoing process, wait for it to finish
%         if ~isempty(src.UserData.compressProcess) && ~src.UserData.compressProcess.HasExited
%             disp("return happened here")
%             return;  % Do nothing if a process is still running
%         end
% 
%         % If the queue is not empty, process the next file
%         if ~isempty(src.UserData.compQueue)
%             % Pop the next file from the queue (FIFO)
%             currentFile = src.UserData.compQueue{1};
%             src.UserData.compQueue(1) = [];  % Remove the processed file from the queue
% 
%             % Define destination file path for the compressed file
%             sourceFile = fullfile(src.UserData.saveDir,currentFile);
%             fileInfo = dir(sourceFile);
%             if isempty(fileInfo)
%                 error("couldn't find file %s",sourceFile)
%             end
% 
%             file_t = fileInfo.date;
%             dateFolderName = sprintf('%02d_%02d_%d',month(file_t),day(file_t),year(file_t));
%             [~, fileName, ~] = fileparts(currentFile);
% 
%             destinationFile = fullfile(src.UserData.compressedDir,dateFolderName,fileparts(currentFile), [fileName '.7z']);
% 
%             % Create the PowerShell command with double quotes around paths (for spaces)
%             powershellScriptPath =  'C:\Users\XFlow Energy\Documents\GitHub\xflow-daq\acquisition\implementations\10m_Spanish_Fork_testing\compress_and_limit.ps1';  % Update to actual path of the script
%             powershellCommand = sprintf('-File "%s" -sourceFilePath "%s" -destinationFilePath "%s"', ...
%                 powershellScriptPath, sourceFile, destinationFile);
% 
%             % Start the PowerShell process with the script
%             disp(['Starting compression for: ', currentFile]);
%             % Create and start the process using .NET's System.Diagnostics.Process
%             process = System.Diagnostics.Process();
%             process.StartInfo.FileName = 'powershell.exe';
%             process.StartInfo.Arguments = powershellCommand;
%             process.StartInfo.CreateNoWindow = true;  % Prevents PowerShell window from popping up
%             process.StartInfo.UseShellExecute = false;
%             process.StartInfo.RedirectStandardOutput = true;  % Redirect output to MATLAB (optional)
% 
%             % Start the process
%             process.Start();
% 
%             % Store the process in UserData for later reference
%             src.UserData.compressProcess = process;
% 
% 
%         end

    end

    function src = uploadData(src)
%         if ~isempty(src.UserData.uploadProcess) && ~src.UserData.uploadProcess.HasExited
%             return;  % Do nothing if a process is still running
%         end
% 
%         if ~isempty(src.UserData.uploadQueue)
%             currentFile = src.UserData.uploadQueue{1};
%             src.UserData.uploadQueue(1) = [];  % Remove the processed file from the queue
%             sourceFile = fullfile(src.UserData.compressedDir,currentFile);
%             destinationFile = fullfile(src.UserData.uploadDir,currentFile);
%             powershellScriptPath =  'C:\Users\XFlow Energy\Documents\GitHub\xflow-daq\acquisition\implementations\10m_Spanish_Fork_testing\upload_limited.ps1';  % Update to actual path of the script
%             powershellCommand = sprintf('-File "%s" -sourceFilePath "%s" -destinationFilePath "%s"', ...
%                 powershellScriptPath, sourceFile, destinationFile);
%             disp(['Starting file server upload for: ', currentFile]);
% 
%                   % Create and start the process using .NET's System.Diagnostics.Process
%             process = System.Diagnostics.Process();
%             process.StartInfo.FileName = 'powershell.exe';
%             process.StartInfo.Arguments = powershellCommand;
%             process.StartInfo.CreateNoWindow = true;  % Prevents PowerShell window from popping up
%             process.StartInfo.UseShellExecute = false;
%             process.StartInfo.RedirectStandardOutput = true;  % Redirect output to MATLAB (optional)
% 
%             % Start the process
%             process.Start();
% 
%             % Store the process in UserData for later reference
%             src.UserData.uploadProcess = process; 
%         end


    end


    function src = startTare(src)
        src.UserData.tareStartTime = datetime("now");

    end

    function src = stopTare(src)

    end

    function allOnline = checkDaqsOnline()
        % List of IP addresses to check
        ipList = {'192.168.2.102', '192.168.2.164', '192.168.2.138','192.168.2.172'};  % Add your IPs here

        allOnline = true;  % Assume all are online initially

        % Loop through each IP and check if it responds to a ping
        for i = 1:length(ipList)
            ip = ipList{i};

            % For Windows: Use '-n 1' (send one ping)
            % For Linux/Mac: Use '-c 1'
            if ispc
                pingCommand = sprintf('ping -n 1 %s', ip);
            else
                pingCommand = sprintf('ping -c 1 %s', ip);
            end

            % Execute the ping command
            [status, ~] = system(pingCommand);

            % If ping fails (status is not 0), set allOnline to false and break the loop
            if status ~= 0
                allOnline = false;
                return;  % Stop checking further IPs as one is offline
            end
        end
    end





end