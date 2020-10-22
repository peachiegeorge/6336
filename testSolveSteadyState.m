function [L, U, Pe, X, Y] = testSolveSteadyState()

    % Generate Random Numbers That Are Repeatable
    rng('default');
    rng(3);

    P = 4;

    theta = GenThetaMat(P, 'symmetric');
%     theta = zeros(P, P)
    
    x = GenSteadyStateVec(P, 1)
    %p = GenPStruct(P, theta);
    p = GenSteadyPStruct(P, theta);
    
    % value in u is not used but EVALF require u as a parameter
    u = GenInputVec(P, 1);
    
    epsX = 0.1;
    epsU = 0.1;
    doCellOps = 1;
    
    [Jf_u, Jf_x] = finiteDifferenceJacobian('EVALF', x, p, u, epsX, epsU, doCellOps);
    
    %Get Jacobian matrix A from analytic Jacobian 
    A = transpose(analyticJacobian(P, x, p, theta));
    
    %Get Jacobian matrix A from finite difference Jacobian
%     A = Jf_x;
    
    %Generate preconditioner of A
%     T1 = genDiagPreconditioner(A);
%     T2 = genRowPreconditioner(A);
    
    %Scale A by Preditioner
%     old_A1 = A;
%     A = T1*A;
    
%     old_A2 = A;
%     A = T2*A;
    
    num_excitations = 10;
    B = zeros(4*P, num_excitations);
    
    for i = 1:num_excitations
        x = GenSteadyStateVec(P, i);     
        f = EVALF(x, p, u);
        B(:, i) = reshape(-cell2mat(f), [4*P, 1]);
    end
    
    %Scale B by Preditioner
%     old_B1 = B;
%     B = T1*B;
    
%     old_B2 = B;
%     B = T2*B;    
    
    [L, U, Pe, X, Y] = solveSteadyState(A, B);    
    
end

