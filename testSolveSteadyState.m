function [L, U, Pe, X, Y] = testSolveSteadyState()
%     P = 4;
%     A = analyticJacobian(P);
%     B = transpose([1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1; 
%         2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2; 
%         3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3; 
%         4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4]);
%     
%     [L, U, Pe, X, Y] = solveSteadyState(A, B);
    
    P = 4;

    theta = GenThetaMat(P, 'symmetric');
    x = GenStateVec(P, '');
    p = GenPStruct(P,  theta);
    u = GenInputVec(P, 0);
    x = u;
    f = EVALF(x, p, u);
    
    A = analyticJacobian(P, x, p, u, f, theta);
    
    num_excitations = 2
    B = zeros(4*P, num_excitations)
    
    for i = 1:num_excitations
        u = GenInputVec(P, i);     
        f = EVALF(x, p, u);
        B(:, i) = cell2mat(f)
    end
    
    [L, U, Pe, X, Y] = solveSteadyState(A, B);    
    
end