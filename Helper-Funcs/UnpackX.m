function [xS, xE, xI, xR] = UnpackX(x)
% Unpacks x for use with plotting functions
% x is a 4P x (num_time_steps) matrix
xS = x(1:4:end,:);
xE = x(2:4:end,:);
xI = x(3:4:end,:);
xR = x(4:4:end,:);
end