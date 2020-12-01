%% Trapezoidal Euler
clc; clear; close all;
dt = 0.5;						% fraction of a day
maxT = 100;						% days
numTSteps = maxT/dt;			% number of time steps
cutoff = 2;						% neighborhood to cut off
useTGCR = false;				% use Newton-TGCR method instead of LU solver
useAdaptiveTimestep = false;	% use adaptive timestep in trapezoidal method
P = 1;							% number of nodes
rng(5);							% start random number generator seed at same value
fileName = 'cambridgeParams';
cases = {'zeros','noMeasures','cutOff','cutOffMultiple'};

for caseNum = 1:length(cases)
	% Initialize state vector
	x0 = GenStateVec(P, 'MIToutbreak'); % Initial State
	theta = GenThetaMat(P,cases{caseNum},cutoff); % No Measures
	u = GenInputVec(P, 1);
	p = GenPStruct(P,theta,cases{caseNum},fileName);
	if useAdaptiveTimestep
		% Generate input
		[x, tVecAdaptive, ~] = trapezoidalFlipThetaAdaptive(P, x0, p, u, maxT, dt);
	else
		% Generate theta matrix
		for tStep = 1:numTSteps
			% Generate parameter matrix
			p_day = GenPStruct(P, theta,cases{caseNum},fileName);
			p_night = GenPStruct(P, -theta,cases{caseNum},fileName); % -theta if commuting
			
			% Generate input
			u = GenInputVec(P, 1);
			
			% Compute t
			t = dt*(tStep);
			
			% Choose day or night
			if(t - floor(t) <= 0.5)
				day = 1;
				p = p_day;
			else
				day = 0;
				p = p_night;
			end
			
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
				if useTGCR
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
				fprintf('Case %d, Day %d, Timestep %d, Time %.2f, Newton Iter %d, nf %i, ndx %i\n',...
					caseNum,day,tStep,t,i,nf,ndx)
				if(nf < tol || ndx < tol)
					break
				end
			end
			x(:,tStep) = xk;
		end
	end
	saveStr = ['Outputs\x-' cases{caseNum} '.mat'];
	save(saveStr,'x','dt');
end

function[f] = getF(x,p,u,dt,gamma)
f = x - (dt/2) * cell2vec(EVALF(convertSeirMatToCell(x),p,u),1) - gamma;
end

function J = getJ(~,x,p,u,~,dt)
% J = analyticJacobian(P, convertSeirMatToCell(x), p, theta);
[J,~] = finiteDifferenceJacobian('EVALF',convertSeirMatToCell(x),p,u,0.1,100,1);
J = eye(size(x,1)) - (dt/2) * (J);
end