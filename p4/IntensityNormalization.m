function normImgW = IntensityNormalization(ImgT, ImgW, TargetCoordInliers, WorldCoordInliers)

MaxInlierCount = size(WorldCoordInliers, 1);
PolyRegressionOrder = 3;

HSVImgT = rgb2hsv(ImgT);
HSVImgW = rgb2hsv(ImgW);

Intensity = zeros(MaxInlierCount, 2);   % Intensity of World/Target
for i = 1 : MaxInlierCount
    Wcoord = floor(WorldCoordInliers(i, :));
    Tcoord = floor(TargetCoordInliers(i, :));
    
    for r = 0 : 0
        for c = 0 : 0
            Intensity(i, 1) = Intensity(i, 1) + ...
                HSVImgT(Tcoord(2) + r, Tcoord(1) + c, 3);
            Intensity(i, 2) = Intensity(i, 2) + ...
                HSVImgW(Wcoord(2) + r, Wcoord(1) + c, 3);
        end
    end           
end

TargetInt = Intensity(:, 1);
WorldInt = Intensity(:, 2);
Param = PolynomialRegression(WorldInt, TargetInt, 1, PolyRegressionOrder);
Pred = PolynomialInference(WorldInt, Param, 1, PolyRegressionOrder);

Erms = sqrt( sum((WorldInt-TargetInt).^2)/size(TargetInt, 1) );
disp(sprintf('Original Erms: %.3f', Erms));
Erms = sqrt( sum((Pred-TargetInt).^2)/size(TargetInt, 1) );
disp(sprintf('Order:%d Erms: %.3f', PolyRegressionOrder, Erms));

% close all;
% figure;
% scatter([1:MaxInlierCount], Intensity(:, 1));
% hold on
% scatter([1:MaxInlierCount], Intensity(:, 2));
% hold on
% scatter([1:MaxInlierCount], Pred);


IntTable = unique(HSVImgW(:, :, 3));
IntTarget = PolynomialInference(IntTable, Param, 1, PolyRegressionOrder);
for i = 1 : numel(IntTarget)
    HSVImgW(HSVImgW==IntTable(i)) = IntTarget(i);
end
normImgW = uint8(hsv2rgb(HSVImgW).*255);

end