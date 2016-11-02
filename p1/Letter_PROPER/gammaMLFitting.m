function [Ks, Thetas] = gammaMLFitting(TrainSet)
% GAMMAMLFITTING Calculate the Gamma Distribution parameter of a given training set
% INPT: TrainSet: LxNxD matrix. A training set of L classes, N samples and D dimension.
% OUPT: Ks: 1xL cell array. Each cell contains the K of a class.
%		Thetas: 1xL cell raary. Each cell contains the Theta of a class.
% Please refer to the report

Ks = cell(1, 1);
Thetas = cell(1, 1);

% Calculate the Gamma Distribution parameter of each training sample 
for i = 1 : length(TrainSet)
    [SampleK, SampleCov] = gammaML(TrainSet{i});
    Ks{i} = SampleK;
    Thetas{i} = SampleCov;
end

end

function [sK, sTheta] = gammaML(dataSet)
% GAMMAML Get K and Theta of Gamma Distribution
% Please refer to the report
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