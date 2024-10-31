function peaks = find_peaks_xflow(signal,prominence,min_distance)
peaks = [];
N = length(signal);

% Loop through the signal to find potential peaks
i = 2;
while i <= N - 1
    % Check if current point is a peak
    if signal(i) > signal(i-1) && signal(i) > signal(i+1)
        % Calculate prominence
        left_min = min(signal(max(1, i-min_distance):i-1));
        right_min = min(signal(i+1:min(N, i+min_distance)));
        peak_prominence = signal(i) - max(left_min, right_min);

        % Only consider it as a peak if prominence requirement is met
        if peak_prominence >= prominence
            % Check for higher peaks in the min_distance range
            start_index = max(1, i - min_distance);
            end_index = min(N, i + min_distance);
            [~, local_max_index] = max(signal(start_index:end_index));
            peak_index = start_index + local_max_index - 1;

            % Add peak only if it's not already added
            if isempty(peaks) || peak_index > peaks(end) + min_distance
                peaks = [peaks, peak_index];
            end

            % Mov_RPMe index to av_RPMoid detecting peaks within min_distance
            i = peak_index + min_distance - 1;
        end
    end
    i = i + 1;
end
end
