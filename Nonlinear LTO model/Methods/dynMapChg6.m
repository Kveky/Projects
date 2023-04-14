function[Rs, Rp, Tp, DQ] = dynMapChg6()

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
        t_n = t(11:660); %Creating a initial value 
        ub_n =ub(11:660);

        %Creating Uoc%
        [Uoc, p] = pwr2(t_n,ub_n);

        %Detrending the nonlinear part
        y = ub_n(1:530) - Uoc(1:530);
        u = detrend(ib(11:540),0);

        yyy = detrend(ub_n(531:end),1);
        uuu = detrend(ib(541:660),0);

        %Placing into one array
        ytot =[y; yyy];
        utot =[u; uuu];

        %Detrending linear part 
        u = detrend(ib(11:660),0);

        yy1 = detrend(ub(661:2075),1);
        uu1 = detrend(ib(661:2075),0);

        yy2 = detrend(ub(2076:end-24),1);
        uu2 = detrend(ib(2076:end-24),0);
        
        %placing into one array
        
        yy = [yy1; yy2];
        uu = [uu1; uu2];
        
        %ARX model setup
        
        na = 1; nb = 2; nk = 0;
        
        %ARMAX model setup 
        
%         na = 1; nb = 2; nc = 1; nk = 0;
        
        
        Ts = t(2)-t(1);
        %Nonlinear part
        
        y1 = ytot(1:130); u1 = utot(1:130);
        y2 = ytot(131:260); u2 = utot(131:260);
        y3 = ytot(261:390); u3 = utot(261:390);
        y4 = ytot(391:520); u4 = utot(391:520);
        y5 = ytot(521:650); u5 = utot(521:650);
        %Linear part
        y6 = yy(1:830); u6 = uu(1:830);
        y7 = yy(831:1660); u7 = uu(831:1660);
        y8 = yy(1661:2490); u8 = uu(1661:2490);
        y9 = yy(2491:3320); u9 = uu(2491:3320); 
        y10 = yy(3321:4150); u10 = uu(3321:4150);


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


        %temporary arrays
        
        Rs_t = [Rs1 Rs2 Rs3 Rs4 Rs5 Rs6 Rs7 Rs8 Rs9 Rs10];
        Rp_t = [Rp1 Rp2 Rp3 Rp4 Rp5 Rp6 Rp7 Rp8 Rp9 Rp10];
        Tp_t = [tau_p1 tau_p2 tau_p3 tau_p4 tau_p5 tau_p6 tau_p7 tau_p8 tau_p9 tau_p10];


        l = length(Rs_t);
        
    elseif filename == 'DATA_5.MAT'
        
        
        %Nonlinear part%
        t_n = t(11:end-20); %660 
        ub_n =ub(11:end-20);%660 

        tt = [];
        Ib = [];
        u0 = 2.4843;
        SoC_ = SoC(11:end-20);
        ib_ = ib(11:end-20);
        
        for k = 1:length(SoC_)
            if ub_n(k) <= u0
                continue
            else
                Ub = ub_n(k:end);
                Ib = ib_(k:end);
                tt = 1:1:length(Ub);
                t_ = tt';
                break
            end
        end
        ub_ = Ub(301:end);
        t__ = t_(301:end);

        ub_lin = Ub(1:300);
        t__lin = t_(1:300);
        Uoc=four2(t__,ub_);
        
        plot(t__,Uoc)
        hold on
        plot(t__,ub_)
        
        
        %Detrending linear part
        yyy = detrend(ub_lin,1);
        uuu = detrend(Ib(1:300),0);
        
        %Detrending Nonlinear part
        yy = ub_ - Uoc;
        uu = detrend(Ib(301:end),0);
        
        y = [yyy; yy];
        u = [uuu; uu];
        
        plot(t_,y)
        
        %ARX
        na = 1; nb = 2; nk = 0;
        
%         na = 1; nb = 2; nc = 1; nk = 0;
        
        %Sample time

        Ts = t(2)-t(1);
 
        
        y1 = y(1:190); u1 = u(1:190);
        y2 = y(191:300); u2 = u(191:300);
        y3 = y(301:570); u3 = u(301:570);
        
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

        Rs_t =  [Rs1 Rs2 Rs3];
        Rp_t = [Rp1 Rp2 Rp3];
        Tp_t = [tau_p1 tau_p2 tau_p3];
        
        l = length(Rs_t);
 
    else 
        % Load data

        if i == 2
            u0 = 2.1684;
        elseif i == 3
            u0 = 2.2164;
        else
            u0 = 2.2287;
        end
       
        % Sampling time
        Ts = t(2) - t(1);
        % Detrending data
        % Remove first 55 points to omit the initial voltage transient

        Ub_ = [];
        tt = [];
        Ib = [];

        SoC_ = SoC(11:end);
        ub_ = ub(11:end);
        ib_ = ib(11:end);

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


        yy1 = detrend(Ub(1:480),1);
        uu1 = detrend(Ib(1:480),0);


        yy2 = detrend(Ub(481:960),1);
        uu2 = detrend(Ib(481:960),0);


        yy3 = detrend(Ub(961:1440),1);
        uu3 = detrend(Ib(961:1440),0);


        yy4 = detrend(Ub(1441:1920),1);
        uu4 = detrend(Ib(1441:1920),0);

        yy5 = detrend(Ub(1921:2400),1);
        uu5 = detrend(Ib(1921:2400),0);


        yy6 = detrend(Ub(2401:2880),1);
        uu6 = detrend(Ib(2401:2880),0);


        yy7 = detrend(Ub(2881:3360),1);
        uu7 = detrend(Ib(2881:3360),0);


        yy8 = detrend(Ub(3361:3840),1);
        uu8 = detrend(Ib(3361:3840),0);

        yy9 = detrend(Ub(3841:4320),1);
        uu9 = detrend(Ib(3841:4320),0);


        yy10 = detrend(Ub(4321:end-24),1);
        uu10 = detrend(Ib(4321:end-24),0);

        y = [yy1; yy2; yy3; yy4; yy5; yy6; yy7; yy8; yy9; yy10];
        u = [uu1; uu2; uu3; uu4; uu5; uu6; uu7; uu8; uu9; uu10];

        ylabel('y'),xlabel('t [s]')

        na = 1; nb = 2; nk = 0;
        
%         na = 1; nb = 2; nc = 1; nk = 0;


        % 10 data sets for identification
        
        y1 = y(1:480); u1 = u(1:480); 
        y2 = y(481:960); u2 = u(481:960); 
        y3 = y(961:1440); u3 = u(961:1440);
        y4 = y(1441:1920); u4 = u(1441:1920);
        y5 = y(1921:2400); u5 = u(1921:2400);
        y6= y(2401:2880); u6 = u(2401:2880);
        y7 = y(2881:3360); u7 = u(2881:3360);
        y8 = y(3361:3840); u8 = u(3361:3840);
        y9 = y(3841:4320); u9 = u(3841:4320);
        y10 = y(4321:end); u10 = u(4321:end);

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

DQ1 = linspace(250,19000,4*10);
DQ2 = [250 500 570]+DQ1(end);
DQ = zeros(1,length(DQ1)+length(DQ2));
DQ_(1:40) = DQ1;
DQ_(41:43) = DQ2;
DQ = 6*DQ_/3600;

figure(3),
subplot(311),plot(DQ,1000*Rs,'b*:','LineWidth',1.25,'MarkerSize',6),grid on
ylabel('R_s [m\Omega]')
subplot(312),plot(DQ,1000*Rp,'b*:','LineWidth',1.25,'MarkerSize',6),grid on
ylabel('R_p [m\Omega]')
subplot(313),plot(DQ,Tp,'b*:','LineWidth',1.25,'MarkerSize',6),grid on
ylabel('T_p [s]'),xlabel('\DeltaQ [Ah]')




end


