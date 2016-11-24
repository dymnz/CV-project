% Learning
MAX_ITERATION = 200;
MIN_GRADIENT_DIFF_PERCENTAGE = 0.001;
LEARNING_RATE = 0.0005;
WEIGHT_DECAY  = 0.0000;
theta = 0.0005 * randn(DIMENSION + 1, MAX_CLASS);

g = 0;
for i = 1 : MAX_ITERATION
    [L, g] = gradientDescentWD(TrainSet, theta, WEIGHT_DECAY); 
    theta = theta - LEARNING_RATE.*g;
    %disp(mean(mean(abs(g))));
end

disp(sprintf('Iterations: %d Final loss: %.2f', i, L));




