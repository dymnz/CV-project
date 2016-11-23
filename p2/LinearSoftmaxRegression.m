% Learning
MAX_ITERATION = 200;
MIN_GRADIENT_DIFF_PERCENTAGE = 0.001;
LAMBDA = 0.0005;
theta = 0.0005 * randn(DIMENSION, MAX_CLASS);

g = 0;
for i = 1 : MAX_ITERATION
    [L, g] = gradientDescent(TrainSet, theta); 
    theta = theta - LAMBDA.*g;
    %disp(mean(mean(abs(g))));
end

disp(sprintf('Iterations: %d Final loss: %.2f', i, L));



