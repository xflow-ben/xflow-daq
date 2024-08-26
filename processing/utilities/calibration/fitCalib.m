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
fit_out.rsquare = gof.rsquare;
fit_out.rmse = gof.rmse;