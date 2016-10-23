%% Set global constants and read training/testing data set%%
% The samples are in 16x8 binary image
% For each sample, there is a class(a-z) and a cross-validation label(cvLabel)

clear; close all;
rng(0,'twister');
%% Global constants
MAX_CLASS = 26;         % # of classes
MAX_TRAIN_SIZE = 100;   % Train set size
MAX_TEST_SIZE = 20;     % Test set size
DATA_ROW = 16;          % Data dimension Row
DATA_COLUMN = 8;        % Data dimension Column
DATA_SIZE = DATA_ROW * DATA_COLUMN;   % Data dimension
cvLabelForTrain = [1, 2, 3, 4, 5, 6, 7];   % cvLabel for training
cvLabelForTest = [8, 9, 0];                % cvLabel for testing

%% Read the training set
[trainSetData, trainSetSize] = readSet (MAX_CLASS, MAX_TRAIN_SIZE, cvLabelForTrain, DATA_ROW, DATA_COLUMN);

%% Read the testing set
[testSetData, testSetSize] = readSet (MAX_CLASS, MAX_TEST_SIZE, cvLabelForTest, DATA_ROW, DATA_COLUMN);

