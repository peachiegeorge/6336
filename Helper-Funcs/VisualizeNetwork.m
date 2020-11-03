function [gr markerSizes] = VisualizeNetwork(x,p)
persistent callIdx totMaxInit sMaxInit eMaxInit iMaxInit rMaxInit
DEF_MARK = 30;              % Default marker size
A = p(1).theta;             % Get theta matrix from any node to form adjacency matrix
xMat = [x{:}];               % Convert to matrix form [S1,S2,S3;...E1,E2,E3;...]

% Get number of total individuals in each note
totVec = sum(xMat,1);	% Total number of individuals per community
tot = sum(totVec);		% Total number of individuals in the entire simulation
susVec = sum(xMat(1,:),1);
expVec = sum(xMat(2,:),1);
infVec = sum(xMat(3,:),1);
remVec = sum(xMat(4,:),1);

if isempty(callIdx)
	totMaxInit = max(totVec);
	sMaxInit = max(susVec);
	eMaxInit = max(expVec);
	iMaxInit = max(infVec);
	rMaxInit = max(remVec);
end

% Sizes should be normalized to the initial values at first timestep
markerSizeTot = DEF_MARK*totVec./totMaxInit;
markerSizeSus = DEF_MARK*susVec./sMaxInit;
markerSizeExp = DEF_MARK*expVec./eMaxInit;
markerSizeInf = DEF_MARK*infVec./iMaxInit;
markerSizeRem = DEF_MARK*remVec./rMaxInit;
markerSizes = [markerSizeTot; markerSizeSus; markerSizeExp; markerSizeInf; markerSizeRem];

gr = digraph(A);    % Generate directed graph
callIdx = 1;
end