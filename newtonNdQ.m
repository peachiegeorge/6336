function x0 = newtonNdQ(x0, p, u, theta, q)
% function newton1d(fhand,x0,itpause)
% 
% INPUTS:
%   fhand - function handle
%   x0    - initial guess
%   itpause - parameter for plotting
% 
% Use Newton's method to solve the nonlinear function
% defined by function handle fhand with initial guess x0.  
%
% itpause is parameter for plotting and defines the 
% number of Newton steps that are plotted sequentially
% pauses between sub-steps

tol=10;          % convergence tolerance
delta_tol=10;     % convergence tolerance
delta_percent_tol = 0.1; % convergence tolerance

maxIters=500;       % max # of iterations
x00=x0;             % initial guess

f = EVALFQ(x0, p, u, q); 
J = analyticJacobianQ(x0, p, theta, q);
dx=J\-f;

first_nf = norm(f,2);
first_ndx = norm(dx,2);

% Newton loop
for iter=1:maxIters
 
    f = EVALFQ(x0, p, u, q);     % evaluate function
    J = analyticJacobianQ(x0, p, theta, q);    % evaluate Jacobian
    
    %Generate preconditioner of J
    T = genDiagPreconditioner(J);
    
    %Scale J by Preditioner
    old_J = J;
    J = T*J;  
    
    %Scale f by Preditioner
    old_f = f;
    f = T*f;        
    
    dx=J\-f;
    
    nf(iter)=norm(f,2);          % norm of f at step k+1
    ndx(iter)=norm(dx,2);        % norm of dx at step k+1)
    nx(iter)=norm(convertSeirCellToMat(x0),2);  % norm of x at step k+1)
    
    if iter > 1
        delta_percent = ndx(iter)/nx(iter-1); 
    end
    
    raw_x0 = convertSeirCellToMat(x0) + dx;     %x0 with full change in dx
    capped_x0 = max(raw_x0, 0);                 %Cap each element of x0 to be non-negative
    
    %x(:, iter)=convertSeirMatToCell(convertSeirCellToMat(x0) + dx);              % solution x at step k+1
    x(:, iter)=convertSeirMatToCell(capped_x0);              % solution x at step k+1
    
    x0=x(:, iter);                 % set value for next guess
    if nf(iter) < tol,          % check for convergence
        % check for convergence
        fprintf('Converged in %d iterations\n',iter);
%         disp(x0)
        fprintf('Reach ||f(x)|| tolerance\n');
        break; 
    end
    
    if ndx(iter) < delta_tol
        % check for convergence
        fprintf('Converged in %d iterations\n',iter);
%         disp(x0)       
        fprintf('Reach delta ||f(x)|| tolerance\n');
        break;         
    end

    if (iter > 1) && (delta_percent < delta_percent_tol)
        % check for convergence
        fprintf('Converged in %d iterations\n',iter);
%         disp(x0)       
        fprintf('Reach (delta ||f(x)||) / ||x|| tolerance\n');
        break;         
    end
    
end

if iter==maxIters, % check for non-convergence
    fprintf('Non-Convergence after %d iterations!!!\n',iter); 
end

% iters = [1:iter];
% 
% figure(4);
% semilogy([0,iters],[first_nf, nf],'*-'); grid on; 
% xlabel('iteration #'); ylabel('||f(x)||');
% 
% figure(5)
% semilogy([0,iters],[first_ndx, ndx],'*-'); grid on; 
% xlabel('iteration #'); ylabel('||dx||');
% 
% figure(6)
% semilogy([0,iters],[first_nf, nf]/first_nf,'*-'); grid on; 
% xlabel('iteration #'); ylabel('||f(x_k)|| / ||f(x_0)||');
% title('Standard Newton')

