function cal = build_crosstalk_matrix(crosstalk,calib,parent_dir,plot_opt,savePath)
%% Process calibration data
% create the applied loads matricies
for i = 1:length(calib)
    [loads{i},volts{i},channel_names{i}] = process_calibration_folder(calib(i),crosstalk,parent_dir);
    if size(calib(i).applied_load_scaling,2)~=1 && size(calib(i).applied_load_scaling,2)~= length(loads{i})
        error('applied_load_scaling must be a column vector')
    elseif size(calib(i).applied_load_scaling,1) ~= length(crosstalk.loads_names)
        error('applied_load_scaling must have number of rows equal to number of load_names')
    end
    if size(calib(i).applied_load_scaling,2) == 1
        load_mats{i} = repmat(calib(i).applied_load_scaling,[1,length(loads{i})]);
        load_mats{i} = load_mats{i}.*loads{i};
    else
        load_mats{i} = calib(i).applied_load_scaling.*loads{i};
    end
end


%% Combine loads and response (volts) matricies
cal.data.load_mat = [load_mats{:}]; % X matrix
cal.data.response_mat = [volts{:}]; % O matrix

% remove any columns with NaN
[~,nanind] = find(isnan(cal.data.response_mat));
cal.data.load_mat(:,nanind) = [];
cal.data.response_mat(:,nanind) = [];
[~,nanind] = find(isnan(cal.data.load_mat));
cal.data.load_mat(:,nanind) = [];
cal.data.response_mat(:,nanind) = [];
%% Compute crosstalk
% K^(-1) O = X, K^(-1) = X / O
% x*A = B, x = B / A in matlab lingo
cal.data.k = cal.data.load_mat/cal.data.response_mat;

%% Finish building output cal struct
cal.type = 'linear_k';
cal.output_units = calib.output_units;
cal.input_channels = crosstalk.channel_names; % name of data columns to input
cal.output_names = crosstalk.loads_names; % names for output (calibrated) channels

%% Plotting
% Plot applied load versus calculated load
if nargin > 3 && plot_opt% plot_opt activates plotting
    r_squared = 1-sum((cal.data.k*cal.data.response_mat-cal.data.load_mat).^2,2)./sum((cal.data.load_mat-mean(cal.data.load_mat,2)).^2,2); % r^2 comparing measured versus applied load
    if  size(cal.data.k,1) == 1 && size(cal.data.k,2) == 1 % single channel calibration version
        for i = 1:size(load_mats{1},1)
            figure; hold on;
            title([strrep(crosstalk.loads_names{i},'_',' '),', R^2 = ',sprintf('%0.5f',r_squared(i))]);
            leg_string = [];
            k = 0;
            calculated_loads_min =0;
            calculated_loads_max = 0;
            for j = 1:length(load_mats)
                if any(load_mats{j}(i,:))
                    k = k + 1;
                    plot(load_mats{j}(i,:),cal.data.k*volts{j}(i,:),'o')
                    leg_string{k} = strrep(calib(j).folder,'_',' ');
                    calculated_loads_max = max(calculated_loads_max(i),max(cal.data.k*volts{j}(i,:)));
                    calculated_loads_min = min(calculated_loads_min(i),min(cal.data.k*volts{j}(i,:)));
                end
            end
        end
        xlabel(sprintf('Load Applied [%s]',cal.output_units))
        ylabel(sprintf('Load Computed from Guages\nUsing Single Channel Calibration [%s]',cal.output_units))
        box on
        grid on
        set(gca,'fontsize',12)
        plot([calculated_loads_min, calculated_loads_max],[calculated_loads_min, calculated_loads_max],'--k')
        legend(leg_string,'Location','Best')
        saveas(gcf,fullfile(savePath,'Figures',[strrep(crosstalk.loads_names{i},'_',' '),' Using Single Channel Calibration.png']))

    else % multiple channel calibration version
        fh{1} = figure;
        fh{2} = figure;
        fh{3} = figure;
        calculated_loads_min =zeros(length(load_mats),1);
        calculated_loads_max =zeros(length(load_mats),1);
        k = 0;
        for j = 1:length(load_mats) % index for each calibration folder
            k = k + 1;
            leg_string{k} = strrep(calib(j).folder,'_',' ');
            for m = 1:size(load_mats{j},2) % index for each load applied in a folder
                calculated_loads(m,:) = cal.data.k*volts{j}(:,m);
                applied_load(m,:) = load_mats{j}(:,m);
            end
            for i = 1:size(load_mats{1},1) % index for each load channel
                figure(fh{i})
                hold on
                plot(applied_load(:,i),calculated_loads(:,i),'o')
                calculated_loads_max(i) = max(calculated_loads_max(i),max(calculated_loads(:,i)));
                calculated_loads_min(i) = min(calculated_loads_min(i),min(calculated_loads(:,i)));
            end
        end
        for i = 1:size(load_mats{1},1) % index for each load channel
            figure(fh{i}); hold on;
            title([strrep(crosstalk.loads_names{i},'_',' '),', R^2 = ',sprintf('%0.5f',r_squared(i))]);
            xlabel(sprintf('Load Applied [%s]',cal.output_units))
            ylabel(sprintf('Load Computed from Guages\nUsing Crosstalk Matrix [%s]',cal.output_units))
            box on
            grid on
            set(gca,'fontsize',12)
            plot([calculated_loads_min(i), calculated_loads_max(i)],[calculated_loads_min(i), calculated_loads_max(i)],'--k')
            legend(leg_string,'Location','Best')
            saveas(gcf,fullfile(savePath,'Figures',[strrep(crosstalk.loads_names{i},'_',' '),' Using Crosstalk Matrix.png']))
        end
    end
end

  