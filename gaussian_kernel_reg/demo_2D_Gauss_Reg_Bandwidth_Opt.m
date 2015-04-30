%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Demo_2D_Gauss_Reg 
%% Made by Youngmok Yun 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;close all;clc;

%% Training data generation
x = rand(2,100)-0.5;
y = (x(1,:)-0.5).^2+x(2,:)+0.1*rand(1,100);

%% Set initial kernel bandwidth
h0=rand(size(x,1),1)*10; 

%% Optimize the bandwidth
h=Opt_Hyp_Gauss_Ker_Reg( h0,x,y );


%% Regression
[xx1 xx2] = meshgrid(-1:0.1:1,-1:0.1:1);

for i=1:size(xx1,1)
    for j=1:size(xx1,2)
        xs=[xx1(i,j);xx2(i,j)];
        ys(i,j)=gaussian_kern_reg(xs,x,y,h); % Prediction
    end
end

%% Result Plot
figure;hold on; 
plot3(x(1,:),x(2,:),y,'.')  % training dataset plot
mesh(xx1,xx2,ys)            % prediction point plot
legend('Training data','Predicted Surface')
grid ; view(3);


