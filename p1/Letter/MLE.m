% This is the Maximum Likelihood Estimator
% Remeber to run 'Init_Read' beforehand

% I use log posterior, because my Covariance Matrix has a high-dimension,
% and that makes the likelihood overflow/underflow

%% Set the priors
% Since we do not have prior knowledge of the data, the prior are uniform
trainPriors = ones(MAX_CLASS, 1)./MAX_CLASS;
trainLogPriors = log(trainPriors);

%% Maximum Likelihood Fitting
[trainMeans, trainCovs] = mlFitting(trainSetData);

%% Find log Posterior for testing set
testSetPosterior = logPosterior(testSetData, trainMeans, trainCovs, trainLogPriors, MAX_CLASS);

%% Correct/Wrong
correct = 0;
testSetErrorCount = zeros(size(trainSetSize));
for m = 1 : size(testSetData, 1)
    for n = 1 : size(testSetData, 2)
        [value, index] = max(testSetPosterior(m, n, :)) ;
        if index == m
            correct = correct + 1;            
        else
%             disp(sprintf('should be %c but recg as %c', m+'a'-1, index+'a'-1));       
            testSetErrorCount(m) = testSetErrorCount(m) + 1;
        end
    end
end
wrong = sum(testSetSize) - correct;
disp(sprintf('Correct: %d', correct));
disp(sprintf('Wrong: %d', wrong));
disp(sprintf('%%Correct: %.1f%%', correct/sum(testSetSize)*100));

