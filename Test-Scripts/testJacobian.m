clear; close all;
P = 2;    % # nodes simulated
eval_u = 'GenInputVec';
eval_f = 'EVALF';
rng(0);
theta = GenThetaMat(P,'random');
x_start = GenStateVec(P, 'sameIC');
u = GenInputVec(P, 0); % Linearization operating point, t=0
p = GenPStruct(P, theta);
[Jf_x, Jf_u] = finiteDifferenceJacobian('EVALF',x_start,p,u,1,1,1);

figure(1);
imagesc(mag2db(Jf_u));
colorbar;
title('Jf_u')

figure(2);
imagesc(mag2db(Jf_x));
colorbar;
title('Jf_x');

c = condest(Jf_x)

%%
tic
doCellOps = 1;
npts = 1000;
P = 20;
theta = GenThetaMat(P,'random');
x_start = GenStateVec(P, 'sameIC');
u = GenInputVec(P, 0); % Linearization operating point, t=0
p = GenPStruct(P, theta);
% 
% epsXVec = logspace(-20,20,npts);
% epsUVec = repmat(0.1,1,npts);
epsXVec = repmat(0.1,1,npts);
epsUVec = logspace(-20,20,npts);
jacobDel = zeros(npts-1,4*P,4*P);

p2(npts).A = struct();
p2(npts).B = struct();

errS1 = zeros(1,npts);
errS2 = zeros(1,npts);
errI1 = zeros(1,npts);
errI2 = zeros(1,npts);

for i = 1:npts
    % Linearize
    [p2(i).A, p2(i).B] = LINEARIZEF(eval_f,x_start,p,u,epsXVec(i),epsUVec(i),doCellOps);
    
    % Forward Euler
%     eval_u = 'GenInputVec';
%     lin_f = 'EVALFLIN';
%     timestep = 0.01;
%     t_start = 0;
%     t_stop = 1*timestep;
%     [X] = ForwardEuler(P, eval_f, x_start, p, eval_u, t_start, t_stop, timestep);
%     [XLin] = ForwardEuler(P, lin_f, x_start, p2(i), eval_u, t_start, t_stop, timestep);
%     
%     XMat = [X{:}];
%     S1 = XMat(1,3);
%     S2 = XMat(1,4);
%     I1 = XMat(3,3);
%     I2 = XMat(3,4);
%     
%     XLinMat = [XLin{:}];
%     S1Lin = XLinMat(1,3);
%     S2Lin = XLinMat(1,4);
%     I1Lin = XLinMat(3,3);
%     I2Lin = XLinMat(3,4);
%     
%     errS1(i) = 100*(S1 - S1Lin) ./ S1;
%     errS2(i) = 100*(S2 - S2Lin) ./ S2;
%     errI1(i) = 100*(I1 - I1Lin) ./ I1;
%     errI2(i) = 100*(I2 - I2Lin) ./ I2;
%     
    % Compute change in Jacobian
    if i > 1
        sf = 1;
        jacobPrev = sf*p2(i-1).A;
%         figure(1)
%         imagesc((jacobCurr));
        jacobCurr = sf*p2(i).A;
        nonzero = p2(i-1).A>0;
        temp = abs(jacobCurr - jacobPrev) ./ jacobPrev;
        jacobDel(i-1,~isnan(temp) & ~isinf(temp)) = temp(~isnan(temp) & ~isinf(temp));
        squeeze(jacobDel(i-1,:,:));
    end
end
toc
%%
close all;
figure(1); 
semilogx(epsXVec,errS1);
hold on
semilogx(epsXVec,errS2);
legend('S1','S2');
xlabel('epsX');
ylabel('% Error');
title('Error in S for 2 Communities');

figure(2); 
semilogx(epsXVec,errI1);
hold on
semilogx(epsXVec,errI2);
legend('I1','I2');
xlabel('epsX');
ylabel('% Error');
title('Error in I for 2 Communities');
%%
jacobDelMax = zeros(1,npts-1);
for i = 1:size(jacobDel,1)
    jacobDelMax(i) = mean(jacobDel(i,:));
end

figure(3);
semilogx(epsXVec(1:end-1), jacobDelMax);
xlabel('epsX');
ylabel('Change in Jacobian');
title('Jacobian Convergence');

figure(4)
semilogx(epsUVec(1:end-1), jacobDelMax);
xlabel('epsU');
ylabel('Change in Jacobian');
title('Jacobian Convergence');
%%
for i = 1:npts
    condJacob(i) = condest(p2(i).A);
end
figure(5);
loglog(epsXVec(1:end), condJacob);
xlabel('epsX');
ylabel('Condition # of Jacobian');
axis tight;
