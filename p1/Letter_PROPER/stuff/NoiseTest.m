% This is a test of the effect of noise

RND = 0;
GaussCC = zeros(size(logspace(-3, -0.5), 2), 26);
GammaCC = zeros(size(logspace(-3, -0.5), 2), 26);

for Noise = logspace(-3, -0.5)
RND = RND + 1;    
disp(Noise);
rng(0,'twister');

% Global constants

MAX_CLASS = 26;         % # of classes
MAX_TRAIN_SIZE = 100;   % Train set size
MAX_TEST_SIZE = 80;     % Test set size
DATA_ROW = 16;          % Data dimension Row
DATA_COLUMN = 8;        % Data dimension Column
DATA_SIZE = DATA_ROW * DATA_COLUMN;   % Data dimension

% Let half of the data be the training set
% The dataset is not uniform, this is the best I can do
TotalSampleCount = [4034 1284 2114 1442 4955 921 2472 861 4913 189 909 3140 1602 5024 3897 1377 341 2673 1394 2136 2562 664 520 413 1221 1094];
TrainCount = round(TotalSampleCount./2);
TestCount = TotalSampleCount - TrainCount;

TestCount = min(200*ones(size(TotalSampleCount)), TestCount);


% Storage
TrainSet = cell(1, 1);
TestSet = cell(1, 1);

% Read the dataset
[TrainSet, TestSet] = readSets(MAX_CLASS, TrainCount, TestCount, DATA_SIZE, Noise);

% Now, run "GaussianMLE.m" or other estimator
% Guassian Distribution Maximum Likelihood Estimation

% Maxmimum Likelihood fitting
[Means, Covs] = gaussianMLFitting(TrainSet);

% Set the priors
% Since we do not have prior knowledge of the data, the prior are uniform
Priors = ones(MAX_CLASS, 1)./MAX_CLASS;

% For each test sample (coming from different classes), test against
% all the classes
Likelihoods = cell(1, 1);
Denominators = cell(1, 1);
Posteriors = cell(1, 1);
for i = 1 : MAX_CLASS
    SampleLikelihoods = zeros(size(TestSet{i}, 1), MAX_CLASS);
    for r = 1 : MAX_CLASS
        DiagCov = diag(diag(Covs{r}));
        SampleLikelihoods(:, r) = mvnpdf(TestSet{i}, Means{r}, DiagCov);
        Likelihoods{i} = SampleLikelihoods;
    end   
end

% Calculate Posterior
for i = 1 : MAX_CLASS
    % Classify the data with Bayes' rule.
    Denominator{i} = 1 ./ (Likelihoods{i} * Priors);
    Posteriors{i} = (Likelihoods{i} * diag(Priors));
    Posteriors{i} = (Posteriors{i}.' * diag(Denominator{i}));
end

% Correct/Wrong
% For each test sample (coming from different classes), check if the
% maximum posterior is the correct class
CorrectCount = zeros(1, MAX_CLASS);
for i = 1 : MAX_CLASS
    [M,I] = max(Posteriors{i});
    CorrectCount(i) = nnz(I==i);
end
GaussCC(RND, :) = CorrectCount;
% Print stuff
CorrectPercentages = CorrectCount./TestCount*100;
TotalPercentage = sum(CorrectCount)/sum(TestCount);
disp(sprintf('Correct/Total: %.2f%%', TotalPercentage*100));



% Gamma Distribution Maximum Likelihood Estimation

[Ks, Thetas] = gammaMLFitting(TrainSet);

% Set the priors
% Since we do not have prior knowledge of the data, the prior are uniform
Priors = ones(MAX_CLASS, 1)./MAX_CLASS;

% For each test sample (coming from different classes), test against
% all the classes
Likelihoods = cell(1, 1);
Denominators = cell(1, 1);
Posteriors = cell(1, 1);
for i = 1 : MAX_CLASS
    SampleLikelihoods = zeros(size(TestSet{i}, 1), MAX_CLASS);
    for r = 1 : size(TestSet{i}, 1)
        for p = 1 : MAX_CLASS
            SampleLikelihoods(r, p) = prod(gampdf(TestSet{i}(r, :), Ks{p}, Thetas{p}));
            
        end
    end
    Likelihoods{i} = SampleLikelihoods;
end

% Calculate Posterior
for i = 1 : MAX_CLASS
    % Classify the data with Bayes' rule.
    Denominator{i} = 1 ./ (Likelihoods{i} * Priors);
    Posteriors{i} = (Likelihoods{i} * diag(Priors));
    Posteriors{i} = (Posteriors{i}.' * diag(Denominator{i}));
end

% Correct/Wrong
% For each test sample (coming from different classes), check if the
% maximum posterior is the correct class
CorrectCount = zeros(1, MAX_CLASS);
for i = 1 : MAX_CLASS
    [M,I] = max(Posteriors{i});
    CorrectCount(i) = nnz(I==i);
end
GammaCC(RND, :) = CorrectCount;
% Print stuff
CorrectPercentages = CorrectCount./TestCount*100;
TotalPercentage = sum(CorrectCount)/sum(TestCount);
disp(sprintf('Correct/Total: %.2f%%', TotalPercentage*100));
end
