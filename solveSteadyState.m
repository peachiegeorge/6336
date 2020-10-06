function [L, U, Pe, X, Y] = solveSteadyState(A, B)
     [L, U, Pe] = lu(A); 
     Y = L\(Pe*B); 
     X = U\Y;
end

