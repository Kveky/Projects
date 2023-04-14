%Diplomski rad, Karlo Kvaternik

%-------%
clear all
clc
%-------%

%Dodavanje foldera s metodama i mjerenim podacima
%------------------------------------------------
addpath(genpath('Methods'))
addpath(genpath('LTO_map'))

%Ucitavanje mapa modela i mjerenih podataka sa baterije
%------------------------------------------------------
load('modelValuesDis.mat')
load('modelValuesChg.mat')
load('measuredDataDis.mat')
load('measuredDataChg.mat')
load('ltoMap.mat')

%Vrijednosti modela
%-------------------------
QDis = 31.857; %mean value of all discharged capacities
QChg = 33.0873; %mean value of all charged capacities

%------ inital values - Discharge - Experimental data ------%
Qmax24Dis = 31.2104;
Qmax18Dis = 31.5904;
Qmax12Dis = 31.9704;
Qmax6Dis = 32.6475;
%------ inital values - Charge - Experimental data ---------%
Qmax24Chg = 32.9569;
Qmax18Chg = 33.0159;
Qmax12Chg = 33.1286;
Qmax6Chg = 33.2477;

QmaxChg = [Qmax6Dis; Qmax12Dis; Qmax18Dis; Qmax24Dis];
xib = linspace(0,24,1001);
QMAX=interp1(Imap(5:end),QmaxChg,xib,'pchip');

%Ostale vrijednosti modela
%-------------------------
% Filtar  mjerenja
Tfilt=4e-3; %[s]
% Chopper
Tch = 1e-3;   % [s]
Kch = 1.0;    % [-]
% Parametri zavojnice
Rc = 0.05; % [Ohm]
Lc = 0.7e-3;
Tc = Rc*Lc;
% Vrijeme uzorkovanja
T = 0.1; % 10  milisek.
% smetnje
R = 1.0e-3; 
%Trajanje simulacije
T_pi = 10000;
%Data acquistion time
Tacq = 1;

%Promjenjivi parametri za estimator
%----------------------------------%
% Varijance perturbacija u stanjima
qk11 =1e-6;  %qj11 = 1e-5, qk22=1e-6 rk = 10
qk22 = 1e-6;
 % qk22 = 1.0e2;
Qk = [qk11 0; 0 qk22];
rk =1e1;
P0 = 1e-1*eye(2,2);
%----------------------------------%

% Struja praznjenja u sekvenci
Idis = -15;
% Struja punjenja u sekvenci
Ich = 5;
% Filtar (dinamika) struje baterije od pretvara?a
Tbat =2; % [s]


%% PI regulator
T = 0.01; % 10  milisek.
Tsig0 = Tch + Tfilt + T;
D2i = 0.5; D3i = 0.5;
Rb = mean(Rsmap(8,:));
Rtot = Rb + Rc;
Imax = 24;
% Pocetni napon 
uc0 = 0.0;  % [V]
% Pocetna struja
I0 = 0.0;
% Stacionarni napon DC me?ukruga
Udc0=4; %[V]

%Upravljanje po naponu baterije
Tei = 1/(D2i*D3i)*((Tsig0*Lc)/(Tsig0*Rtot+Lc));
Kci = 1/(D2i^2*D3i)*(Tsig0*Lc)/(Tei^2)-Rtot;
Tci = (D3i*D2i^2*Tei^3*Kci)/(Tsig0*Lc);

%Kompenzator od prenapona baterije
D2c = 0.5;
Tsigc = Tei + T + Tfilt;
Tec = 0.9*Tsigc/D2c;

KR_cmp = (1/Rb)*(Tsigc/D2c/Tec - 1);
TI_cmp = Tec*(1 - D2c*Tec/Tsigc);
KI_cmp = KR_cmp/TI_cmp;

%% Iscrtavanje simulacijskog modela i stvarnog %%
%-------------------------------------------
%% Uoc curve 
figure(2)
plot(xk*100,Uoc,'k-','LineWidth',2)
hold on
plot(dxi*100, dUoc,'ro','MarkerSize',8)
xlabel('Battery state-of-charge \xi(k)'),ylabel('Open circuit voltage {\it U_{oc}} [V]')
xlim([0 100])
ylim([1.7 2.7])
grid on
yticks(1.7:0.2:2.7);
ax = gca; 
ax.FontSize = 16; 
set(gca,'fontname','times')
legend('Spline interpolation', 'Measurements','Location','northwest')

%% Discharging curves
figure(1)
plot(Q6dis, ub6dis, 'k','LineWidth',1.5)
hold on
plot (Q12dis, ub12Dis,'g','LineWidth',1.5)
hold on 
plot(Q18dis, ub(4:end),'r','LineWidth',1.5)
hold on 
plot(Q24dis, ub24Dis,'b','LineWidth',1.5)
xlabel('Discharged charge {\itQ_{max}} ({\it I_d} ) [Ah]'),ylabel('Battery terminal voltage {\it U_b} [V]')
xlim([0 33])
ylim([1.7 2.7])
grid on
yticks(1.7:0.2:2.7);
ax = gca; 
ax.FontSize = 16; 
set(gca,'fontname','times')
legend('6 A', '12 A', '18 A', '24 A','Location','northeast')
title(legend,['Discharging' newline 'current | I_d |'])

%% Rp Rs Tp map figure
figure(2)
plot(DxiMap*100, Rpmap(5,:)*1000,'b-','LineWidth',1.25,'MarkerSize',6)
hold on
plot(DxiMap*100, Rpmap(6,:)*1000,'g-','LineWidth',1.25,'MarkerSize',6)
hold on
plot(DxiMap*100,Rpmap(7,:)*1000,'k-','LineWidth',1.25,'MarkerSize',6)
hold on
plot(DxiMap*100,Rpmap(8,:)*1000,'r-','LineWidth',1.25,'MarkerSize',6)
xlabel('Battery state-of-charge \xi [%]'),ylabel('{\it R_p} [m\Omega]')
xlim([0 100])
grid on
xticks(0:20:100);
ax = gca; 
ax.FontSize = 16; 
set(gca,'fontname','times')
legend('6 A', '12 A', '18 A', '24 A','Location','northeast')
title(legend,['Charging' newline 'current | I_c |'])

figure(3)
plot(DxiMap*100, Rpmap(4,:)*1000,'b-','LineWidth',1.25,'MarkerSize',6)
hold on
plot(DxiMap*100, Rpmap(3,:)*1000,'g-','LineWidth',1.25,'MarkerSize',6)
hold on
plot(DxiMap*100,Rpmap(2,:)*1000,'k-','LineWidth',1.25,'MarkerSize',6)
hold on
plot(DxiMap*100,Rpmap(1,:)*1000,'r-','LineWidth',1.25,'MarkerSize',6)
xlabel('Battery state-of-charge \xi [%]'),ylabel('{\it R_p} [m\Omega]')
xlim([0 100])
grid on
xticks(0:20:100);
ax = gca; 
ax.FontSize = 16; 
set(gca,'fontname','times')
legend('6 A', '12 A', '18 A', '24 A','Location','northeast')
title(legend,['Discharging' newline 'current | I_d |'])


figure(4)
plot(DxiMap*100, Rsmap(4,:)*1000,'b-','LineWidth',1.25,'MarkerSize',6)
hold on
plot(DxiMap*100, Rsmap(3,:)*1000,'g-','LineWidth',1.25,'MarkerSize',6)
hold on
plot(DxiMap*100,Rsmap(2,:)*1000,'k-','LineWidth',1.25,'MarkerSize',6)
hold on
plot(DxiMap*100,Rsmap(1,:)*1000,'r-','LineWidth',1.25,'MarkerSize',6)
xlabel('Battery state-of-charge \xi [%]'),ylabel(' {\it R_s} [m\Omega]')
xlim([0 100])
grid on
xticks(0:20:100);
ax = gca; 
ax.FontSize = 16; 
set(gca,'fontname','times')
legend('6 A', '12 A', '18 A', '24 A','Location','northeast')
title(legend,['Discharging' newline 'current | I_d |'])

figure(5)
plot(DxiMap*100, Rsmap(5,:)*1000,'b-','LineWidth',1.25,'MarkerSize',6)
hold on
plot(DxiMap*100, Rsmap(6,:)*1000,'g-','LineWidth',1.25,'MarkerSize',6)
hold on
plot(DxiMap*100,Rsmap(7,:)*1000,'k-','LineWidth',1.25,'MarkerSize',6)
hold on
plot(DxiMap*100,Rsmap(8,:)*1000,'r-','LineWidth',1.25,'MarkerSize',6)
xlabel('Battery state-of-charge \xi [%]'),ylabel(' {\it R_s} [m\Omega]')
xlim([0 100])
grid on
xticks(0:20:100);
ax = gca; 
ax.FontSize = 16; 
set(gca,'fontname','times')
legend('6 A', '12 A', '18 A', '24 A','Location','northeast')
title(legend,['Charging' newline 'current | I_c |'])

figure(6)
plot(DxiMap*100, Rpmap(5,:).*Cpmap(5,:),'b-','LineWidth',1.25,'MarkerSize',6)
hold on
plot(DxiMap*100,Rpmap(6,:).*Cpmap(6,:),'g-','LineWidth',1.25,'MarkerSize',6)
hold on
plot(DxiMap*100,Rpmap(7,:).*Cpmap(7,:),'k-','LineWidth',1.25,'MarkerSize',6)
hold on
plot(DxiMap*100,Rpmap(8,:).*Cpmap(8,:),'r-','LineWidth',1.25,'MarkerSize',6)
xlabel('Battery state-of-charge \xi [%]'),ylabel(' {\it T_p} [s]')
xlim([0 100])
grid on
xticks(0:20:100);
ax = gca; 
ax.FontSize = 16; 
set(gca,'fontname','times')
legend('6 A', '12 A', '18 A', '24 A','Location','northeast')
title(legend,['Charging' newline 'current | I_c |'])

figure(7)
plot(DxiMap*100, Rpmap(4,:).*Cpmap(4,:),'b-','LineWidth',1.25,'MarkerSize',6)
hold on
plot(DxiMap*100,Rpmap(3,:).*Cpmap(3,:),'g-','LineWidth',1.25,'MarkerSize',6)
hold on
plot(DxiMap*100,Rpmap(2,:).*Cpmap(2,:),'k-','LineWidth',1.25,'MarkerSize',6)
hold on
plot(DxiMap*100,Rpmap(1,:).*Cpmap(1,:),'r-','LineWidth',1.25,'MarkerSize',6)
xlabel('Battery state-of-charge \xi [%]'),ylabel(' {\it T_p} [s]')
xlim([0 100])
grid on
xticks(0:20:100);
ax = gca; 
ax.FontSize = 16; 
set(gca,'fontname','times')
legend('6 A', '12 A', '18 A', '24 A','Location','northeast')
title(legend,['Discharging' newline 'current | I_d |'])


%% simulation vs model 

figure(8)
plot(Q6dis, ub6dis, 'b','LineWidth',1.5)
hold on
plot (Q6dis(1:end-2), ub_sim,'r','LineWidth',1.5)
xlabel('Discharged charge {\itQ_{max}} ({\it I_d} ) [Ah]'),ylabel('Battery terminal voltage {\it U_b} [V]')
xlim([0 33])
ylim([1.7 2.7])
grid on
yticks(1.7:0.2:2.7);
ax = gca; 
ax.FontSize = 16; 
set(gca,'fontname','times')
legend('experimental','simulation','Location','northeast')
title(legend,['| I_d | = 6 A'])

figure(9)
plot(Q12dis, ub12Dis, 'b','LineWidth',1.5)
hold on
plot (Q12dis(1:end-1), ub_sim,'r','LineWidth',1.5)
xlabel('Discharged charge {\itQ_{max}} ({\it I_d} ) [Ah]'),ylabel('Battery terminal voltage {\it U_b} [V]')
xlim([0 33])
ylim([1.7 2.7])
grid on
yticks(1.7:0.2:2.7);
ax = gca; 
ax.FontSize = 16; 
set(gca,'fontname','times')
legend('experimental','simulation','Location','northeast')
title(legend,['| I_d | = 12 A'])

figure(10)
plot(Q18dis, ub(4:end), 'b','LineWidth',1.5)
hold on
plot (Q18dis, ub_sim(4:end),'r','LineWidth',1.5)
xlabel('Discharged charge {\itQ_{max}} ({\it I_d} ) [Ah]'),ylabel('Battery terminal voltage {\it U_b} [V]')
xlim([0 33])
ylim([1.7 2.7])
grid on
yticks(1.7:0.2:2.7);
ax = gca; 
ax.FontSize = 16; 
set(gca,'fontname','times')
legend('experimental','simulation','Location','northeast')
title(legend,['| I_d | = 18 A'])


figure(11)
plot(Q24dis, ub24Dis, 'b','LineWidth',1.5)
hold on
plot (Q24dis, ub_sim,'r','LineWidth',1.5)
xlabel('Discharged charge {\itQ_{max}} ({\it I_d} ) [Ah]'),ylabel('Battery terminal voltage {\it U_b} [V]')
xlim([0 33])
ylim([1.7 2.7])
grid on
yticks(1.7:0.2:2.7);
ax = gca; 
ax.FontSize = 16; 
set(gca,'fontname','times')
legend('experimental','simulation','Location','northeast')
title(legend,['| I_d | = 24 A'])

figure(12)
plot(Q6chg, ub6chg, 'b','LineWidth',1.5)
hold on
plot (Q6chg(1:end-4), ub_sim,'r','LineWidth',1.5)
xlabel('Charged charge {\itQ_{max}} ({\it I_d} ) [Ah]'),ylabel('Battery terminal voltage {\it U_b} [V]')
xlim([0 33])
ylim([1.7 2.7])
grid on
yticks(1.7:0.2:2.7);
ax = gca; 
ax.FontSize = 16; 
set(gca,'fontname','times')
legend('experimental','simulation','Location','northwest')
title(legend,['| I_c | = 6 A'])

figure(13)
plot(Q12chg, ub12chg, 'b','LineWidth',1.5)
hold on
plot (Q12chg(1:end-2), ub_sim,'r','LineWidth',1.5)
xlabel('Charged charge {\itQ_{max}} ({\it I_d} ) [Ah]'),ylabel('Battery terminal voltage {\it U_b} [V]')
xlim([0 33])
ylim([1.7 2.7])
grid on
yticks(1.7:0.2:2.7);
ax = gca; 
ax.FontSize = 16; 
set(gca,'fontname','times')
legend('experimental','simulation','Location','northwest')
title(legend,['| I_c | = 12 A'])


figure(14)
plot(Q18chg, ub18chg, 'b','LineWidth',1.5)
hold on
plot (Q18chg(1:end-1), ub_sim,'r','LineWidth',1.5)
xlabel('Charged charge {\itQ_{max}} ({\it I_d} ) [Ah]'),ylabel('Battery terminal voltage {\it U_b} [V]')
xlim([0 33])
ylim([1.7 2.7])
grid on
yticks(1.7:0.2:2.7);
ax = gca; 
ax.FontSize = 16; 
set(gca,'fontname','times')
legend('experimental','simulation','Location','northwest')
title(legend,['| I_c | = 18 A'])


figure(15)
plot(Q24chg, ub24, 'b','LineWidth',1.5)
hold on
plot (Q24chg, ub_sim,'r','LineWidth',1.5)
xlabel('Charged charge {\itQ_{max}} ({\it I_d} ) [Ah]'),ylabel('Battery terminal voltage {\it U_b} [V]')
xlim([0 33])
ylim([1.7 2.7])
grid on
yticks(1.7:0.2:2.7);
ax = gca; 
ax.FontSize = 16; 
set(gca,'fontname','times')
legend('experimental','simulation','Location','northwest')
title(legend,['| I_c | = 24 A'])


%% SOC - ekf
figure(17)
plot(t24, SoC_sim*100, 'b','LineWidth',1.5)
hold on
plot (t24, SoC_est*100,'r','LineWidth',1.5)
xlabel('time {\it t} [s]'),ylabel('Battery state-of-charge \mu [%]')
xlim([0 5000])
ylim([0 100])
grid on
% yticks(0:20:100);
% xticks(0:1000:5000);

ax = gca; 
ax.FontSize = 16; 
set(gca,'fontname','times')
legend('Simulation','Estimated','Location','northwest')
title(legend,['| I_c | = 24 A'])

%% current curvature
figure(16)
plot(xib, QMAX,'b-','LineWidth',1.5)
hold on
plot (Imap(5:end), QmaxChg, 'r*','LineWidth',1.5,'MarkerSize',6)
xlabel('Discharging current |{\itI_d} | [A]'),ylabel('Discharge capacity {\it Q_{max}}({\it I_d} ) [Ah]')
xlim([ 0 Imap(end)])
ylim([QMAX(end) QMAX(1)])
grid on
ax = gca; 
ax.FontSize = 16; 
set(gca,'fontname','times')
legend('Interpolation curve','Measurements','Location','northeast')



%% FuzzyVsPi - COntroller
clearvars -except ib_fuzzy SoC_Fuzzy ub_Fuzzy SoC_est uc_fuzzy t_Fuzzy
save simulation_with_Fuzzy.mat


plot(t,SoC_sim)

figure(17)
plot(t_PI, SoC_PI*100,'k-','LineWidth',1.5)
hold on
plot(t_Fuzzy, SoC_Fuzzy*100,'r-','LineWidth',1.5)
hold on
plot (t_Fuzzy, SoC_est*100, 'b--','LineWidth',1.5,'MarkerSize',6)
xlabel('Time passed {\it t}  [s]'),ylabel('Battery state-of-charge \mu [%]')
xlim([ 0 6200])
ylim([0 110])
yticks(0:25:100);
xticks(0:1550:6200);
grid on
ax = gca; 
ax.FontSize = 16; 
set(gca,'fontname','times')
legend('PI controller','Fuzzy controller','Fuzzy controller(estimated)','Location','northwest')

plot(t_PI, ib_PI)

figure(18)
plot(t_PI, ub_PI,'k-','LineWidth',1.5)
hold on
plot(t_Fuzzy, ub_Fuzzy,'r-','LineWidth',1.5)
hold on
xlabel('Time passed {\it t}  [s]'),ylabel('Battery Voltage {\it U_b}  [V]')
xlim([ 0 6200])
ylim([1.75 2.75])
yticks(1.75:0.2:2.75);
xticks(0:1550:6200);
grid on
ax = gca; 
ax.FontSize = 16; 
set(gca,'fontname','times')
legend('PI controller','Fuzzy controller','Location','northwest')

%input one
[xOut,umfOut] = plotmf(fis,'input',1);
plot(xOut*100, umfOut(:,1),'r--','LineWidth',2)
hold on
plot(xOut*100, umfOut(:,2),'k.-.','LineWidth',2)
hold on
plot(xOut*100, umfOut(:,3),'b-.','LineWidth',2)
hold on
plot(xOut*100, umfOut(:,4),'g-','LineWidth',2)
xlabel('Difference of state-of-charge \Delta\xi (k)'),ylabel(['Membership functions' newline  '\mu_i(\Delta\xi (k))'])
grid on
xlim([0 100])
ylim([0 1.2])
xticks(0:20:100);
ax = gca; 
ax.FontSize = 16; 
set(gca,'fontname','times')

%input two
[xOut,umfOut] = plotmf(fis,'input',2);
plot(xOut, umfOut(:,1),'r--','LineWidth',2)
hold on
plot(xOut, umfOut(:,2),'k-','LineWidth',2)
hold on
plot(xOut, umfOut(:,3),'b-.','LineWidth',2)
xlabel('Measured battery voltage {\it u_b} (k)'),ylabel(['Membership functions' newline  '\mu_j({\it u_b} (k))'])
grid on
xlim([1.7 2.75])
ylim([0 1.2])
xticks(1.6:0.2:3.8);
ax = gca; 
ax.FontSize = 16; 
set(gca,'fontname','times')

%output
gensurf(fis)
xlabel('\mu_i(\Delta\xi (k))'),ylabel(['\mu_j({\it u_b} (k))']),zlabel(['Output rule set:' newline '{\it u_{ch}} [V]'])
set(get(gca,'xlabel'),'rotation',15)
set(get(gca,'ylabel'),'rotation',-30)
zlim([2.75 4])
ax = gca; 
ax.FontSize = 16; 
set(gca,'fontname','times')


