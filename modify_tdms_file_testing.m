tdmsFilePath = fullfile(pwd,'parallel_write_test.tdms');

if ~libisloaded('tdmlib')
    setUpTDMSLibrary;
end

% Handle to the TDMS file
fileHandle = int64(0);

% Open the TDMS file
[err, ~,~,fileHandle] = calllib('tdmlib', 'DDC_OpenFile', tdmsFilePath, '', fileHandle);
assert(err == 0, 'Failed to open TDMS file');

% Get the current time (or define your specific time)
currentTime = datetime('now');
nyear = year(currentTime);
nmonth = month(currentTime);
nday = day(currentTime);
nhour = hour(currentTime);
nminute = minute(currentTime);
nsecond = floor(second(currentTime));
nmillisecond = mod(second(currentTime),1)*1000;


% Set the timestamp property
err = calllib('tdmlib', 'DDC_CreateFilePropertyTimestampComponents', fileHandle, 'startTime1', ...
              uint32(nyear), uint32(nmonth), uint32(nday), uint32(nhour), uint32(nminute), uint32(nsecond),nmillisecond);
assert(err == 0, 'Failed to set the timestamp property');


% Save and close the TDMS file
err = calllib('tdmlib', 'DDC_SaveFile', fileHandle);
assert(err == 0, 'Failed to save TDMS file');

err = calllib('tdmlib', 'DDC_CloseFile', fileHandle);
assert(err == 0, 'Failed to close TDMS file');

% Unload the library when done
unloadlibrary('tdmlib');

disp('Timestamp property added successfully.');
