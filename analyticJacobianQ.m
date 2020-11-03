function[Jf] = analyticJacobian(x, p, theta, q)

numNodes = size(x,1);
numVariables= size(x,1)*4;
Jf = zeros(numVariables);

% Calculate inter-community flows leaving  
sumInterFlowLeaving = zeros(numNodes, 1);
for node = 1:numNodes
    for neighbor = 1:numNodes
        sumInterFlowLeaving(node) = sumInterFlowLeaving(node) + theta(neighbor, node);
    end
end

for node = 1:numNodes
    for var = 1:4
        row = (node - 1)*4 + var;
        if(var == 1)
            % S variable
            % Calculate derivative contributions to home node
%             homeCoeff = p(node).beta * x{node}(3);
%             Jf(row,row) = - homeCoeff;
%             Jf(row,row+1) = homeCoeff;

            Jf(row,row) = q * (p(node).mu - p(node).nu - (p(node).beta * x{node}(3)) - sumInterFlowLeaving(node)) + (1 - q);
            Jf(row,row+1) = q * (p(node).beta * x{node}(3));            
            
            % Calculate controbution to other nodes
            for nextNode = 1:numNodes-1
                if(nextNode ~= node)
                    nextSCol = (nextNode - 1)*4 + 1;
                    Jf(row,nextSCol) = q * theta(node,nextNode);
                end
            end
            
        elseif(var == 2)
            % E variable
            % Calculate derivative contributions to home node
%             homeCoeff = p(node).sigma;
%             Jf(row,row) = - homeCoeff;
%             Jf(row,row+1) = homeCoeff;
            
            Jf(row,row) = q * (- p(node).sigma - p(node).nu - sumInterFlowLeaving(node)) + (1 - q);
            Jf(row,row+1) = q * p(node).sigma;              

            % Calculate controbution to other nodes
            for nextNode = 1:numNodes-1
                if(nextNode ~= node)
                    nextECol = (nextNode - 1)*4 + 2;
                    Jf(row,nextECol) = q * theta(node,nextNode);
                end
            end
            
        elseif(var == 3)
            % I variable
            % Involved both in susceptiblity and home coeff
            % Calculate derivative contributions to home node
%             homeCoeff = p(node).gamma;
%             Jf(row,row) = - homeCoeff;
%             Jf(row,row+1) = homeCoeff;

            Jf(row,row) = q * (- p(node).gamma - p(node).nu - sumInterFlowLeaving(node)) + (1 - q);
            Jf(row,row+1) = q * p(node).gamma;
            
            % susceptible contribution
            sCoeff = p(node).beta * x{node}(1);
            Jf(row,row-2) = q * (- sCoeff);
            Jf(row,row-1) = q * sCoeff;
            
            % Calculate controbution to other nodes
            for nextNode = 1:numNodes-1
                if(nextNode ~= node)
                    nextICol = (nextNode - 1)*4 + 3;
                    Jf(row,nextICol) = q * theta(node,nextNode);
                end
            end
        elseif(var == 4)
            % R Variable
            % Calculate derivative contributions to home node
            Jf(row,row) = q * (- p(node).nu) + (1 - q);           
        end
    end  
end

Jf = transpose(Jf);

end