% Classification Rate vs. |Weight Decay|

WEIGHT_DECAYS = [0 logspace(-10, 0)];
corretPTrain = zeros(size(WEIGHT_DECAYS));
corretPTest = zeros(size(WEIGHT_DECAYS));

for C = 1 : numel(WEIGHT_DECAYS)
    
%% Learning
MAX_ITERATION = 1000;
MIN_GRADIENT_DIFF_PERCENTAGE = 0.001;
LEARNING_RATE = 0.0005;
WEIGHT_DECAY  = WEIGHT_DECAYS(C);
theta = 0.0005 * randn(DIMENSION + 1, MAX_CLASS);

g = 0;
for i = 1 : MAX_ITERATION
    [L, g] = gradientDescentWD(TrainSet, theta, WEIGHT_DECAY); 
    theta = theta - LEARNING_RATE.*g;
    %disp(mean(mean(abs(g))));
end

disp(sprintf('For %.4f WD: final cost = %.2f', WEIGHT_DECAY, L));

%% Training Set error
K = MAX_CLASS;
errorCount = zeros(size(TrainSet));

for i = 1 : K
    target = i;
    
    for r = 1 : size(TrainSet{i}, 1)
        xi = TrainSet{i}(r, :).';
        yi = softmax(xi, theta);
        [v ind] = max(yi);
        if ind ~= target
            errorCount(i) = errorCount(i) + 1;
        end
    end
end
corretPTrain(C) = (1-sum(errorCount)/sum(TrainCount)) * 100;
disp( sprintf('Training correct %%: %.2f%%', (1-sum(errorCount)/sum(TrainCount)) * 100));

%% Testing Set error
K = MAX_CLASS;
errorCount = zeros(size(TestSet));

for i = 1 : K
    target = i;
    
    for r = 1 : size(TestSet{i}, 1)
        xi = TestSet{i}(r, :).';
        yi = softmax(xi, theta);
        [v ind] = max(yi);
        if ind ~= target
            errorCount(i) = errorCount(i) + 1;
        end
    end
end
corretPTest(C) = (1-sum(errorCount)/sum(TestCount)) * 100;
disp( sprintf('Testing correct %%: %.2f%%', (1-sum(errorCount)/sum(TestCount)) * 100));

end
figure; 
scatter(WEIGHT_DECAYS, corretPTrain);
hold on;
scatter(WEIGHT_DECAYS, corretPTest);
axis([0, 1, 0, 100]);
set(gca,'xscale','log');
legend('Train','Test');
title('Classification Rate vs. |Weight Decay|');
