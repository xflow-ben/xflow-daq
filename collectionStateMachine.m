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

if src.UserData.tareRequest && ~strcmp(state,"lowWind")
    warning("Turbine state must be ""lowWind"" for a tare request to be executed\n")
    src.UserData.tareRequest = false;
end

backUpData(src); % we allways keep on top of backing up the data to the other drive

switch state
    case "turbDown"
        if ~comsDown && ~turbineFault
            state = "lowWind";
        else
            uploadData;
        end
    case "lowWind"
        if comsDown || turbineFault
            state = "turbDown";
            uploadData;
        else
            if src.UserData.BBB.UserData.windAv > src.UserData.windThresh
                windGood = true;
            else
                windGood = false;
            end
            if windGood
                startDataCollection(src);
                state = "running";
            elseif src.UserData.tareRequest
                state = "takingTare";
                src.UserData.tareStartTime = datetime("now");
                startTare(tareTime);
            else
                uploadData;
            end
        end
        
    case "running"
        if comsDown || turbineFault
            state = "turbDown";
            stopDataCollection;
        else
            windGood = checkWindspeed(windThresh);
            if ~windGood
                stopDataCollection;
                state = "lowWind";
            else
                compressCopyData;
            end
        end

    case "takingTare"
        timeNow = datetime("now");
        if seconds(timeNow - src.UserData.tareStartTime) + 2 > tareTime
            state = "lowWind";
            stopTare;
        end
end

src.UserData.state = state;
catch ME
    fprintf("\nError in collection loop: %s \n",ME.message)
    start(src);
end


    function startDataCollection(src)
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

        src.UserData.BBB.UserData.startStop = "start";
        src.UserData.d.start;


    end


    function src = stopDataCollection(src)

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


    

end