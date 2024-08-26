function data = process_calibration(filename,consts,directions)
d = arm_calib_process_folder(filename);%,'Lower Arm Mx');

% Make any modifications to d here, if needed (errors in metaData entry)

for i = 1:length(d)
    d(i).force = directions.force*d(i).Load*consts.lbf_to_N;
    d(i).moment = directions.moment*d(i).Load*consts.lbf_to_N *consts.R_lower; % convert to N*m at arm root
    d(i).Indicator_reading = directions.deflect*d(i).Indicator_reading.*consts.inch_to_m;
end

% Process data into force, moment, volts, and deflection
[data,~] = process_all_chan_calib(d,'Indicator_reading');
% apply deflection correction
data.deflect = sign(data.deflect).*(abs(data.deflect)-consts.rad_per_N*abs(data.force)*consts.R_deflect_correction_lower);
save('Lower_arm_-Mx','-struct','data');

for II = 1:6
    subplot(2,3,II)
    hold on
    plot(data.force,data.channel(II).volts,'o')
    grid on
    box on
    title(data.channel(II).chan_name)
end