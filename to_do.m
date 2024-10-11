% data tasks

% Take tare point routine??


% master script that starts and stops things, and deals with data moving
% and compression. make stoppable by command line call. Otherwise run off
% of a repeated timer

% check for / create data folders in the data directories
% set up and launch DAQ
% set up and launch controller data program

% keep track of lists of file prefix types. When new one is created, take
% the second to last and

% In shell script
% - compress it using 7zip. Save compress file to a temporary location
% - move the file to the 2 drives (internal drive and eternal USB drive)
% - delete the origional file
% - upload to server?

% in MATLAB regular timer callback func
% keep a queue of files to compress / move
% detect that compression is finished based on if the 7z files have been
% moved to the drive locations. 