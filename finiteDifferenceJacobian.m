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
end

