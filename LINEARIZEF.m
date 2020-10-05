function [A,B] = LINEARIZEF(f,x0,p,u0,epsX,epsU,doScalarEval)
% TO RUN: Provide 
% A  : Jacobian w.r.t state variables, x, evaluated at operating pt. x0
% B  : K0 (see def. in PM2 doc) and Jf_u, the Jcobian w.r.t inputs/sources u
% f  : function handler, e.g. f = 'EVALF' or f = @(x) x.^2;
% x0 : state vector about which to evaluate the Jacobian
% p  : Parameter struct
% u0 : input vector about which to evaluate the Jacbobian
% epsX : small epsilon in x ('deltaX')
% epsU : small epsilon in u ('deltaU');
% doScalarEval : a flag to let the functions know if you are evaluating a
%                scalar function

[Jf_u, Jf_x] = finiteDifferenceJacobian(f,x0,p,u0,epsX,epsU,doScalarEval);
if doScalarEval
    K0 = feval(f,x0) - Jf_x*x0;
else
    K0 = cell2mat(feval(f,x0,p,u0)) - Jf_x*cell2mat(x0) - Jf_u*cell2mat(u0);
end
A = Jf_x;
B = [K0,Jf_u];

end