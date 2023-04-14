function[Rs, Rp, Tp, DQ] = dynMapDis18()

% Creating R0, Rp, tau 1D lookup table for 6A
%First set of measured data
%-------------------------------------------%
clc
%-------------------------------------------%



% Load data
clear all 
clc

load DATA001.MAT

%Nonlinear part - start%
t_n1 = t(5:250); %Creating a initial value 
ub_n1 =ub(5:250);
ib_n1 = ib(5:250);
%Linear part till ending
ub_r = ub(201:5600);
ib_r = ib(201:5600);
t_r = t(201:5600);
plot(t_r, ub_r)

%Nonlinear part - end%
ub_n2 = ub(5601:6310);
ib_n2 = ib(5601:6310);
t_n2 = t(5601:6310);


%Creating Uoc-start%
Uoc1 = pwr2(t_n1,ub_n1);

%Creating Uoc-end%
Uoc2 = fourDis2(t_n2, ub_n2);


plot(t_n2, ub_n2)
hold on
plot(t_n2, Uoc2)

% Sampling time
Ts = t(2) - t(1);

%Detrending the nonlinear part
yy1 = ub_n1 - Uoc1;
uu1 = detrend(ib_n1,0);

yy2 = detrend(ub_r(1:272),1);
uu2 = detrend(ib_r(1:272),0);

yy3 = detrend(ub_r(273:545),1);
uu3 = detrend(ib_r(273:545),0);

yy4 = detrend(ub_r(545:1090),1);
uu4 = detrend(ib_r(545:1090),0);

yy5 = detrend(ub_r(1091:1635),1);
uu5 = detrend(ib_r(1091:1635),0);

yy6 = detrend(ub_r(1636:2180),1);
uu6 = detrend(ib_r(1636:2180),0);

yy7 = detrend(ub_r(2181:2725),1);
uu7 = detrend(ib_r(2181:2725),0);

yy8 = detrend(ub_r(2726:3270),1);
uu8 = detrend(ib_r(2726:3270),0);

yy9 = detrend(ub_r(3271:3815),1);
uu9 = detrend(ib_r(3271:3815),0);

yy10 = detrend(ub_r(3816:4360),1);
uu10 = detrend(ib_r(3816:4360),0);

yy11 = detrend(ub_r(4361:4905),1);
uu11 = detrend(ib_r(4361:4905),0);

yy12 = detrend(ub_r(4906:end),1);
uu12 = detrend(ib_r(4906:end),0);

yy13 = ub_n2- Uoc2;
uu13 = detrend(ib_n2,0);


y =[yy1; yy2; yy3; yy4; yy5; yy6; yy7; yy8; yy9; yy10; yy11; yy12; yy13];
u =[uu1; uu2; uu3; uu4; uu5; uu6; uu7; uu8; uu9; uu10; uu11; uu12; uu13]; 

t_ = t(5:6310);

na = 1; nb = 2; nk = 0;

% Five data sets for identification
y1 = y(1:146); u1 = u(1:146); 
y2 = y(147:418); u2 = u(147:418); 
y3 = y(419:691); u3 = u(419:691); 
y4 = y(692:1236); u4 = u(692:1236);
y5 = y(1237:1781); u5 = u(1237:1781);
y6 = y(1782:2326); u6 = u(1782:2326);
y7= y(2327:2871); u7 = u(2327:2871);
y8 = y(2872:3416); u8 = u(2872:3416);
y9 = y(3417:3961); u9 = u(3417:3961);
y10 = y(3962:4506); u10 = u(3962:4506);
y11 = y(4507:5051); u11 = u(4507:5051);
y12 = y(5052:5596); u12 = u(5052:5596);
y13 = y(5597:end); u13 = u(5597:end);

thm1 = arx([y1 u1],[na nb nk]);
[num1,den1] = th2tf(thm1);
b1 = num1(1); b0 = num1(2); a = -den1(2);
Rs1 = b1; tau_p1 = -Ts/log(a); Rp1 = (b0 + a*b1)/(1-a);

thm2 = arx([y2 u2],[na nb nk]);
[num2,den2] = th2tf(thm2);
b1 = num2(1); b0 = num2(2); a = -den2(2);
Rs2 = b1; tau_p2 = -Ts/log(a); Rp2 = (b0 + a*b1)/(1-a);

thm3 = arx([y3 u3],[na nb nk]);
[num3,den3] = th2tf(thm3);
b1 = num3(1); b0 = num3(2); a = -den3(2);
Rs3 = b1; tau_p3 = -Ts/log(a); Rp3 = (b0 + a*b1)/(1-a);

thm4 = arx([y4 u4],[na nb nk]);
[num4,den4] = th2tf(thm4);
b1 = num4(1); b0 = num4(2); a = -den4(2);
Rs4 = b1; tau_p4 = -Ts/log(a); Rp4 = (b0 + a*b1)/(1-a);

thm5 = arx([y5 u5],[na nb nk]);
[num5,den5] = th2tf(thm5);
b1 = num5(1); b0 = num5(2); a = -den5(2);
Rs5 = b1; tau_p5 = -Ts/log(a); Rp5 = (b0 + a*b1)/(1-a);

thm6 = arx([y6 u6],[na nb nk]);
[num6,den6] = th2tf(thm6);
b1 = num6(1); b0 = num6(2); a = -den6(2);
Rs6 = b1; tau_p6 = -Ts/log(a); Rp6 = (b0 + a*b1)/(1-a);

thm7 = arx([y7 u7],[na nb nk]);
[num7,den7] = th2tf(thm7);
b1 = num7(1); b0 = num7(2); a = -den7(2);
Rs7 = b1; tau_p7 = -Ts/log(a); Rp7 = (b0 + a*b1)/(1-a);

thm8 = arx([y8 u8],[na nb nk]);
[num8,den8] = th2tf(thm8);
b1 = num8(1); b0 = num8(2); a = -den8(2);
Rs8 = b1; tau_p8 = -Ts/log(a); Rp8 = (b0 + a*b1)/(1-a);

thm9 = arx([y9 u9],[na nb nk]);
[num9,den9] = th2tf(thm9);
b1 = num9(1); b0 = num9(2); a = -den9(2);
Rs9 = b1; tau_p9 = -Ts/log(a); Rp9 = (b0 + a*b1)/(1-a);

thm10 = arx([y10 u10],[na nb nk]);
[num10,den10] = th2tf(thm10);
b1 = num10(1); b0 = num10(2); a = -den10(2);
Rs10 = b1; tau_p10 = -Ts/log(a); Rp10 = (b0 + a*b1)/(1-a);

thm11 = arx([y11 u11],[na nb nk]);
[num11,den11] = th2tf(thm11);
b1 = num11(1); b0 = num11(2); a = -den11(2);
Rs11 = b1; tau_p11 = -Ts/log(a); Rp11 = (b0 + a*b1)/(1-a);

thm12 = arx([y12 u12],[na nb nk]);
[num12,den12] = th2tf(thm12);
b1 = num12(1); b0 = num12(2); a = -den12(2);
Rs12 = b1; tau_p12 = -Ts/log(a); Rp12 = (b0 + a*b1)/(1-a);

thm13 = arx([y13 u13],[na nb nk]);
[num13,den13] = th2tf(thm13);
b1 = num13(1); b0 = num13(2); a = -den13(2);
Rs13 = b1; tau_p13 = -Ts/log(a); Rp13 = (b0 + a*b1)/(1-a);

Rs = [Rs1 Rs2 Rs3 Rs4 Rs5 Rs6 Rs7 Rs8 Rs9 Rs10 Rs11 Rs12 Rs13 ];
Rp = [Rp1 Rp2 Rp3 Rp4 Rp5 Rp6 Rp7 Rp8 Rp9 Rp10 Rp11 Rp12 Rp13 ];
Tp = [tau_p1 tau_p2 tau_p3 tau_p4 tau_p5 tau_p6 tau_p7 tau_p8 tau_p9 tau_p10 tau_p11 tau_p12 tau_p13 ];

%Creating DQ map for following 1D lookup table

DQ = 18*[146 418 691 1236 1781 2326 2871 3416 3961 4506 5051 5596 6307]/3600;

figure(3),
subplot(311),plot(DQ,1000*Rs,'b*:','LineWidth',1.5,'MarkerSize',6),grid on
ylabel('R_s [m\Omega]')
subplot(312),plot(DQ,1000*Rp,'b*:','LineWidth',1.5,'MarkerSize',6),grid on
ylabel('R_p [m\Omega]')
subplot(313),plot(DQ,Tp,'b*:','LineWidth',1.5,'MarkerSize',6),grid on
ylabel('T_p [s]'),xlabel('\DeltaQ [Ah]')







end


