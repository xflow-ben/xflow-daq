function sd = calculate_sd(td,consts)

%% Create sd (statistical data)
N = consts.data.N; % Get sd averaging time [s]

if sum(strcmp(consts.data.save_types, 'sd'))
    % Create sd (statistical data): do N-second averaging here (e.g. 10 second).
    % Split data up into chunks, do the averaging
    sd = struct();

    count = 0;
    fields = fieldnames(td);

    % Determine the number of chunks
    start_time = min(td.Time);
    end_time = max(td.Time);


    if isnan(consts.data.N)% no time span specified, so average the entire file
        N = seconds(end_time-start_time);
        num_chunks = 1;
    else
        num_chunks = ceil(seconds(end_time - start_time) / N);
    end


    % Loop through each chunk
    for KK = 1:num_chunks
        % Find the start and end times for this chunk
        chunk_start = start_time + seconds((KK-1) * N);
        chunk_end = start_time + seconds(KK * N);

        % Find indices of data points within this chunk
        indices = find(td.Time >= chunk_start & td.Time < chunk_end);

        if ~isempty(indices)
            % if sum(isnan(td.(fields{1})(indices))) == 0 % Don't except chunks with nans
                count = count + 1;

                % Compute the average for each field in the struct
                for LL = 1:numel(fields)
                    if ~strcmp(fields{LL}, 'Time')
                    % Extract the chunk data statistics
                    chunk_data = td.(fields{LL})(indices);

                    sd.(fields{LL}).mean(count) = mean(chunk_data,1,'omitnan');

                    sd.(fields{LL}).std(count) = std(chunk_data,'omitnan');
                    sd.(fields{LL}).min(count) = min(chunk_data,[],'omitnan');
                    sd.(fields{LL}).max(count) = max(chunk_data,[],'omitnan');
                    end
                end
                sd.td_index.start(count) = indices(1);
                sd.td_index.end(count) = indices(end);
            % end
        end
    end
end
