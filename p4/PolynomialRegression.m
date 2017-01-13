function W = PolynomialRegression(X, T, Dimension, Order)


%% Constants and data reading %%
cTrainSetSize = size(X, 1);
cDimension = Dimension;
cOrder = Order;
TrainX = X;
TrainT = T;

%% 2/3nd order linear regression by partial derivation %%
%% Build the Normal Equation: AW = Y 
cOrder = min(cOrder, 3);
if cDimension > 1
    S = (1 - cDimension^(cOrder+1))/(1 - cDimension);
else 
    S = Order + 1;
end

W = zeros(S);
Y = zeros(length(W), 1);
A = zeros(length(W), length(W));

% Build the Weight from partial derivative
% If I had more time, I would have written a shorter code
Weight = ones(cTrainSetSize, 1);
for i = 1 : cDimension
    Weight = cat(2, Weight, TrainX(:, i));
end
if cOrder > 1
for i = 1 : cDimension
    for r = 1 : cDimension
        Weight = cat(2, Weight, TrainX(:, i).*TrainX(:, r));
    end
end
end
if cOrder > 2
for i = 1 : cDimension
    for r = 1 : cDimension
        for p = 1 : cDimension
        Weight = cat(2, Weight, TrainX(:, i).*TrainX(:, r).*TrainX(:, p));
        end
    end
end
end

% Build the A and Y matrix
for i = 1 : length(W)
        A(i, :) = sum(Weight.*repmat(Weight(:, i), 1, S));
        Y(i) = sum(TrainT.*Weight(:, i));
end

%% Find W using W = pinv(A)Y
% W = A\Y;
W = pinv(A)*Y;

end
