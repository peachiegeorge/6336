function u = GenInputVec(P, t)
% Function to generate vector of inputs.
% P: total number of nodes
% t: time [days]
% u: P x 1 cell array of inputs
if t == 0 
    % Only generate an input for t = 0.
    N_MAX = 500;    % Max number of people per node
    I_MAX = 5;      % Max number of infected people per node
    N0 = round(N_MAX*rand(P,1));    % Initial population
    I0 = round(I_MAX*rand(P,1));    % Initial infected
    reduceAmnt = round(I_MAX*rand(length(I0(N0<I0)),1));
    I0(N0<I0) = I0(N0<I0) - reduceAmnt; % If N0 < I0, reduce # of infected
    % At least have one infected
    if (I0 < 1)
        I0 = I0 + I_MAX;
    end
    uM = [N0-I0, zeros(P,1), I0, zeros(P,1)]';
    u = num2cell(uM,1)';
else
    % t > 0, so zero the inputs.
    uM = [zeros(P,1), zeros(P,1), zeros(P,1), zeros(P,1)]';
    u = num2cell(uM,1)';
end
