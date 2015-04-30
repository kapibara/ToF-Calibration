%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Demo_2D_Gauss_Reg 
%% Made by Youngmok Yun 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;close all;clc;

%% Training data generation
x = 1:100; % training data x
y = sin(x/10)+(x/50).^2+0.2*randn(1,100);   % training data y

%% Set initial kernel bandwidth
h0=rand(1)*100; % kernel bandwidth

%% Optimize the bandwidth
h=Opt_Hyp_Gauss_Ker_Reg( h0,x,y );

%% Regression
xs= linspace(-10,110);
ys = gaussian_kern_reg(xs,x,y,h);

%% Plot result
figure;hold on; 
plot(x,y,'.');
plot(xs,ys,'r-');
legend('training data','regression','location','best')
title(['Gaussian kernel linear smoother h_{init} =' num2str(h0,3) ', h_{op} = ' num2str(h)]);

