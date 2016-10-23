function testSetPosterior = logPosterior(testSetData, trainMeans, trainCovs, trainLogPriors, MAX_CLASS)
% Given Mean/Cov/Prior of each class, get the log posterior for testing set.

testSetPosterior = zeros(size(testSetData,1), size(testSetData,2), MAX_CLASS);
for i = 1 : MAX_CLASS    
    trainMean = trainMeans(i,:);
    trainLogPrior = trainLogPriors(i);
    trainDiagCov = diag(diag(squeeze(trainCovs(i, :, :))));
    for m = 1 : size(testSetData, 1)  
            test = squeeze(testSetData(m, :, :));
            logLikelihood = logmvnpdf(test, trainMean, trainDiagCov);            
            testSetPosterior(m, :, i) = bsxfun(@plus, logLikelihood, trainLogPrior);
    end
end