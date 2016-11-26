function Y = softmax(X, Theta)
% Softmax function
% INPT: X: DxI matrix. The dataset with D dimensions and I samples
% 		theta: DxK matrix. The model parameters with D dimensions of K classes
% OUPT: Y: KxI matrix. The result of Softmax with K classes and I samples

K = size(Theta, 2); % # of Class

weight = exp(Theta.' * X);
Y = weight ./ repmat(sum(weight), K, 1);

end