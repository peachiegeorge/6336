% Live Demo: Infectious disease spread in a neighborhood-level metapopulation model
% 6.336 Final Project
% Suleeporn Yui Sujichantararat, Georgia Thomas, Jason Zhang     GROUP ID: DISEASE

%% Setup
clc; close all; clear all;
addpath(genpath('C:\Users\Jason\Documents\Git\6336InfectiousDisease'))
cases = {'noTravel','noMeasures','cutOffMultiple','validationCase'};
stateInitType = {'singleInfectedAll', 'MIToutbreak','validationCase'};
dt = 0.05;
load('Live-Demo\Sim1.mat');
load('Live-Demo\Sim2.mat');
load('Live-Demo\Sim3.mat');
cambridge = readtable('Cambridge/cam.xlsx');
%% Simulation and save results
% [ySim1, xSim1, pSim1] = SimSEIR(1,  cases{4}, stateInitType{3}, dt, 200);  % Simulation 1: Simple SEIR model, single neighborhood
% [ySim2, xSim2, pSim2] = SimSEIR(13, cases{2}, stateInitType{2}, dt, 100);  % Simulation 2
% [ySim3, xSim3, pSim3] = SimSEIR(13, cases{3}, stateInitType{2}, dt, 100);  % Simulation 3  
% save('Sim1.mat','ySim1','xSim1','pSim1')
% save('Sim2.mat','ySim2','xSim2','pSim2');
% save('Sim3.mat','ySim3','xSim3','pSim3');

%% Plot the SEIR proportions (area) vs. time and the animated SEIR curves.
close all;
f1 = figure(1);
plotSEIRProp(f1,ySim1,xSim1,dt,'Simulation 1: Single Neighborhood, Proportions');
set(f1,'position',[1049 612 740 360]);

% Add plot for validation
f11 = figure(11);
imshow('Live-Demo\Comparison-Plot.jpg');
title('Reference: Y. Fang et al., J. Med. Virol. 92(6), 645–659 (2020)');
set(gcf,'position',[1049 83 741 440]);

f2 = figure(2);
animationSpeed = 1;
animateSEIR(f2,ySim1,animationSpeed,'Simulation 1: Single Neighborhood',dt);

%% Cambridge map
f10 = figure(10);
title('Cambridge Map');
imshow('Cambridge\Cambridge-Map.png');
set(gcf,'position',[133 105 1660 820]);

%% Simulation 2 & 3: SEIR metapopulation (multiple neighborhoods) model, 
% with and without measures 13 neighborhoods, single infected person in Neighborhood 2 (MIT)
% Simulation 2 is without measures; Simulation 3 is with measures
close all;
f3 = figure(3);
pos = [85 100 1725 863];    % Figure position
geovisSEIR(f3,xSim2,dt,pSim2,0.5,false,'Sim 2 (No Measures)',cambridge,pos);

%% Connections
close all;
f4 = figure(4);
geovisSEIR(f4,xSim2,dt,pSim2,1,true,'Sim 2 \theta_{ij} (No Measures)',cambridge,[10   128   945   801]);

% f5 = figure(5);
openfig('Live-Demo\Connections-Sim3');
% geovisSEIR(f5,xSim3,dt,pSim3,1,true,'Sim 3 \theta_{ij} (With Measures)',cambridge,[956   128   945   801]);

% 0.542798941798943,0.237203495630462,0.038153439153439,0.047440699126092

%% Geobubble 3
close all;
f6 = figure(6);
geovisSEIR(f6,xSim3,dt,pSim3,0.5,false,'Sim 3 (With Measures)',cambridge,pos);

%% Neighborhood breakdown
close all;
f7 = figure(7);
plotSEIRProp(f7,ySim2,xSim2,dt);
set(f7,'position',[17    82   595   905]);
sgtitle('Simulation 2: No Measures, Neighborhood Breakdown');

f8 = figure(8);
plotSEIRProp(f8,ySim3,xSim3,dt);
set(f8,'position',[618    82   595   905]);
sgtitle('Simulation 3: Measures, Neighborhood Breakdown');

f9 = figure(9);
compareSEIR(f9,ySim2,ySim3,dt);
ax = ancestor(f9, 'axes');
ax.YAxis.Exponent = 0;
ytickformat('%d');
xlabel('Time (days)')
ylabel('# Individuals');
title('No Measures (dotted) vs. Measures (solid)')
set(gcf,'position',[1217 564 698 416]); 

f10 = figure(10);
title('Cambridge Map');
imshow('Cambridge\Cambridge-Map.png');
set(gcf,'position',[1217 81 702 400]);
