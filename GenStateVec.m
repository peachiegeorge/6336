function x = GenStateVec(P, method)
% Initialize states for all nodes
% P: total number of nodes
% x: P x 1 cell array
x = cell(P,1);
for i = 1:length(x)
    if method == "sameIC"
        x{i} = 100*ones(4,1);
    elseif method == "random"
        x{i} = 1000*rand(4,1);
    else
        x{i} = zeros(4,1);
    end
end
end
