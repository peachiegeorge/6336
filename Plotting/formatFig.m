function formatFig(f)
% Set font sizes
f.CurrentAxes.FontSize = 20
set(f,'Position', [680   558   560   420]);
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

% Save figure as .png
print(f,'-dpng');
end