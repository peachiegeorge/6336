clc; clear; close all
rng(1);

% Generate x,p,u
P = 3; % Number of nodes
theta = GenThetaMat(P,'random');
x0 = GenStateVec(P, 'random');
p = GenPStruct(P, theta);
u0 = GenInputVec(P, 0); % Linearization operating point, t=0

% Forward Euler parameters
t_start = 0;
t_stop = 50;
timestep = 0.01;
eval_f = 'EVALF';
eval_u = 'GenInputVec';

% Run Forward Euler
[X] = ForwardEuler(P, eval_f, x0, p, eval_u, t_start, t_stop, timestep);
