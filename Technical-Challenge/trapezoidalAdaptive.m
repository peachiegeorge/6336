%% Trapezoidal Euler

function [xSeirCell, t] = trapezoidalAdaptive()

    clear all
    close all

    rng(5);
    
    dt = 0.1;
    maxT = 100;
    numTSteps = maxT/dt;
    
    [P, x0SeirCell, p, u] = initializeCambridgeCommunities();
    x(:,1) = convertSeirCellToMat(x0SeirCell);
        
    tStep = 1;
    prevT = 0;
    
    while prevT < maxT
        
        if(tStep > 1)
            x(:,tStep) = x(:,tStep-1);
            
            %dt must not make the next t pass the end of each day
            maxCurT = floor(t(tStep-1) + 1);
            dt = min(dt, maxCurT - t(tStep-1));           
            
            t(tStep) = t(tStep-1) + dt;       
        else       
            t(tStep) = dt;          
        end

        gamma = x(:,tStep) + (dt/2) * convertSeirCellToMat(EVALF(convertSeirMatToCell(x(:,tStep)),p,u));

        xk = squeeze(x(:,tStep));

        isConverged = false;
        [xk, isConverged] = newton(xk, p, u, dt, gamma, isConverged);
        
        while ~isConverged 
            dt = dt/2;
            [xk, isConverged] = newton(xk, p, u, dt, gamma, isConverged);
        end
        
        dt = dt*2;
      
        x(:,tStep) = xk;
        xSeirCell(:, tStep) = convertSeirMatToCell(xk);
        
        prevT = t(tStep);
        tStep = tStep + 1;
        
    end
    
    %Add the first initial state
    xSeirCell = [x0SeirCell xSeirCell];
    t = [0 t];
    
end

function [xk, isConverged] = newton(xk, p, u, dt, gamma, isConverged)

    % Newton Method
    maxIter = 1000;
    tol = 1e-7;

    isConverged = false;
    
    for i = 1:maxIter

        % Find f
        f = -getF(xk, p, u, dt, gamma);

        % Find J
        J = getJ(xk, p, u, dt);

        % Solve 
        dx = J\f;

        xk = xk + dx;
        nf = norm(abs(f));
        
        if(nf<tol)
            isConverged = true;
            break
        end
    end 
    
end
    
function[f] = getF(x,p,u,dt,gamma)

    f = x - (dt/2) * convertSeirCellToMat(EVALF(convertSeirMatToCell(x),p,u)) - gamma;

end

function J = getJ(x,p,u,dt)

    J = eye(size(x,1)) - (dt/2) * (finiteDifferenceJacobian('EVALF', convertSeirMatToCell(x), p, u, 1, 1, 1));

end