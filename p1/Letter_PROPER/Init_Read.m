% Set global constants and read training/testing data set%%
% The samples are in 16x8 binary image
% A Gaussian noise with var=0.1 is added

clear; close all;
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

TestCount = 50*ones(size(TotalSampleCount));


% Storage
TrainSet = cell(1, 1);
TestSet = cell(1, 1);

% Read the dataset
[TrainSet, TestSet] = readSets(MAX_CLASS, TrainCount, TestCount, DATA_SIZE);

% Now, run "GaussianMLE.m" or other estimator

