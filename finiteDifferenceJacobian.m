function[Jf_u, Jf_x] = finiteDifferenceJacobian(f,x0,p,u0,epsX,epsU,doScalarEval)

numNodes = size(x0,1);   % # nodes
if doScalarEval
    numEquationsPerNode = 1;
    numEquations = size(x0,1);
else
    % Total # of equations in system
    numEquationsPerNode = size(x0{1},1);
    numEquations = size(x0,1)*numEquationsPerNode;
end

Jf_u = zeros(numEquations,numEquations);
Jf_x = zeros(numEquations,numEquations);

for node = 1:numNodes
    for eq = 1:numEquationsPerNode
        uStep = u0;
        xStep = x0;
        if doScalarEval
            uStep(node) = u0(node) + epsU;
            xStep(node) = x0(node) + epsX;
            fDiffU = feval(f,x0,p,uStep) - feval(f,x0,p,u0);
            fDiffX = feval(f,xStep,p,u0) - feval(f,x0,p,u0);
            Jf_u((node-1)*numEquationsPerNode+eq,:) = (1/epsU)*fDiffU;
            Jf_x((node-1)*numEquationsPerNode+eq,:) = (1/epsX)*fDiffX;
        else
            uStep{node}(eq) = u0{node}(eq) + epsU;
            xStep{node}(eq) = x0{node}(eq) + epsX;
            fDiffU = cellfun(@minus, feval(f,x0,p,uStep), feval(f,x0,p,u0), 'Un',0);
            fDiffX = cellfun(@minus, feval(f,xStep,p,u0), feval(f,x0,p,u0), 'Un',0);
            Jf_u((node-1)*numEquationsPerNode+eq,:) = (1/epsU) * cell2mat(fDiffU);
            Jf_x((node-1)*numEquationsPerNode+eq,:) = (1/epsX) * cell2mat(fDiffX);
        end
    end
end
end

