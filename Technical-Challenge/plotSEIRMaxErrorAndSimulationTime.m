function plotSEIRMaxErrorAndSimulationTime(trapMaxPercentError, trapSimulationTime,...
                                            feMaxPercentError, feSimulationTime)
            

    f = figure;


    
    hold on;
     
    fePl = plot(feMaxPercentError, feSimulationTime, '-rs',...
                'LineWidth', 2, ...
                'MarkerSize', 10,...
                'MarkerEdgeColor', 'r',...
                'MarkerFaceColor', 'r')     
    
    trapPl = plot(trapMaxPercentError, trapSimulationTime, '-go',...
                'LineWidth', 2, ...
                'MarkerSize', 10,...
                'MarkerEdgeColor', 'g',...
                'MarkerFaceColor', 'g') 
          
    hold off;
    
    
    xlabel('Error (%)', 'FontWeight', 'bold');
    ylabel('Total Simulation Time (s)', 'FontWeight', 'bold');
    legend('Forward Euler', 'Trapezoidal');   
    
    trapLabels = {'0.05 day', '0.1 day', '0.2 day', 'adaptive', '0.5 day'};
    text(trapMaxPercentError, trapSimulationTime, trapLabels,...
            'FontSize', 12);

    feLabels = {'0.0001 day', '0.0005 day', '0.001 day', '0.002 day'};
    text(feMaxPercentError, feSimulationTime, feLabels,... 
            'VerticalAlignment','bottom', 'HorizontalAlignment', 'left',...
            'FontSize', 12);   
    
    set(gca,'Xtick',0:2:16);
    set(gca,'Ytick',0:100:800);
    
    axis([0 16 0 800]);
    
%     rectangle('Position',[0,0,3,300],'FaceColor',[0 .5 .5],...
%     'EdgeColor','b',...
%     'LineWidth',3)




    
    grid on;
    grid minor;

    box on;
    
    f.CurrentAxes.FontSize = 15;
end

