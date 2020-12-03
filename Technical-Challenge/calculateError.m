%Calculate Error between Reference and Experiment Model
function [percentErrorDayStateCell, sumPercentErrorDayState,...
    populationErrorDayStateCell, sumPopulationErrorDayState] = calculateError(expDtType, refTimestep, expTimestep, refState, expState)
    
    
    %c as a coefficient matrix to sum SEIR across all nodes
    P = 13;
    c = zeros(4, P*4);
    for i=1:P
        c(1, (i-1)*4 + 1) = 1;
        c(2, (i-1)*4 + 2) = 1;
        c(3, (i-1)*4 + 3) = 1;
        c(4, (i-1)*4 + 4) = 1;
    end   
    
    %%%%% Get SEIR State at the end of each day %%%%%
    
    %Get SEIR reference state at the end of each day
    refNumTimeStepsPerDay = 1/refTimestep;

    for i=1:100
        refDayState(:, i) = refState(:, i*refNumTimeStepsPerDay+1);
    end
    refDayState = [refState(:,1) refDayState];   %Add the initial state at t=0

    %Get SEIR experiment state at the end of each day
    
    if expDtType == "fixed"
        
        expNumTimeStepsPerDay = 1/expTimestep;

        for i=1:100
            expDayState(:, i) = expState(:, i*expNumTimeStepsPerDay+1);
        end
        expDayState = [expState(:,1) expDayState];   %Add the initial state at t=0
        
    elseif expDtType == "adaptive" 

        day = 1;
        for i = 1:size(expTimestep, 2)

            %It's the time at the end of the day (i.e. is integer)
            if (floor(expTimestep(i)) == ceil(expTimestep(i)))
                expDayState(:, day) = expState(:, i);
                day = day+1;
            end
        end        
    end
    
    %%%%%% Percent Error %%%%%
    
    % Calculate error in percentage
    percentErrorDayState = abs(expDayState - refDayState)./refDayState*100;

    % Assign 0% for the initial stage to avoid NaN from division by 0
    percentErrorDayState(:,1) = zeros(52, 1);

    %Sum Day Error of All Nodes
    sumRefDayState = c * refDayState;
    sumExpDayState = c * expDayState;
    sumPercentErrorDayState = abs(sumExpDayState - sumRefDayState)./sumRefDayState*100;

    %% Convert SEIR matrix time series to cell
    for i = 1:size(percentErrorDayState,2)
        percentErrorDayStateCell(:,i) = convertSeirMatToCell(percentErrorDayState(:,i));
    end
    
    %%%%%% Population Error %%%%%    

    % Calculate error as #Individuals
    populationErrorDayState = abs(expDayState - refDayState);

    %Sum Day Error of All Nodes
    sumRefDayState = c * refDayState;
    sumExpDayState = c * expDayState;
    sumPopulationErrorDayState = abs(sumExpDayState - sumRefDayState);

    %% Convert SEIR matrix time series to cell
    for i = 1:size(populationErrorDayState,2)
        populationErrorDayStateCell(:,i) = convertSeirMatToCell(populationErrorDayState(:,i));
    end
    
end