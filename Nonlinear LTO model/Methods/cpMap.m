function Z = cpMap(Dq, I, Cp, x, y)
%% Fit: 'Cp'.
[xData, yData, zData] = prepareSurfaceData( Dq, I, Cp );

% Set up fittype and options.
ft = fittype( 'poly53' );

% Fit model to data.
[fitresult, gof] = fit( [xData, yData], zData, ft );


p = coeffvalues(fitresult);


%Function interpretation%
Z = p(1) + p(2).*x + p(3).*y + p(4).*x.^2 + p(5).*x.*y + p(6).*y.^2 + p(7).*x.^3 + p(8).*x.^2.*y + p(9).*x.*y.^2 + p(10).*y.^3 + p(11).*x.^4 + p(12).*x.^3.*y + p(13).*x.^2.*y.^2 + p(14).*x.*y.^3 + p(15).*x.^5 + p(16).*x.^4.*y + p(17).*x.^3.*y.^2 + p(18).*x.^2.*y.^3;
   




