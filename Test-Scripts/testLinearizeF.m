clear; close all;

%% Test Case 1: Simple scalar linear system, no inputs.
f1 = @(x,p,u) x.^3;
doCellOps = 0;
x0 = 6;
u0 = 0;
[A1,B1] = LINEARIZEF(f1,x0,[],u0,0.001,0.001,doCellOps);
testX1 = linspace(0,10,100);
testF1 = f1(testX1);
testF1Jacobian = A1*testX1 + B1*[1; u0];
plot(testX1,testF1,'r','linewidth',1.5); hold on;
plot(testX1,testF1Jacobian,'b--','linewidth',1.5);
plot(x0,f1(x0), 'ko-');
hold off;
ylabel('f(x)');
xlabel('x');
legend('f_1','First-order Taylor series','location','se');
title('Test Case 1: f_1(x) = x^3, x_0 = 6');
set(gcf,'position',[286   678   379   300]);

%% Test Case 2: Simple scalar linear system, no inputs.
f2 = @(x,p,u) cos(x);
doCellOps = 0;
x0 = pi/2;
u0 = 0;
[A2,B2] = LINEARIZEF(f2,x0,[],u0,0.001,0.001,doCellOps);
testX2 = linspace(0,5,100);
testF2 = f2(testX2);
testF2Jacobian = A2*testX2 + B2*[1; u0];
plot(testX2,testF2,'r','linewidth',1.5); hold on;
plot(testX2,testF2Jacobian,'b--','linewidth',1.5);
plot(x0,f2(x0), 'ko-');
hold off;
ylabel('f(x)');
xlabel('x');
legend('f_2','First-order Taylor series','location','sw');
title('Test Case 2: f_{2}(x) = cos(x), x_0 = \pi/2');
set(gcf,'position',[286   678   379   300]);

%% Test Case 3 Simple scalar linear system, no inputs.
f3 = @(x,p,u) exp(x);
doCellOps = 0;
x0 = 0.5;
[A3,B3] = LINEARIZEF(f3,x0,[],0,0.001,0.001,doCellOps);
testX3 = linspace(0,1,100);
testF3 = f3(testX3);
testF3Jacobian = A3*testX3 + B3*[1; 0];
plot(testX3,testF3,'r','linewidth',1.5); hold on;
plot(testX3,testF3Jacobian,'b--','linewidth',1.5);
plot(x0,f3(x0), 'ko-');
hold off;
ylabel('f(x)');
xlabel('x');
legend('f_3','First-order Taylor series','location','nw');
title('Test Case 3: f_{3}(x) = e^x, x_0 = 0.5');
set(gcf,'position',[286   678   379   300]);

%% Test Case 4 Simple heat conducting bar
f4 = 'eval_f_LinearSystem';
u4 = 'eval_u_step';
N = 1000; % # of nodes
doCellOps = 0;
[p,x0,t_start,t_stop,max_dt_FE] = getParam_HeatBarExample(N);
u0 = zeros(N,1); % Only considering t = 0

% Linearize
[A4,B4] = LINEARIZEF(f4,x0,p,u0,1,1,doCellOps);

% Simulate 100 different state vectors
testX4 = rand(N,1000);
testU4 = u0;
testF4 = feval(f4,testX4,p,testU4);    % Analytic solution
testF4Jacobian = A4*testX4 + B4*[1; testU4]; % First order Jacobian solt'n

%% Plots for test 4
close all;
figure;
imagesc(A4);
title('A');
colorbar;
set(gcf,'position',[286   678   379   300]);

figure;
plot(B4(:,1))
title('K0');
xlabel('Node');
set(gcf,'position',[286   678   379   300]);

figure;
imagesc(B4(:,2:end));
title('B');
colorbar;
set(gcf,'position',[286   678   379   300]);

figure;
imagesc(testX4);
title('Random States');
xlabel('n');
ylabel('Node');
colorbar;
set(gcf,'position',[286   678   379   300]);

figure;
imagesc(testF4);
title('Exact Solution');
colorbar;
xlabel('Input Vector');
ylabel('Node');
set(gcf,'position',[286   678   379   300]);

figure;
imagesc(testF4Jacobian);
title('Jacobian Approximation')
colorbar;
xlabel('Input Vector');
ylabel('Node');
set(gcf,'position',[286   678   379   300]);

figure;
imagesc(abs(testF4Jacobian - testF4));
title('Difference')
colorbar;
xlabel('Input Vector');
ylabel('Node');
set(gcf,'position',[286   678   379   300]);
%% Test Case 5: SEIR Model w/ 100 nodes
P = 100;    % # nodes simulated
f5 = 'EVALF';
theta = GenThetaMat(P,'symmetric');
x0 = GenStateVec(P, 'sameIC');
p = GenPStruct(P, theta);
u0 = GenInputVec(P, 0); % Linearization operating point, t=0

epsX = 0.1;   % Steps
epsU = 0.1;

doCellOps = true;
[A5,B5] = LINEARIZEF(f5,x0,p,u0,epsX,epsU,doCellOps);

testX5 = GenStateVec(P, 'sameIC');
testU5 = u0;
testF5 = cell2vec(feval(f5,testX5,p,testU5),1);    % Analytic solution
testX5Vec = cell2vec(testX5,1);
testU5Vec = cell2vec(testU5,1);
testF5Jacobian = A5*testX5Vec + B5*[1; testU5Vec]; % First order Jacobian solt'n

%% Plots for test case 5
close all;
figure;
plot(testF5);
title('Exact');
set(gcf,'position',[286   678   379   300]);
figure;
plot(testF5Jacobian);
title('Jacobian');
set(gcf,'position',[286   678   379   300]);

%% Test Case 6: Forward Euler, 2 Nodes with Same Input Vec
close all;
P = 12;
t_start = 0;
t_stop = 20;
epsX = 0.1;   % Steps
epsU = 0.1;
timestep = 0.01;
doCellOps = 1;
eval_u = 'GenInputVec';
eval_f = 'EVALF';
lin_f = 'EVALFLIN';
theta = GenThetaMat(P,'random');
x_start = GenStateVec(P, 'random');
u0 = GenInputVec(P, 0); % Linearization operating point, t=0
p1 = GenPStruct(P, theta);

[p2.A, p2.B] = LINEARIZEF(eval_f,x_start,p1,u0,epsX,epsU,doCellOps); % A5, B5 from above

% test FE function
[X] = ForwardEuler(P, eval_f, x_start, p1, eval_u, t_start, t_stop, timestep);
[XLin] = ForwardEuler(P, lin_f, x_start, p2, eval_u, t_start, t_stop, timestep);

Ntotal = zeros(size(X,1),size(X,2));
NtotalLin = zeros(size(XLin,1),size(XLin,2));

% Plot SEIR curves for all nodes
xlims = [0 20];
ylims = [0 10000];
for i = 1:size(X,1)
    S = X(i,:);
    s = [S{1:end}];
    Ntotal(i,:) = sum(s, 1);
    
    SLin = XLin(i,:);
    sLin = [SLin{1:end}];
    NtotalLin(i,:) = sum(sLin, 1);
    
    figure;
    hold on;
    days = linspace(t_start,t_stop,length(s(1,1:end)));
    plot(days, s(1,1:end), 'LineWidth', 1.5);
    plot(days, s(2,1:end), 'LineWidth', 1.5);
    plot(days, s(3,1:end), 'LineWidth', 1.5);
    plot(days, s(4,1:end), 'LineWidth', 1.5);
    xlabel('t [days]');
    ylabel('# Individuals');
    hold off;
    legend('S(t)','E(t)','I(t)','R(t)');
    title(['Exact' ' Node ', num2str(i)])
    xlim(xlims);
    ylim(ylims);
    set(gcf,'position',[286   678   379   300]);
    
    figure;
    hold on;
    plot(days, sLin(1,1:end), 'LineWidth', 1.5);
    plot(days, sLin(2,1:end), 'LineWidth', 1.5);
    plot(days, sLin(3,1:end), 'LineWidth', 1.5);
    plot(days, sLin(4,1:end), 'LineWidth', 1.5);
    xlabel('t [days]');
    ylabel('# Individuals');
    hold off;
    legend('S(t)','E(t)','I(t)','R(t)');
    title(['Linearized ' 'Node ', num2str(i)])
    xlim(xlims);
    ylim(ylims);
    set(gcf,'position',[286   678   379   300]);
    
end
%% Test Case 7: Forward Euler, 10 Nodes with Same Input Vec
close all;
P = 2;
doPlots = 1;
rng(1);
eval_f = 'EVALF';
x_start = GenStateVec(P,'sameIC');
theta = GenThetaMat(P,'random');
p1 = GenPStruct(P, theta);
u0 = GenInputVec(P, 0); % Linearization operating point, t=0
epsX = 0.01;   % Steps
epsU = 0.01;
doCellOps = 1;

% Linearize
[p2.A, p2.B] = LINEARIZEF(eval_f,x_start,p1,u0,epsX,epsU,doCellOps);

% Forward Euler
eval_u = 'GenInputVec';
lin_f = 'EVALFLIN';
timestep = 0.01;
t_start = 0;
t_stop = 30;
[X] = ForwardEuler(P, eval_f, x_start, p1, eval_u, t_start, t_stop, timestep);
[XLin] = ForwardEuler(P, lin_f, x_start, p2, eval_u, t_start, t_stop, timestep);

% Plot SEIR curves for all nodes
Ntotal = zeros(size(X,1),size(X,2));
NtotalLin = zeros(size(XLin,1),size(XLin,2));
xlims = [0 3];
ylims = [0 1000];
if doPlots == 1
    for i = 1:size(X,1)
        S = X(i,:);
        s = [S{1:end}];
        Ntotal(i,:) = sum(s, 1);
        
        SLin = XLin(i,:);
        sLin = [SLin{1:end}];
        NtotalLin(i,:) = sum(sLin, 1);
        
        subplot(size(X,1),2,(i-1)*2+1)
        hold on;
        days = linspace(t_start,t_stop,length(s(1,1:end)));
        plot(days, s(1,1:end), 'LineWidth', 1.5);
        plot(days, s(2,1:end), 'LineWidth', 1.5);
        plot(days, s(3,1:end), 'LineWidth', 1.5);
        plot(days, s(4,1:end), 'LineWidth', 1.5);
        xlabel('t [days]');
        ylabel('# Individuals');
        hold off;
        if i == 1
            legend('S(t)','E(t)','I(t)','R(t)');
        end
        title(['Exact' ' Node ', num2str(i)])
        xlim(xlims);
%         ylim(ylims);
        set(gcf,'position',[286   231   649   747]);
        
        subplot(size(X,1),2,(i-1)*2+2)
        hold on;
        plot(days, sLin(1,1:end), 'LineWidth', 1.5);
        plot(days, sLin(2,1:end), 'LineWidth', 1.5);
        plot(days, sLin(3,1:end), 'LineWidth', 1.5);
        plot(days, sLin(4,1:end), 'LineWidth', 1.5);
        xlabel('t [days]');
        ylabel('# Individuals');
        hold off;
        if i == 1
            legend('S(t)','E(t)','I(t)','R(t)');
        end
        title(['Linearized ' 'Node ', num2str(i)])
        xlim(xlims);
%         ylim(ylims);
        set(gcf,'position',[286   231   649   747]);
    end
end
condest(p2.A)

%% Plots for test case 7
deflines = lines(4);
close all;
figure;
imagesc((p2.A));
title('A');
c = colorbar;
c.Label.String = 'dB';
set(gcf,'position',[286   678   379   300]);

figure;
plot(p2.B(:,1))
title('K0');
xlabel('Node');
set(gcf,'position',[286   678   379   300]);

figure;
imagesc(mag2db(p2.B(:,2:end)));
title('B');
c = colorbar;
c.Label.String = 'dB';
set(gcf,'position',[286   678   379   300]);

figure;
startVec = cell2vec(x_start,1);
plot(startVec(1:4:end),'color',deflines(1,:),'linewidth',1.5)
title('Initial S for all Nodes');
xlabel('Node #');
ylabel('# Individuals')
axis tight;
set(gcf,'position',[286   678   379   300]);
% ylim([0 100]);

figure;
plot(startVec(2:4:end),'color',deflines(2,:),'linewidth',1.5)
title('Initial E for all Nodes');
xlabel('Node #');
ylabel('# Individuals')
axis tight;
set(gcf,'position',[286   678   379   300]);
% ylim([0 100]);

figure;
plot(startVec(3:4:end),'color',deflines(3,:),'linewidth',1.5)
title('Initial I for all Nodes');
xlabel('Node #');
ylabel('# Individuals')
axis tight;
set(gcf,'position',[286   678   379   300]);
% ylim([0 100]);

figure;
plot(startVec(4:4:end),'color',deflines(4,:),'linewidth',1.5)
title('Initial R for all Nodes');
xlabel('Node #');
ylabel('# Individuals')
axis tight;
set(gcf,'position',[286   678   379   300]);
% ylim([0 100]);
%% Testing LU solver with preconditioner matrix
sf = 100000000;
diagel = sf*diag(p2.A);
conditioned = p2.A;
conditioned(1:size(p2.A)+1:end) = diagel; % Scale diagonal elements
condest(conditioned)
BVec = cell2vec(u0,1);
% BVec = zeros(4*P,1);
xSolve = conditioned \ (-p2.B*[1;BVec]);
xSolve*sf

%% Try iterative solver
xSolve2 = sf*tgcr(conditioned, -p2.B*[1;BVec], 1e-3, 1e3)
xSolve3 = sf*gmres(conditioned, -p2.B*[1;BVec])