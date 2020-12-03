function plotSEIR(t_start, t_stop, state, seir_ylabel, yIsInteger)
    hold on;
    days = linspace(t_start, t_stop, length(state(1,1:end)));
    pl = plot(days, state(1,1:end), 'LineWidth', 2);
    
    if yIsInteger
        ax = ancestor(pl, 'axes');
        ax.YAxis.Exponent = 0;
        ytickformat(ax, '%d');  
    end
    
    plot(days, state(2,1:end), 'LineWidth', 2);    
    plot(days, state(3,1:end), 'LineWidth', 2);    
    plot(days, state(4,1:end), 'LineWidth', 2);
    hold off;
    
    xlabel('Days');
    ylabel(seir_ylabel);
    legend('S','E','I','R');
end