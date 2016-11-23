% Learning

MAX_ITERATION = 200;
MIN_GRADIENT_DIFF_PERCENTAGE = 0.001;
LAMBDA = 0.0005;
theta = 0.005 * randn(DIMENSION, MAX_CLASS);

lastG = 0;
g = 0;
for i = 1 : MAX_ITERATION
    [L, g] = gradientDescent(TrainSet, theta); 
    theta = theta - LAMBDA.*g;
end

disp(sprintf('Iterations: %d \t Final cost: %.2f', i, L));




