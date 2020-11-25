%% Trapezoidal Euler

clear all
close all

dt = 0.01;
maxT = 100;
numTSteps = maxT/dt;

% Number of nodes
P = 1;

theta = GenThetaMat(P,'zeroes');
x0 = GenStateVec(P, 'random'); % Initial State
p = GenPStruct(P, theta);
u = GenInputVec(P, 1); % Linearization operating point, t=0

x(:,1) = convertSeirCellToMat(x0);
for tStep = 1:numTSteps
    
    % Compute t
    t = dt*(tStep);
    if(mod(tStep,1000) == 0)
        disp("Step = "+num2str(tStep)+"/"+num2str(numTSteps))
    end
    
    if(tStep>1)
        x(:,tStep) = x(:,tStep-1);
    end
    
    gamma = x(:,tStep) + (dt/2) * convertSeirCellToMat(EVALF(convertSeirMatToCell(x(:,tStep)),p,u));
    
    % Newton Method
    maxIter = 1000;
    tol = 1e-7;
    
    xk = squeeze(x(:,tStep));
    
    for i = 1:maxIter
        
        % Find f
        f = -getF(xk,p,u,dt,gamma);
        
        % Find J
        J = getJ(P,xk,p,theta,dt);
        
        % Solve 
        dx = J\f;
        
        xk = xk + dx;
        nf = norm(abs(f));
        if(nf<tol)
            break
        end
    end 
    x(:,tStep) = xk;
end
function[f] = getF(x,p,u,dt,gamma)

f = x - (dt/2) * convertSeirCellToMat(EVALF(convertSeirMatToCell(x),p,u)) - gamma;

end
function J = getJ(P,x,p,theta,dt)

J = eye(size(x,1)) - (dt/2) * (analyticJacobian(P,convertSeirMatToCell(x),p,theta));
end