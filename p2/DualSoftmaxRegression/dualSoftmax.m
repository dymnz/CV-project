function Y = dualSoftmax(X, Psi, x)
% Softmax function with Dual Activation
% INPT: X: 1xKxIxD matrix. The training dataset with D dimensions and I samples
% 		Psi: 1xKxIx1 matrix. The psi for K class, each with I samples 
%       x: DxI matrix. The testing dataset with D dimensions and I samples
% OUPT: Y: KxI matrix. The result of Softmax with K classes and I samples

K = size(Psi, 2);
I = size(x, 2);

weights = zeros(K, I); % KxI
powers = zeros(K, I);
for i = 1 : K
    % 1xI * IxD * DxI = 1xI
    powers(i, :) = Psi{i}' * X{i} * x;    
end
weights = exp(powers);
Y = weights ./ repmat(sum(weights), K, 1);

end