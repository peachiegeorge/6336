function [L, U, Pe, X, Y] = testSolveSteadyState()

    % Generate Random Numbers That Are Repeatable
    rng('default');
    rng(3);

    P = 4;

    %theta = GenThetaMat(P, 'symmetric');
    theta = zeros(P, P)
    
    x = GenSteadyStateVec(P, 1)
    %p = GenPStruct(P, theta);
    p = GenSteadyPStruct(P, theta);
    
    % value in u is not used but EVALF require u as a parameter
    u = GenInputVec(P, 1);
    
    A = transpose(analyticJacobian(P, x, p, theta));
    
    num_excitations = 10
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

function p = GenSteadyPStruct(P, theta)
% Function to generate struct of parameters
% Set parameters for each node
% P: total number of nodes
% theta: matrix of thetas
% p: P x 1 cell array
p(P, 1).beta = 0;  % Initialize struct array

p(1,1).beta = 0.04;
p(1,1).sigma = 0.2;
p(1,1).gamma = 0.5;
p(1,1).nu = 0.1;
p(1,1).theta = theta(1,:); % Extract row for that node

p(2,1).beta = 0.05;
p(2,1).sigma = 0.3;
p(2,1).gamma = 0.4;
p(2,1).nu = 0.2;
p(2,1).theta = theta(2,:); % Extract row for that node

p(3,1).beta = 0.01;
p(3,1).sigma = 0.1;
p(3,1).gamma = 0.3;
p(3,1).nu = 0.3;
p(3,1).theta = theta(3,:); % Extract row for that node

p(4,1).beta = 0.01;
p(4,1).sigma = 0.3;
p(4,1).gamma = 0.2;
p(4,1).nu = 0.4;
p(4,1).theta = theta(4,:); % Extract row for that node

end

