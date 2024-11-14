function plot_normal_operation_capture_matrix(U, TI, U_bin_edges, TI_bin_edges)
    % Create a 2D histogram matrix
    capture_matrix = zeros(length(TI_bin_edges)-1, length(U_bin_edges)-1);

    % Populate the capture matrix with counts
    for i = 1:length(U_bin_edges)-1
        for j = 1:length(TI_bin_edges)-1
            % Find the number of occurrences within the current wind speed and TI bin
            if j == length(TI_bin_edges)-1
                % Special case for the top bin (29%-100%)
                indices = U >= U_bin_edges(i) & U < U_bin_edges(i+1) & ...
                    TI >= TI_bin_edges(j);
            else
                indices = U >= U_bin_edges(i) & U < U_bin_edges(i+1) & ...
                    TI >= TI_bin_edges(j) & TI < TI_bin_edges(j+1);
            end
            capture_matrix(j, i) = sum(indices);
        end
    end

    % Calculate the max number of entries per TI bin for a given wind speed bin
    max_entire_per_ti_bin = max(capture_matrix);

    % Calculate the total number of entries for each wind speed bin
    total_entries_per_ws_bin = sum(capture_matrix, 1);

    % Adjust the dimensions of the matrices for pcolor
    [W, T] = meshgrid(U_bin_edges, TI_bin_edges);

    % Create a figure with the specified layout

    %% 2D capture matrix
    figure;

    % Define a blue colormap for the 2D heatmap
% Define a custom colormap that transitions from white to a dull blue
n_colors = 256; % Number of colors in the colormap
custom_colormap = [linspace(1, 0.2, n_colors)', ... % Red channel (from white to duller)
                   linspace(1, 0.5, n_colors)', ... % Green channel (from white to a dull blue)
                   linspace(1, 0.8, n_colors)'];   % Blue channel (from white to a deeper blue)

    subplot(6, 1, 1:4);
    h = pcolor(W, T, [capture_matrix zeros(size(capture_matrix, 1), 1); zeros(1, size(capture_matrix, 2) + 1)]);
    colormap(gca, custom_colormap);
    caxis([0 max(capture_matrix(:))]); % Scale colorbar to match data range
    xlabel('Wind Speed (m/s)');
    ylabel('Turbulence Intensity (%)');
    set(gca, 'YDir', 'normal'); % To have TI increasing upward
    axis tight;
    shading flat; % Ensures that the color fills each bin without gridlines between cells

    % Adjust tick marks to be centered within the bins
    wind_speed_ticks = U_bin_edges(1:end-1) + 0.5; % Center tick marks within bins
    ti_ticks = TI_bin_edges(1:end-1) + diff(TI_bin_edges) / 2; % Center tick marks within bins

    % Set custom tick labels to show the ranges, including the top bin for 29%-100%
    wind_speed_labels = arrayfun(@(x, y) sprintf('%d-%d', x, y), U_bin_edges(1:end-1), U_bin_edges(2:end), 'UniformOutput', false);
    ti_labels = [arrayfun(@(x, y) sprintf('%d-%d', x, y), TI_bin_edges(1:end-2), TI_bin_edges(2:end-1), 'UniformOutput', false), {'29-100%'}];

    set(gca, 'XTick', wind_speed_ticks, 'XTickLabel', wind_speed_labels, ...
        'YTick', ti_ticks, 'YTickLabel', ti_labels);

    % Add grid lines to delineate the boundaries of the bins
    hold on;
    for i = 1:length(U_bin_edges)
        xline(U_bin_edges(i), 'Color', 'k', 'LineWidth', 0.5);
    end
    for j = 1:length(TI_bin_edges)
        yline(TI_bin_edges(j), 'Color', 'k', 'LineWidth', 0.5);
    end

    % Add text labels centered within each bin
    for i = 1:length(U_bin_edges)-1
        for j = 1:length(TI_bin_edges)-1
            count = capture_matrix(j, i);
            if count > 0
                text(U_bin_edges(i) + 0.5, TI_bin_edges(j) + diff(TI_bin_edges(j:j+1)) / 2, num2str(count), ...
                    'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontSize', 8, 'Color', 'k');
            end
        end
    end

    %% Passing bins
    subplot(6, 1, 6);
    passing_criteria = max_entire_per_ti_bin > 60 | total_entries_per_ws_bin > 200;
    imagesc(U_bin_edges(1:end-1) + 0.5, 1, passing_criteria); % Binary map: 1 if entries > 0, 0 otherwise
    colormap(gca, [0.8 0.4 0.4; 0.6 1.0 0.6]); % Light red for 0, soft green for >0
    set(gca, 'YDir', 'normal');
    xlabel('Wind Speed (m/s)');
    title({
        '\fontsize{14}Passing Bins', ...
        '\fontsize{10}At Least one TI Bin with > 60 Entries OR At Least 200 Entries Across all TI Bins'
        }, 'Interpreter', 'tex');
    set(gca, 'XTick', U_bin_edges(1:end-1) + 0.5, 'XTickLabel', arrayfun(@(x, y) sprintf('%d-%d', x, y), U_bin_edges(1:end-1), U_bin_edges(2:end), 'UniformOutput', false));
    set(gca, 'YTick', []);
    axis tight;
    hold on;

    % Add grid lines and text labels for the heatmap
    for i = 1:length(U_bin_edges)
        xline(U_bin_edges(i), 'Color', 'k', 'LineWidth', 0.5);
    end

    % Add text labels 'Y' for passing bins and 'N' for non-passing bins
    for i = 1:length(U_bin_edges)-1
        label = 'Fail';
        if passing_criteria(i)
            label = 'Pass';
        end
        text(U_bin_edges(i) + 0.5, 1, label, ...
            'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontSize', 8, 'Color', 'k');
    end

    set(gcf, 'Position', [892 531 668 707])
end
