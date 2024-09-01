classdef channel < sharedFunctions
    properties
        device; % E.g. Dev1
        physicalChannel;  % Physical channel string (e.g., 'ai0')
        name;      % Name of the channel
    end

    properties (SetAccess = private, GetAccess = public)
        % visible to user, but not editable
        channelType;      % Type of the channel (e.g., AIVoltage, AIBridge, CICountEdges...)
        settings = struct; % s
    end

    properties (Access = private)
        lib;              % Library alias
        taskHandle;       % Handle to the parent task
    end
    methods

        function obj = channel(lib, taskHandle, channelType, device, physicalChannel, name, inputs)

            obj.physicalChannel = physicalChannel;
            obj.device = device;
            obj.lib = lib;
            obj.taskHandle = taskHandle;
            obj.name = name;
            channelName = name;

            if ~strcmp(device(end),'/')
                device = [device,'/'];
            end
            if strcmp(device(1),'/')
                device = device(2:end);
            end
            fullChannelPath = [device,physicalChannel];

            % Validate the physical channel before creating the channel
            % obj.validateChannel(physicalChannel);
            switch channelType
                case 'AIVoltage'
                    terminalConfig = sharedFunctions.getConstInputVal('terminalConfig',inputs{1},{'RSE','Diff','NRSE'},[sharedFunctions.DAQmx.Val_RSE,sharedFunctions.DAQmx.Val_Diff,sharedFunctions.DAQmx.Val_NRSE]);
                    obj.settings.terminalConfig = inputs{1};
                    obj.settings.inputRange = inputs{2};
                    minVal = obj.settings.inputRange(1);
                    maxVal = obj.settings.inputRange(2);
                    obj.settings.units = 'Volts';
                    customScaleName = '';
                    units = sharedFunctions.DAQmx.Val_Volts;

                    % Call the DAQmxCreateAIVoltageChan function
                    err = calllib(lib, 'DAQmxCreateAIVoltageChan', ...
                        taskHandle, ...          % voidPtr
                        fullChannelPath, ...     % cstring
                        channelName, ...         % cstring
                        terminalConfig, ...      % int32
                        minVal, ...              % double
                        maxVal, ...              % double
                        units, ...               % int32
                        customScaleName);        % cstring

                    % Check for errors using the updated error handling function
                    sharedFunctions.handleDAQmxError(lib, err);
                case 'CICountEdges'


                    % Extract and cast the arguments
                    obj.settings.edgeDirection = inputs{1};
                    obj.settings.countDirection = inputs{3};  % double
                    obj.settings.initialValue = int32(inputs{2});
                    initialValue = int32(inputs{2});

                    edgeDirection = sharedFunctions.getConstInputVal('edgeDirection',inputs{1},{'rising','falling'},[sharedFunctions.DAQmx.Val_Rising,sharedFunctions.DAQmx.Val_Falling]);
                    countDirection = sharedFunctions.getConstInputVal('countDirection',inputs{3},{'up','down','external'},[sharedFunctions.DAQmx.Val_CountUp, sharedFunctions.DAQmx.Val_CountDown, sharedFunctions.DAQmx.Val_ExtControlled]);

                    % Call the DAQmxCreateAIVoltageChan function
                    % err = calllib('myni', 'DAQmxCreateCICountEdgesChan',
                    % counterTask.taskHandle,
                    % 'cDAQ9188-18F21FFMod2/ctr0',
                    % ''
                    % , d.DAQmx_Val_Rising, int32(0), d.DAQmx_Val_CountUp);

                    err = calllib(lib, 'DAQmxCreateCICountEdgesChan', ...
                        taskHandle, ...          % voidPtr
                        fullChannelPath, ...     % cstring
                        channelName, ...         % cstring
                        edgeDirection, ...      % int32
                        initialValue, ...              % double
                        countDirection);        % cstring

                    % Check for errors using the updated error handling function
                    sharedFunctions.handleDAQmxError(lib, err);
                case 'CIAngEncoder'
                    if ~strcmp(device(1),'/')
                        device = ['/',device];
                    end
                    AInputTerm = [device,inputs{1}];
                    obj.settings.AInputTerm = AInputTerm;
                    BInputTerm = [device,inputs{2}];
                    obj.settings.BInputTerm = BInputTerm;
                    if ~isempty(inputs{3})
                        ZInputTerm = [device,inputs{3}]; % leave empty ('') to disable z reset
                    else
                        ZInputTerm = '';
                    end
                    obj.settings.ZInputTerm = ZInputTerm;

                    obj.settings.decodingType = inputs{4};
                    decodingType = sharedFunctions.getConstInputVal('decodingType',inputs{4},{'X1','X2','X4'},[sharedFunctions.DAQmx.Val_X1,sharedFunctions.DAQmx.Val_X2,sharedFunctions.DAQmx.Val_X4]);
               
                    obj.settings.pulsesPerRev = inputs{5};
                    pulsesPerRev = uint32(inputs{5});

                    initialAngle = 0.0;

                    ZidxPhase = sharedFunctions.getConstInputVal('ZidxPhase',inputs{6},{'AHighBHigh','AHighBLow','ALowBHigh','ALowBLow'},[sharedFunctions.DAQmx.Val_AHighBHigh,sharedFunctions.DAQmx.Val_AHighBLow,sharedFunctions.DAQmx.Val_ALowBHigh,sharedFunctions.DAQmx.Val_ALowBLow]);
                     obj.settings.ZidxPhase = inputs{6};
                   
                    if isempty(ZInputTerm)
                        ZidxEnable = uint32(0);
                    else
                        ZidxEnable = uint32(1);
                    end

                    ZidxVal = 0.0;
                    customScaleName = '';
      
                    units = sharedFunctions.DAQmx.Val_Ticks;

                    err = calllib(lib, 'DAQmxCreateCIAngEncoderChan',...
                        taskHandle,...
                        fullChannelPath,...
                        channelName,...
                        decodingType,...
                        ZidxEnable,...
                        ZidxVal,...
                        ZidxPhase,...
                        units,...
                        pulsesPerRev,...
                        initialAngle,...
                        customScaleName);

                    sharedFunctions.handleDAQmxError(lib, err);
                    % set the intput terminals
                    err = calllib(lib,'DAQmxSetCIEncoderAInputTerm',taskHandle,channelName,AInputTerm);
                    sharedFunctions.handleDAQmxError(lib, err);
                    err = calllib(lib,'DAQmxSetCIEncoderBInputTerm',taskHandle,channelName,BInputTerm);
                    sharedFunctions.handleDAQmxError(lib, err);
                    if ~isempty(ZInputTerm)
                        err = calllib(lib,'DAQmxSetCIEncoderZInputTerm',taskHandle,channelName,ZInputTerm);
                        sharedFunctions.handleDAQmxError(lib, err);
                    end


                case 'AIResistance'
                    % Extract and cast the arguments
                    obj.settings.inputRange = inputs{1};
                    minVal = obj.settings.inputRange(1);  % double
                    maxVal = obj.settings.inputRange(2);  % double
                    obj.settings.resistanceConfig = inputs{2};
                    resistanceConfig = sharedFunctions.getConstInputVal('resistanceConfig',inputs{2},{'2 wire','3 wire','4 wire'},[sharedFunctions.DAQmx.Val_2Wire,sharedFunctions.DAQmx.Val_3Wire,sharedFunctions.DAQmx.Val_4Wire]);
                    obj.settings.currentExcitSource = inputs{3};
                    currentExcitSource = sharedFunctions.getConstInputVal('currentExcitSource',inputs{3},{'internal','external','none'},[sharedFunctions.DAQmx.Val_Internal,sharedFunctions.DAQmx.Val_External,sharedFunctions.DAQmx.Val_None]);
                    currentExcitVal = inputs{4};
                    obj.settings.ExcitVal = inputs{4};
                    obj.settings.units = 'Ohms';
                    units = sharedFunctions.DAQmx.Val_Ohms;
                    customScaleName = '';


                    % Call the DAQmxCreateAIVoltageChan function
                    err = calllib(lib, 'DAQmxCreateAIResistanceChan', ...
                        taskHandle, ...          % voidPtr
                        fullChannelPath, ...     % cstring
                        channelName, ...         % cstring
                        minVal, ...              % double
                        maxVal, ...              % double
                        units, ...               % int32
                        resistanceConfig,...
                        currentExcitSource,...
                        currentExcitVal,...
                        customScaleName);        % cstring

                    % Check for errors using the updated error handling function
                    sharedFunctions.handleDAQmxError(lib, err);
                case 'AIRTD'


                    obj.settings.inputRange = inputs{1};
                    minVal = obj.settings.inputRange(1);  % double
                    maxVal = obj.settings.inputRange(2);  % double

                    units = sharedFunctions.getConstInputVal('units',inputs{2},{'Deg C', 'Deg F','Kelvins','Dev R'},[sharedFunctions.DAQmx.Val_DegC,sharedFunctions.DAQmx.Val_DegF,sharedFunctions.DAQmx.Val_Kelvins,sharedFunctions.DAQmx.Val_DegR]);
                    obj.settings.units = inputs{2};

                    rtdType = sharedFunctions.getConstInputVal('RTD Type',inputs{3},{'Pt3750','Pt3851','Pt3911','Pt3916','Pt3920','Pt3928','Custom'},[sharedFunctions.DAQmx.Val_Pt3750,sharedFunctions.DAQmx.Val_Pt3851,sharedFunctions.DAQmx.Val_Pt3911,sharedFunctions.DAQmx.Val_Pt3916,sharedFunctions.DAQmx.Val_Pt3920,sharedFunctions.DAQmx.Val_Pt3928,sharedFunctions.DAQmx.Val_Custom]);
                    obj.settings.rtdType = inputs{3};

                    obj.settings.resistanceConfig = inputs{4};
                    resistanceConfig = sharedFunctions.getConstInputVal('resistanceConfig',inputs{4},{'2 wire','3 wire','4 wire'},[sharedFunctions.DAQmx.Val_2Wire,sharedFunctions.DAQmx.Val_3Wire,sharedFunctions.DAQmx.Val_4Wire]);

                    obj.settings.currentExcitSource = inputs{5};
                    currentExcitSource = sharedFunctions.getConstInputVal('currentExcitSource',inputs{5},{'internal','external','none'},[sharedFunctions.DAQmx.Val_Internal,sharedFunctions.DAQmx.Val_External,sharedFunctions.DAQmx.Val_None]);

                    currentExcitVal = inputs{6};
                    obj.settings.ExcitVal = inputs{6};

                    r0 = inputs{7};
                    obj.settings.r0 = inputs{7};


                    % Call the DAQmxCreateAIVoltageChan function
                    err = calllib(lib, 'DAQmxCreateAIRTDChan', ...
                        taskHandle, ...          % voidPtr
                        fullChannelPath, ...     % cstring
                        channelName, ...         % cstring
                        minVal, ...              % double
                        maxVal, ...              % double
                        units, ...               % int32
                        rtdType,...
                        resistanceConfig,...
                        currentExcitSource,...
                        currentExcitVal,...
                        r0);        % cstring

                    % Check for errors using the updated error handling function
                    sharedFunctions.handleDAQmxError(lib, err);
                case 'AIBridge'

                    % Extract and cast the arguments
                    obj.settings.inputRange = inputs{2};
                    minVal = obj.settings.inputRange(1);  % double
                    maxVal = obj.settings.inputRange(2);  % double

                    units = sharedFunctions.getConstInputVal('units',inputs{1},{'Volts per Volt','mV per Volt'},[sharedFunctions.DAQmx.Val_VoltsPerVolt,sharedFunctions.DAQmx.Val_mVoltsPerVolt]);
                    obj.settings.units = inputs{1};
                    bridgeConfig = sharedFunctions.getConstInputVal('bridgeConfig',inputs{3},{'full','half','quarter'},[sharedFunctions.DAQmx.Val_FullBridge,sharedFunctions.DAQmx.Val_HalfBridge,sharedFunctions.DAQmx.Val_QuarterBridge]);
                    obj.settings.bridgeConfig = inputs{3};
                    voltageExcitSource = sharedFunctions.getConstInputVal('voltageExcitSource',inputs{4},{'internal','external','none'},[sharedFunctions.DAQmx.Val_Internal,sharedFunctions.DAQmx.Val_External,sharedFunctions.DAQmx.Val_None]);
                    obj.settings.voltageExcitSource = inputs{4};
                    voltageExcitVal = inputs{5};
                    obj.settings.voltageExcitVal = voltageExcitVal;
                    nominalBridgeResistance = inputs{6};
                    obj.settings.nominalBridgeResistance = nominalBridgeResistance;
                    customScaleName = '';

                    % Call the DAQmxCreateAIVoltageChan function
                    err = calllib(lib, 'DAQmxCreateAIBridgeChan', ...
                        taskHandle, ...          % voidPtr
                        fullChannelPath, ...     % cstring
                        channelName, ...         % cstring
                        minVal, ...              % double
                        maxVal, ...              % double
                        units, ...               % int32
                        bridgeConfig,...
                        voltageExcitSource,...
                        voltageExcitVal,...
                        nominalBridgeResistance,...
                        customScaleName);        % cstring

                    % Check for errors using the updated error handling function
                    sharedFunctions.handleDAQmxError(lib, err);

                otherwise
                    error('Channel type %s not yet programmed, or spelled incorrectly',channelType)
            end
        end

    end
end

