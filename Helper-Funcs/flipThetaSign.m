function [p_day, p_night] = flipThetaSign(P, p)

    %Assuming the given parameter is at day time
    p_day = p;

    %Generate parameter for night time with flip theta's sign
    p_night(P, 1).beta = 0;  % Initialize struct array
    for i = 1:P
        p_night(i,1).beta = p(i,1).beta;
        p_night(i,1).sigma = p(i,1).sigma;
        p_night(i,1).gamma = p(i,1).gamma;
        p_night(i,1).mu = p(i,1).mu;
        p_night(i,1).nu = p(i,1).nu;
        p_night(i,1).theta = -p(i,1).theta; % Extract row for that node
    end

end