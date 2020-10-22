function[Jf] = analyticJacobian(P, x, p, theta)

numNodes = size(x,1);
numVariables= size(x,1)*4;
Jf = zeros(numVariables);

% Calculate inter-community flows leaving  
sumInterFlowLeaving = zeros(numNodes, 1);
for node = 1:numNodes
    for neighbor = 1:numNodes
        sumInterFlowLeaving(node) = sumInterFlowLeaving(node) + theta(neighbor, node)
    end
end

for node = 1:numNodes
    for var = 1:4
        row = (node - 1)*4 + var;
        if(var == 1)
            % S variable
            % Calculate derivative contributions to home node
            homeCoeff = (p(node).beta * x{node}(3));
%             Jf(row,row) = - homeCoeff;
%             Jf(row,row+1) = homeCoeff;

            Jf(row,row) = p(node).mu - p(node).nu - homeCoeff - sumInterFlowLeaving(node);
            Jf(row,row+1) = homeCoeff;            
            
            % Calculate controbution to other nodes
            for nextNode = 1:numNodes-1
                if(nextNode ~= node)
                    nextSCol = (nextNode - 1)*4 + 1;
                    Jf(row,nextSCol) = theta(node,nextNode);
                end
            end
            
        elseif(var == 2)
            % E variable
            % Calculate derivative contributions to home node
            homeCoeff = (p(node).sigma);
%             Jf(row,row) = - homeCoeff;
%             Jf(row,row+1) = homeCoeff;
            
            Jf(row,row) = - homeCoeff - p(node).nu - sumInterFlowLeaving(node);
            Jf(row,row+1) = homeCoeff;              

            % Calculate controbution to other nodes
            for nextNode = 1:numNodes-1
                if(nextNode ~= node)
                    nextECol = (nextNode - 1)*4 + 2;
                    Jf(row,nextECol) = theta(node,nextNode);
                end
            end
            
        elseif(var == 3)
            % I variable
            % Involved both in susceptiblity and home coeff
            % Calculate derivative contributions to home node
            homeCoeff = (p(node).gamma);
%             Jf(row,row) = - homeCoeff;
            Jf(row,row) = - homeCoeff - p(node).nu - sumInterFlowLeaving(node);
            Jf(row,row+1) = homeCoeff;
            
            % susceptible contribution
            sCoeff = (p(node).beta * x{node}(1))
            Jf(row,row-2) = - sCoeff;
            Jf(row,row-1) = sCoeff;
            
            % Calculate controbution to other nodes
            for nextNode = 1:numNodes-1
                if(nextNode ~= node)
                    nextICol = (nextNode - 1)*4 + 3;
                    Jf(row,nextICol) = theta(node,nextNode);
                end
            end
        elseif(var == 4)
            % R Variable
            % Calculate derivative contributions to home node
            homeCoeff = (p(node).nu);
            Jf(row,row) = - homeCoeff;           
        end
    end
    
end