%% Trapezoidal

function [xSeirCell, t, newtonLastIter] = trapezoidalFlipThetaAdaptive(P, x_start, p, u, t_stop, timestep)
	
    dt = timestep;
    maxT = t_stop;
    
    x0SeirCell = x_start;
    x(:,1) = convertSeirCellToMat(x0SeirCell);
        
    tStep = 1;
    prevT = 0;
    
    while prevT < maxT
        
        %Show status at the end of each day
        if mod(prevT, 1) == 0
            disp("At time t = " + num2str(prevT));
        end
        
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
        [xk, isConverged, lastIter] = newton(xk, p, u, dt, gamma, isConverged);
        
        while ~isConverged 
            %dt won't go below 0.05
            dt = max(0.05, dt/2);
            [xk, isConverged, lastIter] = newton(xk, p, u, dt, gamma, isConverged);
        end
        
        %dt won't be higher than 0.4
        dt = min(0.4, dt*2);
        
        %To avoid precision error indirectly from other variables
        dt = max(0.05, dt);
      
        x(:,tStep) = xk;
        xSeirCell(:, tStep) = convertSeirMatToCell(xk);
        newtonLastIter(tStep) = lastIter;
        
        prevT = t(tStep);
        tStep = tStep + 1;
        
    end
    
    %Add the first initial state
    xSeirCell = [x0SeirCell xSeirCell];
    t = [0 t];
    
end

function [xk, isConverged, lastIter] = newton(xk, p, u, dt, gamma, isConverged)

    % Newton Method
%     maxIter = 4;
%     tol = 2e-12;
%     percent_tol = 5e-1;
    
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

        %To prevent dx from making negative people   
        dx = max(-xk, dx);        
        
        xk = xk + dx;
                    
        %Set mininum state to 0 people (no negative value)
        xk = max(xk, 0);  
        
        nf = norm(abs(f));
        ndx(i) = norm(dx);
        
        if i > 1
            percent_ndx = (norm(ndx(i) - ndx(i-1)) / norm(ndx(i-1))) * 100;
        else
            percent_ndx = 100;
        end
        
%         if ((nf<tol) || (ndx(i)<tol) || (percent_ndx < percent_tol))
        if (nf<tol) || (ndx(i)<tol)    
            isConverged = true;
            break
        end
    end 
    
    lastIter = i;
    
end
    
function[f] = getF(x,p,u,dt,gamma)

    f = x - (dt/2) * convertSeirCellToMat(EVALF(convertSeirMatToCell(x),p,u)) - gamma;

end

function J = getJ(x,p,u,dt)

%     J = eye(size(x,1)) - (dt/2) * (finiteDifferenceJacobian('EVALF', convertSeirMatToCell(x), p, u, 1, 1, 1));
    J = eye(size(x,1)) - (dt/2) * (finiteDifferenceJacobian('EVALF', convertSeirMatToCell(x), p, u, 0.1, 100, 1));
    
end