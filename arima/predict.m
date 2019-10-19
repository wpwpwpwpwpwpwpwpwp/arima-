clc;
clear;
filename='UNRATE.csv';
data=xlsread(filename);
TrainData=data(1:861-24);
TestData=data(861-24:861);
x = TrainData;
s = 12; 
n = 24; 
m1 = length(x); 
for i = s+1:m1;
    y(i-s) = x(i) - x(i-s);
end
w = diff(y);
ToEstMd = arima('ARLags',1:5,'MALags',1:5,'Constant',0);
[EstMd,EstParamCov,LogL,info] = estimate(ToEstMd,w');
w_Forecast = forecast(EstMd,n,'Y0',w');
yhat = y(end) + cumsum(w_Forecast); 
for j = 1:n
    x(m1 + j) = yhat(j) + x(m1+j-s); 
end

x(m1+1:end)
figure(2);
plot(TestData,'-.')
hold on
plot(ans,'r')
grid
legend('Original Data','Forecasting Data ARMA(5,5)')

