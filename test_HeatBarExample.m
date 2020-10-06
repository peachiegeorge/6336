clear all
close all

%select input evaluation functions
eval_u = 'eval_u_step';

% Heat Conducting Bar Example
[p,x_start,t_start,t_stop,max_dt_FE] = getParam_HeatBarExample(10);
eval_f = 'eval_f_LinearSystem';

% test FE function
figure(1)
visualize=1;
[X] = ForwardEuler(eval_f,x_start,p,eval_u,t_start,t_stop*.99/10,max_dt_FE,visualize);