function [P, x0SeirCell, p, u] = initializeCambridgeCommunities()

    rng(5);

    %Load Cambridge population
    load('cambridgeParams.mat');
    
    % Number of nodes
    P = 13;
    
    theta = GenThetaMat(P,'symmetric');
    
    p = GenPStruct(P, theta);
    u = GenInputVec(P, 1); % Linearization operating point, t=0

    % Initialize first state
    x0 = zeros(P*4, 1);
    for i = 1:13
        
        s_index = (i-1)*4 + 1;
        i_index = s_index + 2;
        
        %Initialize S as #people in Cambridge
        x0(s_index) = pop(i);
        
        %Initialize I = 1 for each node
        x0(i_index) = 1;
      
    end
    
    x0SeirCell = convertSeirMatToCell(x0);
    
end