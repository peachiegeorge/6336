function [maxE,maxI] = getMaxVals(x)
% getMaxVals Calculates the maximum E and I given an SEIR state
maxE = max(x(2,:));
maxI = max(x(3,:));
end

