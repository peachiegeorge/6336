function x = GenStateVec(P)
% Initialize states for all nodes
% P: total number of nodes
% x: P x 1 cell array
x = cell(P,1);
for i = 1:length(x)
   x{i} = zeros(4,1); 
end
end
