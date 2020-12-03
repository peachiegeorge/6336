function theta = GenThetaMat(P, method, cutOffVal)
% Function to generate matrix of random thetas given # of nodes
% For future implementation: parameterize beta using gravitational or
% radiation model.
% P: total number of nodes
% Method: Method for generating thetas
% theta: P x P matrix of theta parameters
NORM_FACT = 1; % Maximum possible travel per unit time
if method == "symmetric"
	d = rand(P,1);
	t = triu(bsxfun(@min,d,d.').*rand(P)/NORM_FACT,1); % The upper trianglar random values
	theta = diag(d)+t+t.'; % Put them together in a symmetric matrix
	theta = theta - diag(diag(theta)); % Zero out the diagonals
elseif method == "upTri"
	d = 2*rand(P,P)-1;  % Generate random nums between [-1 1]
	theta = triu(d./NORM_FACT,1); % The upper trianglar random values
elseif method == "random"
	theta = randfixedsum(P,P,1,0,1)/NORM_FACT;
	theta(1:size(theta,2)+1:end) = 0;
elseif method == "noTravel"
	theta = zeros(P,P);
elseif method == "noMeasures"
	load('Cambridge\cambridgeParams.mat');
	for i = 1:P
		for j = 1:P
			theta1 = jobs(i) * pop(i) * poverty(j) / NORM_FACT;
			theta2 = jobs(j) * pop(j) * poverty(i) / NORM_FACT;
			theta(i,j) = max(theta1,theta2);
		end
	end
	theta = theta(1:P,1:P);
elseif method == "cutOff"
	load('Cambridge\cambridgeParams.mat');
	for i = 1:P
		for j = 1:P
			theta1 = jobs(i) * pop(i) * poverty(j) / NORM_FACT;
			theta2 = jobs(j) * pop(j) * poverty(i) / NORM_FACT;
			theta(i,j) = max(theta1,theta2);
		end
	end
	theta(cutOffVal,:) = 0;
	theta(:,cutOffVal) = 0;
	theta = theta(1:P,1:P);
elseif method == "cutOffMultiple"
	load('Cambridge\cambridgeParams.mat');
	for i = 1:P
		for j = 1:P
			theta1 = jobs(i) * pop(i) * poverty(j) / NORM_FACT;
			theta2 = jobs(j) * pop(j) * poverty(i) / NORM_FACT;
			theta(i,j) = max(theta1,theta2);
		end
    end
    % 10% attenuation of travel
    attFac = 0.01;
	theta(1,:) = attFac*theta(1,:);
	theta(:,1) = attFac*theta(:,1);
	theta(2,:) = attFac*theta(2,:);
	theta(:,2) = attFac*theta(:,2);
	theta(5,:) = attFac*theta(5,:);
	theta(:,5) = attFac*theta(:,5);
	theta = theta(1:P,1:P);
else
	disp('Not a valid case for GenThetaMat.');
end
end