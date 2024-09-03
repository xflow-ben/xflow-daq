function alias = setUpTDMSLibrary
if ~libisloaded('tdmlib')
    mFilePath = fileparts(mfilename('fullpath'));
    binFolder = fullfile(mFilePath,'..\..\..\','lib');
    dllPath = fullfile(binFolder,'nilibddc.dll');
    headerPath = fullfile(binFolder,'nilibddc_m.h');

    % check if thes paths make sense
    if isempty(dir(dllPath))
        error('dll file not found at %s',dllPath);
    end
    if isempty(dir(dllPath))
        error('header file not found at %s',headerPath);
    end

    % check if the bin folder is on the system path
    % Define the folder you want to check
    s = what(binFolder);
    binFullPath = s.path;
     addpath(binFullPath)

    % Get the system PATH environment variable
    systemPath = getenv('PATH');

    % Check if the folder is in the PATH, add it if not
    if ~contains(systemPath, binFullPath)
        systemPath = [systemPath, ';',binFullPath];
        setenv('PATH',systemPath);
        systemPath = getenv('PATH');
        if ~contains(systemPath, binFullPath)
            error('Unable to add %s to the system PATH',binFullPath)
        end
    end

    % warning off MATLAB:loadlibrary:TypeNotFound
    % warning off MATLAB:loadlibrary:TypeNotFoundForStructure
    loadlibrary(dllPath, headerPath, 'alias', 'tdmlib');

end
alias = 'tdmlib';
end