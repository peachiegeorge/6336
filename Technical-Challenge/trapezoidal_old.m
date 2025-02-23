%% Trapezoidal Euler

function xSeirCell = trapezoidal()

    clear all
    close all

    rng(5);
    
    dt = 0.1;
    maxT = 100;
    numTSteps = maxT/dt;
    
    [P, x0SeirCell, p, u] = initializeCambridgeCommunities();
    x(:,1) = convertSeirCellToMat(x0SeirCell);
    
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
            J = getJ(xk,p,u,dt);

            % Solve 
            dx = J\f;

            xk = xk + dx;
            nf = norm(abs(f));
            if(nf<tol)
                break
            end
        end 
        
        x(:,tStep) = xk;
        xSeirCell(:, tStep) = convertSeirMatToCell(xk);
        
    end
    
    %Add the first initial state
    xSeirCell = [x0SeirCell xSeirCell];
    
end
    
function[f] = getF(x,p,u,dt,gamma)

    f = x - (dt/2) * convertSeirCellToMat(EVALF(convertSeirMatToCell(x),p,u)) - gamma;

end

function J = getJ(x,p,u,dt)

    J = eye(size(x,1)) - (dt/2) * (finiteDifferenceJacobian('EVALF', convertSeirMatToCell(x), p, u, 1, 1, 1));

end