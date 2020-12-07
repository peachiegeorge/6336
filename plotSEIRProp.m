function [fY fX] = plotSEIRProp(fig,y,x,dt,figTitle)
%% Plot all neighborhood proportions
% y is a  4 x num_time_steps matrix
% x is a 4P x num_time_steps matrix
xS = x(1:4:end,:);
xE = x(2:4:end,:);
xI = x(3:4:end,:);
xR = x(4:4:end,:);
numTimeSteps = size(xS,2);
tVec = dt*[1:numTimeSteps];
fX = fig;
if size(x,1) == 52
    % Means 13 neighborhoods simulated
    t1 = tiledlayout(5,3);
    t1.TileSpacing = 'compact';
    for i = 1 : 13
        nexttile;
        nhx = [xS(i,:)' xE(i,:)' xI(i,:)' xR(i,:)'];
        area(tVec,nhx)
        title([sprintf('Neighborhood %i',i)]);
        axis tight;
        ylabel('# Individuals');
        xlabel('Days');
    end
    % Plot the summed neighborhoods
%     fY = figure;
%     nhy = [y(1,:)' y(2,:)' y(3,:)' y(4,:)'];
%     area(tVec,nhy)
%     title([figTitle ':Summed Neighborhoods']);
%     axis tight;
%     ylabel('# Individuals');
%     xlabel('Days');
%     legend('S','E','I','R')
else
    % One neighborhood simulated
    nh = [xS' xE' xI' xR'];
    area(tVec,nh)
    title(figTitle);
    axis tight;
    ylabel('# Individuals');
    xlabel('Days');
    legend('S','E','I','R')
    fY = fX;
end
end