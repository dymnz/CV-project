% Linear Softmax Regression

MAX_ITERATION = 200;	% Stop the iteration when this is reached
LEARNING_RATE = 1;		% Learning rate
WEIGHT_DECAY  = 0.0000;	% Weight decay parameter

% DxK model parameter, +1 for bias. Randomly intialized
theta = 0.0005 * randn(DIMENSION + 1, MAX_CLASS);	

% Train until maximum iterations is reached
% Can be modified to stop when gradient change and avg. loss is small
for i = 1 : MAX_ITERATION

	% Gradient Descent, get the Loss and Gradient
    [L, g] = gradientDescentWD(TrainSet, theta, WEIGHT_DECAY); 
	
	% Update theta
    theta = theta - LEARNING_RATE.*g./TrainCount;
    disp(L/TrainCount);
end

disp(sprintf('Iterations: %d Final loss: %.2f', i, L/TrainCount));




