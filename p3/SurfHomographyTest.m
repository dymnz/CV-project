%% Find the homography between two images with SURF and RANSAC
clear; close all;

%% Init images
disp('Read images...');
Img1 = rgb2gray(imread('./data/bs2.jpg'));
Img2 = rgb2gray(imread('./data/b1.jpg'));

% Small = Fast
Img1 = imresize(Img1, 0.5);
Img2 = imresize(Img2, 0.5);

%% Find matched SURF feature points
disp('Find SURF matching points...');
[T, W] = surfFindMatchPoints(Img1, Img2);

NumOfMPs = size(W, 1);

disp(sprintf('Num of MPs: %d', NumOfMPs));

%% RANSAC
disp('RANSAC...');
% TODO: Find a better way to set RANSACiteration
% TODO: Find a better InlierThreshold
HomographyIterations = 300;
RANSACiteration = max(500, NumOfMPs*10);
InlierThreshold = 5;

maxInliers = zeros(1,1);
maxInlierCount = 0;
for i = 1 : RANSACiteration
% Randomly pick four points
Indices = randperm(NumOfMPs, 4);
WorldCoord = W(Indices, :);
TargetCoord = T(Indices, :);

% Find homography using the four points
phi = findHomography(WorldCoord, TargetCoord, 4, HomographyIterations);
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
    
    if double(maxInlierCount)/NumOfMPs >= 0.5
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
phi = findHomographyTest(WorldCoord, TargetCoord, maxInlierCount, HomographyIterations);

exphi = double(reshape(phi, [3 3]));
t = projective2d(exphi);
img= imwarp(Img2,t);
figure; imshow(img);
% figure; imshow(Img1);

%%
exphi = double(reshape(phi, [3 3]));
t = projective2d(inv(exphi));
img = imwarp(Img1, t);
figure; imshow(img);
% figure; imshow(Img1);

%% Append Nemo2
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
RImg2 = imref2d(size(Img2));
% t = projective2d(exphi);
% [img, RImg2] = imwarp(Img2, RImg2, t);

RNe = imref2d(size(a));
t = projective2d(inv(exphi));
[a RNex] = imwarp(a, RNe, t);
alpha = imwarp(alpha, RNe, t);

figure; imshow(a, RNex, 'Parent',ax1);
set(I,'AlphaData',alpha);
figure; imshow(img, RImg2, 'Parent',ax2);


%%
xa = uint8(zeros([size(img) 3]));
xa( floor(RNex.YWorldLimits(1)):floor(RNex.YWorldLimits(1)) + size(a, 1) - 1,...
    floor(RNex.XWorldLimits(1)):floor(RNex.XWorldLimits(1)) + size(a, 2) - 1, :)...
    = a;
Rxa = imref2d(size(xa));

xalpha = uint8(zeros(size(img)));
xalpha( floor(RNex.YWorldLimits(1)):floor(RNex.YWorldLimits(1)) + size(a, 1) - 1,...
    floor(RNex.XWorldLimits(1)):floor(RNex.XWorldLimits(1)) + size(a, 2) - 1)...
    = alpha;

% figure; imshow(img, RImg2);
% figure; imshow(xa, Rxa);
I = imshow(xa, 'Parent',ax2);
set(I,'AlphaData',xalpha);
imshow(img, 'Parent',ax1);


% imwrite(a, './result2.png');
% imwrite(img, './result1.png');


%% 
