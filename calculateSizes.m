function [bufferSize, fileWriteSize, samplesPerFile] = calculateSizes(rate, fileLengthSeconds)
    % Constants
    SECTOR_SIZE = 512;          % bytes
    SAMPLE_SIZE = 8;            % bytes per sample (float64)
    SAMPLES_PER_SECTOR = SECTOR_SIZE / SAMPLE_SIZE; % 64 samples
    BUFFER_MULTIPLIER = 8;      % Buffer size should be a multiple of 8 times the sector size
    
    % Calculate samplesPerFile
    samplesPerFile = rate * fileLengthSeconds;
    
    % Ensure rate is a power of 2 if it is above 512
    if rate > 512 && mod(log2(rate), 1) ~= 0
        error('Rate must be a power of 2 for rates above 512.');
    end
    
    % Calculate fileWriteSize that is a multiple of 64 samples and meets other constraints
    % If samplesPerFile is small, choose the smallest aligned fileWriteSize
    if samplesPerFile < SAMPLES_PER_SECTOR
        fileWriteSize = SAMPLES_PER_SECTOR;
    else
        potentialFileWriteSizes = SAMPLES_PER_SECTOR:SAMPLES_PER_SECTOR:samplesPerFile;
        validFileWriteSizes = potentialFileWriteSizes(mod(potentialFileWriteSizes, rate) == 0);
        fileWriteSize = min(validFileWriteSizes);
    end
    
    % Determine the buffer size based on the rate
    if rate <= 512
        % For low rates, use a smaller buffer size
        bufferSize = 2 * fileWriteSize;
    else
        % For higher rates, use a larger buffer size
        bufferSize = 10 * fileWriteSize;
    end

    % Ensure buffer size is aligned with 8 times the sector size
    bufferSize = max(bufferSize, BUFFER_MULTIPLIER * SAMPLES_PER_SECTOR);
    bufferSize = ceil(bufferSize / (BUFFER_MULTIPLIER * SAMPLES_PER_SECTOR)) * (BUFFER_MULTIPLIER * SAMPLES_PER_SECTOR);

    % Final validation
    if mod(fileWriteSize, SAMPLES_PER_SECTOR) ~= 0 || mod(bufferSize, BUFFER_MULTIPLIER * SAMPLES_PER_SECTOR) ~= 0
        error('The resulting buffer size or file write size does not meet the alignment requirements.');
    end
end