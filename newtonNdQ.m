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

f_tol=1;          % convergence tolerance
delta_tol=1;     % convergence tolerance
delta_percent_tol = 0.01; % convergence tolerance
x_tol=1;

maxIters=500;       % max # of iterations
x00=x0;             % initial guess

[num_row, num_col] = size(x0);
num_x0_nodes = num_row;

first_nx = norm(convertSeirCellToMat(x0),2);

% Newton loop
for iter=1:maxIters
 
    f = EVALFQ(x0, p, u, q);     % evaluate function
    J = analyticJacobianQ(x0, p, theta, q);    % evaluate Jacobian
    
    %Generate preconditioner of J
%     T = genDiagPreconditioner(J);
%     
%     %Scale J by Preditioner
%     old_J = J;
%     J = T*J;  
%     
%     %Scale f by Preditioner
%     old_f = f;
%     f = T*f;        
    
    dx=J\-f;
    
    nf(iter)=norm(f,2);          % norm of f at step k+1
    ndx(iter)=norm(dx,2);        % norm of dx at step k+1)
    
    
    if iter > 1
        delta_percent(iter) = ndx(iter)/nx(iter-1); 
    end
    
    if iter == 1
        first_nf = nf(iter);
    end
    
    %Scale dx to avoid overshooting     
    old_nx = norm(convertSeirCellToMat(x0),2);
    if ndx(iter) > old_nx
        old_dx = dx;
        old_ndx = ndx(iter);
        old_dx = dx;
        
        dx = dx / ndx(iter) * 0.5 * old_nx;
        ndx(iter)=norm(dx,2);
    end
    
    raw_x0 = convertSeirCellToMat(x0) + dx;     %x0 with full change in dx
    rounded_raw_x0 = round(raw_x0);
    capped_x0 = round(max(raw_x0, 0));          %Cap each element of x0 to be non-negative
                                                %and round to nearest integer
    
    %x(:, iter)=convertSeirMatToCell(rounded_raw_x0);              % solution x at step k+1
    
    x(:, iter)=convertSeirMatToCell(capped_x0);              % solution x at step k+1
    %x(:, iter)=convertSeirMatToCell(raw_x0);              % solution x at step k+1    
    
    x0=x(:, iter);                 % set value for next guess
    
    nx(iter)=norm(convertSeirCellToMat(x0),2);  % norm of x at step k+1)
    
    if nf(iter) < f_tol,          % check for convergence
        % check for convergence
        fprintf('Converged in %d iterations\n',iter);
%         disp(x0)
        fprintf('Reach ||f(x)|| tolerance\n');
        break; 
    end
    
    if nx(iter) < x_tol,          % check for convergence
        % check for convergence
        fprintf('Converged in %d iterations\n',iter);
%         disp(x0)
        fprintf('Reach || x || tolerance\n');
        break; 
    end
    
    if ndx(iter) < delta_tol
        % check for convergence
        fprintf('Converged in %d iterations\n',iter);
%         disp(x0)       
        fprintf('Reach delta ||f(x)|| tolerance\n');
        break;         
    end

    if (iter > 1) && (delta_percent(iter) < delta_percent_tol)
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

all_nx = [first_nx, nx];
all_x = [x00, x];

iters = [1:iter];

% figure(4);
% semilogy([iters],[nf],'*-'); grid on; 
% xlabel('iteration #'); ylabel('||f(x)||');
% 
% figure(5)
% semilogy([iters],[ndx],'*-'); grid on; 
% xlabel('iteration #'); ylabel('||dx||');
% 
% figure(6)
% semilogy([iters],[nf]/first_nf,'*-'); grid on; 
% xlabel('iteration #'); ylabel('||f(x_k)|| / ||f(x_0)||');
% title('Standard Newton')

