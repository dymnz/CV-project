
ITERATION_COUNTS = [100 200 500 700 1000 1500];

for C = 1 : numel(ITERATION_COUNTS)

%% Learning    
MAX_ITERATION = ITERATION_COUNTS(C);
MIN_GRADIENT_DIFF_PERCENTAGE = 0.001;
LAMBDA = 0.0005;
theta = 0.005 * randn(DIMENSION, MAX_CLASS);

for i = 1 : MAX_ITERATION
    [L, g] = gradientDescent(TrainSet, theta); 
    theta = theta - LAMBDA.*g;
end

disp(sprintf('For %d iterations: final cost = %.2f', MAX_ITERATION, L));

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

disp( sprintf('Testing correct %%: %.2f%%', (1-sum(errorCount)/sum(TestCount)) * 100));


end