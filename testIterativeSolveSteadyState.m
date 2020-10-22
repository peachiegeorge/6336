function [x, r_norms] = testIterativeSolveSteadyState()

    % Generate Random Numbers That Are Repeatable
    rng('default');
    rng(3);

    P = 4;

    %theta = GenThetaMat(P, 'symmetric');
    theta = GenThetaMat(P, 'symmetric');
%     theta = zeros(P, P)
    
    x = GenSteadyStateVec(P, 1)
    %p = GenPStruct(P, theta);
    p = GenSteadyPStruct(P, theta);
    
    % value in u is not used but EVALF require u as a parameter
    u = GenInputVec(P, 1);
    
    A = transpose(analyticJacobian(P, x, p, theta));

    %Generate preconditioner of A
    T1 = genDiagPreconditioner(A);    

    %Scale A by Preditioner
    old_A1 = A;
    A = T1*A;    
    
    num_excitations = 10
    B = zeros(4*P, num_excitations)
    
    for i = 1:num_excitations
        x = GenSteadyStateVec(P, i)     
        f = EVALF(x, p, u);
        B(:, i) = reshape(-cell2mat(f), [4*P, 1])
    end
    
    %Scale B by Preditioner
    old_B1 = B;
    B = T1*B;    
    
    % Multiple right-hand side
    [x, r_norms] = iterativeSolveSteadyState(A, B)
end








