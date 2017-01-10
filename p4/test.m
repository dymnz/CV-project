%% Find the homography between two images with SURF and RANSAC
clear; close all;

%% Read and resize the images
disp('Read images...');

% Target
Img1 = imread('./data/a1.jpg');
Img1 = imresize(Img1, [NaN 1280]);
% Photo
Img2 = imread('./data/a2.jpg');
Img2 = imresize(Img2, [NaN 1280]);

%% Find matched SURF feature points
disp('Find SURF matching points...');
[T, W] = surfFindMatchPoints(histeq(rgb2gray(Img1)), histeq(rgb2gray(Img2)));

NumOfMPs = size(W, 1);

disp(sprintf('Num of MPs: %d', NumOfMPs));

%% RANSAC
disp('RANSAC...');
HomographyIterations = 500; % # of maximum iterations for non-linear optimization
RANSACiteration = min(max(500, NumOfMPs*10), 1000); % # of maximum iterations for RANSAC
InlierThreshold = 1.0;    % Thershold for projection error in pixels

maxInliers = zeros(1,1);    % Store the largest set of inliers
maxInlierCount = -1;

%% Normalize the coordinates
% MaxValue = max(max(max(W)), max(max(T)));
% W = W./MaxValue;
% T = T./MaxValue;
% InlierThreshold = InlierThreshold/MaxValue;

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
	maxInleirs = Inliers;
    maxInlierCount = InlierCount;
    disp(sprintf('Itr: %d InlierCount: %d', i, maxInlierCount));
    
    if double(maxInlierCount)/NumOfMPs >= 0.7
        break;
    end
end

end

%% Use the best set of inliers to find homography
disp('Find the final homography...');
disp(sprintf('NumOfMPs: %d Inliers: %d', NumOfMPs, maxInlierCount));

WorldCoord = W(maxInleirs, :);
TargetCoord = T(maxInleirs, :);
% WorldCoord = W(maxInleirs, :).*MaxValue;
% TargetCoord = T(maxInleirs, :).*MaxValue;

phi = findHomography(WorldCoord, TargetCoord, 3000);

% Here it is 
H = double(reshape(phi, [3 3]));

%% Append the pattern onto the image
RNe = imref2d(size(Img2));
t = projective2d(H);
[transformedImg2 RNex] = imwarp(Img2, RNe, t);
alpha = imwarp(255*ones([size(Img2, 1) size(Img2, 2)]), RNe, t);

% Fix axis
if floor(RNex.YWorldLimits(1)) < 0
    coord1Y = -floor(RNex.YWorldLimits(1));
    coord2Y = 1;
    Ylim = max(-floor(RNex.YWorldLimits(1))+size(Img1, 1), ...
        RNex.ImageSize(1));
else 
    coord1Y = 1;
    coord2Y = floor(RNex.YWorldLimits(1));    
    Ylim = RNex.ImageSize(1) + floor(RNex.YWorldLimits(1));
end
if floor(RNex.XWorldLimits(1)) < 0
    coord1X = -floor(RNex.XWorldLimits(1));
    coord2X = 1;   
    Xlim = max(-floor(RNex.XWorldLimits(1))+size(Img1, 2), ...
        RNex.ImageSize(2));    
else 
	coord1X = 1;
    coord2X = floor(RNex.XWorldLimits(1));   
    Xlim = RNex.ImageSize(2) +  floor(RNex.XWorldLimits(1));  
end
    
     
x2 = uint8(zeros([Ylim Xlim 3]));
x2( ...
	coord2Y:coord2Y + size(transformedImg2, 1) - 1, ...
    coord2X:coord2X + size(transformedImg2, 2) - 1, :)...
    = transformedImg2;

xAlpha = uint8(zeros([Ylim Xlim 1]));
xAlpha(...
	coord2Y:coord2Y + size(transformedImg2, 1) - 1, ...
    coord2X:coord2X + size(transformedImg2, 2) - 1, :)...
    = alpha;

x1 = uint8(zeros([Ylim Xlim 3]));
x1( ...
	coord1Y:coord1Y + size(Img1, 1) - 1,...
    coord1X:coord1X + size(Img1, 2) - 1, :)...
    = Img1;


image = uint8(zeros([Ylim Xlim 3]));
for i = 1 : 3
     image(:, :, i) = x1(:, :, i).*(1-xAlpha/255) + x2(:, :, i).*(xAlpha/255);
end

figure; imshow(image);
imwrite(image, 'result.jpg');