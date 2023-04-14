%Diplomski rad, Karlo Kvaternik

%Test Code%
%Searching all MAT files and adding into one array%
%---------%

d = dir('*.MAT'); %Finding all .MAT files 
num_mat = length(d); % Checking the size of all MAT files
calc_val = 3;

%initialization of variables
Rs = zeros(1,calc_val*num_mat)
Rp = [];
Tp = [];
j = 1;

for i=1:num_mat;
    load(['DATA_' num2str(i) '.MAT']) %loading in the chronical order .MAT files
    Rsl1 = 1+2;
    Rsl2 = 2+3;
    Rsl3 = 3+4;
    Rsl = [ Rsl1 Rsl2 Rsl3 ];
    l = length(Rsl);
    
    if i == 1;
        
        Rs(j:l) = Rsl;
    else
        
        Rs(j:j+2) = Rsl;
    end
    
    j = j + l;
end

%Test Code%
%Getting the values from pwr2 model%
%---------%

[a, b] = pwr2(t_m,ub_m);
p = coeffvalues(a)
f = p(1).*t_m.^p(2)+p(3);
plot(t_m,f)

%Test Code%
%Adding values that matches the condition%
%---------%
clear Uoc_
dxi = [0 0.02941 0.05882 0.08824 0.11765 0.14706 0.17647 0.20588 0.29412 0.38235 0.47059 0.55882 0.64706 0.73529 0.76470 0.79412 0.82353 0.85294 0.88235 0.91177 0.94118 0.97059 1];
dUoc = [1.75322 2.06987 2.09326 2.10405 2.11610 2.12451 2.13360 2.13860 2.16270 2.18163 2.19778 2.22238 2.24607 2.29094 2.30815 2.32132 2.34510 2.36715 2.39125 2.41715 2.44550 2.48900 2.68371];

Uoc_ = [];
t = [];

SoC_ = SoC(10:end);
ub_ = ub(10:end);
for i = 1:length(SoC_)
    if ub_(i) <= dUoc(3)
        Uoc_(i) = ub_(i);
        t(i) = i;
    else
        break
    end
end

plot(t,Uoc_)
dUoc_dt = gradient(Uoc_)./gradient(t);
plot 

%Test Code%
%Creating nonlinear approx of first set measured data%
%---------%

%Nonlinear part%
t_n = t(11:660); %Creating a initial value 
ub_n =ub(11:660);

%Creating Uoc%
[Uoc, p] = pwr2(t_n,ub_n);


%Test Code%
%Calculating total capacity of true battery 
%---------%
Q6dis=zeros(size(t6dis));
Q12dis=zeros(size(t12Dis));
Q18dis=zeros(size(t(4:end)));
Q24dis=zeros(size(t24Dis));

for n=2:length(t6dis)
    Q6dis(n)=Q6dis(n-1)+abs(ib6dis(n)*((t6dis(n)-t6dis(n-1))/(3600)));
end
for n=2:length(t12Dis)
    Q12dis(n)=Q12dis(n-1)+abs(ib12Dis(n)*((t12Dis(n)-t12Dis(n-1))/(3600)));
end
for n=2:length(t(4:end))
    Q18dis(n)=Q18dis(n-1)+abs(ib(n)*((t(n)-t(n-1))/(3600)));
end
for n=2:length(t24Dis)
    Q24dis(n)=Q24dis(n-1)+abs(ib24Dis(n)*((t24Dis(n)-t24Dis(n-1))/(3600)));
end

%Charge
Q6chg=zeros(size(t6chg));
Q12chg=zeros(size(t12chg));
Q18chg=zeros(size(t18chg));
Q24chg=zeros(size(t24));

for n=2:length(t6chg)
    Q6chg(n)=Q6chg(n-1)+abs(ib6chg(n)*((t6chg(n)-t6chg(n-1))/(3600)));
end
for n=2:length(t12chg)
    Q12chg(n)=Q12chg(n-1)+abs(ib12chg(n)*((t12chg(n)-t12chg(n-1))/(3600)));
end
for n=2:length(t18chg)
    Q18chg(n)=Q18chg(n-1)+abs(ib18chg(n)*((t18chg(n)-t18chg(n-1))/(3600)));
end
for n=2:length(t24)
    Q24chg(n)=Q24chg(n-1)+abs(ib24(n)*((t24(n)-t24(n-1))/(3600)));
end

%Test Code%
%Adding into one array
%---------%
ib1 = ib
ub1 = ub
SoC1 = SoC
t1 = t
ub1(end)

ib2 = ib
ub2 = ub
SoC2 = SoC
t2 = t

ib3 = ib
ub3 = ub
SoC3 = SoC
t3 = t



for k = 1:length(t2)
    if ub2(k) >=ub1(end)
        continue
    else
        ub2_ = ub2(k:end);
        ib2_ = ib2(k:end);
        t2_ = (0:1:length(Ub)-1)';
        SoC2 = SoC2(k:end)
        break
    end
end

ub6Dis = [ub1; ub2; ub3]
ib6Dis = [ib1; ib2; ib3]
t6Dis = [t1; t1(end)+t2+1; t3+t2(end)+t1(end)+2]
SoC6Dis = [SoC1; SoC2 - (1-SoC1(end)) ]
plot(t12Dis, SoC12Dis)

SoC3 = SoC2 - (1-SoC1(end))
delta = SoC3(end)
SoCR = SoC3 - delta

for k = 1:length(t1)
    if SoC1(k) <= SoCR(1)
        j = k
        break
    else
        continue
    end
end
