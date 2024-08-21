classdef sharedFunctions < handle
    properties(Constant)
        DAQmx = daqmx_header_consts;
    end
    methods(Static)
        function handleDAQmxError(lib, err)
            if err ~= 0
                % Define a buffer for the error string
                bufferSize = 1024;

                % Call DAQmxGetErrorString to get the error message
                [~, errorString] = calllib(lib, 'DAQmxGetErrorString', ...
                    err, blanks(bufferSize), uint32(bufferSize));

                % Remove any trailing null characters
                errorString = strtrim(errorString);

                % Throw an error with the message
                error('DAQmx Error: %s', errorString);
            end
        end

        function DAQmxValOut = getConstInputVal(optName,userIn,stringOptions,DAQmxVals)
            optInd = find(ismember(stringOptions,userIn));
            if isempty(optInd)
                errString = [optName,' options are '];
                for i = 1:length(stringOptions)
                    errString = [errString,stringOptions{i},', '];
                end
                errString(end-1:end) = [];
                error(errString);
            end

            if numel(optInd) > 1
                error('Matched more than one option??')
            end
            DAQmxValOut = DAQmxVals(optInd);
        end

    end

end

