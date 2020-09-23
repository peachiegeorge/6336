function p = GenPStruct(P,theta)
% Function to generate struct of parameters
% Set parameters for each node
% P: total number of nodes
% theta: matrix of thetas
% p: P x 1 cell array
p(P, 1).beta = 0;  % Initialize struct array
for i = 1:P
    p(i,1).beta = 0.05;
    p(i,1).sigma = 0.1;
    p(i,1).gamma = 0.03;
    p(i,1).theta = theta(i,:); % Extract row for that node
end