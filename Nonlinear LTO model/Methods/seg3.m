function [xi, Uoc] = seg3(dxi, dUoc)

%Prvi set mjerenja
%dxi = [0 0.02579 0.05493 0.07692 0.099374 0.12821 0.15385 0.23077 0.30769 0.38461 0.46154 0.53846 0.61539 0.64103 0.66666 0.69231 0.71795 0.74359 0.76923 0.79487 0.82051 0.84616 0.87180 0.89744 0.92308 0.94872 0.97436 1];  
%dUoc = [1.663190  2.068240 2.090715 2.100920 2.113350 2.122406 2.131622 2.153261 2.152316 2.173648 2.190853 2.212600 2.238120 2.249200 2.257410 2.272650 2.287980 2.305020 2.323950 2.336490 2.361500 2.385900 2.406090 2.438520 2.483400 2.519110 2.642650 2.755360]; 

%Drugi set mjerenja

len_v = length(dxi);

x1 = dxi(1:5); y1 = dUoc(1:5); 
x2_ = dxi(5:len_v-2); y2_ = dUoc(5:len_v-2);
x3 = dxi(len_v-2:len_v); y3 = dUoc(len_v-2:len_v);

dy1dx1 = (dUoc(6)-dUoc(5))/(dxi(6)-dxi(5));
dy3dx3 = (dUoc(len_v-3)-dUoc(len_v-2))/(dxi(len_v-3)-dxi(len_v-2));

x2 = [dxi(5) dxi(len_v-2)];
y2 = [dUoc(5) dUoc(len_v-2)];

xi_int = 0.0:0.001:1.0;
len_int = length(xi_int);

xi_int1 = xi_int(1:round(dxi(5)*len_int));
xi_int2 = xi_int(round(dxi(5)*len_int)+1:round(dxi(len_v-2)*len_int)-1);
xi_int3 = xi_int(round(dxi(len_v-2)*len_int):len_int);

A1 = [x1(1)^5 x1(1)^4 x1(1)^3 x1(1)^2 x1(1) 1;x1(2)^5 x1(2)^4 x1(2)^3 x1(2)^2 x1(2) 1;x1(3)^5 x1(3)^4 x1(3)^3 x1(3)^2 x1(3) 1;x1(4)^5 x1(4)^4 x1(4)^3 x1(4)^2 x1(4) 1;x1(5)^5 x1(5)^4 x1(5)^3 x1(5)^2 x1(5) 1;5*x1(5)^4 4*x1(5)^3 3*x1(5)^2 2*x1(5) 1 0];
b1 = [y1(1);y1(2);y1(3);y1(4);y1(5);dy1dx1];

A1 = [x1(1)^5 x1(1)^4 x1(1)^3 x1(1)^2 x1(1) 1;x1(2)^5 x1(2)^4 x1(2)^3 x1(2)^2 x1(2) 1;x1(3)^5 x1(3)^4 x1(3)^3 x1(3)^2 x1(3) 1;x1(4)^5 x1(4)^4 x1(4)^3 x1(4)^2 x1(4) 1;x1(5)^5 x1(5)^4 x1(5)^3 x1(5)^2 x1(5) 1;5*x1(5)^4 4*x1(5)^3 3*x1(5)^2 2*x1(5) 1 0];
b1 = [y1(1);y1(2);y1(3);y1(4);y1(5);dy1dx1];

A2 = [3*x2(1)^2 2*x2(1) 1 0; x2(1)^3 x2(1)^2 x2(1) 1;x2(2)^3 x2(2)^2 x2(2) 1;3*x2(2)^2 2*x2(2) 1 0];
b2 = [dy1dx1;y2(1);y2(2);dy3dx3];

A3 = [3*x3(1)^2 2*x3(1) 1 0; x3(1)^3 x3(1)^2 x3(1) 1;x3(2)^3 x3(2)^2 x3(2) 1;x3(3)^3 x3(3)^2 x3(3) 1];
b3 = [dy3dx3;y3(1);y3(2);y3(3)];

p1 = inv(A1)*b1;
p2 = inv(A2)*b2;
p3 = inv(A3)*b3;

y1_int = polyval(p1,xi_int1);
y2_int = polyval(p2,xi_int2);
y3_int = polyval(p3,xi_int3);

Uoc = [y1_int y2_int y3_int];
xi = [xi_int1 xi_int2 xi_int3];

end


% figure(1),
% plot(dxi,dUoc,'kd','LineWidth',1,'MarkerSize',6),hold on
% plot(xi_int1,y1_int,'r:','LineWidth',2)
% plot(xi_int2,y2_int,'g:','LineWidth',2),
% plot(xi_int3,y3_int,'b:','LineWidth',2),grid on
% legend('Mjerenje','Segment 1: polinom 5. reda','Segment 2: polinom 3. reda','Segment 3: polinom 3. reda')
% xlabel('SoC'),ylabel('U_o_c [V]')
% 
% p1_der = (5:-1:1).*p1(1:5)';
% p2_der = (3:-1:1).*p2(1:3)';
% p3_der = (3:-1:1).*p3(1:3)';
% 
% dy1 = polyval(p1_der,xi_int1);
% dy2 = polyval(p2_der,xi_int2);
% dy3 = polyval(p3_der,xi_int3);
% 
% dy_vect = [dy1 dy2 dy3];
% 
% figure(2)
% plot(xi_int,dy_vect,'b','LineWidth',2),grid on
% xlabel('SoC'),ylabel('dU_o_c/dSoC [V]')