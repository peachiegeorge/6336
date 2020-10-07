function f = EVALFLIN(x,p,u)
% x : P x 1 cell array of inputs {[S1; E1; I1; R1];...
%                                 [SP; EP; IP; RP]}
% p : P x 1 struct of params
% u : P x 1 cell array of inputs {[U1; U1; U1; U1];...
%                                 [UP; UP; UP; UP]}
% f : P x 1 cell array of outputs {[dS1/dt; dE1/dt; dI1/dt; dR1/dt];...
%                                 [dSP/dt; dEP/dt; dIP/dt; dRP/dt]}
fC = p.A*cell2vec(x, 1) + p.B*[1; cell2vec(u, 1)];
f = mat2cell(fC,4*ones(1,length(fC)/4));
end