function[Rs, Rp, Tp, DQ] = dynMapChg12()

% Creating R0, Rp, tau 1D lookup table for 6A
%First set of measured data
%-------------------------------------------%
clc
%-------------------------------------------%


d = dir('*.MAT');%Finding all .MAT files 
num_mat = length(d); % Checking the size of all MAT files
% calc_val = 18; %10 given points of input/output

%initialization of variables
% Rs = zeros(1,calc_val*num_mat+3);
% Rp = zeros(1,calc_val*num_mat+3);
% Tp = zeros(1,calc_val*num_mat+3);


Rs = [];
Rp = [];
Tp = [];
j = 1; %i value of the array

for i=1:num_mat
    
    filename = sprintf('DATA_%d.MAT',i); %saving as a variable
    
    load(filename) %loading in the chronical order of .MAT files

    % Sampling time

    Ts = t(2) - t(1);
    
    % Detrending data
    % Remove first 55 points to omit the initial voltage transient
    
    if filename == 'DATA_1.MAT'
        
        %Nonlinear part%
        t_n = t(11:330); %Creating a initial value 
        ub_n =ub(11:330);

        %Linear part till ending
        ub_r = ub(331:3315);
        ib_r = ib(331:3315);

        %Creating Uoc%
        [Uoc, p] = pwr2(t_n,ub_n);

        plot(t_n, ub_n)
        hold on
        plot(t_n, Uoc)

        figure(1)
        subplot(211),plot(t,ib),grid on
        ylabel('i_b [A]')
        subplot(212),plot(t,ub),grid on
        ylabel('u_b [V]'),xlabel('t [s]')

        % Sampling time
        Ts = t(2) - t(1);



        %Detrending the nonlinear part
        yy1 = ub_n - Uoc;
        uu1 = detrend(ib(11:330),0);

        yy2 = detrend(ub_r(1:298),1);
        uu2 = detrend(ib_r(1:298),0);

        yy3 = detrend(ub_r(299:596),1);
        uu3 = detrend(ib_r(299:596),0);

        yy4 = detrend(ub_r(597:894),1);
        uu4 = detrend(ib_r(597:894),0);

        yy5 = detrend(ub_r(895:1192),1);
        uu5 = detrend(ib_r(895:1192),0);

        yy6 = detrend(ub_r(1193:1490),1);
        uu6 = detrend(ib_r(1193:1490),0);

        yy7 = detrend(ub_r(1491:1788),1);
        uu7 = detrend(ib_r(1491:1788),0);

        yy8 = detrend(ub_r(1789:2086),1);
        uu8 = detrend(ib_r(1789:2086),0);

        yy9 = detrend(ub_r(2087:2384),1);
        uu9 = detrend(ib_r(2087:2384),0);

        yy10 = detrend(ub_r(2385:2682),1);
        uu10 = detrend(ib_r(2385:2682),0);

        yy11 = detrend(ub_r(2683:end),1);
        uu11 = detrend(ib_r(2683:end),0);


        y =[yy1; yy2; yy3; yy4; yy5; yy6; yy7; yy8; yy9; yy10; yy11];
        u =[uu1; uu2; uu3; uu4; uu5; uu6; uu7; uu8; uu9; uu10; uu11]; 
        t_ = t(11:3315);

        na = 1; nb = 2; nk = 0;

        % Five data sets for identification
        y1 = y(1:326); u1 = u(1:326);
        y2 = y(327:624); u2 = u(327:624);
        y3 = y(625:922); u3 = u(625:922);
        y4 = y(923:1220); u4 = u(923:1220);
        y5 = y(1221:1518); u5 = u(1221:1518);
        y6 = y(1519:1816); u6 = u(1519:1816);
        y7 = y(1817:2114); u7 = u(1817:2114);
        y8 = y(2115:2412); u8 = u(2115:2412);
        y9 = y(2413:2710); u9 = u(2413:2710);
        y10 = y(2711:3008); u10 = u(2711:3008);
        y11 = y(3009:end); u11 = u(3009:end);
        % ARX model - ident. per data sets

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

        % ARMAX model - ident. per data sets
        
        
%         thm1 = armax([y1 u1],[na nb nc nk]);
%         [A1,B1,C1] = polydata(thm1);
%         b1 = B1(1); b0 = B1(2); a = -A1(2);
%         Rs1 = b1; tau_p1 = -Ts/log(a); Rp1 = (b0 + a*b1)/(1-a);
% 
%         thm2 = armax([y2 u2],[na nb nc nk]);
%         [A2,B2,C2] = polydata(thm2);
%         b1 = B2(1); b0 = B2(2); a = -A2(2);
%         Rs2 = b1; tau_p2 = -Ts/log(a); Rp2 = (b0 + a*b1)/(1-a);
%         
%         thm3 = armax([y3 u3],[na nb nc nk]);
%         [A3,B3,C3] = polydata(thm3);
%         b1 = B3(1); b0 = B3(2); a = -A3(2);
%         Rs3 = b1; tau_p3 = -Ts/log(a); Rp3 = (b0 + a*b1)/(1-a);
%         
%         thm4 = armax([y4 u4],[na nb nc nk]);
%         [A4,B4,C4] = polydata(thm4);
%         b1 = B4(1); b0 = B4(2); a = -A4(2);
%         Rs4 = b1; tau_p4 = -Ts/log(a); Rp4 = (b0 + a*b1)/(1-a);
%         
%         thm5 = armax([y5 u5],[na nb nc nk]);
%         [A5,B5,C5] = polydata(thm5);
%         b1 = B5(1); b0 = B5(2); a = -A5(2);
%         Rs5 = b1; tau_p5 = -Ts/log(a); Rp5 = (b0 + a*b1)/(1-a);
%         
%         thm6 = armax([y6 u6],[na nb nc nk]);
%         [A6,B6,C6] = polydata(thm6);
%         b1 = B6(1); b0 = B6(2); a = -A6(2);
%         Rs6 = b1; tau_p6 = -Ts/log(a); Rp6 = (b0 + a*b1)/(1-a);
% 
%         thm7 = armax([y7 u7],[na nb nc nk]);
%         [A7,B7,C7] = polydata(thm7);
%         b1 = B7(1); b0 = B7(2); a = -A7(2);
%         Rs7 = b1; tau_p7 = -Ts/log(a); Rp7 = (b0 + a*b1)/(1-a);
%         
%         thm8 = armax([y8 u8],[na nb nc nk]);
%         [A8,B8,C8] = polydata(thm8);
%         b1 = B8(1); b0 = B8(2); a = -A8(2);
%         Rs8 = b1; tau_p8 = -Ts/log(a); Rp8 = (b0 + a*b1)/(1-a);
%         
%         thm9 = armax([y9 u9],[na nb nc nk]);
%         [A9,B9,C9] = polydata(thm9);
%         b1 = B9(1); b0 = B9(2); a = -A9(2);
%         Rs9 = b1; tau_p9 = -Ts/log(a); Rp9 = (b0 + a*b1)/(1-a);
%         
%         thm10 = armax([y10 u10],[na nb nc nk]);
%         [A10,B10,C10] = polydata(thm10);
%         b1 = B10(1); b0 = B10(2); a = -A10(2);
%         Rs10 = b1; tau_p10 = -Ts/log(a); Rp10 = (b0 + a*b1)/(1-a);
        % ARX model - ident. per data sets


        %temporary arrays
        
        Rs_t = [Rs1 Rs2 Rs3 Rs4 Rs5 Rs6 Rs7 Rs8 Rs9 Rs10 Rs11];
        Rp_t = [Rp1 Rp2 Rp3 Rp4 Rp5 Rp6 Rp7 Rp8 Rp9 Rp10 Rp11];
        Tp_t = [tau_p1 tau_p2 tau_p3 tau_p4 tau_p5 tau_p6 tau_p7 tau_p8 tau_p9 tau_p10 tau_p11];

        l = length(Rs_t);
        
    elseif filename == 'DATA_3.MAT'

        Ts = t(2) - t(1);

        %Nonlinear part%
        t_n = t(3010:3280); %3280
        ub_n =ub(3010:3280); %3292
        ib_n = ib(3010:3280);
        ub_l = ub(13:3005);
        t_l = t(13:3005);
        tt = [];
        Ib = [];
        u0 = 2.2754;
        SoC_ = SoC(13:3005);
        ib_ = ib(13:3005);

        for k = 1:length(SoC_)
            if ub_l(k) <= u0
                continue
            else
                Ub = ub_l(k:end);
                Ib = ib_(k:end);
                tt = 1:1:length(Ub);
                t_ = tt';
                break
            end
        end

        Uoc= four2(t_n,ub_n);

        %Detrending linear part
        yy1 = detrend(Ub(1:299),1);
        uu1 = detrend(Ib(1:299),0);

        yy2 = detrend(Ub(300:598),1);
        uu2 = detrend(Ib(300:598),0);


        yy3 = detrend(Ub(599:897),1);
        uu3 = detrend(Ib(599:897),0);

        yy4 = detrend(Ub(898:1196),1);
        uu4 = detrend(Ib(898:1196),0);


        yy5 = detrend(Ub(1197:1495),1);
        uu5 = detrend(Ib(1197:1495),0);


        yy6 = detrend(Ub(1496:1794),1);
        uu6 = detrend(Ib(1496:1794),0);

        yy7 = detrend(Ub(1795:2093),1);
        uu7 = detrend(Ib(1795:2093),0);

        yy8 = detrend(Ub(2094:2392),1);
        uu8 = detrend(Ib(2094:2392),0);


        yy9 = detrend(Ub(2393:2691),1);
        uu9 = detrend(Ib(2393:2691),0);


        yy10 = detrend(Ub(2692:end),1);
        uu10 = detrend(Ib(2692:end),0);


        yy11 = ub_n - Uoc;
        uu11 = detrend(ib_n,0);

        y = [yy1; yy2; yy3; yy4; yy5; yy6; yy7; yy8; yy9; yy10; yy11];
        u = [uu1; uu2; uu3; uu4; uu5; uu6; uu7; uu8; uu9; uu10; uu11];


        na = 1; nb = 2; nk = 0;

        % na = 1; nb = 2; nc = 1; nk = 0;


        % 10 data sets for identification

        y1 = y(1:327); u1 = u(1:327); 
        y2 = y(328:654); u2 = u(328:654); 
        y3 = y(655:981); u3 = u(655:981);
        y4 = y(982:1308); u4 = u(982:1308);
        y5 = y(1309:1635); u5 = u(1309:1635);
        y6 = y(1636:1962); u6 = u(1636:1962);
        y7 = y(1963:2289); u7 = u(1963:2289);
        y8 = y(2290:2616); u8 = u(2290:2616);
        y9 = y(2617:2986); u9 = u(2617:2986);
        y10 = y(2987:end); u10 = u(2987:end);

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


        
        %ARMAX model
        
%         thm1 = armax([y1 u1],[na nb nc nk]);
%         [A1,B1,C1] = polydata(thm1);
%         b1 = B1(1); b0 = B1(2); a = -A1(2);
%         Rs1 = b1; tau_p1 = -Ts/log(a); Rp1 = (b0 + a*b1)/(1-a);
% 
%         thm2 = armax([y2 u2],[na nb nc nk]);
%         [A2,B2,C2] = polydata(thm2);
%         b1 = B2(1); b0 = B2(2); a = -A2(2);
%         Rs2 = b1; tau_p2 = -Ts/log(a); Rp2 = (b0 + a*b1)/(1-a);
%         
%         thm3 = armax([y3 u3],[na nb nc nk]);
%         [A3,B3,C3] = polydata(thm3);
%         b1 = B3(1); b0 = B3(2); a = -A3(2);
%         Rs3 = b1; tau_p3 = -Ts/log(a); Rp3 = (b0 + a*b1)/(1-a);
%               
%         

        Rs_t = [Rs1 Rs2 Rs3 Rs4 Rs5 Rs6 Rs7 Rs8 Rs9 Rs10 ];
        Rp_t = [Rp1 Rp2 Rp3 Rp4 Rp5 Rp6 Rp7 Rp8 Rp9 Rp10 ];
        Tp_t = [tau_p1 tau_p2 tau_p3 tau_p4 tau_p5 tau_p6 tau_p7 tau_p8 tau_p9 tau_p10];

        l = length(Rs_t);
        
    else 
        % Load data

        u0 = 2.1990;
        % Sampling time
        Ts = t(2) - t(1);
        % Detrending data
        % Remove first 55 points to omit the initial voltage transient

        tt = [];
        Ib = [];

        SoC_ = SoC(11:3309);
        ub_ = ub(11:3309);
        ib_ = ib(11:3309);

        for k = 1:length(SoC_)
            if ub_(k) <= u0
                continue
            else
                Ub = ub_(k:end);
                Ib = ib_(k:end);
                tt = 1:1:length(Ub);
                t_ = tt';
                break
            end
        end


        yy1 = detrend(Ub(1:323),1);
        uu1 = detrend(Ib(1:323),0);

        yy2 = detrend(Ub(324:646),1);
        uu2 = detrend(Ib(324:646),0);


        yy3 = detrend(Ub(647:969),1);
        uu3 = detrend(Ib(647:969),0);


        yy4 = detrend(Ub(970:1292),1);
        uu4 = detrend(Ib(970:1292),0);


        yy5 = detrend(Ub(1293:1615),1);
        uu5 = detrend(Ib(1293:1615),0);

        yy6 = detrend(Ub(1616:1938),1);
        uu6 = detrend(Ib(1616:1938),0);

        yy7 = detrend(Ub(1939:2261),1);
        uu7 = detrend(Ib(1939:2261),0);


        yy8 = detrend(Ub(2262:2584),1);
        uu8 = detrend(Ib(2262:2584),0);


        yy9 = detrend(Ub(2585:2907),1);
        uu9 = detrend(Ib(2585:2907),0);


        yy10 = detrend(Ub(2908:3230),1);
        uu10 = detrend(Ib(2908:3230),0);


        y = [yy1; yy2; yy3; yy4; yy5; yy6; yy7; yy8; yy9; yy10];
        u = [uu1; uu2; uu3; uu4; uu5; uu6; uu7; uu8; uu9; uu10];

        ylabel('y'),xlabel('t [s]')

        na = 1; nb = 2; nk = 0;

        %         na = 1; nb = 2; nc = 1; nk = 0;


        % 10 data sets for identification

        y1 = y(1:323); u1 = u(1:323); 
        y2 = y(324:646); u2 = u(324:646); 
        y3 = y(647:969); u3 = u(647:969);
        y4 = y(970:1292); u4 = u(970:1292);
        y5 = y(1293:1615); u5 = u(1293:1615);
        y6= y(1616:1938); u6 = u(1616:1938);
        y7 = y(1939:2261); u7 = u(1939:2261);
        y8 = y(2262:2584); u8 = u(2262:2584);
        y9 = y(2585:2907); u9 = u(2585:2907);
        y10 = y(2908:end); u10 = u(2908:end);

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

        %ARMAX model
        
%         thm1 = armax([y1 u1],[na nb nc nk]);
%         [A1,B1,C1] = polydata(thm1);
%         b1 = B1(1); b0 = B1(2); a = -A1(2);
%         Rs1 = b1; tau_p1 = -Ts/log(a); Rp1 = (b0 + a*b1)/(1-a);
% 
%         thm2 = armax([y2 u2],[na nb nc nk]);
%         [A2,B2,C2] = polydata(thm2);
%         b1 = B2(1); b0 = B2(2); a = -A2(2);
%         Rs2 = b1; tau_p2 = -Ts/log(a); Rp2 = (b0 + a*b1)/(1-a);
%         
%         thm3 = armax([y3 u3],[na nb nc nk]);
%         [A3,B3,C3] = polydata(thm3);
%         b1 = B3(1); b0 = B3(2); a = -A3(2);
%         Rs3 = b1; tau_p3 = -Ts/log(a); Rp3 = (b0 + a*b1)/(1-a);
%         
%         thm4 = armax([y4 u4],[na nb nc nk]);
%         [A4,B4,C4] = polydata(thm4);
%         b1 = B4(1); b0 = B4(2); a = -A4(2);
%         Rs4 = b1; tau_p4 = -Ts/log(a); Rp4 = (b0 + a*b1)/(1-a);
%         
%         thm5 = armax([y5 u5],[na nb nc nk]);
%         [A5,B5,C5] = polydata(thm5);
%         b1 = B5(1); b0 = B5(2); a = -A5(2);
%         Rs5 = b1; tau_p5 = -Ts/log(a); Rp5 = (b0 + a*b1)/(1-a);
%         
%         thm6 = armax([y6 u6],[na nb nc nk]);
%         [A6,B6,C6] = polydata(thm6);
%         b1 = B6(1); b0 = B6(2); a = -A6(2);
%         Rs6 = b1; tau_p6 = -Ts/log(a); Rp6 = (b0 + a*b1)/(1-a);
% 
%         thm7 = armax([y7 u7],[na nb nc nk]);
%         [A7,B7,C7] = polydata(thm7);
%         b1 = B7(1); b0 = B7(2); a = -A7(2);
%         Rs7 = b1; tau_p7 = -Ts/log(a); Rp7 = (b0 + a*b1)/(1-a);
%         
%         thm8 = armax([y8 u8],[na nb nc nk]);
%         [A8,B8,C8] = polydata(thm8);
%         b1 = B8(1); b0 = B8(2); a = -A8(2);
%         Rs8 = b1; tau_p8 = -Ts/log(a); Rp8 = (b0 + a*b1)/(1-a);
%         
%         thm9 = armax([y9 u9],[na nb nc nk]);
%         [A9,B9,C9] = polydata(thm9);
%         b1 = B9(1); b0 = B9(2); a = -A9(2);
%         Rs9 = b1; tau_p9 = -Ts/log(a); Rp9 = (b0 + a*b1)/(1-a);
%         
%         thm10 = armax([y10 u10],[na nb nc nk]);
%         [A10,B10,C10] = polydata(thm10);
%         b1 = B10(1); b0 = B10(2); a = -A10(2);
%         Rs10 = b1; tau_p10 = -Ts/log(a); Rp10 = (b0 + a*b1)/(1-a);
%                 
%         
        

        Rs_t = [Rs1 Rs2 Rs3 Rs4 Rs5 Rs6 Rs7 Rs8 Rs9 Rs10 ];
        Rp_t = [Rp1 Rp2 Rp3 Rp4 Rp5 Rp6 Rp7 Rp8 Rp9 Rp10 ];
        Tp_t = [tau_p1 tau_p2 tau_p3 tau_p4 tau_p5 tau_p6 tau_p7 tau_p8 tau_p9 tau_p10];
        
        l = length(Rs_t);

       
    end
        
    %Inserting into true arrays
    if i == 1;
        
        Rs(j:l) = Rs_t; 
        Rp(j:l) = Rp_t; 
        Tp(j:l) = Tp_t;
    else
        
        Rs(j:j+l-1) = Rs_t;
        Rp(j:j+l-1) = Rp_t;
        Tp(j:j+l-1) = Tp_t;
    end
    
    j = j + l;
    
    clearvars -except Rs Rp Tp j i Ts filename 
end
%Creating DQ map for following 1D lookup table

DQ1 = 12*[326 624 922 1220 1518 1816 2114 2412 2710 3008 3306]/3600;
DQ2 = 12*[323 646 969 1292 1615 1938 2261 2584 2907 3230]/3600 + DQ1(end);
DQ3 = 12*[ 327 654 981 1308 1635 1962 2289 2616 2943 3270]/3600 + DQ2(end);
DQ = [];
DQ = [DQ1 DQ2 DQ3];

figure(3),
subplot(311),plot(DQ,1000*Rs,'b*:','LineWidth',1.25,'MarkerSize',6),grid on
ylabel('R_s [m\Omega]')
subplot(312),plot(DQ,1000*Rp,'b*:','LineWidth',1.25,'MarkerSize',6),grid on
ylabel('R_p [m\Omega]')
subplot(313),plot(DQ,Tp,'b*:','LineWidth',1.25,'MarkerSize',6),grid on
ylabel('T_p [s]'),xlabel('\DeltaQ [Ah]')




end


