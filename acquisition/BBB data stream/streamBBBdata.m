function t = streamBBBdata(saveDirectory,fileDurationSeconds)

    %% Ensure Cleanup on MATLAB Exit
    % Register the cleanup function to execute when MATLAB exits or the function is cleared
    cleanupObj = onCleanup(@()cleanup());
        %% set up file saving
    % make sure save dir exists
    if isempty(dir(saveDirectory))
        error('Cant find directory named %s',saveDirectory);
    end
  
    dateFormatSpec = '%04d, %02d, %02d, %02d, %02d, %.6f\n';

    timerPeriod = 0.25;       % Timer period in seconds (e.g., 0.1s = 100ms)

    %% Create the MATLAB Timer
    t = timer;
    t.StartDelay = timerPeriod;              % Set the delay before execution
    t.TimerFcn = @(src,event)timerCallback(src,event);        % Set the function to be executed
    t.ExecutionMode = 'singleShot'; % Execute the function only once
    t.UserData = struct();
    t.UserData.mode = 'continuous'; % continuous or finite
    t.UserData.startStop = ''; % make "start" to start saving, "stop" to stop
    t.UserData.save = false; % True/false if saving data
    t.UserData.windAv = 0; % long average windspeed (max of 2 annos)
    t.UserData.windInst = 0; % instantaneous windspeed (max of 2 annos)
    t.UserData.comsDown = false;
    t.UserData.fileDurationSeconds = fileDurationSeconds;
    t.UserData.formatSpecStored = '';
    [t.UserData.socket, t.UserData.packet] = createUDPSocket;
    start(t);



    %% Define the Timer Callback Function
    function timerCallback(src, ~)
        stop(src);


        if strcmp(src.UserData.startStop,"start")
            if src.UserData.save
                warning("BBB saving already running")
            else
                saveFilePath = makeNextFileNum(saveDirectory);
                src.UserData.saveFileID = fopen(saveFilePath,'w');
                fileStartTime = datetime("now");
                src.UserData.fileStartTime = fileStartTime;
                fprintf(src.UserData.saveFileID,dateFormatSpec,year(fileStartTime),month(fileStartTime),day(fileStartTime),hour(fileStartTime),minute(fileStartTime),second(fileStartTime));
                src.UserData.save = true;
                if strcmp(src.UserData.mode,"finite")
                    src.UserData.startTime = fileStartTime;
                end
            end
        elseif strcmp(src.UserData.startStop,"stop")
            if ~src.UserData.save
                warning("BBB saving already stopped")
            else
                src = stopSaving(src);
            end
        elseif ~strcmp(src.UserData.startStop,"")
            error("Unrecognized command ""%s"" for UserData.startStop",src.UserData.startStop)
        end
        src.UserData.startStop = '';

        try
            while true
                % Attempt to receive a datagram
                src.UserData.socket.receive(src.UserData.packet);
                % Extract data from the DatagramPacket

                receivedBytes = src.UserData.packet.getData();
                numBytes = src.UserData.packet.getLength();

                % Convert Java byte array to MATLAB uint8 array
                % MATLAB automatically handles Java's 0-based indexing
                if mod(numBytes,8) == 0
                    data = typecast(receivedBytes(1:numBytes),'double');
                else
                    error('Bad packet length?')
                end

                if isempty(src.UserData.formatSpecStored)
                    n = length(data)-1;
                    src.UserData.formatSpecStored = [repmat('%.6f,', 1, n-1), '%.6f\n'];
                end
                src.UserData.comsDown = false;
                % Process the received data
                
                src.UserData.windAv = data(354);
                src.UserData.windInst = max(data(350:351));
                src.UserData.turbState = data(126); % UPDATE TO 
                disp(src.UserData.windInst);
                disp(src.UserData.turbState);
                
                if src.UserData.save
                    src = saveData(data.',src);
                end

            end
            
        catch ME
            
            % Handle SocketTimeoutException to exit the loop when no more packets are available
            if isprop(ME,'ExceptionObject') && strcmp(ME.ExceptionObject, 'java.net.SocketTimeoutException: Receive timed out')
                % No more datagrams available at this time
                % Optionally, perform other actions or logging here
                if strcmp(src.UserData.mode,"finite") && src.UserData.save
                    if seconds(datetime("now") - src.UserData.startTime) > src.UserData.fileDurationSeconds
                        src.UserData.save = false;
                    end
                end
            else
                % For other exceptions, display an error message
                disp(['Error in timerCallback: ', ME.message]);
                src = stopSaving(src);
                src.UserData.comsDown = true;
            end
        end
        start(src);
    end

    %% Define the Data Processing Function
    function src = saveData(data,src)

        fprintf(src.UserData.saveFileID, src.UserData.formatSpecStored, data(1:end-1));  % Write all but the last element with commas

        if seconds(datetime("now")-src.UserData.fileStartTime) > src.UserData.fileDurationSeconds
           
            if strcmp(src.UserData.mode,"continuous")
                fclose(src.UserData.saveFileID);
                src.UserData.saveFileID = fopen(makeNextFileNum(saveDirectory),'w');
                fileStartTime = datetime("now");
                t.UserData.fileStartTime = fileStartTime;
                fprintf(src.UserData.saveFileID,dateFormatSpec,year(fileStartTime),month(fileStartTime),day(fileStartTime),hour(fileStartTime),minute(fileStartTime),second(fileStartTime));
            elseif strcmp(src.UserData.mode,"finite")
                src = stopSaving(src);
            end

        end


    end

    function src = stopSaving(src)
        fclose(src.UserData.saveFileID);
        src.UserData.save = false;
    end

    %% Define the Timer Error Handler
%     function timerErrorHandler(~, ~)
%         disp('An error occurred in the timer.');
%         cleanup();
%     end

    %% Define the Cleanup Function
    function cleanup
        % Stop and delete the timer
        if isvalid(t)
            stop(t);
            delete(t);
            disp('Timer stopped and deleted.');
        end

        % Close the DatagramSocket
        if ~isempty(t.UserData.socket)
            t.UserData.socket.close();
        end

        fclose(t.UserData.saveFileID);
    end


    function fullFilePathOut = makeNextFileNum(directoryPath)

        TemplogFileNamePath = fullfile(directoryPath,['data_controller_','*.csv']);
        files = dir(TemplogFileNamePath);
        if isempty(files)
            nextFileNum = 0;
        else
            for i = 1:length(files)
                fileNums(i) = str2double(files(i).name(end-7:end-4));
            end
            if any(isnan(fileNums))
                error('error retreiving file numbers')
            end
            nextFileNum = max(fileNums) + 1;
        end
        fullFilePathOut = fullfile(directoryPath,['data_controller_',sprintf('%04.0f',nextFileNum),'.csv']);
    end


end
