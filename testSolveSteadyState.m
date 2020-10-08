function [L, U, Pe, X, Y] = testSolveSteadyState()

    % Generate Random Numbers That Are Repeatable
    rng('default');
    rng(3);

    P = 4;

    %theta = GenThetaMat(P, 'symmetric');
    theta = zeros(P, P)
    
    x = GenSteadyStateVec(P, 1)
    p = GenPStruct(P, theta);
    
    % value in u is not used but EVALF require u as a parameter
    u = GenInputVec(P, 1);
    
    A = transpose(analyticJacobian(P, x, p, theta));
    
    num_excitations = 100
    B = zeros(4*P, num_excitations)
    
    for i = 1:num_excitations
        x = GenSteadyStateVec(P, i)     
        f = EVALF(x, p, u);
        B(:, i) = reshape(-cell2mat(f), [4*P, 1])
    end
    
    [L, U, Pe, X, Y] = solveSteadyState(A, B);    
    
end

function x = GenSteadyStateVec(P, seed)
    x = cell(P,1);
    
    rng(seed);
    rand_e = randi([0 20], 1, 4) * 10;
    rand_r = randi([0 20], 1, 4) * 10;
    
    x{1} = [6100; rand_e(1); 190; rand_r(1)];
    x{2} = [2500; rand_e(2); 350; rand_r(2)];
    x{3} = [7200; rand_e(3); 620; rand_r(3)];
    x{4} = [3400; rand_e(4); 860; rand_r(4)];
end
