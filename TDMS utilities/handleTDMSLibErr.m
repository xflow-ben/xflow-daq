function handleTDMSLibErr(lib,err)


if err ~= 0
    % Retrieve the error description from the library
    errMsg = calllib(lib, 'DDC_GetLibraryErrorDescription', err);

    % Display the error information
    error('TDMS Library Error (Code: %d): %s', err, errMsg);
end



end