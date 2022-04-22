%% axest
function makepretty_axes(xname,yname)
xlabel(xname)
ylabel(yname)
ax = gca;
ax.LineWidth = 1.2;
ax.FontSize = 18;
box on
ax.TickDir = 'both';
ax.TickLength = [0.009 0.009];
ax.XGrid = 'on';
ax.YGrid = 'on';
ax.GridLineStyle = '--';
ax.GridAlpha = 0.1;
ax.FontName = 'Helvetica Neue';







