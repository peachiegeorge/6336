function[Jf] = finiteDifferenceJacobian()

P = 100;    % # nodes simulated
theta = GenThetaMat(P);
x = GenStateVec(P);
p = GenPStruct(P,theta);
u = GenInputVec(P);
epsilon = 0.01;
    
numNodes = size(x,1);
numEquations= size(x,1)*4;

Jf = zeros(numEquations,numEquations);

for ind = 1:numNodes
     
    for eq = 1:4
       
    uStep = u;
    uStep{ind}(eq) = uStep{ind}(eq)+epsilon;
    
    fDiff = cellfun(@minus,EVALF(x,p,uStep), EVALF(x,p,u),'Un',0);
    
    Jf((ind-1)*4+eq,:) = (1/epsilon) * cell2mat(fDiff);
    %disp(Jf(:,(ind-1)*4+eq));
    end
end

function theta = GenThetaMat(P)
% Function to generate matrix of random thetas given # of nodes
% For future implementation: parameterize beta using gravitational or
% radiation model.
% P: total number of nodes
% theta: P x (P-1) matrix of theta parameters
NORM_FACT = 5; % Maximum possible travel per unit time
theta = zeros(P,P-1);
for m = 1:P
    for n = 1:P-1
        if m ~= n
            theta(m,n) = rand(1)/NORM_FACT;
        end
    end
end
end

function x = GenStateVec(P)
% Initialize states for all nodes
% P: total number of nodes
% x: P x 1 cell array
x = cell(P,1);
end

function p = GenPStruct(P,theta)
% Function to generate struct of parameters
% Set parameters for each node
% P: total number of nodes
% theta: matrix of thetas
% p: P x 1 cell array
for i = 1:P
   p(i,1).beta = 0.05;
   p(i,1).sigma = 0.1;
   p(i,1).gamma = 0.03;
   p(i,1).theta = theta(i,:); % Extract row for that node
end
end

function u = GenInputVec(P)
% Function to generate vector of inputs
% P: total number of nodes
% u: P x 1 cell array of inputs
N_MAX = 500; % Max number of people per node
I_MAX = 5;  % Max number of infected people per node
N0 = round(N_MAX*rand(P,1));   % Initial population
I0 = round(I_MAX*rand(P,1));    % Initial infected

% If N0 < I0, reduce # of infected
idxOfLessThan = N0<I0;
reduceAmnt = round(I_MAX*rand(length(I0(N0<I0)),1));
I0(N0<I0) = I0(N0<I0) - round(I0(N0<I0));
uM = [N0-I0, zeros(P,1), I0, zeros(P,1)]';
u = num2cell(uM,1)';
end
end

