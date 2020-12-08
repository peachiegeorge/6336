% Setup
addpath(genpath('C:\Users\Jason\Documents\Git\6336InfectiousDisease'))
cases = {'noTravel','noMeasures','cutOffMultiple'};
stateInitType = {'singleInfectedAll', 'MIToutbreak'};

% Time span to simulate
dt = 0.05;
% tspan = [0 100];    % days
tspan = 0:dt:100;
% Define parameters to match Sim1
x0 = GenStateVec(1, stateInitType{1}); % Initial State
theta = GenThetaMat(1, cases{1}, 0); % No Measures
u = GenInputVec(1, 1);
p = GenPStruct(1, theta, cases{1}); % Generate parameter matrix

% Define ODE
dfdt = @(t,x) cell2vec(EVALF(convertSeirMatToCell(x),p,u),1);

% ODE solve
opts = odeset('RelTol',1e-2,'AbsTol',1e-2,'MaxStep',0.5);
[t y] = ode45(dfdt,tspan,cell2vec(x0,1),opts);
y = y';

%% Plot
f2 = figure(2);
animateSEIR(f2,y,100,'Sim1 (ode45)',dt);
% ax = gca;
% set(ax,'LineWidth',1.5);
% ax.YAxis.FontSize = 18;
% ax.XAxis.FontSize = 18;
% ax.Title.FontSize = 18;
% title('Simulation 1: Single Neighborhood (ode45)');
formatFig(f2);
