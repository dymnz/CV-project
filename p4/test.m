IntDef = Intensity(:, 1)-Intensity(:, 2);
TargetInt = Intensity(:, 1);
WorldInt = Intensity(:, 2);

color = hsv(3);
figure;
scatter([1:maxInlierCount], Intensity(:, 1), 20, color(1, :));
hold on
scatter([1:maxInlierCount], Intensity(:, 2), 20, color(2, :));
hold on
Param = PolynomialRegression(WorldInt, TargetInt, 1, 1);
Pred = PolynomialInference(WorldInt, Param, 1, 1);
scatter([1:maxInlierCount], Pred, 20, color(3, :));

Erms = sqrt( sum((WorldInt-TargetInt).^2)/size(TargetInt, 1) );
disp(sprintf('Original Erms: %.3f', Erms));
for i = 1 : 3
    Param = PolynomialRegression(WorldInt, TargetInt, 1, i);
    Pred = PolynomialInference(WorldInt, Param, 1, i);
    Erms = sqrt( sum((Pred-TargetInt).^2)/size(TargetInt, 1) );
    disp(sprintf('Order:%d Erms: %.3f', i, Erms));
end

IntTable = unique(HSVImg2(:, :, 3));
IntTarget = PolynomialInference(IntTable, Param, 1, 3);
for i = 1 : numel(IntTarget)
    HSVImg2(HSVImg2==IntTable(i)) = IntTarget(i);
end