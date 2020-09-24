function f = EVALF(x,p,u)
% x : P x 1 cell array of inputs {[S1; E1; I1; R1];...
%                                 [SP; EP; IP; RP]}
% p : P x 1 struct of params
% u : P x 1 cell array of inputs {[U1; U1; U1; U1];...
%                                 [UP; UP; UP; UP]}
% f : P x 1 cell array of outputs {[dS1/dt; dE1/dt; dI1/dt; dR1/dt];...
%                                 [dSP/dt; dEP/dt; dIP/dt; dRP/dt]}

P = length(x); % number of nodes
f = cell(P,1); % Initialize f
% x = u; % Add inputs to x

% Initialize Qs, Ms
Qs = zeros(P,1);
Qe = zeros(P,1);
Qi = zeros(P,1);
Ms = zeros(P,1);
Me = zeros(P,1);
Mi = zeros(P,1);

% Convert all the inputs from cell to matrix
% *Need to do this to calculate inter-node flows
xMat = [x{1:end}];

for i = 1:P % For each node
    % Calculate inter-node flows
    Ms(i) = CalcMs(p(i).theta, xMat(1,1:end)');
    Me(i) = CalcMe(p(i).theta, xMat(2,1:end)');
    Mi(i) = CalcMi(p(i).theta, xMat(3,1:end)');
    
    % Calculate intra-node flows
    Qs(i) = CalcQs(p(i).beta,  x{i}(1), x{i}(3));
    Qe(i) = CalcQe(p(i).sigma, x{i}(2));
    Qi(i) = CalcQi(p(i).gamma, x{i}(3));
    
    % Calculate entries of f
    f{i}(1,1) = -Qs(i) + Ms(i);
    f{i}(2,1) = Qs(i) - Qe(i) + Me(i);
    f{i}(3,1) = Qe(i) - Qi(i) + Mi(i);
    f{i}(4,1) = Qi(i);
end
end

function Qs = CalcQs(beta,S,I)
Qs = beta*S*I;
end

function Ms = CalcMs(theta,S)
Ms = theta*S;
end

function Qe = CalcQe(sigma,E)
Qe = sigma*E;
end

function Me = CalcMe(theta,E)
Me = theta*E;
end

function Qi = CalcQi(gamma,I)
Qi = gamma*I;
end

function Mi = CalcMi(theta,I)
Mi = theta*I;
end