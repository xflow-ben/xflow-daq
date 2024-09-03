function d = process_calibration_point(filename,ch_list)
% generic calibration process point

tdms = readTDMS(filename,'');

in = convertTDMStoXFlowFormat(tdms);

for i = 1:length(ch_list)
    find_temp = find(strcmp(in.chanNames,ch_list{i}));
    if isempty(find_temp)
        error('Requested channel %s not found in meta_data',ch_list{i});
    end
    chind(i) = find_temp;
end

d.median = median(in.data(:,chind))';
d.mean = mean(in.data(:,chind))';
d.std = std(in.data(:,chind))';
d.ch_names = ch_list';
time_ind = find(strcmp(in.chanNames,'time'));
d.mid_time = median(in.data(:,time_ind));

applied_load_ind = strcmp({tdms.property.name},'Applied_Load');
if ~isempty(applied_load_ind)
    d.load = str2double(tdms.property(applied_load_ind).value);
else
    error('Check Spelling of Applied_Load')
end
end
