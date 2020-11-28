load CambridgeCOVID19
%%
figure;
t = 1:268;	% Days
plot(t,CambridgeCOVID19.NewPositiveCases);
title('New Positive Cases');
xlabel('Days');
ylabel('# New Positives');

figure;
plot(t,CambridgeCOVID19.CumulativePositiveCases);
title('Cumulative Positive Cases');
xlabel('Days');
ylabel('# Cumulative Positives');

%% 
figure;
semilogy(t,CambridgeCOVID19.CumulativePositiveCases);
title('Cumulative Positive Cases');
xlabel('Days');
ylabel('# Cumulative Positives');
x = 1:41;
y = CambridgeCOVID19.CumulativePositiveCases(1:max(x))