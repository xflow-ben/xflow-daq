function data = resampleXFlow(data,time,targetTime)
% resamples column vectors in data origionally sampled at points "time" to
% targetTime points. Can upsample or downsample.
% time and targetTime are to be datetime format

freqOrig = 1/(seconds(time(2)-time(1)));
freqTarget = 1/(seconds(targetTime(2)-targetTime(1)));

freqMult = 5;% how many x above freqTarget our upsampling will be (minimum)

if freqOrig < freqMult*freqTarget % then upsample first
    interpolationFactor = ceil(freqTarget*freqMult/freqOrig);
    if interpolationFactor < 5
        M = 50;
    else
        M = round(10*interpolationFactor);
    end
    if M > 200
        M = 200;
    end
    data = interpolate_polyphase_matrix(data, interpolationFactor,M);
else
    interpolationFactor = 1;
end


tUpsampled = linspace(time(1), time(end), size(data,1))';

% Step 2: Anti-aliasing filter (FIR)
cutoff = (freqTarget / 2) * 0.9;         % 90% of Nyquist frequency
filterOrder = 61;                       % Filter order
b = fir1(filterOrder - 1, cutoff / (freqOrig * interpolationFactor / 2));
data = filtfilt(b, 1, data);  % Zero-phase FIR filtering

      % Target time vector (example)
data = interp1(tUpsampled, data, targetTime);


    function X = interpolate_polyphase_matrix(Y, M, N)
        % interpolate_polyphase_matrix: Performs polyphase FIR-based interpolation
        %                               on a matrix where each column is a time series.
        %
        % Input:
        %   Y = Matrix of input signals, with each column representing a time series
        %   M = Interpolation factor
        %   N = FIR filter order (scalar) or coefficient vector of length 2*M*N + 1
        % Output:
        %   X = Matrix of interpolated signals (columns processed independently)
        %   G = Polyphase FIR filter coefficient matrix
        %
        % Example:
        %   data = randn(100, 5);  % 100 time points, 5 signals
        %   [upsampled_data, G] = interpolate_polyphase_matrix(data, 5, 50);

        [nRows, nCols] = size(Y);  % Get the size of the input matrix

        % Step 1: Generate the FIR filter coefficients
            g = M * fir1(2 * M * N, 1 / M);  % FIR filter design


        % Ensure the input data is zero-padded to handle edge cases
        Ny = nRows; % Number of rows in Y
        Y = [Y; zeros(ceil(Ny / M) * M - Ny, nCols)];

        % Step 2: Prepare the polyphase filter
        Ng = length(g);
        g = [g, zeros(1, ceil(Ng / M) * M - Ng)];  % Zero-pad filter coefficients
        G = reshape(g, M, length(g) / M);         % Polyphase decomposition of the filter

        % Step 3: Initialize the output matrix
        X = zeros(M * size(Y, 1), nCols);         % Allocate upsampled matrix

        % Step 4: Process each column independently
        for col = 1:nCols
            y = Y(:, col)'; % Extract the current column as a row vector
            Nzeros = zeros(1, N);  % Padding for FIR filtering

            % Apply polyphase interpolation to the column
            for lambda = 1:M
                % Filter for the current polyphase
                tmp = filter(G(lambda, :), 1, [y, Nzeros]);
                X(lambda:M:end, col) = tmp(N + 1:end);  % Assign filtered values
            end
        end

        % Trim any excess zeros at the end of the output
        X = X(1:M * nRows, :);
    end

end
