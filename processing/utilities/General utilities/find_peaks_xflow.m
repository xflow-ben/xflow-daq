function peaks = find_peaks_xflow(signal, prominence, min_distance)
fprintf('Starting Find peaks\n')
tic;
    peaks = [];
    N = length(signal);
    i = 2;

    while i <= N - 1
        if signal(i) > signal(i-1) && signal(i) > signal(i+1)
            % Calculate prominence
            left_min = min(signal(max(1, i-min_distance):i-1));
            right_min = min(signal(i+1:min(N, i+min_distance)));
            peak_prominence = signal(i) - max(left_min, right_min);

            if peak_prominence >= prominence
                % Check for higher peaks in the min_distance range
                start_index = max(1, i - min_distance);
                end_index = min(N, i + min_distance);
                [~, local_max_index] = max(signal(start_index:end_index));
                peak_index = start_index + local_max_index - 1;

                if isempty(peaks) || peak_index > peaks(end) + min_distance
                    peaks = [peaks, peak_index];
                end

                % Move `i` beyond this peak's range
                i = peak_index + min_distance;
            else
                i = i + 1;  % No peak, move forward by 1
            end
        else
            i = i + 1;  % No peak, move forward by 1
        end
    end
    fprintf('Find Peaks finished\n')
toc;
end
