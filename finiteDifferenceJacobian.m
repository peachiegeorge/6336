function[Jf_u, Jf_x] = finiteDifferenceJacobian(f,x,p,u,epsX,epsU,doScalarEval)

numNodes = size(x,1);
if iscell(x)
    numEquations= size(x,1)*size(x{1},1);
else
    numEquations = size(x,1);
end

Jf_u = zeros(numEquations,numEquations);
Jf_x = zeros(numEquations,numEquations);

for ind = 1:numNodes
    for eq = 1:numEquations
        uStep = u;
        if size(u) > 1
            % Vector
            uStep{ind}(eq) = u{ind}(eq) + epsU;
        else
            % Scalar
            uStep = u + epsU;
        end
        xStep = x;
        if size(x) > 1
            % Vector
            xStep{ind}(eq) = x{ind}(eq) + epsX;
        else
            % Scalar
            xStep = x + epsX;
        end
        if doScalarEval
            fDiffX = feval(f,xStep) - feval(f,x);
            Jf_x = (1/epsX)*fDiffX;
            Jf_u = [];
        else
            fDiffU = cellfun(@minus, feval(f,x,p,uStep), feval(f,x,p,u), 'Un',0);
            fDiffX = cellfun(@minus, feval(f,xStep,p,u), feval(f,x,p,u), 'Un',0);
            Jf_u((ind-1)*4+eq,:) = (1/epsU) * cell2mat(fDiffU);
            Jf_x((ind-1)*4+eq,:) = (1/epsX) * cell2mat(fDiffX);
        end

    end
end
end

