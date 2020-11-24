function [A,B] = LINEARIZEF(f,x0,p,u0,epsX,epsU,doCellOps)
% A  : Jacobian w.r.t state variables, x, evaluated at operating pt. x0
% B  : K0 (see def. in PM2 doc) and Jf_u, the Jacobian w.r.t inputs/sources u
% f  : function handler, e.g. f = 'EVALF' or f = @(x) x.^2;
% x0 : state vector about which to evaluate the Jacobian
% p  : Parameter struct
% u0 : input vector about which to evaluate the Jacbobian
% epsX : small epsilon in x ('deltaX')
% epsU : small epsilon in u ('deltaU');
% doScaladoCellOpsrEval : a flag to let the functions know if you are
% evaluating with cells

% Calculate the finite differences
[Jf_x, Jf_u] = finiteDifferenceJacobian(f,x0,p,u0,epsX,epsU,doCellOps);

% K0 should be N x 1 where N is the number of equations in the system
if doCellOps
    K0 = cell2mat(feval(f,x0,p,u0)) - Jf_x*cell2mat(x0) - Jf_u*cell2mat(u0);
else
    K0 = feval(f,x0,p,u0) - Jf_x*x0 - Jf_u*u0;
end

% Return linearized system at x0,u0
A = Jf_x;       % Jacobian, w.r.t x (state)
B = [K0,Jf_u];  % Constant terms and Jacobian, w.r.t. u (input)
end