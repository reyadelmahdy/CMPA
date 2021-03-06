% Reyad ElMahdy
% 101064879

close all
clear
clc

% Part 1

Is = 0.01e-12;
Ib = 0.1e-12;
Vb = 1.3;
Gp = 0.1;

V = linspace(-1.95,0.7,200);

I = Is*(exp(1.2*V/0.025) - 1) + Gp*V -Ib*(exp(-(1.2/0.025)*(V+Vb)) -1);

Ir = I + 0.2*I.*rand(1,200);

% Generating the plots
figure(1);
plot(V,I);
hold on;
grid on;
plot(V,Ir);
legend('No noise', '20% Noise');
xlabel('V');
ylabel('I');
title('No noise IV vs 20% noise IV (linear y axis)');

figure(2);
semilogy(V,abs(I));
hold on;
grid on;
semilogy(V,abs(Ir));
legend('No noise', '20% Noise');
xlabel('V');
ylabel('I');
title('No noise IV vs 20% noise IV (logarithmic y axis)');

% Part 2: Applying and plotting the polynomial solutions
poly4 = polyfit(V,Ir,4);
poly4 = polyval(poly4, V);
poly8 = polyfit(V,Ir,8);
poly8 = polyval(poly8, V);

figure(3);
plot(V,I);
hold on;
grid on;
plot(V,Ir);
plot(V,poly4);
plot(V,poly8);
legend('No noise', '20% Noise','4th order polyfit', '8th order polyfit');
xlabel('V');
ylabel('I');
title('No noise IV vs 20% noise IV with polynomial fits( linear y axis)');

poly4 = polyfit(V,Ir,4);
poly4 = polyval(poly4, V);
poly8 = polyfit(V,Ir,8);
poly8 = polyval(poly8, V);

figure(4);
semilogy(V,abs(I));
hold on;
grid on;
semilogy(V,abs(Ir));
semilogy(V,abs(poly4));
semilogy(V,abs(poly8));
legend('No noise', '20% Noise','4th order polyfit', '8th order polyfit');
xlabel('V');
ylabel('I');
title('No noise IV vs 20% noise IV with polynomial fits (logarithmic y axis)');

% Part 3: Nonlinear Curve Fitting

fo = fittype('A.*(exp(1.2*x/25e-3)-1) + 0.1*x - C.*(exp(1.2*(-(x+1.3))/25e-3)-1)');
ff = fit(V',Ir',fo);
fAC = ff(V);
fo = fittype('A.*(exp(1.2*x/25e-3)-1) + B.*x - C.*(exp(1.2*(-(x+1.3))/25e-3)-1)');
ff = fit(V',Ir',fo);
fABC = ff(V);
fo = fittype('A.*(exp(1.2*x/25e-3)-1) + B.*x - C.*(exp(1.2*(-(x+D))/25e-3)-1)');
ff = fit(V',Ir',fo);
fABCD = ff(V);

figure(5);
hold on;
grid on;
plot(V,I);
plot(V,Ir);
plot(V,fAC);
plot(V,fABC);
plot(V,fABCD);
legend('No noise','20% Noise','Explicit B and D','Explicit B','All Implicit');
title('No noise vs 20% Noise vs Nonlinear curve fit IV Plots (Linear y)');
xlabel('Voltage');
ylabel('Current')
hold off;

figure(6);
semilogy(V,abs(I));
hold on;
grid on;
semilogy(V,abs(Ir));
semilogy(V,abs(fAC));
semilogy(V,abs(fABC));
semilogy(V,abs(fABCD));
legend('No noise','20% Noise','Explicit B and D','Explicit B','All Implicit');
title('No noise vs 20% Noise vs Nonlinear curve fit IV Plots (Logarithmic y)');
xlabel('Voltage');
ylabel('Current')
hold off;

% Part 4: Neural Net Fitting
inputs = V.';
targets = I.';
hiddenLayerSize = 10;
net = fitnet(hiddenLayerSize);
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;
[net,tr] = train(net,inputs,targets);
outputs = net(inputs);
errors = gsubtract(outputs,targets);
performance = perform(net,targets,outputs);
view(net);
Inn = outputs;

figure(7);
plot(V,I);
hold on;
grid on;
plot(V,Ir);
plot(V,Inn);
legend('No noise','20% Noise','Neural Net');
title('No noise vs 20% Noise vs Neural Net IV graphs (Linear y)');
xlabel('Voltage');
ylabel('Current');
hold off;

figure(8);
semilogy(V,abs(I));
hold on;
grid on;
semilogy(V,abs(Ir));
semilogy(V,abs(Inn));
legend('No noise','20% Noise','Neural Net');
title('No noise vs 20% Noise vs Neural Net IV graphs (Logarithmic y)');
xlabel('Voltage');
ylabel('Current');
hold off;

