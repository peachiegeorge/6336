function x = GenStateVec(P, method)
% Initialize states for all nodes
% P: total number of nodes
% x: P x 1 cell array
x = cell(P,1);
N = 12000;  % Total est. population of Cambridge, MA
c = 12;     % # of neighborhoods in Cambridge
for i = 1:length(x)
    if method == "sameIC"
        x{i} = 100*ones(4,1);
%         x{i}(2) = 0;
%         x{i}(4) = 0;
    elseif method == "random"
        x{i} = (N/c)*rand(4,1);
%         x{i}(2) = 0;
%         x{i}(4) = 0;
    elseif method == "zeros"
        x{i} = zeros(4,1);
    end
end
end
