%% Trapezoidal Euler
clear all

dt = 0.01;  % fraction of a day
maxT = 100; % days
numTSteps = maxT/dt;
fileName = 'cambridgeParams';

% Number of nodes
P = 13;
cases = {'zeros','noMeasures','cutOff2','cutOffMultiple'};
% Generate theta matrix
%theta = GenThetaMat(P,'zeros'); % No Travel
%theta = GenThetaMat(P,'cutOffMultiple',2); % Cut Off Multiple Communities (defined in GenThetaMat)
%theta = GenThetaMat(P,'cutOff',2); % Cut Off Community (num defines which one)
theta = GenThetaMat(P,'noMeasures',2); % No Measures

% Initialize state vector
x0 = GenStateVec(P, 'MIToutbreak'); % Initial State
freq = 1;   % 1 full cycle per 90 days
for tStep = 1:numTSteps
    tStep
    % Generate modulated theta
    % thetaMod(:,:,tStep) = theta*cos(2*pi*freq*(tStep-1)*dt); % Use tStep-1 so the first point is multiplied by 1
    
    % Generate parameter matrix
    % p_day = GenPStruct(P, theta,'noMeasures',fileName);
    % p_night = GenPStruct(P, -theta,'noMeasures',fileName); % - theta if commuting
    
    % p = GenPStruct(P,thetaMod(:,:,tStep),'noMeasures',fileName);
    p = GenPStruct(P,theta,'noMeasures',fileName);
    
    % Generate input
    u = GenInputVec(P, 1); % Linearization operating point, t=0
    
    x(:,1) = cell2vec(x0,1);
    
    % Compute t
    %     t = dt*(tStep);
    %     if(t-floor(t)<0.5)
    %         day = 1;
    %         p = p_day;
    %     else
    %         day = 0;
    %         p = p_night;
    %     end

    %     if(mod(tStep,1) == 0)
    %         %disp("Step = "+num2str(tStep)+"/"+num2str(numTSteps))
    %         disp("Time = " + num2str(t) + ", Day = " + num2str(day))
    %     end
    
    if(tStep>1)
        x(:,tStep) = x(:,tStep-1);
    end
    
    gamma = x(:,tStep) + (dt/2) * cell2vec(EVALF(convertSeirMatToCell(x(:,tStep)),p,u),1);
    
    % Newton Method
    maxIter = 1000;
    tol = 1e-7;
    xk = squeeze(x(:,tStep));
    for i = 1:maxIter
        F = -getF(xk,p,u,dt,gamma); % Find F
        % FVec(:,i) = F;
        J = getJ(P,xk,p,u,theta,dt); % Find J
        % JVec(:,:,i) = J;
        dx = J\F;       % Solve
        dx = modtgcr(fhand,xk,-F,delta,eps,900);
        xk = xk + dx;   % Update
        nf = norm(abs(F));
        if(nf<tol)
            fprintf('Num Newton iters: %d', i);
            break
        end
    end
    x(:,tStep) = xk;
end

function[f] = getF(x,p,u,dt,gamma)
f = x - (dt/2) * cell2vec(EVALF(convertSeirMatToCell(x),p,u),1) - gamma;
end

function J = getJ(~,x,p,u,~,dt)
% J = analyticJacobian(P, convertSeirMatToCell(x), p, theta);
[J,~] = finiteDifferenceJacobian('EVALF',convertSeirMatToCell(x),p,u,0.1,100,1);
J = eye(size(x,1)) - (dt/2) * (J);
end