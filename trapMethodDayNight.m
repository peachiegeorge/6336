%% Trapezoidal Euler
clear all

dt = 0.5;
maxT = 100;
numTSteps = maxT/dt;
fileName = 'cambridgeParams2'
% Number of nodes
P = 13;

%theta = GenThetaMat(P,'zeros'); % No Travel
%theta = GenThetaMat(P,'cutOffMultiple',2); % Cut Off Multiple Communities (defined in GenThetaMat)
%theta = GenThetaMat(P,'cutOff',2); % Cut Off Community (num defines which one)
%theta = GenThetaMat(P,'noMeasures',2); % No Measures

x0 = GenStateVec(P, 'sameInfect'); % Initial State
p_day = GenPStruct(P, theta,'noMeasures',fileName);
p_night = GenPStruct(P, -theta,'noMeasures',fileName); % - theta if commuting
u = GenInputVec(P, 1); % Linearization operating point, t=0

x(:,1) = convertSeirCellToMat(x0);
for tStep = 1:numTSteps
    
    % Compute t
    t = dt*(tStep);
    if(t-floor(t)<0.5)
        day = 1;
        p = p_day;
    else
        day = 0;
        p = p_night;
    end
    
    if(mod(tStep,1) == 0)
        %disp("Step = "+num2str(tStep)+"/"+num2str(numTSteps))
        disp("Time = "+num2str(t)+", Day = "+num2str(day))
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
        fVec(:,i)=f;
        % Find J
        
        J = getJ(P,xk,p,u,theta,dt);
        JVec(:,:,i)=J;
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

f = x - (dt/2) * convertSeirCellToMat(EVALF2(convertSeirMatToCell(x),p,u)) - gamma;

end
function J = getJ(P,x,p,u,theta,dt)
%J = analyticJacobian(P, convertSeirMatToCell(x), p, theta);
[J,~] = finiteDifferenceJacobian('EVALF2',convertSeirMatToCell(x),p,u,0.1,100,1);
J = eye(size(x,1)) - (dt/2) * (J);
end