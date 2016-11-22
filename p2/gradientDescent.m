function [L, g] = gradientDescent(x, oldTheta)

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