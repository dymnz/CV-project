% Learning

MAX_ITERATION = 200;
MIN_GRADIENT_DIFF_PERCENTAGE = 0.001;
LAMBDA = 0.0005;
theta = 0.005 * randn(DIMENSION, MAX_CLASS);

lastG = 0;
g = 0;
for i = 1 : MAX_ITERATION
%     lastG = g;    
    [L, g] = gradientDescent(TrainSet, theta); 
%     if  sum(sum(abs(lastG - g)))/sum(sum(abs(g))) < MIN_GRADIENT_DIFF_PERCENTAGE
%         break;
%     end
    theta = theta - LAMBDA.*g;
end
disp(i);
disp(L);



