
TRAINSET_COUNTS = [1:9 10:10:200];
corretPTrain = zeros(size(TRAINSET_COUNTS));
corretPTest = zeros(size(TRAINSET_COUNTS));


for C = 1 : numel(TRAINSET_COUNTS)
%% Init and Read
rng(0,'twister');

% Global constants
MAX_CLASS = 26;         % # of classes
MAX_TRAIN_SIZE = TRAINSET_COUNTS(C);   % Test set size
MAX_TEST_SIZE = 50;     % Test set size
DATA_ROW = 16;          % Data dimension Row
DATA_COLUMN = 8;        % Data dimension Column
DIMENSION = 1 + DATA_ROW * DATA_COLUMN;   % Data dimension. + a prepend 1
NOISE_MAGNITUDE = 0;  % The var. of noise to add when reading samples

% Let half of the data be the training set
% The dataset is not uniform, this is the best I can do
TotalSampleCount = [4034 1284 2114 1442 4955 921 2472 861 4913 189 909 3140 1602 5024 3897 1377 341 2673 1394 2136 2562 664 520 413 1221 1094];

% Limit the train set size to min(MAX_TRAIN_SIZE, Half of samples)
TrainCount = min(round(TotalSampleCount./2), MAX_TRAIN_SIZE*ones(size(TotalSampleCount)));

TestCount = TotalSampleCount - TrainCount;

% Limit the test set size to min(MAX_TEST_SIZE, Amount of samples left)
TestCount = min(MAX_TEST_SIZE*ones(size(TotalSampleCount)), TestCount);

% Storage
TrainSet = cell(1, 1);
TestSet = cell(1, 1);

% Read the dataset
[TrainSet, TestSet] = readSets(MAX_CLASS, TrainCount, TestCount, DIMENSION, NOISE_MAGNITUDE);

%% Learning    
MAX_ITERATION = 200;
MIN_GRADIENT_DIFF_PERCENTAGE = 0.001;
LAMBDA = 0.0005;
theta = 0.0005 * randn(DIMENSION, MAX_CLASS);

lastG = 0;
g = 0;
for i = 1 : MAX_ITERATION
    [L, g] = gradientDescent(TrainSet, theta); 
    theta = theta - LAMBDA.*g;
    %disp(mean(mean(abs(g))));
end

disp(sprintf('For %d training samples: final cost = %.2f', MAX_TRAIN_SIZE, L));

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
scatter(TRAINSET_COUNTS, corretPTrain);
hold on;
scatter(TRAINSET_COUNTS, corretPTest);
axis([0, 200, 0, 100]);
legend('Train','Test');
title('Classification Rate vs. # of Training Samples');