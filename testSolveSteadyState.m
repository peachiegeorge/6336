function [L, U, Pe, X, Y] = testSolveSteadyState()
%     P = 4;
%     A = analyticJacobian(P);
%     B = transpose([1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1; 
%         2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2; 
%         3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3; 
%         4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4]);
%     
%     [L, U, Pe, X, Y] = solveSteadyState(A, B);

    % Generate Random Numbers That Are Repeatable
    rng('default');
    rng(2);

    P = 4;

    %theta = GenThetaMat(P, 'symmetric');
    theta = zeros(P, P)
    
    x = GenStateVec(P, '');
    p = GenPStruct(P,  theta);
    u = GenInputVec(P, 0);
    x = u;
    f = EVALF(x, p, u);
    
    A = analyticJacobian(P, x, p, u, f, theta);
    
    num_excitations = 1
    B = zeros(4*P, num_excitations)
    
    for i = 1:num_excitations
        %u = GenInputVec(P, 0);     
        f = EVALF(x, p, u);
        B(:, i) = reshape(-cell2mat(f), [4*P, 1])
    end
    
    [L, U, Pe, X, Y] = solveSteadyState(A, B);    
    
end

% function A = GenMatrixA(P, p)
% 
%     A = zeros(4*P, 4*P)
%     theta = GenLinearThetaMat(P)
%     p = GenLinearPStruct(P, theta)
%     
%     for i = 1:P % For each node
%         
%         A(i,i) = - p(i).beta;
%         
%         for j = 1:P
%            if i ~= j
%                A(i,j) = p(i).theta(i,j)
%            else
%                % Row of S
%                if mod(i, 4) == 1
%                    
%                % Row of E
%                elseif mod(i, 4) == 2
%                
%                % Row of I
%                elseif mod(i, 4) == 3
%                
%                % Row of R
%                elseif mod(i, 4) == 0
%                    
%                end
%            end
%         end
%         
%         p(i).theta;
%         p(i).sigma;
%         p(i).gamma;
%     end
% end
% 
% function theta = GenLinearThetaMat(P)
% % Function to generate matrix of thetas given # of nodes
% % P: total number of nodes
% % theta: P x P matrix of theta parameters
% theta = zeros(P, P);
% 
% function p = GenLinearPStruct(P, theta)
% % Function to generate struct of parameters
% % Set parameters for each node
% % P: total number of nodes
% % theta: matrix of thetas
% % p: P x 1 cell array
% p(P, 1).beta = 0;  % Initialize struct array
% for i = 1:P
%     p(i,1).beta = 0.009;
%     p(i,1).sigma = 0.1;
%     p(i,1).gamma = 0.1;
%     p(i,1).theta = theta(i,:); % Extract row for that node
% end