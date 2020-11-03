function [gr markerSizes] = VisualizeNetwork(x,p)
DEF_MARK = 30;              % Default marker size
A = p(1).theta;             % Get theta matrix from any node to form adjacency matrix
xMat = [x{:}];               % Convert to matrix form [S1,S2,S3;...E1,E2,E3;...]

% Get number of total individuals in each note
totVec = sum(xMat,1);
tot = sum(totVec);
susVec = sum(xMat(1,:),1);
expVec = sum(xMat(2,:),1);
infVec = sum(xMat(3,:),1);
remVec = sum(xMat(4,:),1);

% Normalize to 4
markerSizeTot = DEF_MARK*totVec;
markerSizeSus = DEF_MARK*susVec;
markerSizeExp = DEF_MARK*expVec;
markerSizeInf = DEF_MARK*infVec;
markerSizeRem = DEF_MARK*remVec;
markerSizes = [markerSizeTot; markerSizeSus; markerSizeExp; markerSizeInf; markerSizeRem]./tot;

gr = digraph(A);    % Generate directed graph



end