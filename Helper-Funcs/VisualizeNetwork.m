function [gr, markerSizes, edgesCMap] = VisualizeNetwork(x,p)
persistent callIdx totMaxInit sMaxInit eMaxInit iMaxInit rMaxInit sInitFlow ...
    eInitFlow iInitFlow rInitFlow

DEF_MARK = 30;              % Default marker size
A = p(1).theta;             % Get theta matrix from any node to form adjacency matrix
xMat = [x{:}];               % Convert to matrix form [S1,S2,S3;...E1,E2,E3;...]
% xDiff = lastX - x;

% Get number of total individuals in each note
totVec = sum(xMat,1);	% Total number of individuals per community
tot = sum(totVec);		% Total number of individuals in the entire simulation
susVec = sum(xMat(1,:),1);
expVec = sum(xMat(2,:),1);
infVec = sum(xMat(3,:),1);
remVec = sum(xMat(4,:),1);

sInflow = p(1).theta.*xMat(1,:)';
eInflow = p(1).theta.*xMat(2,:)';
iInflow = p(1).theta.*xMat(3,:)';
rInflow = p(1).theta.*xMat(4,:)';

% outflowS = p(1).theta'.*Os;

if isempty(callIdx)
    totMaxInit = max(totVec);
    sMaxInit = max(susVec);
    eMaxInit = max(expVec);
    iMaxInit = max(infVec);
    rMaxInit = max(remVec);
    sInitFlow = max(sInflow(:));
    eInitFlow = max(eInflow(:));
    iInitFlow = max(iInflow(:));
    rInitFlow = max(rInflow(:));
end

% Sizes should be normalized to the initial values at first timestep
markerSizeTot = DEF_MARK*totVec./totMaxInit;
markerSizeSus = DEF_MARK*susVec./totMaxInit;
markerSizeExp = DEF_MARK*expVec./totMaxInit;
markerSizeInf = DEF_MARK*infVec./totMaxInit;
markerSizeRem = DEF_MARK*remVec./totMaxInit;
markerSizes = [markerSizeTot; markerSizeSus; markerSizeExp; markerSizeInf; markerSizeRem];

sInflowNorm = sInflow./sInitFlow;
eInflowNorm = eInflow./eInitFlow;
iInflowNorm = iInflow./iInitFlow;
rInflowNorm = rInflow./rInitFlow;

sMapIdx = ceil(sInflowNorm*256);
eMapIdx = ceil(eInflowNorm*256);
iMapIdx = ceil(iInflowNorm*256);
rMapIdx = ceil(rInflowNorm*256);

sEdgeCmap = getEdgeColor(sMapIdx);
eEdgeCmap = getEdgeColor(eMapIdx);
iEdgeCmap = getEdgeColor(iMapIdx);
rEdgeCmap = getEdgeColor(rMapIdx);

edgesCMap = cat(3, sEdgeCmap, eEdgeCmap, iEdgeCmap, rEdgeCmap);
gr = digraph(A);    % Generate directed graph
callIdx = 1;

% Estimate flows based on change in value of x
end

function edgeCmap = getEdgeColor(normInflows)
cmapIdx = normInflows';
cmapIdxVec = cmapIdx(:);
cmapIdxVec(cmapIdxVec >= 256) = 256;
cmapIdxNoDiag = cmapIdxVec(cmapIdxVec ~= 0);
cmap = jet;
edgeCmap = cmap(cmapIdxNoDiag,:);
end