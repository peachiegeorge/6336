function p = GenPStruct(P,theta,method,saveFile)
% Function to generate struct of parameters
% Set parameters for each node
% P: total number of nodes
% theta: matrix of thetas
% p: P x 1 cell array
% Parameters from https://link.springer.com/article/10.1007/s11071-020-05743-y#Sec3
NORM_FACT = 1;
thetaOG = theta;
%load(saveFile);
%load('cambridgeParams');
p(P, 1).beta = 0;  % Initialize struct array
betaVal = [10,20,1,5,5,1,1,1,1,1,1,1,1];

if(method == "noMeasures")
    for i = 1:P
        p(i,1).beta = betaVal(i) / NORM_FACT; %[days^-1 person^1]
        p(i,1).sigma = 1/14; %[days^-1]
        p(i,1).gamma = 1/10; %[days^-1]
        p(i,1).mu = 1e-4;   % Community birth rate [days^-1]
        p(i,1).nu = 1e-4;   % Community death rate [days^-1]
        p(i,1).theta = thetaOG; % Extract row for that node
    end
elseif(method == "cutOffMultiple" && P > 1)
    for i = 1:P
        p(i,1).beta = betaVal(i) / NORM_FACT; %[days^-1 person^1]
        p(i,1).sigma = 1/14; %[days^-1]
        p(i,1).gamma = 1/10; %[days^-1]
        p(i,1).mu = 1e-4;   % Community birth rate [days^-1]
        p(i,1).nu = 1e-4;   % Community death rate [days^-1]
        p(i,1).theta = thetaOG; % Extract row for that node
    end
    p(1,1).beta = 0.5*p(1,1).beta;
    p(2,1).beta = 0.5*p(2,1).beta;
    p(5,1).beta = 0.5*p(5,1).beta;
elseif(method == "noTravel")
    for i = 1:P
        p(i,1).beta = betaVal(i) / NORM_FACT; %[days^-1 person^1]
        p(i,1).sigma = 1/14; %[days^-1]
        p(i,1).gamma = 1/10; %[days^-1]
        p(i,1).mu = 1e-4;   % Community birth rate [days^-1]
        p(i,1).nu = 1e-4;   % Community death rate [days^-1]
        p(i,1).theta = theta; % Extract row for that node
    end
else
    disp('Not a valid case for GenPStruct.');
end

