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
p(1,1).mu = 0.001;
p(1,1).nu = 0.1;
% p(1,1).theta = theta(1,:); % Extract row for that node
p(1,1).theta = theta;

p(2,1).beta = 0.05;
p(2,1).sigma = 0.3;
p(2,1).gamma = 0.4;
p(2,1).mu = 0.001;
p(2,1).nu = 0.2;
% p(2,1).theta = theta(2,:); % Extract row for that node
p(2,1).theta = theta;

p(3,1).beta = 0.01;
p(3,1).sigma = 0.1;
p(3,1).gamma = 0.3;
p(3,1).mu = 0.001;
p(3,1).nu = 0.3;
% p(3,1).theta = theta(3,:); % Extract row for that node
p(3,1).theta = theta;

p(4,1).beta = 0.01;
p(4,1).sigma = 0.3;
p(4,1).gamma = 0.2;
p(4,1).mu = 0.001;
p(4,1).nu = 0.4;
% p(4,1).theta = theta(4,:); % Extract row for that node
p(4,1).theta = theta;

end