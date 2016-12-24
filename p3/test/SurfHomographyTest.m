%% Find the homography between two images with SURF and RANSAC
clear; close all;

%% Read and resize the images
disp('Read images...');
Img1 = rgb2gray(imread('./data/cover.jpg'));
Img2 = rgb2gray(imread('./data/b2.jpg'));

Img1 = imresize(Img1, 0.5);
Img2 = imresize(Img2, 0.5);

%% Find matched SURF feature points
disp('Find SURF matching points...');
[T, W] = surfFindMatchPoints(Img1, Img2);

NumOfMPs = size(W, 1);

disp(sprintf('Num of MPs: %d', NumOfMPs));

%% RANSAC
disp('RANSAC...');
HomographyIterations = 300; % # of maximum iterations for non-linear optimization
RANSACiteration = min(max(500, NumOfMPs*10), 1000); % # of maximum iterations for RANSAC
InlierThreshold = 5;    % Thershold for projection error in pixels

maxInliers = zeros(1,1);    % Store the largest set of inliers
maxInlierCount = -1;    % Track the 

for i = 1 : RANSACiteration
% Randomly pick four points
Indices = randperm(NumOfMPs, 4);
WorldCoord = W(Indices, :);
TargetCoord = T(Indices, :);

% Find homography using the four points
phi = findHomography(WorldCoord, TargetCoord, HomographyIterations);
exphi = double(reshape(phi, [3 3]));

% Find point-wise error - psi
exW = [W ones(NumOfMPs, 1)];
exphi = [phi(1:8);1];
denom = exW*exphi(7:9);
x = exW*exphi(1:3)./denom;
y = exW*exphi(4:6)./denom;
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
    
    if double(maxInlierCount)/NumOfMPs >= 0.8
        break;
    end
end

end

%% Wrap up
disp('Find the final homography...');
disp(sprintf('NumOfMPs: %d Inliers: %d', NumOfMPs, maxInlierCount));

% Use the best set of inliers to find homography
WorldCoord = W(maxInleirs, :);
TargetCoord = T(maxInleirs, :);
%%
phi = findHomography(WorldCoord, TargetCoord, HomographyIterations);

exphi = double(reshape(phi, [3 3]));
t = projective2d(exphi);
img= imwarp(Img2,t);
figure; imshow(img);

%% Append Nemo
figure1 = figure;
ax1 = axes('Parent',figure1);
ax2 = axes('Parent',figure1);
set(ax1,'Visible','off');
set(ax2,'Visible','off');
% [a,map,alpha] = imread('./data/nemo.png');
[a,map,alpha] = imread('./data/s2.png');
[a map] = imresize(a, 0.5);
alpha = imresize(alpha, 0.5);

img = Img2;

RNe = imref2d(size(a));
t = projective2d(inv(exphi));
[a RNex] = imwarp(a, RNe, t);
alpha = imwarp(alpha, RNe, t);

xa = uint8(zeros([size(img) 3]));
xa( floor(RNex.YWorldLimits(1)):floor(RNex.YWorldLimits(1)) + size(a, 1) - 1,...
    floor(RNex.XWorldLimits(1)):floor(RNex.XWorldLimits(1)) + size(a, 2) - 1, :)...
    = a;
Rxa = imref2d(size(xa));

xalpha = uint8(zeros(size(img)));
xalpha( floor(RNex.YWorldLimits(1)):floor(RNex.YWorldLimits(1)) + size(a, 1) - 1,...
    floor(RNex.XWorldLimits(1)):floor(RNex.XWorldLimits(1)) + size(a, 2) - 1)...
    = alpha;

I = imshow(xa, 'Parent',ax2);
set(I,'AlphaData',xalpha);
imshow(img, 'Parent',ax1);

%% 

i2 = imresize(imread('./data/a2.jpg'), 0.5);
imx = i2;
radius = 3;
for i = 1 : size(WorldCoord, 1)
    pts = round(WorldCoord(i, :));
    rx = pts(2); cx = pts(1);
    for r = rx-radius : rx+radius
        for c = cx-radius : cx+radius
            imx(r, c, :) = [255 0 0];
        end
    end
end
figure;imshow(imx);
