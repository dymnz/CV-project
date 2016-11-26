function [L, g] = gradientDescent(X, psi)
% Gradient Descent using algorithm 9.8
% INPT: X: DxI matrix. The dataset with D dimensions and I samples
%       psi: 1xKxIx1 matrix. The psi for K class, each with I samples 
% OUPT: L: scalar. The cost function of Softmax Regression calculated using psi
%       g: DxK matrix. The gradient of parameter matrix

K = size(psi, 2);

L = 0;	% Loss
g = cell(1, size(psi, 2));  % Gradient matrix, matches the size of psi
% Initialize the gradient
for i = 1 : size(psi, 2)
    g{i} = zeros(size(psi{i}));
end

% For each class in training set
for i = 1 : K
    target = i;	% The target of this subset
        
    xi = X{i}.';	% The samples of this subset
	
	% Dual Softmax function, the reuslt is KxI
    yi = dualSoftmax(X, psi, xi);  
	
	% Update the loss
    L = L - sum(log(yi(target, :)));
    
	% Update the graident
    for n = 1 : K
        for r = 1 : size(X{i}, 1)
            if target == n               
                g{n} = g{n} + (yi(n, r) - 1)*X{n}*xi(:, r);
            else              
                g{n} = g{n} + yi(n, r)*X{n}*xi(:, r);
            end
        end 
    end
end
    
end