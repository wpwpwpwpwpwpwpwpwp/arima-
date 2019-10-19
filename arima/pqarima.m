clc;
clear;
filename='UNRATE.csv';
data=xlsread(filename);
TrainData=data(1:861-24);
TestData=data(861-24:861);
figure(1);
r=TrainData;
t=length(r);
plot(r);
xlim([0,t])
title('Changes in the unemployment rate')
s = 12; 
x = TrainData;
n = 24; 
m1 = length(x); 
for i = s+1:m1;
    y(i-s) = x(i) - x(i-s);
end
w = diff(y); 
k=0;
m2 = length(2);
for i = 0:6
    for j = 0:6
        if i == 0 & j == 0
            continue
        elseif i == 0
            ToEstMd = arima('MALags',1:j,'Constant',0); 
        elseif j == 0
            ToEstMd = arima('ARLags',1:i,'Constant',0); 
        else
            ToEstMd = arima('ARLags',1:i,'MALags',1:j,'Constant',0); 
        end
        k = k + 1;
        R(k) = i;
        M(k) = j;
        [EstMd,EstParamCov,LogL,info] = estimate(ToEstMd,w');
        numParams = sum(any(EstParamCov));
        [aic(k),bic(k)] = aicbic(LogL,numParams,m2);
    end
end
fprintf('R,M,AIC,BIC\n%f');
check  = [R',M',aic',bic']
