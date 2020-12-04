function plotSEIRTestCase(t_start, t_stop, matState, model_type, timestep_desc, seir_ylabel)

    yIsInteger = true;

    % Convert SEIR matrix time series to cell
    for i = 1:size(matState,2)   
        X(:,i) = convertSeirMatToCell(matState(:,i));   
    end

    % Plot SEIR curves for each node
    for i = 1:size(X,1)

        State = X(i,:);
        state = [State{1:end}];

        N(i,:) = sum(state, 1);

%         figure;
%         plotSEIR(t_start, t_stop, state, seir_ylabel, yIsInteger);
%         seir_title = strcat(model_type, ' Simulation with ', timestep_desc, ' of Node', ' ', num2str(i));
%         title(seir_title);

        if i == 1
            sumState = state;     
        else
            sumState = sumState + state;     
        end
    end

    %Sum SEIR across all nodes
    f = figure;
    plotSEIR(t_start, t_stop, sumState, seir_ylabel, yIsInteger);
    formatFig(f);

    %N of each node
%     figure;
%     imagesc(N(:,:));
%     title(['N(t) of ', model_type, ' Simulation with ', timestep_desc]);
%     xlabel('Timestep');
%     ylabel('Node');
%     colorbar;
    
end