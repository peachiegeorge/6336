function T = genDiagPreconditioner(A)
    
    [num_row, num_col] = size(A);

    T = zeros(num_row, num_col)
    for i=1:num_col
        T(i,i) = 1/A(i,i)
%         T(i,i) = 10000
    end
    
end