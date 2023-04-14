function Z = rpMap(Dq, I, Rp, x,y)

%% Fit: 'rpMap'.
[xData, yData, zData] = prepareSurfaceData( Dq, I, Rp );

% Set up fittype and options.
ft = fittype( 'poly53' );
opts = fitoptions( 'Method', 'LinearLeastSquares' );
% opts.Normalize = 'on';
opts.Lower = [-Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf -1];
opts.Upper = [Inf  Inf  Inf  Inf Inf Inf Inf Inf Inf Inf Inf Inf Inf Inf Inf Inf Inf 1];

% Fit model to data.
[fitresult, gof] = fit( [xData, yData], zData, ft,opts);

p = coeffvalues(fitresult);


%Function interpretation%
Z = p(1) + p(2).*x + p(3).*y + p(4).*x.^2 + p(5).*x.*y + p(6).*y.^2 + p(7).*x.^3 + p(8).*x.^2.*y + p(9).*x.*y.^2 + p(10).*y.^3 + p(11).*x.^4 + p(12).*x.^3.*y + p(13).*x.^2.*y.^2 + p(14).*x.*y.^3 + p(15).*x.^5 + p(16).*x.^4.*y + p(17).*x.^3.*y.^2 + p(18).*x.^2.*y.^3;
                    

% Plot fit with data.
% figure( 'Name', 'rpMap' );
% h = plot( fitresult, [xData, yData], zData );
% legend( h, 'rpMap', 'Rp vs. Dq, I', 'Location', 'NorthEast' );
% Label axes
% xlabel Dq
% ylabel I
% zlabel Rp
% grid on
% view( -16.3, 42.8 );
% 
