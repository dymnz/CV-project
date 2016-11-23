function [L, g] = gradientDescent(x, oldTheta)
% Gradient Descent using algorithm 9.8
% INPT: x: DxI matrix. The dataset with D dimensions and I samples
%       oldTheta: DxK matrix. The model parameters with D dimensions of K classes
% OUPT: L: scalar. The cost function of Softmax Regression calculated using oldTheta
%       g: DxK matrix. The gradient of parameter matrix



% TODO: Change cost calculation to batch
%       Add weight decay

L = 0;
g = zeros(size(oldTheta));
K = size(oldTheta, 2);

for i = 1 : K
    target = i;
    
    for r = 1 : size(x{i}, 1)
        xi = x{i}(r, :).';
        yi = softmax(xi, oldTheta);
        L = L - log( yi(target) );
        
        for n = 1 : K
            if target == n
                g(:, n) = g(:, n) + (yi(n) - 1)*xi;
            else
                g(:, n) = g(:, n) + yi(n)*xi;
            end            
        end        
    end   
end

end