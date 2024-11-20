function cal = build_crosstalk_matrix(crosstalk,calib,data_path,data_folder,tdmsPrefix,plot_opt,savePath)
%% Process calibration data
data_dir = fullfile(data_path,data_folder);
% create the applied loads matricies
for i = 1:length(calib)
    [loads,volts{i},~] = process_calibration_folder(calib(i),crosstalk,data_dir,tdmsPrefix);
    if size(calib(i).applied_load_scaling,2)~=1 && size(calib(i).applied_load_scaling,2)~= length(loads)
        error('applied_load_scaling must be a column vector OR the number of columns must match the number of measured points')
    elseif size(calib(i).applied_load_scaling,1) ~= length(crosstalk.loads_names)
         error('applied_load_scaling must have number of rows equal to number of load_names')
    end
    if size(calib(i).applied_load_scaling,2) == 1
        load_mats{i} = repmat(calib(i).applied_load_scaling,[1,length(loads)]).*loads;
    else
        load_mats{i} = calib(i).applied_load_scaling.*loads;
    end
end


%% Combine loads and response (volts) matricies
cal.data.loadMat = [load_mats{:}]; % X matrix
cal.data.responseMat = [volts{:}]; % O matrix

% remove any columns with NaN
[~,nanind] = find(isnan(cal.data.responseMat));
cal.data.loadMat(:,nanind) = [];
cal.data.responseMat(:,nanind) = [];
[~,nanind] = find(isnan(cal.data.loadMat));
cal.data.loadMat(:,nanind) = [];
cal.data.responseMat(:,nanind) = [];
%% Compute crosstalk
% k = Response \ Load
% Backslash solves equation for k for Response * k = Load
% transpose the inputs as our data (time) direction is along the columns
cal.data.k = (cal.data.responseMat')\(cal.data.loadMat');

%% Finish building output cal struct
cal.type = 'linear_k';
cal.inputChannels = crosstalk.channel_names; % name of data columns to input
cal.outputNames = crosstalk.loads_names; % names for output (calibrated) channels
cal.outputUnits = crosstalk.output_units; % units corresponding to output names

%% Plot applied load versus calculated load
isSingleChannelCal = size(cal.data.k,1) == 1 && size(cal.data.k,2) == 1; % Flag for single or multi channel calibration

if nargin > 5 && plot_opt % plot_opt activates plotting
   
    % Calculate R^2
    r_squared = 1-sum((((cal.data.responseMat')*cal.data.k)'-cal.data.loadMat).^2,2)./sum((cal.data.loadMat-mean(cal.data.loadMat,2)).^2,2); % r^2 comparing measured versus applied load
  
    % Initialize figures for each channel
    for i = 1:size(load_mats{1},1)
        fh{i} = figure;
    end

    % Plot data and store useful quantities for cleaning figure
    calculated_loads_min =zeros(size(load_mats{1},1),1);
    calculated_loads_max =zeros(size(load_mats{1},1),1);
    k = 0;
    for j = 1:length(load_mats) % index for each calibration folder
        k = k + 1;
        leg_string{k} = strrep(calib(j).folder,'_',' ');
        calculated_loads = [];
        applied_load = [];
        for m = 1:size(load_mats{j},2) % index for each load applied in a folder
            calculated_loads(m,:) = ((volts{j}(:,m)')*cal.data.k)';
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

    % Clean up and save figure
    for i = 1:size(load_mats{1},1) % index for each load channel
        figure(fh{i}); hold on;
        title([strrep(crosstalk.loads_names{i},'_',' '),', R^2 = ',sprintf('%0.5f',r_squared(i))]);
        xlabel(sprintf('Load Applied [%s]',cal.outputUnits{i}))
        if isSingleChannelCal
            ylabel(sprintf('Load Computed from Guages\nUsing Single Channel Calibration [%s]',cal.outputUnits{i}))
        else
            ylabel(sprintf('Load Computed from Guages\nUsing Crosstalk Matrix [%s]',cal.outputUnits{i}))
        end
        box on
        grid on
        set(gca,'fontsize',12)
        plot([calculated_loads_min(i), calculated_loads_max(i)],[calculated_loads_min(i), calculated_loads_max(i)],'--k')
        legend(leg_string,'Location','SouthEast')
        saveDir = fullfile(savePath,'Figures',data_folder);
        if ~exist(saveDir)
            mkdir(saveDir)
        end
        if isSingleChannelCal
            saveas(gcf,fullfile(saveDir,[strrep(crosstalk.loads_names{i},'_',' '),' Using Single Channel Calibration.png']))
        else
            saveas(gcf,fullfile(saveDir,[strrep(crosstalk.loads_names{i},'_',' '),' Using Crosstalk Matrix.png']))
        end
    end
end

