function [L, g] = gradientDescentWD(X, oldTheta, WD)
% Gradient Descent with Weight Decay
% INPT: x: DxI matrix. The dataset with D dimensions and I samples
%       oldTheta: DxK matrix. The model parameters with D dimensions of K classes
%       WD: Scalar. The weight of Weight Decay term
% OUPT: L: scalar. The cost function of Softmax Regression calculated using oldTheta
%       g: DxK matrix. The gradient of parameter matrix

% TODO: Add weight decay

L = 0;
g = zeros(size(oldTheta));
K = size(oldTheta, 2);

for i = 1 : K
    target = i;
        
    xi = X{i}.';
    yi = softmax(xi, oldTheta);
    L = L - (sum(log( yi(target, :) )) + WD*(sum(sum(oldTheta.^2))));
    
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