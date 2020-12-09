function formatFig(f,pos,numYAxisTicks)
% Set font sizes
f.CurrentAxes.FontSize = 20;
set(f,'Position', pos);
f.CurrentAxes.Title.String = {};   % Remove title
% Set linewidths to 2
if ~isempty(f.Children(2).Children(1))
	f.Children(2).Children(1).LineWidth = 2;
	f.Children(2).Children(2).LineWidth = 2;
	f.Children(2).Children(3).LineWidth = 2;
	f.Children(2).Children(4).LineWidth = 2;
end

% Set tick marks so they don't change upon exporting
f.CurrentAxes.XTickMode = 'manual';
f.CurrentAxes.YTickMode = 'manual';
ax = gca(f);
ax.YAxis.Exponent = 0;
dTick = ax.YTick(end) / numYAxisTicks;
ax.YTick = 0 : dTick : max(ax.YLim);
% ax.YLim = 
% Save figure as .png
print(f,'-dpng');
end