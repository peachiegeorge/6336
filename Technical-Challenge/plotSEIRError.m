function plotSEIRError(t_start, t_stop, expTimestep, expModelType,...
    percentErrorDayStateCell, sumPercentErrorDayState, populationErrorDayStateCell, sumPopulationErrorDayState)

    %%%%%% Error in Percentage %%%%%

    % Plot SEIR percent error curves for each node

    seir_ylabel = 'Error (%)';    
    yIsInteger = false;
    for i = 1:size(percentErrorDayStateCell,1)
        State = percentErrorDayStateCell(i,:);
        state = [State{1:end}];

        figure;
        plotSEIR(t_start, t_stop, state, seir_ylabel, yIsInteger);
        seirTitle = strcat('Error of ', expModelType, ' of Node ', num2str(i));
        title(seirTitle);     

    end

    f = figure;
    plotSEIR(t_start, t_stop, sumPercentErrorDayState, seir_ylabel, yIsInteger);
    seirTitle = strcat('Error of ', expModelType, ' of All Nodes');
    title(seirTitle);             
    formatFig(f);



    %%%%% Error as #Individuals %%%%%

    % Plot SEIR population error curves for each node

    seir_ylabel = 'Error (# Individuals)'; 
    yIsInteger = true;    
    for i = 1:size(populationErrorDayStateCell,1)
        State = populationErrorDayStateCell(i,:);
        state = [State{1:end}];

        figure; 
        plotSEIR(t_start, t_stop, state, seir_ylabel, yIsInteger); 
        seirTitle = strcat('Error of ', expModelType, ' of Node ', num2str(i));
        title(seirTitle);     
    end

    f = figure;
    plotSEIR(t_start, t_stop, sumPopulationErrorDayState, seir_ylabel, yIsInteger);
    seirTitle = strcat('Error of ', expModelType, ' of All Nodes');
    title(seirTitle);        
    formatFig(f);

end