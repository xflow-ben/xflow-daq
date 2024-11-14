function resetTimes = findResetRPM(v_RPM,t_RPM)

threshold = 0.25; % Set threshold v_RPMoltage lev_RPMel
prominence = 3; % peak prominance
min_distance = 89;

crossing_indices = find((v_RPM(1:end-1) < threshold) & (v_RPM(2:end) >= threshold)); % Rising edge crossings

% Calculate pulse widths in terms of data counts
pulse_width_counts = diff(crossing_indices); % Difference in counts between rising edges

pulse_width_counts_smooth = smooth(pulse_width_counts,100);

signal = pulse_width_counts - pulse_width_counts_smooth;

peaks = find_peaks_xflow(signal,prominence,min_distance);

resetTimes = t_RPM(crossing_indices(peaks));

end