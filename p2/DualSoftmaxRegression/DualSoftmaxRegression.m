% Dual Softmax Regression Learning

MAX_ITERATION = 2000;	% Stop the iteration when this is reached
LEARNING_RATE = 0.002;	% Learning rate
psi = cell(1, MAX_CLASS);   % 1xK Ix1	The psi for K class, each with I samples 

% Initialize the psi with random number
for i = 1 : MAX_CLASS
    psi{i} = 0.005 * randn(TrainCounts(i), 1);
end

% Gradient Descent process
for i = 1 : MAX_ITERATION

	% Gradient Descent, get the Loss and Gradient
    [L, g] = gradientDescent(TrainSet, psi); 
	
	% Update psi
    for r = 1 : MAX_CLASS
        psi{r} = psi{r} - LEARNING_RATE.*g{r}./TrainCount;
    end    
    disp(sprintf('%d %.3f', i, L/TrainCount));    
end

disp(sprintf('Iterations: %d Final loss: %.2f', i, L/TrainCount));




