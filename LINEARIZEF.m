function [A,B] = LINEARIZEF(x0,p,u0)
% f : P x 1 cell array of outputs {[dS1/dt; dE1/dt; dI1/dt; dR1/dt];...
%                                 [dSP/dt; dEP/dt; dIP/dt; dRP/dt]}
% x0 : P x 1 cell array of state vector inputs {[S1; E1; I1; R1]; [SP; EP; IP; RP]}
%      about which to linearize
% p  : P x 1 struct of params
% u0 : P x 1 cell array of inputs {[U1; U1; U1; U1];...
%                                 [UP; UP; UP; UP]}
% u  : 

[Jf_u, Jf_x] = finiteDifferenceJacobian(x0,p,u0);
K0 = cell2mat(EVALF(x0,p,u0)) - Jf_x*cell2mat(x0) - Jf_u*cell2mat(u0);
A = Jf_x;
B = [K0,Jf_u];

end