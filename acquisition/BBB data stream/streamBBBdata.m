function t = streamBBBdata(saveDirectory,fileDurationSeconds)
    % UDPReceiverNonBlockingEnhanced: Receives UDP datagrams without blocking MATLAB.
    %
    % This function sets up a non-blocking UDP receiver using Java's DatagramSocket
    % and MATLAB's timer. It listens on a specified port and processes all incoming
    % datagrams available at each timer tick, reducing the chance of backlog and
    % packet loss.
    %% Ensure Cleanup on MATLAB Exit
    % Register the cleanup function to execute when MATLAB exits or the function is cleared
    cleanupObj = onCleanup(@()cleanup());
        %% set up file saving
    % make sure save dir exists
    if isempty(dir(saveDirectory))
        error('Cant find directory named %s',saveDirectory);
    end
    saveFilePath = makeNextFileNum(saveDirectory);
    saveFileID = fopen(saveFilePath,'w');
    dateFormatSpec = '%04d, %02d, %02d, %02d, %02d, %.6f\n';

    %% Import necessary Java classes
    import java.net.DatagramSocket
    import java.net.DatagramPacket
    import java.lang.reflect.Array

    %% Configuration Parameters
    port = 8888;            % UDP port to listen on
    bufferSize = 16384;       % Size of the buffer for incoming datagrams (in bytes)
    timerPeriod = 0.25;       % Timer period in seconds (e.g., 0.1s = 100ms)
    socketTimeout = 50;      % Socket timeout in milliseconds

    %% Initialize the DatagramSocket
    try
        socket = DatagramSocket(port);
        socket.setSoTimeout(socketTimeout);        % Set short timeout for non-blocking
        socket.setReceiveBufferSize(bufferSize);   % Adjust socket's receive buffer size
        actualBufferSize = socket.getReceiveBufferSize();
        disp(['UDP Receiver initialized on port ', num2str(port)]);
        disp(['Socket receive buffer size set to ', num2str(actualBufferSize), ' bytes']);
    catch ME
        error(['Failed to create DatagramSocket: ', ME.message]);
    end

    %% Create the DatagramPacket Buffer
    buffer = Array.newInstance(java.lang.Byte.TYPE, bufferSize);
    packet = DatagramPacket(buffer, bufferSize);



    %% Create the MATLAB Timer
    t = timer;
    t.StartDelay = timerPeriod;              % Set the delay before execution
    t.TimerFcn = @(src,event)timerCallback(src,event);        % Set the function to be executed
    t.StartFcn = @(src,event)startCallback(src,event);
    % t.ErrorFcn = @timerErrorHandler;
    t.ExecutionMode = 'singleShot'; % Execute the function only once
    t.UserData = struct();
    


    %% StartFcn callback: Called when the timer starts
    function startCallback(~, ~)
        t.UserData.fileStartTime = datetime("now");
        disp('Controller UDP Receiver started. Listening for data...');

    end


    %% Define the Timer Callback Function
    function timerCallback(~, ~)
        stop(t);
        try
            while true
                % Attempt to receive a datagram
                socket.receive(packet);
                % Extract data from the DatagramPacket

                receivedBytes = packet.getData();
                numBytes = packet.getLength();

                % Convert Java byte array to MATLAB uint8 array
                % MATLAB automatically handles Java's 0-based indexing
                if mod(numBytes,8) == 0
                    data = typecast(receivedBytes(1:numBytes),'double');
                else
                    error('Bad packet length?')
                end

                % Process the received data

                saveData(data.',t.UserData.fileStartTime);
            end
            
        catch ME

            % Handle SocketTimeoutException to exit the loop when no more packets are available
            if isprop(ME,'ExceptionObject') && strcmp(ME.ExceptionObject, 'java.net.SocketTimeoutException: Receive timed out')
                % No more datagrams available at this time
                % Optionally, perform other actions or logging here
            else
                % For other exceptions, display an error message
                disp(['Error in timerCallback: ', ME.message]);
            end
        end
        start(t);
    end

    %% Define the Data Processing Function
    function saveData(data,fileStartTime)
        % Example: Convert data to string and display
        persistent formatSpecStored
    
        if isempty(formatSpecStored)
            % Determine the number of elements in the vector
            n = length(data)-1;

            % Create the format string once based on the first vector's length
            if n == 0
                error('Vector is empty. Cannot create a format specification.');
            end

            formatSpecStored = [repmat('%.6f,', 1, n-1), '%.6f\n'];
            
            fprintf(saveFileID,dateFormatSpec,year(fileStartTime),month(fileStartTime),day(fileStartTime),hour(fileStartTime),minute(fileStartTime),second(fileStartTime));
        end

        fprintf(saveFileID, formatSpecStored, data(1:end-1));  % Write all but the last element with commas

        if seconds(datetime("now")-fileStartTime) > fileDurationSeconds
            fclose(saveFileID);
            saveFileID = fopen(makeNextFileNum(saveDirectory),'w');
            fileStartTime = datetime("now");
            t.UserData.fileStartTime = fileStartTime;
            fprintf(saveFileID,dateFormatSpec,year(fileStartTime),month(fileStartTime),day(fileStartTime),hour(fileStartTime),minute(fileStartTime),second(fileStartTime));

        end


    end

    %% Define the Timer Error Handler
%     function timerErrorHandler(~, ~)
%         disp('An error occurred in the timer.');
%         cleanup();
%     end

    %% Define the Cleanup Function
    function cleanup()
        % Stop and delete the timer
        if isvalid(t)
            stop(t);
            delete(t);
            disp('Timer stopped and deleted.');
        end

        % Close the DatagramSocket
        if exist('socket', 'var') && ~isempty(socket)
            socket.close();
            disp('DatagramSocket closed.');
        end

        disp('UDP Receiver stopped.');
        fclose(saveFileID);
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
