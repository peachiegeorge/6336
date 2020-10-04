function[Jf_u, Jf_x] = finiteDifferenceJacobian()

P = 100;    % # nodes simulated
theta = GenThetaMat(P, 'symmetric');
x = GenStateVec(P, 'else'); % Operating point is about 0
p = GenPStruct(P,theta);
u = GenInputVec(P, 0); % t = 0 input 
epsilonX = cell(P,1);
epsilonU = cell(P,1);
for i = 1:P
        epsilonX{i} = ones(4,1);
        epsilonU{i} = ones(4,1);
end

numNodes = size(x,1);
numEquations= size(x,1)*4;

Jf_u = zeros(numEquations,numEquations);
Jf_x = zeros(numEquations,numEquations);


for ind = 1:numNodes
    for eq = 1:4
        uStep = u;
        uStep{ind}(eq) = uStep{ind}(eq) + epsilonU;
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

