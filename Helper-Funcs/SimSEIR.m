function [y x] = SimSEIR(numNeighborhoods,simCase,initCond,dt)
maxT = 100;						% days
numTSteps = maxT/dt;			% number of time steps
cutoff = 2;						% neighborhood to cut off
useGMRES = false;				% use GMRES method instead of LU solver
useAdaptiveTimestep = false;	% use adaptive timestep in trapezoidal method
P = numNeighborhoods;			% number of neighborhoods
fileName = 'cambridgeParams';

% Initialize state vector
x0 = GenStateVec(P, initCond); % Initial State
theta = GenThetaMat(P, simCase, cutoff); % No Measures
u = GenInputVec(P, 1);
p = GenPStruct(P, theta, simCase, fileName);
if useAdaptiveTimestep
    % Generate input
    [x, tVecAdaptive, ~] = trapezoidalFlipThetaAdaptive(P, x0, p, u, maxT, dt);
else
    % Generate theta matrix
    for tStep = 1:numTSteps
        % Generate parameter matrix
        % p_day =   GenPStruct(P,  theta, simCase, fileName);
        % p_night = GenPStruct(P, -theta, simCase, fileName); % -theta if commuting
        
        % Generate input
        u = GenInputVec(P, 1);
        
        % Compute t
        t = dt*(tStep);
        
        % Choose day or night
%         if(t - floor(t) < 0.5)
%             day = 1;
%             p = p_day;
%         else
%             day = 0;
%             p = p_night;
%         end
        
        % Initialize state at current timestep to previous state
        x(:,1) = cell2vec(x0,1);
        if(tStep > 1)
            x(:,tStep) = x(:, tStep-1);
        end
        
        % Compute gamma
        gamma = x(:,tStep) + (dt/2) * cell2vec(EVALF(convertSeirMatToCell(x(:,tStep)),p,u),1);
        
        % Newton-solve for current state
        maxIter = 1000;
        tol = 1e-7;
        xk = squeeze(x(:,tStep));
        for i = 1:maxIter
            F = getF(xk,p,u,dt,gamma);		% Find F
            J = getJ(P,xk,p,u,theta,dt);	% Find J
            if useGMRES
                delta =	1e-12;				% tolerance for TGCR solver
                eps = 1000;					% stepsize for estimation of Jacobian in TGCR
                maxGCRIter = 500;			% Maximum # of iterations for GCR
                fhand = @(xg) getF(xg,p,u,dt,gamma);
                dx = modtgcr(fhand,xk,-F,delta,eps,maxGCRIter);
            else % MATLAB LU solver
                dx = J\(-F);				% Solve
            end
            xk = xk + dx;					% Update
            xk = max(xk,0);					% Set minimum state to 0 people
            nf = norm(abs(F));
            ndx = norm(dx);
            fprintf('Timestep %d, Time %.2f, Newton Iter %d, nf %i, ndx %i\n',tStep,t,i,nf,ndx)
            if(nf < tol || ndx < tol)
                break
            end
        end
        x(:,tStep) = xk;
    end
end
c = [repmat(eye(4,4),P,1)];
y = c'*x;
end

function[f] = getF(x,p,u,dt,gamma)
f = x - (dt/2) * cell2vec(EVALF(convertSeirMatToCell(x),p,u),1) - gamma;
end

function J = getJ(~,x,p,u,~,dt)
% J = analyticJacobian(P, convertSeirMatToCell(x), p, theta);
[J,~] = finiteDifferenceJacobian('EVALF',convertSeirMatToCell(x),p,u,0.1,100,1);
J = eye(size(x,1)) - (dt/2) * (J);
end