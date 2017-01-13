function Predictions = PolynomialInference(X, W, Dimension, Order)

cTestSetSize = size(X, 1);
cDimension = Dimension;
cOrder = Order;
TestX = X;

% Construct X for test set
X = ones(cTestSetSize, 1);
for i = 1 : cDimension
    X = cat(2, X, TestX(:, i));
end
if cOrder > 1
for i = 1 : cDimension
    for r = 1 : cDimension
        X = cat(2, X, TestX(:, i).*TestX(:, r));
    end
end
end
if cOrder > 2
for i = 1 : cDimension
    for r = 1 : cDimension
        for p = 1 : cDimension
        X = cat(2, X, TestX(:, i).*TestX(:, r).*TestX(:, p));
        end
    end
end
end

% Predict
Predictions = X*W;
