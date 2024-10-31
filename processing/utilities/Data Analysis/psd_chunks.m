function [pxx_combined, f_combined] = psd_chunks(t, x, Fs)
    % PSD_CHUNKS Calculate the PSD for data with gaps in the time vector.
    %
    % Inputs:
    %   t - Time vector (non-uniform sampling with possible gaps)
    %   x - Data vector
    %   Fs - Sampling frequency in Hz
    %
    % Outputs:
    %   pxx_combined - Combined PSD of all consistent chunks
    %   f_combined   - Frequency vector associated with the PSD
    
    % Find the indices where gaps occur
    dt = diff(t);
    gap_indices = find(dt > 1/Fs);
    
    % Add the start and end of the time vector as chunk boundaries
    chunk_indices = [1; gap_indices + 1; length(t) + 1];
    
    % Initialize arrays to accumulate PSD data
    pxx_list = [];
    f_list = [];
    
    % Process each chunk
    for i = 1:length(chunk_indices) - 1
        % Get the current chunk
        start_idx = chunk_indices(i);
        end_idx = chunk_indices(i + 1) - 1;
        
        t_chunk = t(start_idx:end_idx);
        x_chunk = x(start_idx:end_idx);
        
        % Calculate the sample frequency for this chunk
        Fs_chunk = 1 / mean(diff(t_chunk));  % Actual sampling frequency for this chunk
        
        % Skip chunks that have fewer than 3 samples (cannot calculate PSD meaningfully)
        if length(t_chunk) < 3
            continue;
        end
        
        % Calculate the PSD using pwelch for the current chunk
        [pxx_chunk, f_chunk] = pwelch(x_chunk, [], [], [], Fs_chunk);
        
        % Accumulate the results
        if isempty(pxx_list)
            pxx_list = pxx_chunk;
            f_list = f_chunk;
        else
            % Ensure that frequency vectors are compatible before averaging
            if isequal(f_list, f_chunk)
                pxx_list = pxx_list + pxx_chunk;  % Sum PSD values (since PSD is additive)
            else
                error('Frequency vectors do not match between chunks. Resampling may be needed.');
            end
        end
    end
    
    % Average the PSD across all chunks
    num_chunks = length(chunk_indices) - 1;
    pxx_combined = pxx_list / num_chunks;
    f_combined = f_list;
    
    % Plot the combined PSD
    figure;
    semilogx(f_combined, pxx_combined);
    xlabel('Frequency (Hz)');
    ylabel('Power/Frequency (x^2/Hz)');
    title('Combined Power Spectral Density (PSD)');


     figure;
    loglog(f_chunk, pxx_chunk);
    xlabel('Frequency (Hz)');
    ylabel('Power/Frequency (x^2/Hz)');
    title('Combined Power Spectral Density (PSD)');
end
