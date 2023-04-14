function [Uoc, p] = pwr2(t, ub)

%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( t, ub );

% Set up fittype and options.
ft = fittype( 'power2' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.MaxFunEvals = 700;
opts.MaxIter = 300;
opts.StartPoint = [1.70386759203694 0.0332977402198986 2.27710631654555e-05];

% Fit model to data.
[a, b] = fit( xData, yData, ft, opts );

p = coeffvalues(a);
Uoc = p(1).*t.^p(2)+p(3);