function Uoc = fourDis2(t_n, ub_n)
%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( t_n, ub_n );

% Set up fittype and options.
ft = fittype( 'fourier2' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = [0 0 0 0 0 0.00485563006737217];

% Fit model to data.
[a, b] = fit( xData, yData, ft, opts );

p = coeffvalues(a);

Uoc = p(1) + p(2)*cos(t_n.*p(6)) + p(3)*sin(t_n*p(6)) + p(4)*cos(2*t_n.*p(6)) + p(5)*sin(2*t_n.*p(6));


