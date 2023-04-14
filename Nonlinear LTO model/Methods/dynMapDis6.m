function[Rs, Rp, Tp, DQ] = dynMapDis6()

% Creating R0, Rp, tau 1D lookup table for 6A
%First set of measured data
%-------------------------------------------%
clc
%-------------------------------------------%


d = dir('*.mat');%Finding all .MAT files 
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
    
    filename = sprintf('DATA_%d.mat',i); %saving as a variable
    
    load(filename) %loading in the chronical order of .MAT files

    % Sampling time

    Ts = t(2) - t(1);
    
    % Detrending data
    % Remove first 55 points to omit the initial voltage transient
    
    if filename == 'DATA_1.mat'
        
        %Nonlinear part%
        t_n = t(2:401); %Creating a initial value 
        ub_n =ub(2:401);

        %Linear part till ending
        ub_r = ub(402:6857);
        ib_r = ib(402:6857);

        %Creating Uoc%
        Uoc = pwr2(t_n,ub_n);

        figure(1)
        subplot(211),plot(t,ib),grid on
        ylabel('i_b [A]')
        subplot(212),plot(t,ub),grid on
        ylabel('u_b [V]'),xlabel('t [s]')

        % Sampling time
        Ts = t(2) - t(1);



        %Detrending the nonlinear part
        yy1 = ub_n - Uoc;
        uu1 = detrend(ib(2:401),0);

        yy2 = detrend(ub_r(1:660),1);
        uu2 = detrend(ib_r(1:660),0);

        yy3 = detrend(ub_r(661:1320),1);
        uu3 = detrend(ib_r(661:1320),0);

        yy4 = detrend(ub_r(1321:1980),1);
        uu4 = detrend(ib_r(1321:1980),0);

        yy5 = detrend(ub_r(1981:2640),1);
        uu5 = detrend(ib_r(1981:2640),0);

        yy6 = detrend(ub_r(2641:3300),1);
        uu6 = detrend(ib_r(2641:3300),0);

        yy7 = detrend(ub_r(3301:3960),1);
        uu7 = detrend(ib_r(3301:3960),0);

        yy8 = detrend(ub_r(3961:4620),1);
        uu8 = detrend(ib_r(3961:4620),0);

        yy9 = detrend(ub_r(4621:5280),1);
        uu9 = detrend(ib_r(4621:5280),0);

        yy10 = detrend(ub_r(5281:5940),1);
        uu10 = detrend(ib_r(5281:5940),0);

        yy11 = detrend(ub_r(5941:end),1);
        uu11 = detrend(ib_r(5941:end),0);

        
        y =[yy1; yy2; yy3; yy4; yy5; yy6; yy7; yy8; yy9; yy10; yy11];
        u =[uu1; uu2; uu3; uu4; uu5; uu6; uu7; uu8; uu9; uu10; uu11]; 
        t_ = t(11:3315);

        na = 1; nb = 2; nk = 0;

        % Five data sets for identification
        y1 = y(1:400); u1 = u(1:400);
        y2 = y(401:1045); u2 = u(401:1045);
        y3 = y(1046:1690); u3 = u(1046:1690);
        y4 = y(1691:2335); u4 = u(1691:2335);
        y5 = y(2336:2980); u5 = u(2336:2980);
        y6 = y(2981:3625); u6 = u(2981:3625);
        y7 = y(3626:4270); u7 = u(3626:4270);
        y8 = y(4271:4915); u8 = u(4271:4915);
        y9 = y(4916:5560); u9 = u(4916:5560);
        y10 = y(5561:6205); u10 = u(5561:6205);
        y11 = y(6206:end); u11 = u(6206:end);
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
        
    elseif filename == 'DATA_3.mat'

        Ts = t(2) - t(1);

        %Nonlinear part%
        t_n = t(4501:5792); %3280
        ub_n =ub(4501:5792); %3292
        ib_n = ib(4501:5792);
        ub_l = ub(1:4500);
        t_l = t(10:4500);
        tt = [];
        Ib = [];
        u0 = 2.132;
        SoC_ = DSoC(1:4500);
        ib_ = ib(1:4500);

        for k = 1:length(SoC_)
            if ub_l(k) >= u0
                continue
            else
                Ub = ub_l(k:end);
                Ib = ib_(k:end);
                tt = 1:1:length(Ub);
                t_ = tt';
                break
            end
        end

        Uoc= fourDis2(t_n,ub_n);
        
        
        %Detrending linear part
        yy1 = detrend(Ub(1:449),1);
        uu1 = detrend(Ib(1:449),0);

        yy2 = detrend(Ub(450:898),1);
        uu2 = detrend(Ib(450:898),0);


        yy3 = detrend(Ub(899:1347),1);
        uu3 = detrend(Ib(899:1347),0);

        yy4 = detrend(Ub(1348:1796),1);
        uu4 = detrend(Ib(1348:1796),0);


        yy5 = detrend(Ub(1797:2245),1);
        uu5 = detrend(Ib(1797:2245),0);


        yy6 = detrend(Ub(2246:2694),1);
        uu6 = detrend(Ib(2246:2694),0);

        yy7 = detrend(Ub(2695:3143),1);
        uu7 = detrend(Ib(2695:3143),0);

        yy8 = detrend(Ub(3144:3592),1);
        uu8 = detrend(Ib(3144:3592),0);


        yy9 = detrend(Ub(3593:4041),1);
        uu9 = detrend(Ib(3593:4041),0);


        yy10 = detrend(Ub(4042:end),1);
        uu10 = detrend(Ib(4042:end),0);


        yy11 = ub_n - Uoc;
        uu11 = detrend(ib_n,0);

        y = [yy1; yy2; yy3; yy4; yy5; yy6; yy7; yy8; yy9; yy10; yy11];
        u = [uu1; uu2; uu3; uu4; uu5; uu6; uu7; uu8; uu9; uu10; uu11];


        na = 1; nb = 2; nk = 0;

        % na = 1; nb = 2; nc = 1; nk = 0;


        % 10 data sets for identification

        y1 = y(1:449); u1 = u(1:449); 
        y2 = y(450:898); u2 = u(450:898); 
        y3 = y(899:1347); u3 = u(899:1347);
        y4 = y(1348:1796); u4 = u(1348:1796);
        y5 = y(1797:2245); u5 = u(1797:2245);
        y6 = y(2246:2694); u6 = u(2246:2694);
        y7 = y(2695:3143); u7 = u(2695:3143);
        y8 = y(3144:3592); u8 = u(3144:3592);
        y9 = y(3593:4041); u9 = u(3593:4041);
        y10 = y(4042:4494); u10 = u(4042:4494);
        y11 = y(4495:end); u11 = u(4495:end);
        
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

        Rs_t = [Rs1 Rs2 Rs3 Rs4 Rs5 Rs6 Rs7 Rs8 Rs9 Rs10 Rs11 ];
        Rp_t = [Rp1 Rp2 Rp3 Rp4 Rp5 Rp6 Rp7 Rp8 Rp9 Rp10 Rp11 ];
        Tp_t = [tau_p1 tau_p2 tau_p3 tau_p4 tau_p5 tau_p6 tau_p7 tau_p8 tau_p9 tau_p10 tau_p11];

        l = length(Rs_t);
 
    else 
        % Load data

        u0 = 2.2197;
        % Sampling time
        Ts = t(2) - t(1);
        % Detrending data
        % Remove first 55 points to omit the initial voltage transient

        tt = [];
        Ib = [];

        SoC_ = DSoC(5:6855);
        ub_ = ub(5:6855);
        ib_ = ib(5:6855);

        for k = 1:length(SoC_)
            if ub_(k) >= u0
                continue
            else
                Ub = ub_(k:end);
                Ib = ib_(k:end);
                tt = 1:1:length(Ub);
                t_ = tt';
                break
            end
        end


        yy1 = detrend(Ub(1:677),1);
        uu1 = detrend(Ib(1:677),0);

        yy2 = detrend(Ub(678:1354),1);
        uu2 = detrend(Ib(678:1354),0);


        yy3 = detrend(Ub(1355:2031),1);
        uu3 = detrend(Ib(1355:2031),0);


        yy4 = detrend(Ub(2032:2708),1);
        uu4 = detrend(Ib(2032:2708),0);


        yy5 = detrend(Ub(2709:3385),1);
        uu5 = detrend(Ib(2709:3385),0);

        yy6 = detrend(Ub(3386:4062),1);
        uu6 = detrend(Ib(3386:4062),0);

        yy7 = detrend(Ub(4063:4739),1);
        uu7 = detrend(Ib(4063:4739),0);


        yy8 = detrend(Ub(4740:5416),1);
        uu8 = detrend(Ib(4740:5416),0);


        yy9 = detrend(Ub(5417:6093),1);
        uu9 = detrend(Ib(5417:6093),0);


        yy10 = detrend(Ub(6094:end),1);
        uu10 = detrend(Ib(6094:end),0);


        y = [yy1; yy2; yy3; yy4; yy5; yy6; yy7; yy8; yy9; yy10];
        u = [uu1; uu2; uu3; uu4; uu5; uu6; uu7; uu8; uu9; uu10];

        ylabel('y'),xlabel('t [s]')

        na = 1; nb = 2; nk = 0;

        %         na = 1; nb = 2; nc = 1; nk = 0;


        % 10 data sets for identification

        y1 = y(1:677); u1 = u(1:677); 
        y2 = y(678:1354); u2 = u(678:1354); 
        y3 = y(1355:2031); u3 = u(1355:2031);
        y4 = y(2032:2708); u4 = u(2032:2708);
        y5 = y(2709:3385); u5 = u(2709:3385);
        y6= y(3386:4062); u6 = u(3386:4062);
        y7 = y(4063:4739); u7 = u(4063:4739);
        y8 = y(4740:5416); u8 = u(4740:5416);
        y9 = y(5417:6093); u9 = u(5417:6093);
        y10 = y(6094:end); u10 = u(6094:end);
        
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

DQ1 = 6*[400 1045 1690 2335 2980 3625 4270 4915 5560 6205 6856]/3600;
DQ2 = 6*[677 1354 2031 2708 3385 4062 4739 5416 6093 6778]/3600+ DQ1(end);
DQ3 = 6*[ 449 898 1347 1796 2245 2694 3143 3592 4041 4494 5786]/3600 + DQ2(end);
        
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


