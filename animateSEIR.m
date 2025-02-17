function f = animateSEIR(y,speed)
%% Animate the summed-neighborhood SEIR curves
% y is a  4 x num_time_steps matrix
% x is a 4P x num_time_steps matrix
% speed is a animation speed scale factor
yS = y(1,:);
yE = y(2,:);
yI = y(3,:);
yR = y(4,:);
dt = 0.5; 
f = figure;
s1 = animatedline('color','#0072BD','LineWidth',1.5); % Blue
e1 = animatedline('color','#D95319','LineWidth',1.5); % Orange
i1 = animatedline('color','#EDB120','LineWidth',1.5); % Yellow
r1 = animatedline('color','#7E2F8E','LineWidth',1.5); % Purple
ylabel('# Individuals');
xlabel('Days');
legend('S','E','I','R')
tVec = dt*(1:size(yS,2));
xlim([0,max(tVec)]);
ylim([0,max(max(yS))]);
step = 1/dt;
for i = 1 : step : size(yS,2)
    addpoints(s1,tVec(i),yS(i));
    addpoints(e1,tVec(i),yE(i));
    addpoints(i1,tVec(i),yI(i));
    addpoints(r1,tVec(i),yR(i));
    % title(sprintf('Summed Neighborhood SEIR, t = %.1f days',(i+step-1)*dt));
    pause(0.033*speed); % ~30 updates/sec
end
end