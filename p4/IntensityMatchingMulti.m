function normImgW = IntensityMatchingMulti(ImgT, ImgW, TargetCoordInliers, WorldCoordInliers)
% Find the modified ImgW that has the brightness matched with ImgT using
% given matched points
% INPT: ImgT: The image that has the targeted brightness.
%       ImgW: The image that we wish to modify for the matching.
%       TargetCoordInliers: Nx2 matrix. The [x y] coordinates of ImgT's
%       matched points.
%       WorldCoordInliers: Nx2 matrix. The [x y] coordinates of ImgW's
%       matched points.
% OUPT: normImgW: Modified ImgW that has the brightness matched with ImgT

%% Constants
MaxInlierCount = size(WorldCoordInliers, 1);    % # of the MPs
PolyRegressionOrder = 2;    % Order of Polynomial Regression (1~3)
Neighbors = 1;              % The # of neighbors to consider for brightness counting
BlockSize = (Neighbors*2+1)^2;  % The size of the region considered for brightness counting
MidGain = 4;                % The weight for the inlier itself

%% Brightness value counting
% Use HSV images so that the brightness can be seperated
HSVImgT = rgb2hsv(ImgT);
HSVImgW = rgb2hsv(ImgW);

% Count the brightness of a region centered by given MPs
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

% Normalize according to the size of considered region and the weight of the
% inlier itself
TargetInt = TargetInt./(BlockSize-1+MidGain);
WorldInt = WorldInt./(BlockSize-1+MidGain);

%% DEBUG ONLY - Show the RMS error of brightness after adjustment
% Learning 
Param = PolynomialRegression(WorldInt, TargetInt, 1, PolyRegressionOrder);
% Inference
Pred = PolynomialInference(WorldInt, Param, 1, PolyRegressionOrder);

Erms = sqrt( sum((WorldInt-TargetInt).^2)/size(TargetInt, 1) );
disp(sprintf('Original Erms: %.3f', Erms));
Erms = sqrt( sum((Pred-TargetInt).^2)/size(TargetInt, 1) );
disp(sprintf('Order:%d Erms: %.3f', PolyRegressionOrder, Erms));

%% Construct brightness mapping
% Only consider the unique brightness values in ImgW
IntTable = unique(HSVImgW(:, :, 3));

% Find the mapping
IntTarget = PolynomialInference(IntTable, Param, 1, PolyRegressionOrder);

% Sometimes the value exceeds the boundary [0 1]
IntTarget(IntTarget>1) = 1; IntTarget(IntTarget<0) = 0;

%% Adjust the brightness and return the brightness matched image
for i = 1 : numel(IntTarget)
    HSVImgW(HSVImgW==IntTable(i)) = IntTarget(i);
end
normImgW = uint8(hsv2rgb(HSVImgW).*255);

end