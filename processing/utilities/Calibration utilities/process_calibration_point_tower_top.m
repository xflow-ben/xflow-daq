function d = process_calibration_point_tower_top(filename,ch_list,dataDir,tdmsPrefix)
% generic calibration process point

temp = split(filename,{tdmsPrefix.data_files{1},'.tdms'});
fileNumStr = temp{2};

in.chanNames = {};
in.data = [];
for II = 1:length(tdmsPrefix.data_files)

    tdms = readTDMS(fullfile(dataDir,[tdmsPrefix.data_files{II},fileNumStr,'.tdms']),'');

    temp = convertTDMStoXFlowFormat(tdms);
    in.chanNames = [in.chanNames temp.chanNames];
    in.data = [in.data temp.data];

end

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
d.mid_time = median(in.data(:,time_ind(1)));


tdms = readTDMS(fullfile(dataDir,[tdmsPrefix.applied_load,fileNumStr,'.tdms']),'');

applied_load_ind = strcmp({tdms.property.name},'appliedLoad');
if sum(applied_load_ind) > 0
    d.load = str2double(tdms.property(applied_load_ind).value);
else
    error('Check Spelling of Applied_Load')
end
end
