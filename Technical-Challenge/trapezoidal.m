%% Trapezoidal Euler

function [xSeirCell, newtonLastIter] = trapezoidal(P, x_start, p, u, t_stop, timestep)
    
    dt = timestep;
    maxT = t_stop;
    numTSteps = maxT/dt;
    
    x0SeirCell = x_start;
    x(:,1) = convertSeirCellToMat(x0SeirCell);
    
    for tStep = 1:numTSteps

        % Compute t
        t = dt*(tStep);
        if(mod(tStep,10) == 0)
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

            %To prevent dx from making negative people   
            dx = max(-xk, dx);
            
            xk = xk + dx;
            
            %Set mininum state to 0 people (no negative value)
            xk = max(xk, 0);           
            
            nf = norm(abs(f));
            ndx = norm(dx);
            
            if (nf<tol) || (ndx<tol)
                break
            end
        end      
        
        x(:,tStep) = xk;
        xSeirCell(:, tStep) = convertSeirMatToCell(xk);
        
        lastIter = i;
        newtonLastIter(tStep) = lastIter;
        
    end
    
    %Add the first initial state
    xSeirCell = [x0SeirCell xSeirCell];
    
end
    
function[f] = getF(x,p,u,dt,gamma)

    f = x - (dt/2) * convertSeirCellToMat(EVALF(convertSeirMatToCell(x),p,u)) - gamma;

end

function J = getJ(x,p,u,dt)

%     J = eye(size(x,1)) - (dt/2) * (finiteDifferenceJacobian('EVALF', convertSeirMatToCell(x), p, u, 1, 1, 1));
    J = eye(size(x,1)) - (dt/2) * (finiteDifferenceJacobian('EVALF', convertSeirMatToCell(x), p, u, 0.1, 100, 1));

end