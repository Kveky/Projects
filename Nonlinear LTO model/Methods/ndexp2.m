function [y, p] = ndexp2(t, Ub)


[xData, yData] = prepareCurveData( t, Ub );

% Set up fittype and options
ft = fittype( 'exp2' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = [2.47956990805051 3.61736678403227e-05 0.000283559712200056 0.0111103408256215];

% Fit model to data

[fitresult, gof] = fit( xData, yData, ft, opts );
p = coeffvalues(fitresult);
y = p(1).*exp(p(2).*t)+p(3).*exp(p(4).*t);

