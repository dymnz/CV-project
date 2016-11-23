function [L, g] = gradientDescent(X, oldTheta)
% Gradient Descent using algorithm 9.8
% INPT: x: DxI matrix. The dataset with D dimensions and I samples
%       oldTheta: DxK matrix. The model parameters with D dimensions of K classes
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
    L = L - sum(log( yi(target, :) ));
    
    for n = 1 : K
        for r = 1 : size(X{i}, 1)
            if target == n
                g(:, n) = g(:, n) + (yi(n, r) - 1)*xi(:, r);
            else
                g(:, n) = g(:, n) + yi(n, r)*xi(:, r);
            end    
        end 
    end        
end

end