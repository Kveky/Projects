function Uoc = tanReg(dxi,dUoc)

%Nelinearna regresija 
% Uoc(ksi) = a*tan(b*ksi + c) + d
n = length(dxi);

%Izracun parametara S i T

S = zeros(1,n);
T = zeros(1,n);
for i=2:length(S)
    S(i) = S(i-1) + 1/2 * (dUoc(i)+dUoc(i-1))*(dxi(i)-dxi(i-1));
    T(i) = T(i-1) + 1/2 * ((dUoc(i))^2 + (dUoc(i-1))^2)*(dxi(i)-dxi(i-1));
end

% Izracun vrijednosti za matricu 
T_sum = sum(T);
T2_sum = sum(T.*T);
T_S_sum = sum(T.*S);
T_x_sum = sum(T.*dxi);
T_y_sum = sum(T.*dUoc);

S_sum = sum(S);
S2_sum = sum(S.*S);
S_x_sum = sum(S.*dxi);
S_y_sum = sum(S.*dUoc);

x_sum = sum(dxi);
x2_sum = sum(dxi.*dxi);
x_y_sum = sum(dxi.*dUoc);

y_sum = sum(dUoc);

H = [T2_sum T_S_sum T_x_sum T_sum
     T_S_sum S2_sum S_x_sum S_sum
     T_x_sum S_x_sum x2_sum x_sum
     T_sum   S_sum    x_sum   n  ];
 
I = [ T_y_sum; S_y_sum; x_y_sum; y_sum ];

y1 = H\I;

A = y1(1);
B = y1(2);
C = y1(3);

%Odredivanje parametara b
b = 1/2*sqrt(-(B^2)+4*A*C);

X = zeros(1,n);
for i=1:length(X)
    X(i) = tan(b*dxi(i));
end

%Izracun vrijednosti za matricu
X_sum = sum(X);
X2_sum = sum(X.*X);
X_y_sum = sum(X.*dUoc);
X2_y_sum = sum(X.*X.*dUoc);
X2_y2_sum = sum(X.*X.*dUoc.*dUoc);

X_y2_sum = sum(X.*dUoc.*dUoc);

J = [ X2_y2_sum X2_y_sum X_y_sum
      X2_y_sum  X2_sum   X_sum
      X_y_sum   X_sum      n   ];

K = [X_y2_sum; X_y_sum; y_sum];

y2 = J\K;

E = y2(1);
F = y2(2);
G = y2(3);

%Odredivanje parametara c
c = atan(E);

z11 = (tan(b*dxi+c)).^2;
z12 = (tan(b*dxi+c));
z13 = (tan(b*dxi+c)).*dUoc;

z11_sum = sum(z11);
z12_sum = sum(z12);
z13_sum = sum(z13);

L = [ z11_sum z12_sum
      z12_sum    n   ];
M = [z13_sum; y_sum];

y3 = L\M;

a = y3(1);
d = y3(2);


Uoc = a*tan(b*dxi + c) +d;


%Nova metoda


% % u0 = mean(dUoc)
% % y = dUoc-u0
% % z = atanh(y)
% % p = polyfit(dxi,dUoc,16)
% % y=polyval(p,dxi)
% % xk= 0:0.001:1;
% % Uoc_map=interp1(dxi,y,xk,'pchip');

%f = fit(dxi.',dUoc.','poly10')
%y = polyval(p,dxi)
%yh1 = atanh(y)+u0
%yh2 = a*dxi.^3+b*dxi.^2+c*dxi+d + u0

% plot(xk,Uoc_map)
% xk = linspace(0,1,1000);
% [a,b] = createFit(dxi,dUoc)
% format long 
% p = coeffvalues(a)
% y = polyval(p,dxi)
% plot(dxi,y)