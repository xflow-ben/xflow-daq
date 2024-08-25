classdef sharedFunctions < handle
    properties(Constant, Hidden)
        DAQmx = daqmx_header_consts;
        taskTypeOptions = {'AI','CI','DI','AO','DO'}; % pretty sure these have to be different tasks, and dermine the read function
    end
    methods(Static)
        function handleDAQmxError(lib, err)
            if err ~= 0
                % Define a buffer for the error string
                bufferSize = 1024;

                % Call DAQmxGetErrorString to get the error message
                [~, errorString] = calllib(lib, 'DAQmxGetErrorString', ...
                    err, blanks(bufferSize), uint32(bufferSize));

                [~, extendedErrorString] = calllib(lib,'DAQmxGetExtendedErrorInfo',blanks(bufferSize), uint32(bufferSize));

                % Remove any trailing null characters
                errorString = strtrim(errorString);
                extendedErrorString = strtrim(extendedErrorString);

                if isempty(extendedErrorString)
                % Throw an error with the message
                    error('DAQmx Error: %s', errorString);
                else
                    error('DAQmx Error: %s\n\nError Details: %s', errorString,extendedErrorString);
                end
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

