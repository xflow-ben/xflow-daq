
% Parameters
fs_orig = 100;          % Original sampling rate (Hz)
fs_target = 40;         % Target sampling rate (Hz)

% Generate the input signal with Gaussian noise over a longer duration
t_orig = (0:1/fs_orig:10)';               % Original time vector for 10 seconds
A = 5 + 5.*t_orig + randn(size(t_orig));  % 5 Hz sine wave with Gaussian noise

% Define the target time vector (new, denser time points for testing)
t_target = linspace(0, 10, 5000)';  % New target time vector with higher density

% Upsample using resample() with internal polyphase filtering
upsample_factor = 20;  % Set manually based on desired intermediate resolution
A_upsampled = resample(A, round(upsample_factor * fs_orig), fs_orig);
t_upsampled = linspace(t_orig(1), t_orig(end), length(A_upsampled))';

% Design a low-pass FIR anti-alias filter for downsampling
cutoff = (fs_target / 2) * 0.9;          % 90% of the target Nyquist frequency
filterOrder = 50;                        % Moderate filter order for anti-aliasing
b = fir1(filterOrder - 1, cutoff / (fs_orig * upsample_factor / 2));  % FIR filter design

% Apply the FIR anti-alias filter using filtfilt
A_filtered = filtfilt(b, 1, A_upsampled);  % Zero-phase filtering

% Downsample to the target time vector using interpolation
A_final_resampled = interp1(t_upsampled, A_filtered, t_target, 'pchip');  % Interpolation to target time

% Plot and compare results
figure;
hold on;
plot(t_orig, A, 'DisplayName', 'Original Signal');
plot(t_target, A_final_resampled, '--', 'DisplayName', 'Resampled Signal');
legend;
xlabel('Time (s)');
ylabel('Amplitude');
title('Comparison of Original and Resampled Signals');
