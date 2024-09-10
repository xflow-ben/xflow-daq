function d = readTDMS(fileName,filePath,channelName)
%
% Reads in a TDMS file. This funciton to remain general (read in any TDMS
% file, don't perform and conversions or computations)
%
% fileName can be the full path and name of the file, or just the file name
% if fileName is only the file name, either provide the filePath argument,
% or make sure the current directory contains the file




% check for file

% filePath = 'C:\Users\Ben Strom\Documents\Loads_Data\new_system_cal\rotor_segment\full_hub_test_rotorStrain_0001.tdms';
filePath = fullfile(filePath,fileName);
if isempty(dir(filePath))
    error('File not found at %s',filePath);
end

lib = setUpTDMSLibrary;

% Initialize the data structure
d = struct();
d.property = [];
d.group = [];

% Initialize variables
fileHandle = libpointer('int64Ptr', 0);

% Open the TDMS file
err = calllib(lib, 'DDC_OpenFileEx', filePath, 'TDMS', 1, fileHandle);
fileHandle = fileHandle.Value;
handleTDMSLibErr(lib,err);

% Read and store file properties
d.property = readProperties(lib,fileHandle, 'file');

% Get the number of groups in the file
numGroups = libpointer('uint32Ptr', 0);
err = calllib(lib, 'DDC_GetNumChannelGroups', fileHandle, numGroups);
handleTDMSLibErr(lib,err);
numGroups = numGroups.Value;

% Get the group handles
groupHandles = libpointer('int64Ptr', zeros(1, numGroups));
err = calllib(lib, 'DDC_GetChannelGroups', fileHandle, groupHandles, numGroups);
handleTDMSLibErr(lib,err);

% Iterate through each group
for groupIndex = 1:numGroups
    groupHandle = groupHandles.Value(groupIndex);
    groupStruct = struct();

    % Read group name
    groupStruct.name = readProperty(lib,groupHandle, 'name', 'group');

    % Read group properties
    groupStruct.property = readProperties(lib,groupHandle, 'group');

    % Read group channels
    if nargin < 3
        groupStruct.channel = readChannels(lib,groupHandle);
    else
        groupStruct.channel = readChannels(lib,groupHandle,channelName);
    end

    % Append group structure to data structure
    d.group = [d.group; groupStruct];
end

% Close the file
err = calllib(lib, 'DDC_CloseFile', fileHandle);
handleTDMSLibErr(lib,err);

% Unload the library
unloadlibrary(lib);


    function properties = readProperties(lib, handle, type)
        err = 0;
        % Read all properties of the specified type (file, group, channel)
        numProperties = libpointer('uint32Ptr', 0);

        % Determine which function to call based on type
        if strcmp(type, 'file')
            err = calllib(lib, 'DDC_GetNumFileProperties', handle, numProperties);
        elseif strcmp(type, 'group')
            err = calllib(lib, 'DDC_GetNumChannelGroupProperties', handle, numProperties);
        elseif strcmp(type, 'channel')
            err = calllib(lib, 'DDC_GetNumChannelProperties', handle, numProperties);
        end
        handleTDMSLibErr(lib,err);

        numProperties = numProperties.Value;
        properties = struct;

        for propIndex = 0:numProperties-1

            % Get the property name
            nameSize = libpointer('uint64Ptr', 0);
            if strcmp(type, 'file')
                err = calllib(lib, 'DDC_GetFilePropertyNameLengthFromIndex', handle, propIndex, nameSize);
            elseif strcmp(type, 'group')
                err = calllib(lib, 'DDC_GetChannelGroupPropertyNameLengthFromIndex', handle, propIndex, nameSize);
            elseif strcmp(type, 'channel')
                err = calllib(lib, 'DDC_GetChannelPropertyNameLengthFromIndex', handle, propIndex, nameSize);
            end
            handleTDMSLibErr(lib,err);
            nameSize = nameSize.Value;
            name = libpointer('cstring',[blanks(nameSize) 0]);

            if strcmp(type, 'file')
                [err, name] = calllib(lib, 'DDC_GetFilePropertyNameFromIndex', handle, propIndex, blanks(nameSize+1), nameSize+1);
            elseif strcmp(type, 'group')
                [err, name] = calllib(lib, 'DDC_GetChannelGroupPropertyNameFromIndex', handle, propIndex, blanks(nameSize+1), nameSize+1);
            elseif strcmp(type, 'channel')
                [err, name] = calllib(lib, 'DDC_GetChannelPropertyNameFromIndex', handle, propIndex, blanks(nameSize+1), nameSize+1);
            end
            handleTDMSLibErr(lib,err);
            properties(propIndex + 1).name = name;

            % Get the property value
            properties(propIndex + 1).value = readProperty(lib,handle, name, type);

        end
    end

    function value = readProperty(lib,handle, propertyName, type)
        err = 0;
        % Get the property data type
        dataType = libpointer('voidPtr', 0);
        if strcmp(type, 'file')
            err = calllib(lib, 'DDC_GetFilePropertyType', handle, propertyName, dataType);
        elseif strcmp(type, 'group')
            err = calllib(lib, 'DDC_GetChannelGroupPropertyType', handle, propertyName, dataType);
        elseif strcmp(type, 'channel')
            err = calllib(lib, 'DDC_GetChannelPropertyType', handle, propertyName, dataType);
        end

        temp = typecast(dataType.Value,'int32');
        dataType = temp(1);
        if ~ismember(dataType,int32([5,2,3,9,10,23,30]))
            error('Did not find a valid data type for data (maybe typecast/ptr issue). dataType was %d',dataType)
        end
        handleTDMSLibErr(lib, err);

        % Retrieve the property value based on its data type
        try
            switch dataType
                case 5  % DDC_UInt8
                    value = libpointer('uint8Ptr', 0);
                    if strcmp(type, 'file')
                        err = calllib(lib, 'DDC_GetFilePropertyUInt8', handle, propertyName, value);
                    elseif strcmp(type, 'group')
                        err = calllib(lib, 'DDC_GetChannelGroupPropertyUInt8', handle, propertyName, value);
                    elseif strcmp(type, 'channel')
                        err = calllib(lib, 'DDC_GetChannelPropertyUInt8', handle, propertyName, value);
                    end
                    handleTDMSLibErr(lib, err);
                    value = value.Value;

                case 2  % DDC_Int16
                    value = libpointer('int16Ptr', 0);
                    if strcmp(type, 'file')
                        err = calllib(lib, 'DDC_GetFilePropertyInt16', handle, propertyName, value);
                    elseif strcmp(type, 'group')
                        err = calllib(lib, 'DDC_GetChannelGroupPropertyInt16', handle, propertyName, value);
                    elseif strcmp(type, 'channel')
                        err = calllib(lib, 'DDC_GetChannelPropertyInt16', handle, propertyName, value);
                    end
                    handleTDMSLibErr(lib, err);
                    value = value.Value;

                case 3  % DDC_Int32
                    value = libpointer('int32Ptr', 0);
                    if strcmp(type, 'file')
                        err = calllib(lib, 'DDC_GetFilePropertyInt32', handle, propertyName, value);
                    elseif strcmp(type, 'group')
                        err = calllib(lib, 'DDC_GetChannelGroupPropertyInt32', handle, propertyName, value);
                    elseif strcmp(type, 'channel')
                        err = calllib(lib, 'DDC_GetChannelPropertyInt32', handle, propertyName, value);
                    end
                    handleTDMSLibErr(lib, err);
                    value = value.Value;

                case 9  % DDC_Float
                    value = libpointer('singlePtr', 0);
                    if strcmp(type, 'file')
                        err = calllib(lib, 'DDC_GetFilePropertyFloat', handle, propertyName, value);
                    elseif strcmp(type, 'group')
                        err = calllib(lib, 'DDC_GetChannelGroupPropertyFloat', handle, propertyName, value);
                    elseif strcmp(type, 'channel')
                        err = calllib(lib, 'DDC_GetChannelPropertyFloat', handle, propertyName, value);
                    end
                    handleTDMSLibErr(lib, err);
                    value = value.Value;

                case 10  % DDC_Double
                    value = libpointer('doublePtr', 0);
                    if strcmp(type, 'file')
                        err = calllib(lib, 'DDC_GetFilePropertyDouble', handle, propertyName, value);
                    elseif strcmp(type, 'group')
                        err = calllib(lib, 'DDC_GetChannelGroupPropertyDouble', handle, propertyName, value);
                    elseif strcmp(type, 'channel')
                        err = calllib(lib, 'DDC_GetChannelPropertyDouble', handle, propertyName, value);
                    end
                    handleTDMSLibErr(lib, err);
                    value = value.Value;

                case 23  % DDC_String

                    valueSize = libpointer('uint32Ptr', 0);
                    if strcmp(type, 'file')
                        err = calllib(lib, 'DDC_GetFileStringPropertyLength', handle, propertyName, valueSize);
                    elseif strcmp(type, 'group')
                        err = calllib(lib, 'DDC_GetChannelGroupStringPropertyLength', handle, propertyName, valueSize);
                    elseif strcmp(type, 'channel')
                        err = calllib(lib, 'DDC_GetChannelStringPropertyLength', handle, propertyName, valueSize);
                    end
                    handleTDMSLibErr(lib, err);

                    valueSize = valueSize.Value + 1;
                    if strcmp(type, 'file')
                        [err,~,value] = calllib(lib, 'DDC_GetFilePropertyString', handle, propertyName, blanks(valueSize), valueSize);
                    elseif strcmp(type, 'group')
                        [err,~,value] = calllib(lib, 'DDC_GetChannelGroupPropertyString', handle, propertyName, blanks(valueSize), valueSize);
                    elseif strcmp(type, 'channel')
                        [err,~,value] = calllib(lib, 'DDC_GetChannelPropertyString', handle, propertyName, blanks(valueSize), valueSize);
                    end
                    handleTDMSLibErr(lib, err);

                case 30  % DDC_Timestamp
                    year = libpointer('uint32Ptr', 0);
                    month = libpointer('uint32Ptr', 0);
                    day = libpointer('uint32Ptr', 0);
                    hour = libpointer('uint32Ptr', 0);
                    minute = libpointer('uint32Ptr', 0);
                    second = libpointer('uint32Ptr', 0);
                    milliSecond = libpointer('doublePtr', 0);
                    if strcmp(type, 'file')
                        err = calllib(lib, 'DDC_GetFilePropertyTimestampComponents', handle, propertyName, ...
                            year, month, day, hour, minute, second, milliSecond, libpointer('uint32Ptr', 0));
                    elseif strcmp(type, 'group')
                        err = calllib(lib, 'DDC_GetChannelGroupPropertyTimestampComponents', handle, propertyName, ...
                            year, month, day, hour, minute, second, milliSecond, libpointer('uint32Ptr', 0));
                    elseif strcmp(type, 'channel')
                        err = calllib(lib, 'DDC_GetChannelPropertyTimestampComponents', handle, propertyName, ...
                            year, month, day, hour, minute, second, milliSecond, libpointer('uint32Ptr', 0));
                    end
                    handleTDMSLibErr(lib, err);

                    value = datetime(year.Value, month.Value, day.Value, ...
                        hour.Value, minute.Value, second.Value) + ...
                        milliseconds(milliSecond.Value);

                otherwise
                    value = 'Unsupported data type';
            end
        catch
            if err == -6214
                % fprintf('Property named %s has no value\n',propertyName);
                value = [];
            end
        end
    end

    function channels = readChannels(lib,groupHandle,channelName)
        err = 0;
        % Get the number of channels in the group
        numChannels = libpointer('uint32Ptr', 0);
        err = calllib(lib, 'DDC_GetNumChannels', groupHandle, numChannels);
        handleTDMSLibErr(lib, err);
        numChannels = numChannels.Value;

        % Get the channel handles
        channelHandles = libpointer('int64Ptr', zeros(1, numChannels));
        err = calllib(lib, 'DDC_GetChannels', groupHandle, channelHandles, numChannels);
        handleTDMSLibErr(lib, err);
        % Initialize channels structure
        channels = struct;
        countChan = 0;
        % Iterate through each channel
        for chanIndex = 1:numChannels
            channelHandle = channelHandles.Value(chanIndex);

            % Read channel name
            temp = readProperty(lib,channelHandle, 'name', 'channel');

            % Only read channel if it is a requested channel name
            if nargin < 3 || strcmp(temp,channelName)
                countChan = countChan + 1;
                channels(countChan).name = temp;
                % Read channel properties
                channels(countChan).property = readProperties(lib,channelHandle, 'channel');

                % Read channel data
                channels(countChan).data = readChannelData(lib,channelHandle);

                % Append channel structure to channels array
            end
        end
        if countChan == 0
            error('Designated channel name, %s, not in the TDMS data',channelName)
        end
    end

    function data = readChannelData(lib,channelHandle)
        err = 0;
        % Get the number of data values in the channel
        numValues = libpointer('uint64Ptr', 0);
        err = calllib(lib, 'DDC_GetNumDataValues', channelHandle, numValues);
        handleTDMSLibErr(lib, err);
        numValues = numValues.Value;

        % Determine the data type of the channel
        dataType = libpointer('voidPtr', 0);
        err = calllib(lib, 'DDC_GetDataType', channelHandle, dataType);
        temp = typecast(dataType.Value,'int32');
        dataType = temp(1);

        if ~ismember(dataType,int32([5,2,3,9,10,23,30]))
            error('Did not find a valid data type for data (maybe typecast/ptr issue). dataType was %d',dataType)
        end

        handleTDMSLibErr(lib, err);
        % dataType = dataType.Value;

        % Read the data based on the data type
        switch dataType
            case 5  % DDC_UInt8
                data = libpointer('uint8Ptr',zeros([numValues,1],'uint8'));
                err = calllib(lib, 'DDC_GetDataValuesUInt8', channelHandle, 0, numValues, data);
                handleTDMSLibErr(lib, err);
                data = data.Value;

            case 2  % DDC_Int16
                data = libpointer('int16Ptr',zeros([numValues,1],'int16'));
                err = calllib(lib, 'DDC_GetDataValuesInt16', channelHandle, 0, numValues, data);
                handleTDMSLibErr(lib, err);
                data = data.Value;
            case 3  % DDC_Int32
                data = libpointer('int32Ptr',zeros([numValues,1],'int32'));
                err = calllib(lib, 'DDC_GetDataValuesInt32', channelHandle, 0, numValues, data);
                handleTDMSLibErr(lib, err);
                data = data.Value;
            case 9  % DDC_Float (single)
                data = libpointer('singlePtr',zeros([numValues,1],'single'));
                err = calllib(lib, 'DDC_GetDataValuesFloat', channelHandle, 0, numValues, data);
                handleTDMSLibErr(lib, err);
                data = data.Value;
            case 10  % DDC_Double
                data = libpointer('doublePtr',zeros([numValues,1]));
                err = calllib(lib, 'DDC_GetDataValuesDouble', channelHandle, 0, numValues, data);
                handleTDMSLibErr(lib, err);
                data = data.Value;
            case 23  % DDC_String
                data = libpointer('cstringPtr',blanks(numValues));  % Strings are stored in a cell array
                err = calllib(lib, 'DDC_GetDataValuesString', channelHandle, 0, numValues, data);
                handleTDMSLibErr(lib, err);
                data = data.Value;
            case 30  % DDC_Timestamp
                year = libpointer('uint32Ptr',zeros([numValues,1],'uint32'));
                month = libpointer('uint32Ptr', zeros([numValues,1],'uint32'));
                day = libpointer('uint32Ptr', zeros([numValues,1],'uint32'));
                hour = libpointer('uint32Ptr', zeros([numValues,1],'uint32'));
                minute = libpointer('uint32Ptr', zeros([numValues,1],'uint32'));
                second = libpointer('uint32Ptr', zeros([numValues,1],'uint32'));
                milliSecond = libpointer('doublePtr', zeros([numValues,1]));

                err = calllib(lib, 'DDC_GetDataValuesTimestampComponents', channelHandle, 0, numValues, ...
                    year, month, day, hour, minute, second, milliSecond, []);

                handleTDMSLibErr(lib, err);

                % Combine the timestamp components into a datetime array
                data = datetime(year.Value, month.Value, day.Value, hour.Value, minute.Value, second.Value) + milliseconds(milliSecond.Value);

            otherwise
                data = 'Unsupported data type';
        end
    end
end