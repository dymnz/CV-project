function Y = softmax(X, theta)
% Softmax function
% INPT: X: DxI matrix. The dataset with D dimensions and I samples
% 		theta: DxK matrix. The model parameters with D dimensions of K classes
% OUPT: Y: KxI matrix. The result of Softmax with K classes and I samples

weight = exp(theta.' * X);
Y = weight / sum(weight);

end