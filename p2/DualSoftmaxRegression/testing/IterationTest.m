
ITERATION_COUNTS = [0 logspace(2, 4, 10);
corretPTrain = zeros(size(ITERATION_COUNTS));
corretPTest = zeros(size(ITERATION_COUNTS));

psi = cell(1, MAX_CLASS);   % 1xK Ix1	The psi for K class, each with I samples 

% Initialize the psi with random number
for i = 1 : MAX_CLASS
    psi{i} = 0.005 * randn(TrainCounts(i), 1);
end

for C = 2 : numel(ITERATION_COUNTS)

%% Learning    
MAX_ITERATION = ITERATION_COUNTS(C);
LEARNING_RATE = 0.002;	% Learning rate


% Gradient Descent process
for i = ITERATION_COUNTS(C-1) : MAX_ITERATION

	% Gradient Descent, get the Loss and Gradient
    [L, g] = gradientDescent(TrainSet, psi); 
	
	% Update psi
    for r = 1 : MAX_CLASS
        psi{r} = psi{r} - LEARNING_RATE.*g{r}./TrainCount;
    end    
    disp(sprintf('%d %.3f', i, L/TrainCount));    
end

disp(sprintf('Iterations: %d Final loss: %.2f', i, L/TrainCount));

%% Training Set error
K = MAX_CLASS;
errorCount = zeros(size(TrainSet));

for i = 1 : K
    target = i;	% The target of this subset
        
    for r = 1 : size(TrainSet{i}, 1)
        xi = TrainSet{i}(r, :).';	% The samples of this subset
        yi = dualSoftmax(TrainSet, psi, xi);  
        [val ind] = max(yi);
        if ind ~= target
            errorCount(i) = errorCount(i) + 1;
        end
    end
end
corretPTrain(C) = (1-sum(errorCount)/sum(TrainCount)) * 100;
disp(sprintf('TrainSet correct: %.2f%%', ...
    (1-sum(errorCount)/sum(TrainCount)) * 100));

%% Testing Set error
K = MAX_CLASS;
errorCount = zeros(size(TestSet));

for i = 1 : K
    target = i;	% The target of this subset
        
    for r = 1 : size(TestSet{i}, 1)
        xi = TestSet{i}(r, :).';	% The samples of this subset
        yi = dualSoftmax(TrainSet, psi, xi);  
        [val ind] = max(yi);
        if ind ~= target
            errorCount(i) = errorCount(i) + 1;
        end
    end
end
corretPTest(C) = (1-sum(errorCount)/sum(TestCount)) * 100;
disp(sprintf('TestSet correct: %.2f%%', ...
    (1-sum(errorCount)/sum(TestCount)) * 100));


end
figure; 
scatter(ITERATION_COUNTS, corretPTrain);
hold on;
scatter(ITERATION_COUNTS, corretPTest);
axis([10, 10000, 0, 100]);
set(gca,'xscale','log');
legend('Train','Test');
title('Classification Rate vs. # of Iterations');
