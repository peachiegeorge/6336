function [f Ms Me Mi Os Oe Oi] = EVALF(x,p,u)
% x : P x 1 vector of inputs {[S1; E1; I1; R1];...
%                                 [SP; EP; IP; RP]}
% p : P x 1 struct of params
% u : P x 1 cell array of inputs {[U1; U1; U1; U1];...
%                                 [UP; UP; UP; UP]}
% f : P x 1 vector of outputs {[dS1/dt; dE1/dt; dI1/dt; dR1/dt];...
%                                 [dSP/dt; dEP/dt; dIP/dt; dRP/dt]}

P = length(x); % number of communities
f = cell(P,1); % Initialize f

% Initialize Qs, Ms
Qs = zeros(P,1);    % Intra-community flows
Qe = zeros(P,1);
Qi = zeros(P,1);
Ms = zeros(P,1);    % Inter-community inflow
Me = zeros(P,1);
Mi = zeros(P,1);
Mr = zeros(P,1);
Os = zeros(P,1);    % Inter-community outflow
Oe = zeros(P,1);
Oi = zeros(P,1);
Or = zeros(P,1);
Ds = zeros(P,1);    % Deaths
De = zeros(P,1);
Di = zeros(P,1);
Dr = zeros(P,1);
B = zeros(P,1);     % Births

% Convert all the inputs from cell to matrix
% *Need to do this to calculate inter-community flows
xMat = [x{1:end}];
N = sum(xMat,1);
% Ntot = sum(N)   % This should stay the same during the entire simulation

% In case x is already a matrix, no conversion is needed
% xMat = x;

% Currently, we use a for loop to handle each community because calculation of
% Qs has a nonlinear term (S*I). Therefore, we cannot do this as a
% matrix-vector multiplcation.
for i = 1:P % For each community
    % Calculate inter-community flows into community
    Ms(i) = CalcMs(p(i).theta(i,:), xMat(1,1:end)', N');     % Linear
    Me(i) = CalcMe(p(i).theta(i,:), xMat(2,1:end)', N');     % Linear
    Mi(i) = CalcMi(p(i).theta(i,:), xMat(3,1:end)', N');     % Linear
    Mr(i) = CalcMr(p(i).theta(i,:), xMat(4,1:end)', N');     % Linear
    
    % Calculate inter-community flows leaving
    Os(i) = CalcOs(p(i).theta(:,i), xMat(1,i), N(i)); % Linear
    Oe(i) = CalcOe(p(i).theta(:,i), xMat(2,i), N(i)); % Linear
    Oi(i) = CalcOi(p(i).theta(:,i), xMat(3,i), N(i)); % Linear
    Or(i) = CalcOr(p(i).theta(:,i), xMat(4,i), N(i)); % Linear
    
    % Calculate intra-community flows
    Qs(i) = CalcQs(p(i).beta,  x{i}(1), x{i}(3), N(i)); % Nonlinear!
    Qe(i) = CalcQe(p(i).sigma, x{i}(2));                % Linear
    Qi(i) = CalcQi(p(i).gamma, x{i}(3));                % Linear
    
    % Calculate births
    % B(i) = CalcB(p(i).mu, sum(x{i}));             % Linear
    
    % Calculate deaths (leakage)
    % Ds(i) = CalcDs(p(i).nu, x{i}(1));               % Linear
    % De(i) = CalcDe(p(i).nu, x{i}(2));               % Linear
    % Di(i) = CalcDi(p(i).nu, x{i}(3));               % Linear
    % Dr(i) = CalcDr(p(i).nu, x{i}(4));               % Linear
    
    % Calculate entries of f (with birth and death)
    % f{i}(1,1) = B(i)  - Qs(i) - Ds(i) + Ms(i) - Os(i) + u{i}(1);
    % f{i}(2,1) = Qs(i) - Qe(i) - De(i) + Me(i) - Oe(i);
    % f{i}(3,1) = Qe(i) - Qi(i) - Di(i) + Mi(i) - Oi(i) + u{i}(3);
    % f{i}(4,1) = Qi(i)         - Dr(i);
    
    % Calculate entries of f (no birth and death)
    f{i}(1,1) = - Qs(i)         + Ms(i) - Os(i) + u{i}(1);
    f{i}(2,1) =   Qs(i) - Qe(i) + Me(i) - Oe(i) + u{i}(2);
    f{i}(3,1) =   Qe(i) - Qi(i) + Mi(i) - Oi(i) + u{i}(3);
    f{i}(4,1) =   Qi(i)         + Mr(i) - Or(i) + u{i}(4);
end
end
%% Inflows
function Ms = CalcMs(theta,S,N)
% Net flow to current community's S population
if S < 0
    Ms = 0;
end
Ms = theta*(S./N);
end

function Me = CalcMe(theta,E,N)
% Net flow to current community's E population
if E < 0
    Me = 0;
end
Me = theta*(E./N);
end

function Mi = CalcMi(theta,I,N)
% Net flow to current community's I population
if I < 0
    Mi = 0;
end
Mi = theta*(I./N);
end

function Mr = CalcMr(theta,R,N)
% Net flow to current community's r population
if R < 0
    Mr = 0;
end
Mr = theta*(R./N);
end

%% Outflows
function Os = CalcOs(theta,S,N)
% Net flow to current community's S population
if S < 0
    Os = 0;
end
Os = sum(theta)*S./N;
end

function Oe = CalcOe(theta,E,N)
% Net flow to current community's S population
if E < 0
    Oe = 0;
end
Oe = sum(theta)*E./N;
end

function Oi = CalcOi(theta,I,N)
% Net flow to current community's S population
if I < 0
    Oi = 0;
end
Oi = sum(theta)*I./N;
end

function Or = CalcOr(theta,R,N)
% Net flow to current community's S population
if R < 0
    Or = 0;
end
Or = sum(theta)*R./N;
end
%% Intra-neighborhood
function Qs = CalcQs(beta,S,I,N)
% Si -> Ei
if S < 0 || I < 0
    Qs = 0;
end
Qs = beta*S*I/N;
end

function Qe = CalcQe(sigma,E)
% Ei -> Ii
if E < 0
    Qe = 0;
end
Qe = sigma*E;
end

function Qi = CalcQi(gamma,I)
% Ii -> Ri
if I < 0
    Qi = 0;
end
Qi = gamma*I;
end

%% Birth/death (not used currently)
function B = CalcB(mu,N)
% Birth rate for each community
if N < 0
    N = 0;
end
B = mu*N;
end

function Ds = CalcDs(nu,S)
% Death for community's S population
if S < 0
    Ds = 0;
end
Ds = nu*S;
end

function De = CalcDe(nu,E)
% Death for community's R population
if E < 0
    De = 0;
end
De = nu*E;
end

function Di = CalcDi(nu,I)
% Death for community's R population
if I < 0
    Di = 0;
end
Di = nu*I;
end

function Dr = CalcDr(nu,R)
% Death for community's R population
if R < 0
    Dr = 0;
end
Dr = nu*R;
end