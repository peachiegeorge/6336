function f = geovisSEIR(x)
f = figure;
xS = x(1:4:end,:);
xE = x(2:4:end,:);
xI = x(3:4:end,:);
xR = x(4:4:end,:);
dt = 0.5;
step = 1/dt;
cambridge = readtable('Cambridge/cam.xlsx');
b = geobubble(cambridge.lat,cambridge.lon,xI(:,1),'BubbleColorList',[0.9290, 0.6940, 0.1250]);
sizeMax = max(max(xI));
sizeMin = min(min(xI));
b.SizeLimits = [floor(sizeMin) floor(sizeMax)];
b.BubbleWidthRange = [1 20];
for i = 1:(1/dt):size(xS,2)
    b.SizeData = xI(:,i);
    b.SizeLegendTitle = '# Infected';
    title(sprintf('Cambridge, MA, t = %.1f days',(i+step-1)*dt));
    grid off;
    drawnow;
end
end

