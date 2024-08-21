
% for 9237, alias free bandwidth is 0.45 * f_s, for alias free  = 120, f_s
% = 266
strain_f_s = 

%% 9237 Bridge modules (strain channels)

d_strain = xfedaq();
d_strain.rate = 630;
sampleClockTimebaseRate = 5000000;
d_strain.acquisitionType = 'finite';

d_strain.addAIBridgeChan('cDAQ9188-18F21FFMod1/ai0','Volts per Volt',[-0.025 0.025],'full','internal',10,350);
d_strain.addAIBridgeChan('cDAQ9188-18F21FFMod1/ai1','Volts per Volt',[-0.025 0.025],'full','internal',10,350);

% This works, dont fuck it up!
d_strain.routeSignal('/cDAQ9188-18F21FF/20MHzTimebase','/cDAQ9188-18F21FF/PFI0')
d_strain.tasks(1).setSampClkTimebaseSrc('/cDAQ9188-18F21FF/PFI0');
d_strain.tasks(1).setSampClkTimebaseRate(sampleClockTimebaseRate);

d_strain.finalizeSetup();
d_strain.start();
%% 9205 Voltage modules (accelerometers and other things)

%% 9411 RTD modules