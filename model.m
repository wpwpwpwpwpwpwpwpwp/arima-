clc;
clear;
filename='UNRATE.csv';
data=xlsread(filename);
trainData=data(1:850);
testData=data(851:861);
r=trainData;
t=length(r);
figure(1);
plot(r);
xlim([0,t])
title('Changes in the unemployment rate')
%%%%ADF test
[h,pvalue]=adftest(r);
figure(2);
subplot(2,1,1);
autocorr(r);
subplot(2,1,2);
parcorr(r);
%%%%AIC AR=8,MA=6
for p=1:8
    for q=1:6
        arma_test=armax(r,[p,q]);
        AIC(p,q)=aic(arma_test);
    end
end
[p,q]=find(AIC==min(min(AIC)));
%%%%made model
arma_model=armax(r,[p,q]);
model=arma_model;
A=round(model.A,4);
C=round(model.C,4);
%%%Diagnostic test
e=resid(arma_model,r);
figure(3);
plot(e);
title('the plot of resid');
ylabel('resid');
xlabel('time');
figure(4);
subplot(2,1,1);
autocorr(e.OutputData);
subplot(2,1,2);
parcorr(e.OutputData);
r1=r;
[Pval,dwr]=dwtest(e.OutputData,r1);
if round(dwr)==2 &Pval>=0.95
    disp(['Residual has no sequence correlation']);
else
    disp(['Residual has  sequence correlation']);
end
%%%%Draw a fit
m=armax(r,'na',8,'nc',8);
rp=predict(m,r,1);
figure(5);
plot(r,'-.')
hold on
plot(rp,'r')
grid
legend('Original Data','Forecasting Data ARMA(7,6)')
%%%%%Forecast daily rate of change over the next 61 days
p=forecast(m,r1,11);
r10=testData;
figure(6);
plot(p,'-.');
hold on;
plot(r10,'r')
legend('Original Data','Forecasting Data');

