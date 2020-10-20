function x = GenStateVec(P, method)
% Initialize states for all nodes
% P: total number of nodes
% x: P x 1 cell array
x = cell(P,1);
N = 110e3;  % Total est. population of Cambridge, MA
c = 12;     % # of neighborhoods in Cambridge
for i = 1:length(x)
    if method == "sameIC"
        x{i} = (N/c)*ones(4,1);
        x{i}(2:end) = [0 0 0];
    elseif method == "random"
        x{i} = (N/c)*rand(4,1);
        x{i}(2:end) = [0 0 0];
    else
        x{i} = zeros(4,1);
    end
end
end
