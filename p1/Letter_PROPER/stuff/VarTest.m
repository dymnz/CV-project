% close all;
% VD = zeros(size(Ks, 2));
% MD = zeros(size(Ks, 2));
% for i = 1 : size(Ks, 2)
%         varD = sum( abs(Ks{i}.*(Thetas{i}.^2) - diag(Covs{i}).') )/DATA_SIZE;
%         meanD = sum( abs(Ks{i}.*(Thetas{i}) - Means{i}) )/DATA_SIZE;
%         
%         VD(i) = varD;
%         MD(i) = meanD;
% end

% h1 = semilogy(VD, 'b');
% hold on;
% h2 = semilogy(MD, 'r');
% xlabel('classes');
% ylabel('|Diff|');

% Set global constants and read training/testing data set%%
% The samples are in 16x8 binary image
% A Gaussian noise with var=0.1 is added


RND = 0;
GaussV = zeros(size(logspace(-3, -0.5), 2), DATA_SIZE);
GammaV = zeros(size(logspace(-3, -0.5), 2), DATA_SIZE);

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
[Ks, Thetas] = gammaMLFitting(TrainSet);

GaussV(RND, :) = abs(diag(Covs{i}).');
GammaV(RND, :) = abs(Ks{i}.*(Thetas{i}.^2));

end

