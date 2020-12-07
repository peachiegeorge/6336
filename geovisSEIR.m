function f = geovisSEIR(fig,x,dt,p,speed,plotEdges,figTitle,table)
% f = fig;
xS = x(1:4:end,:);
xE = x(2:4:end,:);
xI = x(3:4:end,:);
xR = x(4:4:end,:);
step = 1/dt;
p = p(1);	% Just take single neighborhood if there are multiple

if plotEdges
    % Find row,col pairs in upper triangular of theta above first superdiagonal
    ut = triu(p.theta,1);
    [r, c] = find(ut);
    edgeIdxPair = [r c];
    edgeCoords = getLatLon(table, edgeIdxPair);
    
    % Generate lookup table
    Cmap = colormap('jet');
    thetaMax = max(abs(ut(:)));
    cmapIdx = floor(size(Cmap,1)*ut(ut~=0)./thetaMax);
    cmapIdx(cmapIdx == 0) = cmapIdx(cmapIdx == 0) + 1;
    
    % Plot edges
    numEdges = size(edgeCoords{1},1);
    geoaxes;
    for i = 1:numEdges
        geoplot(edgeCoords{1}(i,:),edgeCoords{2}(i,:),'LineWidth',0.1,'Color',Cmap(cmapIdx(i),:));
        hold on;
    end
    colorbar;
    title(figTitle);
else
    % Plot nodes
    bnodes = geobubble(table.lat,table.lon,xI(:,1),'BubbleColorList',[0.9290, 0.6940, 0.1250],'basemap','topographic');
    sizeMax = max(max(xI));
    sizeMin = min(min(xI));
    bnodes.SizeLimits = [floor(sizeMin) floor(sizeMax)];
    bnodes.BubbleWidthRange = [1 20];
    bnodes.ZoomLevel = 13.375;
    set(gcf,'position',[389 165 1129 741]);
%     geolimits(1.005*[42.3559, 42.3974], 1.005*[-71.1547, -71.0772]);
    % Animation
    for i = 1:(1/(dt*speed)):size(xS,2)  
        bnodes.SizeData = xI(:,i);
        bnodes.SizeLegendTitle = '# Infected';
        title([figTitle sprintf(', Cambridge, MA, t = %.1f days',(i+step-1)*dt*speed)]);
        grid off;
        drawnow;
    end
end
end

%% Functions
function edgeCoords = getLatLon(tbl, edgeIdxPair)
% Table contains the longitude and latitude coordinates
% edgeIdxPair are pairs of indices for nonzero values in upper superdiagonal of theta
% edgeCoords is a cell array
rLats = [tbl.lat(edgeIdxPair(:,1)), tbl.lat(edgeIdxPair(:,2))];	% Get lat/lon for row indices
cLong = [tbl.lon(edgeIdxPair(:,1)), tbl.lon(edgeIdxPair(:,2))];	% Get lat/lon for col indices
edgeCoords = {rLats cLong};
end
