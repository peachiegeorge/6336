clear; close all;
%% Test 100 nodes
P = 100;    % # nodes simulated
eval_f = 'EVALF'
theta = GenThetaMat(P,'symmetric');
x0 = GenStateVec(P, 'sameIC');
p = GenPStruct(P, theta);
u0 = GenInputVec(P, 0); % Linearization operating point, t=0
epsX = 1;
epsU = 1;
[A,B] = LINEARIZEF(eval_f,x0,p,u0,epsX,epsU);
figure(1);
imagesc(A);
title('Jf_X')
figure(2);
imagesc(B);
title('K0 and Jf_U');
%% Simple scalar linear system, no inputs.
f1 = @(x) x.^3;
doScalarInput = 1;
x0 = 6;
[A1,B1] = LINEARIZEF(f1,x0,[],[],0.001,[],doScalarInput);
testX1 = linspace(0,10,100);
testF1 = f1(testX1);
testF1Jacobian = f1(x0) + A1*(testX1 - x0);
plot(testX1,testF1,'r'); hold on;
plot(testX1,testF1Jacobian,'b');
