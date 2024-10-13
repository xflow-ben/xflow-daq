function filesToMove = compareDirectories(sourceDir, destDir)
    % Initialize cell array to store files that need to be moved
    filesToMove = {};
    
    % Get the list of all files in both folders (with relative paths)
    filesInA = getAllFiles(sourceDir);
    filesInB = getAllFiles(destDir);
    
    % Create a map (structure) to store the sizes of files in B for comparison
    filesInBMap = containers.Map();
    
    % Populate the map with files from B and their sizes
    for i = 1:length(filesInB)
        % Get the relative path of the file in B
        relativePathB = strrep(filesInB{i}, strcat(destDir, filesep), '');
        
        % Skip files that start with a period (hidden files)
        if startsWith(relativePathB, '.')
            continue; % Skip hidden files
        end
        
        % Get file info and store the size
        fileInfoB = dir(fullfile(destDir, relativePathB));
        filesInBMap(char(relativePathB)) = fileInfoB.bytes; % Store size of file in B as char vector
    end
    
    % Iterate through all files in A to find discrepancies
    for i = 1:length(filesInA)
        % Get the relative path of the file in A
        relativePathA = strrep(filesInA{i}, strcat(sourceDir, filesep), '');
        
        % Skip files that start with a period (hidden files)
        if startsWith(relativePathA, '.')
            continue; % Skip hidden files
        end
        
        % Get file info for A
        fileInfoA = dir(fullfile(sourceDir, relativePathA));
        
        if isKey(filesInBMap, char(relativePathA))
            % If the file exists in both, compare their sizes
            sizeB = filesInBMap(char(relativePathA));
            if fileInfoA.bytes ~= sizeB
                % If file sizes differ, add to the list
                filesToMove{end+1} = char(relativePathA); % Convert to char vector
            end
        else
            % If the file is not found in B, add to the list
            filesToMove{end+1} = char(relativePathA); % Convert to char vector
        end
    end
end

function fileList = getAllFiles(folder)
    % Recursive function to get all files in a directory (with relative paths)
    dirData = dir(folder);  % Get the data for the current folder
    dirIndex = [dirData.isdir];  % Find the index for directories
    fileList = {dirData(~dirIndex).name};  % Get a list of the files (character arrays)
    
    % Ensure that fileList is a cell array of character vectors and ignore hidden files
    fileList = fileList(~startsWith(fileList, '.'));
    
    for i = 1:length(fileList)
        fileList{i} = char(fullfile(folder, fileList{i}));  % Use fullfile for concatenation and convert to char
    end
    
    subDirs = {dirData(dirIndex).name};  % Get a list of the subdirectories
    validIndex = ~ismember(subDirs, {'.', '..'});  % Find index of valid subdirectories
    
    % Loop over valid subdirectories
    for i = find(validIndex)
        nextDir = fullfile(folder, subDirs{i});
        subFiles = getAllFiles(nextDir);  % Recursively call getAllFiles
        
        % Concatenate results
        fileList = [fileList, subFiles];  % Append subdirectory files to the list
    end
end
