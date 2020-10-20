clear; close all;
P = 10;    % # nodes simulated
%select model evaluation function
eval_f = 'EVALF';

theta = GenThetaMat(P,'random');

x_start = GenStateVec(P, 'sameIC');
p = GenPStruct(P, theta);
u = GenInputVec(P, 3); % Linearization operating point, t=0

[Jf_u, Jf_x] = finiteDifferenceJacobian('EVALF',x_start,p,u,0.1,0.1,1);

figure(1);
imagesc(Jf_u);
title('Jf_u')
figure(2);
imagesc(Jf_x);
title('Jf_x');