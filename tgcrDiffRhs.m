function [x, r_norms] = tgcrDiffRhs(M, B, tol, maxiters) 
% Generalized conjugate residual method for solving Mx = b
% INPUTS
% M - matrix
% B - multiple right hand side (each column for each right hand side)
% tol - convergence tolerance, terminate on norm(b - Mx) < tol * norm(b)
% maxiters - maximum number of iterations before giving up 
% OUTPUTS
% x - computed solution, returns null if no convergence
% r_norms - the scaled norm of the residual at each iteration (r_norms(1) = 1)

last_vec_idx = 0;

[num_row, num_col] = size(B);

% Generate the initial guess for x (zero)
x = zeros(size(B));

recycled_p = []
recycled_Mp = []

for col = 1:num_col 
    
    % Define b as the iter-th column of B
    b = B(:, col);

    % Set the initial residual to b - Mx^0 = b
    r = b;
    
    % Determine the norm of the initial residual
    r_norms = []
    r_norms(1) = norm(r, 2);  
    
    if col ~= 1
        
        [num_recycled_row, num_recycled_col] = size(recycled_p);
    
        % Use the residual as the first guess for the new
        % search direction and multiply by M
        p(:, 1) = r; 
        Mp(:, 1) = M * p(:, 1);

        % Make the new Mp vector orthogonal to the previous Mp vectors,
        % and the p vectors M^TM orthogonal to the previous p vectors
        for j=1:num_recycled_col, 
            beta = Mp(:, 1)' * recycled_Mp(:,j); 
            p(:,1) = p(:,1) - beta * recycled_p(:,j); 
            Mp(:,1) = Mp(:,1) - beta * recycled_Mp(:,j);
        end; 

        % Make the orthogonal Mp vector of unit length, and scale the
        % p vector so that M * p  is of unit length
        norm_Mp = norm(Mp(:,1),2);
        Mp(:,1) = Mp(:,1)/norm_Mp;
        p(:,1) = p(:,1)/norm_Mp;

        % Determine the optimal amount to change x in the p direction
        % by projecting r onto Mp
        alpha = r' * Mp(:,1);

        % Update x and r
        r = r - alpha * Mp(:,1); 

        % Determine the norm of the initial residual
        r_norms(1) = norm(r, 2); 
        
    end    
    
    p = []
    Mp = []
    
    
    for iter = 1:maxiters
        % Use the residual as the first guess for the new
        % search direction and multiply by M
        p(:,iter) = r; 
        Mp(:,iter) = M * p(:,iter);

        % Make the new Mp vector orthogonal to the previous Mp vectors,
        % and the p vectors M^TM orthogonal to the previous p vectors
        for j=1:iter-1, 
            beta = Mp(:,iter)' * Mp(:,j); 
            p(:,iter) = p(:,iter) - beta * p(:,j); 
            Mp(:,iter) = Mp(:,iter) - beta * Mp(:,j);
        end; 

        % Make the orthogonal Mp vector of unit length, and scale the
        % p vector so that M * p  is of unit length
        norm_Mp = norm(Mp(:,iter),2);
        Mp(:,iter) = Mp(:,iter)/norm_Mp;
        p(:,iter) = p(:,iter)/norm_Mp;

        % Determine the optimal amount to change x in the p direction
        % by projecting r onto Mp
        alpha = r' * Mp(:,iter);

        % Update x and r
        x(:, col) = x(:, col) + alpha * p(:,iter); 
        r = r - alpha * Mp(:,iter); 

        % Save the norm of r
        r_norms(iter+1) = norm(r,2); 

        % Print the norm during the iteration 
        % fprintf('||r||=%g i=%d\n', norms(iter+1), iter+1);

        % Check convergence.
        if r_norms(iter+1) < (tol * r_norms(1))
            break; 
        end; 
	end;

    % Notify user of convergence
    if r_norms(iter+1) > (tol * r_norms(1))
        fprintf(1, 'GCR NONCONVERGENCE!!!\n');
        x = [];
    else 
        fprintf(1, 'GCR converged in %d iterations\n', iter);
    end; 

    % Scale the r_norms with respect to the initial residual norm
    r_norms = r_norms / r_norms(1);
    
    recycled_p = cat(2, recycled_p, p);
    recycled_Mp = cat(2, recycled_Mp, Mp);
    
    last_vec_idx = last_vec_idx + iter;
    
end


