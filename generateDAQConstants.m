function generateDAQConstants(headerFilePath, outputFilePath)
    % take the NIDAQmc.h file and generate corresponding constants for
    % matlab (constants only, not functions)
    % Open the header file
    fid = fopen(headerFilePath, 'r');
    if fid == -1
        error('Cannot open header file.');
    end

    % Read the header file line by line
    constants = containers.Map;
    comments = {};
    while ~feof(fid)
        line = strtrim(fgetl(fid));
        
        % Collect comments
        if startsWith(line, '//')
            comments{end+1} = strrep(line, '//', '%');
        elseif startsWith(line, '#define')
            parts = strsplit(line);
            if numel(parts) >= 3
                name = parts{2};
                value = parts{3};
                
                % Check for valid MATLAB identifier
                if isvarname(name)
                    % Handle hex and numeric values
                    if startsWith(value, '0x')
                        value = ['hex2dec(''' value(3:end) ''')'];
                    elseif all(isstrprop(value, 'digit') | value == '-')
                        % Do nothing, value is already a valid number
                    else
                        continue; % Skip non-numeric and non-hex values
                    end
                    
                    % Store the constant with its comments
                    if ~isKey(constants, name)
                        constants(name) = struct('value', value, 'comments', {comments});
                    end
                end
            end
            comments = {}; % Reset comments
        end
    end
    fclose(fid);

    % Open the output file
    fout = fopen(outputFilePath, 'w');
    if fout == -1
        error('Cannot open output file.');
    end

    % Write the class definition header
    fprintf(fout, 'classdef MyDAQConstants\n');
    fprintf(fout, '    properties (Constant)\n');

    % Write the constants and their comments
    keys = constants.keys;
    for i = 1:numel(keys)
        name = keys{i};
        value = constants(name).value;
        commentLines = constants(name).comments;
        for j = 1:numel(commentLines)
            fprintf(fout, '        %s\n', commentLines{j});
        end
        fprintf(fout, '        %s = %s;\n', name, value);
    end

    % Write the class definition footer
    fprintf(fout, '    end\n');
    fprintf(fout, 'end\n');

    fclose(fout);
end