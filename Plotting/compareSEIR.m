function compareSEIR(fig,y1,y2,dt)
lineColors = {'#0072BD', '#D95319', '#EDB120', '#7E2F8E'};
tVec = dt*(1:size(y1,2));
hold on;
for i = 2:3
    plot(fig.CurrentAxes,tVec,y1(i,:),'--','color',lineColors{i},'linewidth',1.5);
end

for i = 2:3
    plot(fig.CurrentAxes,tVec,y2(i,:),'color',lineColors{i},'linewidth',1.5);
end
hold off;

legend('Exposed (No measures)','Infected (No measures)','Exposed (Measures)','Infected (Measures)');