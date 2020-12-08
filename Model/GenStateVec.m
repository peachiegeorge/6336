function x = GenStateVec(P, method)
% Initialize states for all nodes
% P: total number of nodes
% x: P x 1 cell array
x = cell(P,1);
% N = 120000;  % Total est. population of Cambridge, MA
% cam = readtable('Cambridge\cam.xlsx');
% N = cam.pop;
load('cambridgeParams.mat');
N = pop;
c = 13;     % # of neighborhoods in Cambridge
for i = 1:length(x)
    if method == "sameIC"
        x{i} = N(i)*ones(4,1);
        x{i}(2) = 0;
        x{i}(3) = 0;
        x{i}(4) = 0;
    elseif method == "random"
        x{i} = N(i)*rand(4,1);
        x{i}(2) = 0;
        x{i}(4) = 0;
    elseif method == "zeros"
        x{i} = zeros(4,1);
    elseif method == "MIToutbreak"
        x{i} = N(i)*ones(4,1);
        x{i}(2) = 0;
        if i == 2
            x{i}(3) = 1;
        else
            x{i}(3) = 0;
        end
        x{i}(4) = 0;
    elseif method == "singleInfectedAll"
        x{i} = N(i)*ones(4,1) - 1;
        x{i}(2) = 0;
        x{i}(3) = 1;
        x{i}(4) = 0;
    elseif method == "validationCase"
        x{i} = 130000*ones(4,1) - 1;
        x{i}(2) = 0;
        x{i}(3) = 1;
        x{i}(4) = 0;
    else
        disp('Not a valid case for GenThetaMat.');
    end
end
end
