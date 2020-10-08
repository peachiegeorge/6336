function theta = GenThetaMat(P, method)
% Function to generate matrix of random thetas given # of nodes
% For future implementation: parameterize beta using gravitational or
% radiation model.
% P: total number of nodes
% Method: Method for generating thetas
% theta: P x (P-1) matrix of theta parameters
NORM_FACT = 50; % Maximum possible travel per unit time
if method == "symmetric"
    d = rand(P,1);
    t = triu(bsxfun(@min,d,d.').*rand(P)/NORM_FACT,1); % The upper trianglar random values
    theta = diag(d)+t-t.'; % Put them together in a symmetric matrix
    theta = theta - diag(diag(theta)); % Zero out the diagonals
elseif method == "upTri"
    d = 2*rand(P,1)-1;  % Generate random nums between [-1 1]
    theta = triu(bsxfun(@min,d,d.').*(2*rand(P)-1)/NORM_FACT,1); % The upper trianglar random values
elseif method == "rand"
    theta = zeros(P,P);
    for m = 1:P
        for n = 1:P
            if m ~= n
                theta(m,n) = rand(1)/NORM_FACT;
            end
        end
    end
elseif method == "zeroes"
    theta = zeros(P,P);
end
end