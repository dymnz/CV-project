function [sMean, sCov] = mvnML(dataSet, setSize)
% Get Mean and Cov of Multivariate Normal Dist

% Get mean of each column - 1xD
sMean = sum(dataSet,1) ./ setSize;

% Calculate covariance matrix %

% You can do it according to the formula
% For some reason this approach takes a lot of time
dataSetSubMean = double(dataSet)-repmat(sMean,size(dataSet,1),1);
sCov = (dataSetSubMean.' * dataSetSubMean);

% Another way is to use cov(double(dataSet)) directly
% sCov = cov(double(dataSet));

% Another one
% sCov = zeros (size(dataSet,2), size(dataSet,2));
% for i = 1 : setSize
%     M = double(dataSet(i, :)) - sMean;
%     M = M' * M;
%     sCov = sCov + M;
% end

if setSize > 1
    sCov = sCov ./ (setSize-1) ./ 1000;
end

end