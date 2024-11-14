function xfedaqSetUpMATLABPaths
% Run this before using the xfedaq functions
% NOTE - DO NOT MOVE THIS FUNCTION

filepath = fileparts(mfilename('fullpath'));
excludeFiles = {'.','..','.git','.gitignore'};
files = dir(filepath);
for i = 1:length(files)
    if ~ismember(files(i).name,excludeFiles) && isfolder(fullfile(filepath,files(i).name))
        addpath(genpath(fullfile(filepath,files(i).name)));
    end
end
end