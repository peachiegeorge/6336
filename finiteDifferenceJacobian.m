function[Jf_u, Jf_x] = finiteDifferenceJacobian(x,p,u)
epsilonX = 1;
epsilonU = 1;

numNodes = size(x,1);
numEquations= size(x,1)*4;

Jf_u = zeros(numEquations,numEquations);
Jf_x = zeros(numEquations,numEquations);

for ind = 1:numNodes
    for eq = 1:4
        uStep = u;
        uStep{ind}(eq) = u{ind}(eq) + epsilonU;
        xStep = x;
        xStep{ind}(eq) = x{ind}(eq) + epsilonX;
        fDiffU = cellfun(@minus, EVALF(x,p,uStep), EVALF(x,p,u),'Un',0);
        fDiffX = cellfun(@minus, EVALF(xStep,p,u), EVALF(x,p,u),'Un',0);
        Jf_u((ind-1)*4+eq,:) = (1/epsilonU) * cell2mat(fDiffU);
        Jf_x((ind-1)*4+eq,:) = (1/epsilonX) * cell2mat(fDiffX);
        %disp(Jf(:,(ind-1)*4+eq));
    end
end
end

