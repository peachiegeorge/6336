clc; clear; close all
rng(1);

% Generate x,p,u
P = 5; % Number of nodes
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

% % Plot SEIR curves for all nodes
% for i = 1:size(X,1)
%     State = X(i,:);
%     state = round([State{1:end}]);
%     N(i,:) = sum(state, 1);
%     figure(i+10);
%     hold on;
%     days = linspace(t_start,t_stop,length(state(1,1:end)));
%     plot(days, state(1,1:end),  'LineWidth', 1.5);
%     xlabel('t [days]');
%     
%     plot(days, state(2,1:end),  'LineWidth', 1.5);
%     xlabel('t [days]');
%     
%     plot(days, state(3,1:end), 'LineWidth', 1.5);
%     xlabel('t [days]');
%     
%     plot(days, state(4,1:end), 'LineWidth', 1.5);
%     xlabel('t [days]');
%     hold off;
%     legend('S(t)','E(t)','I(t)','R(t)');
%     title(['Test Case 6' ' Node ', num2str(i)])
% end
% % Plot N(t)
% figure;
% imagesc(N(:,:));
% title('Test Case 6 N(t)');
% xlabel('Timestep');
% ylabel('Node');
% colorbar;

% % Plot all individuals
% plot(days,sum(N,1),'LineWidth',1.5);
% ylim([max(sum(N,1))-100, max(sum(N,1))+100]);
% xlabel('t [days]'); ylabel('$\sum{N(t)}$','interpreter','latex');
% title(['Total Number of Individuals in System'])