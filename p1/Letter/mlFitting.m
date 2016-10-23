function [Means, Covs] = mlFitting(trainSetData)
%% Maximum Likelihood Multivariate Normal Distribution Fitting
Means = zeros(size(trainSetData, 1), size(trainSetData, 3));
Covs = zeros(size(trainSetData, 1), size(trainSetData, 3), size(trainSetData, 3));

for i = 1 : size(trainSetData, 1)
    [Means(i, :), Covs(i, :, :)] = mvnML(squeeze(trainSetData(i, :, :)), size(trainSetData,2));
end