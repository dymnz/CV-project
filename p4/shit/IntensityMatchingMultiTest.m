function normImgW = IntensityMatchingMultiTest(ImgT, ImgW, TargetCoordInliers, WorldCoordInliers)

MaxInlierCount = size(WorldCoordInliers, 1);
PolyRegressionOrder = 3;
Neighbors = 1;
BlockSize = (Neighbors*2+1)^2;
MidGain = 4;
HSVImgT = rgb2hsv(ImgT);
HSVImgW = rgb2hsv(ImgW);


TargetInt = zeros(MaxInlierCount, 1);
WorldInt = zeros(MaxInlierCount, 1);
for i = 1 : MaxInlierCount
    Wcoord = floor(WorldCoordInliers(i, :));
    Tcoord = floor(TargetCoordInliers(i, :));
    for r = -Neighbors : Neighbors
        for c = -Neighbors : Neighbors
            if r == 0 && c == 0
                k = MidGain;
            else
                k = 1;
            end
            TargetInt(i) = TargetInt(i) + ...
                k*HSVImgT(Tcoord(2) + r, Tcoord(1) + c, 3);
            WorldInt(i) = WorldInt(i) + ...
                k*HSVImgW(Wcoord(2) + r, Wcoord(1) + c, 3);
        end
    end           
end
TargetInt = TargetInt./(BlockSize-1+MidGain);
WorldInt = WorldInt./(BlockSize-1+MidGain);

Param = PolynomialRegression(WorldInt, TargetInt, 1, PolyRegressionOrder);
Pred = PolynomialInference(WorldInt, Param, 1, PolyRegressionOrder);

Erms = sqrt( sum((WorldInt-TargetInt).^2)/size(TargetInt, 1) );
disp(sprintf('Original Erms: %.3f', Erms));
Erms = sqrt( sum((Pred-TargetInt).^2)/size(TargetInt, 1) );
disp(sprintf('Order:%d Erms: %.3f', PolyRegressionOrder, Erms));

IntTable = unique(HSVImgW(:, :, 3));
IntTarget = PolynomialInference(IntTable, Param, 1, PolyRegressionOrder);
IntTarget(IntTarget>1) = 1; IntTarget(IntTarget<0) = 0;
for i = 1 : numel(IntTarget)
    HSVImgW(HSVImgW==IntTable(i)) = IntTarget(i);
end
normImgW = uint8(hsv2rgb(HSVImgW).*255);


% close all;
% figure;
% scatter([1:MaxInlierCount], TargetInt(:));
% hold on
% scatter([1:MaxInlierCount], WorldInt(:));
% hold on
% scatter([1:MaxInlierCount], Pred);
% legend('Target', 'Current', 'Inferred');
% xlabel('Sample #'); ylabel('Intensity');
% title('Intensity at different pixel');

% close all;
% figure;
% scatter([1:MaxInlierCount], TargetInt(:));
% hold on
% scatter([1:MaxInlierCount], Pred);
% legend('Target', 'Inferred');
% xlabel('Sample #'); ylabel('Intensity');
% title('Intensity at different pixel');
% 
% figure;
% scatter([1:MaxInlierCount], TargetInt(:));
% hold on
% scatter([1:MaxInlierCount], WorldInt(:));
% legend('Target', 'Current');
% xlabel('Sample #'); ylabel('Intensity');
% title('Intensity at different pixel');

Param = PolynomialRegression(WorldInt, TargetInt, 1, 1);
Pred = PolynomialInference(WorldInt, Param, 1, 1);
figure;
scatter([1:MaxInlierCount], TargetInt(:));
hold on
scatter([1:MaxInlierCount], Pred);
legend('Target', 'Inferred');
xlabel('Sample #'); ylabel('Intensity');
title('Intensity Inference - Order:1');

Param = PolynomialRegression(WorldInt, TargetInt, 1, 2);
Pred = PolynomialInference(WorldInt, Param, 1, 2);
figure;
scatter([1:MaxInlierCount], TargetInt(:));
hold on
scatter([1:MaxInlierCount], Pred);
legend('Target', 'Inferred');
xlabel('Sample #'); ylabel('Intensity');
title('Intensity Inference - Order:2');

Param = PolynomialRegression(WorldInt, TargetInt, 1, 3);
Pred = PolynomialInference(WorldInt, Param, 1, 3);
figure;
scatter([1:MaxInlierCount], TargetInt(:));
hold on
scatter([1:MaxInlierCount], Pred);
legend('Target', 'Inferred');
xlabel('Sample #'); ylabel('Intensity');
title('Intensity Inference - Order:3');


range = [0:0.005:1]';
Param = PolynomialRegression(WorldInt, TargetInt, 1, 1);
predR = PolynomialInference(range, Param, 1, 1);
predR(predR>1) = 1; predR(predR<0) = 0;
figure; plot(range, predR);
hold on;
plot(range, range);
axis([0 1 0 1]);
legend('Inferred', 'Reference');
xlabel('Original Intensity'); ylabel('Mapped Intensity');
title('Intensity Mapping - Order:1');

Param = PolynomialRegression(WorldInt, TargetInt, 1, 2);
predR = PolynomialInference(range, Param, 1, 2);
predR(predR>1) = 1; predR(predR<0) = 0;
figure; plot(range, predR);
hold on;
plot(range, range);
axis([0 1 0 1]);
legend('Inferred', 'Reference');
xlabel('Original Intensity'); ylabel('Mapped Intensity');
title('Intensity Mapping - Order:2');

Param = PolynomialRegression(WorldInt, TargetInt, 1, 3);
predR = PolynomialInference(range, Param, 1, 3);
predR(predR>1) = 1; predR(predR<0) = 0;
figure; plot(range, predR);
hold on;
plot(range, range);
axis([0 1 0 1]);
legend('Inferred', 'Reference');
xlabel('Original Intensity'); ylabel('Mapped Intensity');
title('Intensity Mapping - Order:3');



end