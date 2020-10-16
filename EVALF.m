function f = EVALF(x,p,u)
% x : P x 1 vector of inputs {[S1; E1; I1; R1];...
%                                 [SP; EP; IP; RP]}
% p : P x 1 struct of params
% u : P x 1 cell array of inputs {[U1; U1; U1; U1];...
%                                 [UP; UP; UP; UP]}
% f : P x 1 vector of outputs {[dS1/dt; dE1/dt; dI1/dt; dR1/dt];...
%                                 [dSP/dt; dEP/dt; dIP/dt; dRP/dt]}

P = length(x); % number of nodes
f = cell(P,1); % Initialize f

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

% Currently, we use a for loop to handle each node because calculation of
% Qs has a nonlinear term (S*I). Therefore, we cannot do this as a
% matrix-vector multiplcation.
for i = 1:P % For each node
    % Calculate inter-node flows
    Ms(i) = CalcMs(p(i).theta, xMat(1,1:end)');
    Me(i) = CalcMe(p(i).theta, xMat(2,1:end)');
    Mi(i) = CalcMi(p(i).theta, xMat(3,1:end)');
    
    % Calculate intra-node flows
    Qs(i) = CalcQs(p(i).beta,  x{i}(1), x{i}(3));
    Qe(i) = CalcQe(p(i).sigma, x{i}(2));
    Qi(i) = CalcQi(p(i).gamma, x{i}(3));
    
    % Calculate deaths (leakage)
    D(i) = CalcD(p(i).nu, x{i}(4));
    
    % Calculate entries of f
    f{i}(1,1) = -Qs(i) + Ms(i) + u{i}(1);
    f{i}(2,1) = Qs(i) - Qe(i) + Me(i) + u{i}(2);
    f{i}(3,1) = Qe(i) - Qi(i) + Mi(i) + u{i}(3);
    f{i}(4,1) = Qi(i) - D(i) + u{i}(4);
end
end

% Variables defined in project report
function D = CalcD(nu,R)
if R < 0
    D = 0;
end
D = nu*R;
end

function Qs = CalcQs(beta,S,I)
if S < 0 || I < 0
    Qs = 0;
end
Qs = beta*S*I;
end

function Ms = CalcMs(theta,S)
% Net flow to current community's S population
if S < 0
    Ms = 0;
end
Ms = theta*S;
end

function Qe = CalcQe(sigma,E)
if E < 0
    Qe = 0;
end
Qe = sigma*E;
end

function Me = CalcMe(theta,E)
if E < 0
    Me = 0;
end
Me = theta*E;
end

function Qi = CalcQi(gamma,I)
if I < 0
    Qi = 0;
end
Qi = gamma*I;
end

function Mi = CalcMi(theta,I)
if I < 0
    Mi = 0;
end
Mi = theta*I;
end