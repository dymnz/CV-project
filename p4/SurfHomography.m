%% Find the homography between two images with SURF and RANSAC
clear; close all;

%% Read and resize the images
disp('Read images...');
HSVEnable = false;
% Target
ImgT = imread('./data/a3.jpg');
ImgT = Preprocessing(ImgT, HSVEnable);
% Photo
ImgW = imread('./data/a4.jpg');
ImgW = Preprocessing(ImgW, HSVEnable);


%% Find matched SURF feature points
disp('Find SURF matching points...');
[T, W] = surfFindMatchPoints(histeq(rgb2gray(ImgT)), histeq(rgb2gray(ImgW)));

NumOfMPs = size(W, 1);

disp(sprintf('Num of MPs: %d', NumOfMPs));

%% RANSAC
disp('RANSAC...');
HomographyIterations = 300; % # of maximum iterations for non-linear optimization
RANSACiteration = min(max(500, NumOfMPs*10), 1000); % # of maximum iterations for RANSAC
InlierThreshold = 1.0;    % Thershold for projection error in pixels

maxInliers = zeros(1,1);    % Store the largest set of inliers
maxInlierCount = -1;

for i = 1 : RANSACiteration
% Randomly pick four points
Indices = randperm(NumOfMPs, 4);
WorldCoord = W(Indices, :);
TargetCoord = T(Indices, :);

% Find homography using the four points
phi = findHomography(WorldCoord, TargetCoord, HomographyIterations);
H = double(reshape(phi, [3 3]));

% Find point-wise error - psi
exW = [W ones(NumOfMPs, 1)];
H = [phi(1:8);1];
denom = exW*H(7:9);
x = exW*H(1:3)./denom;
y = exW*H(4:6)./denom;
X = [x y];
psi = T - X;

% Find squared root error for each point
sqE = sqrt(psi(:, 1).^2 + psi(:, 2).^2);

% Count the number of inliers
Inliers = find(sqE<InlierThreshold);
InlierCount = numel(Inliers);

% If a better set of inliers is found, store it
if InlierCount > maxInlierCount
	maxInliers = Inliers;
    maxInlierCount = InlierCount;
    disp(sprintf('Itr: %d InlierCount: %d', i, maxInlierCount));
    
    if double(maxInlierCount)/NumOfMPs >= 0.7
        break;
    end
end

end
%% Intensity normalization
WorldCoordInliers = W(maxInliers, :);
TargetCoordInliers = T(maxInliers, :);
normImgW = IntensityNormalizationMulti(ImgT, ImgW, TargetCoordInliers, WorldCoordInliers);

%% Use the best set of inliers to find homography
disp('Find the final homography...');
disp(sprintf('NumOfMPs: %d Inliers: %d', NumOfMPs, maxInlierCount));

WorldCoordInliers = W(maxInliers, :);
TargetCoordInliers = T(maxInliers, :);

phi = findHomography(WorldCoordInliers, TargetCoordInliers, 3000);

% Here it is 
H = double(reshape(phi, [3 3]));

%% Append the pattern onto the image
RNe = imref2d(size(normImgW));
t = projective2d(H);
[transformedImgW RNex] = imwarp(normImgW, RNe, t);
alpha = imwarp(255*ones([size(normImgW, 1) size(normImgW, 2)]), RNe, t);

% Fix axis
if floor(RNex.YWorldLimits(1)) < 0
    coord1Y = max(1, -floor(RNex.YWorldLimits(1)));
    coord2Y = 1;
    Ylim = max(-floor(RNex.YWorldLimits(1))+size(ImgT, 1), ...
        RNex.ImageSize(1));
else 
    coord1Y = 1;
    coord2Y = max(1, floor(RNex.YWorldLimits(1)));    
    Ylim = RNex.ImageSize(1) + floor(RNex.YWorldLimits(1));
end
if floor(RNex.XWorldLimits(1)) < 0
    coord1X = max(1, -floor(RNex.XWorldLimits(1)));
    coord2X = 1;   
    Xlim = max(-floor(RNex.XWorldLimits(1))+size(ImgT, 2), ...
        RNex.ImageSize(2));    
else 
	coord1X = 1;
    coord2X = max(1, floor(RNex.XWorldLimits(1)));   
    Xlim = RNex.ImageSize(2) +  floor(RNex.XWorldLimits(1));  
end
    
% Project images according to the new coordinate    
x2 = uint8(zeros([Ylim Xlim 3]));
x2( ...
	coord2Y:coord2Y + size(transformedImgW, 1) - 1, ...
    coord2X:coord2X + size(transformedImgW, 2) - 1, :)...
    = transformedImgW;

xAlpha = uint8(zeros([Ylim Xlim 1]));
xAlpha(...
	coord2Y:coord2Y + size(transformedImgW, 1) - 1, ...
    coord2X:coord2X + size(transformedImgW, 2) - 1, :)...
    = alpha;

x1 = uint8(zeros([Ylim Xlim 3]));
x1( ...
	coord1Y:coord1Y + size(ImgT, 1) - 1,...
    coord1X:coord1X + size(ImgT, 2) - 1, :)...
    = ImgT;

% Stack the images
image = uint8(zeros([Ylim Xlim 3]));
for i = 1 : 3
     image(:, :, i) = x1(:, :, i).*(1-xAlpha/255) + x2(:, :, i).*(xAlpha/255);
end

figure; imshow(image);
imwrite(image, 'result.jpg');