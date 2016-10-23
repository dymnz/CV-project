testSetPosterior = zeros(size(testSetData,1), size(testSetData,2), MAX_CLASS);
for i = 1 : MAX_CLASS    
    trainMean = trainMeans(i,:);
    trainLogPrior = trainLogPriors(i);
    trainDiagCov = diag(diag(squeeze(trainCovs(i, :, :))));
    for m = 1 : size(testSetData, 1)  
            test = squeeze(testSetData(m, :, :));
            logLikelihood = lognpdf(test, trainMean, trainDiagCov);            
            testSetPosterior(m, :, i) = bsxfun(@plus, logLikelihood, trainLogPrior);
    end
end

wrong = 0;
correct = 0;
for m = 1 : size(testSetData, 1)
    for n = 1 : size(testSetData, 2)
        [value, index] = max(testSetPosterior(m, n, :)) ;
        if index == m
            correct = correct + 1;            
        else
            wrong = wrong + 1;            
        end
    end
end

disp(correct);
disp(wrong);
