function theta = GenSteadyThetaMat(P)
    
    theta = zeros(P,P);
    
    %Incoming flow to node 1
    theta(1,2) = 0.012;
    theta(1,3) = 0.013;
    
    %Incoming flow to node 2
    theta(2,4) = 0.024;

    %Incoming flow to node 3
    theta(3,1) = 0.031;    
    
    %Incoming flow to node 4
    theta(4,1) = 0.041;
    theta(4,3) = 0.043;        
end