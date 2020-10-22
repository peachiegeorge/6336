function [x, r_norms] = iterativeSolveSteadyState(A, B)

    tol = 10^-5;
    maxiters = 20;

    [num_row, num_col] = size(B);
    
    %One right-hand side at a time
%     [x, r_norms] = tgcr(A, B(:,1), tol, maxiters)

%     x = zeros(num_row, num_col);
%     for i = 1:num_col 
%         [x_i, r_norms] = tgcr(A, B(:,i), tol, maxiters);
%         x(:, i) = x_i;
%     end
    
    %GMRES for sparse matrix and diagonally dominant matrix
%     x = zeros(num_row, num_col);
%     for i = 1:num_col 
%         [x_i, r_norms] = gmres(A, B(:,i), [], tol, maxiters);
%         x(:, i) = x_i;
%     end
    
    %Multiple right-hand side
    [x, r_norms] = tgcrDiffRhs(A, B, tol, maxiters) 
    
end