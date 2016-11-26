function [L, g] = gradientDescentWD(X, Theta, WD)
% Batch Gradient Descent with Weight Decay
% INPT: x: DxI matrix. The dataset with D dimensions and I samples
%       Theta: DxK matrix. The model parameters with D dimensions of K classes
%       WD: Scalar. The weight of Weight Decay term
% OUPT: L: scalar. The cost function of Softmax Regression calculated using Theta
%       g: DxK matrix. The gradient of parameter matrix

L = 0;  % Loss
g = zeros(size(Theta)); % Gradient matrix, matches the size of Theta
K = size(Theta, 2);	% # of Class


% For each class in training set
for i = 1 : K
    target = i;	% The target of this subset
        
    xi = X{i}.';	% The samples of this subset
	
	% Softmax function, the reuslt is KxI
    yi = softmax(xi, oldTheta);
	
	% Update the loss
    L = L - (sum(log( yi(target, :) )) + WD*(sum(sum(oldTheta.^2))));
    
    % Update the graident
    for n = 1 : K
        for r = 1 : size(X{i}, 1)
            if target == n
                g(:, n) = g(:, n) + (yi(n, r) - 1)*xi(:, r) + WD*oldTheta(:, n);
            else
                g(:, n) = g(:, n) + yi(n, r)*xi(:, r) + WD*oldTheta(:, n);
            end    
        end 
    end
end

end