function data = readQBladeTxt(filename, variableName)
    % Reads the specified variable's data from a tab-delimited text file.
    %
    % Inputs:
    % - filename: Path to the file (e.g., 'Utah_turb_dyn_stall.txt')
    % - variableName: Name of the variable to retrieve data (e.g., 'X_l_Mean_Tension_MOO_UpperBottomN_[N]')
    %
    % Output:
    % - data: Data associated with the specified variable as a column vector

    % Check if the file exists
    if ~isfile(filename)
        error('File "%s" not found.', filename);
    end

    % Open the file and read the third line as the header
    fileID = fopen(filename, 'r');
    fgetl(fileID); % Skip the first line
    fgetl(fileID); % Skip the second line
    headerLine = strtrim(fgetl(fileID)); % Read the third line and trim whitespace
    fclose(fileID);
    headers = strsplit(headerLine, '\t');

    % Remove extra spaces from headers to ensure clean matching
    headers = strtrim(headers);

    % Find the index of the specified variable in the headers
    varIndex = find(strcmp(headers, variableName));
    if isempty(varIndex)
        error('Variable "%s" not found in file.', variableName);
    end

    % Read the data starting from the fourth line
    dataArray = readtable(filename, 'FileType', 'text', 'Delimiter', '\t', 'HeaderLines', 3);

    % Extract the data for the specified variable
    data = dataArray{:, varIndex};
end
