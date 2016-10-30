TotalSampleCount = [4034 1284 2114 1442 4955 921 2472 861 4913 189 909 3140 1602 5024 3897 1377 341 2673 1394 2136 2562 664 520 413 1221 1094];
TrainCount = round(TotalSampleCount./2);
TestCount = TotalSampleCount - TrainCount;

TestCount = min(200*ones(size(TotalSampleCount)), TestCount);

load('GaussCC.mat');
load('GammaCC.mat');
Noise = logspace(-3, -0.5);

gammaRP = zeros(size(logspace(-3, -0.5)));
gaussRP = zeros(size(logspace(-3, -0.5)));
for i = 1 : size(logspace(-3, -0.5), 2)
    gaussRP(i) = sum(GaussCC(i, :))./sum(TestCount);
    gammaRP(i) = sum(GammaCC(i, :))./sum(TestCount);
end

plot(logspace(-3, -0.5), gaussRP);
hold on;
plot(logspace(-3, -0.5), gammaRP);
ylim([0 1])
legend('Gauss','Gamma');
xlabel('Noise variance');
ylabel('Recognition rate');
hold off;

figure;
plot(logspace(-3, -0.5), abs(gaussRP - gammaRP));

% 
% gaussClassC = sum(GaussCC)./(size(logspace(-3, -0.5), 2).*TestCount);
% gammaClassC = sum(GammaCC)./(size(logspace(-3, -0.5), 2).*TestCount);
% 
% bar(1:26, gaussClassC, 0.7, 'FaceColor',[1 0.3 0.3])
% hold on;
% bar(1:26, gammaClassC, 0.35, 'FaceColor',[0.3 1 0.3])
% legend('Gauss','Gamma');
