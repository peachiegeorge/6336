clear all
close all

%Generate Random Numbers That Are Repeatable
% rng('default');
% rng(1);

% # nodes simulated
P = 2;    

% time in days
t_start = 0;
t_stop = 7;
timestep = 0.25;

%select input evaluation function
eval_u = 'GenInputVec';

%generate Theta matrix of Theta[i,k] representing 
%the rate at which individuals move from node k to node i. 
%Units of [time-1].
theta = GenThetaMat(P, 'symmetric');

%start state at time 0 equals input vector at time 0
x_start = GenInputVec(P, 0);

%generate parameters beta, sigma, gamme, and theta
%beta[i] the probability of disease transmitting from an infectious individual to a susceptible individual 
%sigma[i] the rate of exposed individuals becoming infectious
%gamme[i] the rate at which individuals recover (or die)
%theta[i,k] the rate at which individuals move from node k to node i.
p = GenPStruct(P, theta);

%select model evaluation function
eval_f = 'EVALF';

% test FE function
[X] = ForwardEuler(P, eval_f, x_start, p, eval_u, t_start, t_stop, timestep);
%% Plot SEIR curves for all nodes
for i = 1:size(X,1)
	S = X(i,:);
	s = [S{1:end}];
	figure(i);
	hold on;
	days = linspace(t_start,t_stop,length(s(1,1:end)));
	plot(days, s(1,1:end));
	xlabel('t [days]'); ylabel('S(t)');

	plot(days, s(2,1:end));
	xlabel('t [days]'); ylabel('E(t)');

	plot(days, s(3,1:end));
	xlabel('t [days]'); ylabel('I(t)');

	plot(days, s(4,1:end));
	xlabel('t [days]'); ylabel('R(t)');
	hold off;
	legend('S','E','I','R');
	title(['Node ',num2str(i)])
end