function [data,fits] = process_single_chan_calib(d,chanName,deflectName)

hasForce = 0;
hasMoment = 0;
hasDeflect = 0;
chan_ind = find(strcmp(d(1).ch_names,chanName));
for i = 1:length(d)
    if isfield(d(i),'force')
        force(i) = d(i).force;
        hasForce = 1;
    end
    if isfield(d(i),'moment')
        moment(i) = d(i).moment;
        hasMoment = 1;
    end
    if isfield(d(i),deflectName)
        deflect(i) = d(i).(deflectName);
        hasDeflect = 1;
    end
    volts(i) = d(i).median(chan_ind);

    time(i) = d(i).mid_time;
end

tare_inds = find(force == 0);
tare_volts = volts(tare_inds);
if hasDeflect
    tare_deflect = deflect(tare_inds);
    deflect(tare_inds) = [];
end

tare_time = time(tare_inds);
if hasForce
    force(tare_inds) = [];
    data.force = force;
end

if hasMoment
    moment(tare_inds) = [];
    data.moment = moment;
end

volts(tare_inds) = [];
time(tare_inds) = [];

data.volts = volts - interp1(tare_time,tare_volts,time);
if hasDeflect
    data.deflect = deflect - interp1(tare_time,tare_deflect,time);
end

fits = [];
if hasMoment
    data.moment = moment;
    fits.volts_moment = fitCalib(data.moment,data.volts);
    fits.volts_moment.x = 'moment';
    fits.volts_moment.y = 'volts';
end

if hasForce
    data.force = force;
    fits.volts_force = fitCalib(data.force,data.volts);
    fits.volts_force.x = 'force';
    fits.volts_force.y = 'volts';
end

    function fit_out = fitCalib(x,y)
        [xData, yData] = prepareCurveData( x, y);
        ft = fittype( 'a*x', 'independent', 'x', 'dependent', 'y' );
        opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
        opts.Display = 'Off';
        opts.StartPoint = 0.5;

        [fitresult, gof] = fit( xData, yData, ft, opts );
        if abs(1-abs(gof.rsquare)) > 0.01
            warning('something wrong with fit, bad rsquare')
        end
        fit_out.slope = fitresult.a;
        fit_out.rquare = gof.rsquare;
        fit_out.rmse = gof.rmse;
    end
end