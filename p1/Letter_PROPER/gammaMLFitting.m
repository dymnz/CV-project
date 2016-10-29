function [Ks, Thetas] = gammaMLFitting(TrainSet)
% Maximum Likelihood Multivariate Normal Distribution Fitting
Ks = cell(1, 1);
Thetas = cell(1, 1);

for i = 1 : length(TrainSet)
    [SampleK, SampleCov] = gammaML(TrainSet{i});
    Ks{i} = SampleK;
    Thetas{i} = SampleCov;
end

end

function [sK, sTheta] = gammaML(dataSet)
% Get K and Theta of Gamma Distribution

sK = zeros(1, size(dataSet, 2));
sTheta = zeros(1, size(dataSet, 2));
for i = 1 : size(dataSet, 2)
    data = dataSet(:, i).';
    N = size(data, 2);
    S = log(1/N*sum(data)) - 1/N*sum(log(data));

    SampleK = (3 - S + sqrt((S-3).^2 + 24*S)) / (12 * S);
    for r = 1 : 5
        SampleK = SampleK - ((log(SampleK) - psi(SampleK) - S) / (1/SampleK - psi(1, SampleK)));   
    end
    sK(i) = SampleK;
    sTheta(i) = 1/(SampleK*N)*sum(data);
end

end