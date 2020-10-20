function p = GenPStruct(P,theta)
% Function to generate struct of parameters
% Set parameters for each node
% P: total number of nodes
% theta: matrix of thetas
% p: P x 1 cell array
% Parameters from https://link.springer.com/article/10.1007/s11071-020-05743-y#Sec3
p(P, 1).beta = 0;  % Initialize struct array
for i = 1:P
    p(i,1).beta = 0.01; %[days^-1 person^1]
    p(i,1).sigma = 0.1; %[days^-1]
    p(i,1).gamma = 0.1; %[days^-1]
    p(i,1).mu = 1e-4;   % Community birth rate [days^-1]
    p(i,1).nu = 1e-4;   % Community death rate [days^-1]
    p(i,1).theta = theta; % Extract row for that node
end