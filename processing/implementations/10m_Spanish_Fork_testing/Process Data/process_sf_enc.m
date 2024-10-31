function [yout,dy,ddy] = process_sf_enc(c)
% c is the encoder counts data
% NOTE, YOU NEED TO ACCOUNT FOR THE RATE IN TEH DERIVATIVES

max_neg_drop = 5;
delete_dist = 50; % how much data on either side of a detected bad spot to remove
derivative_fix_win = 100;
multi_poly_wind = 800; % multiPolyDiff window size, points
n = 2; % polynomial order

dc = diff(c);
inds = find(dc<-max_neg_drop);
inds = inds + 1;

c_new = c;
for i = 1:length(inds)
    c_new(inds(i):end) = c_new(inds(i):end) + c(inds(i)-1);
end
[dy,~] = multipolydiff(c_new,20,2);

c_pks = dy - smooth(dy,100);


peaks = find(-c_pks>0.1);%find_peaks_xflow(-c_pks,0.15,500);
lcpks = length(c_pks);
for i = 1:length(peaks)
    c_new(max([1,peaks(i)-delete_dist]):min([peaks(i)+delete_dist,lcpks])) = NaN;

end


win = derivative_fix_win;
y = c_new;
% Initialize the output vector
y_shifted = y;

% Find the indices of NaNs (gaps) in the vector
nan_idx = isnan(y);
gap_starts = find(diff(nan_idx) == 1); % Last point before each gap
gap_ends = find(diff(nan_idx) == -1) + 1; % First point after each gap

% If the first or last element is NaN, adjust gap start/end handling
if isnan(y(1))
    gap_ends = gap_ends(2:end);
end
if isnan(y(end))
    gap_starts = gap_starts(1:end-1);
end

% Iterate through each gap
for k = 1:length(gap_starts)
    % Indices for the end of data before and start of data after the gap
    start_idx = gap_starts(k);
    end_idx = gap_ends(k);

    % Define the window ranges
    range_before = max(1, start_idx - win + 1):start_idx;
    range_after = end_idx:min(length(y), end_idx + win - 1);


    % Calculate the median slope (difference) before and after the gap
    slope_before = mean(diff(y(range_before)), 'omitmissing');
    slope_after = mean(diff(y(range_after)), 'omitmissing');

    % Compute the average slope
    m_av = mean([slope_before, slope_after]);

    % Calculate the shift amount based on the average slope
    gap_length = end_idx - start_idx;  % Number of points in the gap
    shift_amount = (y(start_idx) + m_av * gap_length) - y(end_idx);


    % Apply the shift to data after the gap
    y_shifted(end_idx:end) = y_shifted(end_idx:end) + shift_amount;
end

[yout,dy,ddy] = multipolydiffNaN(y_shifted,multi_poly_wind,n);

end