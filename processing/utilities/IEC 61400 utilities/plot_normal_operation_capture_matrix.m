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

    % Calculate the number of TI bins with > 6 entries for each wind speed bin
    num_ti_bins_over_6 = sum(capture_matrix > 6, 1);

    % Calculate the total number of entries for each wind speed bin
    total_entries_per_ws_bin = sum(capture_matrix, 1);

    % Adjust the dimensions of the matrices for pcolor
    [W, T] = meshgrid(U_bin_edges, TI_bin_edges);

    % Create a figure with the specified layout
    figure;

    % Define a custom colormap from white to red
    n_colors = 256; % Number of colors in the colormap
    custom_colormap = [linspace(1, 1, n_colors)', linspace(1, 0, n_colors)', linspace(1, 0, n_colors)'];

    %% Number of TI bins with > 6 entries
    subplot(6, 1, 5);
    imagesc(U_bin_edges(1:end-1) + 0.5, 1, num_ti_bins_over_6); % Using imagesc for a heatmap
    colormap(custom_colormap);
    caxis([0 max(capture_matrix(:))]); % Consistent colormap scale
    set(gca, 'YDir', 'normal');
    xlabel('Wind Speed (m/s)');
    ylabel('with 6 TS','Rotation',0);
    title('Number of TI Bins with > 6 Entries');
    set(gca, 'XTick', U_bin_edges(1:end-1) + 0.5, 'XTickLabel', arrayfun(@(x, y) sprintf('%d-%d', x, y), U_bin_edges(1:end-1), U_bin_edges(2:end), 'UniformOutput', false));
    set(gca, 'YTick', []);
    axis tight;
    hold on;

    % Add grid lines and text labels for the heatmap
    for i = 1:length(U_bin_edges)
        xline(U_bin_edges(i), 'Color', 'k', 'LineWidth', 0.5);
    end
    for i = 1:length(U_bin_edges)-1
        text(U_bin_edges(i) + 0.5, 1, num2str(num_ti_bins_over_6(i)), ...
            'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontSize', 8, 'Color', 'k');
    end
    hold off;

    %% Total number of entries per wind speed bin
    subplot(6, 1, 6);
    imagesc(U_bin_edges(1:end-1) + 0.5, 1, total_entries_per_ws_bin); % Using imagesc for a heatmap
    colormap(custom_colormap);
    caxis([0 max(capture_matrix(:))]); % Consistent colormap scale
    set(gca, 'YDir', 'normal');
    xlabel('Wind Speed (m/s)');
    ylabel('in WS bin','Rotation',0);
    title('Total Entries in Wind Speed Bin');
    set(gca, 'XTick', U_bin_edges(1:end-1) + 0.5, 'XTickLabel', arrayfun(@(x, y) sprintf('%d-%d', x, y), U_bin_edges(1:end-1), U_bin_edges(2:end), 'UniformOutput', false));
    set(gca, 'YTick', []);
    axis tight;
    hold on;

    % Add grid lines and text labels for the heatmap
    for i = 1:length(U_bin_edges)
        xline(U_bin_edges(i), 'Color', 'k', 'LineWidth', 0.5);
    end
    for i = 1:length(U_bin_edges)-1
        text(U_bin_edges(i) + 0.5, 1, num2str(total_entries_per_ws_bin(i)), ...
            'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontSize', 8, 'Color', 'k');
    end
    hold off;

    %% 2D capture matrix
    subplot(6, 1, 1:4);
    h = pcolor(W, T, [capture_matrix zeros(size(capture_matrix, 1), 1); zeros(1, size(capture_matrix, 2) + 1)]);
    colormap(custom_colormap);
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
    hold off;

    %% Adjust the positions of the subplots to ensure spacing
    subplot(6, 1, 1:4);
    pos = get(gca, 'Position');
    set(gca, 'Position', [pos(1), pos(2) + 0.1, pos(3), pos(4) - 0.1]);

    subplot(6, 1, 5);
    pos = get(gca, 'Position');
    set(gca, 'Position', [pos(1), pos(2) + 0.05, pos(3), pos(4) - 0.05]);

    subplot(6, 1, 6);
    pos = get(gca, 'Position');
    set(gca, 'Position', [pos(1), pos(2), pos(3), pos(4) - 0.05]);

    set(gcf,'Position',[892 531 668 707])
end
