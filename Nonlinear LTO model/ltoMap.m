addpath(genpath('Methods'))
addpath(genpath('measuredData'))

%Parametri za izradu mapa
%Charge
%----------------------
x6 = linspace(0,1,43);
x12 = linspace(0,1,31);
x18 = linspace(0,1,22);
x24 = linspace(0,1,12);


%Discharge
%----------------------
x6Dis = linspace(1,0,32);
x12Dis = linspace(1,0,24);
x18Dis = linspace(1, 0,13);
x24Dis = linspace(1, 0, 12);


xk = 0:0.001:1;
xkDis = 1:-0.001:0;

%Prvi set mjerenja
%dxi = [0 0.02579 0.05493 0.07692 0.099374 0.12821 0.15385 0.23077 0.30769 0.38461 0.46154 0.53846 0.61539 0.64103 0.66666 0.69231 0.71795 0.74359 0.76923 0.79487 0.82051 0.84616 0.87180 0.89744 0.92308 0.94872 0.97436 1];  
%dUoc = [1.663190  2.068240 2.090715 2.100920 2.113350 2.122406 2.131622 2.153261 2.152316 2.173648 2.190853 2.212600 2.238120 2.249200 2.257410 2.272650 2.287980 2.305020 2.323950 2.336490 2.361500 2.385900 2.406090 2.438520 2.483400 2.519110 2.642650 2.755360]; 
%2.06987  2.10405 2.09326  2.11610 2.03987 10675
%Drugi set mjerenja
dxi = [0 0.02941 0.05882 0.08824 0.11765 0.14706 0.17647 0.20588 0.29412 0.38235 0.47059 0.55882 0.64706 0.73529 0.76470 0.79412 0.82353 0.85294 0.88235 0.91177 0.94118 0.97059 1];
dUoc = [1.75322 2.03987  2.09326 2.10675 2.11610 2.12451 2.13360 2.13860 2.16270 2.18163 2.19778 2.22238 2.24607 2.29094 2.30815 2.32132 2.34510 2.36715 2.39125 2.41715 2.44550 2.48900 2.68371];

%Set mjerenja za temperaturu 
dxiT = [0 0.04 0.08 0.16 0.20 0.24 0.28 0.32 0.36 0.40 0.44 0.48 0.52 0.56 0.60 0.64 0.68 0.72 0.76 0.8 0.84 0.88 0.92 0.96 1];
dT = [ 17 18 18.8 19.2 19.5 19.6 19.7 20.4 20.6 20.8 21 21.2 21.3 21.3 21.35 21.36 21.4 21.45 21.48 21.6 21.7 22 22.4 22.8 23];

%Dobivanje Uoc krivulje

[xi, Uoc] = seg3(dxi, dUoc);

plot(xk, Uoc,'r-')
hold on
plot(xk, Uocmap(6,:))
hold on
plot(dxi,dUoc,'.')

 
[xi, Uoc] = seg3(dxi, dUoc);

plot(xi, Uoc)
hold on
plot(dxi,dUoc,'.')

%Calculating Uoc gradient for charge and discharge
dUocdSoCChg = gradient(Uoc)./(gradient(xk));
plot(xk, dUocdSoCChg)

dUocdSoCDis = gradient(Uocmap(1,:))./(gradient(xk));
plot(xk, dUocdSoCDis)

dUocdSoCmap = [dUocdSoCDis; dUocdSoCDis; dUocdSoCDis; dUocdSoCDis; dUocdSoCChg; dUocdSoCChg; dUocdSoCChg;dUocdSoCChg]

%% Mean difference between real model and simulated - Discharge
%--------------------------------------------------------------
delta = mean(ub - ub_sim);
delta24 = 7.2; %mV
delta18 = 27.2;%mV
delta12 = 20.8; %mV
delta6 = 25.3; %mV

Delta = [delta6 delta12 delta18 delta24];
avgDelta = mean(Delta)/1000; %V

%Voltage correction for Charge Uoc
Uoc = Uoc - avgDelta;
UocDis = Uoc;

%% Mean difference between real model and simulated - Charge
%-----------------------------------------------------------
delta = mean(ub24-ub_sim)
delta24 = 9.7; %mV
delta18 = 9.3;%mV
delta12 = 10.2; %mV
delta6 = 1; %mV

Delta = [delta6 delta12 delta18 delta24];
avgDelta = mean(Delta)/1000; %V

%Voltage correction for Charge Uoc
UocChg = zeros(1,length(Uoc));
UocChg = Uoc;
%% Charge map
%-----------------------------

%6A Parameter identification%
[Rs6,Rp6,Tp6, DQ6]=dynMapChg6() ;

%12A Parameter identification%
[Rs12,Rp12,Tp12, DQ12]=dynMapChg12() ;

%18A Parameter identification%
[Rs18,Rp18,Tp18, DQ18]=dynMapChg18() ;

%24A Parameter identification%
[Rs24,Rp24,Tp24, DQ24]=dynMapChg24() ;

%% Discharge map
%-----------------------------

%6A Parameter identification%
[RsDis6,RpDis6,TpDis6, DQDis6]=dynMapDis6() ;

%12A Parameter identification%
[RsDis12,RpDis12,TpDis12, DQDis12]=dynMapDis12() ;

%18A Parameter identification%
[RsDis18,RpDis18,TpDis18, DQDis18]=dynMapDis18() ;

%24A Parameter identification%
[RsDis24,RpDis24,TpDis24, DQDis24]=dynMapDis24() ;

%Identifing virtual capacity
Cp6 = Tp6./RP6;
Cp12 = Tp12./RP12;
Cp18 = Tp18./RP18;
Cp24 = Tp24./RP24;

CpDis6 = TpDis6./RpDis6;
CpDis12 = TpDis12./RpDis12;
CpDis18 = TpDis18./RpDis18;
CpDis24 = TpDis24./RpDis24;

%% Discharge 
%Rs map
Rs6mapDis=interp1(x6Dis,RsDis6,xkDis,'pchip');
Rs12mapDis=interp1(x12Dis,RsDis12,xkDis,'pchip');
Rs18mapDis=interp1(x18Dis,RsDis18,xkDis,'pchip');
Rs24mapDis=interp1(x24Dis,RsDis24,xkDis,'pchip');
RsMapDis = [Rs6mapDis; Rs12mapDis; Rs18mapDis; Rs24mapDis];
RsMapDis = [RsMapDis(4,:); RsMapDis(3,:); RsMapDis(2,:); RsMapDis(1,:)] 

%Rp map
Rp6mapDis=interp1(x6Dis,RpDis6,xkDis,'pchip');
Rp12mapDis=interp1(x12Dis,RpDis12,xkDis,'pchip');
Rp18mapDis=interp1(x18Dis,RpDis18,xkDis,'pchip');
Rp24mapDis=interp1(x24Dis,RpDis24,xkDis,'pchip');
RpMapDis = [Rp6mapDis; Rp12mapDis; Rp18mapDis; Rp24mapDis];
RpMapDis = [RpMapDis(4,:); RpMapDis(3,:); RpMapDis(2,:); RpMapDis(1,:)] 
figure(4)
plot (DxiMapDis, Rs24mapDis)

%Cp map
Cp6mapDis = interp1(x6Dis,CpDis6,xkDis,'pchip');
Cp12mapDis = interp1(x12Dis, CpDis12, xkDis, 'pchip');
Cp18mapDis = interp1(x18Dis, CpDis18, xkDis, 'pchip');
Cp24mapDis = interp1(x24Dis, CpDis24, xkDis, 'pchip');
CpMapDis = [Cp6mapDis; Cp12mapDis; Cp18mapDis; Cp24mapDis];
CpMapDis = [CpMapDis(4,:); CpMapDis(3,:); CpMapDis(2,:); CpMapDis(1,:)] 

%DQb map
DxiMapDis = xkDis;
%I map
IMapDis = [-24; -18; -12; -6];
clearvars -except RsMapDis RpMapDis CpMapDis DxiMapDis IMapDis UocDis dUocdSoCDis
save modelValuesDis.mat
%% Charge 
%Rs map
Rs6map=interp1(x6,Rs6,xk,'pchip');
Rs12map=interp1(x12,Rs12,xk,'pchip');
Rs18map=interp1(x18,Rs18,xk,'pchip');
Rs24map=interp1(x24,Rs24,xk,'pchip');
RsMap = [Rs6map; Rs12map; Rs18map; Rs24map];

plot (xk, Rs6map)
%Rp map
Rp6map=interp1(x6,Rp6,xk,'pchip');
Rp12map=interp1(x12,Rp12,xk,'pchip');
Rp18map=interp1(x18,Rp18,xk,'pchip');
Rp24map=interp1(x24,Rp24,xk,'pchip');
RpMap = [Rp6map; Rp12map; Rp18map; Rp24map];

%Cp map
Cp6map = interp1(x6,Cp6,xk,'pchip');
Cp12map = interp1(x12, Cp12, xk, 'pchip');
Cp18map = interp1(x18, Cp18, xk, 'pchip');
Cp24map = interp1(x24, Cp24, xk, 'pchip');
CpMap = [Cp6map; Cp12map; Cp18map; Cp24map];

Uocmap = [UocDis; UocDis; UocDis; UocDis; Uoc; Uoc; Uoc; Uoc];

%DQb map
DxiMap = xk;
%I map
IMap = [6; 12; 18; 24];
clearvars -except RsMap RpMap CpMap DxiMap IMap Uocmap dUocdSoCChg
save modelValuesChg.mat
% %%
% %Korekcija napona zbog Uoc krivulje
% % Nije se dovoljno dugo pustala baterija u mirovanje da joj se tocno
% %odredi Uoc krivulja
% %Potrebno ucitati measuredData.mat file
% 
% deltaU6 = mean(ub_sim6 - ub6);
% dib6 = mean(ib6);
% Kr6 = deltaU/dib;
% 
% deltaU12 = mean(ub_sim12 - ub12);
% dib12 = mean(ib12);
% Kr12 = deltaU12/dib12;
% 
% deltaU18 =abs(ub - ub_sim);
% dib18 = abs(ib);
% Kr18inv =mean(deltaU18./dib18);
% Kr18 = 1/Kr18inv;
% K = mean(RpMapDis(3,:))*Kr18
% 
% deltaU24 = ub - ub_sim;
% dib24 = ib;
% Kr24 = mean(abs(deltaU24./dib24));
% K = Kr24+1
% %Pridruzivanje pojacanja na Rp
% IMap = [-24 -18 -12 -6]
% RpMap6 = Kr6*RpMap(1,:);
% RpMap12 = Kr12*RpMap(2,:);
% RpMap24 = 2*RpMapDis(4,:);
% CpMap24 = CpMapDis(4,:)/2;
% RpMap = [RpMap6; RpMap12; RpMap18; RpMap24];
% 
% CpMapDis(4,:) = CpMap24
% RpMapDis(4,:) = RpMap24
% 
% clearvars -except Rsmap Rpmap Cpmap DxiMap Imap Uocmap dUocdSoCmap
% save ltoMap.mat
%% Combining into one mat file

RpMapDis = [RpMapDis(4,:); RpMapDis(3,:); RpMapDis(2,:); RpMapDis(1,:)]
RsMapDis = [RsMapDis(4,:); RsMapDis(3,:); RsMapDis(2,:); RsMapDis(1,:)]
CpMapDis = [CpMapDis(4,:); CpMapDis(3,:); CpMapDis(2,:); CpMapDis(1,:)]

Imap = [IMapDis; IMap];
Cpmap = [CpMapDis; CpMap];
Rsmap = [RsMapDis; RsMap];
Rpmap = [RpMapDis; RpMap];

clearvars -except Rsmap Rpmap Cpmap DxiMap Imap Uocmap dUocdSoC
save ltoMap.mat


%% fixing measured data
%Charge
ub6chg = [ub6(1:4830); ub6(4840:9666); ub6(9674:14500);ub6(14508:19335);ub6(19341:end)];
t6chg = [t6(1:4830); t12(4840:9666)-10; t6(9674:14500)-10-8; t6(14508:19335)-10-8-8;t6(19341:end)-10-8-8-6 ];
ib6chg= [ib6(1:4830); ib6(4840:9666); ib6(9674:14500);ib6(14508:19335);ib6(19341:end)];

ub12chg = [ub12(1:3315); ub12(4000:7309); ub12(7520:end)];
t12chg = [t12(1:3315); t12(4000:7309)-685; t12(7520:end)-685-211];
ib12chg= [ib12(1:3315); ib12(4000:7309); ib12(7520:end)];

ub18chg = [ub18(1:3317); ub18(3567:end)];
t18chg = [t18(1:3317); t18(3567:end)-250 ];
ib18chg= [ib18(1:3317); ib18(3567:end)];

%Discharge
ub6dis = [ub6Dis(1:6855); ub6Dis(6876:13725); ub6Dis(13765:end)];
t6dis = [t6Dis(1:6855); t6Dis(6876:13725)-21; t6Dis(13765:end)-21-40];
ib6dis = [ib6Dis(1:6855); ib6Dis(6876:13725); ib6Dis(13765:end)];




