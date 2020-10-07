clear; close all;

%% Test 1 Simple scalar linear system, no inputs.
f1 = @(x,p,u) x.^3;
doScalarInput = 1;
x0 = 6;
u0 = 0;
[A,B] = LINEARIZEF(f1,x0,[],u0,0.001,0.001,doScalarInput);
testX1 = linspace(0,10,100);
testF1 = f1(testX1);
testF1Jacobian = A1*testX1 + B1*[1; u0];
% testF1Jacobian = f1(x0) + A*(testX1 - x0);
plot(testX1,testF1,'r','linewidth',1.5); hold on;
plot(testX1,testF1Jacobian,'b--','linewidth',1.5);
plot(x0,f1(x0), 'ko-');
hold off;
ylabel('f(x)');
xlabel('x');
legend('f_1','First-order Taylor series','location','se');
title('Test Case 1: f_1(x) = x^3, x_0 = 6');
set(gcf,'position',[286   678   379   300]);

%% Test 2 Simple scalar linear system, no inputs.
f2 = @(x,p,u) cos(x);
doScalarInput = 1;
x0 = pi/2;
u0 = 0;
[A2,B2] = LINEARIZEF(f2,x0,[],u0,0.001,0.001,doScalarInput);
testX2 = linspace(0,5,100);
testF2 = f2(testX2);
testF2Jacobian = A2*testX2 + B2*[1; u0];
% testF2Jacobian = f2(x0) + A2*(testX2 - x0);
plot(testX2,testF2,'r','linewidth',1.5); hold on;
plot(testX2,testF2Jacobian,'b--','linewidth',1.5);
plot(x0,f2(x0), 'ko-');
hold off;
ylabel('f(x)');
xlabel('x');
legend('f_2','First-order Taylor series','location','sw');
title('Test Case 2: f_{2}(x) = cos(x), x_0 = \pi/2');
set(gcf,'position',[286   678   379   300]);

%% Test 3 Simple scalar linear system, no inputs.
f3 = @(x,p,u) exp(x);
doScalarInput = 1;
x0 = 0.5;
[A3,B3] = LINEARIZEF(f3,x0,[],0,0.001,0.001,doScalarInput);
testX3 = linspace(0,1,100);
testF3 = f3(testX3);
testF3Jacobian = A3*testX3 + B3*[1; 0];
% testF3Jacobian = f3(x0) + A3*(testX3 - x0);
plot(testX3,testF3,'r','linewidth',1.5); hold on;
plot(testX3,testF3Jacobian,'b--','linewidth',1.5);
plot(x0,f3(x0), 'ko-');
hold off;
ylabel('f(x)');
xlabel('x');
legend('f_3','First-order Taylor series','location','nw');
title('Test Case 3: f_{3}(x) = e^x, x_0 = 0.5');
set(gcf,'position',[286   678   379   300]);

%% Test 4 Simple heat conducting bar
f4 = 'eval_f_LinearSystem';
u4 = 'eval_u_step';
N = 1000; % # of nodes
doScalarInput = 1;
[p,x0,t_start,t_stop,max_dt_FE] = getParam_HeatBarExample(N);
u0 = zeros(N,1); % Only considering t = 0

% Linearize
[A4,B4] = LINEARIZEF(f4,x0,p,u0,1,1,doScalarInput);

% Simulate 100 different state vectors
testX4 = rand(N,1000);
testU4 = u0;
testF4 = feval(f4,testX4,p,testU4);    % Analytic solution
testF4Jacobian = A4*testX4 + B4*[1; testU4]; % First order Jacobian solt'n

%% Plots for test 4
close all;
figure;
imagesc(testX4);
title('Random Inputs');
xlabel('n');
ylabel('Node');
colorbar;

figure;
imagesc(testF4);
title('Exact Solution');
colorbar;
xlabel('Input Vector');
ylabel('Node');

figure;
imagesc(testF4Jacobian);
title('Jacobian Approximation')
colorbar;
xlabel('Input Vector');
ylabel('Node');

figure;
imagesc(abs(testF4Jacobian - testF4));
title('Difference')
colorbar;
xlabel('Input Vector');
ylabel('Node');

%% Test Case 5: SEIR Model w/ 100 nodes
P = 100;    % # nodes simulated
eval_f = 'EVALF';
theta = GenThetaMat(P,'symmetric');
x0 = GenStateVec(P, 'sameIC');
p = GenPStruct(P, theta);
u0 = GenInputVec(P, 0); % Linearization operating point, t=0
epsX = 1;   % Steps
epsU = 1;
[A0,B0] = LINEARIZEF(eval_f,x0,p,u0,epsX,epsU,0);
%
figure(1);
imagesc(A0);
title('Jf_X')
figure(2);
plot(B0(:,1));
title('K0');
xlabel('Node');
ylabel('K0');
figure(3);
imagesc(B0(:,2:end));
title('Jf_U');