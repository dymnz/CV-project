% This is the bootstrap script for the entire project,
% run this before anything else.

clear; close all;
rng(0,'twister');

% Global constants
MAX_CLASS = 26;         % # of classes
MAX_TRAIN_SIZE = 100;   % Test set size
MAX_TEST_SIZE = 50;     % Test set size
DATA_ROW = 16;          % Data dimension Row
DATA_COLUMN = 8;        % Data dimension Column
DIMENSION = DATA_ROW * DATA_COLUMN;   % Data dimension
NOISE_MAGNITUDE = 0.01;  % The var. of noise to add when reading samples

% Let half of the data be the training set
% The dataset is not uniform, this is the best I can do
TotalSampleCount = [4034 1284 2114 1442 4955 921 2472 861 4913 189 909 3140 1602 5024 3897 1377 341 2673 1394 2136 2562 664 520 413 1221 1094];

% Limit the train set size to min(MAX_TRAIN_SIZE, Half of samples)
TrainCount = min(round(TotalSampleCount./2), MAX_TRAIN_SIZE*ones(size(TotalSampleCount)));
TestCount = TotalSampleCount - TrainCount;

% Limit the test set size to min(MAX_TEST_SIZE, Amount of samples left)
TestCount = min(MAX_TEST_SIZE*ones(size(TotalSampleCount)), TestCount);

% Storage
TrainSet = cell(1, 1);
TestSet = cell(1, 1);

% Read the dataset
[TrainSet, TestSet] = readSets(MAX_CLASS, TrainCount, TestCount, DIMENSION, NOISE_MAGNITUDE);


