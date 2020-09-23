clear all
close all

%Generate Random Numbers That Are Repeatable
% rng('default');
% rng(1);

P = 20;    % # nodes simulated; for current setting o
t_start = 0;
t_stop = 2;
timestep = 0.01;

%select input evaluation function
eval_u = 'GenInputVec';

theta = GenThetaMat(P);
%x_start = GenStateVec(P);
%x_start = transpose(reshape(cell2mat(GenInputVec(P, 0)), [4, P]));

%start state at time 0 equals input vector at time 0
x_start = GenInputVec(P, 0);
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