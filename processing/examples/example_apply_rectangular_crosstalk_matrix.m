clear all
close all




% In this example script, we will create fake data for a two-axis load
% cell. Load will be applied to one channel at a time and there will be a linear
% dependence in the second channel from that load. We will then calculate
% the cross talk matrix and demonstrate that the erroneous load is removed.


%% Example of square cross talk matrix with big cross term

cal.type = 'linear_k';
cal.input_channels = {'a','b'};
cal.output_names = {'A','B'};
dataColumns = {'a','b'};

% Build applied load matrix
applied_load_to_channel_1 = [-1 0 1 2 3 0 0 0 0];
applied_load_to_channel_2 = [0 0 0 0 0 0 1 2 3];
load_matrix = [applied_load_to_channel_1;applied_load_to_channel_2]

% Build response matrix
channel_1_response = [-1 0 1 2 3 0 0.2 0.4 0.6];
channel_2_response = [-1 0 1 2 3 0 1.1 2.2 3.3];
response_matrix = [channel_1_response;channel_2_response]

% Calculate cross talk matrix, k
cal.data.k = load_matrix/response_matrix;
cal.data.k
% Load calculated from k matrix
out = apply_calibration(response_matrix',dataColumns,cal)

% Compare load cauclated from k matrix and response data to the applied
% loads
figure
hold on
plot(load_matrix(1,:)',out.A,'x')
plot(load_matrix(2,:)',out.B,'o')
x = 4;
plot(x*[-1 1],x*[-1 1],'--k')

%% Example of square cross talk matrix with real data
load('sample_real_cal_data.mat')
cal.data.load_mat = cal.data.load_mat([1 3],[1:9,18:33]);
cal.data.response_mat = cal.data.response_mat([1 3],[1:9,18:33]);
cal.input_channels = {cal.input_channels{[1,3]}};
cal.output_names = {cal.output_names{[1,3]}};
cal.output_units = {cal.output_units{[1,3]}};

cal.data.k = cal.data.load_mat/cal.data.response_mat;

out = apply_calibration(cal.data.response_mat',cal.input_channels,cal)

figure
hold on
plot(cal.data.load_mat(1,:),out.Upper_Yoke_Fx,'o')
% plot(cal.data.load_mat(2,:),out.Upper_Yoke_Fz,'o')
plot(cal.data.load_mat(2,:),out.Upper_Yoke_My,'o')
x = 6000;
plot(x*[-1 1],x*[-1 1],'--k')


load('sample_real_cal_data.mat')
x = cal.data.load_mat([2],[10:17]);
y = cal.data.response_mat([2],[10:17]);
figure
hold on
plot(x,y,'.')

x = cal.data.load_mat([2],[18:33]);
y = cal.data.response_mat([2],[18:33]);
plot(x,y,'x')

%%
load('sample_real_cal_data.mat')
mv_FZ = cal.data.response_mat([2],[10:33])
mv_My = cal.data.response_mat([3],[10:33])
Fz = cal.data.load_mat([2],[10:33])
% Fz(9:end) = Fz(9:end)*0.66;
My = cal.data.load_mat([3],[10:33])
cal.data.load_mat = cal.data.load_mat([2 3],[10:33]);
cal.data.response_mat = cal.data.response_mat([2 3],[10:33]);
cal.input_channels = {cal.input_channels{[2,3]}};
cal.output_names = {cal.output_names{[2,3]}};
cal.output_units = {cal.output_units{[2,3]}};
cal.data.k = cal.data.load_mat/cal.data.response_mat;

out = apply_calibration(cal.data.response_mat',cal.input_channels,cal)


% %% Example of rectangular cross talk matrix with big cross term
% cal.input_channels = {'a','b','c'};
% cal.output_names = {'A','B'};
% dataColumns = {'a','b','c'};
% % Build applied load matrix
% applied_load_to_channel_1 = [-1 0 1 2 3 0 0 0 0 0 0 0];
% applied_load_to_channel_2 = [0 0 0 0 0 0 1 2 3 0.5 1 1.5];
% 
% load_matrix = [applied_load_to_channel_1;applied_load_to_channel_2]
% 
% % Build response matrix
% channel_1_response = [-1 0 1 2 3 0 0.2 0.4 0.6 0.1 0.2 0.3];
% channel_2_response = [-1 0 1 2 3 0 1.1 2.2 3.3 0.5 1 1.5];
% 
% response_matrix = [channel_1_response;channel_2_response]
% 
% % Calculate cross talk matrix, k
% cal.data.k = load_matrix/response_matrix;
% cal.data.k
% % Load calculated from k matrix
% out = apply_calibration(response_matrix',dataColumns,cal)
% 
% % Compare load cauclated from k matrix and response data to the applied
% % loads
% out.A./load_matrix(1,:)'
% out.B./load_matrix(2,:)'
% out.C./load_matrix(3,:)'