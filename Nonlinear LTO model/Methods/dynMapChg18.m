function[Rs, Rp, Tp, DQ] = dynMapChg18()

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
        t_n = t(6:190); %Creating a initial value 
        ub_n =ub(6:190);

        %Linear part till ending
        ub_r = ub(191:3315);
        ib_r = ib(191:3315);

        %Creating Uoc%
        [Uoc, p] = pwr2(t_n,ub_n);

        % Sampling time
        Ts = t(2) - t(1);

        %Detrending the nonlinear part
        yy1 = ub_n - Uoc;
        uu1 = detrend(ib(6:190),0);

        yy2 = detrend(ub_r(1:312),1);
        uu2 = detrend(ib_r(1:312),0);

        yy3 = detrend(ub_r(313:624),1);
        uu3 = detrend(ib_r(313:624),0);

        yy4 = detrend(ub_r(625:936),1);
        uu4 = detrend(ib_r(625:936),0);

        yy5 = detrend(ub_r(937:1248),1);
        uu5 = detrend(ib_r(937:1248),0);

        yy6 = detrend(ub_r(1249:1560),1);
        uu6 = detrend(ib_r(1249:1560),0);

        yy7 = detrend(ub_r(1561:1872),1);
        uu7 = detrend(ib_r(1561:1872),0);

        yy8 = detrend(ub_r(1873:2184),1);
        uu8 = detrend(ib_r(1873:2184),0);

        yy9 = detrend(ub_r(2185:2496),1);
        uu9 = detrend(ib_r(2185:2496),0);

        yy10 = detrend(ub_r(2497:2808),1);
        uu10 = detrend(ib_r(2497:2808),0);

        yy11 = detrend(ub_r(2809:end),1);
        uu11 = detrend(ib_r(2809:end),0);


        y =[yy1; yy2; yy3; yy4; yy5; yy6; yy7; yy8; yy9; yy10; yy11];
        u =[uu1; uu2; uu3; uu4; uu5; uu6; uu7; uu8; uu9; uu10; uu11]; 
        t_ = t(6:3315);





        %Placing into one array
        % Detrending data
        % Remove first 55 points to omit the initial voltage transient

        na = 1; nb = 2; nk = 0;

        % Five data sets for identification
        y1 = y(1:185); u1 = u(1:185); 
        y2 = y(186:497); u2 = u(186:497); 
        y3 = y(498:809); u3 = u(498:809);
        y4 = y(810:1121); u4 = u(810:1121);
        y5 = y(1122:1433); u5 = u(1122:1433);
        y6= y(1434:1745); u6 = u(1434:1745);
        y7 = y(1746:2057); u7 = u(1746:2057);
        y8 = y(2058:2369); u8 = u(2058:2369);
        y9 = y(2370:2681); u9 = u(2370:2681);
        y10 = y(2682:2993); u10 = u(2682:2993);
        y11 = y(2994:end); u11 = u(2994:end);


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
        
      
        
        %ARMAX model setup 
        
%         na = 1; nb = 2; nc = 1; nk = 0;
        


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
        
        Rs_t = [Rs1 Rs2 Rs3 Rs4 Rs5 Rs6 Rs7 Rs8 Rs9 Rs10 Rs11 ];
        Rp_t = [Rp1 Rp2 Rp3 Rp4 Rp5 Rp6 Rp7 Rp8 Rp9 Rp10 Rp11 ];
        Tp_t = [tau_p1 tau_p2 tau_p3 tau_p4 tau_p5 tau_p6 tau_p7 tau_p8 tau_p9 tau_p10 tau_p11];


        l = length(Rs_t);
        
    else 
     
        Ts = t(2) - t(1);

        %Nonlinear part%
        t_n = t(3050:3260); %3280
        ub_n =ub(3050:3260); %3292
        ib_n = ib(3050:3260);
        ub_l = ub(10:3049);
        t_l = t(10:3049);
        tt = [];
        Ib = [];
        u0 = 2.2477;
        SoC_ = SoC(10:3049);
        ib_ = ib(10:3049);

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

        Uoc = four2(t_n, ub_n);

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

        %         na = 1; nb = 2; nc = 1; nk = 0;


        % 10 data sets for identification

        y1 = y(1:284); u1 = u(1:284); 
        y2 = y(285:568); u2 = u(285:568); 
        y3 = y(569:852); u3 = u(569:852);
        y4 = y(853:1136); u4 = u(853:1136);
        y5 = y(1137:1420); u5 = u(1137:1420);
        y6 = y(1421:1704); u6 = u(1421:1704);
        y7 = y(1705:1988); u7 = u(1705:1988);
        y8 = y(1989:2272); u8 = u(1989:2272);
        y9 = y(2273:2556); u9 = u(2273:2556);
        y10 = y(2557:2843); u10 = u(2557:2843);
        y11 = y(2844:end); u11 = u(2844:end);


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


%         na = 1; nb = 2; nc = 1; nk = 0;
        
        %Sample time

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
         
    end
        
    %Inserting into true arrays
    if i == 1
        
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

DQ1 = 18*[185 497 809 1121 1433 1745 2057 2369 2681 2993 3310]/3600;
DQ2 = 18*[284 568 852 1136 1420 1704 1988 2272 2556 2843 3160]/3600+DQ1(end);
DQ = [];
DQ = [DQ1 DQ2];

% figure(3),
% subplot(311),plot(DQ,1000*Rs,'b*:','LineWidth',1.25,'MarkerSize',6),grid on
% ylabel('R_s [m\Omega]')
% subplot(312),plot(DQ,1000*Rp,'b*:','LineWidth',1.25,'MarkerSize',6),grid on
% ylabel('R_p [m\Omega]')
% subplot(313),plot(DQ,Tp,'b*:','LineWidth',1.25,'MarkerSize',6),grid on
% ylabel('T_p [s]'),xlabel('\DeltaQ [Ah]')
% 



end


