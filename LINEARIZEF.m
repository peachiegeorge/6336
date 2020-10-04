function [A,B] = LINEARIZEF(f,x0,p,u0,u)
% f : P x 1 cell array of outputs {[dS1/dt; dE1/dt; dI1/dt; dR1/dt];...
%                                 [dSP/dt; dEP/dt; dIP/dt; dRP/dt]}
% x0 : P x 1 cell array of state vector inputs {[S1; E1; I1; R1]; [SP; EP; IP; RP]}
%      about which to linearize
% p  : P x 1 struct of params
% u0 : P x 1 cell array of inputs {[U1; U1; U1; U1];...
%                                 [UP; UP; UP; UP]}
% u  : 


end