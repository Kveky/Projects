function[Rs, Rp, Tp, DQ] = dynMapDis12()

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
        t_n = t(2:119); %Creating a initial value 
        ub_n =ub(2:119);

        %Linear part till ending
        ub_r = ub(120:end);
        ib_r = ib(120:end);

        %Creating Uoc%
        Uoc= fourDis2(t_n,ub_n);
       
        % Sampling time
        Ts = t(2) - t(1);

        %Detrending the nonlinear part
        yy1 = ub_n - Uoc;
        uu1 = detrend(ib(2:119),0);

        yy2 = detrend(ub_r(1:197),1);
        uu2 = detrend(ib_r(1:197),0);
        
        yy3 = detrend(ub_r(198:395),1);
        uu3 = detrend(ib_r(198:395),0);

        yy4 = detrend(ub_r(396:593),1);
        uu4 = detrend(ib_r(396:593),0);

        yy5 = detrend(ub_r(594:790),1);
        uu5 = detrend(ib_r(594:790),0);
        
        yy6 = detrend(ub_r(791:1185),1);
        uu6 = detrend(ib_r(791:1185),0);

        yy7 = detrend(ub_r(1186:1580),1);
        uu7 = detrend(ib_r(1186:1580),0);

        yy8 = detrend(ub_r(1581:1975),1);
        uu8 = detrend(ib_r(1581:1975),0);

        yy9 = detrend(ub_r(1976:2370),1);
        uu9 = detrend(ib_r(1976:2370),0);

        yy10 = detrend(ub_r(2371:2765),1);
        uu10 = detrend(ib_r(2371:2765),0);

        yy11 = detrend(ub_r(2766:3160),1);
        uu11 = detrend(ib_r(2766:3160),0);

        yy12 = detrend(ub_r(3161:3555),1);
        uu12 = detrend(ib_r(3161:3555),0);

        yy13 = detrend(ub_r(3556:end),1);
        uu13 = detrend(ib_r(3556:end),0);


        y =[yy1; yy2; yy3; yy4; yy5; yy6; yy7; yy8; yy9; yy10; yy11; yy12; yy13];
        u =[uu1; uu2; uu3; uu4; uu5; uu6; uu7; uu8; uu9; uu10; uu11; uu12; uu13]; 
        t_ = t(6:3315);

        



        %Placing into one array
        % Detrending data
        % Remove first 55 points to omit the initial voltage transient

        na = 1; nb = 2; nk = 0;

        % Five data sets for identification
        y1 = y(1:118); u1 = u(1:118); 
        y2 = y(119:316); u2 = u(119:316); 
        y3 = y(317:513); u3 = u(317:513); 
        y4 = y(514:710); u4 = u(514:710);
        y5 = y(711:908); u5 = u(711:908);
        y6 = y(909:1303); u6 = u(909:1303);
        y7 = y(1304:1698); u7 = u(1304:1698);
        y8= y(1699:2093); u8 = u(1699:2093);
        y9 = y(2094:2488); u9 = u(2094:2488);
        y10 = y(2489:2883); u10 = u(2489:2883);
        y11 = y(2884:3278); u11 = u(2884:3278);
        y12 = y(3279:3673); u12 = u(3279:3673);
        y13 = y(3674:end); u13 = u(3674:end);
        
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
        
        Rs_t = [Rs1 Rs2 Rs3 Rs4 Rs5 Rs6 Rs7 Rs8 Rs9 Rs10 Rs11 Rs12 Rs13  ];
        Rp_t = [Rp1 Rp2 Rp3 Rp4 Rp5 Rp6 Rp7 Rp8 Rp9 Rp10 Rp11 Rp12 Rp13  ];
        Tp_t = [tau_p1 tau_p2 tau_p3 tau_p4 tau_p5 tau_p6 tau_p7 tau_p8 tau_p9 tau_p10 tau_p11 tau_p12 tau_p13];

       
        l = length(Rs_t);
        
    else 
     
        Ts = t(2) - t(1);

        %Nonlinear part%
        t_n = t(4575:5574); %3280
        ub_n =ub(4575:5574); %3292
        ib_n = ib(4575:5574);
        ub_l = ub(2:4574);
        t_l = t(2:4574);
        tt = [];
        Ib = [];
        u0 = 2.1909;
        SoC_ = SoC(2:4574);
        ib_ = ib(2:4574);

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

        Uoc = fourDis2(t_n, ub_n);

        %Detrending linear part
        yy1 = detrend(Ub(1:450),1);
        uu1 = detrend(Ib(1:450),0);

        yy2 = detrend(Ub(451:900),1);
        uu2 = detrend(Ib(451:900),0);


        yy3 = detrend(Ub(901:1350),1);
        uu3 = detrend(Ib(901:1350),0);

        yy4 = detrend(Ub(1351:1800),1);
        uu4 = detrend(Ib(1351:1800),0);


        yy5 = detrend(Ub(1801:2250),1);
        uu5 = detrend(Ib(1801:2250),0);


        yy6 = detrend(Ub(2251:2700),1);
        uu6 = detrend(Ib(2251:2700),0);

        yy7 = detrend(Ub(2701:3150),1);
        uu7 = detrend(Ib(2701:3150),0);

        yy8 = detrend(Ub(3151:3600),1);
        uu8 = detrend(Ib(3151:3600),0);


        yy9 = detrend(Ub(3601:4050),1);
        uu9 = detrend(Ib(3601:4050),0);


        yy10 = detrend(Ub(4051:end),1);
        uu10 = detrend(Ib(4051:end),0);


        yy11 = ub_n - Uoc;
        uu11 = detrend(ib_n,0);

        y = [yy1; yy2; yy3; yy4; yy5; yy6; yy7; yy8; yy9; yy10; yy11];
        u = [uu1; uu2; uu3; uu4; uu5; uu6; uu7; uu8; uu9; uu10; uu11];


        na = 1; nb = 2; nk = 0;

        %         na = 1; nb = 2; nc = 1; nk = 0;


        % 10 data sets for identification

        y1 = y(1:1000); u1 = u(1:1000); 
        y2 = y(1001:1450); u2 = u(1001:1450); 
        y3 = y(1451:1900); u3 = u(1451:1900);
        y4 = y(1901:2350); u4 = u(1901:2350);
        y5 = y(2351:2800); u5 = u(2351:2800);
        y6 = y(2801:3250); u6 = u(2801:3250);
        y7 = y(3251:3700); u7 = u(3251:3700);
        y8 = y(3701:4150); u8 = u(3701:4150);
        y9 = y(4151:4600); u9 = u(4151:4600);
        y10 = y(4601:5050); u10 = u(4601:5050);
        y11 = y(5051:end); u11 = u(5051:end);

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

DQ1 = 12*[118 316 513 710 908 1303 1698 2093 2488 2883 3278 3673 4069]/3600;
DQ2 = 12*[1000 1450 1900 2350 2800 3250 3700 4150 4600 5050 5500]/3600+DQ1(end);
DQ = [];
DQ = [DQ1 DQ2];

figure(3),
subplot(311),plot(DQ,1000*Rs,'b*:','LineWidth',1.25,'MarkerSize',6),grid on
ylabel('R_s [m\Omega]')
subplot(312),plot(DQ,1000*Rp,'b*:','LineWidth',1.25,'MarkerSize',6),grid on
ylabel('R_p [m\Omega]')
subplot(313),plot(DQ,Tp,'b*:','LineWidth',1.25,'MarkerSize',6),grid on
ylabel('T_p [s]'),xlabel('\DeltaQ [Ah]')




end


