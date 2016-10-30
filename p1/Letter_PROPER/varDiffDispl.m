TotalSampleCount = [4034 1284 2114 1442 4955 921 2472 861 4913 189 909 3140 1602 5024 3897 1377 341 2673 1394 2136 2562 664 520 413 1221 1094];
TrainCount = round(TotalSampleCount./2);
TestCount = TotalSampleCount - TrainCount;

TestCount = min(200*ones(size(TotalSampleCount)), TestCount);

Noise = logspace(-3, -0.5);

GaussVD = zeros(size(logspace(-3, -0.5)));
GammaVD = zeros(size(logspace(-3, -0.5)));
for i = 1 : size(logspace(-3, -0.5), 2)
    GammaVD(i) = sum(GammaV(i, :));
    GaussVD(i) = sum(GaussV(i, :));
end

plot(logspace(-3, -0.5), GaussVD);
hold on;
plot(logspace(-3, -0.5), GammaVD);
legend('Gauss','Gamma');
xlabel('Noise variance');
ylabel('Variance');
hold off;

plot(logspace(-3, -0.5), GammaVD - GaussVD  )
