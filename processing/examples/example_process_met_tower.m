clear all

load('C:\Users\Ian\Documents\GitHub\xflow-daq\processing\implementations\10m_Spanish_Fork_testing\Calibrations\Results\cal_struct_02_10_24.mat')

consts = XFlow_Spanish_Fork_testing_constants();
files.dataFile = 'data_met_tower_0000.tdms';
files.absolute_data_dir = 'C:\Users\Ian\Documents\GitHub\xflow-daq\processing\examples\';
files.relative_experiment_dir = '';
results = process_data_point(files,cal,consts)