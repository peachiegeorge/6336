function [x, r_norms] = testNewtonSolveSteadyState()

    % Generate Random Numbers That Are Repeatable
    rng('default');
    rng(3);

    P = 4;

%     theta = GenThetaMat(P, 'symmetric');
    theta = zeros(P, P);
    
    x = GenSteadyStateVec(P, 1)
    %p = GenPStruct(P, theta);
    p = GenSteadyPStruct(P, theta);
    
    % value in u is not used but EVALF require u as a parameter
    u = GenInputVec(P, 1);   
    
    num_excitations = 1
    B = zeros(4*P, num_excitations)
    
    for i = 1:num_excitations
        x = GenSteadyStateVec(P, i)     
        f = EVALF(x, p, u);
%         B(:, i) = reshape(-cell2mat(f), [4*P, 1])
        B(:, i) = - convertSeirCellToMat(f);
    end 
    
    %----- Continuous scheme
    cont_x0 = [];                       % Array to keep calculated x0 from continuous scheme
    x0 = GenSteadyStateInitialGuess(P);   % initial guess
    cont_q = [0.25:0.25:1];                % Array to keep q to be used in continuous scheme
    
    %Iterate through each q in the continuous scheme
    for q = cont_q  
        cont_x0 = [cont_x0, x0];                % Keep current initial guess to the list
        xf = newtonNdQ(x0, p, u, theta, q);     % Call Newton
        x0 = xf;                                % Assign initial guess for next Newton
    end
    
    disp('Finished Newton with x0 = ');
    disp(x0);
end








