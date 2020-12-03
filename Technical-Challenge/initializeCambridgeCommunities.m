function [P, x0SeirCell, p, u] = initializeCambridgeCommunities()
    
    % Number of nodes
    P = 13;
    
    x0SeirCell = GenStateVec(P, 'MIToutbreak');
    theta = GenThetaMat(P, 'cutOffMultiple', 0); 
    p = GenPStruct(P, theta, 'cutOffMultiple', 'cambridgeParams.mat');    
    u = GenInputVec(P, 1); %With t ~= 0, no input
     
end